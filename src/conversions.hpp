#ifndef DIAQ_CONVERSIONS_HPP
#define DIAQ_CONVERSIONS_HPP

#include "denseMatrix.hpp"
#include "config.hpp"
#include "diaQMatrix.hpp"
#include <omp.h>

std::vector<std::complex<valType> > to_numpy(diaQMatrix A);
diaQMatrix from_numpy(std::vector<std::complex<valType>> vals, std::vector<long int> shape);

#endif // DIAQ_CONVERSIONS_HPP