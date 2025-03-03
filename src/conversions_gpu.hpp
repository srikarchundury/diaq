#ifndef DIAQ_CONVERSIONS_GPU_HPP
#define DIAQ_CONVERSIONS_GPU_HPP

// CUDA libraries
#include "cuda_runtime_api.h"
#include "cuda_runtime.h"
#include "cuda_profiler_api.h"
#include "device_launch_parameters.h"

// DiaQ imports
#include "config.hpp"
#include "diaQMatrix.hpp"
#include "denseMatrix.hpp"

namespace diaq {

// declarations
std::shared_ptr<diaQMatrix> from_numpy_cuda(std::complex<valType> *values, std::vector<unsigned int> shape);
std::shared_ptr<diaQMatrix> convertToQuantumSparse_cuda(std::shared_ptr<denseMatrix> d, unsigned int *new_shape);

} // namespace diaq

#endif // DIAQ_CONVERSIONS_GPU_HPP