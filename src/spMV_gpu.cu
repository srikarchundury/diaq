#include "matrixKernels_gpu.hpp"
#include "cuda_check.hpp"
#include "deviceMatrix_gpu.hpp"

#include <vector>
#include <stdexcept>

namespace diaq {

// -----------------------------------------------------------------------------
// Single-diagonal kernel: each thread processes one diagonal element.
// For diagonal dIndex:
//   d < 0: x_idx = i;         y_idx = i - d
//   d > 0: x_idx = d + i;     y_idx = i
//   d = 0: x_idx = i;         y_idx = i
// -----------------------------------------------------------------------------
__global__ void spmv_single_diag_kernel(
    unsigned int len,
    int          dIndex,
    unsigned int offset,
    unsigned int numRows,
    unsigned int numCols,
    const valType * __restrict__ A_real,
    const valType * __restrict__ A_imag,
    const valType * __restrict__ x_real,
    const valType * __restrict__ x_imag,
    valType * __restrict__ y_real,
    valType * __restrict__ y_imag
) {
    unsigned int tid    = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned int stride = blockDim.x * gridDim.x;

    for (unsigned int i = tid; i < len; i += stride) {
        int x_idx, y_idx;

        if (dIndex == 0) {
            x_idx = static_cast<int>(i);
            y_idx = static_cast<int>(i);
        } else if (dIndex > 0) {
            x_idx = dIndex + static_cast<int>(i);
            y_idx = static_cast<int>(i);
        } else { // dIndex < 0
            x_idx = static_cast<int>(i);
            y_idx = static_cast<int>(i) - dIndex;  // dIndex is negative
        }

        // Bounds safety (for rectangular matrices)
        if (x_idx < 0 || x_idx >= static_cast<int>(numCols)) continue;
        if (y_idx < 0 || y_idx >= static_cast<int>(numRows)) continue;

        unsigned int A_idx = offset + i;
        unsigned int X_idx = static_cast<unsigned int>(x_idx);
        unsigned int Y_idx = static_cast<unsigned int>(y_idx);

        valType ar = A_real[A_idx];
        valType ai = A_imag[A_idx];
        valType xr = x_real[X_idx];
        valType xi = x_imag[X_idx];

        // y[Y_idx] += A[i] * x[x_idx]
        valType prod_r = ar * xr - ai * xi;
        valType prod_i = ar * xi + ai * xr;

        // No atomics needed: each diagonal element maps to a unique y_idx
        y_real[Y_idx] += prod_r;
        y_imag[Y_idx] += prod_i;
    }
}

// -----------------------------------------------------------------------------
// Multi-diagonal row-parallel kernel
// Each thread owns a set of rows, loops over all diagonals.
// -----------------------------------------------------------------------------
__global__ void spmv_row_kernel(
    unsigned int numRows,
    unsigned int numCols,
    int          numDiags,
    const int * __restrict__ dIndices,             // [numDiags]
    const unsigned int * __restrict__ diagOffsets, // [numDiags]
    const unsigned int * __restrict__ diagLens,    // [numDiags]
    const valType * __restrict__ A_real,
    const valType * __restrict__ A_imag,
    const valType * __restrict__ x_real,
    const valType * __restrict__ x_imag,
    valType * __restrict__ y_real,
    valType * __restrict__ y_imag
) {
    unsigned int tid    = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned int stride = blockDim.x * gridDim.x;

    for (unsigned int row = tid; row < numRows; row += stride) {
        valType acc_r = 0.0;
        valType acc_i = 0.0;

        for (int k = 0; k < numDiags; ++k) {
            int d              = dIndices[k];
            unsigned int len   = diagLens[k];
            unsigned int off   = diagOffsets[k];

            int pos_int;
            int col;

            if (d == 0) {
                pos_int = static_cast<int>(row);
                col     = static_cast<int>(row);
                if (pos_int < 0 || pos_int >= static_cast<int>(len))     continue;
                if (col     < 0 || col     >= static_cast<int>(numCols)) continue;
            } else if (d > 0) {
                pos_int = static_cast<int>(row);
                col     = d + pos_int;
                if (pos_int < 0 || pos_int >= static_cast<int>(len))     continue;
                if (col     < 0 || col     >= static_cast<int>(numCols)) continue;
            } else { // d < 0
                pos_int = static_cast<int>(row) + d;  // d negative
                if (pos_int < 0 || pos_int >= static_cast<int>(len))     continue;
                col = pos_int;
                if (col < 0 || col >= static_cast<int>(numCols))         continue;
            }

            unsigned int pos  = static_cast<unsigned int>(pos_int);
            unsigned int idxA = off + pos;
            unsigned int idxX = static_cast<unsigned int>(col);

            valType ar = A_real[idxA];
            valType ai = A_imag[idxA];
            valType xr = x_real[idxX];
            valType xi = x_imag[idxX];

            acc_r += ar * xr - ai * xi;
            acc_i += ar * xi + ai * xr;
        }

        y_real[row] = acc_r;
        y_imag[row] = acc_i;
    }
}

// -----------------------------------------------------------------------------
// y = A x with A, x, y on the device: one kernel for a single diagonal (vector times
// shifted vector), else the row kernel over all diagonals.
// -----------------------------------------------------------------------------
void spmv_device(const deviceDiaQMatrix &A, const valType *x_real, const valType *x_imag, valType *y_real,
                 valType *y_imag, cudaStream_t stream) {
    const unsigned int M = A.matrix_shape[0];
    const unsigned int N = A.matrix_shape[1];
    DIAQ_CUDA_CHECK(cudaMemsetAsync(y_real, 0, M * sizeof(valType), stream));
    DIAQ_CUDA_CHECK(cudaMemsetAsync(y_imag, 0, M * sizeof(valType), stream));
    const unsigned int numDiags = static_cast<unsigned int>(A.num_diags());
    if (numDiags == 0) return;
    const int threadsPerBlock = 256;
    const int maxBlocks = 65535;
    if (numDiags == 1) {
        const unsigned int len = A.diagLens[0];
        int blocks = static_cast<int>((len + threadsPerBlock - 1) / threadsPerBlock);
        if (blocks > maxBlocks) blocks = maxBlocks;
        if (blocks > 0) {
            spmv_single_diag_kernel<<<blocks, threadsPerBlock, 0, stream>>>(
                len, A.dIndices[0], A.diagOffsets[0], M, N, A.d_real, A.d_imag, x_real, x_imag, y_real, y_imag);
        }
    } else {
        int blocks = static_cast<int>((M + threadsPerBlock - 1) / threadsPerBlock);
        if (blocks > maxBlocks) blocks = maxBlocks;
        spmv_row_kernel<<<blocks, threadsPerBlock, 0, stream>>>(
            M, N, static_cast<int>(numDiags), A.d_dIndices, A.d_diagOffsets, A.d_diagLens, A.d_real, A.d_imag,
            x_real, x_imag, y_real, y_imag);
    }
    DIAQ_CUDA_CHECK(cudaGetLastError());
}

// Host vectors in and out, A already on the device: copies x and y only.
static void spmv_host_vectors(const deviceDiaQMatrix &A, const std::shared_ptr<vector> &x,
                              const std::shared_ptr<vector> &y) {
    const unsigned int M = A.matrix_shape[0];
    const unsigned int N = A.matrix_shape[1];
    if (x->numRows != N) throw std::runtime_error("spmv_cuda: dimension mismatch (x length vs A.cols)");
    if (y->numRows != M) throw std::runtime_error("spmv_cuda: dimension mismatch (y length vs A.rows)");
    DeviceBuffer xr(N), xi(N), yr(M), yi(M);
    DIAQ_CUDA_CHECK(cudaMemcpy(xr.p, x->realValues, N * sizeof(valType), cudaMemcpyHostToDevice));
    DIAQ_CUDA_CHECK(cudaMemcpy(xi.p, x->imagValues, N * sizeof(valType), cudaMemcpyHostToDevice));
    spmv_device(A, xr.p, xi.p, yr.p, yi.p, 0);
    DIAQ_CUDA_CHECK(cudaMemcpy(y->realValues, yr.p, M * sizeof(valType), cudaMemcpyDeviceToHost));
    DIAQ_CUDA_CHECK(cudaMemcpy(y->imagValues, yi.p, M * sizeof(valType), cudaMemcpyDeviceToHost));
}

// y = A * x, host matrix and vectors (A is uploaded for this call; for repeated products with one A, upload it once
// as a deviceDiaQMatrix).
void spmv_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
    if (x->numRows != A->matrix_shape[1]) throw std::runtime_error("spmv_cuda: dimension mismatch (x length vs A.cols)");
    if (y->numRows != A->matrix_shape[0]) throw std::runtime_error("spmv_cuda: dimension mismatch (y length vs A.rows)");
    deviceDiaQMatrix dA(A);
    spmv_host_vectors(dA, x, y);
}

std::shared_ptr<vector> spmv_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x) {
    auto y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spmv_cuda(A, x, y);
    return y;
}

std::shared_ptr<vector> spmv_cuda(const std::shared_ptr<deviceDiaQMatrix> &A, std::shared_ptr<vector> x) {
    auto y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spmv_host_vectors(*A, x, y);
    return y;
}

} // namespace diaq
