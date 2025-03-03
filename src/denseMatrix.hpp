#ifndef DIAQ_DENSEMATRIX_HPP
#define DIAQ_DENSEMATRIX_HPP

#include "diaQMatrix.hpp"

namespace diaq {

class denseMatrix : public std::enable_shared_from_this<denseMatrix> {
    public:
        unsigned int *matrix_shape;
        std::vector<unsigned int> shape;
        valType *realData;
        valType *imagData;

        denseMatrix(const unsigned int s) {
            unsigned int size = s*s;
            #if NUM_BYTES_ALIGNED == -1
                realData = (valType *)calloc(size, sizeof(valType));
                imagData = (valType *)calloc(size, sizeof(valType));
            #else
                realData = aligned_alloc_helper(size * sizeof(valType));
                imagData = aligned_alloc_helper(size * sizeof(valType));
            #endif
            matrix_shape = new unsigned int[2];
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        } 
        denseMatrix(const unsigned int s, valType *real_data) {
            unsigned int size = s*s;
            realData = real_data;
            #if NUM_BYTES_ALIGNED == -1
                imagData = (valType *)calloc(size, sizeof(valType));
            #else
                imagData = aligned_alloc_helper(size * sizeof(valType));
                #pragma omp parallel for
                for(unsigned int i = 0; i < size; i++) {
                    imagData[i] = 0.0;
                }
            #endif
            matrix_shape = new unsigned int[2];
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        denseMatrix(const unsigned int s, valType *real_data, valType *imag_data) {
            realData = real_data;
            imagData = imag_data;
            matrix_shape = new unsigned int[2];
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        denseMatrix(unsigned int **d, valType *real_data) {
            matrix_shape = *d;
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
        denseMatrix(unsigned int **d, valType *real_data, valType *imag_data) {
            realData = real_data;
            imagData = imag_data;
            matrix_shape = *d;
            shape.push_back(matrix_shape[0]);
            shape.push_back(matrix_shape[1]);
        }
        denseMatrix(unsigned int **d, valType *real_data, valType *imag_data, std::vector<unsigned int> ts) {
            realData = real_data;
            imagData = imag_data;
            matrix_shape = *d;
            shape = ts;
        }
        ~denseMatrix() {
            #ifdef DEEP_DEBUG
                std::cout << "denseMatrix destructor called" << std::endl;
            #endif
            // we have to free because we allocate manually, other places are vector.hpp, diagonal.hpp!!!
            std::free(realData);
            std::free(imagData);
            // somehow tests fail if I free it here, invesigating!!
        }
        std::complex<valType> *getData_forPy() {
            unsigned int size = matrix_shape[0] * matrix_shape[1];
            std::complex<valType> *res = new std::complex<valType>[size]();
            #pragma omp parallel for
            for(unsigned int i = 0; i < size; i++) {
                res[i] = std::complex<valType>{realData[i], imagData[i]};
            }
            return res;
        }
        std::complex<valType> *getData() {
            unsigned int size = matrix_shape[0] * matrix_shape[1];
            std::complex<valType> *res = (std::complex<valType> *)malloc(size * sizeof(std::complex<valType>));
            #pragma omp parallel for
            for(unsigned int i = 0; i < size; i++) {
                res[i] = std::complex<valType>{realData[i], imagData[i]};
            }
            return res;
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
            #pragma omp simd
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
        // currently un-used!
        // given a point in nxn matrix, returns the diagonalIndex (-n,..,0,..n,..,2n-2) that it should belong to.
        int getTargetDiagIndex(std::shared_ptr<diaQMatrix> qm, unsigned int i, unsigned int j) {
            unsigned int size = matrix_shape[0] * matrix_shape[1];
            // every element will be part of 2 diagonals?? We choose one of them based on sparsity in each.
            // get diagonal index, based on distance or number of elements.
            int targetDiagIndex_1 = 2 * size, targetDiagIndex_2 = 2 * size;
            // loop through all possible diagonals (principal and anti)
            for(int k = -1 * size + 1; k <= static_cast<int>(2 * size - 2); k++) {
                std::shared_ptr<diagonal> kDiag = qm->getDiagonal_orCreateIt(k);
                unsigned int *kCoords = kDiag->getCoords(size, k);
                if(isPartOf(k, kCoords[0], kCoords[1], i, j)) {
                    // std::cout << i << "," << j << "=" << k << std::endl;
                    if(targetDiagIndex_1 == static_cast<int>(2 * size)) {
                        targetDiagIndex_1 = k;
                    }
                    else if(targetDiagIndex_2 == static_cast<int>(2 * size)) {
                        targetDiagIndex_2 = k;
                    }
                }
            }
            if(targetDiagIndex_2 != static_cast<int>(2 * size)) {
                return (qm->getDiagonal_orCreateIt(targetDiagIndex_1)->numNonZeros() > qm->getDiagonal_orCreateIt(targetDiagIndex_2)->numNonZeros())?targetDiagIndex_1:targetDiagIndex_2;
            }
            return targetDiagIndex_1;
        }
        int getTargetDiagIndex_onlydiags(int i, int j) {
            return j-i;
        }
        std::shared_ptr<diaQMatrix> convertToQuantumSparse(std::vector<unsigned int> new_shape);
        std::shared_ptr<diaQMatrix> convertToQuantumSparse(unsigned int *new_matrix_shape);
        std::shared_ptr<diaQMatrix> convertToQuantumSparse();
};

} // namespace diaq

#endif // DIAQ_DENSEMATRIX_HPP
