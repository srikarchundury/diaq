#include "simd_kernels.hpp"
#include "diagonal.hpp"

namespace diaq {

void run_without_vectorization(unsigned long int k, unsigned long int lenRes, unsigned long int offsetA, unsigned long int offsetB, unsigned long int jump, unsigned long int lenDiagA, unsigned long int lenDiagB, valType *real_vals_a, valType *imag_vals_a, valType *real_vals_b, valType *imag_vals_b, valType *real_vals_final, valType *imag_vals_final) {
    // no vectorization
    // logger.log("No vectorization");
    #ifdef DEBUG
        std::cout << "No vectorization" << std::endl;
    #endif
    // #pragma omp simd; this does not work as is!
    while(k < lenRes && k + offsetA - jump < lenDiagA && k + offsetB - jump < lenDiagB) {
        // std::cout << "loop k=" << k << std::endl;
		valType real_a = real_vals_a[k + offsetA - jump];
        valType imag_a = imag_vals_a[k + offsetA - jump];
        valType real_b = real_vals_b[k + offsetB - jump];
        valType imag_b = imag_vals_b[k + offsetB - jump];
		real_vals_final[k] = (valType)((valType)(real_a * real_b) - (valType)(imag_a * imag_b));
		imag_vals_final[k] = (valType)((valType)(real_a * imag_b) + (valType)(imag_a * real_b));
        k += 1;
    }
}

// ----------------------------------------------------------------
//
// SIMD - SSE for valType = float, AVX for valType = double
//
// ----------------------------------------------------------------
#ifdef __AVX__
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
    void run_avx<double>(unsigned long int k, unsigned long int lenRes, unsigned long int offsetA, unsigned long int offsetB, unsigned long int jump, unsigned long int lenDiagA, unsigned long int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final) {

        #ifdef DEEP_DEBUG
            std::cout << "Using AVX-Double vectorization" << std::endl;
        #endif

        // unsigned long int loop_count = 0;
        // unsigned long int k_cpy = k;
        // while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
        //     loop_count++;
        //     k_cpy++;
        // }

        unsigned long int max_lenRes = lenRes - k;
        unsigned long int max_lenDiagA = lenDiagA - (k + offsetA - jump);
        unsigned long int max_lenDiagB = lenDiagB - (k + offsetB - jump);

        unsigned long int loop_count = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});

        __m256d real_a, real_b; // a for valuesA and b for valuesB
        __m256d imag_a, imag_b; // a for valuesA and b for valuesB
        __m256d real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        int left_overs = loop_count - ((loop_count / 4) * 4);
        unsigned long int vec_loop = (loop_count / 4);
        unsigned long int left_overs_start_at_A = k + offsetA - jump + 4 * (loop_count / 4);
        unsigned long int left_overs_start_at_B = k + offsetB - jump + 4 * (loop_count / 4);

        while (vec_loop--) {
            real_a = _mm256_loadu_pd(&real_vals_a[k + offsetA - jump]);
            imag_a = _mm256_loadu_pd(&imag_vals_a[k + offsetA - jump]);
            real_b = _mm256_loadu_pd(&real_vals_b[k + offsetB - jump]);
            imag_b = _mm256_loadu_pd(&imag_vals_b[k + offsetB - jump]);

            real_reala_realb = _mm256_mul_pd(real_a, real_b);
            real_imaga_imagb = _mm256_mul_pd(imag_a, imag_b);
            real_res = _mm256_sub_pd(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm256_mul_pd(real_a, imag_b);
            imag_imaga_realb = _mm256_mul_pd(imag_a, real_b);
            imag_res = _mm256_add_pd(imag_reala_imagb, imag_imaga_realb);

            _mm256_storeu_pd(&real_vals_final[k], real_res);
            _mm256_storeu_pd(&imag_vals_final[k], imag_res);

            k += 4;
        }
        if (left_overs != 0) {
            real_a = avx_load_partial_double(left_overs, &real_vals_a[left_overs_start_at_A]);
            imag_a = avx_load_partial_double(left_overs, &imag_vals_a[left_overs_start_at_A]);
            real_b = avx_load_partial_double(left_overs, &real_vals_b[left_overs_start_at_B]);
            imag_b = avx_load_partial_double(left_overs, &imag_vals_b[left_overs_start_at_B]);

            real_reala_realb = _mm256_mul_pd(real_a, real_b);
            real_imaga_imagb = _mm256_mul_pd(imag_a, imag_b);
            real_res = _mm256_sub_pd(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm256_mul_pd(real_a, imag_b);
            imag_imaga_realb = _mm256_mul_pd(imag_a, real_b);
            imag_res = _mm256_add_pd(imag_reala_imagb, imag_imaga_realb);

            avx_store_partial_double(left_overs, &real_vals_final[k], real_res);
            avx_store_partial_double(left_overs, &imag_vals_final[k], imag_res);

            // k += left_overs;
        }
    }
    // ------------------------AVX FLOAT----------------------------------------
    __m256 avx_load_partial_float(int n, const float* p) {
        // Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi32(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        // int maskValue = (1 << n) - 1;
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
    void run_avx<float>(unsigned long int k, unsigned long int lenRes, unsigned long int offsetA, unsigned long int offsetB, unsigned long int jump, unsigned long int lenDiagA, unsigned long int lenDiagB, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final) {

        #ifdef DEEP_DEBUG
            std::cout << "Using AVX-Float vectorization" << std::endl;
        #endif
        
        // // logger.log("Using AVX-Float vectorization");
        // // printf("Using AVX-Float vectorization\n");
        // unsigned long int loop_count = 0;
        // unsigned long int k_cpy = k;
        // while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
        //     loop_count++;
        //     k_cpy++;
        // }

        unsigned long int max_lenRes = lenRes - k;
        unsigned long int max_lenDiagA = lenDiagA - (k + offsetA - jump);
        unsigned long int max_lenDiagB = lenDiagB - (k + offsetB - jump);

        unsigned long int loop_count = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});

        __m256 real_a, real_b; // a for valuesA and b for valuesB
        __m256 imag_a, imag_b; // a for valuesA and b for valuesB
        __m256 real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        int left_overs = loop_count - ((loop_count / 8) * 8);
        unsigned long int vec_loop = (loop_count / 8);
        unsigned long int left_overs_start_at_A = k + offsetA - jump + 8 * (loop_count / 8);
        unsigned long int left_overs_start_at_B = k + offsetB - jump + 8 * (loop_count / 8);

        // printf("k = %ld, lenRes = %ld, offsetA = %ld, offsetB = %ld, jump = %ld, lenDiagA = %ld, lenDiagB = %ld, loop_count = %ld, left_overs = %ld, vec_loop = %ld, left_overs_start_at_A = %ld, left_overs_start_at_B = %ld\n", k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, loop_count, left_overs, vec_loop, left_overs_start_at_A, left_overs_start_at_B);

        while (vec_loop--) {
            // printf("test here 1\n");
            real_a = _mm256_loadu_ps(&real_vals_a[k + offsetA - jump]);
            imag_a = _mm256_loadu_ps(&imag_vals_a[k + offsetA - jump]);
            real_b = _mm256_loadu_ps(&real_vals_b[k + offsetB - jump]);
            imag_b = _mm256_loadu_ps(&imag_vals_b[k + offsetB - jump]);

            // printf("test here 2\n");

            real_reala_realb = _mm256_mul_ps(real_a, real_b);
            real_imaga_imagb = _mm256_mul_ps(imag_a, imag_b);
            real_res = _mm256_sub_ps(real_reala_realb, real_imaga_imagb);

            // printf("test here 3\n");

            imag_reala_imagb = _mm256_mul_ps(real_a, imag_b);
            imag_imaga_realb = _mm256_mul_ps(imag_a, real_b);
            imag_res = _mm256_add_ps(imag_reala_imagb, imag_imaga_realb);

            // printf("test here 4\n");

            avx_store_partial_float(8, &real_vals_final[k], real_res);
            avx_store_partial_float(8, &imag_vals_final[k], imag_res);

            // printf("test here 5\n");

            // printing real_res, imag_res
            // float *real_res_ptr = (float *)&real_res;
            // float *imag_res_ptr = (float *)&imag_res;
            // printf("real_res = [%f, %f, %f, %f, %f, %f, %f, %f]\n", real_res_ptr[0], real_res_ptr[1], real_res_ptr[2], real_res_ptr[3], real_res_ptr[4], real_res_ptr[5], real_res_ptr[6], real_res_ptr[7]);
            // printf("imag_res = [%f, %f, %f, %f, %f, %f, %f, %f]\n", imag_res_ptr[0], imag_res_ptr[1], imag_res_ptr[2], imag_res_ptr[3], imag_res_ptr[4], imag_res_ptr[5], imag_res_ptr[6], imag_res_ptr[7]);

            k += 8;
        }
        if (left_overs != 0) {
            real_a = avx_load_partial_float(left_overs, &real_vals_a[left_overs_start_at_A]);
            imag_a = avx_load_partial_float(left_overs, &imag_vals_a[left_overs_start_at_A]);
            real_b = avx_load_partial_float(left_overs, &real_vals_b[left_overs_start_at_B]);
            imag_b = avx_load_partial_float(left_overs, &imag_vals_b[left_overs_start_at_B]);

            real_reala_realb = _mm256_mul_ps(real_a, real_b);
            real_imaga_imagb = _mm256_mul_ps(imag_a, imag_b);
            real_res = _mm256_sub_ps(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm256_mul_ps(real_a, imag_b);
            imag_imaga_realb = _mm256_mul_ps(imag_a, real_b);
            imag_res = _mm256_add_ps(imag_reala_imagb, imag_imaga_realb);

            avx_store_partial_float(left_overs, &real_vals_final[k], real_res);
            avx_store_partial_float(left_overs, &imag_vals_final[k], imag_res);

            // k += left_overs;
        }
    }

    // SPMV for AVX
    template<typename valTypeTemplate>
    void run_spmv_avx_1(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, unsigned long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx_2(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, unsigned long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx_0(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, unsigned long int dLength);

    // ------------------------AVX DOUBLE----------------------------------------
    template<>
    void run_spmv_avx_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, unsigned long int dLength) {

        #ifdef DEBUG
            std::cout << "run_spmv_avx_1 - Double" << std::endl;
        #endif

        // printf("run_spmv_avx_1 - Double\n");
        unsigned long int vec_loop = dLength / 4;
        int left_overs = dLength % 4;

        __m256d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned long int i = 0; i < vec_loop * 4; i += 4) {
            real_vals_vec = _mm256_load_pd(&real_vals[i]);
            imag_vals_vec = _mm256_load_pd(&imag_vals[i]);
            x_real_vals_vec = _mm256_load_pd(&x_real_values[i]);
            x_imag_vals_vec = _mm256_load_pd(&x_imag_values[i]);

            y_real_vals_vec = _mm256_loadu_pd(&y_real_values[i - dIndex]);
            y_imag_vals_vec = _mm256_loadu_pd(&y_imag_values[i - dIndex]);

            y_real_vals_vec = _mm256_add_pd(y_real_vals_vec, _mm256_sub_pd(_mm256_mul_pd(real_vals_vec, x_real_vals_vec), _mm256_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm256_add_pd(y_imag_vals_vec, _mm256_add_pd(_mm256_mul_pd(real_vals_vec, x_imag_vals_vec), _mm256_mul_pd(imag_vals_vec, x_real_vals_vec)));

            _mm256_storeu_pd(&y_real_values[i - dIndex], y_real_vals_vec);
            _mm256_storeu_pd(&y_imag_values[i - dIndex], y_imag_vals_vec);
        }

        if(left_overs != 0) {
            unsigned long int left_overs_start_at = vec_loop * 4;
            real_vals_vec = avx_load_partial_double(left_overs, &real_vals[left_overs_start_at]);
            imag_vals_vec = avx_load_partial_double(left_overs, &imag_vals[left_overs_start_at]);
            x_real_vals_vec = avx_load_partial_double(left_overs, &x_real_values[left_overs_start_at]);
            x_imag_vals_vec = avx_load_partial_double(left_overs, &x_imag_values[left_overs_start_at]);
            y_real_vals_vec = avx_load_partial_double(left_overs, &y_real_values[left_overs_start_at - dIndex]);
            y_imag_vals_vec = avx_load_partial_double(left_overs, &y_imag_values[left_overs_start_at - dIndex]);

            y_real_vals_vec = _mm256_add_pd(y_real_vals_vec, _mm256_sub_pd(_mm256_mul_pd(real_vals_vec, x_real_vals_vec), _mm256_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm256_add_pd(y_imag_vals_vec, _mm256_add_pd(_mm256_mul_pd(real_vals_vec, x_imag_vals_vec), _mm256_mul_pd(imag_vals_vec, x_real_vals_vec)));

            avx_store_partial_double(left_overs, &y_real_values[left_overs_start_at - dIndex], y_real_vals_vec);
            avx_store_partial_double(left_overs, &y_imag_values[left_overs_start_at - dIndex], y_imag_vals_vec);
        }
    }
    template<>
    void run_spmv_avx_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, unsigned long int dLength) {

        // printf("run_spmv_avx_2 - Double\n");'

        #ifdef DEBUG
            std::cout << "run_spmv_avx_2 - Double" << std::endl;
        #endif

        // // cross checking with non-simd version
        // double *temp_real = new double[dLength];
        // double *temp_imag = new double[dLength];
        // for(long int i = 0; i < dLength; i++) {
        //     temp_real[i] = y_real_values[i];
        //     temp_imag[i] = y_imag_values[i];
        // }

        unsigned long int vec_loop = dLength / 4;
        int left_overs = dLength % 4;

        // printf("vec_loop = %ld, left_overs = %ld, dIndex = %ld, dLength = %ld\n", vec_loop, left_overs, dIndex, dLength);

        __m256d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned long int i = 0; i < vec_loop * 4; i += 4) {
            real_vals_vec = _mm256_load_pd(&real_vals[i]);
            imag_vals_vec = _mm256_load_pd(&imag_vals[i]);

            x_real_vals_vec = _mm256_loadu_pd(&x_real_values[dIndex + i]);
            x_imag_vals_vec = _mm256_loadu_pd(&x_imag_values[dIndex + i]);

            y_real_vals_vec = _mm256_load_pd(&y_real_values[i]);
            y_imag_vals_vec = _mm256_load_pd(&y_imag_values[i]);

            y_real_vals_vec = _mm256_add_pd(y_real_vals_vec, _mm256_sub_pd(_mm256_mul_pd(real_vals_vec, x_real_vals_vec), _mm256_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm256_add_pd(y_imag_vals_vec, _mm256_add_pd(_mm256_mul_pd(real_vals_vec, x_imag_vals_vec), _mm256_mul_pd(imag_vals_vec, x_real_vals_vec)));

            _mm256_store_pd(&y_real_values[i], y_real_vals_vec);
            _mm256_store_pd(&y_imag_values[i], y_imag_vals_vec);
        }

        if(left_overs != 0) {
            unsigned long int left_overs_start_at = vec_loop * 4;
            real_vals_vec = avx_load_partial_double(left_overs, &real_vals[left_overs_start_at]);
            imag_vals_vec = avx_load_partial_double(left_overs, &imag_vals[left_overs_start_at]);
            x_real_vals_vec = avx_load_partial_double(left_overs, &x_real_values[dIndex + left_overs_start_at]);
            x_imag_vals_vec = avx_load_partial_double(left_overs, &x_imag_values[dIndex + left_overs_start_at]);
            y_real_vals_vec = avx_load_partial_double(left_overs, &y_real_values[left_overs_start_at]);
            y_imag_vals_vec = avx_load_partial_double(left_overs, &y_imag_values[left_overs_start_at]);

            y_real_vals_vec = _mm256_add_pd(y_real_vals_vec, _mm256_sub_pd(_mm256_mul_pd(real_vals_vec, x_real_vals_vec), _mm256_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm256_add_pd(y_imag_vals_vec, _mm256_add_pd(_mm256_mul_pd(real_vals_vec, x_imag_vals_vec), _mm256_mul_pd(imag_vals_vec, x_real_vals_vec)));

            avx_store_partial_double(left_overs, &y_real_values[left_overs_start_at], y_real_vals_vec);
            avx_store_partial_double(left_overs, &y_imag_values[left_overs_start_at], y_imag_vals_vec);
        }
        // // printing y_real_values, y_imag_values in single line
        // printf("y_real_values = [");
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     printf("%f, ", y_real_values[i]);
        // }
        // printf("]\n");
        // printf("y_imag_values = [");
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     printf("%f, ", y_imag_values[i]);
        // }
        // printf("]\n");
        
        // #pragma omp simd
        // for (unsigned long int i = 0; i < dLength; i++) {
        //     unsigned long int x_idx = dIndex + i;
        //     unsigned long int y_idx = i;
        //     temp_real[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
        //     temp_imag[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        // }
        // printf("temp_real = [");
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     printf("%f, ", temp_real[i]);
        // }
        // printf("]\n");
        // printf("temp_imag = [");
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     printf("%f, ", temp_imag[i]);
        // }
        // printf("]\n");
        // // write a quick check to see if temp_real and y_real_values are same and temp_imag and y_imag_values are same
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     if(temp_real[i] != y_real_values[i]) {
        //         printf("temp_real[%ld] = %f, y_real_values[%ld] = %f\n", i, temp_real[i], i, y_real_values[i]);
        //     }
        //     if(temp_imag[i] != y_imag_values[i]) {
        //         printf("temp_imag[%ld] = %f, y_imag_values[%ld] = %f\n", i, temp_imag[i], i, y_imag_values[i]);
        //     }
        // }
    }

    template<>
    void run_spmv_avx_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, unsigned long int dLength) {

        #ifdef DEBUG
            std::cout << "run_spmv_avx_0 - Double" << std::endl;
        #endif

        // printf("run_spmv_avx_0 - Double\n");
        unsigned long int vec_loop = dLength / 4;
        int left_overs = dLength % 4;

        __m256d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned long int i = 0; i < vec_loop * 4; i += 4) {
            real_vals_vec = _mm256_load_pd(&real_vals[i]);
            imag_vals_vec = _mm256_load_pd(&imag_vals[i]);
            x_real_vals_vec = _mm256_load_pd(&x_real_values[i]);
            x_imag_vals_vec = _mm256_load_pd(&x_imag_values[i]);
            y_real_vals_vec = _mm256_load_pd(&y_real_values[i]);
            y_imag_vals_vec = _mm256_load_pd(&y_imag_values[i]);

            y_real_vals_vec = _mm256_add_pd(y_real_vals_vec, _mm256_sub_pd(_mm256_mul_pd(real_vals_vec, x_real_vals_vec), _mm256_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm256_add_pd(y_imag_vals_vec, _mm256_add_pd(_mm256_mul_pd(real_vals_vec, x_imag_vals_vec), _mm256_mul_pd(imag_vals_vec, x_real_vals_vec)));

            _mm256_store_pd(&y_real_values[i], y_real_vals_vec);
            _mm256_store_pd(&y_imag_values[i], y_imag_vals_vec);
        }

        if(left_overs != 0) {
            unsigned long int left_overs_start_at = vec_loop * 4;
            real_vals_vec = avx_load_partial_double(left_overs, &real_vals[left_overs_start_at]);
            imag_vals_vec = avx_load_partial_double(left_overs, &imag_vals[left_overs_start_at]);
            x_real_vals_vec = avx_load_partial_double(left_overs, &x_real_values[left_overs_start_at]);
            x_imag_vals_vec = avx_load_partial_double(left_overs, &x_imag_values[left_overs_start_at]);
            y_real_vals_vec = avx_load_partial_double(left_overs, &y_real_values[left_overs_start_at]);
            y_imag_vals_vec = avx_load_partial_double(left_overs, &y_imag_values[left_overs_start_at]);

            y_real_vals_vec = _mm256_add_pd(y_real_vals_vec, _mm256_sub_pd(_mm256_mul_pd(real_vals_vec, x_real_vals_vec), _mm256_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm256_add_pd(y_imag_vals_vec, _mm256_add_pd(_mm256_mul_pd(real_vals_vec, x_imag_vals_vec), _mm256_mul_pd(imag_vals_vec, x_real_vals_vec)));

            avx_store_partial_double(left_overs, &y_real_values[left_overs_start_at], y_real_vals_vec);
            avx_store_partial_double(left_overs, &y_imag_values[left_overs_start_at], y_imag_vals_vec);
        }
    }

    // // ------------------------AVX FLOAT----------------------------------------
    // template<>
    // void run_spmv_avx_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, unsigned long int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_avx_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, unsigned long int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_avx_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, unsigned long int dLength) {
    //     // TODO
    // }
    
#endif

#ifdef __SSE__
    template<typename valTypeTemplate>
    void run_sse(unsigned long int k, unsigned long int lenRes, unsigned long int offsetA, unsigned long int offsetB, unsigned long int jump, unsigned long int lenDiagA, unsigned long int lenDiagB, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final);

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
        #pragma unroll
        for(int i = 0; i < n; i++){
            loc[i] = vec[i];
        }
    }
    template<>
    void run_sse<float>(unsigned long int k, unsigned long int lenRes, unsigned long int offsetA, unsigned long int offsetB, unsigned long int jump, unsigned long int lenDiagA, unsigned long int lenDiagB, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final) {

        #ifdef DEEP_DEBUG
            std::cout << "Using SSE-Float vectorization" << std::endl;
        #endif
        
        // unsigned long int loop_count = 0;
        // unsigned long int k_cpy = k;
        // while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
        //     loop_count++;
        //     k_cpy++;
        // }

        unsigned long int max_lenRes = lenRes - k;
        unsigned long int max_lenDiagA = lenDiagA - (k + offsetA - jump);
        unsigned long int max_lenDiagB = lenDiagB - (k + offsetB - jump);

        unsigned long int loop_count = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});

        __m128 real_a, real_b; // a for valuesA and b for valuesB
        __m128 imag_a, imag_b; // a for valuesA and b for valuesB
        __m128 real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        int left_overs = loop_count - ((loop_count / 4) * 4);
        unsigned long int vec_loop = (loop_count / 4);
        unsigned long int left_overs_start_at_A = k + offsetA - jump + 4 * (loop_count / 4);
        unsigned long int left_overs_start_at_B = k + offsetB - jump + 4 * (loop_count / 4);

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
    void run_sse<double>(unsigned long int k, unsigned long int lenRes, unsigned long int offsetA, unsigned long int offsetB, unsigned long int jump, unsigned long int lenDiagA, unsigned long int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final) {

        #ifdef DEEP_DEBUG
            std::cout << "Using SSE-Double vectorization" << std::endl;
        #endif

        // unsigned long int loop_count = 0;
        // unsigned long int k_cpy = k;
        // while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
        //     loop_count++;
        //     k_cpy++;
        // }

        unsigned long int max_lenRes = lenRes - k;
        unsigned long int max_lenDiagA = lenDiagA - (k + offsetA - jump);
        unsigned long int max_lenDiagB = lenDiagB - (k + offsetB - jump);

        unsigned long int loop_count = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});

        __m128d real_a, real_b; // a for valuesA and b for valuesB
        __m128d imag_a, imag_b; // a for valuesA and b for valuesB
        __m128d real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        int left_overs = loop_count - ((loop_count / 2) * 2);
        unsigned long int vec_loop = (loop_count / 2);
        // unsigned long int left_overs_start_at_A = k + offsetA - jump + 2 * (loop_count / 2);
        // unsigned long int left_overs_start_at_B = k + offsetB - jump + 2 * (loop_count / 2);

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
    }

    // SPMV for SSE
    template<typename valTypeTemplate>
    void run_spmv_sse_1(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, unsigned long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_sse_2(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, unsigned long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_sse_0(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, unsigned long int dLength);

    // // ------------------------SSE FLOAT----------------------------------------
    // template<>
    // void run_spmv_sse_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, unsigned long int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_sse_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, unsigned long int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_sse_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, unsigned long int dLength) {
    //     // TODO
    // }

    // ------------------------SSE DOUBLE----------------------------------------
    template<>
    void run_spmv_sse_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, unsigned long int dLength) {

        #ifdef DEBUG
            std::cout << "run_spmv_sse_1 - Double" << std::endl;
        #endif

        unsigned long int vec_loop = dLength / 2;
        // int left_overs = dLength % 2;

        __m128d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned long int i = 0; i < vec_loop; i += 2) {
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

        for (unsigned long int i = vec_loop * 2; i < dLength; i++) {
            unsigned long int x_idx = i;
            unsigned long int y_idx = i - dIndex;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        }
    }
    template<>
    void run_spmv_sse_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, unsigned long int dLength) {

        #ifdef DEBUG
            std::cout << "run_spmv_sse_2 - Double" << std::endl;
        #endif

        unsigned long int vec_loop = dLength / 2;
        // int left_overs = dLength % 2;

        __m128d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned long int i = 0; i < vec_loop; i += 2) {
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

        for (unsigned long int i = vec_loop * 2; i < dLength; i++) {
            unsigned long int x_idx = dIndex + i;
            unsigned long int y_idx = i;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        }
    }
    template<>
    void run_spmv_sse_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, unsigned long int dLength) {

        #ifdef DEBUG
            std::cout << "run_spmv_sse_0 - Double" << std::endl;
        #endif

        unsigned long int vec_loop = dLength / 2;
        // int left_overs = dLength % 2;

        __m128d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned long int i = 0; i < vec_loop; i += 2) {
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

        for (unsigned long int i = vec_loop * 2; i < dLength; i++) {
            unsigned long int x_idx = i;
            unsigned long int y_idx = i;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        }
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
    void run_avx512<double>(unsigned long int k, unsigned long int lenRes, unsigned long int offsetA, unsigned long int offsetB, unsigned long int jump, unsigned long int lenDiagA, unsigned long int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final) {

        #ifdef DEEP_DEBUG
            std::cout << "Using AVX512-Double vectorization" << std::endl;
        #endif

        // unsigned long int loop_count = 0;
        // unsigned long int k_cpy = k;
        // while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
        //     loop_count++;
        //     k_cpy++;
        // }

        unsigned long int max_lenRes = lenRes - k;
        unsigned long int max_lenDiagA = lenDiagA - (k + offsetA - jump);
        unsigned long int max_lenDiagB = lenDiagB - (k + offsetB - jump);
        unsigned long int loop_count = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});

        __m512d real_a, real_b; // a for valuesA and b for valuesB
        __m512d imag_a, imag_b; // a for valuesA and b for valuesB
        __m512d real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        int left_overs = loop_count - ((loop_count / 8) * 8);
        unsigned long int vec_loop = (loop_count / 8);
        unsigned long int left_overs_start_at_A = k + offsetA - jump + 8 * (loop_count / 8);
        unsigned long int left_overs_start_at_B = k + offsetB - jump + 8 * (loop_count / 8);

        while (vec_loop--) {
            real_a = _mm512_loadu_pd(&real_vals_a[k + offsetA - jump]);
            imag_a = _mm512_loadu_pd(&imag_vals_a[k + offsetA - jump]);
            real_b = _mm512_loadu_pd(&real_vals_b[k + offsetB - jump]);
            imag_b = _mm512_loadu_pd(&imag_vals_b[k + offsetB - jump]);

            real_reala_realb = _mm512_mul_pd(real_a, real_b);
            real_imaga_imagb = _mm512_mul_pd(imag_a, imag_b);
            real_res = _mm512_sub_pd(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm512_mul_pd(real_a, imag_b);
            imag_imaga_realb = _mm512_mul_pd(imag_a, real_b);
            imag_res = _mm512_add_pd(imag_reala_imagb, imag_imaga_realb);

            _mm512_storeu_pd(&real_vals_final[k], real_res);
            _mm512_storeu_pd(&imag_vals_final[k], imag_res);

            k += 8;
        }
        if (left_overs != 0) {
            real_a = avx512_load_partial_double(left_overs, &real_vals_a[left_overs_start_at_A]);
            imag_a = avx512_load_partial_double(left_overs, &imag_vals_a[left_overs_start_at_A]);
            real_b = avx512_load_partial_double(left_overs, &real_vals_b[left_overs_start_at_B]);
            imag_b = avx512_load_partial_double(left_overs, &imag_vals_b[left_overs_start_at_B]);

            real_reala_realb = _mm512_mul_pd(real_a, real_b);
            real_imaga_imagb = _mm512_mul_pd(imag_a, imag_b);
            real_res = _mm512_sub_pd(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm512_mul_pd(real_a, imag_b);
            imag_imaga_realb = _mm512_mul_pd(imag_a, real_b);
            imag_res = _mm512_add_pd(imag_reala_imagb, imag_imaga_realb);

            avx512_store_partial_double(left_overs, &real_vals_final[k], real_res);
            avx512_store_partial_double(left_overs, &imag_vals_final[k], imag_res);

            // k += left_overs;
        }
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
    void run_avx512<float>(unsigned long int k, unsigned long int lenRes, unsigned long int offsetA, unsigned long int offsetB, unsigned long int jump, unsigned long int lenDiagA, unsigned long int lenDiagB, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final) {

        #ifdef DEEP_DEBUG
            std::cout << "Using AVX512-Float vectorization" << std::endl;
        #endif
        
        // unsigned long int loop_count = 0;
        // unsigned long int k_cpy = k;
        // while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
        //     loop_count++;
        //     k_cpy++;
        // }

        unsigned long int max_lenRes = lenRes - k;
        unsigned long int max_lenDiagA = lenDiagA - (k + offsetA - jump);
        unsigned long int max_lenDiagB = lenDiagB - (k + offsetB - jump);

        unsigned long int loop_count = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});

        __m512 real_a, real_b; // a for valuesA and b for valuesB
        __m512 imag_a, imag_b; // a for valuesA and b for valuesB
        __m512 real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        int left_overs = loop_count - ((loop_count / 8) * 8);
        unsigned long int vec_loop = (loop_count / 8);
        unsigned long int left_overs_start_at_A = k + offsetA - jump + 8 * (loop_count / 8);
        unsigned long int left_overs_start_at_B = k + offsetB - jump + 8 * (loop_count / 8);

        // printf("k = %ld, lenRes = %ld, offsetA = %ld, offsetB = %ld, jump = %ld, lenDiagA = %ld, lenDiagB = %ld, loop_count = %ld, left_overs = %ld, vec_loop = %ld, left_overs_start_at_A = %ld, left_overs_start_at_B = %ld\n", k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, loop_count, left_overs, vec_loop, left_overs_start_at_A, left_overs_start_at_B);

        while (vec_loop--) {
            // printf("test here 1\n");
            real_a = _mm512_loadu_ps(&real_vals_a[k + offsetA - jump]);
            imag_a = _mm512_loadu_ps(&imag_vals_a[k + offsetA - jump]);
            real_b = _mm512_loadu_ps(&real_vals_b[k + offsetB - jump]);
            imag_b = _mm512_loadu_ps(&imag_vals_b[k + offsetB - jump]);

            // printf("test here 2\n");

            real_reala_realb = _mm512_mul_ps(real_a, real_b);
            real_imaga_imagb = _mm512_mul_ps(imag_a, imag_b);
            real_res = _mm512_sub_ps(real_reala_realb, real_imaga_imagb);

            // printf("test here 3\n");

            imag_reala_imagb = _mm512_mul_ps(real_a, imag_b);
            imag_imaga_realb = _mm512_mul_ps(imag_a, real_b);
            imag_res = _mm512_add_ps(imag_reala_imagb, imag_imaga_realb);

            // printf("test here 4\n");

            avx512_store_partial_float(8, &real_vals_final[k], real_res);
            avx512_store_partial_float(8, &imag_vals_final[k], imag_res);

            // printf("test here 5\n");

            // printing real_res, imag_res
            // float *real_res_ptr = (float *)&real_res;
            // float *imag_res_ptr = (float *)&imag_res;
            // printf("real_res = [%f, %f, %f, %f, %f, %f, %f, %f]\n", real_res_ptr[0], real_res_ptr[1], real_res_ptr[2], real_res_ptr[3], real_res_ptr[4], real_res_ptr[5], real_res_ptr[6], real_res_ptr[7]);
            // printf("imag_res = [%f, %f, %f, %f, %f, %f, %f, %f]\n", imag_res_ptr[0], imag_res_ptr[1], imag_res_ptr[2], imag_res_ptr[3], imag_res_ptr[4], imag_res_ptr[5], imag_res_ptr[6], imag_res_ptr[7]);

            k += 8;
        }
        if (left_overs != 0) {
            real_a = avx512_load_partial_float(left_overs, &real_vals_a[left_overs_start_at_A]);
            imag_a = avx512_load_partial_float(left_overs, &imag_vals_a[left_overs_start_at_A]);
            real_b = avx512_load_partial_float(left_overs, &real_vals_b[left_overs_start_at_B]);
            imag_b = avx512_load_partial_float(left_overs, &imag_vals_b[left_overs_start_at_B]);

            real_reala_realb = _mm512_mul_ps(real_a, real_b);
            real_imaga_imagb = _mm512_mul_ps(imag_a, imag_b);
            real_res = _mm512_sub_ps(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm512_mul_ps(real_a, imag_b);
            imag_imaga_realb = _mm512_mul_ps(imag_a, real_b);
            imag_res = _mm512_add_ps(imag_reala_imagb, imag_imaga_realb);

            avx512_store_partial_float(left_overs, &real_vals_final[k], real_res);
            avx512_store_partial_float(left_overs, &imag_vals_final[k], imag_res);

            // k += left_overs;
        }
    }

    // SPMV for AVX
    template<typename valTypeTemplate>
    void run_spmv_avx512_1(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, unsigned long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx512_2(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, unsigned long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx512_0(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, unsigned long int dLength);

    // ------------------------AVX512 DOUBLE----------------------------------------
    template<>
    void run_spmv_avx512_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, unsigned long int dLength) {

        #ifdef DEBUG
            std::cout << "run_spmv_avx512_1 - Double" << std::endl;
        #endif

        // printf("run_spmv_avx512_1 - Double\n");
        unsigned long int vec_loop = dLength / 8;
        int left_overs = dLength % 8;

        __m512d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned long int i = 0; i < vec_loop * 8; i += 8) {
            real_vals_vec = _mm512_load_pd(&real_vals[i]);
            imag_vals_vec = _mm512_load_pd(&imag_vals[i]);
            x_real_vals_vec = _mm512_load_pd(&x_real_values[i]);
            x_imag_vals_vec = _mm512_load_pd(&x_imag_values[i]);

            y_real_vals_vec = _mm512_loadu_pd(&y_real_values[i - dIndex]);
            y_imag_vals_vec = _mm512_loadu_pd(&y_imag_values[i - dIndex]);

            y_real_vals_vec = _mm512_add_pd(y_real_vals_vec, _mm512_sub_pd(_mm512_mul_pd(real_vals_vec, x_real_vals_vec), _mm512_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm512_add_pd(y_imag_vals_vec, _mm512_add_pd(_mm512_mul_pd(real_vals_vec, x_imag_vals_vec), _mm512_mul_pd(imag_vals_vec, x_real_vals_vec)));

            _mm512_storeu_pd(&y_real_values[i - dIndex], y_real_vals_vec);
            _mm512_storeu_pd(&y_imag_values[i - dIndex], y_imag_vals_vec);
        }

        if(left_overs != 0) {
            unsigned long int left_overs_start_at = vec_loop * 8;
            real_vals_vec = avx512_load_partial_double(left_overs, &real_vals[left_overs_start_at]);
            imag_vals_vec = avx512_load_partial_double(left_overs, &imag_vals[left_overs_start_at]);
            x_real_vals_vec = avx512_load_partial_double(left_overs, &x_real_values[left_overs_start_at]);
            x_imag_vals_vec = avx512_load_partial_double(left_overs, &x_imag_values[left_overs_start_at]);
            y_real_vals_vec = avx512_load_partial_double(left_overs, &y_real_values[left_overs_start_at - dIndex]);
            y_imag_vals_vec = avx512_load_partial_double(left_overs, &y_imag_values[left_overs_start_at - dIndex]);

            y_real_vals_vec = _mm512_add_pd(y_real_vals_vec, _mm512_sub_pd(_mm512_mul_pd(real_vals_vec, x_real_vals_vec), _mm512_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm512_add_pd(y_imag_vals_vec, _mm512_add_pd(_mm512_mul_pd(real_vals_vec, x_imag_vals_vec), _mm512_mul_pd(imag_vals_vec, x_real_vals_vec)));

            avx512_store_partial_double(left_overs, &y_real_values[left_overs_start_at - dIndex], y_real_vals_vec);
            avx512_store_partial_double(left_overs, &y_imag_values[left_overs_start_at - dIndex], y_imag_vals_vec);
        }
    }
    template<>
    void run_spmv_avx512_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, unsigned long int dLength) {

        // printf("run_spmv_avx512_2 - Double\n");'

        #ifdef DEBUG
            std::cout << "run_spmv_avx512_2 - Double" << std::endl;
        #endif

        // // cross checking with non-simd version
        // double *temp_real = new double[dLength];
        // double *temp_imag = new double[dLength];
        // for(long int i = 0; i < dLength; i++) {
        //     temp_real[i] = y_real_values[i];
        //     temp_imag[i] = y_imag_values[i];
        // }

        unsigned long int vec_loop = dLength / 8;
        int left_overs = dLength % 8;

        // printf("vec_loop = %ld, left_overs = %ld, dIndex = %ld, dLength = %ld\n", vec_loop, left_overs, dIndex, dLength);

        __m512d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned long int i = 0; i < vec_loop * 8; i += 8) {
            real_vals_vec = _mm512_load_pd(&real_vals[i]);
            imag_vals_vec = _mm512_load_pd(&imag_vals[i]);

            x_real_vals_vec = _mm512_loadu_pd(&x_real_values[dIndex + i]);
            x_imag_vals_vec = _mm512_loadu_pd(&x_imag_values[dIndex + i]);

            y_real_vals_vec = _mm512_load_pd(&y_real_values[i]);
            y_imag_vals_vec = _mm512_load_pd(&y_imag_values[i]);

            y_real_vals_vec = _mm512_add_pd(y_real_vals_vec, _mm512_sub_pd(_mm512_mul_pd(real_vals_vec, x_real_vals_vec), _mm512_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm512_add_pd(y_imag_vals_vec, _mm512_add_pd(_mm512_mul_pd(real_vals_vec, x_imag_vals_vec), _mm512_mul_pd(imag_vals_vec, x_real_vals_vec)));

            _mm512_store_pd(&y_real_values[i], y_real_vals_vec);
            _mm512_store_pd(&y_imag_values[i], y_imag_vals_vec);
        }

        if(left_overs != 0) {
            unsigned long int left_overs_start_at = vec_loop * 8;
            real_vals_vec = avx512_load_partial_double(left_overs, &real_vals[left_overs_start_at]);
            imag_vals_vec = avx512_load_partial_double(left_overs, &imag_vals[left_overs_start_at]);
            x_real_vals_vec = avx512_load_partial_double(left_overs, &x_real_values[dIndex + left_overs_start_at]);
            x_imag_vals_vec = avx512_load_partial_double(left_overs, &x_imag_values[dIndex + left_overs_start_at]);
            y_real_vals_vec = avx512_load_partial_double(left_overs, &y_real_values[left_overs_start_at]);
            y_imag_vals_vec = avx512_load_partial_double(left_overs, &y_imag_values[left_overs_start_at]);

            y_real_vals_vec = _mm512_add_pd(y_real_vals_vec, _mm512_sub_pd(_mm512_mul_pd(real_vals_vec, x_real_vals_vec), _mm512_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm512_add_pd(y_imag_vals_vec, _mm512_add_pd(_mm512_mul_pd(real_vals_vec, x_imag_vals_vec), _mm512_mul_pd(imag_vals_vec, x_real_vals_vec)));

            avx512_store_partial_double(left_overs, &y_real_values[left_overs_start_at], y_real_vals_vec);
            avx512_store_partial_double(left_overs, &y_imag_values[left_overs_start_at], y_imag_vals_vec);
        }
        // // printing y_real_values, y_imag_values in single line
        // printf("y_real_values = [");
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     printf("%f, ", y_real_values[i]);
        // }
        // printf("]\n");
        // printf("y_imag_values = [");
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     printf("%f, ", y_imag_values[i]);
        // }
        // printf("]\n");
        
        // #pragma omp simd
        // for (unsigned long int i = 0; i < dLength; i++) {
        //     unsigned long int x_idx = dIndex + i;
        //     unsigned long int y_idx = i;
        //     temp_real[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
        //     temp_imag[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        // }
        // printf("temp_real = [");
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     printf("%f, ", temp_real[i]);
        // }
        // printf("]\n");
        // printf("temp_imag = [");
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     printf("%f, ", temp_imag[i]);
        // }
        // printf("]\n");
        // // write a quick check to see if temp_real and y_real_values are same and temp_imag and y_imag_values are same
        // for(unsigned long int i = 0; i < dLength; i++) {
        //     if(temp_real[i] != y_real_values[i]) {
        //         printf("temp_real[%ld] = %f, y_real_values[%ld] = %f\n", i, temp_real[i], i, y_real_values[i]);
        //     }
        //     if(temp_imag[i] != y_imag_values[i]) {
        //         printf("temp_imag[%ld] = %f, y_imag_values[%ld] = %f\n", i, temp_imag[i], i, y_imag_values[i]);
        //     }
        // }
    }

    template<>
    void run_spmv_avx512_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, unsigned long int dLength) {

        #ifdef DEBUG
            std::cout << "run_spmv_avx512_0 - Double" << std::endl;
        #endif

        // printf("run_spmv_avx512_0 - Double\n");
        unsigned long int vec_loop = dLength / 8;
        int left_overs = dLength % 8;

        __m512d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (unsigned long int i = 0; i < vec_loop * 8; i += 8) {
            real_vals_vec = _mm512_load_pd(&real_vals[i]);
            imag_vals_vec = _mm512_load_pd(&imag_vals[i]);
            x_real_vals_vec = _mm512_load_pd(&x_real_values[i]);
            x_imag_vals_vec = _mm512_load_pd(&x_imag_values[i]);
            y_real_vals_vec = _mm512_load_pd(&y_real_values[i]);
            y_imag_vals_vec = _mm512_load_pd(&y_imag_values[i]);

            y_real_vals_vec = _mm512_add_pd(y_real_vals_vec, _mm512_sub_pd(_mm512_mul_pd(real_vals_vec, x_real_vals_vec), _mm512_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm512_add_pd(y_imag_vals_vec, _mm512_add_pd(_mm512_mul_pd(real_vals_vec, x_imag_vals_vec), _mm512_mul_pd(imag_vals_vec, x_real_vals_vec)));

            _mm512_store_pd(&y_real_values[i], y_real_vals_vec);
            _mm512_store_pd(&y_imag_values[i], y_imag_vals_vec);
        }

        if(left_overs != 0) {
            unsigned long int left_overs_start_at = vec_loop * 8;
            real_vals_vec = avx512_load_partial_double(left_overs, &real_vals[left_overs_start_at]);
            imag_vals_vec = avx512_load_partial_double(left_overs, &imag_vals[left_overs_start_at]);
            x_real_vals_vec = avx512_load_partial_double(left_overs, &x_real_values[left_overs_start_at]);
            x_imag_vals_vec = avx512_load_partial_double(left_overs, &x_imag_values[left_overs_start_at]);
            y_real_vals_vec = avx512_load_partial_double(left_overs, &y_real_values[left_overs_start_at]);
            y_imag_vals_vec = avx512_load_partial_double(left_overs, &y_imag_values[left_overs_start_at]);

            y_real_vals_vec = _mm512_add_pd(y_real_vals_vec, _mm512_sub_pd(_mm512_mul_pd(real_vals_vec, x_real_vals_vec), _mm512_mul_pd(imag_vals_vec, x_imag_vals_vec)));
            y_imag_vals_vec = _mm512_add_pd(y_imag_vals_vec, _mm512_add_pd(_mm512_mul_pd(real_vals_vec, x_imag_vals_vec), _mm512_mul_pd(imag_vals_vec, x_real_vals_vec)));

            avx512_store_partial_double(left_overs, &y_real_values[left_overs_start_at], y_real_vals_vec);
            avx512_store_partial_double(left_overs, &y_imag_values[left_overs_start_at], y_imag_vals_vec);
        }
    }


    // // ------------------------AVX512 FLOAT----------------------------------------
    // template<>
    // void run_spmv_avx512_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, unsigned long int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_avx512_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, unsigned long int dLength) {
    //     // TODO
    // }
    // template<>
    // void run_spmv_avx512_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, unsigned long int dLength) {
    //     // TODO
    // }
    
#endif

bool diagonal::isEmpty() {
    // bool result = true;
    // const long int vecSize = 8;  // AVX-512 processes 8 doubles at a time
    // __m512d zero = _mm512_setzero_pd();

    // #pragma omp parallel for simd
    // for (long int i = 0; i < dLength; i += vecSize) {
    //     __m512d realVec = _mm512_loadu_pd(&realValues[i]);
    //     __m512d imagVec = _mm512_loadu_pd(&imagValues[i]);

    //     __mmask8 cmpReal = _mm512_cmp_pd_mask(realVec, zero, _CMP_NEQ_UQ);
    //     __mmask8 cmpImag = _mm512_cmp_pd_mask(imagVec, zero, _CMP_NEQ_UQ);

    //     if (cmpReal || cmpImag) {
    //         result = false;
    //     }
    // }
    // return result;
    bool isEmpty = true;
    #pragma omp parallel for reduction(&:isEmpty)
    for (unsigned long int i = 0; i < dLength; i++) {
        if (realValues[i] != 0 || imagValues[i] != 0) {
            isEmpty = false;
        }
    }
    return isEmpty;
}

} // namespace diaq