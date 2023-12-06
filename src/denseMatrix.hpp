#ifndef DIAQ_DENSEMATRIX_HPP
#define DIAQ_DENSEMATRIX_HPP

#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include <complex>


#include "diaQMatrix.hpp"


class denseMatrix {
    public:
        std::vector<long int> matrix_shape;
        std::vector<long int> shape;
        long int size;
        denseMatrix(const long int s, double *real_data) {
            size = s*s;
            realData = real_data;
            imagData = (double *)calloc(size, sizeof(double));
            matrix_shape.push_back(s);
            matrix_shape.push_back(s);
            shape.push_back(s);
            shape.push_back(s);
        }
        denseMatrix(const long int s, double *real_data, double *imag_data) {
            size = s*s;
            realData = real_data;
            imagData = imag_data;
            matrix_shape.push_back(s);
            matrix_shape.push_back(s);
            shape.push_back(s);
            shape.push_back(s);
        }
        denseMatrix(std::vector<long int> *d, double *real_data) {
            matrix_shape = *d;
            size = matrix_shape[0] * matrix_shape[1];
            realData = real_data;
            imagData = (double *)calloc(size, sizeof(double));
            shape = *d;
        }
        denseMatrix(std::vector<long int> *d, double *real_data, double *imag_data) {
            realData = real_data;
            imagData = imag_data;
            matrix_shape = *d;
            size = matrix_shape[0] * matrix_shape[1];
            shape = *d;
        }
        denseMatrix(std::vector<long int> *d, double *real_data, double *imag_data, std::vector<long int> *ts) {
            realData = real_data;
            imagData = imag_data;
            matrix_shape = *d;
            size = matrix_shape[0] * matrix_shape[1];
            shape = *ts;
        }
        std::vector<std::complex<double> > getData_forPy() {
            std::vector<std::complex<double> > res(size, 0);
            for(long int i = 0; i < size; i++) {
                res[i] = std::complex<double>{realData[i], imagData[i]};
            }
            return res;
        }
        std::complex<double> *getData() {
            std::complex<double> *res = (std::complex<double> *)malloc(size * sizeof(std::complex<double>));
            for(long int i = 0; i < size; i++) {
                res[i] = std::complex<double>{realData[i], imagData[i]};
            }
            return res;
        }
        double *getRealData() {
            return realData;
        }
        double *getImagData() {
            return imagData;
        }
        long int getFlatIndex(std::vector<long int> ten_pos) {
            long int flat_index = 0;
            long long int prod = 1;
            for(long int i = 0; i < shape.size() ; i++) {
                prod *= shape[i];
                flat_index = flat_index + (size / prod) * ten_pos[i];
            }
            return flat_index;
        }
        std::complex<double> getItem(std::vector<long int> ten_pos) {
            std::complex<double> ans{realData[getFlatIndex(ten_pos)], imagData[getFlatIndex(ten_pos)]};
            return ans;
        }
        void set(long int i, long int j, std::complex<double> val) {
            realData[matrix_shape[1] * i + j] = val.real();
            imagData[matrix_shape[1] * i + j] = val.imag();
        }
        std::complex<double> get(long int i, long int j) {
            std::complex<double> ans{realData[matrix_shape[1] * i + j], imagData[matrix_shape[1] * i + j]};
            return ans;
        }
        void print() {
            std::cout << "matrix_shape (";
            for(long int i = 0; i < matrix_shape.size()-1; i++) {
                std::cout << matrix_shape[i] << ",";
            }
            std::cout << matrix_shape[matrix_shape.size()-1] << ")" << std::endl;
            std::cout << "tensor_shape (";
            for(long int i = 0; i < shape.size()-1; i++) {
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
            if(dIndex >= size){
                p = x + y - a - b;
            }
            return p;
        }
        double sparsity() {
            long int z = 0;
            for(long int i = 0; i < size; i++) {
                if(realData[i] == 0.0 && imagData[i] == 0.0) {
                    z++;
                }
            }
            return ((double)z/(double)size) * 100;
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
        diaQMatrix convertToQuantumSparse(std::vector<long int> new_shape);
    private:
        double *realData;
        double *imagData;
};

#endif // DIAQ_DENSEMATRIX_HPP