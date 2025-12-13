#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<diaQMatrix> add(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
    if(A->matrix_shape[0] != B->matrix_shape[0] || A->matrix_shape[1] != B->matrix_shape[1]) {
        throw std::invalid_argument("input matrices are not addable");
    }
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(A->matrix_shape, A->dIndices, A->shape);
    for (size_t d = 0; d < A->dIndices.size(); ++d) {
        int idxA = A->dIndices[d];
        int bIdx = -1;
        for (size_t k = 0; k < B->dIndices.size(); ++k) {
            if (B->dIndices[k] == idxA) { bIdx = static_cast<int>(k); break; }
        }
        valType* realA = A->realData + A->diagOffsets[d];
        valType* imagA = A->imagData + A->diagOffsets[d];
        valType* realB = (bIdx != -1) ? (B->realData + B->diagOffsets[bIdx]) : nullptr;
        valType* imagB = (bIdx != -1) ? (B->imagData + B->diagOffsets[bIdx]) : nullptr;
        valType* realC = result->realData + result->diagOffsets[d];
        valType* imagC = result->imagData + result->diagOffsets[d];
        unsigned int len = A->getDiagonalLengthInternal(idxA);
        for (unsigned int i = 0; i < len; ++i) {
            realC[i] = realA[i] + (realB ? realB[i] : 0.0);
            imagC[i] = imagA[i] + (imagB ? imagB[i] : 0.0);
        }
    }
    return result;
}

std::shared_ptr<diaQMatrix> operator+(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B) {
    return add(A, B);
}

} // namespace diaq