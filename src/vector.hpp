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

        bool isEqualTo(std::shared_ptr<vector> v, valType tol=1e-6) {
            if (numRows != v->numRows) {
                return false;
            }
            bool result = true;
            #pragma omp parallel for
            for (unsigned int i = 0; i < numRows; ++i) {
                if (std::abs(realValues[i] - v->realValues[i]) > tol || std::abs(imagValues[i] - v->imagValues[i]) > tol) {
                    // printf("Vectors differ at index %u: (%.6f, %.6f) vs (%.6f, %.6f)\n", i, realValues[i], imagValues[i], v->realValues[i], v->imagValues[i]);
                    result = false;
                }
            }
            return result;
        }

        std::complex<valType> operator[](unsigned int i) {
            return std::complex<valType>(realValues[i], imagValues[i]);
        }

        const std::complex<valType> operator[](unsigned int i) const {
            return std::complex<valType>(realValues[i], imagValues[i]);
        }

        std::shared_ptr<vector> subtract(std::shared_ptr<vector> v) {
            assert(numRows == v->numRows);
            std::shared_ptr<vector> result = std::make_shared<vector>(numRows);
            valType *realValues = result->realValues;
            valType *imagValues = result->imagValues;

            #pragma omp parallel for
            for (unsigned int i = 0; i < numRows; ++i) {
                realValues[i] = realValues[i] - v->realValues[i];
                imagValues[i] = imagValues[i] - v->imagValues[i];
            }
            return result;
        }

        unsigned int num_rows() const {
            return numRows;
        }

        valType dot(const std::shared_ptr<vector> v) {
            valType result = 0.0;
            valType *realValues = v->realValues;
            valType *imagValues = v->imagValues;

            #pragma omp parallel for reduction(+:result)
            for (unsigned int i = 0; i < numRows; ++i) {
                result += realValues[i] * realValues[i] + imagValues[i] * imagValues[i];
            }
            return result;
        }

        valType norm() {
            valType result = 0.0;
            #pragma omp parallel for reduction(+:result)
            for (unsigned int i = 0; i < numRows; ++i) {
                result += realValues[i] * realValues[i] + imagValues[i] * imagValues[i];
            }
            return std::sqrt(result);
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
            valType *realValues = v->realValues;
            valType *imagValues = v->imagValues;

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
            valType *realValues = v->realValues;
            valType *imagValues = v->imagValues;

            #pragma omp parallel for reduction(+:real_res,imag_res)
            for (unsigned int i = 0; i < numRows; ++i) {
                real_res += realValues[i] * realValues[i] - imagValues[i] * imagValues[i];
                imag_res += realValues[i] * imagValues[i] + imagValues[i] * realValues[i];
            }
            return std::complex<valType>(real_res, imag_res);
        }

        valType daggerMultiplyReal(std::shared_ptr<vector> v) {
            valType real_res = 0.0;
            valType *realValues = v->realValues;
            valType *imagValues = v->imagValues;

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

        std::shared_ptr<vector> copy() {
            std::shared_ptr<vector> v = std::make_shared<vector>(numRows);
            valType *realValues = v->realValues;
            valType *imagValues = v->imagValues;

            #pragma omp parallel for
            for (unsigned int i = 0; i < numRows; ++i) {
                realValues[i] = realValues[i];
                imagValues[i] = imagValues[i];
            }
            return v;
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
