#ifndef DIAQ_CONVERSIONS_HPP
#define DIAQ_CONVERSIONS_HPP

#include "denseMatrix.hpp"
#include "config.hpp"
#include "diaQMatrix.hpp"
#include "vector.hpp"

namespace diaq {

// All conversion functions now use the new diaQMatrix storage layout (realData, imagData, diagOffsets, dIndices)
std::vector<std::complex<valType>> to_numpy(std::shared_ptr<diaQMatrix> A);
std::shared_ptr<diaQMatrix> from_numpy(std::complex<valType> *vals, std::vector<unsigned int> shape);

std::vector<std::complex<valType>> to_numpy_vector(std::shared_ptr<vector> v);
std::shared_ptr<vector> from_numpy_vector(std::complex<valType> *vals, unsigned int M);

} // namespace diaq

#endif // DIAQ_CONVERSIONS_HPP