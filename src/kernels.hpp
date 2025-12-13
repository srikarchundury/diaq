#ifndef DIAQ_KERNELS_HPP
#define DIAQ_KERNELS_HPP

#include "matrixKernels.hpp"
#include "conversions.hpp"
#include "vectorKernels.hpp" // not using this currently, all in matrixKernels since all ops involve matrices! maybe this can have pure vector ops later!

#ifdef CUDA_ENABLED
	#include "matrixKernels_gpu.hpp"
	#include "conversions_gpu.hpp"
#endif

namespace diaq {

} // namespace diaq

#endif // DIAQ_KERNELS_HPP