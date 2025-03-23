#ifndef DIAQ_SIMD_KERNELS_HPP
#define DIAQ_SIMD_KERNELS_HPP

#include "config.hpp"

#ifdef __AVX2__
	#include <immintrin.h>
#endif

#ifdef __AVX512F__
	#include <immintrin.h>
#endif

#ifdef __SSE__
	#include <xmmintrin.h>
	#include <emmintrin.h>
#endif

namespace diaq {

	void run_without_vectorization(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, valType *real_vals_a, valType *imag_vals_a, valType *real_vals_b, valType *imag_vals_b, valType *real_vals_final, valType *imag_vals_final);

#ifdef __AVX2__
	
	// template
    template<typename valTypeTemplate>
    void run_avx(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final);
	
	// AVX double
	__m256d avx_load_partial_double(int n, const double *p);
	void avx_store_partial_double(int n, double *loc, __m256d vec);
	template<>
	void run_avx<double>(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final);

	// AVX float
	__m256 avx_load_partial_float(int n, const float *p);
	void avx_store_partial_float(int n, float *loc, __m256 vec);
	template<>
	void run_avx<float>(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final);

	// SPMV for AVX, 1 for positive diagonals, 2 for negative diagonals, 0 for main diagonal
	template<typename valTypeTemplate>
	void run_spmv_avx_1(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
	template<typename valTypeTemplate>
	void run_spmv_avx_2(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
	template<typename valTypeTemplate>
	void run_spmv_avx_0(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

	// AVX double
	template<>
	void run_spmv_avx_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_avx_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_avx_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);

	// AVX float
	template<>
	void run_spmv_avx_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_avx_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_avx_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);

#endif

#ifdef __SSE__
	template<typename valTypeTemplate>
	void run_sse(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final);

	// SSE float
	__m128 sse_load_partial_float(int n, float *p);
	void sse_store_partial_float(int n, float *loc, __m128 vec);
	template<>
	void run_sse<float>(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final);

	// SSE double
	__m128d sse_load_partial_double(int n, double *p);
	void sse_store_partial_double(int n, double *loc, __m128d vec);
	template<>
	void run_sse<double>(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final);

	// SPMV for SSE, 1 for positive diagonals, 2 for negative diagonals, 0 for main diagonal
	template<typename valTypeTemplate>
	void run_spmv_sse_1(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
	template<typename valTypeTemplate>
	void run_spmv_sse_2(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
	template<typename valTypeTemplate>
	void run_spmv_sse_0(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

	// SSE double
	template<>
	void run_spmv_sse_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_sse_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_sse_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);

	// SSE float
	template<>
	void run_spmv_sse_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_sse_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_sse_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);

	// SSE double
	template<>
	void run_spmv_sse_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_sse_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
	template<>
	void run_spmv_sse_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);

#endif

#ifdef __AVX512F__

    // Template for general implementation
    template<typename valTypeTemplate>
    void run_avx512(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final);

    // AVX-512 double
    __m512d avx512_load_partial_double(int n, const double *p);
    void avx512_store_partial_double(int n, double *loc, __m512d vec);
    template<>
    void run_avx512<double>(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final);

    // AVX-512 float
    __m512 avx512_load_partial_float(int n, const float *p);
    void avx512_store_partial_float(int n, float *loc, __m512 vec);
    template<>
    void run_avx512<float>(unsigned int k, unsigned int lenRes, unsigned int offsetA, unsigned int offsetB, unsigned int jump, unsigned int lenDiagA, unsigned int lenDiagB, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final);

    // SPMV for AVX-512, 1 for positive diagonals, 2 for negative diagonals, 0 for main diagonal
    template<typename valTypeTemplate>
    void run_spmv_avx512_1(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
    template<typename valTypeTemplate>
    void run_spmv_avx512_2(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
    template<typename valTypeTemplate>
    void run_spmv_avx512_0(valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

    // AVX-512 double
    template<>
    void run_spmv_avx512_1<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
    template<>
    void run_spmv_avx512_2<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
    template<>
    void run_spmv_avx512_0<double>(double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);

    // AVX-512 float
    template<>
    void run_spmv_avx512_1<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
    template<>
    void run_spmv_avx512_2<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
    template<>
    void run_spmv_avx512_0<float>(float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);

#endif


} // namespace diaq

#endif // DIAQ_SIMD_KERNELS_HPP