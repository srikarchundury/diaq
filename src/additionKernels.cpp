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
    // Delegate to the in-place member add, which handles union-of-diagonals,
    // OpenMP parallelism, and cache-blocked inner loops.
    auto result = A->copy();
    result->add(B);
    return result;
}

std::shared_ptr<diaQMatrix> operator+(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B) {
    return add(A, B);
}

} // namespace diaq