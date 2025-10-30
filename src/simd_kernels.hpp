#ifndef DIAQ_SIMD_KERNELS_HPP
#define DIAQ_SIMD_KERNELS_HPP

#include "config.hpp"

namespace diaq {
	#if VEC_TYPE == 1 // AVX2
		#include "simd_avx2_kernels.hpp"
	#endif

	#if VEC_TYPE == 2 // AVX-512
		#include "simd_avx512_kernels.hpp"
	#endif

	#if VEC_TYPE == 0 // SSE
		#include "simd_sse_kernels.hpp"
	#endif

	#if VEC_TYPE == 3 // MAC/NEON
		#include "simd_mac_kernels.hpp"
	#endif

	#if VEC_TYPE == -1 // No SIMD
		#include "simd_nosimd_kernels.hpp"
	#endif

} // namespace diaq

#endif // DIAQ_SIMD_KERNELS_HPP
