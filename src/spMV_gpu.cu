#include "matrixKernels_gpu.hpp"

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
// y = A * x  (convenience wrapper returning a new vector)
// -----------------------------------------------------------------------------
std::shared_ptr<vector> spmv_cuda(std::shared_ptr<diaQMatrix> A,
                                  std::shared_ptr<vector> x) {
    unsigned int M = A->matrix_shape[0];
    auto y = std::make_shared<vector>(M, 0.0, 0.0);
    spmv_cuda(A, x, y);
    return y;
}

// -----------------------------------------------------------------------------
// Core GPU spMV: y = A * x
// -----------------------------------------------------------------------------
void spmv_cuda(std::shared_ptr<diaQMatrix> A,
               std::shared_ptr<vector> x,
               std::shared_ptr<vector> y) {

    #ifdef DEBUG
        printf("starting <spMV_gpu> --- ");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    unsigned int M = A->matrix_shape[0];
    unsigned int N = A->matrix_shape[1];

    // Dimension checks (same as CPU semantics)
    if (x->numRows != N) {
        throw std::runtime_error("spmv_cuda: dimension mismatch (x length vs A.cols)");
    }
    if (y->numRows != M) {
        throw std::runtime_error("spmv_cuda: dimension mismatch (y length vs A.rows)");
    }

    unsigned int numDiags = static_cast<unsigned int>(A->dIndices.size());
    if (numDiags == 0) {
        #ifdef DEEP_DEBUG
            std::cout << "spmv_cuda: empty matrix, zeroing out y." << std::endl;
        #endif
        for (unsigned int i = 0; i < M; ++i) {
            y->realValues[i] = 0.0;
            y->imagValues[i] = 0.0;
        }
        return;
    }

    // ---------------- Host-side diagonal metadata ----------------
    std::vector<int>          h_dIndices(numDiags);
    std::vector<unsigned int> h_diagOffsets(numDiags);
    std::vector<unsigned int> h_diagLens(numDiags);

    for (unsigned int k = 0; k < numDiags; ++k) {
        int d = A->dIndices[k];
        h_dIndices[k]    = d;
        h_diagOffsets[k] = A->diagOffsets[k];
        h_diagLens[k]    = A->getDiagonalLengthInternal(d);
    }

    std::size_t totalLength = A->totalLength;

    #ifdef DEEP_DEBUG
        std::cout << "GPU spmv meta:" << std::endl;
        std::cout << "  M=" << M << ", N=" << N
                  << ", numDiags=" << numDiags
                  << ", totalLength=" << totalLength << std::endl;
        for (unsigned int k = 0; k < numDiags; ++k) {
            std::cout << "  k=" << k
                      << " d=" << h_dIndices[k]
                      << " offset=" << h_diagOffsets[k]
                      << " len=" << h_diagLens[k]
                      << std::endl;
        }
    #endif

    // ---------------- Device allocations ----------------
    valType *d_A_real = nullptr, *d_A_imag = nullptr;
    valType *d_x_real = nullptr, *d_x_imag = nullptr;
    valType *d_y_real = nullptr, *d_y_imag = nullptr;

    cudaMalloc(&d_A_real, totalLength * sizeof(valType));
    cudaMalloc(&d_A_imag, totalLength * sizeof(valType));
    cudaMemcpy(d_A_real, A->realData,
               totalLength * sizeof(valType), cudaMemcpyHostToDevice);
    cudaMemcpy(d_A_imag, A->imagData,
               totalLength * sizeof(valType), cudaMemcpyHostToDevice);

    cudaMalloc(&d_x_real, N * sizeof(valType));
    cudaMalloc(&d_x_imag, N * sizeof(valType));
    cudaMemcpy(d_x_real, x->realValues,
               N * sizeof(valType), cudaMemcpyHostToDevice);
    cudaMemcpy(d_x_imag, x->imagValues,
               N * sizeof(valType), cudaMemcpyHostToDevice);

    cudaMalloc(&d_y_real, M * sizeof(valType));
    cudaMalloc(&d_y_imag, M * sizeof(valType));
    cudaMemset(d_y_real, 0, M * sizeof(valType));
    cudaMemset(d_y_imag, 0, M * sizeof(valType));

    #ifdef DEBUG
        std::cout << "Host A_real: ";
        for (size_t i = 0; i < totalLength; ++i) std::cout << A->realData[i] << " ";
        std::cout << std::endl;
        std::cout << "Host A_imag: ";
        for (size_t i = 0; i < totalLength; ++i) std::cout << A->imagData[i] << " ";
        std::cout << std::endl;
        std::cout << "Host x_real: ";
        for (size_t i = 0; i < N; ++i) std::cout << x->realValues[i] << " ";
        std::cout << std::endl;
        std::cout << "Host x_imag: ";
        for (size_t i = 0; i < N; ++i) std::cout << x->imagValues[i] << " ";
        std::cout << std::endl;
    #endif

    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
        std::cerr << "CUDA error after allocation/copy: " << cudaGetErrorString(err) << std::endl;
    }
    int threadsPerBlock = 256;
    int maxBlocks       = 65535;

    // -----------------------------------------------------------------
    // SPECIAL CASE: single diagonal -> vector * shifted-vector
    // -----------------------------------------------------------------
    if (numDiags == 1) {
        int          d     = h_dIndices[0];
        unsigned int off   = h_diagOffsets[0];
        unsigned int len   = h_diagLens[0];

        int blocks = (static_cast<int>(len) + threadsPerBlock - 1) / threadsPerBlock;
        if (blocks > maxBlocks) blocks = maxBlocks;

        spmv_single_diag_kernel<<<blocks, threadsPerBlock>>>(
            len,
            d,
            off,
            M,
            N,
            d_A_real,
            d_A_imag,
            d_x_real,
            d_x_imag,
            d_y_real,
            d_y_imag
        );
        cudaDeviceSynchronize();
        err = cudaGetLastError();
        if (err != cudaSuccess) {
            std::cerr << "CUDA error after kernel: " << cudaGetErrorString(err) << std::endl;
        }
        #ifdef DEEP_DEBUG
            std::vector<valType> debug_y_real(M), debug_y_imag(M);
            cudaMemcpy(debug_y_real.data(), d_y_real, M * sizeof(valType), cudaMemcpyDeviceToHost);
            cudaMemcpy(debug_y_imag.data(), d_y_imag, M * sizeof(valType), cudaMemcpyDeviceToHost);
            std::cout << "Device y_real: ";
            for (size_t i = 0; i < M; ++i) std::cout << debug_y_real[i] << " ";
            std::cout << std::endl;
            std::cout << "Device y_imag: ";
            for (size_t i = 0; i < M; ++i) std::cout << debug_y_imag[i] << " ";
            std::cout << std::endl;
        #endif
    }
    // -----------------------------------------------------------------
    // GENERAL CASE: multiple diagonals -> row-based kernel
    // -----------------------------------------------------------------
    else {
        int          *d_dIndices    = nullptr;
        unsigned int *d_diagOffsets = nullptr;
        unsigned int *d_diagLens    = nullptr;

        cudaMalloc(&d_dIndices,    numDiags * sizeof(int));
        cudaMalloc(&d_diagOffsets, numDiags * sizeof(unsigned int));
        cudaMalloc(&d_diagLens,    numDiags * sizeof(unsigned int));

        cudaMemcpy(d_dIndices, h_dIndices.data(),
                   numDiags * sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(d_diagOffsets, h_diagOffsets.data(),
                   numDiags * sizeof(unsigned int), cudaMemcpyHostToDevice);
        cudaMemcpy(d_diagLens, h_diagLens.data(),
                   numDiags * sizeof(unsigned int), cudaMemcpyHostToDevice);

        int blocks = (static_cast<int>(M) + threadsPerBlock - 1) / threadsPerBlock;
        if (blocks > maxBlocks) blocks = maxBlocks;

        spmv_row_kernel<<<blocks, threadsPerBlock>>>(
            M,
            N,
            static_cast<int>(numDiags),
            d_dIndices,
            d_diagOffsets,
            d_diagLens,
            d_A_real,
            d_A_imag,
            d_x_real,
            d_x_imag,
            d_y_real,
            d_y_imag
        );
        cudaDeviceSynchronize();

        cudaFree(d_dIndices);
        cudaFree(d_diagOffsets);
        cudaFree(d_diagLens);
    }

    // ---------------- Copy result back ----------------
    cudaMemcpy(y->realValues, d_y_real,
               M * sizeof(valType), cudaMemcpyDeviceToHost);
    cudaMemcpy(y->imagValues, d_y_imag,
               M * sizeof(valType), cudaMemcpyDeviceToHost);

    // ---------------- Cleanup ----------------
    cudaFree(d_A_real);
    cudaFree(d_A_imag);
    cudaFree(d_x_real);
    cudaFree(d_x_imag);
    cudaFree(d_y_real);
    cudaFree(d_y_imag);

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
        printf("spMV_gpu completed in %.3f ms\n", duration / 1000.0);
    #endif
}

} // namespace diaq
