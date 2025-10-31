#ifndef DIAQ_SIMD_AVX2_KERNELS_HPP
#define DIAQ_SIMD_AVX2_KERNELS_HPP

#include "config.hpp"
#include <immintrin.h>

namespace diaq {

// Template for general implementation
template<typename valTypeTemplate>
void run_avx(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final, bool overwrite);

// AVX double
__m256d avx_load_partial_double(int n, const double *p);
void avx_store_partial_double(int n, double *loc, __m256d vec);
template<>
void run_avx<double>(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final, bool overwrite);

// AVX float
__m256 avx_load_partial_float(int n, const float *p);
void avx_store_partial_float(int n, float *loc, __m256 vec);
template<>
void run_avx<float>(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final, bool overwrite);

// SPMV for AVX, 1 for positive diagonals, 2 for negative diagonals, 0 for main diagonal
template<typename valTypeTemplate>
void run_spmv_avx_1(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
template<typename valTypeTemplate>
void run_spmv_avx_2(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
template<typename valTypeTemplate>
void run_spmv_avx_0(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);

// AVX double
template<>
void run_spmv_avx_1<double>(unsigned int start, unsigned int end, double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
template<>
void run_spmv_avx_2<double>(unsigned int start, unsigned int end, double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
template<>
void run_spmv_avx_0<double>(unsigned int start, unsigned int end, double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);

// AVX float
template<>
void run_spmv_avx_1<float>(unsigned int start, unsigned int end, float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
template<>
void run_spmv_avx_2<float>(unsigned int start, unsigned int end, float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
template<>
void run_spmv_avx_0<float>(unsigned int start, unsigned int end, float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);

} // namespace diaq

#endif // DIAQ_SIMD_AVX2_KERNELS_HPP