// Diagonal-format matrix times dense matrix on data that already lives on the GPU (no host copies).
//
// Layout (row-aligned DIA, as in cuSPARSE's legacy DIA and the ELL family):
//   offsets[k]               column offset of diagonal k: A[r, r + offsets[k]]
//   vals[k * n_rows + r]     A[r, r + offsets[k]] (0 where r + offsets[k] is outside [0, n_cols))
//   B                        n_cols x n_right, row-major
//   C                        n_rows x n_right, row-major, overwritten: C = A * B
// Values are double or complex double (interleaved real, imaginary: the layout of numpy's complex128 and of
// torch.complex128), so tensors from torch or cupy are passed by their data pointers.
//
// One thread per entry of C, consecutive threads along a row of C (and of B): reads of B and writes of C are
// coalesced; the diagonal values of a row are read once per column of B. The offsets are staged in shared memory
// when there are at most SPMM_DIA_SHARED_OFFSETS of them.
#include <cuda_runtime.h>
#include <cuComplex.h>
#include <cstdint>
#include <stdexcept>
#include <string>

#include "spMM_device_gpu.hpp"

namespace diaq {

namespace {

constexpr int SPMM_DIA_SHARED_OFFSETS = 1024;

__device__ __forceinline__ double fma_val(double acc, double a, double b) { return fma(a, b, acc); }

__device__ __forceinline__ cuDoubleComplex fma_val(cuDoubleComplex acc, cuDoubleComplex a, cuDoubleComplex b) {
    return make_cuDoubleComplex(acc.x + a.x * b.x - a.y * b.y, acc.y + a.x * b.y + a.y * b.x);
}

template <typename T> __device__ __forceinline__ T zero_val();
template <> __device__ __forceinline__ double zero_val<double>() { return 0.0; }
template <> __device__ __forceinline__ cuDoubleComplex zero_val<cuDoubleComplex>() {
    return make_cuDoubleComplex(0.0, 0.0);
}

template <typename T, bool SHARED>
__global__ void spmm_dia_kernel(int64_t n_rows, int64_t n_cols, int64_t n_right, int n_diags,
                                const int64_t *__restrict__ offsets, const T *__restrict__ vals,
                                const T *__restrict__ B, T *__restrict__ C) {
    extern __shared__ int64_t s_off[];
    const int64_t *off = offsets;
    if (SHARED) {
        for (int k = threadIdx.x; k < n_diags; k += blockDim.x) s_off[k] = offsets[k];
        __syncthreads();
        off = s_off;
    }
    const int64_t total = n_rows * n_right;
    for (int64_t e = blockIdx.x * (int64_t)blockDim.x + threadIdx.x; e < total;
         e += (int64_t)gridDim.x * blockDim.x) {
        const int64_t r = e / n_right;
        const int64_t j = e - r * n_right;
        T acc = zero_val<T>();
        for (int k = 0; k < n_diags; ++k) {
            const int64_t c = r + off[k];
            if (c >= 0 && c < n_cols) acc = fma_val(acc, vals[(int64_t)k * n_rows + r], B[c * n_right + j]);
        }
        C[e] = acc;
    }
}

template <typename T>
void launch(int64_t n_rows, int64_t n_cols, int64_t n_right, int n_diags, const int64_t *offsets, const T *vals,
            const T *B, T *C, cudaStream_t stream) {
    const int threads = 256;
    const int64_t total = n_rows * n_right;
    if (total == 0) return;
    int device = 0, sms = 0;
    cudaGetDevice(&device);
    cudaDeviceGetAttribute(&sms, cudaDevAttrMultiProcessorCount, device);
    int64_t blocks = (total + threads - 1) / threads;
    const int64_t cap = (int64_t)sms * 32;
    if (blocks > cap) blocks = cap;
    if (n_diags <= SPMM_DIA_SHARED_OFFSETS) {
        spmm_dia_kernel<T, true><<<(unsigned int)blocks, threads, n_diags * sizeof(int64_t), stream>>>(
            n_rows, n_cols, n_right, n_diags, offsets, vals, B, C);
    } else {
        spmm_dia_kernel<T, false><<<(unsigned int)blocks, threads, 0, stream>>>(
            n_rows, n_cols, n_right, n_diags, offsets, vals, B, C);
    }
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) throw std::runtime_error(std::string("spmm_dia_device: ") + cudaGetErrorString(err));
}

}  // namespace

void spmm_dia_device(std::uintptr_t offsets, std::uintptr_t vals, int n_diags, int64_t n_rows, int64_t n_cols,
                     std::uintptr_t B, int64_t n_right, std::uintptr_t C, bool is_complex, std::uintptr_t stream) {
    auto s = reinterpret_cast<cudaStream_t>(stream);
    const auto *off = reinterpret_cast<const int64_t *>(offsets);
    if (is_complex) {
        launch<cuDoubleComplex>(n_rows, n_cols, n_right, n_diags, off, reinterpret_cast<const cuDoubleComplex *>(vals),
                                reinterpret_cast<const cuDoubleComplex *>(B), reinterpret_cast<cuDoubleComplex *>(C), s);
    } else {
        launch<double>(n_rows, n_cols, n_right, n_diags, off, reinterpret_cast<const double *>(vals),
                       reinterpret_cast<const double *>(B), reinterpret_cast<double *>(C), s);
    }
}

}  // namespace diaq
