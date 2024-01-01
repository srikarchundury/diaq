#ifndef DIAQ_NORMS_HPP
#define DIAQ_NORMS_HPP

#include <cmath>
#include <iostream>
#include <complex>
#include <cassert>

#include "vector.hpp"

// TODO: change to .hpp and move to include/
#include "denseMatrix.hpp"
#include "kernels.hpp"

valType norm(const vector &x);

#endif // DIAQ_NORMS_HPP