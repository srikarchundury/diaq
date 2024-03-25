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
diaQMatrix *product_cuda(diaQMatrix *A, diaQMatrix *B);
vector *spmv_cuda(diaQMatrix *A, vector *x);

} // namespace diaq

#endif // DIAQ_MATRIXKERNELS_GPU_HPP