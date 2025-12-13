#include "matrixKernels.hpp"

namespace diaq {
    //
    // C = A^n
    //
    // log(n) spGEMM operations using exponentiation by squaring!!!
    std::shared_ptr<diaQMatrix> pow(std::shared_ptr<diaQMatrix> A, int n) {
        if (n == 0) {
            return std::make_shared<identityMatrix>(A->matrix_shape[0]);
        }
        if (n == 1) {
            return A;
        }
        if (n % 2 == 0) {
            std::shared_ptr<diaQMatrix> half = pow(A, n / 2);
            return product(half, half);
        } else {
            std::shared_ptr<diaQMatrix> half = pow(A, n / 2);
            return product(product(half, half), A);
        }
    }

} // namespace diaq
