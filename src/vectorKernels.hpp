#ifndef DIAQ_VECTORKERNELS_HPP
#define DIAQ_VECTORKERNELS_HPP

#include <algorithm>
#include <cassert>
#include <cmath>
#include <functional>
#include <random>
#include <omp.h>

#include "vector.hpp"
#include "diaQMatrix.hpp"
#include "diagonal.hpp"

void zeroize(vector &x);
void unitize(vector &x);
void randomize(vector &x, float scale, float mean);
float one_norm(const vector &x);
float two_norm(const vector &x);
float inf_norm(const vector &x);
float p_norm(const vector &x);
vector operator+(const vector &x, const vector &y);
vector operator-(const vector &x, const vector &y);
vector &operator*=(vector &x, float alpha);
vector &operator+=(vector &x, std::complex<float> alpha);
vector &operator+=(vector &x, const vector &y);
vector &operator-=(const vector &x, const vector &y);

#endif // DIAQ_VECTORKERNELS_HPP