#include "matrixKernels_gpu.hpp"

namespace diaq {
    // C = A^n on GPU
    //
    // log(n) spGEMM operations using exponentiation by squaring!!!
    std::shared_ptr<diaQMatrix> pow_cuda(std::shared_ptr<diaQMatrix> A, int n) {
        if (n == 0) {
            return std::make_shared<identityMatrix>(A->matrix_shape[0]);
        }
        if (n == 1) {
            return A;
        }
        if (n % 2 == 0) {
            std::shared_ptr<diaQMatrix> half = pow_cuda(A, n / 2);
            return product_cuda(half, half);
        } else {
            std::shared_ptr<diaQMatrix> half = pow_cuda(A, n / 2);
            return product_cuda(product_cuda(half, half), A);
        }
    }

} // namespace diaq
