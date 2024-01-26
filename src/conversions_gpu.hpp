#ifndef DIAQ_CONVERSIONS_GPU_HPP
#define DIAQ_CONVERSIONS_GPU_HPP

#include <iostream>
#include <vector>
#include <map>
#include <complex>
#include <cmath>
#include <omp.h>
#include <unordered_map>

// CUDA libraries
#include "cuda_runtime_api.h"
#include "cuda_runtime.h"
#include "cuda_profiler_api.h"
#include "device_launch_parameters.h"

// DIAQ imports
#include "config.hpp"
#include "diaQMatrix.hpp"
#include "denseMatrix.hpp"

namespace diaq {

// declarations
diaQMatrix from_numpy_cuda(std::vector<std::complex<valType>> values, std::vector<long int> shape);
diaQMatrix convertToQuantumSparse_cuda(denseMatrix *d, std::vector<long int> new_shape);

} // namespace diaq

#endif // DIAQ_CONVERSIONS_GPU_HPP