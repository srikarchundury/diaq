#include "simd_avx2_kernels.hpp"

namespace diaq {

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
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
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
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        std::chrono::microseconds duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
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
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
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
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        std::chrono::microseconds duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
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
    unsigned int start, unsigned int end,
    double *x_real_values, double *x_imag_values,
    double *real_vals, double *imag_vals,
    double *y_real_values, double *y_imag_values,
    int dIndex, unsigned int dLength) {

    #ifdef DEEP_DEBUG
        std::cout << "Starting run_spmv_avx_1 - Aligned SIMD (w/ Prologue/Epilogue) --" << std::endl;
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    #endif

    // Compute SIMD-aligned sub-range within [start, end). dIndex < 0 here.
    // Need i % 4 == 0 and (i - dIndex) % 4 == 0; since dIndex is negative,
    // (i - dIndex) = i + |dIndex|, computed safely via unsigned arithmetic.
    unsigned int simd_start = start;
    for (; simd_start + 4 <= end; ++simd_start) {
        if ((simd_start % 4 == 0) && ((simd_start - (unsigned int)dIndex) % 4 == 0)) break;
    }
    if (simd_start + 4 > end) simd_start = end;
    unsigned int simd_end = end - ((end - simd_start) % 4);

    // --- Prologue [start, simd_start) ---
    #pragma omp parallel for
    for (unsigned int i = start; i < simd_start; ++i) {
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

    // --- Epilogue [simd_end, end) ---
    #pragma omp parallel for
    for (unsigned int i = simd_end; i < end; ++i) {
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
        printf("\t\trun_spmv_avx_1 - Double (Blocked SIMD) took %f milliseconds\n", duration / 1000.0);
    #endif
}
template<>
void run_spmv_avx_2<double>(
    unsigned int start, unsigned int end,
    double *x_real_values, double *x_imag_values,
    double *real_vals, double *imag_vals,
    double *y_real_values, double *y_imag_values,
    int dIndex, unsigned int dLength) {

    #ifdef DEEP_DEBUG
        std::cout << "Starting run_spmv_avx_2 - Aligned SIMD (w/ Prologue/Epilogue) --" << std::endl;
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    #endif

    // Compute SIMD-aligned sub-range within [start, end). dIndex > 0 here.
    // Need i % 4 == 0 and (i + dIndex) % 4 == 0; both satisfied when dIndex % 4 == 0.
    unsigned int simd_start = start;
    for (; simd_start + 4 <= end; ++simd_start) {
        if ((simd_start % 4 == 0) && ((simd_start + (unsigned int)dIndex) % 4 == 0)) break;
    }
    if (simd_start + 4 > end) simd_start = end;
    unsigned int simd_end = end - ((end - simd_start) % 4);

    // --- Prologue [start, simd_start) ---
    #pragma omp parallel for
    for (unsigned int i = start; i < simd_start; ++i) {
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

    // --- Epilogue [simd_end, end) ---
    #pragma omp parallel for
    for (unsigned int i = simd_end; i < end; ++i) {
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
        printf("\t\trun_spmv_avx_2 - Double (Blocked SIMD) took %f milliseconds\n", duration / 1000.0);
    #endif
}

template<>
void run_spmv_avx_0<double>(
    unsigned int start, unsigned int end,
    double *x_real_values, double *x_imag_values,
    double *real_vals, double *imag_vals,
    double *y_real_values, double *y_imag_values,
    int dIndex, unsigned int dLength) {

    #ifdef DEEP_DEBUG
        std::cout << "Starting run_spmv_avx_0 - SIMD aligned version --" << std::endl;
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    #endif

    // Compute SIMD-aligned sub-range within [start, end). dIndex == 0 here.
    // Need i % 4 == 0; alignment always achievable.
    unsigned int simd_start = start;
    for (; simd_start + 4 <= end; ++simd_start) {
        if (simd_start % 4 == 0) break;
    }
    if (simd_start + 4 > end) simd_start = end;
    unsigned int simd_end = end - ((end - simd_start) % 4);

    // --- Prologue [start, simd_start) ---
    #pragma omp parallel for
    for (unsigned int i = start; i < simd_start; ++i) {
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

    // --- Epilogue [simd_end, end) ---
    #pragma omp parallel for
    for (unsigned int i = simd_end; i < end; ++i) {
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
        printf("\t\trun_spmv_avx_0 - Double (Blocked SIMD) took %f milliseconds\n", duration / 1000.0);
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

} // namespace diaq