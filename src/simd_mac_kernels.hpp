#ifndef SIMD_MAC_KERNELS_HPP
#define SIMD_MAC_KERNELS_HPP

#include "config.hpp"
#include <arm_neon.h>

template<typename valTypeTemplate>
void run_mac(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final, bool overwrite);


float64x2_t mac_load_partial_double(int n, const double *p);
void mac_store_partial_double(int n, double *loc, float64x2_t vec);
template<>
void run_mac<double>(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset, double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final, bool overwrite);


float32x4_t mac_load_partial_float(int n, const float *p);
void mac_store_partial_float(int n, float *loc, float32x4_t vec);
template<>
void run_mac<float>(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset, float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final, bool overwrite);


template<typename valTypeTemplate>
void run_spmv_mac_1(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
template<typename valTypeTemplate>
void run_spmv_mac_2(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);
template<typename valTypeTemplate>
void run_spmv_mac_0(unsigned int start, unsigned int end, valTypeTemplate *x_real_values, valTypeTemplate *x_imag_values, valTypeTemplate *real_vals, valTypeTemplate *imag_vals, valTypeTemplate *y_real_values, valTypeTemplate *y_imag_values, int dIndex, unsigned int dLength);


template<>
void run_spmv_mac_1<double>(unsigned int start, unsigned int end, double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
template<>
void run_spmv_mac_2<double>(unsigned int start, unsigned int end, double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);
template<>
void run_spmv_mac_0<double>(unsigned int start, unsigned int end, double *x_real_values, double *x_imag_values, double *real_vals, double *imag_vals, double *y_real_values, double *y_imag_values, int dIndex, unsigned int dLength);

template<>
void run_spmv_mac_1<float>(unsigned int start, unsigned int end, float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
template<>
void run_spmv_mac_2<float>(unsigned int start, unsigned int end, float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);
template<>
void run_spmv_mac_0<float>(unsigned int start, unsigned int end, float *x_real_values, float *x_imag_values, float *real_vals, float *imag_vals, float *y_real_values, float *y_imag_values, int dIndex, unsigned int dLength);

#endif // SIMD_MAC_KERNELS_HPP