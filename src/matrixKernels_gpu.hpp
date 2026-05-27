#ifndef DIAQ_MATRIXKERNELS_GPU_HPP
#define DIAQ_MATRIXKERNELS_GPU_HPP

// others
#include <unordered_map>
#include <vector>
#include <utility>
#include <stdexcept>
#include <cstdio>

// CUDA libraries
#include "cuda_runtime_api.h"
#include "cuda_runtime.h"
#include "cuda_profiler_api.h"
#include "device_launch_parameters.h"

// DiaQ imports
#include "diaQMatrix.hpp"
#include "vector.hpp"
#include "config.hpp"

namespace diaq {

// declarations
std::shared_ptr<diaQMatrix> product_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B);

void spmv_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y);
std::shared_ptr<vector> spmv_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x);

// we saw that hamiltonian simulation calls spmv multiple times in succession, so we can have a function that does spmv n times in one go on the GPU, avoiding memory transfers!
void spMV_ntimes_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y, int n);
std::shared_ptr<vector> spMV_ntimes_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, int n);

// pow -- exponentiation by squaring on GPU
std::shared_ptr<diaQMatrix> pow_cuda(std::shared_ptr<diaQMatrix> A, int n);

// sparse matrix exponential on GPU - just expm(A)
std::shared_ptr<diaQMatrix> expm_taylor_cuda(std::shared_ptr<diaQMatrix> A, int max_iterations, valType scale_cutoff = 1.0, valType tolerance = 1e-12);
std::shared_ptr<diaQMatrix> expm_taylor_scaled_cuda(std::shared_ptr<diaQMatrix> A, int max_iterations, valType scale_cutoff = 1.0, valType tolerance = 1e-12);

// sparse matrix exponential on GPU - negative time
std::shared_ptr<diaQMatrix> expm_negative_taylor_cuda(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations, valType scale_cutoff = 1.0, valType tolerance = 1e-12);
std::shared_ptr<diaQMatrix> expm_negative_taylor_scaled_cuda(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations, valType scale_cutoff = 1.0, valType tolerance = 1e-12);

// sparse hamiltonian simulation on GPU
std::shared_ptr<vector> hamiltonian_simulation_cuda(std::shared_ptr<diaQMatrix> H, std::shared_ptr<vector> psi0, valType t, long unsigned r/*num_timesteps*/, int max_iterations, valType scale_cutoff = 1.0, valType tolerance = 1e-12);

} // namespace diaq

#endif // DIAQ_MATRIXKERNELS_GPU_HPP