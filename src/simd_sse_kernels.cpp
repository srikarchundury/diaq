#include "simd_sse_kernels.hpp"

namespace diaq {

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

} // namespace diaq