#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x) {
    std::shared_ptr<vector> y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spMV(A, x, y);
    // x goes out of scope here and would be deleted by shared_ptr!
    return y;
}

// Simple task struct for 2D blocking over diagonals and element ranges
struct SpmvTask {
    size_t diagIndex;
    unsigned int start;
    unsigned int end;
};

void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
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
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    #endif

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    size_t total_diagonals = A->dIndices.size();
    size_t N = y->numRows;

    if (total_diagonals == 0 || N == 0) {
        return;
    }

    // -------------------- Build 2D block tasks --------------------
    // Each task: (diag index, [start, end) over diagonal elements)
    // We only create tasks for the vectorizable range [0, vec_len),
    // where vec_len is a multiple of VEC_WIDTH. Tail is handled separately.
    const unsigned int TILE_LEN = BLOCK_SIZE; // assumed multiple of VEC_WIDTH

    std::vector<SpmvTask> tasks;
    tasks.reserve(total_diagonals * 4); // heuristic reserve

    // Store vectorized length per diagonal to handle tails later
    std::vector<unsigned int> vec_len_per_diag(total_diagonals);

    // std::array<unsigned int, 2> mat_shape = A->matrix_shape;

    for (size_t a = 0; a < total_diagonals; ++a) {
        int dIndex = A->dIndices[a];
        unsigned int dLength = A->getDiagonalLengthInternal(dIndex);

        if (dLength == 0) {
            vec_len_per_diag[a] = 0;
            continue;
        }

        // Vectorizable part (multiple of VEC_WIDTH)
        unsigned int vec_len = (dLength / VEC_WIDTH) * VEC_WIDTH;
        vec_len_per_diag[a] = vec_len;

        // Create tasks only for [0, vec_len)
        unsigned int tile_start = 0;
        while (tile_start < vec_len) {
            unsigned int tile_end = tile_start + TILE_LEN;
            if (tile_end > vec_len) {
                tile_end = vec_len;
            }

            SpmvTask task;
            task.diagIndex = a;
            task.start = tile_start;
            task.end   = tile_end;
            tasks.push_back(task);

            tile_start = tile_end;
        }
    }

    // If nothing vectorizable, we will just do scalar below
    if (tasks.empty()) {
        // Pure scalar fallback across all diagonals
        for (size_t a = 0; a < total_diagonals; ++a) {
            int dIndex = A->dIndices[a];
            unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
            unsigned int offset = A->diagOffsets[a];
            valType *real_vals = A->realData + offset;
            valType *imag_vals = A->imagData + offset;

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
            std::chrono::high_resolution_clock::time_point end_time_scalar = std::chrono::high_resolution_clock::now();
            auto duration_scalar = std::chrono::duration_cast<std::chrono::microseconds>(end_time_scalar - start_time);
            printf("\t\t spMV (scalar-only) took %f milliseconds\n", duration_scalar.count() / 1000.0);
        #endif
        return;
    }

    // -------------------- Thread-local y buffers --------------------
    int max_threads = omp_get_max_threads();
    int num_threads = max_threads;

    std::vector<std::shared_ptr<vector> > y_locals(num_threads);
    for (int t = 0; t < num_threads; ++t) {
        y_locals[t] = y->copy(); // aligned alloc, initialized to y (zeros)
    }

    // -------------------- Parallel 2D blocked SIMD over tasks --------------------
    #pragma omp parallel num_threads(num_threads)
    {
        int tid = omp_get_thread_num();
        valType *y_real_values = y_locals[tid]->realValues;
        valType *y_imag_values = y_locals[tid]->imagValues;

        #pragma omp for schedule(static)
        for (size_t ti = 0; ti < tasks.size(); ++ti) {
            SpmvTask task = tasks[ti];
            size_t a = task.diagIndex;
            unsigned int tile_start = task.start;
            unsigned int tile_end   = task.end;

            int dIndex = A->dIndices[a];
            unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
            unsigned int offset = A->diagOffsets[a];
            valType *real_vals = A->realData + offset;
            valType *imag_vals = A->imagData + offset;

            // Sanity clamp (should not happen if we built tasks correctly)
            if (tile_end > dLength) {
                tile_end = dLength;
            }
            if (tile_start >= tile_end) {
                continue;
            }

            // Choose kernel based on diagonal index sign and VEC_TYPE
            if (dIndex < 0) {
                #if VEC_TYPE == 2
                    run_spmv_avx512_1(tile_start, tile_end,
                                  x_real_values, x_imag_values,
                                  real_vals, imag_vals,
                                  y_real_values, y_imag_values,
                                  dIndex, dLength);
                #elif VEC_TYPE == 1
                    run_spmv_avx_1(tile_start, tile_end,
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
                    run_spmv_mac_1(tile_start, tile_end,
                               x_real_values, x_imag_values,
                               real_vals, imag_vals,
                               y_real_values, y_imag_values,
                               dIndex, dLength);
                #else
                    // Pure scalar in this build
                    for (unsigned int i = tile_start; i < tile_end; ++i) {
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
                    run_spmv_avx512_2(tile_start, tile_end,
                                  x_real_values, x_imag_values,
                                  real_vals, imag_vals,
                                  y_real_values, y_imag_values,
                                  dIndex, dLength);
                #elif VEC_TYPE == 1
                    run_spmv_avx_2(tile_start, tile_end,
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
                    run_spmv_mac_2(tile_start, tile_end,
                               x_real_values, x_imag_values,
                               real_vals, imag_vals,
                               y_real_values, y_imag_values,
                               dIndex, dLength);
                #else
                    for (unsigned int i = tile_start; i < tile_end; ++i) {
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
                    run_spmv_avx512_0(tile_start, tile_end,
                                  x_real_values, x_imag_values,
                                  real_vals, imag_vals,
                                  y_real_values, y_imag_values,
                                  dIndex, dLength);
                #elif VEC_TYPE == 1
                    run_spmv_avx_0(tile_start, tile_end,
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
                    run_spmv_mac_0(tile_start, tile_end,
                               x_real_values, x_imag_values,
                               real_vals, imag_vals,
                               y_real_values, y_imag_values,
                               dIndex, dLength);
                #else
                    for (unsigned int i = tile_start; i < tile_end; ++i) {
                        y_real_values[i] += real_vals[i] * x_real_values[i] -
                                            imag_vals[i] * x_imag_values[i];
                        y_imag_values[i] += real_vals[i] * x_imag_values[i] +
                                            imag_vals[i] * x_real_values[i];
                    }
                #endif
            }
        } // end tasks loop
    } // end parallel region

    // -------------------- Scalar tails for each diagonal --------------------
    // Any leftover elements in [vec_len, dLength) are handled here.
    // We put them into y_locals[0] only; they are small (at most VEC_WIDTH-1 per diag).
    valType *y_tail_real = y_locals[0]->realValues;
    valType *y_tail_imag = y_locals[0]->imagValues;

    for (size_t a = 0; a < total_diagonals; ++a) {
        int dIndex = A->dIndices[a];
        unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
        unsigned int vec_len = vec_len_per_diag[a];

        if (vec_len >= dLength) {
            continue;
        }

        unsigned int offset = A->diagOffsets[a];
        valType *real_vals = A->realData + offset;
        valType *imag_vals = A->imagData + offset;

        if (dIndex < 0) {
            for (unsigned int i = vec_len; i < dLength; ++i) {
                unsigned int x_idx = i;
                unsigned int y_idx = i - dIndex;
                y_tail_real[y_idx] += real_vals[i] * x_real_values[x_idx] -
                                      imag_vals[i] * x_imag_values[x_idx];
                y_tail_imag[y_idx] += real_vals[i] * x_imag_values[x_idx] +
                                      imag_vals[i] * x_real_values[x_idx];
            }
        } else if (dIndex > 0) {
            for (unsigned int i = vec_len; i < dLength; ++i) {
                unsigned int x_idx = dIndex + i;
                unsigned int y_idx = i;
                y_tail_real[y_idx] += real_vals[i] * x_real_values[x_idx] -
                                      imag_vals[i] * x_imag_values[x_idx];
                y_tail_imag[y_idx] += real_vals[i] * x_imag_values[x_idx] +
                                      imag_vals[i] * x_real_values[x_idx];
            }
        } else {
            for (unsigned int i = vec_len; i < dLength; ++i) {
                y_tail_real[i] += real_vals[i] * x_real_values[i] -
                                  imag_vals[i] * x_imag_values[i];
                y_tail_imag[i] += real_vals[i] * x_imag_values[i] +
                                  imag_vals[i] * x_real_values[i];
            }
        }
    }

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
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
        printf("\t\t spMV (blocked) took %f milliseconds\n", duration.count() / 1000.0);
    #endif

#endif // !CUDA_ENABLED
}

} // namespace diaq
