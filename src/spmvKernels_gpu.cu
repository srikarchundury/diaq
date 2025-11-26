#include "matrixKernels_gpu.hpp"

#include <vector>
#include <stdexcept>

namespace diaq {

// -----------------------------------------------------------------------------
// Row-parallel spMV kernel
// Each thread processes several rows of y:
//    y[row] = sum_k A(row, col_k) * x[col_k]
// No atomics, because each row is owned by a single thread.
// -----------------------------------------------------------------------------
__global__ void spmv_row_kernel(
    unsigned int numRows,
    unsigned int numCols,
    int          numDiags,
    const int * __restrict__ dIndices,          // [numDiags]
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

        // Loop over diagonals
        for (int k = 0; k < numDiags; ++k) {
            int d              = dIndices[k];
            unsigned int len   = diagLens[k];
            unsigned int off   = diagOffsets[k];

            // Map this row to (pos, col) on the diagonal d,
            // consistent with CPU scalar fallback:
            //
            // d < 0: x_idx = i;           y_idx = i - d;
            // d > 0: x_idx = d + i;       y_idx = i;
            // d = 0: x_idx = i;           y_idx = i;
            //
            // Here we invert to get i, x_idx from (row,d).

            int pos_int;
            int col;

            if (d == 0) {
                pos_int = static_cast<int>(row);
                col     = static_cast<int>(row);
                if (pos_int < 0 || pos_int >= static_cast<int>(len)) continue;
                if (col     < 0 || col     >= static_cast<int>(numCols)) continue;
            } else if (d > 0) {
                // y_idx = i = row
                pos_int = static_cast<int>(row);
                col     = d + pos_int;
                if (pos_int < 0 || pos_int >= static_cast<int>(len))       continue;
                if (col     < 0 || col     >= static_cast<int>(numCols))   continue;
            } else { // d < 0
                // y_idx = i - d = row  =>  i = row + d
                pos_int = static_cast<int>(row) + d; // d is negative
                if (pos_int < 0 || pos_int >= static_cast<int>(len))       continue;
                col = pos_int;
                if (col < 0 || col >= static_cast<int>(numCols))           continue;
            }

            unsigned int pos  = static_cast<unsigned int>(pos_int);
            unsigned int idxA = off + pos;
            unsigned int idxX = static_cast<unsigned int>(col);

            valType ar = A_real[idxA];
            valType ai = A_imag[idxA];
            valType xr = x_real[idxX];
            valType xi = x_imag[idxX];

            // (ar + i ai) * (xr + i xi)
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
    // Mirror CPU path: constructor (num_rows, real_init, imag_init)
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
        std::cout << "\t\t Starging spmv_cuda..." << std::endl;
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    unsigned int M = A->matrix_shape[0];
    unsigned int N = A->matrix_shape[1];

    if (x->numRows != N) {
        throw std::runtime_error("spmv_cuda: dimension mismatch (x length vs A.cols)");
    }
    if (y->numRows != M) {
        throw std::runtime_error("spmv_cuda: dimension mismatch (y length vs A.rows)");
    }

    int numDiags = static_cast<int>(A->dIndices.size());
    if (numDiags == 0 || A->totalLength == 0) {
        // Just zero out y and return
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

    for (int k = 0; k < numDiags; ++k) {
        int d = A->dIndices[static_cast<std::size_t>(k)];
        h_dIndices[k]    = d;
        h_diagOffsets[k] = A->diagOffsets[static_cast<std::size_t>(k)];
        h_diagLens[k]    = A->getDiagonalLengthInternal(d);
    }

    // ---------------- Device allocations ----------------
    valType *d_A_real = nullptr, *d_A_imag = nullptr;
    valType *d_x_real = nullptr, *d_x_imag = nullptr;
    valType *d_y_real = nullptr, *d_y_imag = nullptr;

    int          *d_dIndices    = nullptr;
    unsigned int *d_diagOffsets = nullptr;
    unsigned int *d_diagLens    = nullptr;

    // A data (SoA)
    cudaMalloc(&d_A_real, A->totalLength * sizeof(valType));
    cudaMalloc(&d_A_imag, A->totalLength * sizeof(valType));
    cudaMemcpy(d_A_real, A->realData,
               A->totalLength * sizeof(valType), cudaMemcpyHostToDevice);
    cudaMemcpy(d_A_imag, A->imagData,
               A->totalLength * sizeof(valType), cudaMemcpyHostToDevice);

    // x data
    cudaMalloc(&d_x_real, N * sizeof(valType));
    cudaMalloc(&d_x_imag, N * sizeof(valType));
    cudaMemcpy(d_x_real, x->realValues,
               N * sizeof(valType), cudaMemcpyHostToDevice);
    cudaMemcpy(d_x_imag, x->imagValues,
               N * sizeof(valType), cudaMemcpyHostToDevice);

    // y data (we overwrite it fully)
    cudaMalloc(&d_y_real, M * sizeof(valType));
    cudaMalloc(&d_y_imag, M * sizeof(valType));
    cudaMemset(d_y_real, 0, M * sizeof(valType));
    cudaMemset(d_y_imag, 0, M * sizeof(valType));

    // Diagonal metadata
    cudaMalloc(&d_dIndices,    numDiags * sizeof(int));
    cudaMalloc(&d_diagOffsets, numDiags * sizeof(unsigned int));
    cudaMalloc(&d_diagLens,    numDiags * sizeof(unsigned int));

    cudaMemcpy(d_dIndices, h_dIndices.data(),
               numDiags * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_diagOffsets, h_diagOffsets.data(),
               numDiags * sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_diagLens, h_diagLens.data(),
               numDiags * sizeof(unsigned int), cudaMemcpyHostToDevice);

    // ---------------- Launch row-parallel kernel ----------------
    int threadsPerBlock = 256;
    int maxBlocks       = 65535;
    int blocks          = (static_cast<int>(M) + threadsPerBlock - 1) / threadsPerBlock;
    if (blocks > maxBlocks) blocks = maxBlocks;

    spmv_row_kernel<<<blocks, threadsPerBlock>>>(
        M,
        N,
        numDiags,
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
    cudaFree(d_dIndices);
    cudaFree(d_diagOffsets);
    cudaFree(d_diagLens);

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
        std::cout << "\t\t spmv_cuda completed in " << duration << " ms." << std::endl;
    #endif

}

} // namespace diaq
