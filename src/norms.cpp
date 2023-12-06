#include "norms.hpp"

double norm(const vector &x) {
    std::complex<float> sum = 0;
    for (size_t i = 0; i < x.num_rows(); ++i) {
        sum += std::conj(x[i]) * x[i];
    }
    assert(sum.imag() == 0.0);
    return std::sqrt(sum.real());
}