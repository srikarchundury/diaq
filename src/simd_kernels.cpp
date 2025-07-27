#include "simd_kernels.hpp"
#include "diagonal.hpp"

namespace diaq {

void run_without_vectorization(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset,
    valType *real_vals_a, valType *imag_vals_a, valType *real_vals_b, valType *imag_vals_b, valType *real_vals_final, valType *imag_vals_final) {
    #ifdef DEEP_DEBUG
        std::cout << "Starting run_without_vectorization -- " << std::endl;
        auto time_start = std::chrono::high_resolution_clock::now();
    #endif
    #pragma omp parallel for schedule(static)
    for (unsigned int k = start; k < end; ++k) {
		valType real_a = real_vals_a[k + a_offset];
        valType imag_a = imag_vals_a[k + a_offset];
        valType real_b = real_vals_b[k + b_offset];
        valType imag_b = imag_vals_b[k + b_offset];
		real_vals_final[k] = (valType)((valType)(real_a * real_b) - (valType)(imag_a * imag_b));
		imag_vals_final[k] = (valType)((valType)(real_a * imag_b) + (valType)(imag_a * real_b));
    }

    #ifdef DEEP_DEBUG
        auto time_end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(time_end - time_start);
        printf("\t\trun_without_vectorization took %f milliseconds\n", duration.count()/1000.0);
    #endif
}

// ----------------------------------------------------------------
//
// SIMD - SSE for valType = float, AVX for valType = double
//
// ----------------------------------------------------------------
#ifdef __AVX2__
    // ------------------------AVX DOUBLE----------------------------------------
    __m256d avx_load_partial_double(int n, const double *p) {
        // Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi64x(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm256_cmpgt_epi64(_mm256_set1_epi64x(n), _mm256_setr_epi64x(0, 1, 2, 3));
        // Load the array elements into the YMM register using the mask
        __m256d ymm = _mm256_maskload_pd(p, mask);
        return ymm;
    }
    void avx_store_partial_double(int n, double *loc, __m256d vec) {
        // Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi64x(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm256_cmpgt_epi64(_mm256_set1_epi64x(n), _mm256_setr_epi64x(0, 1, 2, 3));
        // Store the elements of the vector 'vec' into the array 'loc' using the mask
        _mm256_maskstore_pd(loc, mask, vec);
    }
    template<>
    void run_avx<double>(
        unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset,
        double *real_vals_a, double *imag_vals_a,
        double *real_vals_b, double *imag_vals_b,
        double *real_vals_final, double *imag_vals_final, bool overwrite
    ) {
        #ifdef DEEP_DEBUG
            auto start_time = std::chrono::high_resolution_clock::now();
        #endif

        // Find first aligned SIMD index
        unsigned int simd_start = start;
        for (; simd_start + 4 <= end; simd_start++) { // 4 = VEC_WIDTH for AVX2
            if ((simd_start % 4 == 0) &&
                ((simd_start + a_offset) % 4 == 0) &&
                ((simd_start + b_offset) % 4 == 0)) {
                break;
            }
        }
        if (simd_start + 4 > end)
            simd_start = end; // no SIMD possible

        unsigned int simd_end = end - ((end - simd_start) % 4); // VEC_WIDTH = 4 for AVX2

        // --- Prologue (unaligned/scalar) ---
        #pragma omp parallel for
        for (unsigned int idx = start; idx < simd_start; ++idx) {
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;

            double real_a = real_vals_a[idx_a];
            double imag_a = imag_vals_a[idx_a];
            double real_b = real_vals_b[idx_b];
            double imag_b = imag_vals_b[idx_b];

            if (overwrite) {
                real_vals_final[idx] = (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] = (real_a * imag_b) + (imag_a * real_b);
            } else {
                real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
            }
        }

        // --- SIMD Main Loop with BLOCKED vector chunks ---
        #pragma omp parallel for schedule(static)
        for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
            unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);

