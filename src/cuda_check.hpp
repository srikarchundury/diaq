#ifndef DIAQ_CUDA_CHECK_HPP
#define DIAQ_CUDA_CHECK_HPP

// Throw on a failed CUDA runtime call (allocation, copy, launch), with the call site, instead of continuing with
// unallocated or stale device memory.
#include <cuda_runtime.h>

#include <stdexcept>
#include <string>

#define DIAQ_CUDA_CHECK(call)                                                                                   \
    do {                                                                                                        \
        cudaError_t diaq_cuda_err_ = (call);                                                                    \
        if (diaq_cuda_err_ != cudaSuccess) {                                                                    \
            throw std::runtime_error(std::string("CUDA error: ") + cudaGetErrorString(diaq_cuda_err_) + " (" + \
                                     __FILE__ + ":" + std::to_string(__LINE__) + ")");                          \
        }                                                                                                       \
    } while (0)

#endif
