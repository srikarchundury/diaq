#ifndef DIAQ_CONVERSIONS_GPU_HPP
#define DIAQ_CONVERSIONS_GPU_HPP

#include <iostream>
#include <vector>
#include <map>
#include <complex>
#include <cmath>
#include <omp.h>
#include "diaQMatrix.hpp"

// CUDA libraries
#include "cuda_runtime_api.h"
#include "cuda_runtime.h"
#include "cuda_profiler_api.h"
#include "device_launch_parameters.h"

// declarations
diaQMatrix from_numpy_cuda(std::vector<std::complex<float>> values, std::vector<long int> shape);

#endif // DIAQ_CONVERSIONS_GPU_HPP