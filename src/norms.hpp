#ifndef DIAQ_NORMS_HPP
#define DIAQ_NORMS_HPP

#include <cmath>
#include <iostream>
#include <complex>
#include <cassert>

#include "vector.hpp"
#include "denseMatrix.hpp"
#include "kernels.hpp"

namespace diaq {

valType norm(const vector &x);

} // namespace diaq

#endif // DIAQ_NORMS_HPP