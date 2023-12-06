#ifndef DIAQ_VECTOR_HPP
#define DIAQ_VECTOR_HPP

#include <iostream>
#include <vector>
#include <complex>

class vector {
    public:
        vector(size_t M) {
            numRows_ = M;
            realValues_ = (double *)calloc(M, sizeof(float));
            imagValues_ = (double *)calloc(M, sizeof(float));
        }
        vector(size_t M, double *realVals, double *imagVals) {
            numRows_ = M;
            realValues_ = realVals;
            imagValues_ = imagVals;
        }
        vector(size_t M, double init_real, double init_imag) {
            numRows_ = M;
            realValues_ = (double *)calloc(M, sizeof(float));
            imagValues_ = (double *)calloc(M, sizeof(float));
            for (size_t i = 0; i < M; ++i) {
                realValues_[i] = init_real;
                imagValues_[i] = init_imag;
            }
        }
        vector(size_t M, double init_real) {
            numRows_ = M;
            realValues_ = (double *)calloc(M, sizeof(float));
            imagValues_ = (double *)calloc(M, sizeof(float));
            for (size_t i = 0; i < M; ++i) {
                realValues_[i] = init_real;
                imagValues_[i] = 0.0;
            }
        }

        std::complex<float> operator[](size_t i) {
            return std::complex<float>(realValues_[i], imagValues_[i]);
        }

        const std::complex<float> operator[](size_t i) const {
            return std::complex<float>(realValues_[i], imagValues_[i]);
        }

        size_t num_rows() const {
            return numRows_;
        }

        void print() {
            std::cout << "length (" << numRows_ << ") [";
            for (size_t i = 0; i < numRows_ - 1; ++i) {
                std::cout << "(" << realValues_[i] << ",";
                std::cout << imagValues_[i] << "), ";
            }
            std::cout << "(" << realValues_[numRows_ - 1] << ",";
            std::cout << imagValues_[numRows_ - 1] << ")]" << std::endl;
        }

        double *getRealValues() {
            return realValues_;
        }

        double *getImagValues() {
            return imagValues_;
        }

    private:
        size_t numRows_;
        double* realValues_;
        double* imagValues_;
};

#endif // DIAQ_VECTOR_HPP