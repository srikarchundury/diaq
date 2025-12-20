#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x) {
    std::shared_ptr<vector> y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spMV(A, x, y);
    return y;
}
std::shared_ptr<vector> spMV_ntimes(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, int n) {
    std::shared_ptr<vector> y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spMV_ntimes(A, x, y, n);
    return y;
}

// Simple task struct for 2D blocking over diagonals and element ranges
struct SpmvTask {
    size_t        diagIndex;
    unsigned int  start;   // inclusive
    unsigned int  end;     // exclusive
};

void spMV(std::shared_ptr<diaQMatrix> A,
          std::shared_ptr<vector> x,
          std::shared_ptr<vector> y) {

    #ifdef CUDA_ENABLED

        {
            std::shared_ptr<vector> tmp = spmv_cuda(A, x);
            if (tmp) {
                unsigned int M = y->num_rows();
                #pragma omp parallel for
                for (unsigned int i = 0; i < M; ++i) {
                    y->realValues[i] = tmp->realValues[i];
                    y->imagValues[i] = tmp->imagValues[i];
                }
            }
            return;
        }

    #else

        #ifdef DEEP_DEBUG
            std::cout << " --- spMV --- " << std::endl;
            A->print();
            x->print();
            A->print_meta();
            x->print_meta();
            y->print_meta();
        #endif

        #ifdef DEBUG
            printf("starting <spMV_blocked> --- ");
            std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
        #endif

        valType *x_real_values = x->realValues;
        valType *x_imag_values = x->imagValues;

        size_t total_diagonals = A->dIndices.size();
        size_t N               = y->numRows;

        if (total_diagonals == 0 || N == 0) {
            return;
        }

        // -------------------- Build 2D block tasks --------------------
        // Each task: (diag index, [start, end) over diagonal elements).
        // We now tile the FULL diagonal length; kernels handle partial SIMD via masks.
        const unsigned int TILE_LEN = BLOCK_SIZE; // BLOCK_SIZE should be multiple of VEC_WIDTH.

        std::vector<SpmvTask> tasks;
        tasks.reserve(total_diagonals * 4); // heuristic

        for (size_t a = 0; a < total_diagonals; ++a) {
            int dIndex             = A->dIndices[a];
            unsigned int dLength   = A->getDiagonalLengthInternal(dIndex);

            if (dLength == 0) {
                continue;
            }

            unsigned int tile_start = 0;
            while (tile_start < dLength) {
                unsigned int tile_end = tile_start + TILE_LEN;
                if (tile_end > dLength) {
                    tile_end = dLength;
                }

                SpmvTask task;
                task.diagIndex = a;
                task.start     = tile_start;
                task.end       = tile_end;
                tasks.push_back(task);

                tile_start = tile_end;
            }
        }

        // If no tasks, just do scalar fallback
        if (tasks.empty()) {
            for (size_t a = 0; a < total_diagonals; ++a) {
                int dIndex           = A->dIndices[a];
                unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
                unsigned int offset  = A->diagOffsets[a];
                valType *real_vals   = A->realData + offset;
                valType *imag_vals   = A->imagData + offset;

                if (dIndex < 0) {
                    for (unsigned int i = 0; i < dLength; ++i) {
                        unsigned int x_idx = i;
                        unsigned int y_idx = i - dIndex;
                        y->realValues[y_idx] += real_vals[i] * x_real_values[x_idx] -
                                                imag_vals[i] * x_imag_values[x_idx];
                        y->imagValues[y_idx] += real_vals[i] * x_imag_values[x_idx] +
                                                imag_vals[i] * x_real_values[x_idx];
                    }
                } else if (dIndex > 0) {
                    for (unsigned int i = 0; i < dLength; ++i) {
                        unsigned int x_idx = dIndex + i;
                        unsigned int y_idx = i;
                        y->realValues[y_idx] += real_vals[i] * x_real_values[x_idx] -
                                                imag_vals[i] * x_imag_values[x_idx];
                        y->imagValues[y_idx] += real_vals[i] * x_imag_values[x_idx] +
                                                imag_vals[i] * x_real_values[x_idx];
                    }
                } else {
                    for (unsigned int i = 0; i < dLength; ++i) {
                        y->realValues[i] += real_vals[i] * x_real_values[i] -
                                            imag_vals[i] * x_imag_values[i];
                        y->imagValues[i] += real_vals[i] * x_imag_values[i] +
                                            imag_vals[i] * x_real_values[i];
                    }
                }
            }

            #ifdef DEBUG
                auto end_time_scalar = std::chrono::high_resolution_clock::now();
                auto duration_scalar = std::chrono::duration_cast<std::chrono::microseconds>(end_time_scalar - start_time);
                printf("spMV_blocked (scalar-only) took %.3f ms\n", duration_scalar.count() / 1000.0);
            #endif
            return;
        }

        // -------------------- Thread-local y buffers --------------------
        int num_threads = omp_get_max_threads();

        std::vector<std::shared_ptr<vector>> y_locals(num_threads);
        for (int t = 0; t < num_threads; ++t) {
            // fresh zero vector – we don't need initial y values
            y_locals[t] = std::make_shared<vector>(N, (valType)0.0, (valType)0.0);
        }

        // -------------------- Parallel 2D blocked SIMD over tasks --------------------
        #pragma omp parallel num_threads(num_threads)
        {
            int tid = omp_get_thread_num();
            valType *y_real_values = y_locals[tid]->realValues;
            valType *y_imag_values = y_locals[tid]->imagValues;

            #pragma omp for schedule(static)
            for (size_t ti = 0; ti < tasks.size(); ++ti) {
                SpmvTask task        = tasks[ti];
                size_t a             = task.diagIndex;
                unsigned int start_i = task.start;
                unsigned int end_i   = task.end;

                int dIndex           = A->dIndices[a];
                unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
                unsigned int offset  = A->diagOffsets[a];
                valType *real_vals   = A->realData + offset;
                valType *imag_vals   = A->imagData + offset;

                // Clamp just in case
                if (end_i > dLength)   end_i   = dLength;
                if (start_i >= end_i)  continue;

                // Choose kernel based on diagonal index sign and VEC_TYPE
                if (dIndex < 0) {
                #if VEC_TYPE == 2
                    run_spmv_avx512_1(start_i, end_i,
                                    x_real_values, x_imag_values,
                                    real_vals, imag_vals,
                                    y_real_values, y_imag_values,
                                    dIndex, dLength);
                #elif VEC_TYPE == 1
                    run_spmv_avx_1(start_i, end_i,
                                x_real_values, x_imag_values,
                                real_vals, imag_vals,
                                y_real_values, y_imag_values,
                                dIndex, dLength);
                #elif VEC_TYPE == 0
                    run_spmv_sse_1(x_real_values, x_imag_values,
                                real_vals, imag_vals,
                                y_real_values, y_imag_values,
                                dIndex, dLength);
                #elif VEC_TYPE == 3
                    run_spmv_mac_1(start_i, end_i,
                                x_real_values, x_imag_values,
                                real_vals, imag_vals,
                                y_real_values, y_imag_values,
                                dIndex, dLength);
                #else
                    // Pure scalar in this build
                    for (unsigned int i = start_i; i < end_i; ++i) {
                        unsigned int x_idx = i;
                        unsigned int y_idx = i - dIndex;
                        y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] -
                                                imag_vals[i] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] +
                                                imag_vals[i] * x_real_values[x_idx];
                    }
                #endif
                }
                else if (dIndex > 0) {
                #if VEC_TYPE == 2
                    run_spmv_avx512_2(start_i, end_i,
                                    x_real_values, x_imag_values,
                                    real_vals, imag_vals,
                                    y_real_values, y_imag_values,
                                    dIndex, dLength);
                #elif VEC_TYPE == 1
                    run_spmv_avx_2(start_i, end_i,
                                x_real_values, x_imag_values,
                                real_vals, imag_vals,
                                y_real_values, y_imag_values,
                                dIndex, dLength);
                #elif VEC_TYPE == 0
                    run_spmv_sse_2(x_real_values, x_imag_values,
                                real_vals, imag_vals,
                                y_real_values, y_imag_values,
                                dIndex, dLength);
                #elif VEC_TYPE == 3
                    run_spmv_mac_2(start_i, end_i,
                                x_real_values, x_imag_values,
                                real_vals, imag_vals,
                                y_real_values, y_imag_values,
                                dIndex, dLength);
                #else
                    for (unsigned int i = start_i; i < end_i; ++i) {
                        unsigned int x_idx = dIndex + i;
                        unsigned int y_idx = i;
                        y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] -
                                                imag_vals[i] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] +
                                                imag_vals[i] * x_real_values[x_idx];
                    }
                #endif
                }
                else {
                #if VEC_TYPE == 2
                    run_spmv_avx512_0(start_i, end_i,
                                    x_real_values, x_imag_values,
                                    real_vals, imag_vals,
                                    y_real_values, y_imag_values,
                                    dIndex, dLength);
                #elif VEC_TYPE == 1
                    run_spmv_avx_0(start_i, end_i,
                                x_real_values, x_imag_values,
                                real_vals, imag_vals,
                                y_real_values, y_imag_values,
                                dIndex, dLength);
                #elif VEC_TYPE == 0
                    run_spmv_sse_0(x_real_values, x_imag_values,
                                real_vals, imag_vals,
                                y_real_values, y_imag_values,
                                dIndex, dLength);
                #elif VEC_TYPE == 3
                    run_spmv_mac_0(start_i, end_i,
                                x_real_values, x_imag_values,
                                real_vals, imag_vals,
                                y_real_values, y_imag_values,
                                dIndex, dLength);
                #else
                    for (unsigned int i = start_i; i < end_i; ++i) {
                        y_real_values[i] += real_vals[i] * x_real_values[i] -
                                            imag_vals[i] * x_imag_values[i];
                        y_imag_values[i] += real_vals[i] * x_imag_values[i] +
                                            imag_vals[i] * x_real_values[i];
                    }
                #endif
                }
            } // tasks loop
        } // parallel region

        // -------------------- Final merge of y_locals into y --------------------
        valType *y_real = y->realValues;
        valType *y_imag = y->imagValues;

        #pragma omp parallel for
        for (size_t i = 0; i < N; ++i) {
            valType sum_r = 0.0;
            valType sum_i = 0.0;

            #pragma omp simd
            for (int t = 0; t < num_threads; ++t) {
                sum_r += y_locals[t]->realValues[i];
                sum_i += y_locals[t]->imagValues[i];
            }
            y_real[i] = sum_r;
            y_imag[i] = sum_i;
        }

        #ifdef DEEP_DEBUG
            std::cout << " --- spMV result --- " << std::endl;
            y->print();
        #endif

        #ifdef DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("spMV_blocked (blocked) took %.3f ms\n", duration.count() / 1000.0);
        #endif

    #endif // !CUDA_ENABLED

}

void spMV_ntimes(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y, int n) {
    #ifdef CUDA_ENABLED

        spMV_ntimes_cuda(A, x, y, n);

    #else

        #ifdef DEBUG
            std::cout << "\t\t Starting spMV_ntimes -- ";
            std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
        #endif

        std::shared_ptr<vector> x_temp = x;
        std::shared_ptr<vector> y_temp = y;
        for (int i = 0; i < n; i++) {
            if (i % 2 == 0) {
                spMV(A, x_temp, y_temp);
            } else {
                spMV(A, y_temp, x_temp);
            }
        }
        // If n is even, the final result is in x_temp, so copy it to y
        if (n % 2 == 0) {
            std::copy(x_temp->realValues, x_temp->realValues + y->numRows, y->realValues);
            std::copy(x_temp->imagValues, x_temp->imagValues + y->numRows, y->imagValues);
        }

        #ifdef DEBUG
            std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\t spMV_ntimes took %f milliseconds\n", duration.count() / 1000.0);
        #endif

    #endif // not CUDA
}

} // namespace diaq
