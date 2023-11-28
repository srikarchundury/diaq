#ifndef DIAQ_VECTOR_HPP
#define DIAQ_VECTOR_HPP

#include <iostream>
#include <vector>
#include <complex>

class vector {
    public:
        vector(size_t M) {
            numRows_ = M;
            realValues_ = (float *)calloc(M, sizeof(float));
            imagValues_ = (float *)calloc(M, sizeof(float));
        }
        vector(size_t M, float *realVals, float *imagVals) {
            numRows_ = M;
            realValues_ = realVals;
            imagValues_ = imagVals;
        }
        vector(size_t M, float init_real, float init_imag) {
            numRows_ = M;
            realValues_ = (float *)calloc(M, sizeof(float));
            imagValues_ = (float *)calloc(M, sizeof(float));
            for (size_t i = 0; i < M; ++i) {
                realValues_[i] = init_real;
                imagValues_[i] = init_imag;
            }
        }
        vector(size_t M, float init_real) {
            numRows_ = M;
            realValues_ = (float *)calloc(M, sizeof(float));
            imagValues_ = (float *)calloc(M, sizeof(float));
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

        float *getRealValues() {
            return realValues_;
        }

        float *getImagValues() {
            return imagValues_;
        }

    private:
        size_t numRows_;
        float* realValues_;
        float* imagValues_;
};

#endif // DIAQ_VECTOR_HPP