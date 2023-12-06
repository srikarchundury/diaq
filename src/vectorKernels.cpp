#include "vectorKernels.hpp"
// ----------------------------------------------------------------
//
// vector arithmetic
//
// ----------------------------------------------------------------

/**
 * @brief Set all elements of a given (complex) vector to 0+0i
 * 
 * @param x the vector to be set to zero
 */
void zeroize(vector &x) {
    for (size_t i = 0; i < x.num_rows(); ++i) {
        x[i] = 0.0;
    }
}

/**
 * @brief Set all elements of a given (complex) vector to 1+0i
 *
 * @param x
 */
void unitize(vector &x) {
    for (size_t i = 0; i < x.num_rows(); ++i) {
        x[i] = 1.0;
    }
}

/**
 * @brief Randomize the entries of a given vector
 * 
 * @param x         vector to be randomized
 * @param scale     spread of uniform distribution to randomize over
 * @param mean      mean of the uniform distribution to randomize over
 */
void randomize(vector &x, float scale, float mean) {
    std::default_random_engine generator;
    std::uniform_real_distribution<float> distribution(mean - scale, mean + scale);
    static auto dice = std::bind(distribution, generator);
    for (size_t i = 0; i < x.num_rows(); ++i) {
        x[i] = std::complex(dice(),dice());
    }
}

/**
 * @brief Calculate the 1 norm of a vector: by summing the abs() of each entry.
 * 
 * @param x  the vector
 * @return float the 1 norm
 */
float one_norm(const vector &x) {
    float sum = 0.0;
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
 * @param x         The vector
 * @return float   The norm
 */
float two_norm(const vector &x) {
    float sum = 0.0;
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
 * @param x         vector
 * @return float   Result
 */
float inf_norm(const vector &x) {
        float result = std::abs(x[0]);
        for (size_t i = 1; i < x.num_rows(); ++i)
        {
            if (std::abs(x[i]) > result)
            {
                result = std::abs(x[i]);
            }
        }
        return result;
}

float p_norm(const vector &x);

vector operator+(const vector &x, const vector &y);

vector operator-(const vector &x, const vector &y)
{
    vector z(x.num_rows());
    #pragma omp parallel for
    for (size_t i = 0; i < z.num_rows(); ++i)
    {
        z[i] = x[i] - y[i];
    }
    return z;
}

vector &operator*=(vector &x, float alpha) {
    #pragma omp parallel for
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        x[i] *= alpha;
    }
    return x;
}

vector &operator+=(vector &x, std::complex<float> alpha) {
    #pragma omp parallel for
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        x[i] += alpha;
    }
    return x;
}

vector &operator+=(vector &x, const vector &y) {
    assert(x.num_rows() == y.num_rows());
    #pragma omp parallel for
    for (size_t i = 0; i < x.num_rows(); ++i)
    {
        x[i] += y[i];
    }
    return x;
}
vector &operator-=(const vector &x, const vector &y);