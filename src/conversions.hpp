#ifndef DIAQ_CONVERSIONS_HPP
#define DIAQ_CONVERSIONS_HPP

#include <omp.h>

#include "denseMatrix.hpp"
#include "config.hpp"
#include "diaQMatrix.hpp"
#include "vector.hpp"

namespace diaq {

std::complex<valType> *to_numpy(diaQMatrix *A);
diaQMatrix *from_numpy(std::complex<valType> *vals, std::vector<long int> shape);

std::complex<valType> *to_numpy_vector(vector *v);
vector *from_numpy_vector(std::complex<valType> *vals, size_t M);

} // namespace diaq

#endif // DIAQ_CONVERSIONS_HPP