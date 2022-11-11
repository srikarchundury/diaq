#ifndef SPARSE_TNQS_KERNELS_HPP
#define SPARSE_TNQS_KERNELS_HPP

#include "Vector.hpp"
#include "matrixKernels.cpp"

// ----------------------------------------------------------------
//
// Vector arithmetic
//
// ----------------------------------------------------------------

void zeroize(Vector &x);
void unitize(Vector &x);
void randomize(Vector &x, double scale = 1.0, double mean = 0.0);

double one_norm(const Vector &x);
double two_norm(const Vector &x);
double inf_norm(const Vector &x);
double p_norm(const Vector &x);

Vector operator+(const Vector &x, const Vector &y);
Vector operator-(const Vector &x, const Vector &y);

Vector &operator*=(Vector &x, double alpha);
Vector &operator+=(Vector &x, double alpha);
Vector &operator+=(Vector &x, const Vector &y);
Vector &operator-=(Vector &x, const Vector &y);


// ----------------------------------------------------------------
//
// Matrix Matrix kernels
//
// ----------------------------------------------------------------

// quantumSparseMatrix product(quantumSparseMatrix A, quantumSparseMatrix B);


#endif // SPARSE_TNQS_KERNELS_HPP