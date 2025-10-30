#ifndef SIMD_NOSIMD_KERNELS_HPP
#define SIMD_NOSIMD_KERNELS_HPP

#include "config.hpp"

namespace diaq {

	template<typename valTypeTemplate>
	void run_without_vectorization(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset, valTypeTemplate *real_vals_a, valTypeTemplate *imag_vals_a, valTypeTemplate *real_vals_b, valTypeTemplate *imag_vals_b, valTypeTemplate *real_vals_final, valTypeTemplate *imag_vals_final, bool overwrite);

} // namespace diaq

#endif // SIMD_NOSIMD_KERNELS_HPP