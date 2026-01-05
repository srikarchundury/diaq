#include "matrixKernels.hpp"

namespace diaq {
    //
    // C = A^n
    //
    // log(n) spGEMM operations using exponentiation by squaring!!!
    std::shared_ptr<diaQMatrix> pow(std::shared_ptr<diaQMatrix> A, int n) {
        if (n < 0) {
            throw std::runtime_error("pow: negative exponent not supported");
        }

        std::shared_ptr<diaQMatrix> result = std::make_shared<identityMatrix>(A->matrix_shape[0]);
        std::shared_ptr<diaQMatrix> base   = A->copy();   // keep input stable

        while (n > 0) {
            if (n & 1) {
                result = product(result, base);
            }
            n >>= 1;
            if (n) {
                base = product(base, base); // ok; product handles alias
            }
        }
        return result;
    }

} // namespace diaq
