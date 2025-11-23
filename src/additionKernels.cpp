#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

/**
* @brief adds two diaQMatrix matrices (C = A + B)
* @param A diaQMatrix
* @param B diaQMatrix
* @return diaQMatrix C
*/
std::shared_ptr<diagonal> addElements(std::shared_ptr<diagonal> A, std::shared_ptr<diagonal> B) {
    valType *real_valsA = A->realValues;
    valType *imag_valsA = A->imagValues;
    valType *real_valsB = B->realValues;
    valType *imag_valsB = B->imagValues;
    if(A->dLength != B->dLength ) {
        throw std::invalid_argument("diagonals are of different lengths!");
    }
    // std::shared_ptr<diagonal> res = new diagonal(A->dIndex, A->dLength);
    std::shared_ptr<diagonal> res = std::make_shared<diagonal>(A->dIndex, A->dLength);
    valType *real_valsC = res->realValues;
    valType *imag_valsC = res->imagValues;
    #pragma omp parallel for
    for(unsigned int i=0; i < A->dLength; i++) {
        real_valsC[i] = real_valsA[i] + real_valsB[i];
        imag_valsC[i] = imag_valsA[i] + imag_valsB[i];
    }
    return res;
}

std::shared_ptr<diaQMatrix> add(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
    // check for out of bounds
    if(A->matrix_shape[0] != B->matrix_shape[0] || A->matrix_shape[1] != B->matrix_shape[1]) {
        throw std::invalid_argument("input matrices are not addable");
    }
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(A->matrix_shape[0] * A->matrix_shape[1]);
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > mapA = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > mapB = B->diagonalMap;
    #pragma omp parallel for
    for(unsigned int a = 0; a < mapA.size(); a++) {
        auto itA = std::next(mapA.begin(), a);
        auto itB = mapB.find(itA->first);
        if (itB == mapB.end()) {
            result->addDiagonal(itA->first, itA->second);
        } else {
            result->addDiagonal(itA->first, addElements(itA->second, itB->second));
        }
    }
    // result->pruneMatrix();
    return result;
}

std::shared_ptr<diaQMatrix> operator+(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B) {
    return add(A, B);
}

} // namespace diaq