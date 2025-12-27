#ifndef DIAQ_VECTORKERNELS_HPP
#define DIAQ_VECTORKERNELS_HPP

#include "config.hpp"
#include "vector.hpp"
#include "diaQMatrix.hpp"
#include "diagonal.hpp"

namespace diaq {

std::shared_ptr<diaQMatrix> outerProduct(std::shared_ptr<vector> v1, std::shared_ptr<vector> v2);
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