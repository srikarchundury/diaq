#ifndef DIAQ_MATRIXKERNELS_GPU_HPP
#define DIAQ_MATRIXKERNELS_GPU_HPP

#include "diaQMatrix.hpp"
#include "vector.hpp"
#include "config.hpp"

// CUDA libraries
#include "cuda_runtime_api.h"
#include "cuda_runtime.h"
#include "cuda_profiler_api.h"
#include "device_launch_parameters.h"

// declarations
diaQMatrix product_cuda(diaQMatrix *A, diaQMatrix *B);
vector spmv_cuda(diaQMatrix *A, vector *x);

#endif // DIAQ_MATRIXKERNELS_GPU_HPP