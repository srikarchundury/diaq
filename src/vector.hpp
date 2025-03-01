#ifndef DIAQ_VECTOR_HPP
#define DIAQ_VECTOR_HPP

#include <iostream>
#include <vector>
#include <complex>

#include "config.hpp"

namespace diaq {

class vector {
    public:
        size_t numRows;
        valType* realValues;
        valType* imagValues;

        vector(size_t M) {
            numRows = M;
            #if NUM_BYTES_ALIGNED == -1
                realValues = (valType *)calloc(M, sizeof(valType));
                imagValues = (valType *)calloc(M, sizeof(valType));
                // realValues = (valType *)malloc(M * sizeof(valType));
                // imagValues = (valType *)malloc(M * sizeof(valType));
                // #pragma omp parallel for
                // for(size_t i = 0; i < M; i++) {
                //     realValues[i] = 0.0;
                //     imagValues[i] = 0.0;
                // }
            #else
                // printf("comes here only?\n");
                realValues = aligned_alloc_helper(M * sizeof(valType));
                imagValues = aligned_alloc_helper(M * sizeof(valType));
                #pragma omp parallel for
                for(size_t i = 0; i < M; i++) {
                    realValues[i] = 0.0;
                    imagValues[i] = 0.0;
                }
            #endif
        }
        vector(size_t M, valType *realVals, valType *imagVals) {
            numRows = M;
            realValues = realVals;
            imagValues = imagVals;
        }
        vector(size_t M, valType *realVals) {
            numRows = M;
            realValues = realVals;
            #if NUM_BYTES_ALIGNED == -1
                imagValues = (valType *)calloc(M, sizeof(valType));
            #else
                imagValues = aligned_alloc_helper(M * sizeof(valType));
            #endif
        }
        vector(size_t M, valType init_real, valType init_imag) {
            numRows = M;
            #if NUM_BYTES_ALIGNED == -1
                realValues = (valType *)calloc(M, sizeof(valType));
                imagValues = (valType *)calloc(M, sizeof(valType));
                for (size_t i = 0; i < M; ++i) {
                    realValues[i] = init_real;
                    imagValues[i] = init_imag;
                }
            #else
                realValues = aligned_alloc_helper(M * sizeof(valType));
                imagValues = aligned_alloc_helper(M * sizeof(valType));
                #pragma omp parallel for
                for(size_t i = 0; i < M; i++) {
                    realValues[i] = init_real;
                    imagValues[i] = init_imag;
                }
            #endif
        }
        vector(size_t M, valType init_real) {
            numRows = M;
            #if NUM_BYTES_ALIGNED == -1
                realValues = (valType *)calloc(M, sizeof(valType));
                imagValues = (valType *)calloc(M, sizeof(valType));
            #else
                realValues = aligned_alloc_helper(M * sizeof(valType));
                imagValues = aligned_alloc_helper(M * sizeof(valType));
            #endif
            for (size_t i = 0; i < M; ++i) {
                realValues[i] = init_real;
                imagValues[i] = 0.0;
            }
        }

        ~vector() {
            this->free();
        }

        void zeroify() {
            #pragma omp parallel for
            for(size_t i = 0; i < numRows; i++) {
                realValues[i] = 0.0;
                imagValues[i] = 0.0;
            }
        }

        std::complex<valType> operator[](size_t i) {
            return std::complex<valType>(realValues[i], imagValues[i]);
        }

        const std::complex<valType> operator[](size_t i) const {
            return std::complex<valType>(realValues[i], imagValues[i]);
        }

        size_t num_rows() const {
            return numRows;
        }

        void setValue(size_t i, valType real, valType imag) {
            realValues[i] = real;
            imagValues[i] = imag;
        }

        std::vector<std::complex<valType> > getArray() {
            std::vector<std::complex<valType> > v;
            for (size_t i = 0; i < numRows; ++i) {
                v.push_back(std::complex<valType>(realValues[i], imagValues[i]));
            }
            return v;
        }

        vector *dagger() {
            vector *v = new vector(numRows);
            valType *realValues = v->realValues;
            valType *imagValues = v->imagValues;

            #pragma omp parallel for
            for (size_t i = 0; i < numRows; ++i) {
                realValues[i] = realValues[i];
                imagValues[i] = -1 * imagValues[i];
            }
            return v;
        }

        std::complex<valType> multiply(vector *v) {
            valType real_res = 0.0;
            valType imag_res = 0.0;
            valType *realValues = v->realValues;
            valType *imagValues = v->imagValues;

            #pragma omp parallel for reduction(+:real_res,imag_res)
            for (size_t i = 0; i < numRows; ++i) {
                real_res += realValues[i] * realValues[i] - imagValues[i] * imagValues[i];
                imag_res += realValues[i] * imagValues[i] + imagValues[i] * realValues[i];
            }
            return std::complex<valType>(real_res, imag_res);
        }

        valType daggerMultiplyReal(vector *v) {
            valType real_res = 0.0;
            valType *realValues = v->realValues;
            valType *imagValues = v->imagValues;

            #pragma omp parallel for reduction(+:real_res)
            for (size_t i = 0; i < numRows; ++i) {
                // Take the conjugate of this vector in place
                valType real_conj = realValues[i];
                valType imag_conj = -imagValues[i];

                // Multiply with the corresponding elements of vector `v`
                real_res += real_conj * realValues[i] - imag_conj * imagValues[i];
            }

            return real_res;
        }

        void print() {
            std::cout << "length (" << numRows << ") [";
            for (size_t i = 0; i < numRows - 1; ++i) {
                printf("(%lf,%lf), ", realValues[i], imagValues[i]);
            }
            printf("(%lf,%lf)]\n", realValues[numRows - 1], imagValues[numRows - 1]);
        }

        void print_meta() {
            std::cout << "length (" << numRows << ")" << std::endl;
            std::cout << "sparsity = " << sparsity() << std::endl;
        }

        valType sparsity() {
            long int num_nonzeros = 0;
            for (size_t i = 0; i < numRows; ++i) {
                if(realValues[i] != 0.0 || imagValues[i] != 0.0) {
                    num_nonzeros++;
                }
            }
            return (valType)1.0 - ((valType)num_nonzeros / (valType)numRows);
        }

        valType *getRealValues() {
            return realValues;
        }

        valType **getRealValuePtr() {
            return &realValues;
        }
        valType **getImagValuePtr() {
            return &imagValues;
        }
        void free() {
            std::free(realValues);
            std::free(imagValues);
        }
};

} // namespace diaq

#endif // DIAQ_VECTOR_HPP