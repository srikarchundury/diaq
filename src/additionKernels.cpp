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
    // A + B straight into a new matrix (this copied A first, then built the sum in a second new matrix)
    return diaQMatrix::combined(*A, *B, 1.0);
}

std::shared_ptr<diaQMatrix> operator+(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B) {
    return add(A, B);
}

} // namespace diaq