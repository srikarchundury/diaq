// implement all functions here
// UPDATE: Implement Kernels in include/kernels.hpp

#include "Vector.hpp"
#include "kernels.hpp"
#include <algorithm>
#include <cassert>
#include <cmath>
#include <functional>
#include <random>
#include <omp.h>

// ----------------------------------------------------------------
//
// Vector arithmetic
//
// ----------------------------------------------------------------

/**
 * @brief Set all elements of a given (complex) Vector to 0+0i
 * 
 * @param x the vector to be set to zero
 */
void zeroize(Vector &x)
{
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        x[i] = 0.0;
    }
}

/**
 * @brief Set all elements of a given (complex) Vector to 1+0i
 *
 * @param x
 */
void unitize(Vector &x)
{
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        x[i] = 1.0;
    }
}

/**
 * @brief Randomize the entries of a given vector
 * 
 * @param x         Vector to be randomized
 * @param scale     spread of uniform distribution to randomize over
 * @param mean      mean of the uniform distribution to randomize over
 */
void randomize(Vector &x, double scale, double mean)
{
    std::default_random_engine generator;
    std::uniform_real_distribution<double> distribution(mean - scale, mean + scale);
    static auto dice = std::bind(distribution, generator);

    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        x[i] = std::complex(dice(),dice());
    }
}

/**
 * @brief Calculate the 1 norm of a vector: by summing the abs() of each entry.
 * 
 * @param x  the vector
 * @return double the 1 norm
 */
double one_norm(const Vector &x)
{
    double sum = 0.0;
    #pragma omp parallel for reduction(+ \
                                   : sum)
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        sum += std::abs(x[i]);
    }
    return sum;
}

/**
 * @brief  Calculate the 2 norm of a vector: by taking the square root of the sums of the norm() of each entry
 * 
 * @param x         The Vector
 * @return double   The norm
 */
double two_norm(const Vector &x)
{
    double sum = 0.0;
    #pragma omp parallel for reduction(+ \
                                   : sum)
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        sum += std::norm(x[i]);
    }
    return std::sqrt(sum);
}

/**
 * @brief Calculate infinity (max) norm
 * 
 * @param x         Vector
 * @return double   Result
 */
double inf_norm(const Vector &x)
{
        double result = std::abs(x[0]);
        for (size_t i = 1; i < x.num_rows(); ++i)
        {
            if (std::abs(x[i]) > result)
            {
                result = std::abs(x[i]);
            }
        }
        return result;
}

double p_norm(const Vector &x);

Vector operator+(const Vector &x, const Vector &y);

Vector operator-(const Vector &x, const Vector &y)
{
    Vector z(x.num_rows());
    #pragma omp parallel for
    for (size_t i = 0; i < z.num_rows(); ++i)
    {
        z[i] = x[i] - y[i];
    }
    return z;
}

Vector &operator*=(Vector &x, double alpha)
{

    #pragma omp parallel for
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        x[i] *= alpha;
    }
    return x;
}

Vector &operator+=(Vector &x, std::complex<double> alpha)
{
    #pragma omp parallel for
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        x[i] += alpha;
    }
    return x;
}

Vector &operator+=(Vector &x, const Vector &y)
{
    assert(x.num_rows() == y.num_rows());
    #pragma omp parallel for
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        x[i] += y[i];
    }
    return x;
}
Vector &operator-=(const Vector &x, const Vector &y);