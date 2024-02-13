#include "matrixKernels.hpp"

#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

void run_without_vectorization(long int k, long int lenRes, long int offsetA, long int offsetB, long int jump, long int lenDiagA, long int lenDiagB, valType *real_vals_a, valType *imag_vals_a, valType *real_vals_b, valType *imag_vals_b, valType *real_vals_final, valType *imag_vals_final) {
    // no vectorization
    logger.log("No vectorization");
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
        logger.log("Using AVX-Double vectorization");
        long int loop_count = 0;
        long int k_cpy = k;
        while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
            loop_count++;
            k_cpy++;
        }
        __m256d real_a, real_b; // a for valuesA and b for valuesB
        __m256d imag_a, imag_b; // a for valuesA and b for valuesB
        __m256d real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        long int left_overs = loop_count - ((loop_count / 8) * 8);
        long int vec_loop = (loop_count / 8);
        long int left_overs_start_at_A = k + offsetA - jump + 8 * (loop_count / 8);
        long int left_overs_start_at_B = k + offsetB - jump + 8 * (loop_count / 8);

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

            k += 8;
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

            k += left_overs;
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
        logger.log("Using AVX-Float vectorization");
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

        while (vec_loop--) {
            real_a = _mm256_loadu_ps(&real_vals_a[k + offsetA - jump]);
            imag_a = _mm256_loadu_ps(&imag_vals_a[k + offsetA - jump]);
            real_b = _mm256_loadu_ps(&real_vals_b[k + offsetB - jump]);
            imag_b = _mm256_loadu_ps(&imag_vals_b[k + offsetB - jump]);

            real_reala_realb = _mm256_mul_ps(real_a, real_b);
            real_imaga_imagb = _mm256_mul_ps(imag_a, imag_b);
            real_res = _mm256_sub_ps(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm256_mul_ps(real_a, imag_b);
            imag_imaga_realb = _mm256_mul_ps(imag_a, real_b);
            imag_res = _mm256_add_ps(imag_reala_imagb, imag_imaga_realb);

            _mm256_store_ps(&real_vals_final[k], real_res);
            _mm256_store_ps(&imag_vals_final[k], imag_res);

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

            k += left_overs;
        }
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
        logger.log("Using SSE-Float vectorization");
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

            k += left_overs;
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
        logger.log("Using SSE-Double vectorization");
        long int loop_count = 0;
        long int k_cpy = k;
        while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
            loop_count++;
            k_cpy++;
        }
        __m128d real_a, real_b; // a for valuesA and b for valuesB
        __m128d imag_a, imag_b; // a for valuesA and b for valuesB
        __m128d real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;
        long int left_overs = loop_count - ((loop_count / 4) * 4);
        long int vec_loop = (loop_count / 4);
        long int left_overs_start_at_A = k + offsetA - jump + 4 * (loop_count / 4);
        long int left_overs_start_at_B = k + offsetB - jump + 4 * (loop_count / 4);

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

            k += 4;
        }
        if (left_overs != 0) {
            real_a = sse_load_partial_double(left_overs, &real_vals_a[left_overs_start_at_A]);
            imag_a = sse_load_partial_double(left_overs, &imag_vals_a[left_overs_start_at_A]);
            real_b = sse_load_partial_double(left_overs, &real_vals_b[left_overs_start_at_B]);
            imag_b = sse_load_partial_double(left_overs, &imag_vals_b[left_overs_start_at_B]);

            real_reala_realb = _mm_mul_pd(real_a, real_b);
            real_imaga_imagb = _mm_mul_pd(imag_a, imag_b);
            real_res = _mm_sub_pd(real_reala_realb, real_imaga_imagb);

            imag_reala_imagb = _mm_mul_pd(real_a, imag_b);
            imag_imaga_realb = _mm_mul_pd(imag_a, real_b);
            imag_res = _mm_add_pd(imag_reala_imagb, imag_imaga_realb);

            sse_store_partial_double(left_overs, &real_vals_final[k], real_res);
            sse_store_partial_double(left_overs, &imag_vals_final[k], imag_res);

            k += left_overs;
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
long int getDiagonalLength(long int dIndex, std::vector<long int> shape) {
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
diagonal multiplyDiagonals(std::vector<long int> shapeA, std::vector<long int> shapeB, long int indexA, long int indexB, diagonal diagA, diagonal diagB) {
    if(indexA + indexB >= shapeB[1]) {
        return diagonal(0, 0);
    }
    else if(indexA + indexB <= -1 * shapeA[0]) {
        return diagonal(0, 0);
    }
    long int lenDiagA = diagA.dLength;
    long int lenDiagB = diagB.dLength;
    // result matrix has dimensions {shapeA[0], shapeB[1]}
    std::vector<long int> res_dims{shapeA[0], shapeB[1]};
    long int lenRes = getDiagonalLength(indexA + indexB, res_dims);
    diagonal res(indexA + indexB, lenRes);
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
	valType *real_vals_a = diagA.getRealValues();
    valType *imag_vals_a = diagA.getImagValues();
    valType *real_vals_b = diagB.getRealValues();
    valType *imag_vals_b = diagB.getImagValues();
	valType *real_vals_final = res.getRealValues();
    valType *imag_vals_final = res.getImagValues();
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
diaQMatrix product(diaQMatrix A, diaQMatrix B) {
    // #ifdef CUDA_ENABLED
    //     return product_cuda(&A, &B);
    // #else
    // if(logger.log_level == DEBUG) {
    //     std::cout << " --- " << std::endl;
    //     std::cout << " --- product --- " << std::endl;
    //     std::cout << " --- " << std::endl;
    //     A.print();
    //     std::cout << " --- times --- " << std::endl;
    //     B.print();
    //     std::cout << " --- " << std::endl;
    // }
    if(A.matrix_shape[1] != B.matrix_shape[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    std::vector<long int> d{A.matrix_shape[0], B.matrix_shape[1]};
    diaQMatrix* result = new diaQMatrix(&d);
    // diaQMatrix* resptr = &result;
    std::unordered_map<long int, diagonal> mapA = A.getDiagonalMap();
    std::unordered_map<long int, diagonal> mapB = B.getDiagonalMap();
    std::unordered_map<long int, diagonal>::iterator itA, itB;
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        for (itB = mapB.begin(); itB != mapB.end(); itB++) {
            // std::cout << " ------ diags ------ " << std::endl;
            // itA->second.print();
            // itB->second.print();
            // std::cout << " ------ diags ------ " << std::endl;
            // std::cout << " --- " << std::endl;
            diagonal diagNew = multiplyDiagonals(A.matrix_shape, B.matrix_shape, itA->first, itB->first, itA->second, itB->second);
            if(diagNew.dLength != 0 && !diagNew.isEmpty()) {
                // std::cout << " ------ new diag ------ " << std::endl;
                // diagNew.print();
                // std::cout << " ------ new diag ------ " << std::endl;
                result->addDiagonal(itA->first + itB->first, diagNew);
                // std::cout << " ------ result ------ " << std::endl;
                // result->print();
                // std::cout << " ------ result ------ " << std::endl;
            } else {
                // std::cout << "diagonal does not exist" << std::endl;
            }
        }
    }
    result->pruneMatrix();
    // std::cout << " ------ final result ------ " << std::endl;
    // result->print();
    // std::cout << " ------ final result ------ " << std::endl;
    // result->print();
    if (logger.log_level == DEEP_DEBUG) {
        std::cout << " --- " << std::endl;
		// --- First matrix ---
		std::unordered_map<long int, diagonal> A_diagonalMap = A.getDiagonalMap();
        // get keys of A_diagonalMap
        std::vector<long int> A_keys;
        std::unordered_map<long int, diagonal>::iterator A_it;
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
        std::unordered_map<long int, diagonal> B_diagonalMap = B.getDiagonalMap();
        // get keys of B_diagonalMap
        std::vector<long int> B_keys;
        std::unordered_map<long int, diagonal>::iterator B_it;
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
        std::unordered_map<long int, diagonal> result_diagonalMap = result->getDiagonalMap();
        // get keys of result_diagonalMap
        std::vector<long int> result_keys;
        std::unordered_map<long int, diagonal>::iterator result_it;
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
	}
    // if(logger.log_level == DEBUG) {
    //     std::cout << " --- " << std::endl;
    //     std::cout << " --- product result --- " << std::endl;
    //     std::cout << " --- " << std::endl;
    //     result->print();
    //     std::cout << " --- " << std::endl;
    // }
    return *result;
    // #endif
}

/**
 * @brief dense matrix multiplication (C = A.B)
 * 
 * @param A denseMatrix
 * @param B denseMatrix
 * 
 * @return denseMatrix  C
 */
denseMatrix denseProduct(denseMatrix A, denseMatrix B) {
    std::vector<long int> shape_a = A.matrix_shape;
    std::vector<long int> shape_b = B.matrix_shape;
    if(shape_a[1] != shape_b[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    valType *real_res = (valType *)calloc(shape_a[0] * shape_b[1], sizeof(valType));
    valType *imag_res = (valType *)calloc(shape_a[0] * shape_b[1], sizeof(valType));
    std::vector<long int> d{A.matrix_shape[0], B.matrix_shape[1]};
    denseMatrix result(&d, real_res, imag_res);
    for(long int i = 0; i < shape_a[0]; i++) {
        for(long int k = 0; k < shape_b[1]; k++) {
            std::complex<valType> res = 0.0;
            for(long int j = 0; j < shape_b[0]; j++) {
                res += A.get(i, j) * B.get(j, k);
            }
            result.set(i, k, res);
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
diagonal addElements(diagonal A, diagonal B) {
    valType *real_valsA = A.getRealValues();
    valType *imag_valsA = A.getImagValues();
    valType *real_valsB = B.getRealValues();
    valType *imag_valsB = B.getImagValues();
    if(A.dLength != B.dLength ) {
        throw std::invalid_argument("diagonals are of different lengths!");
    }
    valType *real_valsC = (valType *)calloc(A.dLength, sizeof(valType));
    valType *imag_valsC = (valType *)calloc(A.dLength, sizeof(valType));
    #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
    for(long int i=0; i < A.dLength; i++) {
        real_valsC[i] = real_valsA[i] + real_valsB[i];
        imag_valsC[i] = imag_valsA[i] + imag_valsB[i];
    }
    return diagonal(A.dIndex, A.dLength, real_valsC, imag_valsC);
}

diaQMatrix add(diaQMatrix A, diaQMatrix B) {
    if(A.getSize() != B.getSize()) {
        throw std::invalid_argument("input matrices are of different dimensions, not compatible");
    }
    diaQMatrix* result = new diaQMatrix(A.getSize());
    std::unordered_map<long int, diagonal> mapA = A.getDiagonalMap();
    std::unordered_map<long int, diagonal> mapB = B.getDiagonalMap();
    std::unordered_map<long int, diagonal>::iterator itA, itB;
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        itB = mapB.find(itA->first);
        if (itB == mapB.end()) {
            result->addDiagonal(itA->first, itA->second);
        } else {
            result->addDiagonal(itA->first, addElements(itA->second, itB->second));
        }
    }
    // result->pruneMatrix();
    return *result;
}


std::complex<valType> trace(diaQMatrix A) {
    std::complex<valType> t;
    std::unordered_map<long int, diagonal>::iterator itA;
    std::unordered_map<long int, diagonal> mapA = A.getDiagonalMap();
    itA = mapA.find(0);
    if(itA == mapA.end()) {
        return t;
    }
    for(long int i=0; i < itA->second.dLength; i++) {
        t += itA->second.getValue(i);
    }
    return t;
}

diaQMatrix reshape(diaQMatrix A, std::vector<long int> new_tensor_shape) {
    // std::cout << "diaq/reshape called with newshape (";
    // for(long int i = 0; i < new_tensor_shape.size()-1; i++) {
    //     std::cout << new_tensor_shape[i] << ",";
    // }
    // std::cout << new_tensor_shape[new_tensor_shape.size()-1] << ")" << std::endl;

    long int old_product = 1;
    #pragma unroll
    for(long int i=0; i < A.shape.size(); i++) old_product *= A.shape[i];
    long int new_product = 1;
    #pragma unroll
    for(long int i=0; i < new_tensor_shape.size(); i++) new_product *= new_tensor_shape[i];
    if(old_product != new_product) {
        std::cout << old_product << "!=" << new_product << std::endl;
        throw std::invalid_argument("cannot reshape long into given shape");
    }
    long int l = new_tensor_shape.size();
    // this shape is important! decides the length of diagonals! Hence, we have to re-write it to maximize length of diagonals, so that number of diagonls are minimized.
    std::vector<long int> new_shape;
    if(l > 2) {
        std::vector<long int> temp{1,1};
        new_shape = temp;
        long int i = l / 2;
        #pragma unroll
        for(long int r = 0; r<i ; r++) {
            new_shape[0] = new_shape[0] * new_tensor_shape[r];
        }
        #pragma unroll
        for(long int r = i; r<l ; r++) {
            new_shape[1] = new_shape[1] * new_tensor_shape[r];
        }
    } else {
        new_shape = new_tensor_shape;
    }
    std::unordered_map<long int, diagonal> newDiagMap;
    // TODO: allocate for all possible diaognal indices and it's lengths. To paralleize later.
    diaQMatrix res{newDiagMap, &new_shape, &new_tensor_shape};
    std::unordered_map<long int, diagonal> diagonalMap = A.getDiagonalMap();
    std::unordered_map<long int, diagonal>::iterator it;


    #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
    for(long int i = -1 * res.matrix_shape[0]; i < res.matrix_shape[1]; i++) {
        res.createDiagonal(i);
    }

    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        valType *real_vals = it->second.getRealValues();
        valType *imag_vals = it->second.getImagValues();
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < it->second.dLength; i++) {
            // std::cout << "(diagonal_idx, diagonal_pos) = (" << it->first << ", " << i << ")" << std::endl;
            // std::cout << "element = " << vals[i] << std::endl;
            std::vector<long int> ten_pos = A.getTensorPosition(it->first, i);
            // std::cout << "tensor index = (";
            // for(long int i = 0; i < ten_pos.size()-1; i++) {
            //     std::cout << ten_pos[i] << ",";
            // }
            // std::cout << ten_pos[ten_pos.size()-1] << ")" << std::endl;

            std::vector<long int> d_pos = res.getDiagonalPositionByFlatIndex(A.getFlatIndex(ten_pos));
            // std::cout << "(new_diagonal_idx, new_diagonal_pos) = (" << d_pos[0] << ", " << d_pos[1] << ")" << std::endl;
            long int d_len = getDiagonalLength(d_pos[0], res.matrix_shape);
            res.setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
            // std::cout << " -- " << std::endl;
        }
    }
    res.pruneMatrix();
    return res;
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

std::vector<long int> modifyTensorShape(std::vector<long int> tShape, std::vector<long int> axes) {
    std::vector<long int> nShape;
    int tShapeSize = tShape.size();
    if(axes.size() == 0) {
        nShape.resize(tShape.size(), 1);
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < tShape.size(); i++) {
            nShape[i] = tShape[tShapeSize - i - 1];
        }
    }
    else {
        nShape.resize(axes.size(), 1);
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < axes.size(); i++) {
            nShape[i] = tShape[axes[i]];
        }
    }
    return nShape;
}

diaQMatrix transpose(diaQMatrix A, std::vector<long int> new_order) {
    if(new_order.size() == 0) {
        new_order.resize(A.shape.size(), 1);
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < A.shape.size(); i++) {
            new_order[i] = A.shape.size() - i - 1;
        }
    }
    // std::cout << "diaq/transpose called with axes (";
    // for(long int i = 0; i < new_order.size()-1; i++) {
    //     std::cout << new_order[i] << ",";
    // }
    // std::cout << new_order[new_order.size()-1] << ")" << std::endl;

    // tranpose of the diagonals
    if(A.shape.size() == 2) {
        std::vector<long int> newShape{A.matrix_shape[1], A.matrix_shape[0]};
        std::unordered_map<long int, diagonal> diagMap = A.getDiagonalMap();
        std::unordered_map<long int, diagonal>::iterator it;
        std::unordered_map<long int, diagonal> newDiagMap;
        for (it = diagMap.begin(); it != diagMap.end(); it++) {
            newDiagMap.insert(std::pair<long int, diagonal>(-1 * it->first, it->second));
        }
        A.setDiagonalMap(newDiagMap);
        // swap A.shape[0] and A.shape[1] and similarly for matrix_shape.
        long int temp = A.shape[0];
        A.shape[0] = A.shape[1];
        A.shape[1] = temp;
        temp = A.matrix_shape[0];
        A.matrix_shape[0] = A.matrix_shape[1];
        A.matrix_shape[1] = temp;
        return A;
    }
    // otherwise, we have to do a lot of work
    // shape of result
    std::vector<long int> new_tensor_shape = modifyTensorShape(A.shape, new_order);
    // std::cout << "gives new_tensor_shape (";
    // for(long int i = 0; i < new_tensor_shape.size()-1; i++) {
    //     std::cout << new_tensor_shape[i] << ",";
    // }
    // std::cout << new_tensor_shape[new_tensor_shape.size()-1] << ")" << std::endl;
    // now, let's perform the transpose element by element
    long int l = new_tensor_shape.size();
    // this shape is important! decides the length of diagonals! Hence, we have to re-write it to maximize length of diagonals, so that number of diagonls are minimized.
    std::vector<long int> new_shape{1,1};
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
    std::unordered_map<long int, diagonal> newDiagMap;
    // TODO: allocate for all possible diaognal indices and it's lengths. To paralleize later.
    diaQMatrix res{newDiagMap, &new_shape, &new_tensor_shape};
    // iterate over all diagonals
    std::unordered_map<long int, diagonal>::iterator it;
    std::unordered_map<long int, diagonal> diagonalMap = A.getDiagonalMap();

    #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
    for(long int i = -1 * res.matrix_shape[0]; i < res.matrix_shape[1]; i++) {
        res.createDiagonal(i);
    }

    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {

        valType *real_vals = it->second.getRealValues();
        valType *imag_vals = it->second.getImagValues();

        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < it->second.dLength; i++) {
            // std::cout << "(diagonal_idx, diagonal_pos) = (" << it->first << ", " << i << ")" << std::endl;
            // std::cout << "element = " << vals[i] << std::endl;
            std::vector<long int> ten_pos = A.getTensorPosition(it->first, i);
            // std::cout << "tensor index = (";
            // for(long int i = 0; i < ten_pos.size()-1; i++) {
            //     std::cout << ten_pos[i] << ",";
            // }
            // std::cout << ten_pos[ten_pos.size()-1] << ")" << std::endl;

            // modify ten_pos to perform the transposition using the new_order
            std::vector<long int> new_ten_pos(new_order.size(), 1);
            #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
            for(long int i=0; i < new_order.size(); i++) {
                new_ten_pos[i] = ten_pos[new_order[i]];
            }

            std::vector<long int> d_pos = res.getDiagonalPosition(new_ten_pos);
            // std::cout << "(new_diagonal_idx, new_diagonal_pos) = (" << d_pos[0] << ", " << d_pos[1] << ")" << std::endl;
            long int d_len = getDiagonalLength(d_pos[0], new_shape);
            res.setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
            // std::cout << " -- " << std::endl;
        }
    }
    res.pruneMatrix();
    return res;
}

diaQMatrix transpose(diaQMatrix A) {
    return transpose(A, std::vector<long int>());   
}

diaQMatrix tensordot(diaQMatrix A, diaQMatrix B, std::vector<std::vector<long int> > axes) {
    // std::cout << "--" << std::endl;
    // std::cout << "tensordot called for A - " << std::endl;
    // A.print();
    // std::cout << "and B - " << std::endl;
    // B.print();
    // std::cout << "with axes - " << " (";
    // long int i=0;
    // for(i=0; i<axes[0].size()-1; i++)
    //     std::cout << axes[0][i] << ",";
    // std::cout << axes[0][i] << ") and (";
    // for(i=0; i<axes[1].size()-1; i++)
    //     std::cout << axes[1][i] << ",";
    // std::cout << axes[1][i] << ")" << std::endl;
    // std::cout << "--" << std::endl;

    diaQMatrix res = diaQMatrix((long int)(0));
    // move axes
    std::vector<long int> order_A;
    std::vector<long int> order_B;
    #pragma unroll
    for(long int i = 0; i < axes[1].size(); i++)
        order_B.push_back(axes[1][i]);
    for(long int i = 0; i < A.shape.size(); i++) {
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
    for(long int i = 0; i < B.shape.size(); i++) {
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
    for(long int i=0;i<axes[0].size();i++) axes_0_product *= A.shape[axes[0][i]];
    long int axes_1_product = 1;
    #pragma unroll
    for(long int i=0;i<axes[1].size();i++) axes_1_product *= B.shape[axes[1][i]];

    A = transpose(A, order_A);
    // A.print();
    B = transpose(B, order_B);
    // B.print();

    long int totalA = A.matrix_shape[0] * A.matrix_shape[1];
    long int totalB = B.matrix_shape[0] * B.matrix_shape[1];

    // std::cout << "axes_0_product = " << axes_0_product << " axes_1_product = " << axes_1_product << std::endl;
    // These have to be equal right? Let's add a check
    if(axes_1_product != axes_0_product) {
        std::cout << "axes_1_product != axes_0_product i.e. " << axes_1_product << " != " << axes_0_product << std::endl;
        throw std::invalid_argument("invalid axes, can't perform tensordot");
    }

    std::vector<long int> new_shape_a{totalA / axes_0_product, axes_0_product};
    std::vector<long int> new_shape_b{axes_1_product, totalB / axes_1_product};

    diaQMatrix reshaped_A = reshape(A, new_shape_a);
    diaQMatrix reshaped_B = reshape(B, new_shape_b);

    // std::cout << "after reshape A - " << std::endl;
    // reshaped_A.convertToDenseMatrix(reshaped_A.shape).print();
    // std::cout << "and B - " << std::endl;
    // reshaped_B.convertToDenseMatrix(reshaped_B.shape).print();

    res = product(reshaped_A, reshaped_B);

    // calculating result's tensor_shape
    res.shape = newTensorShape(A.shape, B.shape, axes[0], axes[1]);
    res.pruneMatrix();
    return res;
}

diaQMatrix array(diaQMatrix A) {
    // std::cout << "array called for A - " << std::endl;
    // A.print();
    // TODO: unclear as of now what this mehthod should be doing
    return A;
}

diaQMatrix einsum(diaQMatrix A, std::vector<long int> axes) {
    std::cout << axes[0] << std::endl;
    return A;
}

// overloading operators
diaQMatrix operator*(const diaQMatrix &A, const diaQMatrix &B) {
    return product(A, B);
}
diaQMatrix operator+(const diaQMatrix &A, const diaQMatrix &B) {
    return add(A, B);
}

diaQMatrix diaQMatrix::reshape(std::vector<long int> new_tensor_shape) {
    return diaq::reshape(*this, new_tensor_shape);
}

diaQMatrix diaQMatrix::transpose(std::vector<long int> new_order) {
    return diaq::transpose(*this, new_order);
}


vector spMV(diaQMatrix A, vector x) {
    #ifdef CUDA_ENABLED
        return spmv_cuda(&A, &x);
    #else
    // if(logger.log_level == DEBUG) {
    //     std::cout << " --- " << std::endl;
    //     std::cout << " --- spMV --- " << std::endl;
    //     std::cout << " --- " << std::endl;
    //     A.print();
    //     std::cout << " --- times --- " << std::endl;
    //     x.print();
    //     std::cout << " --- " << std::endl;
    // }
    // // measure start time
    // auto start = std::chrono::high_resolution_clock::now();
    if(A.matrix_shape[1] != x.num_rows()) {
        throw std::invalid_argument("Not multiplyable");
    }
    vector y(A.matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y.getRealValues();
    valType *y_imag_values = y.getImagValues();

    valType *x_real_values = x.getRealValues();
    valType *x_imag_values = x.getImagValues();
    std::unordered_map<long int, diagonal> diagMap = A.getDiagonalMap();
    std::unordered_map<long int, diagonal>::iterator it;

    #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        long int dIndex = it->first;
        long int dLength = it->second.dLength;
        valType *real_vals = it->second.getRealValues();
        valType *imag_vals = it->second.getImagValues();
        #pragma omp simd
        for (long int i = 0; i < dLength; i++) {
            // std::cout << "dIndex=" << dIndex << "; dLength=" << dLength << "; i=" << i << std::endl;
            long int x_idx = (dIndex < 0)? i : dIndex + i;
            long int y_idx = (dIndex < 0)? i - dIndex : i;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
            // std::cout << "y[" << y_idx << "] = " << c << " * x[" << x_idx << "]" << std::endl;
            // std::cout << " -- " << std::endl;
        }
    }
    // if(logger.log_level == DEBUG) {
    //     std::cout << " --- " << std::endl;
    //     std::cout << " --- spMV result --- " << std::endl;
    //     std::cout << " --- " << std::endl;
    //     y.print();
    //     std::cout << " --- " << std::endl;
    // }
    // // measure end time
    // auto end = std::chrono::high_resolution_clock::now();
    // // calculate duration
    // std::chrono::duration<double> duration = end - start;
    // // log duration
    // printf("SpMV took %f seconds\n", duration.count());
    return y;
    #endif
}

vector MV(denseMatrix A, vector x) {
    if(A.matrix_shape[1] != x.num_rows()) {
        throw std::invalid_argument("Not multiplyable");
    }
    valType *x_real_values = x.getRealValues();
    valType *x_imag_values = x.getImagValues();
    vector y(A.matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y.getRealValues();
    valType *y_imag_values = y.getImagValues();
    for(long int i = 0; i < A.matrix_shape[0]; i++) {
        valType res_real = 0.0;
        valType res_imag = 0.0;
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int j = 0; j < A.matrix_shape[1]; j++) {
            std::complex<valType> elem = A.get(i, j);
            res_real += elem.real() * x_real_values[j] - elem.imag() * x_imag_values[j];
            res_imag += elem.real() * x_imag_values[j] + elem.imag() * x_real_values[j];
        }
        y_real_values[i] = res_real;
        y_imag_values[i] = res_imag;
    }
    return y;
}

denseMatrix dense_kron_product(denseMatrix A, denseMatrix B) {
    // A: m x n
    // B: p x q
    // C: mp x nq

    std::vector<long int> shape_a = A.matrix_shape;
    std::vector<long int> shape_b = B.matrix_shape;

    // Calculate dimensions for the resulting matrix
    std::vector<long int> d{shape_a[0] * shape_b[0], shape_a[1] * shape_b[1]};
    valType *real_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
    valType *imag_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
    denseMatrix result(&d, real_res, imag_res);

    // Iterate through the rows of matrix A
    for (long int i = 0; i < A.matrix_shape[0]; i++) {

        // Iterate through the columns of matrix A
        for (long int j = 0; j < A.matrix_shape[1]; j++) {

            // Iterate through the rows of matrix B
            for (long int k = 0; k < B.matrix_shape[0]; k++) {

                // Iterate through the columns of matrix B
                for (long int l = 0; l < B.matrix_shape[1]; l++) {

                    // Calculate the resulting indices in the new matrix
                    long int newIndexI = i * B.matrix_shape[0] + k;
                    long int newIndexJ = j * B.matrix_shape[1] + l;

                    // Multiply the element of A by the element of B
                    std::complex<valType> newElement = A.get(i, j) * B.get(k, l);

                    // Add the resulting element to the appropriate position in the result denseMatrix
                    result.set(newIndexI, newIndexJ, newElement);
                }
            }
        }
    }
    return result;
}

diagonal multiplyEntireDiagonals(std::vector<long int> shapeA, std::vector<long int> shapeB, diagonal diagA, diagonal diagB) {
    // std::cout << "multiplyEntireDiagonals called" << std::endl;
    // diagA.print();
    // diagB.print();
    long int dIndexA = diagA.dIndex;
    long int dIndexB = diagB.dIndex;
    long int dLengthA = diagA.dLength;
    long int dLengthB = diagB.dLength;
    long int dLength = dLengthA * dLengthB;
    valType *real_valsA = diagA.getRealValues();
    valType *imag_valsA = diagA.getImagValues();
    valType *real_valsB = diagB.getRealValues();
    valType *imag_valsB = diagB.getImagValues();
    valType *real_valsC = (valType *)calloc(dLength, sizeof(valType));
    valType *imag_valsC = (valType *)calloc(dLength, sizeof(valType));
    for(long int i = 0; i < dLengthA; i++) {
        valType each_real = real_valsA[i];
        valType each_imag = imag_valsA[i];
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int j = 0; j < dLengthB; j++) {
            long int c_pos = i * dLengthB + j;
            real_valsC[c_pos] = each_real * real_valsB[j] - each_imag * imag_valsB[j];
            imag_valsC[c_pos] = each_real * imag_valsB[j] + each_imag * real_valsB[j];
        }
    }
    long int dIndexC = dIndexA + dIndexB;
    return diagonal(dIndexC, dLength, real_valsC, imag_valsC);
}

diaQMatrix multiply_by_scalar(valType scalar_real, valType scalar_imag, diaQMatrix A) {
    // if(logger.log_level == DEEP_DEBUG) {
    //     std::cout << " --- " << std::endl;
    //     std::cout << " --- multiply_by_scalar --- " << std::endl;
    //     std::cout << " --- " << std::endl;
    //     std::cout << "scalar_real = " << scalar_real << "; scalar_imag = " << scalar_imag << std::endl;
    //     std::cout << " --- times --- " << std::endl;
    //     A.print();
    //     std::cout << " --- " << std::endl;
    // }
    // if(scalar_real == 0.0 && scalar_imag == 0.0) {
    //     logger.log("diaq/multiply_by_scalar called with scalar = 0.0");
    //     // can handle this better. TODO
    //     return diaQMatrix((long int)0);
    // }
    diaQMatrix result((long int)0);
    result.matrix_shape = A.matrix_shape;
    result.shape = A.shape;
    std::unordered_map<long int, diagonal> diagMap = A.getDiagonalMap();
    std::unordered_map<long int, diagonal>::iterator it;
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        long int dIndex = it->first;
        long int dLength = it->second.dLength;
        valType *real_vals = it->second.getRealValues();
        valType *imag_vals = it->second.getImagValues();
        diagonal newDiag(dIndex, dLength);
        valType *real_valsC = newDiag.getRealValues();
        valType *imag_valsC = newDiag.getImagValues();

        #if VECTORIZATION_TYPE == 1
            long int dLength_mul_4 = dLength - (dLength % 4);
            for (long int i = 0; i < dLength_mul_4; i += 4) {
                __m256d real_vals_vec = _mm256_loadu_pd(real_vals + i);
                __m256d imag_vals_vec = _mm256_loadu_pd(imag_vals + i);
                __m256d scalar_real_vec = _mm256_set1_pd(scalar_real);
                __m256d scalar_imag_vec = _mm256_set1_pd(scalar_imag);

                __m256d real_valsC_vec = _mm256_mul_pd(real_vals_vec, scalar_real_vec);
                __m256d imag_valsC_vec = _mm256_mul_pd(imag_vals_vec, scalar_imag_vec);

                real_valsC_vec = _mm256_sub_pd(real_valsC_vec, _mm256_mul_pd(imag_vals_vec, scalar_imag_vec));
                imag_valsC_vec = _mm256_add_pd(_mm256_mul_pd(real_vals_vec, scalar_imag_vec), imag_valsC_vec);

                _mm256_storeu_pd(real_valsC + i, real_valsC_vec);
                _mm256_storeu_pd(imag_valsC + i, imag_valsC_vec);
            }
            // Handle dLength_left
            for (long int i = dLength_mul_4; i < dLength; i++) {
                real_valsC[i] = real_vals[i] * scalar_real - imag_vals[i] * scalar_imag;
                imag_valsC[i] = real_vals[i] * scalar_imag + imag_vals[i] * scalar_real;
            }
        #else
            #pragma omp simd
            for (long int i = 0; i < dLength; i++) {
                real_valsC[i] = real_vals[i] * scalar_real - imag_vals[i] * scalar_imag;
                imag_valsC[i] = real_vals[i] * scalar_imag + imag_vals[i] * scalar_real;
            }
        #endif

        // printf("printing newDiag\n");
        // newDiag.print();
        result.setDiagonal(dIndex, newDiag);
    }
    // if(logger.log_level == DEEP_DEBUG) {
    //     std::cout << " --- " << std::endl;
    //     std::cout << " --- multiply_by_scalar result --- " << std::endl;
    //     std::cout << " --- " << std::endl;
    //     result.print();
    //     std::cout << " --- " << std::endl;
    // }
    return result;
}

diaQMatrix kron_product(diaQMatrix A, diaQMatrix B) {
    // A: m x n
    // B: p x q
    // C: mp x nq

    // measure start time
    // auto start = std::chrono::high_resolution_clock::now();

    // if(logger.log_level == DEEP_DEBUG) {
    //     std::cout << " --- " << std::endl;
    //     std::cout << " --- kron product --- " << std::endl;
    //     std::cout << " --- " << std::endl;
    //     A.print();
    //     std::cout << " --- times --- " << std::endl;
    //     B.print();
    //     std::cout << " --- " << std::endl;
    // }

    std::vector<long int> shape_a = A.matrix_shape;
    std::vector<long int> shape_b = B.matrix_shape;

    // map of combination of A diagonal index, A diagonal position to multiply_by_scalar matrix. The individual blocks of matrices: A11 * B, A12 * B, A21 * B, A22 * B, ...
    std::map<std::pair<long int, long int>, diaQMatrix> kron_map;

    // Calculate dimensions for the resulting matrix
    std::vector<long int> result_shape{shape_a[0] * shape_b[0], shape_a[1] * shape_b[1]};
    diaQMatrix *result = new diaQMatrix(&result_shape);

    std::unordered_map<long int, diagonal> A_diagonalMap = A.getDiagonalMap();
    std::unordered_map<long int, diagonal>::iterator itA;

    // for each element in A, do multiply_by_scalar with B and add to kron_list.
    // paralleize this later. TODO
    for (itA = A_diagonalMap.begin(); itA != A_diagonalMap.end(); itA++) {
        long int diagonal_index = itA->first;
        diagonal *diag = &(itA->second);
        long int diagonal_length = diag->dLength;

        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int diagonal_position = 0; diagonal_position < diagonal_length; diagonal_position++) {
            diaQMatrix kron_block = multiply_by_scalar(diag->getRealValue(diagonal_position), diag->getImagValue(diagonal_position), B);
            std::vector<long int> A_pos = A.getMatrixPosition(diagonal_index, diagonal_position);
            std::pair<long int, long int> key = std::make_pair(A_pos[0], A_pos[1]);
            kron_map.insert(std::pair<std::pair<long int, long int>, diaQMatrix>(key, kron_block));
        }

    }
    // if(logger.log_level == DEEP_DEBUG) {
    //     std::cout << " --- " << std::endl;
    //     std::cout << "kron_map.size() = " << kron_map.size() << std::endl;
    //     std::cout << " --- " << std::endl;
    // }

    // pre-allocate resutl's diagonals and paralleize this below later,! TODO

    // traverse kron_map and add to result.
    std::map<std::pair<long int, long int>, diaQMatrix>::iterator it;
    #pragma omp parallel for num_threads(4)
    for (it = kron_map.begin(); it != kron_map.end(); it++) {
        // for each element in A
        std::vector<long int> A_mat_pos{it->first.first, it->first.second};
        diaQMatrix kron_block = it->second;

        // we now have to add to result's res_diag_index at res_diag_pos
        std::unordered_map<long int, diagonal> kron_block_diagMap = kron_block.getDiagonalMap();
        std::unordered_map<long int, diagonal>::iterator itK;

        #pragma omp parallel for num_threads(4)
        for (itK = kron_block_diagMap.begin(); itK != kron_block_diagMap.end(); itK++) {

            long int kron_block_diag_index = itK->first;
            diagonal kron_block_diag = itK->second;
            long int kron_block_diag_length = kron_block_diag.dLength;

            #pragma omp parallel for num_threads(4)
            for(long int kron_block_diag_position = 0; kron_block_diag_position < kron_block_diag_length; kron_block_diag_position++) {

                std::vector<long int> B_mat_pos = kron_block.getMatrixPosition(kron_block_diag_index, kron_block_diag_position);
                std::vector<long int> res_mat_pos{A_mat_pos[0] * shape_b[0] + B_mat_pos[0], A_mat_pos[1] * shape_b[1] + B_mat_pos[1]};
                std::vector<long int> res_diag_pos = result->getDiagonalPosition(res_mat_pos);

                // if(logger.log_level == DEEP_DEBUG) {
                //     std::cout << "A_mat_pos = (" << A_mat_pos[0] << ", " << A_mat_pos[1] << ")" << std::endl;
                //     std::cout << "B_mat_pos = (" << B_mat_pos[0] << ", " << B_mat_pos[1] << ")" << std::endl;
                //     std::cout << "res_mat_pos = (" << res_mat_pos[0] << ", " << res_mat_pos[1] << ")" << std::endl;
                //     std::cout << "res_diag_pos = (" << res_diag_pos[0] << ", " << res_diag_pos[1] << ")" << std::endl;
                // }

                result->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], result->getDiagonalLength(res_diag_pos[0]), kron_block_diag.getRealValue(kron_block_diag_position), kron_block_diag.getImagValue(kron_block_diag_position));
            }
        }
    }

    // result->pruneMatrix(); // Prune the resulting matrix if necessary; we don't actually need this :thinking

    // // for now let's just convert to dense, do the kron product and convert back to diaq
    // denseMatrix denseA = A.convertToDenseMatrix(A.shape);
    // denseMatrix denseB = B.convertToDenseMatrix(B.shape);
    // denseMatrix denseC = dense_kron_product(denseA, denseB);
    // diaQMatrix result = denseC.convertToQuantumSparse(denseC.shape);

    // if(logger.log_level == DEEP_DEBUG) {
    //     std::cout << " --- " << std::endl;
    //     std::cout << " --- kron result --- " << std::endl;
    //     std::cout << " --- " << std::endl;
    //     result->print();
    //     std::cout << " --- " << std::endl;
    // }

    // // measure end time
    // auto end = std::chrono::high_resolution_clock::now();
    // // calculate duration
    // std::chrono::duration<double> duration = end - start;
    // // log duration
    // printf("Kron product took %f seconds\n", duration.count());

    // return result;
    return *result;
}

} // namespace diaq