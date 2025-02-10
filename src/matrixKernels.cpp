#include "matrixKernels.hpp"

#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

void run_without_vectorization(long int k, long int lenRes, long int offsetA, long int offsetB, long int jump, long int lenDiagA, long int lenDiagB, valType *real_vals_a, valType *imag_vals_a, valType *real_vals_b, valType *imag_vals_b, valType *real_vals_final, valType *imag_vals_final) {
    // no vectorization
    // logger.log("No vectorization");
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
    // template
    template<typename valTypeTemplate>
    void run_avx(long int k, long int lenRes, long int offsetA, long int offsetB, long int jump, long int lenDiagA, long int lenDiagB, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final);

    // ------------------------AVX DOUBLE----------------------------------------
    #include <immintrin.h>
    __m256d avx_load_partial_double(long int n, const double *p) {
        // Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi64x(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm256_cmpgt_epi64(_mm256_set1_epi64x(n), _mm256_setr_epi64x(0, 1, 2, 3));
        // Load the array elements into the YMM register using the mask
        __m256d ymm = _mm256_maskload_pd(p, mask);
        return ymm;
    }
    void avx_store_partial_double(long int n, double *loc, __m256d vec) {
        // Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi64x(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm256_cmpgt_epi64(_mm256_set1_epi64x(n), _mm256_setr_epi64x(0, 1, 2, 3));
        // Store the elements of the vector 'vec' into the array 'loc' using the mask
        _mm256_maskstore_pd(loc, mask, vec);
    }
    template<>
    void run_avx<double>(long int k, long int lenRes, long int offsetA, long int offsetB, long int jump, long int lenDiagA, long int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final) {
        // logger.log("Using AVX-Double vectorization");
        long int loop_count = 0;
        long int k_cpy = k;
        while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
            loop_count++;
            k_cpy++;
        }
        __m256d real_a, real_b; // a for valuesA and b for valuesB
        __m256d imag_a, imag_b; // a for valuesA and b for valuesB
        __m256d real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        long int left_overs = loop_count - ((loop_count / 4) * 4);
        long int vec_loop = (loop_count / 4);
        long int left_overs_start_at_A = k + offsetA - jump + 4 * (loop_count / 4);
        long int left_overs_start_at_B = k + offsetB - jump + 4 * (loop_count / 4);

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
    #include <immintrin.h> 
    __m256 avx_load_partial_float(long int n, const float* p) {
        // Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi32(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        int maskValue = (1 << n) - 1;
        mask = _mm256_cmpgt_epi32(_mm256_set1_epi32(n), _mm256_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7));
        // Load the array elements into the YMM register using the mask
        __m256 ymm = _mm256_maskload_ps(p, mask);
        return ymm;
    }
	void avx_store_partial_float(long int n, float *loc, __m256 vec) {
		// Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi32(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm256_cmpgt_epi32(_mm256_set1_epi32(n), _mm256_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7));
        // Store the elements of the vector 'vec' into the array 'loc' using the mask
        _mm256_maskstore_ps(loc, mask, vec);
	}
    template<>
    void run_avx<float>(long int k, long int lenRes, long int offsetA, long int offsetB, long int jump, long int lenDiagA, long int lenDiagB, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final) {
        // logger.log("Using AVX-Float vectorization");
        // printf("Using AVX-Float vectorization\n");
        long int loop_count = 0;
        long int k_cpy = k;
        while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
            loop_count++;
            k_cpy++;
        }
        __m256 real_a, real_b; // a for valuesA and b for valuesB
        __m256 imag_a, imag_b; // a for valuesA and b for valuesB
        __m256 real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        long int left_overs = loop_count - ((loop_count / 8) * 8);
        long int vec_loop = (loop_count / 8);
        long int left_overs_start_at_A = k + offsetA - jump + 8 * (loop_count / 8);
        long int left_overs_start_at_B = k + offsetB - jump + 8 * (loop_count / 8);

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
    void run_spmv_avx_1(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx_2(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_avx_0(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, long int dLength);

    // ------------------------AVX DOUBLE----------------------------------------
    template<>
    void run_spmv_avx_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, long int dLength) {
        // printf("run_spmv_avx_1 - Double\n");
        long int vec_loop = dLength / 4;
        long int left_overs = dLength % 4;

        __m256d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (long int i = 0; i < vec_loop * 4; i += 4) {
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
            long int left_overs_start_at = vec_loop * 4;
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
    void run_spmv_avx_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, long int dLength) {

        // printf("run_spmv_avx_2 - Double\n");

        // // cross checking with non-simd version
        // double *temp_real = new double[dLength];
        // double *temp_imag = new double[dLength];
        // for(long int i = 0; i < dLength; i++) {
        //     temp_real[i] = y_real_values[i];
        //     temp_imag[i] = y_imag_values[i];
        // }

        long int vec_loop = dLength / 4;
        long int left_overs = dLength % 4;

        // printf("vec_loop = %ld, left_overs = %ld, dIndex = %ld, dLength = %ld\n", vec_loop, left_overs, dIndex, dLength);

        __m256d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (long int i = 0; i < vec_loop * 4; i += 4) {
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
            long int left_overs_start_at = vec_loop * 4;
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
        // for(long int i = 0; i < dLength; i++) {
        //     printf("%f, ", y_real_values[i]);
        // }
        // printf("]\n");
        // printf("y_imag_values = [");
        // for(long int i = 0; i < dLength; i++) {
        //     printf("%f, ", y_imag_values[i]);
        // }
        // printf("]\n");
        
        // #pragma omp simd
        // for (long int i = 0; i < dLength; i++) {
        //     long int x_idx = dIndex + i;
        //     long int y_idx = i;
        //     temp_real[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
        //     temp_imag[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        // }
        // printf("temp_real = [");
        // for(long int i = 0; i < dLength; i++) {
        //     printf("%f, ", temp_real[i]);
        // }
        // printf("]\n");
        // printf("temp_imag = [");
        // for(long int i = 0; i < dLength; i++) {
        //     printf("%f, ", temp_imag[i]);
        // }
        // printf("]\n");
        // // write a quick check to see if temp_real and y_real_values are same and temp_imag and y_imag_values are same
        // for(long int i = 0; i < dLength; i++) {
        //     if(temp_real[i] != y_real_values[i]) {
        //         printf("temp_real[%ld] = %f, y_real_values[%ld] = %f\n", i, temp_real[i], i, y_real_values[i]);
        //     }
        //     if(temp_imag[i] != y_imag_values[i]) {
        //         printf("temp_imag[%ld] = %f, y_imag_values[%ld] = %f\n", i, temp_imag[i], i, y_imag_values[i]);
        //     }
        // }
    }

    template<>
    void run_spmv_avx_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, long int dLength) {
        // printf("run_spmv_avx_0 - Double\n");
        long int vec_loop = dLength / 4;
        long int left_overs = dLength % 4;

        __m256d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (long int i = 0; i < vec_loop * 4; i += 4) {
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
            long int left_overs_start_at = vec_loop * 4;
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


    // ------------------------AVX FLOAT----------------------------------------
    template<>
    void run_spmv_avx_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, long int dLength) {
        // TODO
    }
    template<>
    void run_spmv_avx_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, long int dLength) {
        // TODO
    }
    template<>
    void run_spmv_avx_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, long int dLength) {
        // TODO
    }

    
#endif
#ifdef __SSE__
    template<typename valTypeTemplate>
    void run_sse(long int k, long int lenRes, long int offsetA, long int offsetB, long int jump, long int lenDiagA, long int lenDiagB, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final);

    // ------------------------SSE Float----------------------------------------
    #include <immintrin.h>
    __m128 sse_load_partial_float(long int n, float *p) {
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
    void sse_store_partial_float(long int n, float *loc, __m128 vec) {
        #pragma unroll
        for(long int i = 0; i < n; i++){
            loc[i] = vec[i];
        }
    }
    template<>
    void run_sse<float>(long int k, long int lenRes, long int offsetA, long int offsetB, long int jump, long int lenDiagA, long int lenDiagB, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final) {
        long int loop_count = 0;
        long int k_cpy = k;
        while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
            loop_count++;
            k_cpy++;
        }
        __m128 real_a, real_b; // a for valuesA and b for valuesB
        __m128 imag_a, imag_b; // a for valuesA and b for valuesB
        __m128 real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        long int left_overs = loop_count - ((loop_count / 4) * 4);
        long int vec_loop = (loop_count / 4);
        long int left_overs_start_at_A = k + offsetA - jump + 4 * (loop_count / 4);
        long int left_overs_start_at_B = k + offsetB - jump + 4 * (loop_count / 4);

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
    #include <emmintrin.h>
    __m128d sse_load_partial_double(long int n, const double *p) {
        // Initialize a mask with all bits set to 1
        __m128i mask = _mm_set1_epi64x(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm_cmpgt_epi64(_mm_set1_epi64x(n), _mm_set_epi64x(0, 1));
        // Load the array elements into the XMM register using the mask
        __m128d xmm = _mm_maskload_pd(p, mask);
        return xmm;
    }
    void sse_store_partial_double(long int n, double *loc, __m128d vec) {
        // Initialize a mask with all bits set to 1
        __m128i mask = _mm_set1_epi64x(-1);
        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        mask = _mm_cmpgt_epi64(_mm_set1_epi64x(n), _mm_set_epi64x(0, 1));
        // Store the elements of the vector 'vec' into the array 'loc' using the mask
        _mm_maskstore_pd(loc, mask, vec);
    }
    template<>
    void run_sse<double>(long int k, long int lenRes, long int offsetA, long int offsetB, long int jump, long int lenDiagA, long int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final) {
        long int loop_count = 0;
        long int k_cpy = k;
        while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
            loop_count++;
            k_cpy++;
        }
        __m128d real_a, real_b; // a for valuesA and b for valuesB
        __m128d imag_a, imag_b; // a for valuesA and b for valuesB
        __m128d real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        long int left_overs = loop_count - ((loop_count / 2) * 2);
        long int vec_loop = (loop_count / 2);
        long int left_overs_start_at_A = k + offsetA - jump + 2 * (loop_count / 2);
        long int left_overs_start_at_B = k + offsetB - jump + 2 * (loop_count / 2);

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
        if (left_overs == 1) { // left over can be 1 or 0, don't need vectorization for that right..
            real_vals_final[k] = (valType)((valType)(real_vals_a[k + offsetA - jump] * real_vals_b[k + offsetB - jump]) - (valType)(imag_vals_a[k + offsetA - jump] * imag_vals_b[k + offsetB - jump]));
            imag_vals_final[k] = (valType)((valType)(real_vals_a[k + offsetA - jump] * imag_vals_b[k + offsetB - jump]) + (valType)(imag_vals_a[k + offsetA - jump] * real_vals_b[k + offsetB - jump]));
            // k += 1;
        }
    }

    // SPMV for SSE
    template<typename valTypeTemplate>
    void run_spmv_sse_1(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_sse_2(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, long int dLength);

    template<typename valTypeTemplate>
    void run_spmv_sse_0(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, long int dIndex, long int dLength);

    // ------------------------SSE FLOAT----------------------------------------
    template<>
    void run_spmv_sse_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, long int dLength) {
        // TODO
    }
    template<>
    void run_spmv_sse_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, long int dLength) {
        // TODO
    }
    template<>
    void run_spmv_sse_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, long int dIndex, long int dLength) {
        // TODO
    }

    // ------------------------SSE DOUBLE----------------------------------------
    template<>
    void run_spmv_sse_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, long int dLength) {
        long int vec_loop = dLength / 2;
        long int left_overs = dLength % 2;

        __m128d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (long int i = 0; i < vec_loop; i += 2) {
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

        for (long int i = vec_loop * 2; i < dLength; i++) {
            long int x_idx = i;
            long int y_idx = i - dIndex;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        }
    }
    template<>
    void run_spmv_sse_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, long int dLength) {
        long int vec_loop = dLength / 2;
        long int left_overs = dLength % 2;

        __m128d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (long int i = 0; i < vec_loop; i += 2) {
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

        for (long int i = vec_loop * 2; i < dLength; i++) {
            long int x_idx = dIndex + i;
            long int y_idx = i;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        }
    }
    template<>
    void run_spmv_sse_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, long int dIndex, long int dLength) {
        long int vec_loop = dLength / 2;
        long int left_overs = dLength % 2;

        __m128d real_vals_vec, imag_vals_vec, x_real_vals_vec, x_imag_vals_vec, y_real_vals_vec, y_imag_vals_vec;

        for (long int i = 0; i < vec_loop; i += 2) {
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

        for (long int i = vec_loop * 2; i < dLength; i++) {
            long int x_idx = i;
            long int y_idx = i;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
        }
    }

#endif

// ----------------------------------------------------------------
//
// Matrix arithmetic
//
// ----------------------------------------------------------------

/**
 * @brief diagonal matrix multiplication
 * 
 * @param A diagonal A index
 * @param B diagonal B index
 * @param A diagonal A
 * @param B diagonal B
 * 
 * @return NULL if zero, else diagonal C
 */
long int getDiagonalLength(long int dIndex, long int *shape) {
    // std::cout << "diag_Index = " << dIndex << " ";
    long int lenRes;
    if(dIndex < 0) {
        lenRes = shape[0] + dIndex;
    } else if(dIndex > 0) {
        lenRes = shape[1] - dIndex;
    }  else {
        lenRes = (shape[0] > shape[1])?shape[1]:shape[0];
    }
    if (lenRes > shape[0]) {
        lenRes = shape[0];
    }
    else if(lenRes > shape[1]) {
        lenRes = shape[1];
    }
    // std::cout << "lenRes = " << lenRes << std::endl;
    return lenRes;
}
diagonal *multiplyDiagonals(long int *shapeA, long int *shapeB, long int indexA, long int indexB, diagonal *diagA, diagonal *diagB) {
    if(indexA + indexB >= shapeB[1]) {
        return NULL;
    }
    else if(indexA + indexB <= -1 * shapeA[0]) {
        return NULL;
    }
    long int lenDiagA = diagA->dLength;
    long int lenDiagB = diagB->dLength;
    // result matrix has dimensions {shapeA[0], shapeB[1]}
    long int res_dims[] = {shapeA[0], shapeB[1]};
    long int lenRes = getDiagonalLength(indexA + indexB, res_dims);
    diagonal *res = new diagonal(indexA + indexB, lenRes);
    // std::cout << "diagonal length = " << lenRes << std::endl;
    long int offsetA = abs(indexA);
    long int offsetB = abs(indexB);
    long int jump = 0;
    if(indexA > 0) {
        if(indexB > 0) {
            offsetB = offsetA;
            offsetA = 0;
        }
        else if(indexB < 0) {
            // std::cout << "jump,offsetA,offsetB " << jump << "," << offsetA << "," << offsetB << std::endl;
            if(offsetA > offsetB) {
                offsetB = abs(indexA + indexB);
                offsetA = 0;
            }
            else {
                offsetA = abs(indexA + indexB);
                offsetB = 0;
            }
        }
        else if(indexB == 0) {
            offsetB = offsetA;
            offsetA = 0;
        }
    }
    else if(indexA < 0) {
        if(indexB > 0) {
            // std::cout << "jump,offsetA,offsetB " << jump << "," << offsetA << "," << offsetB << std::endl;
            // std::cout << "lenDiagA,lenDiagB,lenRes " << lenDiagA << "," << lenDiagB << "," << lenRes << std::endl;
            // jump decides how many positions to skip for each diagonal, depends on the length of the shorter diagonal.
            if(lenDiagB < lenDiagA) {
                jump = lenRes - lenDiagB;
            }
            else if(lenDiagA < lenDiagB) {
                jump = lenRes - lenDiagA;
            }
            else {
                if(indexA + indexB < 0) {
                    // jump = abs(indexA) - abs(shapeA[0] - shapeB[1]);
                    jump = abs(indexB);
                } else {
                    jump = abs(indexA);
                }
            }
            offsetA = 0;
            offsetB = 0;
        }
        else if(indexB < 0) {
            offsetA = offsetB;
            offsetB = 0;
        }
        else if(indexB == 0) {
            offsetA = 0;
            offsetB = 0;
        }
    }
    else if(indexA == 0) {
        if(indexB > 0) {
            offsetA = 0;
            offsetB = 0;
        }
        else if(indexB < 0) {
            offsetA = offsetB;
            offsetB = 0;
        }
        else if(indexB == 0) {
            offsetA = 0;
            offsetB = 0;
        }
    }
    long int k = 0;
    if(jump != 0) {
        k += jump;
    }
	valType *real_vals_a = diagA->getRealValues();
    valType *imag_vals_a = diagA->getImagValues();
    valType *real_vals_b = diagB->getRealValues();
    valType *imag_vals_b = diagB->getImagValues();
	valType *real_vals_final = res->getRealValues();
    valType *imag_vals_final = res->getImagValues();
    // std::cout << "k=" << k << std::endl;
    // std::cout << "lenRes,jump,offsetA,offsetB " << lenRes << "," << jump << "," << offsetA << "," << offsetB << std::endl;
    #if VECTORIZATION_TYPE == 0
        run_sse(k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
    #elif VECTORIZATION_TYPE == 1
        run_avx(k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
    #elif VECTORIZATION_TYPE == -1
        run_without_vectorization(k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
    #endif
    return res;
}

/**
 * @brief quantum sparse matrix multiplication (C = A.B)
 * 
 * @param A diaQMatrix
 * @param B diaQMatrix
 * 
 * @return diaQMatrix  C
 */
diaQMatrix *product(diaQMatrix *A, diaQMatrix *B) {
    
    // A->print_meta();
    // B->print_meta();


    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif


    #ifdef CUDA_ENABLED
        return product_cuda(A, B);
    #else

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- product --- " << std::endl;
        std::cout << " --- " << std::endl;
        A->print();
        std::cout << " --- times --- " << std::endl;
        B->print();
        std::cout << " --- " << std::endl;
    #endif

    if(A->matrix_shape[1] != B->matrix_shape[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    long int *d = new long int[2];
    d[0] = A->matrix_shape[0];
    d[1] = B->matrix_shape[1];
    diaQMatrix* result = new diaQMatrix(&d);
    std::unordered_map<long int, diagonal*> mapA = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*> mapB = B->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator itA, itB;

    #pragma omp parallel for
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        for (itB = mapB.begin(); itB != mapB.end(); itB++) {
            // std::cout << " ------ diags ------ " << std::endl;
            // itA->second->print();
            // itB->second->print();
            // std::cout << " ------ diags ------ " << std::endl;
            // std::cout << " --- " << std::endl;
            diagonal *diagNew = multiplyDiagonals(A->matrix_shape, B->matrix_shape, itA->first, itB->first, itA->second, itB->second);
            if(diagNew != NULL && diagNew->dLength != 0 && !diagNew->isEmpty()) {
                // std::cout << " ------ new diag ------ " << std::endl;
                // diagNew->print();
                // std::cout << " ------ new diag ------ " << std::endl;
                result->addDiagonal(itA->first + itB->first, diagNew);
                // std::cout << " ------ result ------ " << std::endl;
                // result->print();
                // std::cout << " ------ result ------ " << std::endl;
            } else if (diagNew != NULL) {
                // printf(" --- printing empty diagonal --- \n");
                // diagNew->print();
                // printf(" --- --- --- \n");
                diagNew->free();
            }
        }
    }

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
		// --- First matrix ---
		std::unordered_map<long int, diagonal*> A_diagonalMap = A->getDiagonalMap();
        // get keys of A_diagonalMap
        std::vector<long int> A_keys;
        std::unordered_map<long int, diagonal*>::iterator A_it;
        for (A_it = A_diagonalMap.begin(); A_it != A_diagonalMap.end(); A_it++) {
            A_keys.push_back(A_it->first);
        }
        // print keys
        std::cout << "keys of A_diagonalMap: ";
        for(long int i = 0; i < A_keys.size(); i++) {
            std::cout << A_keys[i] << " ";
        }
        std::cout << std::endl;
		// --- Second matrix ---
        std::unordered_map<long int, diagonal*> B_diagonalMap = B->getDiagonalMap();
        // get keys of B_diagonalMap
        std::vector<long int> B_keys;
        std::unordered_map<long int, diagonal*>::iterator B_it;
        for (B_it = B_diagonalMap.begin(); B_it != B_diagonalMap.end(); B_it++) {
            B_keys.push_back(B_it->first);
        }
        // print keys
        std::cout << "keys of B_diagonalMap: ";
        for(long int i = 0; i < B_keys.size(); i++) {
            std::cout << B_keys[i] << " ";
        }
        std::cout << std::endl;
		// --- Result matrix ---
        std::unordered_map<long int, diagonal*> result_diagonalMap = result->getDiagonalMap();
        // get keys of result_diagonalMap
        std::vector<long int> result_keys;
        std::unordered_map<long int, diagonal*>::iterator result_it;
        for (result_it = result_diagonalMap.begin(); result_it != result_diagonalMap.end(); result_it++) {
            result_keys.push_back(result_it->first);
        }
        // print keys
        std::cout << "keys of result_diagonalMap: ";
        for(long int i = 0; i < result_keys.size(); i++) {
            std::cout << result_keys[i] << " ";
        }
        std::cout << std::endl;
        std::cout << " --- " << std::endl;
        std::cout << " --- product result --- " << std::endl;
        std::cout << " --- " << std::endl;
        result->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\tUnitary multiplication took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return result;

    #endif
}

/**
 * @brief dense matrix multiplication (C = A.B)
 * 
 * @param A denseMatrix
 * @param B denseMatrix
 * 
 * @return denseMatrix  C
 */
denseMatrix *denseProduct(denseMatrix *A, denseMatrix *B) {
    long int *shape_a = A->matrix_shape;
    long int *shape_b = B->matrix_shape;
    if(shape_a[1] != shape_b[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    valType *real_res = (valType *)calloc(shape_a[0] * shape_b[1], sizeof(valType));
    valType *imag_res = (valType *)calloc(shape_a[0] * shape_b[1], sizeof(valType));
    long int *d = new long int[2];
    d[0] = A->matrix_shape[0];
    d[1] = B->matrix_shape[1];
    denseMatrix *result = new denseMatrix(&d, real_res, imag_res);
    for(long int i = 0; i < shape_a[0]; i++) {
        for(long int k = 0; k < shape_b[1]; k++) {
            std::complex<valType> res = 0.0;
            for(long int j = 0; j < shape_b[0]; j++) {
                res += A->get(i, j) * B->get(j, k);
            }
            result->set(i, k, res);
        }
    }
    return result;
}

/**
* @brief adds two diaQMatrix matrices (C = A + B)
* @param A diaQMatrix
* @param B diaQMatrix
* @return diaQMatrix C
*/
diagonal *addElements(diagonal *A, diagonal *B) {
    valType *real_valsA = A->getRealValues();
    valType *imag_valsA = A->getImagValues();
    valType *real_valsB = B->getRealValues();
    valType *imag_valsB = B->getImagValues();
    if(A->dLength != B->dLength ) {
        throw std::invalid_argument("diagonals are of different lengths!");
    }
    diagonal *res = new diagonal(A->dIndex, A->dLength);
    valType *real_valsC = res->getRealValues();
    valType *imag_valsC = res->getImagValues();
    #pragma omp parallel for
    for(long int i=0; i < A->dLength; i++) {
        real_valsC[i] = real_valsA[i] + real_valsB[i];
        imag_valsC[i] = imag_valsA[i] + imag_valsB[i];
    }
    return res;
}

diaQMatrix *add(diaQMatrix *A, diaQMatrix *B) {
    if(A->getSize() != B->getSize()) {
        throw std::invalid_argument("input matrices are of different dimensions, not compatible");
    }
    diaQMatrix* result = new diaQMatrix(A->getSize());
    std::unordered_map<long int, diagonal*> mapA = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*> mapB = B->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator itA, itB;
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        itB = mapB.find(itA->first);
        if (itB == mapB.end()) {
            result->addDiagonal(itA->first, itA->second);
        } else {
            result->addDiagonal(itA->first, addElements(itA->second, itB->second));
        }
    }
    // result->pruneMatrix();
    return result;
}


std::complex<valType> trace(diaQMatrix *A) {
    std::complex<valType> t = 0;
    std::unordered_map<long int, diagonal*>::iterator itA;
    std::unordered_map<long int, diagonal*> mapA = A->getDiagonalMap();
    itA = mapA.find(0);
    if(itA == mapA.end()) {
        return t;
    }
    for(long int i=0; i < itA->second->dLength; i++) {
        t += itA->second->getValue(i);
    }
    return t;
}

diaQMatrix *matrix_reshape(diaQMatrix *A, long int *matrix_shape) {
    // start time
    auto start = std::chrono::high_resolution_clock::now();

    // this is matrix_reshape.
    // printf("diaq/matrix_reshape called with newshape (%ld, %ld)\n", matrix_shape[0], matrix_shape[1]);
    diaQMatrix *res = new diaQMatrix(&matrix_shape, A->shape);
    std::unordered_map<long int, diagonal*> diagonalMap = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator it;
    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        valType *real_vals = it->second->getRealValues();
        valType *imag_vals = it->second->getImagValues();
        #pragma omp parallel for
        for(long int i = 0; i < it->second->dLength; i++) {
            // old_d_pos has (it->first, i) for A->matrix_shape
            long int *d_pos = res->getDiagonalPositionByFlatIndex(A->getFlatIndex(it->first, i));
            long int d_len = getDiagonalLength(d_pos[0], res->matrix_shape);
            if(real_vals[i] != 0 || imag_vals[i] != 0) { // doing this here to avoid pruning later below.
                res->setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
            }
        }
    }
    return res;
}

diaQMatrix *reshape(diaQMatrix *A, std::vector<long int> new_tensor_shape) {
    long int old_product = 1;
    #pragma unroll
    for(long int i=0; i < A->shape.size(); i++) old_product *= A->shape[i];
    long int new_product = 1;
    #pragma unroll
    for(long int i=0; i < new_tensor_shape.size(); i++) new_product *= new_tensor_shape[i];
    if(old_product != new_product) {
        std::cout << old_product << "!=" << new_product << std::endl;
        throw std::invalid_argument("cannot reshape long into given shape");
    }
    // this is tensor reshape, we can just replace shape and we're good.
    A->shape = new_tensor_shape;
    return A;
}

std::vector<long int> newTensorShape(std::vector<long int> tensor_shape_A, std::vector<long int> tensor_shape_B, std::vector<long int> axis_A, std::vector<long int> axis_B) {
    std::vector<long int> res;
    for(long int i = 0; i < tensor_shape_A.size(); i++) {
        long int notin = 1;
        for(long int p = 0; p < axis_A.size(); p++) {
            if(i == axis_A[p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            res.push_back(tensor_shape_A[i]);
        }
    }
    // std::cout << "axis_B " << axis_B << std::endl;
    for(long int i = 0; i < tensor_shape_B.size(); i++) {
        long int notin = 1;
        for(long int p = 0; p < axis_B.size(); p++) {
            if(i == axis_B[p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            res.push_back(tensor_shape_B[i]);
        }
    }
    return res;
}

long int *newMatrixShape(std::vector<long int> tensorShape) {
    long int product = 1;
    for (long int i = 0; i < tensorShape.size(); i++) {
        product *= tensorShape[i];
    }
    long int sqrtProduct = static_cast<long int>(std::sqrt(product));
    // Find the closest factors of the product
    long int x = 1;
    long int y = product;
    for (long int i = sqrtProduct; i > 0; --i) {
        if (product % i == 0) {
            x = i;
            y = product / i;
            break;
        }
    }
    long int *new_shape = new long int[2];
    new_shape[0] = x;
    new_shape[1] = y;
    return new_shape;
}

std::vector<long int> modifyTensorShape(std::vector<long int> tShape, std::vector<long int> axes) {
    std::vector<long int> nShape;
    int tShapeSize = tShape.size();
    if(axes.size() == 0) {
        nShape.resize(tShape.size(), 1);
        #pragma omp parallel for
        for(long int i = 0; i < tShape.size(); i++) {
            nShape[i] = tShape[tShapeSize - i - 1];
        }
    }
    else {
        nShape.resize(axes.size(), 1);
        #pragma omp parallel for
        for(long int i = 0; i < axes.size(); i++) {
            nShape[i] = tShape[axes[i]];
        }
    }
    return nShape;
}

diaQMatrix *transpose(diaQMatrix *A, std::vector<long int> new_order) {
    // // start timer
    // auto start = std::chrono::high_resolution_clock::now();

    if(new_order.size() == 0) {
        new_order.resize(A->shape.size(), 1);
        #pragma omp parallel for
        for(long int i = 0; i < A->shape.size(); i++) {
            new_order[i] = A->shape.size() - i - 1;
        }
    }
    // std::cout << "diaq/transpose called with axes (";
    // for(long int i = 0; i < new_order.size()-1; i++) {
    //     std::cout << new_order[i] << ",";
    // }
    // std::cout << new_order[new_order.size()-1] << ")" << std::endl;

    // tranpose of the diagonals
    if(A->shape.size() == 2) {
        std::unordered_map<long int, diagonal *> diagMap = A->getDiagonalMap();
        std::unordered_map<long int, diagonal *>::iterator it;
        std::unordered_map<long int, diagonal *> newDiagMap;
        #pragma omp parallel for
        for (it = diagMap.begin(); it != diagMap.end(); it++) {
            it->second->setIndex(-1 * it->first);
            newDiagMap.insert(std::pair<long int, diagonal *>(-1 * it->first, it->second));
        }
        A->setDiagonalMap(newDiagMap);
        // swap A->shape[0] and A->shape[1] and similarly for matrix_shape.
        long int temp = A->shape[0];
        A->shape[0] = A->shape[1];
        A->shape[1] = temp;
        temp = A->matrix_shape[0];
        A->matrix_shape[0] = A->matrix_shape[1];
        A->matrix_shape[1] = temp;
        return A;
    }
    // otherwise, we have to do a lot of work
    // shape of result
    std::vector<long int> new_tensor_shape = modifyTensorShape(A->shape, new_order);
    // std::cout << "gives new_tensor_shape (";
    // for(long int i = 0; i < new_tensor_shape.size()-1; i++) {
    //     std::cout << new_tensor_shape[i] << ",";
    // }
    // std::cout << new_tensor_shape[new_tensor_shape.size()-1] << ")" << std::endl;
    // now, let's perform the transpose element by element
    long int l = new_tensor_shape.size();
    // this shape is important! decides the length of diagonals! Hence, we have to re-write it to maximize length of diagonals, so that number of diagonls are minimized.
    long int *new_shape = new long int[2];
    new_shape[0] = 1;
    new_shape[1] = 1;
    long int i = l / 2;
    #pragma unroll
    for(long int r = 0; r<i ; r++) {
        new_shape[0] = new_shape[0] * new_tensor_shape[r];
    }
    #pragma unroll
    for(long int r = i; r<l ; r++) {
        new_shape[1] = new_shape[1] * new_tensor_shape[r];
    }
    // std::cout << "new_shape = " << new_shape[0] << "," << new_shape[1] << std::endl;
    // res matrix/tensor
    std::unordered_map<long int, diagonal*> newDiagMap;
    // TODO: allocate for all possible diaognal indices and it's lengths. To paralleize later.
    diaQMatrix *res = new diaQMatrix(newDiagMap, &new_shape, new_tensor_shape);
    // iterate over all diagonals
    std::unordered_map<long int, diagonal*>::iterator it;
    std::unordered_map<long int, diagonal*> diagonalMap = A->getDiagonalMap();

    // #pragma omp parallel for
    // for(long int i = -1 * res->matrix_shape[0]; i < res->matrix_shape[1]; i++) {
    //     res->createDiagonal(i);
    // }

    #pragma omp parallel for
    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {

        valType *real_vals = it->second->getRealValues();
        valType *imag_vals = it->second->getImagValues();

        #pragma omp parallel for
        for(long int i = 0; i < it->second->dLength; i++) {
            // std::cout << "(diagonal_idx, diagonal_pos) = (" << it->first << ", " << i << ")" << std::endl;
            // std::cout << "element = " << vals[i] << std::endl;
            std::vector<long int> ten_pos = A->getTensorPosition(it->first, i);
            // std::cout << "tensor index = (";
            // for(long int i = 0; i < ten_pos.size()-1; i++) {
            //     std::cout << ten_pos[i] << ",";
            // }
            // std::cout << ten_pos[ten_pos.size()-1] << ")" << std::endl;

            // modify ten_pos to perform the transposition using the new_order
            std::vector<long int> new_ten_pos(new_order.size(), 1);
            #pragma omp parallel for
            for(long int i=0; i < new_order.size(); i++) {
                new_ten_pos[i] = ten_pos[new_order[i]];
            }

            long int *d_pos = res->getDiagonalPosition(new_ten_pos);
            // std::cout << "(new_diagonal_idx, new_diagonal_pos) = (" << d_pos[0] << ", " << d_pos[1] << ")" << std::endl;
            long int d_len = getDiagonalLength(d_pos[0], new_shape);
            if(real_vals[i] != 0.0 || imag_vals[i] != 0.0) { // to avoid pruning later.
                res->setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
            }
            // std::cout << " -- " << std::endl;
        }
    }
    return res;
}

diaQMatrix *transpose(diaQMatrix *A) {
    return transpose(A, std::vector<long int>());
}

diaQMatrix *tensordot1(diaQMatrix *A, diaQMatrix *B, std::vector<std::vector<long int> > axes) {
    // // start timer
    // auto start = std::chrono::high_resolution_clock::now();

    A->balance(); // to make sure x and y dims are balanced in the underlying matrix format
    B->balance(); // to make sure x and y dims are balanced in the underlying matrix format

    std::cout << "--" << std::endl;
    std::cout << "tensordot called for A - " << std::endl;
    A->print_meta();
    std::cout << "and B - " << std::endl;
    B->print_meta();
    std::cout << "with axes - " << " (";
    long int i=0;
    for(i=0; i<axes[0].size()-1; i++)
        std::cout << axes[0][i] << ",";
    std::cout << axes[0][i] << ") and (";
    for(i=0; i<axes[1].size()-1; i++)
        std::cout << axes[1][i] << ",";
    std::cout << axes[1][i] << ")" << std::endl;
    std::cout << "--" << std::endl;

    diaQMatrix *res;
    // move axes
    std::vector<long int> order_A;
    std::vector<long int> order_B;
    #pragma unroll
    for(long int i = 0; i < axes[1].size(); i++)
        order_B.push_back(axes[1][i]);
    for(long int i = 0; i < A->shape.size(); i++) {
        long int notin = 1;
        for(long int p = 0; p < axes[0].size(); p++) {
            if(i == axes[0][p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            order_A.push_back(i);
        }
    }
    for(long int i = 0; i < B->shape.size(); i++) {
        long int notin = 1;
        for(long int p = 0; p < axes[1].size(); p++) {
            if(i == axes[1][p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            order_B.push_back(i);
        }
    }
    #pragma unroll
    for(long int i = 0; i < axes[0].size(); i++)
        order_A.push_back(axes[0][i]);
    // std::cout << "with order_A (";
    // for(long int i = 0; i < order_A.size()-1; i++)
    //     std::cout << order_A[i] << ",";
    // std::cout << order_A[order_A.size()-1] << ")" << std::endl;
    // std::cout << "with order_B (";
    // for(long int i = 0; i < order_B.size()-1; i++)
    //     std::cout << order_B[i] << ",";
    // std::cout << order_B[order_B.size()-1] << ")" << std::endl;

    long int axes_0_product = 1;
    #pragma unroll
    for(long int i=0;i<axes[0].size();i++) axes_0_product *= A->shape[axes[0][i]];
    long int axes_1_product = 1;
    #pragma unroll
    for(long int i=0;i<axes[1].size();i++) axes_1_product *= B->shape[axes[1][i]];

    A = transpose(A, order_A);
    // printf("A after transpose\n");
    // A->print();
    B = transpose(B, order_B);
    // printf("B after transpose\n");
    // B->print();

    long int totalA = A->matrix_shape[0] * A->matrix_shape[1];
    long int totalB = B->matrix_shape[0] * B->matrix_shape[1];

    // std::cout << "axes_0_product = " << axes_0_product << " axes_1_product = " << axes_1_product << std::endl;
    // These have to be equal right? Let's add a check
    if(axes_1_product != axes_0_product) {
        std::cout << "axes_1_product != axes_0_product i.e. " << axes_1_product << " != " << axes_0_product << std::endl;
        throw std::invalid_argument("invalid axes, can't perform tensordot");
    }

    long int *new_shape_a = new long int[2] {totalA / axes_0_product, axes_0_product};
    long int *new_shape_b = new long int[2] {axes_1_product, totalB / axes_1_product};

    // std::vector<long int> new_shape_a{totalA / axes_0_product, axes_0_product};
    // std::vector<long int> new_shape_b{axes_1_product, totalB / axes_1_product};

    diaQMatrix *reshaped_A = matrix_reshape(A, new_shape_a);
    diaQMatrix *reshaped_B = matrix_reshape(B, new_shape_b);

    // std::cout << "after reshape A - " << std::endl;
    // reshaped_A->convertToDenseMatrix()->print();
    // std::cout << "and B - " << std::endl;
    // reshaped_B->convertToDenseMatrix()->print();

    res = product(reshaped_A, reshaped_B);

    // calculating result's tensor_shape
    res->shape = newTensorShape(A->shape, B->shape, axes[0], axes[1]);
    // res->pruneMatrix(); // do we really need this?

    // res->transpose(); // to make sure x and y dims are balanced in the underlying matrix format


    return res;
}

long int *getMatrixShape(std::vector<long int> tensor_shape) {
    // print tensor_shape
    // printf("tensor_shape = (");
    // for (long int i = 0; i < tensor_shape.size() - 1; i++) {
    //     printf("%ld, ", tensor_shape[i]);
    // }
    // printf("%ld)\n", tensor_shape[tensor_shape.size() - 1]);
    // Calculate the product of the tensor shape
    long int product = 1;
    for (long int i = 0; i < tensor_shape.size(); i++) {
        product *= tensor_shape[i];
    }
    long int sqrtProduct = static_cast<long int>(std::sqrt(product));
    // Find the closest factors of the product
    long int x = 1;
    long int y = product;
    for (long int i = sqrtProduct; i > 0; --i) {
        if (product % i == 0) {
            x = i;
            y = product / i;
            break;
        }
    }
    long int *new_shape = new long int[2];
    new_shape[0] = y;
    new_shape[1] = x;
    // printf("new_shape = (%ld, %ld)\n", new_shape[0], new_shape[1]);
    return new_shape;
}

std::vector<long int> getTenPos(const std::vector<long int>& ten_pos_A,
                                     const std::vector<long int>& ten_pos_B,
                                     const std::vector<long int>& axes_A,
                                     const std::vector<long int>& axes_B,
                                     const std::vector<long int>& shape_A,
                                     const std::vector<long int>& shape_B) {
    std::vector<long int> res;
    for (long int i = 0; i < ten_pos_A.size(); i++) {
        long int notin = 1;
        for (long int p = 0; p < axes_A.size(); p++) {
            if (i == axes_A[p]) {
                notin = 0;
                break;
            }
        }
        if (notin) {
            res.push_back(ten_pos_A[i]);
        }
    }
    for (long int i = 0; i < ten_pos_B.size(); i++) {
        long int notin = 1;
        for (long int p = 0; p < axes_B.size(); p++) {
            if (i == axes_B[p]) {
                notin = 0;
                break;
            }
        }
        if (notin) {
            res.push_back(ten_pos_B[i]);
        }
    }
    return res;
}

diaQMatrix *tensordot(diaQMatrix *A, diaQMatrix *B, std::vector<std::vector<long int> > axes) {
    // start timer
    // auto start = std::chrono::high_resolution_clock::now();

    // std::cout << "--" << std::endl;
    // std::cout << "tensordot called for A - " << std::endl;
    // A->print_meta();
    // std::cout << "and B - " << std::endl;
    // B->print_meta();
    // std::cout << "with axes - " << " (";
    // long int i=0;
    // for(i=0; i<axes[0].size()-1; i++)
    //     std::cout << axes[0][i] << ",";
    // std::cout << axes[0][i] << ") and (";
    // for(i=0; i<axes[1].size()-1; i++)
    //     std::cout << axes[1][i] << ",";
    // std::cout << axes[1][i] << ")" << std::endl;
    // std::cout << "--" << std::endl;

    // let's try element by element like we do with tensor transpose!
    std::vector<long int> new_tensor_shape = newTensorShape(A->shape, B->shape, axes[0], axes[1]);
    long int *new_matrix_shape = getMatrixShape(new_tensor_shape);
    diaQMatrix *res = new diaQMatrix(&new_matrix_shape, new_tensor_shape);
    // printf("res matrix shape\n");
    // res->print_shape();

    // element by element tensordot multiplication, inspired from COO format
    std::unordered_map<long int, diagonal*> mapA = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*> mapB = B->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator itA, itB;
    #pragma omp parallel for
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        diagonal *diagA = itA->second;
        valType *real_vals_A = diagA->getRealValues();
        valType *imag_vals_A = diagA->getImagValues();
        // #pragma omp parallel schedule(auto) num_threads(NUMBER_OF_OMP_THREADS)
        for(long int diagA_pos = 0; diagA_pos < diagA->dLength; diagA_pos++) {
            std::vector<long int> ten_pos_A = A->getTensorPosition(itA->first, diagA_pos);
            #pragma omp parallel for
            for (itB = mapB.begin(); itB != mapB.end(); itB++) {
                diagonal *diagB = itB->second;
                valType *real_vals_B = diagB->getRealValues();
                valType *imag_vals_B = diagB->getImagValues();
                #pragma omp parallel for
                for(long int diagB_pos = 0; diagB_pos < diagB->dLength; diagB_pos++) {
                    std::vector<long int> ten_pos_B = B->getTensorPosition(itB->first, diagB_pos);
                    // if the common axes
                    if (ten_pos_A[axes[0][0]] == ten_pos_B[axes[1][0]]) {
                        // print ten_pos_A and ten_pos_B
                        // printf("ten_pos_A = (");
                        // for (long int i = 0; i < ten_pos_A.size() - 1; i++) {
                        //     printf("%ld, ", ten_pos_A[i]);
                        // }
                        // printf("%ld)\n", ten_pos_A[ten_pos_A.size() - 1]);
                        // printf("ten_pos_B = (");
                        // for (long int i = 0; i < ten_pos_B.size() - 1; i++) {
                        //     printf("%ld, ", ten_pos_B[i]);
                        // }
                        // printf("%ld)\n", ten_pos_B[ten_pos_B.size() - 1]);
                        // Calculate resulting coordinates after contraction
                        std::vector<long int> result_coords = getTenPos(ten_pos_A, ten_pos_B, axes[0], axes[1], A->shape, B->shape);
                        // printing result_coords
                        // printf("result_coords = (");
                        // for (long int i = 0; i < result_coords.size() - 1; i++) {
                        //     printf("%ld, ", result_coords[i]);
                        // }
                        // printf("%ld)\n", result_coords[result_coords.size() - 1]);

                        // get the diagonal position and length
                        long int *res_diag_pos = res->getDiagonalPosition(result_coords);
                        long int res_diag_len = res->getDiagonalLength(res_diag_pos[0]);
                        valType real_val = real_vals_A[diagA_pos] * real_vals_B[diagB_pos] - imag_vals_A[diagA_pos] * imag_vals_B[diagB_pos];
                        valType imag_val = real_vals_A[diagA_pos] * imag_vals_B[diagB_pos] + imag_vals_A[diagA_pos] * real_vals_B[diagB_pos];
                        if(real_val != 0.0 || imag_val != 0.0) { // to avoid pruning later.
                            valType new_real_val = res->getItem_real(res_diag_pos[0], res_diag_pos[1]) + real_val;
                            valType new_imag_val = res->getItem_imag(res_diag_pos[0], res_diag_pos[1]) + imag_val;
                            res->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], res_diag_len, new_real_val, new_imag_val);
                        }
                        std::free(res_diag_pos);
                    }
                }
            }
        }
    }

    return res;
}

diaQMatrix *array(diaQMatrix *A) {
    // std::cout << "array called for A - " << std::endl;
    // A.print();
    // TODO: unclear as of now what this mehthod should be doing
    return A;
}

diaQMatrix *einsum(diaQMatrix *A, std::vector<long int> axes) {
    std::cout << axes[0] << std::endl;
    return A;
}

// overloading operators
diaQMatrix *operator*(diaQMatrix &A, diaQMatrix &B) {
    return product(&A, &B);
}
diaQMatrix *operator+(diaQMatrix &A, diaQMatrix &B) {
    return add(&A, &B);
}

void diaQMatrix::matrix_reshape(long int *matrix_shape) {
    // printf("self reshape called with newshape (%ld, %ld)\n", matrix_shape[0], matrix_shape[1]);
    diaQMatrix *temp = diaq::matrix_reshape(this, matrix_shape);
    *this = *temp;
    delete temp;
}

diaQMatrix *diaQMatrix::reshape(std::vector<long int> new_tensor_shape) {
    return diaq::reshape(this, new_tensor_shape);
}

void diaQMatrix::transpose(std::vector<long int> new_order) {
    diaQMatrix *temp = diaq::transpose(this, new_order);
    *this = *temp;
    delete temp;
}

void diaQMatrix::transpose() {
    diaQMatrix *temp = diaq::transpose(this);
    *this = *temp;
    delete temp;
}

vector *spMV(diaQMatrix *A, vector *x, vector *y) {
    #ifdef CUDA_ENABLED
        return spmv_cuda(A, x);
    #else
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- spMV --- " << std::endl;
        std::cout << " --- " << std::endl;
        A->print();
        std::cout << " --- times --- " << std::endl;
        x->print();
        std::cout << " --- " << std::endl;
        printf("Analyzing SpM\n");
        A->print_meta();
        printf("Analyzing V\n");
        x->print_meta();
        printf("Analyzing Y\n");
        y->print_meta();
    #endif

    #ifdef DEBUG
        // measure start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    if(A->matrix_shape[1] != x->num_rows()) {
        throw std::invalid_argument("Not multiplyable");
    }
    // vector *y = new vector(A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->getRealValues();
    valType *y_imag_values = y->getImagValues();

    valType *x_real_values = x->getRealValues();
    valType *x_imag_values = x->getImagValues();
    std::unordered_map<long int, diagonal*> diagMap = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        long int dIndex = it->first;
        long int dLength = it->second->dLength;
        valType *real_vals = it->second->getRealValues();
        valType *imag_vals = it->second->getImagValues();
        if(dIndex < 0) { // negative diagonals
            // printf("Negative diagonal!!\n");
            #if VECTORIZATION_TYPE == 1
                run_spmv_avx_1(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
            #elif VECTORIZATION_TYPE == 0
                run_spmv_sse_1(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
            #else // run without vectorization
                #pragma omp simd
                for (long int i = 0; i < dLength; i++) {
                    long int x_idx = i;
                    long int y_idx = i - dIndex;
                    y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                    y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                }
            #endif
        }
        else if(dIndex > 0) { // positive diagonals
            // printf("Positive diagonal!!\n");
            #if VECTORIZATION_TYPE == 1
                run_spmv_avx_2(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
            #elif VECTORIZATION_TYPE == 0
                run_spmv_sse_2(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
            #else // run without vectorization
                #pragma omp simd
                for (long int i = 0; i < dLength; i++) {
                    long int x_idx = dIndex + i;
                    long int y_idx = i;
                    y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                    y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                }
            #endif
        }
        else {
            // 0th diagonal
            // printf("Zero diagonal!!\n");
            #if VECTORIZATION_TYPE == 1
                run_spmv_avx_0(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
            #elif VECTORIZATION_TYPE == 0
                run_spmv_sse_0(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
            #else // run without vectorization
                #pragma omp simd
                for (long int i = 0; i < dLength; i++) {
                    y_real_values[i] += real_vals[i] * x_real_values[i] - imag_vals[i] * x_imag_values[i];
                    y_imag_values[i] += real_vals[i] * x_imag_values[i] + imag_vals[i] * x_real_values[i];
                }
            #endif
        }
    }

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- spMV result --- " << std::endl;
        std::cout << " --- " << std::endl;
        y->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t spMV took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return y;

    #endif
}

vector *spMV(diaQMatrix *A, vector *x, vector *y, long int qubit_smaller, long int qubit_larger) {

    // DID NOT IMPLEMENT YET!
    // TODO: PLS IMPLEMENT!!

    #ifdef DEBUG
        // measure start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    long int *new_gate_shape = new long int[2] {q_diff_exp, q_diff_exp};

    if(A->matrix_shape[1] != x->numRows_) {
        throw std::invalid_argument("Not multiplyable");
    }
    // vector *y = new vector(A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues_;
    valType *y_imag_values = y->imagValues_;

    valType *x_real_values = x->realValues_;
    valType *x_imag_values = x->imagValues_;
    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        diagonal *diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        switch(diag->dIndex) {
            case -3: {
                long int dIndex = -1 * q_diff_exp - 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case -2: {
                long int dIndex = -1 * q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case -1: {
                long int dIndex = -1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // something
                dIndex = -1 * q_diff_exp + 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 0: {
                long int dIndex = 0;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 1: {
                long int dIndex = 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                dIndex = q_diff_exp - 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 2: {
                long int dIndex = q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 3: {
                long int dIndex = q_diff_exp + 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
        }
    }

    free(new_gate_shape);

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t spMV (non-adj) took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return y;
}

vector *MV(denseMatrix *A, vector *x, vector *y) {
    if(A->matrix_shape[1] != x->numRows_) {
        throw std::invalid_argument("Not multiplyable");
    }
    valType *x_real_values = x->realValues_;
    valType *x_imag_values = x->imagValues_;
    // vector *y = new vector(A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues_;
    valType *y_imag_values = y->imagValues_;
    for(long int i = 0; i < A->matrix_shape[0]; i++) {
        valType res_real = 0.0;
        valType res_imag = 0.0;
        #pragma omp parallel for
        for(long int j = 0; j < A->matrix_shape[1]; j++) {
            std::complex<valType> elem = A->get(i, j);
            res_real += elem.real() * x_real_values[j] - elem.imag() * x_imag_values[j];
            res_imag += elem.real() * x_imag_values[j] + elem.imag() * x_real_values[j];
        }
        y_real_values[i] = res_real;
        y_imag_values[i] = res_imag;
    }
    return y;
}

denseMatrix *dense_kron_product(denseMatrix *A, denseMatrix *B) {
    // A: m x n
    // B: p x q
    // C: mp x nq

    long int *shape_a = A->matrix_shape;
    long int *shape_b = B->matrix_shape;

    // Calculate dimensions for the resulting matrix
    long int *d = (long int *)calloc(2, sizeof(long int));
    d[0] = shape_a[0] * shape_b[0];
    d[1] = shape_a[1] * shape_b[1];
    valType *real_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
    valType *imag_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
    denseMatrix *result = new denseMatrix(&d, real_res, imag_res);

    // Iterate through the rows of matrix A
    for (long int i = 0; i < A->matrix_shape[0]; i++) {

        // Iterate through the columns of matrix A
        for (long int j = 0; j < A->matrix_shape[1]; j++) {

            // Iterate through the rows of matrix B
            for (long int k = 0; k < B->matrix_shape[0]; k++) {

                // Iterate through the columns of matrix B
                for (long int l = 0; l < B->matrix_shape[1]; l++) {

                    // Calculate the resulting indices in the new matrix
                    long int newIndexI = i * B->matrix_shape[0] + k;
                    long int newIndexJ = j * B->matrix_shape[1] + l;

                    // Multiply the element of A by the element of B
                    std::complex<valType> newElement = A->get(i, j) * B->get(k, l);

                    // Add the resulting element to the appropriate position in the result denseMatrix
                    result->set(newIndexI, newIndexJ, newElement);
                }
            }
        }
    }
    return result;
}

diaQMatrix *multiply_by_scalar(diaQMatrix *A, valType scalar_real, valType scalar_imag) {
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- multiply_by_scalar --- " << std::endl;
        std::cout << " --- " << std::endl;
        std::cout << "scalar_real = " << scalar_real << "; scalar_imag = " << scalar_imag << std::endl;
        std::cout << " --- times --- " << std::endl;
        A->print();
        std::cout << " --- " << std::endl;
    #endif

    diaQMatrix *result = new diaQMatrix((long int)0);

    result->matrix_shape = A->matrix_shape;
    result->shape = A->shape;

    std::unordered_map<long int, diagonal*> diagMap = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        long int dIndex = it->first;
        long int dLength = it->second->dLength;
        valType *real_vals = it->second->getRealValues();
        valType *imag_vals = it->second->getImagValues();
        diagonal *newDiag = new diagonal(dIndex, dLength);
        valType *real_valsC = newDiag->getRealValues();
        valType *imag_valsC = newDiag->getImagValues();

        #pragma omp simd
        for (long int i = 0; i < dLength; i++) {
            real_valsC[i] = real_vals[i] * scalar_real - imag_vals[i] * scalar_imag;
            imag_valsC[i] = real_vals[i] * scalar_imag + imag_vals[i] * scalar_real;
        }

        result->setDiagonal(dIndex, newDiag);
    }

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- multiply_by_scalar result --- " << std::endl;
        std::cout << " --- " << std::endl;
        result->print();
        std::cout << " --- " << std::endl;
    #endif

    return result;
}

diaQMatrix *kron_product(diaQMatrix *A, diaQMatrix *B) {

    #ifdef DEEP_DEBUG
        printf("\tdiaq::kron_product\n");
        printf("\tA Meta:\n");
        A->print_meta();
        printf("\tB Matrix:\n");
        B->print();
    #endif

    #ifdef DEBUG
        // measure start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int *shape_a = A->matrix_shape;
    long int *shape_b = B->matrix_shape;

    // map of unique A elements and their corresponding kron blocks
    std::map<std::pair<valType, valType>, diaQMatrix *> unique_kron_blocks;

    // Calculate dimensions for the resulting matrix
    long int *result_shape = new long int[2];
    result_shape[0] = shape_a[0] * shape_b[0];
    result_shape[1] = shape_a[1] * shape_b[1];
    diaQMatrix *result = new diaQMatrix(&result_shape);

    std::unordered_map<long int, diagonal*> A_diagonalMap = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator itA;

    for (itA = A_diagonalMap.begin(); itA != A_diagonalMap.end(); itA++) {
        long int diagonal_index = itA->first;
        diagonal *diag = itA->second;
        long int diagonal_length = diag->dLength;

        #pragma omp parallel for
        for(long int diagonal_position = 0; diagonal_position < diagonal_length; diagonal_position++) {
            // skippihg zero elements
            if(diag->getRealValue(diagonal_position) == 0.0 && diag->getImagValue(diagonal_position) == 0.0) {
                continue;
            }
            diaQMatrix *kron_block;
            // dynamic programming for unique kron blocks
            if(unique_kron_blocks.find(std::pair<valType, valType>(diag->getRealValue(diagonal_position), diag->getImagValue(diagonal_position))) == unique_kron_blocks.end()) {
                kron_block = multiply_by_scalar(B, diag->getRealValue(diagonal_position), diag->getImagValue(diagonal_position));
                // printf("printing kron_block\n");
                // kron_block->print();
                // store in unique_kron_blocks
                unique_kron_blocks.insert(std::pair<std::pair<valType, valType>, diaQMatrix *>(std::pair<valType, valType>(diag->getRealValue(diagonal_position), diag->getImagValue(diagonal_position)), kron_block));
            } else {
                kron_block = unique_kron_blocks.find(std::pair<valType, valType>(diag->getRealValue(diagonal_position), diag->getImagValue(diagonal_position)))->second;
            }
            long int *A_pos = A->getMatrixPosition(diagonal_index, diagonal_position);
            std::unordered_map<long int, diagonal*> kron_block_diagMap = kron_block->getDiagonalMap();
            std::unordered_map<long int, diagonal*>::iterator itK;
            for (itK = kron_block_diagMap.begin(); itK != kron_block_diagMap.end(); itK++) {
                long int kron_block_diag_index = itK->first;
                diagonal *kron_block_diag = itK->second;
                long int kron_block_diag_length = kron_block_diag->dLength;

                #pragma omp parallel for
                for(long int kron_block_diag_position = 0; kron_block_diag_position < kron_block_diag_length; kron_block_diag_position++) {

                    long int *B_mat_pos = kron_block->getMatrixPosition(kron_block_diag_index, kron_block_diag_position);
                    long int res_mat_pos[2] = {A_pos[0] * shape_b[0] + B_mat_pos[0], A_pos[1] * shape_b[1] + B_mat_pos[1]};
                    long int *res_diag_pos = result->getDiagonalPosition(res_mat_pos);

                    result->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], result->getDiagonalLength(res_diag_pos[0]), kron_block_diag->getRealValue(kron_block_diag_position), kron_block_diag->getImagValue(kron_block_diag_position));

                    // free(res_diag_pos);
                    // free(B_mat_pos);
                    // free(res_mat_pos);
                }
            }
            // free(A_pos);
            // kron_block->free();
        }
    }

    #ifdef DEEP_DEBUG
        printf("\tResult Meta:\n");
        result->print_meta();
    #endif


    #ifdef DEBUG
        // measure end timer
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t kron_product took %f milliseconds\n", duration.count()/1000.0);
    #endif

    // return result;
    return result;
}

diaQMatrix *identity_kron_matrix(long int n, diaQMatrix *A) {

    #ifdef DEEP_DEBUG
        printf("\tdiaq::identity_kron_matrix\n");
        printf("\tA Meta:\n");
        A->print_meta();
    #endif

    #ifdef DEBUG
        // measure start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int N = 1L << n;

    // assume a nxn identity matrix, which has one diagonal of length N, in index 0.
    // we just repeat A, N times in the result matrix
    long int *result_shape = new long int[2] {N * A->matrix_shape[0], N * A->matrix_shape[1]};
    diaQMatrix *result = new diaQMatrix(&result_shape);
    std::unordered_map<long int, diagonal*> diagMap = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator it;
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        long int dIndex = it->first;
        diagonal *diag = it->second;
        // printf("A's diagonal\n");
        // diag->print();
        long int dLength = diag->dLength;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->getRealValues();
        valType *imag_vals = diag->getImagValues();

        // result diag
        long int new_dLength = result->getDiagonalLength(dIndex); // TODO: there should be a better way to get this using n and dLength.
        diagonal *newDiag = new diagonal(dIndex, new_dLength);
        valType *newDiag_real_vals = newDiag->getRealValues();
        valType *newDiag_imag_vals = newDiag->getImagValues();

        #pragma omp parallel for
        for(long int rep = 0; rep < N; rep++) {
            long int skip_places = (rep) * (dLength + abs(dIndex));
            for(long int i = 0; i < dLength; i++) {
                newDiag_real_vals[i + skip_places] = real_vals[i];
                newDiag_imag_vals[i + skip_places] = imag_vals[i];
            }
        }
        result->setDiagonal(dIndex, newDiag);
    }

    #ifdef DEEP_DEBUG
        printf("\tResult Meta:\n");
        result->print_meta();
    #endif

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return result;
}

void identity_kron_matrix_times_vector(long int n, diaQMatrix *A, vector *x, vector *y) {

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int N = 1L << n;

    valType *y_real_values = y->realValues_;
    valType *y_imag_values = y->imagValues_;

    valType *x_real_values = x->realValues_;
    valType *x_imag_values = x->imagValues_;

    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    // #pragma omp parallel for schedule(dynamic) // because there can only be max 8 diagonals in a 2q-gate.
    // for (it = diagMap.begin(); it != diagMap.end(); it++) {
    //     long int dIndex = it->first;
    //     diagonal *diag = it->second;
    //     long int dLength = diag->dLength;
    //     valType *real_vals = diag->realValues;
    //     valType *imag_vals = diag->imagValues;

    //     if(dIndex < 0) { // for negative diagonals
    //         #pragma omp simd
    //         for(long int rep = 0; rep < n; rep++) {
    //             long int skip_places = rep * (dLength - dIndex);
    //             #pragma unroll
    //             for(long int i = 0; i < dLength; i++) {
    //                 long int x_idx = i + skip_places;
    //                 long int y_idx = i + skip_places - dIndex;
    //                 y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
    //                 y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
    //             }
    //         }
    //     }
    //     else { // for 0th and positive diagonals
    //         #pragma omp simd
    //         for(long int rep = 0; rep < n; rep++) {
    //             long int skip_places = rep * (dLength + dIndex);
    //             // printf("dLength = %ld, skip_places = %ld\n", dLength, skip_places);
    //             #pragma unroll
    //             for(long int i = 0; i < dLength; i++) {
    //                 valType each_real = real_vals[i];
    //                 valType each_imag = imag_vals[i];
    //                 long int skip_places = rep * (dLength + dIndex);
    //                 long int x_idx = dIndex + i + skip_places;
    //                 long int y_idx = i + skip_places;
    //                 y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
    //                 y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
    //             }
    //         }
    //     }
    // }

    // for (it = diagMap.begin(); it != diagMap.end(); it++) {
    //     long int dIndex = it->first;
    //     diagonal *diag = it->second;
    //     long int dLength = diag->dLength;
    //     valType *real_vals = diag->realValues;
    //     valType *imag_vals = diag->imagValues;

    //     if (dIndex < 0) {
    //         for (long int rep = 0; rep < n; ++rep) {
    //             long int skip_places = rep * (dLength - dIndex);
    //             for (long int i = 0; i < dLength; ++i) {
    //                 valType real_i = real_vals[i];
    //                 valType imag_i = imag_vals[i];
    //                 if (real_i != 0 || imag_i != 0) { // 0s are skipped since they don't affect the result
    //                     long int x_idx = i + skip_places;
    //                     long int y_idx = i + skip_places - dIndex;
    //                     y_real_values[y_idx] += real_i * x_real_values[x_idx] - imag_i * x_imag_values[x_idx];
    //                     y_imag_values[y_idx] += real_i * x_imag_values[x_idx] + imag_i * x_real_values[x_idx];
    //                 }
    //             }
    //         }
    //     } else { // Process 0th and positive diagonals using vectorization and loop unrolling
    //         for (long int rep = 0; rep < n; ++rep) {
    //             long int skip_places = rep * (dLength + dIndex);
    //             for (long int i = 0; i < dLength; ++i) {
    //                 valType real_i = real_vals[i];
    //                 valType imag_i = imag_vals[i];
    //                 if (real_i != 0 || imag_i != 0) {
    //                     long int x_idx = dIndex + i + skip_places;
    //                     long int y_idx = i + skip_places;
    //                     y_real_values[y_idx] += real_i * x_real_values[x_idx] - imag_i * x_imag_values[x_idx];
    //                     y_imag_values[y_idx] += real_i * x_imag_values[x_idx] + imag_i * x_real_values[x_idx];
    //                 }
    //             }
    //         }
    //     }
    // }

    long long int y_len = y->numRows_; // same as x->numRows_;
    long int A_size = A->matrix_shape[0];

    // I kron A has the same number of diagonals as A, but each diagonal has N times more G elements and more 0s that we don't need to care about.
    // So, we can just iterate through the diagonals of A and repeat each diagonal N times in the result vector. But offsets are important and different for each iteration, since each is essentially a block!
    // now for each diagonal in A
    // index in y and x goes from (0, block_idx * diag_length)

    long int last_y_offset = (N-1) * A_size;

    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        // now we can do element wise!
        long int dIndex = it->first;
        diagonal *diag = it->second;
        long int dLength = diag->dLength;
        valType *real_vals = diag->getRealValues();
        valType *imag_vals = diag->getImagValues();

        long int x_inner_offset = 0;
        long int y_inner_offset = 0;

        if(dIndex > 0) {
            x_inner_offset += dIndex;
        }
        if(dIndex < 0) {
            y_inner_offset -= dIndex; // kind of like adding abs(dIndex) to y_offset
        }

        #pragma omp parallel for
        for(long int y_offset = 0; y_offset <= last_y_offset; y_offset += A_size) { // this is like traversing blocks in I kron A
            long int x_offset = y_offset + x_inner_offset;
            long int new_y_offset = y_offset + y_inner_offset;

            // long int block_idx = y_offset / A_size;
            // std::cout << "block_idx = " << block_idx << "; dIndex = " << dIndex << "; dLength = " << dLength << "; x_offset = " << x_offset << "; y_offset = " << y_offset << std::endl;
            // now the element wise multiplication, for elements in this diagonal, and it's like atmost 4 loop and can be unrolled.

            #pragma omp simd
            for (long int y_idx = new_y_offset; y_idx < dLength + new_y_offset; y_idx++) {
                long int x_idx = x_offset + (y_idx - new_y_offset); // adjust x_idx for each iteration
                long int i = y_idx - new_y_offset; // if you want to match your original i loop
                // std::cout << " \t\t y_idx = " << y_idx << "; x_idx = " << x_idx << std::endl;
                y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif
}


void identity_kron_matrix_times_vector(long int n, diaQMatrix *A, vector *x, vector *y, long int qubit_smaller, long int qubit_larger) {

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    n = 1L << n;

    long int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    long int *new_gate_shape = new long int[2] {q_diff_exp, q_diff_exp};

    // vector *y = new vector(n * A->matrix_shape[0]);
    valType *y_real_values = y->realValues_;
    valType *y_imag_values = y->imagValues_;

    valType *x_real_values = x->realValues_;
    valType *x_imag_values = x->imagValues_;

    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        diagonal *diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        switch(diag->dIndex) {
            case -3: {
                long int dIndex = -1 * q_diff_exp - 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < n; rep++) {
                    long int skip_places = rep * (dLength - dIndex);
                    #pragma omp simd
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            long int x_idx = i + skip_places;
                            long int y_idx = i + skip_places - dIndex;
                            y_real_values[y_idx] += real_vals[0] * x_real_values[x_idx] - imag_vals[0] * x_imag_values[x_idx];
                            y_imag_values[y_idx] += real_vals[0] * x_imag_values[x_idx] + imag_vals[0] * x_real_values[x_idx];
                        }
                    }
                }
                break;
            }
            case -2: {
                long int dIndex = -1 * q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < n; rep++) {
                    long int skip_places = rep * (dLength - dIndex);
                    #pragma omp simd
                    for(long int i = 0; i < dLength/2; i++) {
                        long int x_idx = i + skip_places;
                        long int y_idx = i + skip_places - dIndex;
                        y_real_values[y_idx] += real_vals[0] * x_real_values[x_idx] - imag_vals[0] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[0] * x_imag_values[x_idx] + imag_vals[0] * x_real_values[x_idx];

                        x_idx = i + skip_places + 1;
                        y_idx = i + skip_places - dIndex + 1;
                        y_real_values[y_idx] += real_vals[1] * x_real_values[x_idx] - imag_vals[1] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[1] * x_imag_values[x_idx] + imag_vals[1] * x_real_values[x_idx];

                    }
                }
                break;
            }
            case -1: {
                long int dIndex = -1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // something
                dIndex = -1 * q_diff_exp + 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 0: {
                long int dIndex = 0;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 1: {
                long int dIndex = 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                dIndex = q_diff_exp - 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 2: {
                long int dIndex = q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 3: {
                long int dIndex = q_diff_exp + 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
        }
    }

    free(new_gate_shape);

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void identity_kron_matrix_kron_identity_times_vector(long int before, diaQMatrix *gate, long int after, vector *x, vector *y) {
    // logically combine matrix_kron_identity and identity_kron_matrix_times_vector

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        std::cout << "identity_kron_matrix_kron_identity_times_vector called" << std::endl;
        printf("gate matrix below\n");
        gate->print();
        printf("\t\tbefore = %ld; after = %ld\n", before, after);
    #endif

    long int before_N = 1L << before;
    long int after_N = 1L << after;

    long int x_length = x->numRows_;

    // if(after * before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // vector *y = new vector(after * before * gate->matrix_shape[0]);
    // y->print();
    valType *y_real_values = y->realValues_;
    valType *y_imag_values = y->imagValues_;
    // PRINT_WITH_LINE("here\n");

    valType *x_real_values = x->realValues_;
    valType *x_imag_values = x->imagValues_;

    std::unordered_map<long int, diagonal*> diagMap = gate->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    // #pragma omp parallel for collapse(2) schedule(static) private(it, dIndex, diag, dLength, rep, i, real_i, imag_i, skip_places, x_idx, y_idx)
    // for (it = diagMap.begin(); it != diagMap.end(); it++) {
    //     long int dIndex = it->first;
    //     diagonal *diag = it->second;
    //     valType *real_vals = diag->realValues;
    //     valType *imag_vals = diag->imagValues;
    //     long int dLength = diag->dLength;
    //     long int offset = (dIndex < 0) ? (before * dLength - before * dIndex) : dIndex * before;
    //     for (long int rep = 0; rep < after; rep++) {
    //         long int skip_places = rep * (before * dLength);
    //         for (long int i = 0; i < dLength; ++i) {
    //             valType real_i = real_vals[i];
    //             valType imag_i = imag_vals[i];
    //             if (real_i != 0 || imag_i != 0) {
    //                 for (long int j = 0; j < before; j++) {
    //                     long int x_idx = j + i * before + skip_places;
    //                     long int y_idx = x_idx + offset;
    //                     y_real_values[y_idx] += real_i * x_real_values[x_idx] - imag_i * x_imag_values[x_idx];
    //                     y_imag_values[y_idx] += real_i * x_imag_values[x_idx] + imag_i * x_real_values[x_idx];
    //                 }
    //             }
    //         }
    //     }
    // }

    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        long int dIndex = it->first;
        diagonal *diag = it->second;
        long int dLength = diag->dLength;
        valType *real_vals = diag->getRealValues();
        valType *imag_vals = diag->getImagValues();

        if(dIndex < 0) { // for negative diagonals
            #pragma omp parallel for
            for(long int rep = 0; rep < before_N; rep++) {
                long int skip_places = rep * (after_N * (dLength - dIndex));
                long int x_offset = skip_places;
                long int y_offset = skip_places - after_N * dIndex;
                for(long int i = 0; i < dLength; i++) {
                    long int inner_x_offset = x_offset + i * after_N;
                    long int inner_y_offset = y_offset + i * after_N;
                    #pragma omp parallel for
                    for(long int j = 0; j < after_N; j++) {
                        long int x_idx = inner_x_offset + j;
                        long int y_idx = inner_y_offset + j;
                        // if(x_idx < x_length && y_idx < x_length) {
                            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                        // }
                    }
                }
            }
        }
        else { // for 0th and positive diagonals
            #pragma omp parallel for
            for(long int rep = 0; rep < before_N; rep++) {
                long int skip_places = rep * (after_N * (dLength + dIndex));
                // printf("dLength = %ld, skip_places = %ld\n", dLength, skip_places);
                long int x_offset = after_N * dIndex + skip_places;
                // long int y_offset = skip_places;
                for(long int i = 0; i < dLength; i++) {
                    long int inner_x_offset = x_offset + i * after_N;
                    long int inner_y_offset = skip_places + i * after_N;
                    #pragma omp parallel for
                    for(long int j = 0; j < after_N; j++) {
                        long int x_idx = inner_x_offset + j;
                        long int y_idx = inner_y_offset + j;
                        // if(x_idx < x_length && y_idx < x_length) {
                            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                        // }
                    }
                }
            }
        }
    }

    // long int A_size = gate->matrix_shape[0];

    // // (I kron A kron I) times x = y
    // for (it = diagMap.begin(); it != diagMap.end(); it++) {
    //     diagonal *diag = it->second;
    //     valType *real_vals = diag->realValues;
    //     valType *imag_vals = diag->imagValues;
    //     long int dIndex = it->first;
    //     long int dLength = diag->dLength;
    //     for (long int i = 0; i < dLength; i++) {
    //         valType real_i = real_vals[i];
    //         valType imag_i = imag_vals[i];
    //         // we can skip 0s
    //         if(real_i == 0 && imag_i == 0) {
    //             continue;
    //         }
    //         // each element kinda becomes an I block (scalar val at i times I block), we don't need a multiplication op here at all, instead we can cover over values of A, N times as 1 times something is just something.
    //         long int y_offset = i * before_N;
    //         long int x_offset = i * before_N;
    //         long int new_dIndex = dIndex * before_N;
    //         if(dIndex > 0) {
    //             x_offset += new_dIndex;
    //         }
    //         else if(dIndex < 0) {
    //             y_offset -= new_dIndex;
    //         }
    //         // std::cout << "dIndex = " << dIndex << "; dLength = " << dLength << std::endl;
    //         // std::cout << "\t x_offset = " << x_offset << "; y_offset = " << y_offset << std::endl;

    //         for (long int j = 0; j < after_N; j++) {
    //             // std::cout << "\t\t x_idx = " << j + x_offset << "; y_idx = " << j + y_offset << std::endl;
    //             long int x_idx = j + x_offset;
    //             long int y_idx = j + y_offset;
    //             // logic till here is for matrix times Identity
    //             for(long int block_idx = 0; block_idx < before_N; block_idx++) {

    //                 long int inner_y_idx = block_idx * A_size + x_idx;
    //                 long int inner_x_idx = block_idx * A_size + y_idx;

    //                 // std::cout << " \t\t y_idx = " << y_idx << "; x_idx = " << x_idx << std::endl;
    //                 y_real_values[inner_y_idx] += real_i * x_real_values[inner_x_idx] - imag_i * x_imag_values[inner_x_idx];
    //                 y_imag_values[inner_y_idx] += real_i * x_imag_values[inner_x_idx] + imag_i * x_real_values[inner_x_idx];

    //             }
    //         }
    //     }
    // }

    #ifdef DEBUG
        // // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void identity_kron_matrix_kron_identity_times_vector(long int before, diaQMatrix *gate, long int after, vector *x, vector *y, long int qubit_smaller, long int qubit_larger) {

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    after = 1L << after;
    before = 1L << before;

    long int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    long int *new_gate_shape = new long int[2] {q_diff_exp, q_diff_exp};

    long int x_length = x->numRows_;

    // if(after * before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // vector *y = new vector(after * before * gate->matrix_shape[0]);
    valType *y_real_values = y->realValues_;
    valType *y_imag_values = y->imagValues_;

    valType *x_real_values = x->realValues_;
    valType *x_imag_values = x->imagValues_;

    std::unordered_map<long int, diagonal*> diagMap = gate->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        diagonal *diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        switch(diag->dIndex) {
            case -3: {
                long int dIndex = -1 * q_diff_exp - 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            case -2: {
                long int dIndex = -1 * q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i += 2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[1];
                        imag_val = imag_vals[1];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case -1: {
                long int dIndex = -1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength/2; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                    for(long int i = dLength/2; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[2];
                            valType imag_val = imag_vals[2];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                dIndex = -1 * q_diff_exp + 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 != 0) {
                            valType real_val = real_vals[1];
                            valType imag_val = imag_vals[1];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            case 0: {
                long int dIndex = 0;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength/2; i+=2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[1];
                        imag_val = imag_vals[1];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                    for(long int i = dLength/2; i < dLength; i+=2) {
                        valType real_val = real_vals[2];
                        valType imag_val = imag_vals[2];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[3];
                        imag_val = imag_vals[3];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 1: {
                long int dIndex = 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength/2; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        // printf("y_real_values[%ld] = %f\n", y_idx, y_real_values[y_idx]);
                                        // printf("y_imag_values[%ld] = %f\n", y_idx, y_imag_values[y_idx]);
                                        // printf("x_real_values[%ld] = %f\n", x_idx, x_real_values[x_idx]);
                                        // printf("x_imag_values[%ld] = %f\n", x_idx, x_imag_values[x_idx]);
                                        // printf("real_val = %f\n", real_val);
                                        // printf("imag_val = %f\n", imag_val);
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                    for(long int i = dLength/2; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[2];
                            valType imag_val = imag_vals[2];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                dIndex = q_diff_exp - 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 != 0) {
                            valType real_val = real_vals[1];
                            valType imag_val = imag_vals[1];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            case 2: {
                long int dIndex = q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i += 2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[1];
                        imag_val = imag_vals[1];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 3: {
                long int dIndex = q_diff_exp + 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            default: {
                break;
            }
        }

    }
    
    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void matrix_kron_identity_times_vector(diaQMatrix *A, long n, vector *x, vector *y) {
    // logically combine matrix_kron_identity and spMV

    #ifdef DEBUG
        //start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        printf("matrix_kron_identity_times_vector called\n");
        printf("A matrix below\n");
        A->print();
        printf("\t\n = %ld\n", n);
    #endif

    long int N = 1L << n;

    long int x_length = x->numRows_;

    // if(before * A->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // vector *y = new vector(before * A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues_;
    valType *y_imag_values = y->imagValues_;

    valType *x_real_values = x->realValues_;
    valType *x_imag_values = x->imagValues_;

    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    // (A kron I) times x = y
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        diagonal *diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        long int dIndex = it->first;
        long int dLength = diag->dLength;
        for (long int i = 0; i < dLength; i++) {
            valType real_i = real_vals[i];
            valType imag_i = imag_vals[i];
            // we can skip 0s
            if(real_i == 0 && imag_i == 0) {
                continue;
            }
            // each element kinda becomes an I block (scalar val at i times I block), we don't need a multiplication op here at all, instead we can cover over values of A, N times as 1 times something is just something.
            long int y_offset = i * N;
            long int x_offset = i * N;
            long int new_dIndex = dIndex * N;
            if(dIndex > 0) {
                x_offset += new_dIndex;
            }
            else if(dIndex < 0) {
                y_offset -= new_dIndex;
            }
            // std::cout << "dIndex = " << dIndex << "; dLength = " << dLength << std::endl;
            // std::cout << "\t x_offset = " << x_offset << "; y_offset = " << y_offset << std::endl;
            #pragma omp parallel for
            for (long int j = 0; j < N; j++) {
                // std::cout << "\t\t x_idx = " << j + x_offset << "; y_idx = " << j + y_offset << std::endl;
                y_real_values[j + y_offset] += real_i * x_real_values[j + x_offset] - imag_i * x_imag_values[j + x_offset];
                y_imag_values[j + y_offset] += real_i * x_imag_values[j + x_offset] + imag_i * x_real_values[j + x_offset];
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

    #ifdef DEEP_DEBUG
        printf("matrix_kron_identity_times_vector done\n");
        printf("y vector below\n");
        y->print();
    #endif

}

void matrix_kron_identity_times_vector(diaQMatrix *gate, long after, vector *x, vector *y, long int qubit_smaller, long int qubit_larger) {
    // logically combine matrix_kron_identity and spMV

    #ifdef DEBUG
        //start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    after = 1L << after;

    long int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    long int *new_gate_shape = new long int[2] {q_diff_exp, q_diff_exp};

    long int x_length = x->numRows_;

    // if(before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // vector *y = new vector(before * gate->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues_;
    valType *y_imag_values = y->imagValues_;

    valType *x_real_values = x->realValues_;
    valType *x_imag_values = x->imagValues_;

    std::unordered_map<long int, diagonal*> diagMap = gate->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        diagonal *diag = it->second;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        switch(diag->dIndex) {
            case -3: {
                long int dIndex = -1 * q_diff_exp - 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case -2: {
                long int dIndex = -1 * q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] += %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[1];
                    each_imag = imag_vals[1];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                break;
            }
            case -1: {
                long int dIndex = -1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength/2; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                for(long int i = dLength/2; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[2];
                        valType each_imag = imag_vals[2];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                dIndex = -1 * q_diff_exp + 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i++) {
                    if( i% 2 != 0) {
                        valType each_real = real_vals[1];
                        valType each_imag = imag_vals[1];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 0: {
                long int dIndex = 0;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength/2; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[1];
                    each_imag = imag_vals[1];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                for(long int i = dLength/2; i < dLength; i+=2) {
                    valType each_real = real_vals[2];
                    valType each_imag = imag_vals[2];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[3];
                    each_imag = imag_vals[3];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                break;
            }
            case 1: {
                long int dIndex = 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength/2; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                for(long int i = dLength/2; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[2];
                        valType each_imag = imag_vals[2];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                dIndex = q_diff_exp - 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i++) {
                    if( i% 2 != 0) {
                        valType each_real = real_vals[1];
                        valType each_imag = imag_vals[1];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 2: {
                long int dIndex = q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[1];
                    each_imag = imag_vals[1];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                break;
            }
            case 3: {
                long int dIndex = q_diff_exp + 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t matrix_kron_identity_times_vector (non-adj) took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

diaQMatrix *matrix_kron_identity(diaQMatrix *A, long int n) { // we can combine this with operations that happen later.

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    n = 1L << n;

    // assume a nxn identity matrix, which has one diagonal of length n, in index 0.
    // we just repeat A, n times in the result matrix
    long int *result_shape = new long int[2] {n * A->matrix_shape[0], n * A->matrix_shape[1]};
    diaQMatrix *result = new diaQMatrix(&result_shape);
    std::unordered_map<long int, diagonal*> diagMap = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator it;
    #pragma omp parallel for
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        long int dIndex = it->first;
        diagonal *diag = it->second;
        long int dLength = diag->dLength;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->getRealValues();
        valType *imag_vals = diag->getImagValues();
        // result diag
        diagonal *newDiag = new diagonal(dIndex * n, result->getDiagonalLength(dIndex * n));
        // printf("srik\n");
        // newDiag->print_meta();
        // printf("awesome\n");
        valType *newDiag_real_vals = newDiag->getRealValues();
        valType *newDiag_imag_vals = newDiag->getImagValues();

        #pragma omp parallel for
        for(long int i = 0; i < dLength; i++) {
            valType each_real = real_vals[i];
            valType each_imag = imag_vals[i];            
            for(long int j = 0; j < n; j++) {
                newDiag_real_vals[j + i * n] = each_real;
                newDiag_imag_vals[j + i * n] = each_imag;
            }
        }

        result->setDiagonal(dIndex * n, newDiag);
    }
    // result->pruneMatrix();

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t matrix_kron_identity took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return result;
}

diaQMatrix *kron_product_old(diaQMatrix *A, diaQMatrix *B) {
    // A: m x n
    // B: p x q
    // C: mp x nq
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- kron product --- " << std::endl;
        std::cout << " --- " << std::endl;
        A->print();
        std::cout << " --- times --- " << std::endl;
        B->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int *shape_a = A->matrix_shape;
    long int *shape_b = B->matrix_shape;

    // map of combination of A diagonal index, A diagonal position to multiply_by_scalar matrix. The individual blocks of matrices: A11 * B, A12 * B, A21 * B, A22 * B, ...
    std::map<std::pair<long int, long int>, std::pair<valType, valType>> kron_map;

    // map of unique A elements and their corresponding kron blocks
    std::map<std::pair<valType, valType>, diaQMatrix *> unique_kron_blocks;

    // Calculate dimensions for the resulting matrix
    long int *result_shape = new long int[2];
    result_shape[0] = shape_a[0] * shape_b[0];
    result_shape[1] = shape_a[1] * shape_b[1];
    diaQMatrix *result = new diaQMatrix(&result_shape);

    std::unordered_map<long int, diagonal*> A_diagonalMap = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator itA;

    // printf("kron here 0\n");

    // for each element in A, do multiply_by_scalar with B and add to kron_list.
    // paralleize this later. TODO
    for (itA = A_diagonalMap.begin(); itA != A_diagonalMap.end(); itA++) {
        long int diagonal_index = itA->first;
        diagonal *diag = itA->second;
        long int diagonal_length = diag->dLength;

        #pragma omp parallel for
        for(long int diagonal_position = 0; diagonal_position < diagonal_length; diagonal_position++) {
            // skippihg zero elements
            if(diag->getRealValue(diagonal_position) == 0.0 && diag->getImagValue(diagonal_position) == 0.0) {
                continue;
            }

            // printf("kron here 1\n");

            diaQMatrix *kron_block;
            // dynamic programming for unique kron blocks
            if(unique_kron_blocks.find(std::pair<valType, valType>(diag->getRealValue(diagonal_position), diag->getImagValue(diagonal_position))) == unique_kron_blocks.end()) {
                kron_block = multiply_by_scalar(B, diag->getRealValue(diagonal_position), diag->getImagValue(diagonal_position));
                // printf("printing kron_block\n");
                // kron_block->print();
                // store in unique_kron_blocks
                unique_kron_blocks.insert(std::pair<std::pair<valType, valType>, diaQMatrix *>(std::pair<valType, valType>(diag->getRealValue(diagonal_position), diag->getImagValue(diagonal_position)), kron_block));
            }

            // printf("kron here 2\n");

            long int *A_pos = A->getMatrixPosition(diagonal_index, diagonal_position);
            std::pair<long int, long int> key = std::make_pair(A_pos[0], A_pos[1]);
            std::pair<valType, valType> val = std::make_pair(diag->getRealValue(diagonal_position), diag->getImagValue(diagonal_position));
            kron_map.insert(std::pair<std::pair<long int, long int>, std::pair<valType, valType>>(key, val));
        }
    }
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << "kron_map.size() = " << kron_map.size() << std::endl;
        std::cout << " --- " << std::endl;
    #endif

    // pre-allocate resutl's diagonals and paralleize this below later,! TODO

    // traverse kron_map and add to result.
    std::map<std::pair<long int, long int>, std::pair<valType, valType>>::iterator it;
    #pragma omp parallel for
    for (it = kron_map.begin(); it != kron_map.end(); it++) {
        // for each element in A
        long int A_mat_pos[2];
        A_mat_pos[0] = it->first.first;
        A_mat_pos[1] = it->first.second;
        // get kron_block from unique_kron_blocks
        diaQMatrix *kron_block = unique_kron_blocks.find(it->second)->second;

        // we now have to add to result's res_diag_index at res_diag_pos
        std::unordered_map<long int, diagonal*> kron_block_diagMap = kron_block->getDiagonalMap();
        std::unordered_map<long int, diagonal*>::iterator itK;

        #pragma omp parallel for
        for (itK = kron_block_diagMap.begin(); itK != kron_block_diagMap.end(); itK++) {

            long int kron_block_diag_index = itK->first;
            diagonal *kron_block_diag = itK->second;
            long int kron_block_diag_length = kron_block_diag->dLength;

            #pragma omp parallel for
            for(long int kron_block_diag_position = 0; kron_block_diag_position < kron_block_diag_length; kron_block_diag_position++) {

                long int *B_mat_pos = kron_block->getMatrixPosition(kron_block_diag_index, kron_block_diag_position);
                long int res_mat_pos[2] = {A_mat_pos[0] * shape_b[0] + B_mat_pos[0], A_mat_pos[1] * shape_b[1] + B_mat_pos[1]};
                long int *res_diag_pos = result->getDiagonalPosition(res_mat_pos);

                #ifdef DEEP_DEBUG
                    std::cout << "A_mat_pos = (" << A_mat_pos[0] << ", " << A_mat_pos[1] << ")" << std::endl;
                    std::cout << "B_mat_pos = (" << B_mat_pos[0] << ", " << B_mat_pos[1] << ")" << std::endl;
                    std::cout << "res_mat_pos = (" << res_mat_pos[0] << ", " << res_mat_pos[1] << ")" << std::endl;
                    std::cout << "res_diag_pos = (" << res_diag_pos[0] << ", " << res_diag_pos[1] << ")" << std::endl;
                #endif

                result->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], result->getDiagonalLength(res_diag_pos[0]), kron_block_diag->getRealValue(kron_block_diag_position), kron_block_diag->getImagValue(kron_block_diag_position));
            }
        }
    }

    // result->pruneMatrix(); // Prune the resulting matrix if necessary; we don't actually need this :thinking

    // // for now let's just convert to dense, do the kron product and convert back to diaq
    // denseMatrix denseA = A.convertToDenseMatrix(A->shape);
    // denseMatrix denseB = B.convertToDenseMatrix(B->shape);
    // denseMatrix denseC = dense_kron_product(denseA, denseB);
    // diaQMatrix result = denseC.convertToQuantumSparse(denseC->shape);

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- kron result --- " << std::endl;
        std::cout << " --- " << std::endl;
        result->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t Kron product took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return result;
}

diaQMatrix *kron_product(diaQMatrix *A, diaQMatrix *B, valType c) {
    return multiply_by_scalar(kron_product(A, B), c, 1.0);
}

diaQMatrix* dagger(diaq::diaQMatrix *A) {
    // dagger is conjugate transpose
    // conjugate first
    diaQMatrix *res = multiply_by_scalar(A, 1.0, -1.0);
    // then transpose
    return transpose(res);
}

diaQMatrix *conjbar(diaQMatrix *A) {
    return multiply_by_scalar(A, 1.0, -1.0);
}

diaQMatrix* expm_negative(diaQMatrix *A, valType t) {
    // Computes e^(-i * A * t) using the Taylor series expansion
    // e^(-i * A * t) ≈ I - i * A * t + (-i * A * t)^2 / 2! + (-i * A * t)^3 / 3! + ...
    // Stops when terms become negligibly small or reach a max iteration count.

    #ifdef DEBUG
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    // Initialize result as the identity matrix
    diaQMatrix *result = new identityMatrix(A->matrix_shape[0]);

    if(A->num_diags() == 1 && A->getDiagonal(0) != nullptr) {
        diagonal *d = A->getDiagonal(0);
        long int dLength = d->dLength;
        valType *real_vals = d->getRealValues();
        valType *imag_vals = d->getImagValues();

        diagonal *res_diag = result->getDiagonal(0);
        valType *res_real_vals = res_diag->getRealValues();
        valType *res_imag_vals = res_diag->getImagValues();

        // Compute exact exp(-i A t) for diagonal elements
        #pragma omp parallel for
        for(long int i = 0; i < dLength; i++) {
            valType a_i = real_vals[i];
            valType b_i = imag_vals[i];

            valType exp_b = std::exp(t * b_i); // e^(t b_i)
            res_real_vals[i] = exp_b * std::cos(t * a_i);
            res_imag_vals[i] = -exp_b * std::sin(t * a_i);
        }

        return result;
    }

    // Parameters
    int max_iterations = 50; // Limit to avoid infinite loops
    valType tolerance = 1e-6; // Tolerance for convergence

    // Initialize the first term in the series as I (identity)
    diaQMatrix *term_so_far = new identityMatrix(A->matrix_shape[0]);

    // std::cout << "Starting Taylor expansion for e^(-i * A * t)..." << std::endl;

    // Iterative Taylor expansion
    for (int n = 1; n <= max_iterations; ++n) {

        // Multiply the term by A
        term_so_far->multiplyMatrix(A);
        valType imag_scale = -1 * t / n;
        // Multiply the term by -i * t / n
        term_so_far->multiply_by_imag(imag_scale);
        // so in second iteration, we multiply by -i * A * t / 2!

        // add the term to the result
        result->addMatrix(term_so_far);

        #ifdef DEEP_DEBUG
            std::cout << "Iteration " << n << "..." << std::endl;
            std::cout << "---" << std::endl;
            std::cout << "Term: " << std::endl;
            term_so_far->print();
            std::cout << "---" << std::endl;
            std::cout << "Result: " << std::endl;
            result->print();
            std::cout << "---" << std::endl;
        #endif

        // Check for convergence (small values in term)
        if (term_so_far->norm() < tolerance) {
            #ifdef DEEP_DEBUG
                std::cout << "---" << std::endl;
                std::cout << "Converged after " << n << " iterations.\n" << std::endl;
                std::cout << "---" << std::endl;
            #endif

            break; // break if criteria met
        }
    }

    // Clean up
    delete term_so_far;

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t expm_negative took %f milliseconds\n", duration.count() / 1000.0);
    #endif

    return result;
}


diaQMatrix *diaQMatrix::multiplyMatrix(diaQMatrix *B) {
    std::unordered_map<long int, diagonal*> BDiagMap = B->getDiagonalMap();
    std::unordered_map<long int, diagonal*> newDiagMap;
    for (auto itA = diagonalMap.begin(); itA != diagonalMap.end(); itA++) {
        long int dIndexA = itA->first;
        diagonal *dA = itA->second;
        for (auto itB = BDiagMap.begin(); itB != BDiagMap.end(); itB++) {
            long int dIndexB = itB->first;
            diagonal *dB = itB->second;
            diagonal *dNew = multiplyDiagonals(matrix_shape, matrix_shape, dIndexA, dIndexB, dA, dB);
            if (dNew != nullptr) {
                newDiagMap.insert({dNew->dIndex, dNew});
            }
        }
    }
    this->diagonalMap = newDiagMap;
    return this;
}

diaQMatrix *diaQMatrix::multiply_by_imag(valType imag) {
    #pragma omp parallel for
    for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {

        diagonal *d = it->second;
        valType *real_vals = d->getRealValues();
        valType *imag_vals = d->getImagValues();
        #pragma omp simd
        for (long int i = 0; i < d->dLength; i++) {
            real_vals[i] = -1.0 * imag_vals[i] * imag;
            imag_vals[i] = real_vals[i] * imag;
        }
    }
    return this;
}

} // namespace diaq