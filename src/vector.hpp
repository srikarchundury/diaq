#ifndef DIAQ_VECTOR_HPP
#define DIAQ_VECTOR_HPP

#include "config.hpp"

namespace diaq {

class vector : public std::enable_shared_from_this<vector> {
    public:
        unsigned int numRows;
        valType* realValues;
        valType* imagValues;

        vector(unsigned int M) {
            numRows = M;
            #if NUM_BYTES_ALIGNED == -1
                realValues = (valType *)calloc(M, sizeof(valType));
                imagValues = (valType *)calloc(M, sizeof(valType));
                // realValues = (valType *)malloc(M * sizeof(valType));
                // imagValues = (valType *)malloc(M * sizeof(valType));
                // #pragma omp parallel for
                // for(unsigned int i = 0; i < M; i++) {
                //     realValues[i] = 0.0;
                //     imagValues[i] = 0.0;
                // }
            #else
                // printf("comes here only?\n");
                realValues = aligned_alloc_helper(M * sizeof(valType));
                imagValues = aligned_alloc_helper(M * sizeof(valType));
                #pragma omp parallel for
                for(unsigned int i = 0; i < M; i++) {
                    realValues[i] = 0.0;
                    imagValues[i] = 0.0;
                }
            #endif
        }

        vector(unsigned int M, valType *realVals, valType *imagVals) {
            numRows = M;
            realValues = realVals;
            imagValues = imagVals;
        }

        vector(unsigned int M, valType *realVals) {
            numRows = M;
            realValues = realVals;
            #if NUM_BYTES_ALIGNED == -1
                imagValues = (valType *)calloc(M, sizeof(valType));
            #else
                imagValues = aligned_alloc_helper(M * sizeof(valType));
            #endif
        }

        vector(unsigned int M, valType init_real, valType init_imag) {
            numRows = M;
            #if NUM_BYTES_ALIGNED == -1
                realValues = (valType *)calloc(M, sizeof(valType));
                imagValues = (valType *)calloc(M, sizeof(valType));
                for (unsigned int i = 0; i < M; ++i) {
                    realValues[i] = init_real;
                    imagValues[i] = init_imag;
                }
            #else
                realValues = aligned_alloc_helper(M * sizeof(valType));
                imagValues = aligned_alloc_helper(M * sizeof(valType));
                #pragma omp parallel for
                for(unsigned int i = 0; i < M; i++) {
                    realValues[i] = init_real;
                    imagValues[i] = init_imag;
                }
            #endif
        }

        vector(unsigned int M, valType init_real) {
            numRows = M;
            #if NUM_BYTES_ALIGNED == -1
                realValues = (valType *)calloc(M, sizeof(valType));
                imagValues = (valType *)calloc(M, sizeof(valType));
            #else
                realValues = aligned_alloc_helper(M * sizeof(valType));
                imagValues = aligned_alloc_helper(M * sizeof(valType));
            #endif
            #pragma omp parallel for
            for (unsigned int i = 0; i < M; ++i) {
                realValues[i] = init_real;
                imagValues[i] = 0.0;
            }
        }
        ~vector() {
            #ifdef DEEP_DEBUG
                std::cout << "vector destructor called" << std::endl;
            #endif
            std::free(realValues);
            std::free(imagValues); // needed because we allocate memory ourserlves unlike shared_ptr! This place and under diagonal.hpp & denseMatrix.hpp are the only places where we need to free memory manually!!!
        }

        void zeroify() {
            #pragma omp parallel for
            for(unsigned int i = 0; i < numRows; i++) {
                realValues[i] = 0.0;
                imagValues[i] = 0.0;
            }
        }

        std::complex<valType> operator[](unsigned int i) {
            return std::complex<valType>(realValues[i], imagValues[i]);
        }

        const std::complex<valType> operator[](unsigned int i) const {
            return std::complex<valType>(realValues[i], imagValues[i]);
        }

        unsigned int num_rows() const {
            return numRows;
        }

        void setValue(unsigned int i, valType real, valType imag) {
            realValues[i] = real;
            imagValues[i] = imag;
        }

        std::vector<std::complex<valType> > getArray() {
            std::vector<std::complex<valType> > v;
            for (unsigned int i = 0; i < numRows; ++i) {
                v.push_back(std::complex<valType>(realValues[i], imagValues[i]));
            }
            return v;
        }

        std::shared_ptr<vector> dagger() {
            std::shared_ptr<vector> v = std::make_shared<vector>(numRows);
            auto realValues = v->realValues;
            auto imagValues = v->imagValues;

            #pragma omp parallel for
            for (unsigned int i = 0; i < numRows; ++i) {
                realValues[i] = realValues[i];
                imagValues[i] = -1 * imagValues[i];
            }
            return v;
        }

        std::complex<valType> multiply(std::shared_ptr<vector> v) {
            valType real_res = 0.0;
            valType imag_res = 0.0;
            auto realValues = v->realValues;
            auto imagValues = v->imagValues;

            #pragma omp parallel for reduction(+:real_res,imag_res)
            for (unsigned int i = 0; i < numRows; ++i) {
                real_res += realValues[i] * realValues[i] - imagValues[i] * imagValues[i];
                imag_res += realValues[i] * imagValues[i] + imagValues[i] * realValues[i];
            }
            return std::complex<valType>(real_res, imag_res);
        }

        valType daggerMultiplyReal(std::shared_ptr<vector> v) {
            valType real_res = 0.0;
            auto realValues = v->realValues;
            auto imagValues = v->imagValues;

            #pragma omp parallel for reduction(+:real_res)
            for (unsigned int i = 0; i < numRows; ++i) {
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
            for (unsigned int i = 0; i < numRows - 1; ++i) {
                printf("(%lf,%lf), ", realValues[i], imagValues[i]);
            }
            printf("(%lf,%lf)]\n", realValues[numRows - 1], imagValues[numRows - 1]);
        }

        void print_meta() {
            std::cout << "length (" << numRows << ")" << std::endl;
            std::cout << "sparsity = " << sparsity() << std::endl;
        }

        valType sparsity() {
            unsigned int num_nonzeros = 0;
            for (unsigned int i = 0; i < numRows; ++i) {
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
};

} // namespace diaq

#endif // DIAQ_VECTOR_HPP
