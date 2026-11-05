#ifndef DIAQ_DENSEMATRIX_HPP
#define DIAQ_DENSEMATRIX_HPP

#include "diaQMatrix.hpp"

namespace diaq {

class denseMatrix : public std::enable_shared_from_this<denseMatrix> {
    public:
        std::array<unsigned int, 2> matrix_shape;
        std::vector<unsigned int> shape;
        valType *realData;
        valType *imagData;

        denseMatrix(const unsigned int s) {
            unsigned int size = s*s;
            #if NUM_BYTES_ALIGNED <= 0
                realData = (valType *)calloc(size, sizeof(valType));
                imagData = (valType *)calloc(size, sizeof(valType));
            #else
                realData = aligned_alloc_helper(size * sizeof(valType));
                imagData = aligned_alloc_helper(size * sizeof(valType));
                #pragma omp parallel for
                for(unsigned int i = 0; i < size; i++) {
                    realData[i] = 0.0;
                    imagData[i] = 0.0;
                }
            #endif

            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        } 
        denseMatrix(const unsigned int s, valType *real_data) {
            unsigned int size = s*s;
            realData = real_data;
            #if NUM_BYTES_ALIGNED <= 0
                imagData = (valType *)calloc(size, sizeof(valType));
            #else
                imagData = aligned_alloc_helper(size * sizeof(valType));
                #pragma omp parallel for
                for(unsigned int i = 0; i < size; i++) {
                    imagData[i] = 0.0;
                }
            #endif

            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        denseMatrix(const unsigned int s, valType *real_data, valType *imag_data) {
            realData = real_data;
            imagData = imag_data;

            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        denseMatrix(std::array<unsigned int, 2> d, valType *real_data) {
            matrix_shape = d;
            realData = real_data;
            unsigned int size = matrix_shape[0] * matrix_shape[1];
            #if NUM_BYTES_ALIGNED == -1
                imagData = (valType *)calloc(size, sizeof(valType));
            #else
                imagData = aligned_alloc_helper(size * sizeof(valType));
                #pragma omp parallel for
                for(unsigned int i = 0; i < size; i++) {
                    imagData[i] = 0.0;
                }
            #endif
            shape.push_back(matrix_shape[0]);
            shape.push_back(matrix_shape[1]);
        }
        denseMatrix(std::array<unsigned int, 2> d, valType *real_data, valType *imag_data) {
            realData = real_data;
            imagData = imag_data;
            matrix_shape = d;
            shape.push_back(matrix_shape[0]);
            shape.push_back(matrix_shape[1]);
        }
        denseMatrix(std::array<unsigned int, 2> d, valType *real_data, valType *imag_data, std::vector<unsigned int> ts) {
            realData = real_data;
            imagData = imag_data;
            matrix_shape = d;
            shape = ts;
        }
        ~denseMatrix() {
            // #ifdef DEEP_DEBUG
            //     std::cout << "denseMatrix destructor called" << std::endl;
            // #endif
            // we have to free because we allocate manually, other places are vector.hpp, diagonal.hpp!!!
            if(realData != nullptr) std::free(realData);
            if(imagData != nullptr) std::free(imagData);
            // somehow tests fail if I free it here, invesigating!!
        }
        valType *getRealData() {
            return realData;
        }
        valType *getImagData() {
            return imagData;
        }
        unsigned int getFlatIndex(std::vector<unsigned int> ten_pos) {
            unsigned int flat_index = 0;
            unsigned int prod = 1;
            #pragma omp simd reduction(+:flat_index)
            for(size_t i = 0; i < shape.size() ; i++) {
                prod *= shape[i];
                flat_index = flat_index + (matrix_shape[0] * matrix_shape[1] / prod) * ten_pos[i];
            }
            return flat_index;
        }
        std::complex<valType> getItem(std::vector<unsigned int> ten_pos) {
            std::complex<valType> ans{realData[getFlatIndex(ten_pos)], imagData[getFlatIndex(ten_pos)]};
            return ans;
        }
        void set(unsigned int i, unsigned int j, std::complex<valType> val) {
            realData[matrix_shape[1] * i + j] = val.real();
            imagData[matrix_shape[1] * i + j] = val.imag();
        }
        std::complex<valType> get(unsigned int i, unsigned int j) {
            std::complex<valType> ans{realData[matrix_shape[1] * i + j], imagData[matrix_shape[1] * i + j]};
            return ans;
        }
        void print() {
            std::cout << "matrix_shape (";
            printf("%u,%u)\n", matrix_shape[0], matrix_shape[1]);
            std::cout << "tensor_shape (";
            for(size_t i = 0; i < shape.size()-1; i++) {
                std::cout << shape[i] << ",";
            }
            std::cout << shape[shape.size()-1] << ")" << std::endl;
            unsigned int size = matrix_shape[0] * matrix_shape[1];
            for (unsigned int i = 0; i < size; i++) {
                if((i+1)%matrix_shape[1] == 0) {
                    std::cout << "(" << realData[i] << "," << imagData[i] << ")" << std::endl;
                }
                else {
                    std::cout << "(" << realData[i] << "," << imagData[i] << ")" << ",";
                }
            }
        }
        bool isPartOf(int dIndex, int a, int b, int x, int y) {
            int p = x - y + b - a;
            unsigned int size = matrix_shape[0] * matrix_shape[1];
            if(dIndex >= (int) size) {
                p = x + y - a - b;
            }
            return (p == 0);
        }
        valType sparsity() {
            unsigned int size = matrix_shape[0] * matrix_shape[1];
            unsigned int z = 0;
            for(unsigned int i = 0; i < size; i++) {
                if(realData[i] == 0.0 && imagData[i] == 0.0) {
                    z++;
                }
            }
            return ((valType)z/(valType)size) * 100;
        }
        std::shared_ptr<diaQMatrix> convertToDiaQ(std::vector<unsigned int> new_shape);
        std::shared_ptr<diaQMatrix> convertToDiaQ(std::array<unsigned int, 2> new_matrix_shape);
        std::shared_ptr<diaQMatrix> convertToDiaQ();
};

} // namespace diaq

#endif // DIAQ_DENSEMATRIX_HPP
