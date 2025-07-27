#ifndef DIAQ_HELPERS_HPP
#define DIAQ_HELPERS_HPP

#include <memory>
#include <string>
#include "diaQMatrix.hpp"

namespace diaq {

/**
 * @brief Compare two diaQMatrix objects for structural and numerical equality.
 *
 * @param A First matrix
 * @param B Second matrix
 * @return std::string "true" if equal, or explanation string if not
 */
std::string compare(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B);

} // namespace diaq

#endif // DIAQ_HELPERS_HPP
