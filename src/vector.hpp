#ifndef DIAQ_VECTOR_HPP
#define DIAQ_VECTOR_HPP

#include <iostream>
#include <vector>
#include <complex>

#include "config.hpp"

namespace diaq {

class vector {
    public:
        size_t numRows_;
        valType* realValues_;
        valType* imagValues_;

        vector(size_t M) {
            numRows_ = M;
            #if NUM_BYTES_ALIGNED == -1
                realValues_ = (valType *)calloc(M, sizeof(valType));
                imagValues_ = (valType *)calloc(M, sizeof(valType));
                // realValues_ = (valType *)malloc(M * sizeof(valType));
                // imagValues_ = (valType *)malloc(M * sizeof(valType));
                // #pragma omp parallel for
                // for(size_t i = 0; i < M; i++) {
                //     realValues_[i] = 0.0;
                //     imagValues_[i] = 0.0;
                // }
            #else
                // printf("comes here only?\n");
                realValues_ = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, M * sizeof(valType));
                imagValues_ = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, M * sizeof(valType));
                #pragma omp parallel for
                for(size_t i = 0; i < M; i++) {
                    realValues_[i] = 0.0;
                    imagValues_[i] = 0.0;
                }
            #endif
        }
        vector(size_t M, valType *realVals, valType *imagVals) {
            numRows_ = M;
            realValues_ = realVals;
            imagValues_ = imagVals;
        }
        vector(size_t M, valType *realVals) {
            numRows_ = M;
            realValues_ = realVals;
            #if NUM_BYTES_ALIGNED == -1
                imagValues_ = (valType *)calloc(M, sizeof(valType));
            #else
                imagValues_ = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, M * sizeof(valType));
            #endif
        }
        vector(size_t M, valType init_real, valType init_imag) {
            numRows_ = M;
            #if NUM_BYTES_ALIGNED == -1
                realValues_ = (valType *)calloc(M, sizeof(valType));
                imagValues_ = (valType *)calloc(M, sizeof(valType));
                for (size_t i = 0; i < M; ++i) {
                    realValues_[i] = init_real;
                    imagValues_[i] = init_imag;
                }
            #else
                realValues_ = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, M * sizeof(valType));
                imagValues_ = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, M * sizeof(valType));
                #pragma omp parallel for
                for(size_t i = 0; i < M; i++) {
                    realValues_[i] = init_real;
                    imagValues_[i] = init_imag;
                }
            #endif
        }
        vector(size_t M, valType init_real) {
            numRows_ = M;
            #if NUM_BYTES_ALIGNED == -1
                realValues_ = (valType *)calloc(M, sizeof(valType));
                imagValues_ = (valType *)calloc(M, sizeof(valType));
            #else
                realValues_ = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, M * sizeof(valType));
                imagValues_ = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, M * sizeof(valType));
            #endif
            for (size_t i = 0; i < M; ++i) {
                realValues_[i] = init_real;
                imagValues_[i] = 0.0;
            }
        }

        ~vector() {
            this->free();
        }

        void zeroify() {
            #pragma omp parallel for
            for(size_t i = 0; i < numRows_; i++) {
                realValues_[i] = 0.0;
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

        void setValue(size_t i, valType real, valType imag) {
            realValues_[i] = real;
            imagValues_[i] = imag;
        }

        std::vector<std::complex<valType> > getArray() {
            std::vector<std::complex<valType> > v;
            for (size_t i = 0; i < numRows_; ++i) {
                v.push_back(std::complex<valType>(realValues_[i], imagValues_[i]));
            }
            return v;
        }

        vector *dagger() {
            vector *v = new vector(numRows_);
            valType *realValues = v->getRealValues();
            valType *imagValues = v->getImagValues();

            #pragma omp parallel for
            for (size_t i = 0; i < numRows_; ++i) {
                realValues[i] = realValues_[i];
                imagValues[i] = -1 * imagValues_[i];
            }
            return v;
        }

        std::complex<valType> multiply(vector *v) {
            valType real_res = 0.0;
            valType imag_res = 0.0;
            valType *realValues = v->getRealValues();
            valType *imagValues = v->getImagValues();

            #pragma omp parallel for reduction(+:real_res,imag_res)
            for (size_t i = 0; i < numRows_; ++i) {
                real_res += realValues_[i] * realValues[i] - imagValues_[i] * imagValues[i];
                imag_res += realValues_[i] * imagValues[i] + imagValues_[i] * realValues[i];
            }
            return std::complex<valType>(real_res, imag_res);
        }

        valType daggerMultiplyReal(vector *v) {
            valType real_res = 0.0;
            valType *realValues = v->realValues_;
            valType *imagValues = v->imagValues_;

            #pragma omp parallel for reduction(+:real_res)
            for (size_t i = 0; i < numRows_; ++i) {
                // Take the conjugate of this vector in place
                valType real_conj = realValues_[i];
                valType imag_conj = -imagValues_[i];

                // Multiply with the corresponding elements of vector `v`
                real_res += real_conj * realValues[i] - imag_conj * imagValues[i];
            }

            return real_res;
        }

        void print() {
            std::cout << "length (" << numRows_ << ") [";
            for (size_t i = 0; i < numRows_ - 1; ++i) {
                printf("(%lf,%lf), ", realValues_[i], imagValues_[i]);
            }
            printf("(%lf,%lf)]\n", realValues_[numRows_ - 1], imagValues_[numRows_ - 1]);
        }

        void print_meta() {
            std::cout << "length (" << numRows_ << ")" << std::endl;
            std::cout << "sparsity = " << sparsity() << std::endl;
        }

        valType sparsity() {
            long int num_nonzeros = 0;
            for (size_t i = 0; i < numRows_; ++i) {
                if(realValues_[i] != 0.0 || imagValues_[i] != 0.0) {
                    num_nonzeros++;
                }
            }
            return (valType)1.0 - ((valType)num_nonzeros / (valType)numRows_);
        }

        valType *getRealValues() {
            return realValues_;
        }

        valType **getRealValuePtr() {
            return &realValues_;
        }
        valType **getImagValuePtr() {
            return &imagValues_;
        }

        valType *getImagValues() {
            return imagValues_;
        }
        void free() {
            std::free(realValues_);
            std::free(imagValues_);
        }
};

} // namespace diaq

#endif // DIAQ_VECTOR_HPP