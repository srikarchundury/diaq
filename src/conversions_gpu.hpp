#ifndef DIAQ_CONVERSIONS_GPU_HPP
#define DIAQ_CONVERSIONS_GPU_HPP

// CUDA libraries
#include "cuda_runtime_api.h"
#include "cuda_runtime.h"
#include "cuda_profiler_api.h"
#include "device_launch_parameters.h"

#include <memory>
#include <vector>
#include <array>
#include <complex>
#include <cmath>
#include <tuple>
#include <iterator>
#include <cstdio>
#include <iostream>
#include <chrono>

// DiaQ imports
#include "config.hpp"
#include "diaQMatrix.hpp"
#include "denseMatrix.hpp"

namespace diaq {

// GPU-accelerated from_numpy: dense complex array -> diaQMatrix
std::shared_ptr<diaQMatrix> from_numpy_cuda(std::complex<valType>* values,
                                            std::vector<unsigned int> shape);

// GPU-accelerated denseMatrix::convertToDiaQ(new_shape)
std::shared_ptr<diaQMatrix> convertToDiaQ_cuda(std::shared_ptr<denseMatrix> d,
                                               std::array<unsigned int, 2> new_shape);

} // namespace diaq

#endif // DIAQ_CONVERSIONS_GPU_HPP