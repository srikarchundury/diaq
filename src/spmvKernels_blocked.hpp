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

// // Thread local buffers + reduction
void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {

    #ifdef CUDA_ENABLED
        spMV_cuda(A, x, y);
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
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    valType *x_real_values = x->realValues;
        valType *x_imag_values = x->imagValues;

        size_t total_diagonals = A->dIndices.size();
        size_t N = y->numRows;

        const unsigned int DIAG_BLOCK = 4;      // number of diagonals per tile
        const unsigned int ELEM_BLOCK = 1024;   // number of elements per tile
        unsigned int numDiagTiles = (total_diagonals + DIAG_BLOCK - 1) / DIAG_BLOCK;

        // Prepare thread-local y buffers outside parallel region
        int max_threads = omp_get_max_threads();
        std::vector<std::shared_ptr<vector>> y_locals(max_threads);
        for (int t = 0; t < max_threads; ++t)
            y_locals[t] = y->copy();
        #pragma omp parallel
        {
            int tid = omp_get_thread_num();
            valType *y_real_values = y_locals[tid]->realValues;
            valType *y_imag_values = y_locals[tid]->imagValues;
            #pragma omp for schedule(static)
            for (unsigned int diag_tile = 0; diag_tile < numDiagTiles; ++diag_tile) {
                unsigned int diag_base = diag_tile * DIAG_BLOCK;
                unsigned int diag_end = diag_base + DIAG_BLOCK;
                if (diag_end > total_diagonals) diag_end = total_diagonals;
                for (unsigned int a = diag_base; a < diag_end; ++a) {
                    int dIndex = A->dIndices[a];
                    unsigned int dLength = A->getDiagonalLengthInternal(A->dIndices[a]);
                    unsigned int offset = A->diagOffsets[a];
                    valType *real_vals = A->realData + offset;
                    valType *imag_vals = A->imagData + offset;
                    unsigned int numElemTiles = (dLength + ELEM_BLOCK - 1) / ELEM_BLOCK;
                    for (unsigned int elem_tile = 0; elem_tile < numElemTiles; ++elem_tile) {
                        unsigned int elem_base = elem_tile * ELEM_BLOCK;
                        unsigned int elem_end = elem_base + ELEM_BLOCK;
                        if (elem_end > dLength) elem_end = dLength;
                        // SIMD and kernel selection as before
                        unsigned int simd_start = elem_base;
                        unsigned int simd_end = elem_end;
                        if (dIndex < 0) { // dIndex < 0
    #if VEC_TYPE == 2
                            run_spmv_avx512_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 1
                            run_spmv_avx_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 0
                            run_spmv_sse_1(x_real_values, x_imag_values, real_vals, imag_vals,
                                        y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 3
                            run_spmv_mac_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
    #else
                            #pragma omp simd
                            for (unsigned int i = elem_base; i < elem_end; ++i) {
                                unsigned int x_idx = i;
                                unsigned int y_idx = i - dIndex;
                                y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                                y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                            }
    #endif
                        }
                        else if (dIndex > 0) { // dIndex > 0
    #if VEC_TYPE == 2
                            run_spmv_avx512_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 1
                            run_spmv_avx_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 0
                            run_spmv_sse_2(x_real_values, x_imag_values, real_vals, imag_vals,
                                        y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 3
                            run_spmv_mac_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
    #else
                            #pragma omp simd
                            for (unsigned int i = elem_base; i < elem_end; ++i) {
                                unsigned int x_idx = dIndex + i;
                                unsigned int y_idx = i;
                                y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                                y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                            }
    #endif
                        } 
                        else { // dIndex == 0
    #if VEC_TYPE == 2
                            run_spmv_avx512_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 1
                            run_spmv_avx_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 0
                            run_spmv_sse_0(x_real_values, x_imag_values, real_vals, imag_vals,
                                        y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 3
                            run_spmv_mac_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
    #else
                            #pragma omp simd
                            for (unsigned int i = elem_base; i < elem_end; ++i) {
                                y_real_values[i] += real_vals[i] * x_real_values[i] - imag_vals[i] * x_imag_values[i];
                                y_imag_values[i] += real_vals[i] * x_imag_values[i] + imag_vals[i] * x_real_values[i];
                            }
    #endif
                        }
                    }
                }
            }
        } // end parallel region
        // Final merge
        valType *y_real = y->realValues;
        valType *y_imag = y->imagValues;
        #pragma omp parallel for
        for (size_t i = 0; i < N; ++i) {
            valType sum_r = 0.0;
            valType sum_i = 0.0;
            for (int t = 0; t < max_threads; ++t) {
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
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t spMV took %f milliseconds\n", duration.count() / 1000.0);
    #endif

    #endif // not CUDA

    }

} // namespace diaq
