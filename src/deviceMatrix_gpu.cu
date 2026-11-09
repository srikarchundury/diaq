#include "deviceMatrix_gpu.hpp"

#include <algorithm>
#include <stdexcept>

#include "cuda_check.hpp"

namespace diaq {

DeviceBuffer::DeviceBuffer(std::size_t n) {
    if (n > 0) DIAQ_CUDA_CHECK(cudaMalloc(&p, n * sizeof(valType)));
}

DeviceBuffer::~DeviceBuffer() { cudaFree(p); }

unsigned int diagonal_length(int d, const std::array<unsigned int, 2> &shape) {
    unsigned int len;
    if (d < 0) {
        len = shape[0] + d;
    } else if (d > 0) {
        len = shape[1] - d;
    } else {
        len = shape[0] < shape[1] ? shape[0] : shape[1];
    }
    if (len > shape[0]) len = shape[0];
    if (len > shape[1]) len = shape[1];
    return len;
}

void deviceDiaQMatrix::layout_and_allocate() {
    const std::size_t n = dIndices.size();
    diagOffsets.resize(n);
    diagLens.resize(n);
    totalLength = 0;
    for (std::size_t k = 0; k < n; ++k) {
        diagOffsets[k] = static_cast<unsigned int>(totalLength);
        diagLens[k] = diagonal_length(dIndices[k], matrix_shape);
        totalLength += diagLens[k];
    }
    if (n > 0) {
        DIAQ_CUDA_CHECK(cudaMalloc(&d_dIndices, n * sizeof(int)));
        DIAQ_CUDA_CHECK(cudaMalloc(&d_diagOffsets, n * sizeof(unsigned int)));
        DIAQ_CUDA_CHECK(cudaMalloc(&d_diagLens, n * sizeof(unsigned int)));
        DIAQ_CUDA_CHECK(cudaMemcpy(d_dIndices, dIndices.data(), n * sizeof(int), cudaMemcpyHostToDevice));
        DIAQ_CUDA_CHECK(cudaMemcpy(d_diagOffsets, diagOffsets.data(), n * sizeof(unsigned int),
                                   cudaMemcpyHostToDevice));
        DIAQ_CUDA_CHECK(cudaMemcpy(d_diagLens, diagLens.data(), n * sizeof(unsigned int), cudaMemcpyHostToDevice));
    }
    if (totalLength > 0) {
        DIAQ_CUDA_CHECK(cudaMalloc(&d_real, totalLength * sizeof(valType)));
        DIAQ_CUDA_CHECK(cudaMalloc(&d_imag, totalLength * sizeof(valType)));
        DIAQ_CUDA_CHECK(cudaMemset(d_real, 0, totalLength * sizeof(valType)));
        DIAQ_CUDA_CHECK(cudaMemset(d_imag, 0, totalLength * sizeof(valType)));
    }
}

deviceDiaQMatrix::deviceDiaQMatrix(std::array<unsigned int, 2> shape_, const std::vector<int> &diagonals)
    : matrix_shape(shape_), shape{shape_[0], shape_[1]}, dIndices(diagonals) {
    layout_and_allocate();
}

deviceDiaQMatrix::deviceDiaQMatrix(const std::shared_ptr<diaQMatrix> &A)
    : matrix_shape(A->matrix_shape), shape(A->shape), dIndices(A->dIndices) {
    layout_and_allocate();
    if (totalLength == 0) return;
    // stage the diagonals packed (the host layout is SIMD-padded), then one copy per part
    std::vector<valType> re(totalLength), im(totalLength);
    for (std::size_t k = 0; k < dIndices.size(); ++k) {
        const valType *sr = A->realData + A->diagOffsets[k];
        const valType *si = A->imagData + A->diagOffsets[k];
        std::copy(sr, sr + diagLens[k], re.begin() + diagOffsets[k]);
        std::copy(si, si + diagLens[k], im.begin() + diagOffsets[k]);
    }
    DIAQ_CUDA_CHECK(cudaMemcpy(d_real, re.data(), totalLength * sizeof(valType), cudaMemcpyHostToDevice));
    DIAQ_CUDA_CHECK(cudaMemcpy(d_imag, im.data(), totalLength * sizeof(valType), cudaMemcpyHostToDevice));
}

deviceDiaQMatrix::~deviceDiaQMatrix() {
    // no throwing from a destructor: errors here are reported by the next checked CUDA call
    cudaFree(d_dIndices);
    cudaFree(d_diagOffsets);
    cudaFree(d_diagLens);
    cudaFree(d_real);
    cudaFree(d_imag);
}

std::shared_ptr<deviceDiaQMatrix> deviceDiaQMatrix::copy() const {
    auto C = std::make_shared<deviceDiaQMatrix>(matrix_shape, dIndices);
    C->shape = shape;
    if (totalLength > 0) {
        DIAQ_CUDA_CHECK(cudaMemcpy(C->d_real, d_real, totalLength * sizeof(valType), cudaMemcpyDeviceToDevice));
        DIAQ_CUDA_CHECK(cudaMemcpy(C->d_imag, d_imag, totalLength * sizeof(valType), cudaMemcpyDeviceToDevice));
    }
    return C;
}

std::shared_ptr<diaQMatrix> deviceDiaQMatrix::to_host() const {
    if (dIndices.empty()) {
        return std::make_shared<diaQMatrix>(matrix_shape);
    }
    std::shared_ptr<diaQMatrix> H = std::make_shared<diaQMatrix>(matrix_shape, dIndices, shape);
    if (totalLength == 0) return H;
    std::vector<valType> re(totalLength), im(totalLength);
    DIAQ_CUDA_CHECK(cudaMemcpy(re.data(), d_real, totalLength * sizeof(valType), cudaMemcpyDeviceToHost));
    DIAQ_CUDA_CHECK(cudaMemcpy(im.data(), d_imag, totalLength * sizeof(valType), cudaMemcpyDeviceToHost));
    for (std::size_t k = 0; k < dIndices.size(); ++k) {
        std::copy(re.begin() + diagOffsets[k], re.begin() + diagOffsets[k] + diagLens[k],
                  H->realData + H->diagOffsets[k]);
        std::copy(im.begin() + diagOffsets[k], im.begin() + diagOffsets[k] + diagLens[k],
                  H->imagData + H->diagOffsets[k]);
    }
    return H;
}

}  // namespace diaq
