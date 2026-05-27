#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

// convenience wrapper that creates the output vector y
std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x) {
    std::shared_ptr<vector> y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spMV(A, x, y);
    // x goes out of scope here and would be deleted by shared_ptr!
    return y;
}
std::shared_ptr<vector> spMV_ntimes(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, int n) {
    std::shared_ptr<vector> y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spMV_ntimes(A, x, y, n);
    // x goes out of scope here and would be deleted by shared_ptr!
    return y;
}

void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {

    #ifdef DEEP_DEBUG
        std::cout << " --- spMV --- " << std::endl;
        A->print();
        x->print();
        A->print_meta();
        x->print_meta();
        y->print_meta();
    #endif

    #ifdef CUDA_ENABLED

        spmv_cuda(A, x, y);

    #else
        
        #ifdef DEBUG
            std::cout << "\t\t Starting spMV -- ";
            std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
        #endif
        
        valType *x_real_values = x->realValues;
        valType *x_imag_values = x->imagValues;

        size_t total_diagonals = A->dIndices.size();
        size_t N = y->numRows;
    
        // Use at most as many threads as there are diagonals
        int max_threads = omp_get_max_threads();
        int num_threads = std::min((int)total_diagonals, max_threads);
    
        // Prepare thread-local y buffers outside parallel region
        std::vector<std::shared_ptr<vector>> y_locals(num_threads);
        for (int t = 0; t < num_threads; ++t)
            y_locals[t] = y->copy();  // uses aligned alloc
        
        #pragma omp parallel num_threads(num_threads)
        {
            int tid = omp_get_thread_num();
            valType *y_real_values = y_locals[tid]->realValues;
            valType *y_imag_values = y_locals[tid]->imagValues;
        
            #pragma omp for schedule(static)
            for (size_t a = 0; a < total_diagonals; ++a) {
                int dIndex = A->dIndices[a];
                unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
                unsigned int offset = A->diagOffsets[a];
                valType *real_vals = A->realData + offset;
                valType *imag_vals = A->imagData + offset;
        
                // Find aligned SIMD region
                unsigned int simd_start = 0;
                for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
                    bool aligned = false;
                    if (dIndex < 0)
                        aligned = (simd_start % VEC_WIDTH == 0) && ((simd_start - dIndex) % VEC_WIDTH == 0);
                    else if (dIndex > 0)
                        aligned = (simd_start % VEC_WIDTH == 0) && ((simd_start + dIndex) % VEC_WIDTH == 0);
                    else
                        aligned = (simd_start % VEC_WIDTH == 0);
                    if (aligned) break;
                }
                if (simd_start + VEC_WIDTH > dLength)
                    simd_start = dLength;
                unsigned int simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

                // Select and call appropriate kernel
                if (dIndex < 0) { // lower diagonal, negative index
                    #if VEC_TYPE == 2
                        run_spmv_avx512_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                                y_real_values, y_imag_values, dIndex, dLength);
                    #elif VEC_TYPE == 1
                        run_spmv_avx_1(0, dLength, x_real_values, x_imag_values, real_vals, imag_vals,
                                                y_real_values, y_imag_values, dIndex, dLength);
                    #elif VEC_TYPE == 0
                        run_spmv_sse_1(x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
                    #elif VEC_TYPE == 3
                        run_spmv_mac_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                                y_real_values, y_imag_values, dIndex, dLength);
                    #else
                        #pragma omp simd
                        for (unsigned int i = 0; i < dLength; i++) {
                            unsigned int x_idx = i;
                            unsigned int y_idx = i - dIndex;
                            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                        }
                    #endif
                }
                else if (dIndex > 0) { // positive diagonals
                    #if VEC_TYPE == 2
                        run_spmv_avx512_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                                y_real_values, y_imag_values, dIndex, dLength);
                    #elif VEC_TYPE == 1
                        run_spmv_avx_2(0, dLength, x_real_values, x_imag_values, real_vals, imag_vals,
                                                y_real_values, y_imag_values, dIndex, dLength);
                    #elif VEC_TYPE == 0
                        run_spmv_sse_2(x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
                    #elif VEC_TYPE == 3
                        run_spmv_mac_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
                    #else
                        #pragma omp simd
                        for (unsigned int i = 0; i < dLength; i++) {
                            unsigned int x_idx = dIndex + i;
                            unsigned int y_idx = i;
                            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                        }
                    #endif
                } else { // main diagonal, dIndex == 0
                    #if VEC_TYPE == 2
                    run_spmv_avx512_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                    y_real_values, y_imag_values, dIndex, dLength);
                    #elif VEC_TYPE == 1
                        run_spmv_avx_0(0, dLength, x_real_values, x_imag_values, real_vals, imag_vals,
                                                y_real_values, y_imag_values, dIndex, dLength);
                    #elif VEC_TYPE == 0
                        run_spmv_sse_0(x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
                    #elif VEC_TYPE == 3
                        run_spmv_mac_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                            y_real_values, y_imag_values, dIndex, dLength);
                    #else
                        #pragma omp simd
                        for (unsigned int i = 0; i < dLength; i++) {
                            y_real_values[i] += real_vals[i] * x_real_values[i] - imag_vals[i] * x_imag_values[i];
                            y_imag_values[i] += real_vals[i] * x_imag_values[i] + imag_vals[i] * x_real_values[i];
                        }
                    #endif
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
            std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\t spMV took %f milliseconds\n", duration.count() / 1000.0);
        #endif

    #endif // not CUDA
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
        // If n is odd, the final result is in x_temp, so copy it to y
        if (n % 2 == 1) {
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
