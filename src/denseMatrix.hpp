#ifndef DIAQ_DENSEMATRIX_HPP
#define DIAQ_DENSEMATRIX_HPP

#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include <complex>


#include "diaQMatrix.hpp"

namespace diaq {

class denseMatrix {
    public:
        long int *matrix_shape;
        std::vector<long int> shape;
        long int size;
        denseMatrix(const long int s) {
            size = s*s;
            realData = (valType *)calloc(size, sizeof(valType));
            imagData = (valType *)calloc(size, sizeof(valType));
            matrix_shape = new long int[2];
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        } 
        denseMatrix(const long int s, valType *real_data) {
            size = s*s;
            realData = real_data;
            imagData = (valType *)calloc(size, sizeof(valType));
            matrix_shape = new long int[2];
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        denseMatrix(const long int s, valType *real_data, valType *imag_data) {
            size = s*s;
            realData = real_data;
            imagData = imag_data;
            matrix_shape = new long int[2];
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        denseMatrix(long int **d, valType *real_data) {
            matrix_shape = *d;
            size = matrix_shape[0] * matrix_shape[1];
            realData = real_data;
            imagData = (valType *)calloc(size, sizeof(valType));
            shape.push_back(matrix_shape[0]);
            shape.push_back(matrix_shape[1]);
        }
        denseMatrix(long int **d, valType *real_data, valType *imag_data) {
            realData = real_data;
            imagData = imag_data;
            matrix_shape = *d;
            size = matrix_shape[0] * matrix_shape[1];
            shape.push_back(matrix_shape[0]);
            shape.push_back(matrix_shape[1]);
        }
        denseMatrix(long int **d, valType *real_data, valType *imag_data, std::vector<long int> ts) {
            realData = real_data;
            imagData = imag_data;
            matrix_shape = *d;
            size = matrix_shape[0] * matrix_shape[1];
            shape = ts;
        }
        std::complex<valType> *getData_forPy() {
            std::complex<valType> *res = new std::complex<valType>[size]();
            #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
            for(long int i = 0; i < size; i++) {
                res[i] = std::complex<valType>{realData[i], imagData[i]};
            }
            return res;
        }
        std::complex<valType> *getData() {
            std::complex<valType> *res = (std::complex<valType> *)malloc(size * sizeof(std::complex<valType>));
            #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
            for(long int i = 0; i < size; i++) {
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
        long int getFlatIndex(std::vector<long int> ten_pos) {
            long int flat_index = 0;
            long long int prod = 1;
            for(size_t i = 0; i < shape.size() ; i++) {
                prod *= shape[i];
                flat_index = flat_index + (size / prod) * ten_pos[i];
            }
            return flat_index;
        }
        std::complex<valType> getItem(std::vector<long int> ten_pos) {
            std::complex<valType> ans{realData[getFlatIndex(ten_pos)], imagData[getFlatIndex(ten_pos)]};
            return ans;
        }
        void set(long int i, long int j, std::complex<valType> val) {
            realData[matrix_shape[1] * i + j] = val.real();
            imagData[matrix_shape[1] * i + j] = val.imag();
        }
        std::complex<valType> get(long int i, long int j) {
            std::complex<valType> ans{realData[matrix_shape[1] * i + j], imagData[matrix_shape[1] * i + j]};
            return ans;
        }
        void print() {
            std::cout << "matrix_shape (";
            printf("%ld,%ld)\n", matrix_shape[0], matrix_shape[1]);
            std::cout << "tensor_shape (";
            for(size_t i = 0; i < shape.size()-1; i++) {
                std::cout << shape[i] << ",";
            }
            std::cout << shape[shape.size()-1] << ")" << std::endl;
            for (long int i = 0; i < size; i++) {
                if((i+1)%matrix_shape[1] == 0) {
                    std::cout << "(" << realData[i] << "," << imagData[i] << ")" << std::endl;
                }
                else {
                    std::cout << "(" << realData[i] << "," << imagData[i] << ")" << ",";
                }
            }
        }
        long int isPartOf(long int dIndex, long int a, long int b, long int x, long int y) {
            long int p = x - y + b - a;
            if(dIndex >= size) {
                p = x + y - a - b;
            }
            return p;
        }
        valType sparsity() {
            long int z = 0;
            for(long int i = 0; i < size; i++) {
                if(realData[i] == 0.0 && imagData[i] == 0.0) {
                    z++;
                }
            }
            return ((valType)z/(valType)size) * 100;
        }
        // currently un-used!
        // given a polong int in nxn matrix, returns the diagonalIndex (-n,..,0,..n,..,2n-2) that it should belong to.
        long int getTargetDiagIndex(diaQMatrix *qm, long int i, long int j) {
            // every element will be part of 2 diagonals. We choose one of them based on sparsity in each.
            // get diagonal index, based on distance or number of elements.
            long int targetDiagIndex_1 = 2 * size, targetDiagIndex_2 = 2 * size;
            // loop through all possible diagonals (principal and anti)
            for(long int k = -1 * size + 1; k <= 2 * size - 2; k++) {
                diagonal* kDiag = qm->getDiagonal(k);
                long int* kCoords = kDiag->getCoords(size, k);
                if(isPartOf(k, kCoords[0], kCoords[1], i, j) == 0) {
                    // std::cout << i << "," << j << "=" << k << std::endl;
                    if(targetDiagIndex_1 == 2 * size) {
                        targetDiagIndex_1 = k;
                    }
                    else if(targetDiagIndex_2 == 2 * size) {
                        targetDiagIndex_2 = k;
                    }
                }
            }
            if(targetDiagIndex_2 != 2 * size) {
                return (qm->getDiagonal(targetDiagIndex_1)->numNonZeros() > qm->getDiagonal(targetDiagIndex_2)->numNonZeros())?targetDiagIndex_1:targetDiagIndex_2;
            }
            return targetDiagIndex_1;
        }
        long int getTargetDiagIndex_onlydiags(long int i, long int j) {
            return j-i;
        }
        void free() {
            std::free(realData);
            std::free(imagData);
        }
        diaQMatrix *convertToQuantumSparse(std::vector<long int> new_shape);
        diaQMatrix *convertToQuantumSparse(long int *new_matrix_shape);
        diaQMatrix *convertToQuantumSparse();
    private:
        valType *realData;
        valType *imagData;
};

} // namespace diaq

#endif // DIAQ_DENSEMATRIX_HPP