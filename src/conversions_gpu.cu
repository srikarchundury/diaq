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
        printf(" starting from_numpy_cuda -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif
    // ----- Compute total number of elements -----
    unsigned int product = 1;
    for (std::size_t s = 0; s < shape.size(); ++s) {
        product *= shape[s];
    }

    int rank = static_cast<int>(shape.size());
    unsigned int x;
    unsigned int y;

    if (rank > 2) {
        // For higher-order tensors, choose a "nice" matrix shape (x, y)
        unsigned int sqrtProduct = static_cast<unsigned int>(
            std::sqrt(static_cast<double>(product))
        );
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
        // Matrix case
        x = shape[0];
        y = shape[1];
    }

    std::array<unsigned int, 2> matrix_shape = {x, y};

    unsigned int matrix_size_x = matrix_shape[0];
    unsigned int matrix_size_y = matrix_shape[1];

    // ----- GPU buffers for diagonal index/position -----
    int* device_diagonal_idx = NULL;
    unsigned int* device_diagonal_pos = NULL;

    cudaMalloc(
        &device_diagonal_idx,
        static_cast<std::size_t>(product) * sizeof(int)
    );
    cudaMalloc(
        &device_diagonal_pos,
        static_cast<std::size_t>(product) * sizeof(unsigned int)
    );

    // Launch kernel (1D)
    unsigned int totalDataSize = product;
    int threadsPerBlock = 256;
    int numBlocks = static_cast<int>(
        (totalDataSize + static_cast<unsigned int>(threadsPerBlock) - 1) /
        static_cast<unsigned int>(threadsPerBlock)
    );

    convert_to_dq<<<numBlocks, threadsPerBlock>>>(
        product,
        matrix_size_x,
        matrix_size_y,
        device_diagonal_idx,
        device_diagonal_pos
    );
    cudaDeviceSynchronize();

    // ----- Host copies (use shared_ptr for arrays) -----
    std::shared_ptr<int[]> host_diagonal_idx(
        new int[static_cast<std::size_t>(product)],
        std::default_delete<int[]>()
    );
    std::shared_ptr<unsigned int[]> host_diagonal_pos(
        new unsigned int[static_cast<std::size_t>(product)],
        std::default_delete<unsigned int[]>()
    );

    cudaMemcpy(
        host_diagonal_idx.get(),
        device_diagonal_idx,
        static_cast<std::size_t>(product) * sizeof(int),
        cudaMemcpyDeviceToHost
    );
    cudaMemcpy(
        host_diagonal_pos.get(),
        device_diagonal_pos,
        static_cast<std::size_t>(product) * sizeof(unsigned int),
        cudaMemcpyDeviceToHost
    );

    cudaFree(device_diagonal_idx);
    cudaFree(device_diagonal_pos);

    // ----- Build diaQMatrix -----
    std::shared_ptr<diaQMatrix> diaq_res =
        std::make_shared<diaQMatrix>(matrix_shape);

    // Track the original tensor shape (like CPU path)
    diaq_res->shape = shape;

    // We keep the heavy sparse structure operations on CPU, but:
    // - use OpenMP
    // - batch updates per thread to reduce critical-section overhead
    #pragma omp parallel
    {
        std::vector< std::tuple<int, unsigned int, valType, valType> > local_updates;

        #pragma omp for nowait
        for (unsigned int i = 0; i < product; ++i) {
            valType r = values[i].real();
            valType im = values[i].imag();
            if (r != static_cast<valType>(0.0) || im != static_cast<valType>(0.0)) {
                int dIndex = host_diagonal_idx.get()[i];
                unsigned int dPos = host_diagonal_pos.get()[i];
                std::tuple<int, unsigned int, valType, valType> tup(
                    dIndex,
                    dPos,
                    r,
                    im
                );
                local_updates.push_back(tup);
            }
        }

        #pragma omp critical
        {
            for (std::size_t k = 0; k < local_updates.size(); ++k) {
                const std::tuple<int, unsigned int, valType, valType>& update =
                    local_updates[k];
                int dIndex = std::get<0>(update);
                unsigned int dPos = std::get<1>(update);
                valType r = std::get<2>(update);
                valType im = std::get<3>(update);

                diaq_res->setDiagonalElement(
                    dIndex,
                    dPos,
                    diaq_res->getDiagonalLength(dIndex),
                    r,
                    im
                );
            }
        }
    }

    // ---- Assign dIndices and dPointers like CPU path ----
    std::size_t numDiags = diaq_res->diagonalMap.size();
    diaq_res->dIndices.resize(numDiags);
    diaq_res->dPointers.resize(numDiags);

    #pragma omp parallel for
    for (std::size_t a = 0; a < numDiags; ++a) {
        phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it =
            diaq_res->diagonalMap.begin();
        std::advance(it, static_cast<long>(a));

        int dIndex = (*it).first;
        std::shared_ptr<diagonal> dptr = (*it).second;

        diaq_res->dIndices[a] = dIndex;
        diaq_res->dPointers[a] = dptr;
    }

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

    // ----- Build diaQMatrix -----
    std::shared_ptr<diaQMatrix> diaq_res = std::make_shared<diaQMatrix>(new_shape);

    // Same batching trick as above to reduce critical overhead
    #pragma omp parallel
    {
        std::vector< std::tuple<int, unsigned int, valType, valType> > local_updates;

        #pragma omp for nowait
        for (unsigned int i = 0; i < size; ++i) {
            valType r = realData[i];
            valType im = imagData[i];
            if (r != static_cast<valType>(0.0) || im != static_cast<valType>(0.0)) {
                int dIndex = host_diagonal_idx.get()[i];
                unsigned int dPos = host_diagonal_pos.get()[i];
                std::tuple<int, unsigned int, valType, valType> tup(
                    dIndex,
                    dPos,
                    r,
                    im
                );
                local_updates.push_back(tup);
            }
        }

        #pragma omp critical
        {
            for (std::size_t k = 0; k < local_updates.size(); ++k) {
                const std::tuple<int, unsigned int, valType, valType>& update =
                    local_updates[k];
                int dIndex = std::get<0>(update);
                unsigned int dPos = std::get<1>(update);
                valType r = std::get<2>(update);
                valType im = std::get<3>(update);

                diaq_res->setDiagonalElement(
                    dIndex,
                    dPos,
                    diaq_res->getDiagonalLength(dIndex),
                    r,
                    im
                );
            }
        }
    }

    // Assign dIndices and dPointers
    std::size_t numDiags = diaq_res->diagonalMap.size();
    diaq_res->dIndices.resize(numDiags);
    diaq_res->dPointers.resize(numDiags);

    #pragma omp parallel for
    for (std::size_t a = 0; a < numDiags; ++a) {
        phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it =
            diaq_res->diagonalMap.begin();
        std::advance(it, static_cast<long>(a));

        int dIndex = (*it).first;
        std::shared_ptr<diagonal> dptr = (*it).second;

        diaq_res->dIndices[a] = dIndex;
        diaq_res->dPointers[a] = dptr;
    }

    // Track original dense shape
    diaq_res->shape = d->shape;

    return diaq_res;
}

} // namespace diaq

#endif // CUDA_ENABLED
