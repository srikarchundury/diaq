#include "conversions_gpu.hpp"

#ifdef CUDA_ENABLED

#include <cmath>
#include <vector>
#include <tuple>
#include <iterator>
#include <memory>

namespace diaq {

// -----------------------------------------------------------------------------
// GPU kernel: map flat index -> (diagonal index, diagonal position)
// -----------------------------------------------------------------------------
__global__ void convert_to_dq(
    unsigned int size,
    unsigned int matrix_size_x,   // kept for signature compatibility; unused
    unsigned int matrix_size_y,
    int* device_diagonal_idx,
    unsigned int* device_diagonal_pos
) {
    // 1D indexing — we launch 1D blocks/grids
    unsigned int index = blockIdx.x * blockDim.x + threadIdx.x;
    if (index >= size) {
        return;
    }

    // Row-major: row = index / matrix_size_y, col = index % matrix_size_y
    unsigned int row = index / matrix_size_y;
    unsigned int col = index % matrix_size_y;

    // Diagonal index: dIndex = col - row (can be negative, so cast to int)
    int d_idx = static_cast<int>(col) - static_cast<int>(row);

    // Position along the diagonal:
    // - For d_idx >= 0: diagonal starts at (0, d_idx), so pos = row
    // - For d_idx <  0: diagonal starts at (-d_idx, 0), so pos = col
    unsigned int d_pos;
    if (d_idx >= 0) {
        d_pos = row;
    } else {
        d_pos = col;
    }

    device_diagonal_idx[index] = d_idx;
    device_diagonal_pos[index] = d_pos;
}

// -----------------------------------------------------------------------------
// from_numpy_cuda: GPU-accelerated from_numpy
// -----------------------------------------------------------------------------
std::shared_ptr<diaQMatrix> from_numpy_cuda(std::complex<valType>* values, std::vector<unsigned int> shape) {

    #ifdef DEBUG
        std::cout << "Using CUDA from_numpy_cuda path" << std::endl;
        printf(" starting from_numpy_cuda -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    // ----- Compute total number of elements -----
    unsigned int product = 1;
    for (std::size_t s = 0; s < shape.size(); ++s) {
        product *= shape[s];
    }
    #ifdef DEBUG
        printf("DEBUG: product=%u, shape.size()=%zu\n", product, shape.size());
    #endif

    int rank = static_cast<int>(shape.size());
    unsigned int x;
    unsigned int y;

    if (rank > 2) {
        unsigned int sqrtProduct = static_cast<unsigned int>(std::sqrt(static_cast<double>(product)));
        x = 1;
        y = product;
        for (unsigned int i = sqrtProduct; i > 0; --i) {
            if (product % i == 0) {
                x = i;
                y = product / i;
                break;
            }
        }
    } else {
        x = shape[0];
        y = shape[1];
    }
    #ifdef DEBUG
        printf("DEBUG: matrix_shape=(%u,%u)\n", x, y);
    #endif

    std::array<unsigned int, 2> matrix_shape = {x, y};
    unsigned int matrix_size_x = matrix_shape[0];
    unsigned int matrix_size_y = matrix_shape[1];

    // ----- GPU buffers for diagonal index/position -----
    int* device_diagonal_idx = NULL;
    unsigned int* device_diagonal_pos = NULL;

    cudaError_t err;
    err = cudaMalloc(&device_diagonal_idx, static_cast<std::size_t>(product) * sizeof(int));
    if (err != cudaSuccess) {
        #ifdef DEBUG
        printf("cudaMalloc device_diagonal_idx failed: %s\n", cudaGetErrorString(err));
        #endif
        return nullptr;
    }
    err = cudaMalloc(&device_diagonal_pos, static_cast<std::size_t>(product) * sizeof(unsigned int));
    if (err != cudaSuccess) {
        #ifdef DEBUG
        printf("cudaMalloc device_diagonal_pos failed: %s\n", cudaGetErrorString(err));
        #endif
        cudaFree(device_diagonal_idx);
        return nullptr;
    }

    // Launch kernel (1D)
    unsigned int totalDataSize = product;
    int threadsPerBlock = 256;
    int numBlocks = static_cast<int>((totalDataSize + static_cast<unsigned int>(threadsPerBlock) - 1) / static_cast<unsigned int>(threadsPerBlock));

    #ifdef DEBUG
        printf("DEBUG: Launching kernel with numBlocks=%d, threadsPerBlock=%d\n", numBlocks, threadsPerBlock);
    #endif

    convert_to_dq<<<numBlocks, threadsPerBlock>>>(product, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        #ifdef DEBUG
            printf("Kernel launch failed: %s\n", cudaGetErrorString(err));
        #endif
        cudaFree(device_diagonal_idx);
        cudaFree(device_diagonal_pos);
        return nullptr;
    }
    err = cudaDeviceSynchronize();
    if (err != cudaSuccess) {
        #ifdef DEBUG
            printf("cudaDeviceSynchronize failed: %s\n", cudaGetErrorString(err));
        #endif
        cudaFree(device_diagonal_idx);
        cudaFree(device_diagonal_pos);
        return nullptr;
    }

    // ----- Host copies (use shared_ptr for arrays) -----
    std::shared_ptr<int[]> host_diagonal_idx(new int[static_cast<std::size_t>(product)], std::default_delete<int[]>());
    std::shared_ptr<unsigned int[]> host_diagonal_pos(new unsigned int[static_cast<std::size_t>(product)], std::default_delete<unsigned int[]>());

    err = cudaMemcpy(host_diagonal_idx.get(), device_diagonal_idx, static_cast<std::size_t>(product) * sizeof(int), cudaMemcpyDeviceToHost);
    if (err != cudaSuccess) {
        #ifdef DEBUG
            printf("cudaMemcpy device_diagonal_idx failed: %s\n", cudaGetErrorString(err));
        #endif
        cudaFree(device_diagonal_idx);
        cudaFree(device_diagonal_pos);
        return nullptr;
    }
    err = cudaMemcpy(host_diagonal_pos.get(), device_diagonal_pos, static_cast<std::size_t>(product) * sizeof(unsigned int), cudaMemcpyDeviceToHost);
    if (err != cudaSuccess) {
        #ifdef DEBUG
            printf("cudaMemcpy device_diagonal_pos failed: %s\n", cudaGetErrorString(err));
        #endif
        cudaFree(device_diagonal_idx);
        cudaFree(device_diagonal_pos);
        return nullptr;
    }

    cudaFree(device_diagonal_idx);
    cudaFree(device_diagonal_pos);

    // ----- Build diaQMatrix, skipping all-zero diagonals -----
    // Fastest: sequential diagonal order
    int min_diag = -static_cast<int>(matrix_shape[0]) + 1;
    int max_diag = static_cast<int>(matrix_shape[1]) - 1;
    std::vector<int> diag_order;
    for (int d = min_diag; d <= max_diag; ++d) {
        diag_order.push_back(d);
    }
    // For each diagonal, check if all elements are zero
    std::vector<int> nonzero_diags;
    std::vector<std::vector<valType>> real_diags;
    std::vector<std::vector<valType>> imag_diags;
    for (int d : diag_order) {
        unsigned int len = diaQMatrix(matrix_shape, {d}).getDiagonalLength(d);
        std::vector<valType> real_diag(len, 0.0);
        std::vector<valType> imag_diag(len, 0.0);
        bool all_zero = true;
        for (unsigned int j = 0; j < len; ++j) {
            std::array<unsigned int, 2> mat_pos = diaQMatrix(matrix_shape, {d}).getMatrixPosition(d, j);
            unsigned int fi = mat_pos[0] * matrix_shape[1] + mat_pos[1];
            real_diag[j] = values[fi].real();
            imag_diag[j] = values[fi].imag();
            if (real_diag[j] != 0.0 || imag_diag[j] != 0.0) {
                all_zero = false;
            }
        }
        if (!all_zero) {
            nonzero_diags.push_back(d);
            real_diags.push_back(real_diag);
            imag_diags.push_back(imag_diag);
        }
    }
    std::shared_ptr<diaQMatrix> diaq_res = std::make_shared<diaQMatrix>(matrix_shape, nonzero_diags, shape);
    // Fill only nonzero diagonals
    for (size_t idx = 0; idx < nonzero_diags.size(); ++idx) {
        int d = nonzero_diags[idx];
        unsigned int len = diaq_res->getDiagonalLength(d);
        int slot = diaq_res->findDiagonalSlot(d);
        if (slot < 0) continue;
        unsigned int offset = diaq_res->diagOffsets[slot];
        for (unsigned int j = 0; j < len; ++j) {
            diaq_res->realData[offset + j] = real_diags[idx][j];
            diaq_res->imagData[offset + j] = imag_diags[idx][j];
        }
    }
    diaq_res->shape = shape;

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
        printf("from_numpy_cuda done in %ld ms \n", duration);
    #endif

    return diaq_res;
}

// -----------------------------------------------------------------------------
// convertToDiaQ_cuda: GPU-accelerated denseMatrix::convertToDiaQ(new_shape)
// -----------------------------------------------------------------------------
std::shared_ptr<diaQMatrix> convertToDiaQ_cuda(std::shared_ptr<denseMatrix> d,
                                               std::array<unsigned int, 2> new_shape) {
    valType* realData = d->getRealData();
    valType* imagData = d->getImagData();

	unsigned int size = new_shape[0] * new_shape[1];

    // ----- GPU buffers -----
    int* device_diagonal_idx = NULL;
    unsigned int* device_diagonal_pos = NULL;

    cudaMalloc(
        &device_diagonal_idx,
        static_cast<std::size_t>(size) * sizeof(int)
    );
    cudaMalloc(
        &device_diagonal_pos,
        static_cast<std::size_t>(size) * sizeof(unsigned int)
    );

    int threadsPerBlock = 1024;
    int numBlocks = static_cast<int>(
        (size + static_cast<unsigned int>(threadsPerBlock) - 1) /
        static_cast<unsigned int>(threadsPerBlock)
    );

    convert_to_dq<<<numBlocks, threadsPerBlock>>>(
        size,
        new_shape[0],
        new_shape[1],
        device_diagonal_idx,
        device_diagonal_pos
    );
    cudaDeviceSynchronize();

    // ----- Host copies -----
    std::shared_ptr<int[]> host_diagonal_idx(
        new int[static_cast<std::size_t>(size)],
        std::default_delete<int[]>()
    );
    std::shared_ptr<unsigned int[]> host_diagonal_pos(
        new unsigned int[static_cast<std::size_t>(size)],
        std::default_delete<unsigned int[]>()
    );

    cudaMemcpy(
        host_diagonal_idx.get(),
        device_diagonal_idx,
        static_cast<std::size_t>(size) * sizeof(int),
        cudaMemcpyDeviceToHost
    );
    cudaMemcpy(
        host_diagonal_pos.get(),
        device_diagonal_pos,
        static_cast<std::size_t>(size) * sizeof(unsigned int),
        cudaMemcpyDeviceToHost
    );

    cudaFree(device_diagonal_idx);
    cudaFree(device_diagonal_pos);

    // Fastest: sequential diagonal order
    int min_diag = -static_cast<int>(new_shape[0]) + 1;
    int max_diag = static_cast<int>(new_shape[1]) - 1;
    std::vector<int> diag_order;
    for (int d = min_diag; d <= max_diag; ++d) {
        diag_order.push_back(d);
    }
    // Build diaQMatrix using zig-zag order
    std::vector<int> nonzero_diags;
    std::vector<std::vector<valType>> real_diags;
    std::vector<std::vector<valType>> imag_diags;
    for (int d : diag_order) {
        unsigned int len = diaQMatrix(new_shape, {d}).getDiagonalLength(d);
        std::vector<valType> real_diag(len, 0.0);
        std::vector<valType> imag_diag(len, 0.0);
        bool all_zero = true;
        for (unsigned int j = 0; j < len; ++j) {
            std::array<unsigned int, 2> mat_pos = diaQMatrix(new_shape, {d}).getMatrixPosition(d, j);
            unsigned int fi = mat_pos[0] * new_shape[1] + mat_pos[1];
            real_diag[j] = realData[fi];
            imag_diag[j] = imagData[fi];
            if (real_diag[j] != 0.0 || imag_diag[j] != 0.0) {
                all_zero = false;
            }
        }
        if (!all_zero) {
            nonzero_diags.push_back(d);
            real_diags.push_back(real_diag);
            imag_diags.push_back(imag_diag);
        }
    }
    std::shared_ptr<diaQMatrix> diaq_res = std::make_shared<diaQMatrix>(new_shape, nonzero_diags, d->shape);
    // Fill only nonzero diagonals
    for (size_t idx = 0; idx < nonzero_diags.size(); ++idx) {
        int d = nonzero_diags[idx];
        unsigned int len = diaq_res->getDiagonalLength(d);
        int slot = diaq_res->findDiagonalSlot(d);
        if (slot < 0) continue;
        unsigned int offset = diaq_res->diagOffsets[slot];
        for (unsigned int j = 0; j < len; ++j) {
            diaq_res->realData[offset + j] = real_diags[idx][j];
            diaq_res->imagData[offset + j] = imag_diags[idx][j];
        }
    }
    diaq_res->shape = d->shape;
    return diaq_res;
}

} // namespace diaq

#endif // CUDA_ENABLED
