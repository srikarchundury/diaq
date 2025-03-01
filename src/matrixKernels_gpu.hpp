#ifndef DIAQ_MATRIXKERNELS_GPU_HPP
#define DIAQ_MATRIXKERNELS_GPU_HPP

// CUDA libraries
#include "cuda_runtime_api.h"
#include "cuda_runtime.h"
#include "cuda_profiler_api.h"
#include "device_launch_parameters.h"

#include "diaQMatrix.hpp"
#include "vector.hpp"
#include "config.hpp"

namespace diaq {

// declarations
std::shared_ptr<diaQMatrix> product_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B);
std::shared_ptr<vector> spmv_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x);

} // namespace diaq

#endif // DIAQ_MATRIXKERNELS_GPU_HPP