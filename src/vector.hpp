#ifndef DIAQ_VECTOR_HPP
#define DIAQ_VECTOR_HPP

#include <iostream>
#include <vector>
#include <complex>

#include "config.hpp"

namespace diaq {

class vector {
    public:
        vector(size_t M) {
            numRows_ = M;
            realValues_ = (valType *)calloc(M, sizeof(valType));
            imagValues_ = (valType *)calloc(M, sizeof(valType));
        }
        vector(size_t M, valType *realVals, valType *imagVals) {
            numRows_ = M;
            realValues_ = realVals;
            imagValues_ = imagVals;
        }
        vector(size_t M, valType *realVals) {
            numRows_ = M;
            realValues_ = realVals;
            imagValues_ = (valType *)calloc(M, sizeof(valType));
        }
        vector(size_t M, valType init_real, valType init_imag) {
            numRows_ = M;
            realValues_ = (valType *)calloc(M, sizeof(valType));
            imagValues_ = (valType *)calloc(M, sizeof(valType));
            for (size_t i = 0; i < M; ++i) {
                realValues_[i] = init_real;
                imagValues_[i] = init_imag;
            }
        }
        vector(size_t M, valType init_real) {
            numRows_ = M;
            realValues_ = (valType *)calloc(M, sizeof(valType));
            imagValues_ = (valType *)calloc(M, sizeof(valType));
            for (size_t i = 0; i < M; ++i) {
                realValues_[i] = init_real;
                imagValues_[i] = 0.0;
            }
        }

        std::complex<valType> operator[](size_t i) {
            return std::complex<valType>(realValues_[i], imagValues_[i]);
        }

        const std::complex<valType> operator[](size_t i) const {
            return std::complex<valType>(realValues_[i], imagValues_[i]);
        }

        size_t num_rows() const {
            return numRows_;
        }

        void print() {
            std::cout << "length (" << numRows_ << ") [";
            for (size_t i = 0; i < numRows_ - 1; ++i) {
                printf("(%lf,%lf), ", realValues_[i], imagValues_[i]);
            }
            printf("(%lf,%lf)]\n", realValues_[numRows_ - 1], imagValues_[numRows_ - 1]);
        }

        valType *getRealValues() {
            return realValues_;
        }

        valType *getImagValues() {
            return imagValues_;
        }

    private:
        size_t numRows_;
        valType* realValues_;
        valType* imagValues_;
};

} // namespace diaq

#endif // DIAQ_VECTOR_HPP