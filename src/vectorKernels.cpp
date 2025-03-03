#include "vectorKernels.hpp"
// ----------------------------------------------------------------
//
// vector arithmetic
//
// ----------------------------------------------------------------

namespace diaq {

/**
 * @brief Set all elements of a given (complex) vector to 0+0i
 * 
 * @param x the vector to be set to zero
 */
void zeroize(std::shared_ptr<vector> x) {
    for (size_t i = 0; i < x->numRows; ++i) {
        (*x)[i] = 0.0;
    }
}

/**
 * @brief Set all elements of a given (complex) vector to 1+0i
 *
 * @param x
 */
void unitize(std::shared_ptr<vector> x) {
    for (size_t i = 0; i < x->numRows; ++i) {
        (*x)[i] = 1.0;
    }
}

/**
 * @brief Randomize the entries of a given vector
 * 
 * @param x         vector to be randomized
 * @param scale     spread of uniform distribution to randomize over
 * @param mean      mean of the uniform distribution to randomize over
 */
void randomize(std::shared_ptr<vector> x, valType scale, valType mean) {
    std::default_random_engine generator;
    std::uniform_real_distribution<valType> distribution(mean - scale, mean + scale);
    static auto dice = std::bind(distribution, generator);
    for (size_t i = 0; i < x->numRows; ++i) {
        (*x)[i] = std::complex(dice(),dice());
    }
}

/**
 * @brief Calculate the 1 norm of a vector: by summing the abs() of each entry.
 * 
 * @param x  the vector
 * @return valType the 1 norm
 */
valType one_norm(const std::shared_ptr<vector> x) {
    valType sum = 0.0;
    #pragma omp parallel for reduction(+ \
                                   : sum)
    for (size_t i = 0; i < x->numRows; ++i)
    {
        sum += std::abs((*x)[i]);
    }
    return sum;
}

/**
 * @brief  Calculate the 2 norm of a vector: by taking the square root of the sums of the norm() of each entry
 * 
 * @param x         The vector
 * @return valType   The norm
 */
valType two_norm(const std::shared_ptr<vector> x) {
    valType sum = 0.0;
    #pragma omp parallel for reduction(+ \
                                   : sum)
    for (size_t i = 0; i < x->numRows; ++i)
    {
        sum += std::norm((*x)[i]);
    }
    return std::sqrt(sum);
}

/**
 * @brief Calculate infinity (max) norm
 * 
 * @param x         vector
 * @return valType   Result
 */
valType inf_norm(const std::shared_ptr<vector> x) {
        valType result = std::abs((*x)[0]);
        for (size_t i = 1; i < x->numRows; ++i)
        {
            if (std::abs((*x)[i]) > result)
            {
                result = std::abs((*x)[i]);
            }
        }
        return result;
}

valType p_norm(const std::shared_ptr<vector> x);

std::shared_ptr<vector> operator+(const std::shared_ptr<vector> x, const std::shared_ptr<vector> y);

std::shared_ptr<vector> operator-(const std::shared_ptr<vector> &x, const std::shared_ptr<vector> &y)
{
    assert(x->numRows == y->numRows);
    auto z = std::make_shared<vector>(x->numRows);
    #pragma omp parallel for
    for (size_t i = 0; i < z->numRows; ++i)
    {
        (*z)[i] = (*x)[i] - (*y)[i];
    }
    return z;
}

std::shared_ptr<vector> &operator*=(std::shared_ptr<vector> &x, valType alpha) {
    #pragma omp parallel for
    for (size_t i = 0; i < x->numRows; ++i)
    {
        (*x)[i] *= alpha;
    }
    return x;
}

std::shared_ptr<vector> &operator+=(std::shared_ptr<vector> &x, std::complex<valType> alpha) {
    #pragma omp parallel for
    for (size_t i = 0; i < x->numRows; ++i)
    {
        (*x)[i] += alpha;
    }
    return x;
}

std::shared_ptr<vector> &operator+=(std::shared_ptr<vector> &x, const std::shared_ptr<vector> y) {
    assert(x->numRows == y->numRows);
    #pragma omp parallel for
    for (size_t i = 0; i < x->numRows; ++i)
    {
        (*x)[i] += (*y)[i];
    }
    return x;
}
std::shared_ptr<vector> &operator-=(const std::shared_ptr<vector> x, const std::shared_ptr<vector> y);

} // namespace diaq