#ifndef DIAQ_CONVERSIONS_HPP
#define DIAQ_CONVERSIONS_HPP

#include <omp.h>


#include "denseMatrix.hpp"
#include "config.hpp"
#include "diaQMatrix.hpp"

namespace diaq {

std::vector<std::complex<valType> > to_numpy(diaQMatrix A);
diaQMatrix from_numpy(std::vector<std::complex<valType>> vals, std::vector<long int> shape);

} // namespace diaq

#endif // DIAQ_CONVERSIONS_HPP