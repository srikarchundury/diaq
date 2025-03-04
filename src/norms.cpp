#include "norms.hpp"

namespace diaq {

valType norm(const vector &x) {
    std::complex<valType> sum = 0;
    for (unsigned int i = 0; i < x.numRows; ++i) {
        sum += std::conj(x[i]) * x[i];
    }
    assert(sum.imag() == 0.0);
    return std::sqrt(sum.real());
}

} // namespace diaq