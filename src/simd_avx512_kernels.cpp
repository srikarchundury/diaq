#include "simd_avx512_kernels.hpp"

namespace diaq {

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
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
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
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        std::chrono::microseconds duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
        printf("\t\trun_avx512 - Double (Blocked SIMD) took %f milliseconds\n", duration.count() / 1000.0);
    #endif
}

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
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
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
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count();
        printf("\t\trun_avx512 - Float took %f milliseconds\n", duration / 1000.0);
    #endif
}

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
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
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
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count();
        printf("\t\trun_spmv_avx512_1 - Double (Blocked SIMD) took %f milliseconds\n", duration / 1000.0);
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
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
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
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count();
        printf("\t\trun_spmv_avx512_2 - Double (Blocked SIMD) took %f milliseconds\n", duration / 1000.0);
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
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
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
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count();
        printf("\t\trun_spmv_avx512_0 - Double (Blocked SIMD) took %f milliseconds\n", duration / 1000.0);
    #endif
}

} // namespace diaq