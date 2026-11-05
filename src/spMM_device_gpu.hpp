#ifndef DIAQ_SPMM_DEVICE_GPU_HPP
#define DIAQ_SPMM_DEVICE_GPU_HPP

#include <cstdint>

namespace diaq {

// C = A * B with A in row-aligned DIA format, all arrays already on the GPU (see spMM_device_gpu.cu):
// offsets: int64[n_diags]; vals: [n_diags * n_rows]; B: [n_cols * n_right]; C: [n_rows * n_right] (row-major),
// double or interleaved complex double. Pointers and the CUDA stream are passed as integers (e.g. from
// torch.Tensor.data_ptr() and torch.cuda.current_stream().cuda_stream).
void spmm_dia_device(std::uintptr_t offsets, std::uintptr_t vals, int n_diags, int64_t n_rows, int64_t n_cols,
                     std::uintptr_t B, int64_t n_right, std::uintptr_t C, bool is_complex, std::uintptr_t stream);

}  // namespace diaq

#endif