            for (unsigned int i = block_start; i + 4 <= block_end; i += 4) { // 4 = VEC_WIDTH for AVX2
                unsigned int idx_a = i + a_offset;
                unsigned int idx_b = i + b_offset;

                _mm_prefetch((const char*)&real_vals_a[idx_a + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&imag_vals_a[idx_a + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&real_vals_b[idx_b + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&imag_vals_b[idx_b + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&real_vals_final[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&imag_vals_final[i + PREFETCH_DIST], _MM_HINT_T0);

                __m256d real_a = _mm256_load_pd(&real_vals_a[idx_a]);
                __m256d imag_a = _mm256_load_pd(&imag_vals_a[idx_a]);
                __m256d real_b = _mm256_load_pd(&real_vals_b[idx_b]);
                __m256d imag_b = _mm256_load_pd(&imag_vals_b[idx_b]);

                __m256d real_res = _mm256_fnmadd_pd(imag_a, imag_b, _mm256_mul_pd(real_a, real_b));
                __m256d imag_res = _mm256_fmadd_pd(real_a, imag_b, _mm256_mul_pd(imag_a, real_b));

                if (overwrite) {
                    _mm256_store_pd(&real_vals_final[i], real_res);
                    _mm256_store_pd(&imag_vals_final[i], imag_res);
                } else {
                    __m256d existing_real = _mm256_load_pd(&real_vals_final[i]);
                    __m256d existing_imag = _mm256_load_pd(&imag_vals_final[i]);

                    _mm256_store_pd(&real_vals_final[i], _mm256_add_pd(existing_real, real_res));
                    _mm256_store_pd(&imag_vals_final[i], _mm256_add_pd(existing_imag, imag_res));
                }
            }
        }

        // --- Epilogue ---
        #pragma omp parallel for
        for (unsigned int idx = simd_end; idx < end; ++idx) {
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;

            double real_a = real_vals_a[idx_a];
            double imag_a = imag_vals_a[idx_a];
            double real_b = real_vals_b[idx_b];
            double imag_b = imag_vals_b[idx_b];

            if (overwrite) {
                real_vals_final[idx] = (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] = (real_a * imag_b) + (imag_a * real_b);
            } else {
                real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
            }
        }

        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_avx - Double (Blocked SIMD) took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }
    // ------------------------AVX FLOAT----------------------------------------
    __m256 avx_load_partial_float(int n, const float* p) {
        // Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi32(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm256_cmpgt_epi32(_mm256_set1_epi32(n), _mm256_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7));
        // Load the array elements into the YMM register using the mask
        __m256 ymm = _mm256_maskload_ps(p, mask);
        return ymm;
    }
    void avx_store_partial_float(int n, float *loc, __m256 vec) {
        // Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi32(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm256_cmpgt_epi32(_mm256_set1_epi32(n), _mm256_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7));
        // Store the elements of the vector 'vec' into the array 'loc' using the mask
        _mm256_maskstore_ps(loc, mask, vec);
    }
    template<>
    void run_avx<float>(
        unsigned int start, unsigned int end,
        unsigned int a_offset, unsigned int b_offset,
        float *real_vals_a, float *imag_vals_a,
        float *real_vals_b, float *imag_vals_b,
        float *real_vals_final, float *imag_vals_final, bool overwrite
    ) {
        #ifdef DEEP_DEBUG
            std::cout << "Starting run_avx float -- " << std::endl;
            auto start_time = std::chrono::high_resolution_clock::now();
        #endif

        // Find first aligned SIMD index
        unsigned int simd_start = start;
        for (; simd_start + 8 <= end; simd_start++) { // VEC_WIDTH = 8 for AVX2 floats
            if ((simd_start % 8 == 0) &&
                ((simd_start + a_offset) % 8 == 0) &&
                ((simd_start + b_offset) % 8 == 0)) {
                break;
            }
        }
        if (simd_start + 8 > end)
            simd_start = end; // no SIMD possible

        unsigned int simd_end = end - ((end - simd_start) % 8);
        unsigned int simd_vec_blocks = (simd_end - simd_start) / 8;

        // --- Prologue (unaligned/scalar) ---
        #pragma omp parallel for
        for (unsigned int idx = start; idx < simd_start; ++idx) {
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;

            float real_a = real_vals_a[idx_a];
            float imag_a = imag_vals_a[idx_a];
            float real_b = real_vals_b[idx_b];
            float imag_b = imag_vals_b[idx_b];

            real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
        }

        // --- SIMD aligned main loop ---
        #pragma omp parallel for
        for (unsigned int i = 0; i < simd_vec_blocks; ++i) {
            unsigned int idx   = simd_start + i * 8;
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;

            _mm_prefetch((const char*)&real_vals_a[idx_a + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch((const char*)&imag_vals_a[idx_a + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch((const char*)&real_vals_b[idx_b + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch((const char*)&imag_vals_b[idx_b + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch((const char*)&real_vals_final[idx + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch((const char*)&imag_vals_final[idx + PREFETCH_DIST], _MM_HINT_T0);

            __m256 real_a = _mm256_load_ps(&real_vals_a[idx_a]);
            __m256 imag_a = _mm256_load_ps(&imag_vals_a[idx_a]);
            __m256 real_b = _mm256_load_ps(&real_vals_b[idx_b]);
            __m256 imag_b = _mm256_load_ps(&imag_vals_b[idx_b]);

            __m256 real_res = _mm256_fnmadd_ps(imag_a, imag_b, _mm256_mul_ps(real_a, real_b)); // real_a*real_b - imag_a*imag_b
            __m256 imag_res = _mm256_fmadd_ps(real_a, imag_b, _mm256_mul_ps(imag_a, real_b));  // real_a*imag_b + imag_a*real_b

            __m256 existing_real = _mm256_load_ps(&real_vals_final[idx]);
            __m256 existing_imag = _mm256_load_ps(&imag_vals_final[idx]);

            _mm256_store_ps(&real_vals_final[idx], _mm256_add_ps(existing_real, real_res));
            _mm256_store_ps(&imag_vals_final[idx], _mm256_add_ps(existing_imag, imag_res));
        }

        // --- Epilogue (unaligned/scalar) ---
        #pragma omp parallel for
        for (unsigned int idx = simd_end; idx < end; ++idx) {
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;

            float real_a = real_vals_a[idx_a];
            float imag_a = imag_vals_a[idx_a];
            float real_b = real_vals_b[idx_b];
            float imag_b = imag_vals_b[idx_b];

            real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
        }

        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_avx - Float took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }

    // SPMV for AVX
    template<typename valTypeTemplate>
    void run_spmv_avx_1(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx_2(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx_0(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    // ------------------------AVX DOUBLE----------------------------------------
    template<>
    void run_spmv_avx_1<double>(
        unsigned int simd_start, unsigned int simd_end,
        double *x_real_values, double *x_imag_values,
        double *real_vals, double *imag_vals,
        double *y_real_values, double *y_imag_values,
        int dIndex, unsigned int dLength) {

        #ifdef DEEP_DEBUG
            std::cout << "Starting run_spmv_avx_1 - Aligned SIMD (w/ Prologue/Epilogue) --" << std::endl;
            auto start_time = std::chrono::high_resolution_clock::now();
        #endif

        // --- Prologue ---
        #pragma omp parallel for
        for (unsigned int i = 0; i < simd_start; ++i) {
            unsigned int y_index = i - dIndex;

            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[i];
            double x_i = x_imag_values[i];

            y_real_values[y_index] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[y_index] += (a_r * x_i) + (a_i * x_r);
        }

        // --- SIMD Main Loop with Blocking ---
        #pragma omp parallel for schedule(static)
        for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
            unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);

            for (unsigned int i = block_start; i + 4 <= block_end; i += 4) { // VEC_WIDTH = 4 for AVX2
                unsigned int y_index = i - dIndex;

                _mm_prefetch((const char*)&real_vals[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&x_real_values[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&y_real_values[y_index + PREFETCH_DIST], _MM_HINT_T0);

                __m256d a_r = _mm256_load_pd(&real_vals[i]);
                __m256d a_i = _mm256_load_pd(&imag_vals[i]);
                __m256d x_r = _mm256_load_pd(&x_real_values[i]);
                __m256d x_i = _mm256_load_pd(&x_imag_values[i]);

                __m256d y_r = _mm256_load_pd(&y_real_values[y_index]);
                __m256d y_i = _mm256_load_pd(&y_imag_values[y_index]);

                y_r = _mm256_fnmadd_pd(a_i, x_i, _mm256_fmadd_pd(a_r, x_r, y_r)); // y_r += (a_r * x_r) - (a_i * x_i)
                y_i = _mm256_fmadd_pd(a_r, x_i, _mm256_fmadd_pd(a_i, x_r, y_i)); // y_i += (a_r * x_i) + (a_i * x_r)

                _mm256_store_pd(&y_real_values[y_index], y_r);
                _mm256_store_pd(&y_imag_values[y_index], y_i);
            }
        }

        // --- Epilogue ---
        #pragma omp parallel for
        for (unsigned int i = simd_end; i < dLength; ++i) {
            unsigned int y_index = i - dIndex;

            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[i];
            double x_i = x_imag_values[i];

            y_real_values[y_index] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[y_index] += (a_r * x_i) + (a_i * x_r);
        }

        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_spmv_avx_1 - Double (Blocked SIMD) took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }
    template<>
    void run_spmv_avx_2<double>(
        unsigned int simd_start, unsigned int simd_end,
        double *x_real_values, double *x_imag_values,
        double *real_vals, double *imag_vals,
        double *y_real_values, double *y_imag_values,
        int dIndex, unsigned int dLength) {

        #ifdef DEEP_DEBUG
            std::cout << "Starting run_spmv_avx_2 - Aligned SIMD (w/ Prologue/Epilogue) --" << std::endl;
            auto start_time = std::chrono::high_resolution_clock::now();
        #endif

        // --- Prologue ---
        #pragma omp parallel for
        for (unsigned int i = 0; i < simd_start; ++i) {
            unsigned int x_index = i + dIndex;

            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[x_index];
            double x_i = x_imag_values[x_index];

            y_real_values[i] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
        }

        // --- SIMD Main Loop with Blocking ---
        #pragma omp parallel for schedule(static)
        for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
            unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);

            for (unsigned int i = block_start; i + 4 <= block_end; i += 4) { // VEC_WIDTH = 4 for AVX2
                unsigned int x_index = i + dIndex;

                _mm_prefetch((const char*)&real_vals[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&x_real_values[x_index + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&y_real_values[i + PREFETCH_DIST], _MM_HINT_T0);

                __m256d a_r = _mm256_load_pd(&real_vals[i]);
                __m256d a_i = _mm256_load_pd(&imag_vals[i]);
                __m256d x_r = _mm256_load_pd(&x_real_values[x_index]);
                __m256d x_i = _mm256_load_pd(&x_imag_values[x_index]);

                __m256d y_r = _mm256_load_pd(&y_real_values[i]);
                __m256d y_i = _mm256_load_pd(&y_imag_values[i]);

                y_r = _mm256_fmadd_pd(a_r, x_r, _mm256_fnmadd_pd(a_i, x_i, y_r)); // y_r += (a_r * x_r) - (a_i * x_i)
                y_i = _mm256_fmadd_pd(a_r, x_i, _mm256_fmadd_pd(a_i, x_r, y_i)); // y_i += (a_r * x_i) + (a_i * x_r)

                _mm256_store_pd(&y_real_values[i], y_r);
                _mm256_store_pd(&y_imag_values[i], y_i);
            }
        }

        // --- Epilogue ---
        #pragma omp parallel for
        for (unsigned int i = simd_end; i < dLength; ++i) {
            unsigned int x_index = i + dIndex;

            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[x_index];
            double x_i = x_imag_values[x_index];

            y_real_values[i] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
        }

        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_spmv_avx_2 - Double (Blocked SIMD) took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }

    template<>
    void run_spmv_avx_0<double>(
        unsigned int simd_start, unsigned int simd_end,
        double *x_real_values, double *x_imag_values,
        double *real_vals, double *imag_vals,
        double *y_real_values, double *y_imag_values,
        int dIndex, unsigned int dLength) {

        #ifdef DEEP_DEBUG
            std::cout << "Starting run_spmv_avx_0 - SIMD aligned version --" << std::endl;
            auto start_time = std::chrono::high_resolution_clock::now();
        #endif

        // --- Prologue ---
        #pragma omp parallel for
        for (unsigned int i = 0; i < simd_start; ++i) {
            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[i];
            double x_i = x_imag_values[i];

            y_real_values[i] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
        }

        // --- SIMD aligned loop with blocking ---
        #pragma omp parallel for schedule(static)
        for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
            unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);

            for (unsigned int i = block_start; i + 4 <= block_end; i += 4) { // VEC_WIDTH = 4 for AVX2
                _mm_prefetch((const char*)&real_vals[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&x_real_values[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch((const char*)&y_real_values[i + PREFETCH_DIST], _MM_HINT_T0);

                __m256d a_r = _mm256_load_pd(&real_vals[i]);
                __m256d a_i = _mm256_load_pd(&imag_vals[i]);
                __m256d x_r = _mm256_load_pd(&x_real_values[i]);
                __m256d x_i = _mm256_load_pd(&x_imag_values[i]);
                __m256d y_r = _mm256_load_pd(&y_real_values[i]);
                __m256d y_i = _mm256_load_pd(&y_imag_values[i]);

                y_r = _mm256_fnmadd_pd(a_i, x_i, _mm256_fmadd_pd(a_r, x_r, y_r)); // y_r += (a_r * x_r) - (a_i * x_i)
                y_i = _mm256_fmadd_pd(a_r, x_i, _mm256_fmadd_pd(a_i, x_r, y_i)); // y_i += (a_r * x_i) + (a_i * x_r)

                _mm256_store_pd(&y_real_values[i], y_r);
                _mm256_store_pd(&y_imag_values[i], y_i);
            }
        }

        // --- Epilogue ---
        #pragma omp parallel for
        for (unsigned int i = simd_end; i < dLength; ++i) {
            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[i];
            double x_i = x_imag_values[i];

            y_real_values[i] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
        }

        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_spmv_avx_0 - Double (Blocked SIMD) took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }

    // // ------------------------AVX FLOAT----------------------------------------
    // template<>
    // void run_spmv_avx_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_avx_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_avx_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength) {
    //     // TODO
    // }
    
#endif

#ifdef __SSE__
    template<typename valTypeTemplate>
    void run_sse(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final);

    // ------------------------SSE Float----------------------------------------
    __m128 sse_load_partial_float(int n, float *p) {
        __m128 t1, t2, xmm;
        switch (n) {
            case 1:
                xmm = _mm_load_ss(p); break;
            case 2:
                xmm = _mm_castpd_ps(_mm_load_sd((double *)p)); break;
            case 3:
                t1 = _mm_castpd_ps(_mm_load_sd((double *)p));
                t2 = _mm_load_ss(p + 2);
                xmm = _mm_movelh_ps(t1, t2); break;
            case 4:
                xmm = _mm_loadu_ps(p); break;
            default:
                xmm = _mm_setzero_ps();
        }
        return xmm;
    }
    void sse_store_partial_float(int n, float *loc, __m128 vec) {
        #pragma GCC unroll 8
        for(int i = 0; i < n; i++){
            loc[i] = vec[i];
        }
    }
    template<>
    void run_sse<float>(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final) {

        #ifdef DEEP_DEBUG
            std::cout << "Starting run_sse float -- " << std::endl;
            auto start = std::chrono::high_resolution_clock::now();
        #endif
        
        // unsigned int loop_count = 0;
        // unsigned int k_cpy = k;
        // while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
        //     loop_count++;
        //     k_cpy++;
        // }

        unsigned int max_lenRes = lenRes - k;
        unsigned int max_lenDiagA = lenDiagA - (k + offsetA - jump);
        unsigned int max_lenDiagB = lenDiagB - (k + offsetB - jump);

        unsigned int loop_count = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});

        __m128 real_a, real_b; // a for valuesA and b for valuesB
        __m128 imag_a, imag_b; // a for valuesA and b for valuesB
        __m128 real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        int left_overs = loop_count - ((loop_count / 4) * 4);
        unsigned int vec_loop = (loop_count / 4);
        unsigned int left_overs_start_at_A = k + offsetA - jump + 4 * (loop_count / 4);
        unsigned int left_overs_start_at_B = k + offsetB - jump + 4 * (loop_count / 4);

        while (vec_loop--) {
            real_a = _mm_loadu_ps(&real_vals_a[k + offsetA - jump]);
            imag_a = _mm_loadu_ps(&imag_vals_a[k + offsetA - jump]);
            real_b = _mm_loadu_ps(&real_vals_b[k + offsetB - jump]);
            imag_b = _mm_loadu_ps(&imag_vals_b[k + offsetB - jump]);

            real_reala_realb = _mm_mul_ps(real_a, real_b);
            real_imaga_imagb = _mm_mul_ps(imag_a, imag_b);
            real_res = _mm_sub_ps(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm_mul_ps(real_a, imag_b);
            imag_imaga_realb = _mm_mul_ps(imag_a, real_b);
            imag_res = _mm_add_ps(imag_reala_imagb, imag_imaga_realb);

            _mm_storeu_ps(&real_vals_final[k], real_res);
            _mm_storeu_ps(&imag_vals_final[k], imag_res);

            k += 4;
        }
        if (left_overs != 0) {
            real_a = sse_load_partial_float(left_overs, &real_vals_a[left_overs_start_at_A]);
            imag_a = sse_load_partial_float(left_overs, &imag_vals_a[left_overs_start_at_A]);
            real_b = sse_load_partial_float(left_overs, &real_vals_b[left_overs_start_at_B]);
            imag_b = sse_load_partial_float(left_overs, &imag_vals_b[left_overs_start_at_B]);

            real_reala_realb = _mm_mul_ps(real_a, real_b);
            real_imaga_imagb = _mm_mul_ps(imag_a, imag_b);
            real_res = _mm_sub_ps(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm_mul_ps(real_a, imag_b);
            imag_imaga_realb = _mm_mul_ps(imag_a, real_b);
            imag_res = _mm_add_ps(imag_reala_imagb, imag_imaga_realb);

            sse_store_partial_float(left_overs, &real_vals_final[k], real_res);
            sse_store_partial_float(left_overs, &imag_vals_final[k], imag_res);

            // k += left_overs;
        }

        #ifdef DEEP_DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\trun_sse - Float took %f milliseconds\n", duration.count()/1000.0);
        #endif
    }

    // ------------------------SSE Double----------------------------------------
    __m128d sse_load_partial_double(int n, const double *p) {
        // Initialize a mask with all bits set to 1
        __m128i mask = _mm_set1_epi64x(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm_cmpgt_epi64(_mm_set1_epi64x(n), _mm_set_epi64x(0, 1));
        // Load the array elements into the XMM register using the mask
        __m128d xmm = _mm_maskload_pd(p, mask);
        return xmm;
    }
    void sse_store_partial_double(int n, double *loc, __m128d vec) {
        // Initialize a mask with all bits set to 1
        __m128i mask = _mm_set1_epi64x(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm_cmpgt_epi64(_mm_set1_epi64x(n), _mm_set_epi64x(0, 1));
        // Store the elements of the vector 'vec' into the array 'loc' using the mask
        _mm_maskstore_pd(loc, mask, vec);
    }
    template<>
    void run_sse<double>(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final) {

        #ifdef DEEP_DEBUG
            std::cout << "Starting run_sse double -- " << std::endl;
            auto start = std::chrono::high_resolution_clock::now();
        #endif

        // unsigned int loop_count = 0;
        // unsigned int k_cpy = k;
        // while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
        //     loop_count++;
        //     k_cpy++;
        // }

        unsigned int max_lenRes = lenRes - k;
        unsigned int max_lenDiagA = lenDiagA - (k + offsetA - jump);
        unsigned int max_lenDiagB = lenDiagB - (k + offsetB - jump);

        unsigned int loop_count = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});

        __m128d real_a, real_b; // a for valuesA and b for valuesB
        __m128d imag_a, imag_b; // a for valuesA and b for valuesB
        __m128d real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        int left_overs = loop_count - ((loop_count / 2) * 2);
        unsigned int vec_loop = (loop_count / 2);
        // unsigned int left_overs_start_at_A = k + offsetA - jump + 2 * (loop_count / 2);
        // unsigned int left_overs_start_at_B = k + offsetB - jump + 2 * (loop_count / 2);

        // printf("k = %ld, lenRes = %ld, offsetA = %ld, offsetB = %ld, jump = %ld, lenDiagA = %ld, lenDiagB = %ld, loop_count = %ld, left_overs = %ld, vec_loop = %ld, left_overs_start_at_A = %ld, left_overs_start_at_B = %ld\n", k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, loop_count, left_overs, vec_loop, left_overs_start_at_A, left_overs_start_at_B);

        while (vec_loop--) {
            real_a = _mm_loadu_pd(&real_vals_a[k + offsetA - jump]);
            imag_a = _mm_loadu_pd(&imag_vals_a[k + offsetA - jump]);
            real_b = _mm_loadu_pd(&real_vals_b[k + offsetB - jump]);
            imag_b = _mm_loadu_pd(&imag_vals_b[k + offsetB - jump]);

            real_reala_realb = _mm_mul_pd(real_a, real_b);
            real_imaga_imagb = _mm_mul_pd(imag_a, imag_b);
            real_res = _mm_sub_pd(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm_mul_pd(real_a, imag_b);
            imag_imaga_realb = _mm_mul_pd(imag_a, real_b);
            imag_res = _mm_add_pd(imag_reala_imagb, imag_imaga_realb);

            _mm_storeu_pd(&real_vals_final[k], real_res);
            _mm_storeu_pd(&imag_vals_final[k], imag_res);

            k += 2;
        }
        if (left_overs == 1) { // left over can be 1 or 0, don't need vectorization for that right..?
            real_vals_final[k] = (valType)((valType)(real_vals_a[k + offsetA - jump] * real_vals_b[k + offsetB - jump]) - (valType)(imag_vals_a[k + offsetA - jump] * imag_vals_b[k + offsetB - jump]));
            imag_vals_final[k] = (valType)((valType)(real_vals_a[k + offsetA - jump] * imag_vals_b[k + offsetB - jump]) + (valType)(imag_vals_a[k + offsetA - jump] * real_vals_b[k + offsetB - jump]));
            // k += 1;
        }

        #ifdef DEEP_DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\trun_sse - Double took %f milliseconds\n", duration.count()/1000.0);
        #endif
    }

    // SPMV for SSE
    template<typename valTypeTemplate>
    void run_spmv_sse_1(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    template<typename valTypeTemplate>
    void run_spmv_sse_2(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    template<typename valTypeTemplate>
    void run_spmv_sse_0(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    // // ------------------------SSE FLOAT----------------------------------------
    // template<>
    // void run_spmv_sse_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_sse_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_sse_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength) {
    //     // TODO
    // }

    // ------------------------SSE DOUBLE----------------------------------------
    template<>
    void run_spmv_sse_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength) {

        #ifdef DEEP_DEBUG
            std::cout << "Starting run_spmv_sse_1 - Double -- " << std::endl;
            auto start = std::chrono::high_resolution_clock::now();
        #endif

        unsigned int vec_loop = dLength / 2;
        // int left_overs = dLength % 2;

        __m128d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned int i = 0; i < vec_loop; i += 2) {
            real_vals_vec = _mm_loadu_pd(&real_vals[i]);
            imag_vals_vec = _mm_loadu_pd(&imag_vals[i]);
            x_real_vals_vec = _mm_loadu_pd(&x_real_values[i]);
            x_imag_vals_vec = _mm_loadu_pd(&x_imag_values[i]);
            y_real_vals_vec = _mm_loadu_pd(&y_real_values[i - dIndex]);
            y_imag_vals_vec = _mm_loadu_pd(&y_imag_values[i - dIndex]);

            y_real_vals_vec = _mm_add_pd(y_real_vals_vec, _mm_sub_pd(_mm_mul_pd(real_vals_vec, x_real_vals_vec), _mm_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm_add_pd(y_imag_vals_vec, _mm_add_pd(_mm_mul_pd(real_vals_vec, x_imag_vals_vec), _mm_mul_pd(imag_vals_vec, x_real_vals_vec)));

            _mm_storeu_pd(&y_real_values[i - dIndex], y_real_vals_vec);
            _mm_storeu_pd(&y_imag_values[i - dIndex], y_imag_vals_vec);
        }

        for (unsigned int i = vec_loop * 2; i < dLength; i++) {
            unsigned int x_idx = i;
            unsigned int y_idx = i - dIndex;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        }

        #ifdef DEEP_DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\trun_spmv_sse_1 - Double took %f milliseconds\n", duration.count()/1000.0);
        #endif
    }
    template<>
    void run_spmv_sse_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength) {

        #ifdef DEEP_DEBUG
            std::cout << "Starting run_spmv_sse_2 - Double -- " << std::endl;
            auto start = std::chrono::high_resolution_clock::now();
        #endif

        unsigned int vec_loop = dLength / 2;
        // int left_overs = dLength % 2;

        __m128d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned int i = 0; i < vec_loop; i += 2) {
            real_vals_vec = _mm_loadu_pd(&real_vals[i]);
            imag_vals_vec = _mm_loadu_pd(&imag_vals[i]);
            x_real_vals_vec = _mm_loadu_pd(&x_real_values[dIndex + i]);
            x_imag_vals_vec = _mm_loadu_pd(&x_imag_values[dIndex + i]);
            y_real_vals_vec = _mm_loadu_pd(&y_real_values[i]);
            y_imag_vals_vec = _mm_loadu_pd(&y_imag_values[i]);

            y_real_vals_vec = _mm_add_pd(y_real_vals_vec, _mm_sub_pd(_mm_mul_pd(real_vals_vec, x_real_vals_vec), _mm_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm_add_pd(y_imag_vals_vec, _mm_add_pd(_mm_mul_pd(real_vals_vec, x_imag_vals_vec), _mm_mul_pd(imag_vals_vec, x_real_vals_vec)));

            _mm_storeu_pd(&y_real_values[i], y_real_vals_vec);
            _mm_storeu_pd(&y_imag_values[i], y_imag_vals_vec);
        }

        for (unsigned int i = vec_loop * 2; i < dLength; i++) {
            unsigned int x_idx = dIndex + i;
            unsigned int y_idx = i;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        }

        #ifdef DEEP_DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\trun_spmv_sse_2 - Double took %f milliseconds\n", duration.count()/1000.0);
        #endif
    }
    template<>
    void run_spmv_sse_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength) {

        #ifdef DEEP_DEBUG
            std::cout << "Starting run_spmv_sse_0 - Double -- " << std::endl;
            auto start = std::chrono::high_resolution_clock::now();
        #endif

        unsigned int vec_loop = dLength / 2;
        // int left_overs = dLength % 2;

        __m128d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned int i = 0; i < vec_loop; i += 2) {
            real_vals_vec = _mm_loadu_pd(&real_vals[i]);
            imag_vals_vec = _mm_loadu_pd(&imag_vals[i]);
            x_real_vals_vec = _mm_loadu_pd(&x_real_values[i]);
            x_imag_vals_vec = _mm_loadu_pd(&x_imag_values[i]);
            y_real_vals_vec = _mm_loadu_pd(&y_real_values[i]);
            y_imag_vals_vec = _mm_loadu_pd(&y_imag_values[i]);

            y_real_vals_vec = _mm_add_pd(y_real_vals_vec, _mm_sub_pd(_mm_mul_pd(real_vals_vec, x_real_vals_vec), _mm_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm_add_pd(y_imag_vals_vec, _mm_add_pd(_mm_mul_pd(real_vals_vec, x_imag_vals_vec), _mm_mul_pd(imag_vals_vec, x_real_vals_vec)));

            _mm_storeu_pd(&y_real_values[i], y_real_vals_vec);
            _mm_storeu_pd(&y_imag_values[i], y_imag_vals_vec);
        }

        for (unsigned int i = vec_loop * 2; i < dLength; i++) {
            unsigned int x_idx = i;
            unsigned int y_idx = i;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        }

        #ifdef DEEP_DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\trun_spmv_sse_0 - Double took %f milliseconds\n", duration.count()/1000.0);
        #endif
    }

#endif

#ifdef __AVX512F__
    // ------------------------AVX512 DOUBLE----------------------------------------
    __m512d avx512_load_partial_double(int n, const double *p) {
        // Create a mask based on the length 'n' of the array
        __mmask8 mask = (1 << n) - 1;
        // Load the array elements into the ZMM register using the mask
        __m512d zmm = _mm512_maskz_loadu_pd(mask, p);
        return zmm;
    }
    void avx512_store_partial_double(int n, double *loc, __m512d vec) {
        // Create a mask based on the length 'n' of the array
        __mmask8 mask = (1 << n) - 1;
        // Store the elements of the vector 'vec' into the array 'loc' using the mask
        _mm512_mask_storeu_pd(loc, mask, vec);
    }

    template<>
    void run_avx512<double>(
        unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset,
        double *real_vals_a, double *imag_vals_a,
        double *real_vals_b, double *imag_vals_b,
        double *real_vals_final, double *imag_vals_final, bool overwrite
    ) {
    #ifdef DEEP_DEBUG
        auto start_time = std::chrono::high_resolution_clock::now();
    #endif
    
        // Find first aligned SIMD index
        unsigned int simd_start = start;
        for (; simd_start + VEC_WIDTH <= end; simd_start++) {
            if ((simd_start % VEC_WIDTH == 0) &&
                ((simd_start + a_offset) % VEC_WIDTH == 0) &&
                ((simd_start + b_offset) % VEC_WIDTH == 0)) {
                break;
            }
        }
        if (simd_start + VEC_WIDTH > end)
            simd_start = end; // no SIMD possible
    
        unsigned int simd_end = end - ((end - simd_start) % VEC_WIDTH);
    
        // --- Prologue (unaligned/scalar) ---
        #pragma omp parallel for
        for (unsigned int idx = start; idx < simd_start; ++idx) {
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;
    
            double real_a = real_vals_a[idx_a];
            double imag_a = imag_vals_a[idx_a];
            double real_b = real_vals_b[idx_b];
            double imag_b = imag_vals_b[idx_b];
    
            if (overwrite) {
                real_vals_final[idx] = (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] = (real_a * imag_b) + (imag_a * real_b);
            } else {
                real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
            }
        }
    
        // --- SIMD Main Loop with BLOCKED vector chunks ---
        #pragma omp parallel for schedule(static)
        for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
            unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);
    
            for (unsigned int i = block_start; i + VEC_WIDTH <= block_end; i += VEC_WIDTH) {
                unsigned int idx_a = i + a_offset;
                unsigned int idx_b = i + b_offset;
    
                _mm_prefetch(&real_vals_a[idx_a + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&imag_vals_a[idx_a + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&real_vals_b[idx_b + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&imag_vals_b[idx_b + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&real_vals_final[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&imag_vals_final[i + PREFETCH_DIST], _MM_HINT_T0);
    
                __m512d real_a = _mm512_load_pd(&real_vals_a[idx_a]);
                __m512d imag_a = _mm512_load_pd(&imag_vals_a[idx_a]);
                __m512d real_b = _mm512_load_pd(&real_vals_b[idx_b]);
                __m512d imag_b = _mm512_load_pd(&imag_vals_b[idx_b]);
    
                __m512d real_res = _mm512_fnmadd_pd(imag_a, imag_b, _mm512_mul_pd(real_a, real_b));
                __m512d imag_res = _mm512_fmadd_pd(real_a, imag_b, _mm512_mul_pd(imag_a, real_b));
    
                if (overwrite) {
                    _mm512_store_pd(&real_vals_final[i], real_res);
                    _mm512_store_pd(&imag_vals_final[i], imag_res);
                } else {
                    __m512d existing_real = _mm512_load_pd(&real_vals_final[i]);
                    __m512d existing_imag = _mm512_load_pd(&imag_vals_final[i]);
    
                    _mm512_store_pd(&real_vals_final[i], _mm512_add_pd(existing_real, real_res));
                    _mm512_store_pd(&imag_vals_final[i], _mm512_add_pd(existing_imag, imag_res));
                }
            }
        }
    
        // --- Epilogue ---
        #pragma omp parallel for
        for (unsigned int idx = simd_end; idx < end; ++idx) {
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;
    
            double real_a = real_vals_a[idx_a];
            double imag_a = imag_vals_a[idx_a];
            double real_b = real_vals_b[idx_b];
            double imag_b = imag_vals_b[idx_b];
    
            if (overwrite) {
                real_vals_final[idx] = (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] = (real_a * imag_b) + (imag_a * real_b);
            } else {
                real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
            }
        }
    
        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_avx512 - Double (Blocked SIMD) took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }    

    // // old original code
    // template<>
    // void run_avx512<double>(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final) {

    //     #ifdef DEBUG
    //         // std::cout << "Starting run_avx512 double -- " << std::endl;
    //         auto start = std::chrono::high_resolution_clock::now();
    //     #endif

    //     // unsigned int loop_count = 0;
    //     // unsigned int k_cpy = k;
    //     // while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
    //     //     loop_count++;
    //     //     k_cpy++;
    //     // }

    //     unsigned int max_lenRes = lenRes - k;
    //     unsigned int max_lenDiagA = lenDiagA - (k + offsetA - jump);
    //     unsigned int max_lenDiagB = lenDiagB - (k + offsetB - jump);
    //     unsigned int loop_count = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});

    //     __m512d real_a, real_b; // a for valuesA and b for valuesB
    //     __m512d imag_a, imag_b; // a for valuesA and b for valuesB
    //     __m512d real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
    //     int left_overs = loop_count - ((loop_count / 8) * 8);
    //     unsigned int vec_loop = (loop_count / 8);
    //     unsigned int left_overs_start_at_A = k + offsetA - jump + PREFETCH_DIST * (loop_count / 8);
    //     unsigned int left_overs_start_at_B = k + offsetB - jump + PREFETCH_DIST * (loop_count / 8);

    //     #pragma omp parallel for
    //     for (unsigned int i = 0; i < vec_loop; ++i) {
    //         unsigned int idx = k + i * 8;

    //         // TODO: do prologue and epilogue separately! and middle part use SIMD aligned load and store!

    //         unsigned int offsetA_idx = idx + offsetA - jump;
    //         unsigned int offsetB_idx = idx + offsetB - jump;

    //         // Prefetch the next set of values for better cache utilization
    //         _mm_prefetch(&real_vals_a[offsetA_idx + PREFETCH_DIST], _MM_HINT_T0);
    //         _mm_prefetch(&imag_vals_a[offsetA_idx + PREFETCH_DIST], _MM_HINT_T0);
    //         _mm_prefetch(&real_vals_b[offsetB_idx + PREFETCH_DIST], _MM_HINT_T0);
    //         _mm_prefetch(&imag_vals_b[offsetB_idx + PREFETCH_DIST], _MM_HINT_T0);

    //         __m512d real_a = _mm512_loadu_pd(&real_vals_a[offsetA_idx]);
    //         __m512d imag_a = _mm512_loadu_pd(&imag_vals_a[offsetA_idx]);
    //         __m512d real_b = _mm512_loadu_pd(&real_vals_b[offsetB_idx]);
    //         __m512d imag_b = _mm512_loadu_pd(&imag_vals_b[offsetB_idx]);

    //         __m512d real_res = _mm512_fnmadd_pd(imag_a, imag_b, _mm512_mul_pd(real_a, real_b));  // real_res = (real_a * real_b) - (imag_a * imag_b)
    //         __m512d imag_res = _mm512_fmadd_pd(real_a, imag_b, _mm512_mul_pd(imag_a, real_b));  // imag_res = (real_a * imag_b) + (imag_a * real_b)

    //         _mm512_storeu_pd(&real_vals_final[idx], real_res);
    //         _mm512_storeu_pd(&imag_vals_final[idx], imag_res);
    //     }

    //     k += vec_loop * 8;

    //     if (left_overs != 0) {
    //         #pragma omp parallel for
    //         for (int i = 0; i < left_overs; ++i) {
    //             unsigned int idx_a = left_overs_start_at_A + i;
    //             unsigned int idx_b = left_overs_start_at_B + i;
    //             unsigned int idx_final = k + i;

    //             double real_a = real_vals_a[idx_a];
    //             double imag_a = imag_vals_a[idx_a];
    //             double real_b = real_vals_b[idx_b];
    //             double imag_b = imag_vals_b[idx_b];

    //             real_vals_final[idx_final] = (real_a * real_b) - (imag_a * imag_b);
    //             imag_vals_final[idx_final] = (real_a * imag_b) + (imag_a * real_b);
    //         }
    //     }

    //     #ifdef DEBUG
    //         auto end = std::chrono::high_resolution_clock::now();
    //         auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    //         printf("\t\trun_avx512 - Double took %f milliseconds\n", duration.count()/1000.0);
    //     #endif
        
    // }

    // ------------------------AVX512 FLOAT----------------------------------------
    __m512 avx512_load_partial_float(int n, const float* p) {
        // Create a mask based on the length 'n' of the array
        __mmask16 mask = (1 << n) - 1;
        // Load the array elements into the ZMM register using the mask
        __m512 zmm = _mm512_maskz_loadu_ps(mask, p);
        return zmm;
    }
    void avx512_store_partial_float(int n, float *loc, __m512 vec) {
        // Create a mask based on the length 'n' of the array
        __mmask16 mask = (1 << n) - 1;
        // Store the elements of the vector 'vec' into the array 'loc' using the mask
        _mm512_mask_storeu_ps(loc, mask, vec);
    }
    template<>
    void run_avx512<float>(
        unsigned int start, unsigned int end,
        unsigned int a_offset, unsigned int b_offset,
        float *real_vals_a, float *imag_vals_a,
        float *real_vals_b, float *imag_vals_b,
        float *real_vals_final, float *imag_vals_final, bool overwrite
    ) {
        #ifdef DEEP_DEBUG
            std::cout << "Starting run_avx512 float -- " << std::endl;
            auto start_time = std::chrono::high_resolution_clock::now();
        #endif

        // Find first aligned SIMD index
        unsigned int simd_start = start;
        for (; simd_start + VEC_WIDTH <= end; simd_start++) {
            if ((simd_start % VEC_WIDTH == 0) &&
                ((simd_start + a_offset) % VEC_WIDTH == 0) &&
                ((simd_start + b_offset) % VEC_WIDTH == 0)) {
                break;
            }
        }
        if (simd_start + VEC_WIDTH > end)
            simd_start = end; // no SIMD possible

        unsigned int simd_end = end - ((end - simd_start) % VEC_WIDTH);

        // --- Prologue (unaligned/scalar) ---
        #pragma omp parallel for
        for (unsigned int idx = start; idx < simd_start; ++idx) {
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;

            float real_a = real_vals_a[idx_a];
            float imag_a = imag_vals_a[idx_a];
            float real_b = real_vals_b[idx_b];
            float imag_b = imag_vals_b[idx_b];

            real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
        }

        // --- SIMD aligned main loop ---
        unsigned int simd_vec_blocks = (simd_end - simd_start) / VEC_WIDTH;

        #pragma omp parallel for
        for (unsigned int i = 0; i < simd_vec_blocks; ++i) {
            unsigned int idx   = simd_start + i * VEC_WIDTH;
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;

            _mm_prefetch(&real_vals_a[idx_a + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch(&imag_vals_a[idx_a + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch(&real_vals_b[idx_b + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch(&imag_vals_b[idx_b + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch(&real_vals_final[idx + PREFETCH_DIST], _MM_HINT_T0);
            _mm_prefetch(&imag_vals_final[idx + PREFETCH_DIST], _MM_HINT_T0);

            __m512 real_a = _mm512_load_ps(&real_vals_a[idx_a]);
            __m512 imag_a = _mm512_load_ps(&imag_vals_a[idx_a]);
            __m512 real_b = _mm512_load_ps(&real_vals_b[idx_b]);
            __m512 imag_b = _mm512_load_ps(&imag_vals_b[idx_b]);

            __m512 real_res = _mm512_fnmadd_ps(imag_a, imag_b, _mm512_mul_ps(real_a, real_b));
            __m512 imag_res = _mm512_fmadd_ps(real_a, imag_b, _mm512_mul_ps(imag_a, real_b));

            __m512 existing_real = _mm512_load_ps(&real_vals_final[idx]);
            __m512 existing_imag = _mm512_load_ps(&imag_vals_final[idx]);

            _mm512_store_ps(&real_vals_final[idx], _mm512_add_ps(existing_real, real_res));
            _mm512_store_ps(&imag_vals_final[idx], _mm512_add_ps(existing_imag, imag_res));
        }

        // --- Epilogue (unaligned/scalar) ---
        #pragma omp parallel for
        for (unsigned int idx = simd_end; idx < end; ++idx) {
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;

            float real_a = real_vals_a[idx_a];
            float imag_a = imag_vals_a[idx_a];
            float real_b = real_vals_b[idx_b];
            float imag_b = imag_vals_b[idx_b];

            real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
        }

        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_avx512 - Float took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }


    // SPMV for AVX
    template<typename valTypeTemplate>
    void run_spmv_avx512_1(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx512_2(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx512_0(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    // ------------------------AVX512 DOUBLE----------------------------------------
    template<>
    void run_spmv_avx512_1<double>(
        unsigned int simd_start, unsigned int simd_end,
        double *x_real_values, double *x_imag_values,
        double *real_vals, double *imag_vals,
        double *y_real_values, double *y_imag_values,
        int dIndex, unsigned int dLength) {

    #ifdef DEEP_DEBUG
        std::cout << "Starting run_spmv_avx512_1 - Aligned SIMD (w/ Prologue/Epilogue) --" << std::endl;
        auto start_time = std::chrono::high_resolution_clock::now();
    #endif

        // --- Prologue ---
        #pragma omp parallel for
        for (unsigned int i = 0; i < simd_start; ++i) {
            unsigned int y_index = i - dIndex;

            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[i];
            double x_i = x_imag_values[i];

            y_real_values[y_index] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[y_index] += (a_r * x_i) + (a_i * x_r);
        }

        // --- SIMD Main Loop with Blocking ---
        #pragma omp parallel for schedule(static)
        for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
            unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);

            for (unsigned int i = block_start; i + VEC_WIDTH <= block_end; i += VEC_WIDTH) {
                unsigned int y_index = i - dIndex;

                _mm_prefetch(&real_vals[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&x_real_values[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&y_real_values[y_index + PREFETCH_DIST], _MM_HINT_T0);

                __m512d a_r = _mm512_load_pd(&real_vals[i]);
                __m512d a_i = _mm512_load_pd(&imag_vals[i]);
                __m512d x_r = _mm512_load_pd(&x_real_values[i]);
                __m512d x_i = _mm512_load_pd(&x_imag_values[i]);

                __m512d y_r = _mm512_load_pd(&y_real_values[y_index]);
                __m512d y_i = _mm512_load_pd(&y_imag_values[y_index]);

                y_r = _mm512_fnmadd_pd(a_i, x_i, _mm512_fmadd_pd(a_r, x_r, y_r));
                y_i = _mm512_fmadd_pd(a_r, x_i, _mm512_fmadd_pd(a_i, x_r, y_i));

                _mm512_store_pd(&y_real_values[y_index], y_r);
                _mm512_store_pd(&y_imag_values[y_index], y_i);
            }
        }

        // --- Epilogue ---
        #pragma omp parallel for
        for (unsigned int i = simd_end; i < dLength; ++i) {
            unsigned int y_index = i - dIndex;

            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[i];
            double x_i = x_imag_values[i];

            y_real_values[y_index] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[y_index] += (a_r * x_i) + (a_i * x_r);
        }

        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_spmv_avx512_1 - Double (Blocked SIMD) took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }

    template<>
    void run_spmv_avx512_2<double>(
        unsigned int simd_start, unsigned int simd_end,
        double *x_real_values, double *x_imag_values,
        double *real_vals, double *imag_vals,
        double *y_real_values, double *y_imag_values,
        int dIndex, unsigned int dLength) {
    
    #ifdef DEEP_DEBUG
        std::cout << "Starting run_spmv_avx512_2 - Aligned SIMD (w/ Prologue/Epilogue) --" << std::endl;
        auto start_time = std::chrono::high_resolution_clock::now();
    #endif
    
        // --- Prologue ---
        #pragma omp parallel for
        for (unsigned int i = 0; i < simd_start; ++i) {
            unsigned int x_index = i + dIndex;
    
            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[x_index];
            double x_i = x_imag_values[x_index];
    
            y_real_values[i] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
        }
    
        // --- SIMD Main Loop with Blocking ---
        #pragma omp parallel for schedule(static)
        for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
            unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);
    
            for (unsigned int i = block_start; i + VEC_WIDTH <= block_end; i += VEC_WIDTH) {
                unsigned int x_index = i + dIndex;
    
                _mm_prefetch(&real_vals[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&x_real_values[x_index + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&y_real_values[i + PREFETCH_DIST], _MM_HINT_T0);
    
                __m512d a_r = _mm512_load_pd(&real_vals[i]);
                __m512d a_i = _mm512_load_pd(&imag_vals[i]);
                __m512d x_r = _mm512_load_pd(&x_real_values[x_index]);
                __m512d x_i = _mm512_load_pd(&x_imag_values[x_index]);
    
                __m512d y_r = _mm512_load_pd(&y_real_values[i]);
                __m512d y_i = _mm512_load_pd(&y_imag_values[i]);
    
                y_r = _mm512_fmadd_pd(a_r, x_r, _mm512_fnmadd_pd(a_i, x_i, y_r));
                y_i = _mm512_fmadd_pd(a_r, x_i, _mm512_fmadd_pd(a_i, x_r, y_i));
    
                _mm512_store_pd(&y_real_values[i], y_r);
                _mm512_store_pd(&y_imag_values[i], y_i);
            }
        }
    
        // --- Epilogue ---
        #pragma omp parallel for
        for (unsigned int i = simd_end; i < dLength; ++i) {
            unsigned int x_index = i + dIndex;
    
            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[x_index];
            double x_i = x_imag_values[x_index];
    
            y_real_values[i] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
        }
    
        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_spmv_avx512_2 - Double (Blocked SIMD) took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }

    template<>
    void run_spmv_avx512_0<double>(
        unsigned int simd_start, unsigned int simd_end,
        double *x_real_values, double *x_imag_values,
        double *real_vals, double *imag_vals,
        double *y_real_values, double *y_imag_values,
        int dIndex, unsigned int dLength) {
    
        #ifdef DEEP_DEBUG
            std::cout << "Starting run_spmv_avx512_0 - SIMD aligned version --" << std::endl;
            auto start_time = std::chrono::high_resolution_clock::now();
        #endif
    
        // --- Prologue ---
        #pragma omp parallel for
        for (unsigned int i = 0; i < simd_start; ++i) {
            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[i];
            double x_i = x_imag_values[i];
    
            y_real_values[i] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
        }
    
        // --- SIMD aligned loop with blocking ---
        #pragma omp parallel for schedule(static)
        for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
            unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);
    
            for (unsigned int i = block_start; i + VEC_WIDTH <= block_end; i += VEC_WIDTH) {
                _mm_prefetch(&real_vals[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&x_real_values[i + PREFETCH_DIST], _MM_HINT_T0);
                _mm_prefetch(&y_real_values[i + PREFETCH_DIST], _MM_HINT_T0);
    
                __m512d a_r = _mm512_load_pd(&real_vals[i]);
                __m512d a_i = _mm512_load_pd(&imag_vals[i]);
                __m512d x_r = _mm512_load_pd(&x_real_values[i]);
                __m512d x_i = _mm512_load_pd(&x_imag_values[i]);
                __m512d y_r = _mm512_load_pd(&y_real_values[i]);
                __m512d y_i = _mm512_load_pd(&y_imag_values[i]);
    
                y_r = _mm512_fnmadd_pd(a_i, x_i, _mm512_fmadd_pd(a_r, x_r, y_r));
                y_i = _mm512_fmadd_pd(a_r, x_i, _mm512_fmadd_pd(a_i, x_r, y_i));
    
                _mm512_store_pd(&y_real_values[i], y_r);
                _mm512_store_pd(&y_imag_values[i], y_i);
            }
        }
    
        // --- Epilogue ---
        #pragma omp parallel for
        for (unsigned int i = simd_end; i < dLength; ++i) {
            double a_r = real_vals[i];
            double a_i = imag_vals[i];
            double x_r = x_real_values[i];
            double x_i = x_imag_values[i];
    
            y_real_values[i] += (a_r * x_r) - (a_i * x_i);
            y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
        }
    
        #ifdef DEEP_DEBUG
            auto end_time = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
            printf("\t\trun_spmv_avx512_0 - Double (Blocked SIMD) took %f milliseconds\n", duration.count() / 1000.0);
        #endif
    }
    

    // // ------------------------AVX512 FLOAT----------------------------------------
    // template<>
    // void run_spmv_avx512_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_avx512_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_avx512_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength) {
    //     // TODO
    // }

#endif

bool diagonal::isEmpty() {
	bool found_nonzero = false;

	#pragma omp parallel
	{
		bool local_found = false;

		#pragma omp for nowait
		for (unsigned int i = 0; i < dLength; ++i) {
			if (found_nonzero || local_found) continue;

			if (realValues[i] != 0.0 || imagValues[i] != 0.0) {
				local_found = true;
			}
		}

		if (local_found) {
			#pragma omp atomic write
			found_nonzero = true;
		}
	}

	return !found_nonzero;
}

} // namespace diaq