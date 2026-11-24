#ifndef DIAQ_DEVICEMATRIX_GPU_HPP
#define DIAQ_DEVICEMATRIX_GPU_HPP

// A diaQMatrix kept in GPU memory. The host-in/host-out GPU entry points (spmv_cuda, product_cuda) copy the whole
// matrix to the GPU and back on every call; a deviceDiaQMatrix is uploaded once and can be used by any number of
// device products (spmv_device, product_device), and downloaded only when its values are needed on the host.
//
// Layout on the device: values in structure-of-arrays form (real, imaginary), diagonals packed back to back (no SIMD
// padding), with per-diagonal index, offset and length arrays. The host keeps copies of the metadata (diagonal
// indices, offsets, lengths), which products need to pair diagonals without reading the device.

#include <array>
#include <cstddef>
#include <memory>
#include <vector>

#include "cuda_runtime_api.h"

#include "config.hpp"
#include "diaQMatrix.hpp"
#include "vector.hpp"

namespace diaq {

// A device array of n values, freed when it goes out of scope.
struct DeviceBuffer {
    valType *p = nullptr;
    explicit DeviceBuffer(std::size_t n);
    ~DeviceBuffer();
    DeviceBuffer(const DeviceBuffer &) = delete;
    DeviceBuffer &operator=(const DeviceBuffer &) = delete;
};

// Length of diagonal d of a rows x cols matrix (as diaQMatrix::getDiagonalLengthInternal).
unsigned int diagonal_length(int d, const std::array<unsigned int, 2> &shape);

class deviceDiaQMatrix {
public:
    std::array<unsigned int, 2> matrix_shape{};
    std::vector<unsigned int> shape;          // tensor shape, kept for the way back to the host
    std::vector<int> dIndices;                // host copies of the metadata
    std::vector<unsigned int> diagOffsets;    // packed offsets into the device value arrays
    std::vector<unsigned int> diagLens;
    std::size_t totalLength = 0;

    int *d_dIndices = nullptr;
    unsigned int *d_diagOffsets = nullptr;
    unsigned int *d_diagLens = nullptr;
    valType *d_real = nullptr;
    valType *d_imag = nullptr;

    // Upload a host matrix (one copy of its values).
    explicit deviceDiaQMatrix(const std::shared_ptr<diaQMatrix> &A);
    // A matrix with these diagonals, all values zero, on the device.
    deviceDiaQMatrix(std::array<unsigned int, 2> shape, const std::vector<int> &diagonals);
    ~deviceDiaQMatrix();
    deviceDiaQMatrix(const deviceDiaQMatrix &) = delete;
    deviceDiaQMatrix &operator=(const deviceDiaQMatrix &) = delete;

    // A second device matrix with the same values (device-to-device copy).
    std::shared_ptr<deviceDiaQMatrix> copy() const;
    // Download into a new host matrix (its own, SIMD-padded layout).
    std::shared_ptr<diaQMatrix> to_host() const;
    std::size_t num_diags() const { return dIndices.size(); }

private:
    void layout_and_allocate();  // packed offsets from dIndices, device metadata, zeroed device values
};

// y = A x on the device; x and y are device arrays (real and imaginary parts) of A's column / row count. y is
// overwritten. Asynchronous on `stream`.
void spmv_device(const deviceDiaQMatrix &A, const valType *x_real, const valType *x_imag, valType *y_real,
                 valType *y_imag, cudaStream_t stream = 0);

// y = A x for a host vector x with A already on the device (only x and y are copied).
std::shared_ptr<vector> spmv_cuda(const std::shared_ptr<deviceDiaQMatrix> &A, std::shared_ptr<vector> x);

// C = A B with all three on the device.
std::shared_ptr<deviceDiaQMatrix> product_device(const deviceDiaQMatrix &A, const deviceDiaQMatrix &B);

}  // namespace diaq

#endif
