#ifndef DIAQ_VECTORKERNELS_HPP
#define DIAQ_VECTORKERNELS_HPP

#include <algorithm>
#include <cassert>
#include <cmath>
#include <functional>
#include <random>
#include <omp.h>

#include "config.hpp"
#include "vector.hpp"
#include "diaQMatrix.hpp"
#include "diagonal.hpp"

namespace diaq {

void zeroize(vector &x);
void unitize(vector &x);
void randomize(vector &x, valType scale, valType mean);
valType one_norm(const vector &x);
valType two_norm(const vector &x);
valType inf_norm(const vector &x);
valType p_norm(const vector &x);
vector operator+(const vector &x, const vector &y);
vector operator-(const vector &x, const vector &y);
vector &operator*=(vector &x, valType alpha);
vector &operator+=(vector &x, std::complex<valType> alpha);
vector &operator+=(vector &x, const vector &y);
vector &operator-=(const vector &x, const vector &y);

} // namespace diaq

#endif // DIAQ_VECTORKERNELS_HPP