#ifndef SPARSE_TNQS_NORMS_HPP
#define SPARSE_TNQS_NORMS_HPP

#include <cmath>
#include <iostream>
#include <complex>
#include <cassert>

#include "Vector.hpp"

// TODO: change to .hpp and move to include/
#include "denseMatrix.hpp"
#include "kernels.hpp"


double norm(const Vector &x)
{
    std::complex<double> sum = 0;

    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        sum += std::conj(x[i]) * x[i];
    }
    assert(sum.imag() == 0.0);
    return std::sqrt(sum.real());
}

#endif // SPARSE_TNQS_NORMS_HPP