#ifndef SPARSE_TNQS_DENSEMATRIX_HPP
#define SPARSE_TNQS_DENSEMATRIX_HPP

#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include <complex>


#include "quantumSparseMatrix.hpp"


class denseMatrix {
    public:
        std::vector<int> shape;
        std::vector<int> tensor_shape;
        int size;
        denseMatrix(const int s, float *real_data) {
            size = s*s;
            realData = real_data;
            imagData = (float *)calloc(size, sizeof(float));
            shape.push_back(s);
            shape.push_back(s);
            tensor_shape.push_back(s);
            tensor_shape.push_back(s);
        }
        denseMatrix(const int s, float *real_data, float *imag_data) {
            size = s*s;
            realData = real_data;
            imagData = imag_data;
            shape.push_back(s);
            shape.push_back(s);
            tensor_shape.push_back(s);
            tensor_shape.push_back(s);
        }
        denseMatrix(std::vector<int> *d, float *real_data) {
            shape = *d;
            size = shape[0] * shape[1];
            realData = real_data;
            imagData = (float *)calloc(size, sizeof(float));
            tensor_shape = *d;
        }
        denseMatrix(std::vector<int> *d, float *real_data, float *imag_data) {
            realData = real_data;
            imagData = imag_data;
            shape = *d;
            size = shape[0] * shape[1];
            tensor_shape = *d;
        }
        denseMatrix(std::vector<int> *d, float *real_data, float *imag_data, std::vector<int> *ts) {
            realData = real_data;
            imagData = imag_data;
            shape = *d;
            size = shape[0] * shape[1];
            tensor_shape = *ts;
        }
        std::complex<float> *getData() {
            std::complex<float> *res = (std::complex<float> *)malloc(size * sizeof(std::complex<float>));
            for(int i = 0; i < size; i++) {
                res[i] = std::complex<float>{realData[i], imagData[i]};
            }
            return res;
        }
        float *getRealData() {
            return realData;
        }
        int getFlatIndex(std::vector<int> ten_pos) {
            int flat_index = 0;
            int prod = 1;
            int remaining;
            for(int i = 0; i < tensor_shape.size() ; i++) {
                prod *= tensor_shape[i];
                flat_index = flat_index + (size / prod) * ten_pos[i];
            }
            return flat_index;
        }
        std::complex<float> getItem(std::vector<int> ten_pos) {
            std::complex<float> ans{realData[getFlatIndex(ten_pos)], imagData[getFlatIndex(ten_pos)]};
            return ans;
        }
        void set(int i, int j, std::complex<float> val) {
            realData[shape[1] * i + j] = val.real();
            imagData[shape[1] * i + j] = val.imag();
        }
        std::complex<float> get(int i, int j) {
            std::complex<float> ans{realData[shape[1] * i + j], imagData[shape[1] * i + j]};
            return ans;
        }
        void print() {
            std::cout << "matrix_shape (";
            for(int i = 0; i < shape.size()-1; i++) {
                std::cout << shape[i] << ",";
            }
            std::cout << shape[shape.size()-1] << ")" << std::endl;
            std::cout << "tensor_shape (";
            for(int i = 0; i < tensor_shape.size()-1; i++) {
                std::cout << tensor_shape[i] << ",";
            }
            std::cout << tensor_shape[tensor_shape.size()-1] << ")" << std::endl;
            for (int i = 0; i < size; i++) {
                if((i+1)%shape[1] == 0) {
                    std::cout << "(" << realData[i] << "," << imagData[i] << ")" << std::endl;
                }
                else {
                    std::cout << "(" << realData[i] << "," << imagData[i] << ")" << ",";
                }
            }
        }
        int isPartOf(int dIndex, int a, int b, int x, int y) {
            int p = x - y + b - a;
            if(dIndex >= size){
                p = x + y - a - b;
            }
            return p;
        }
        float sparsity() {
            int z = 0;
            for(int i = 0; i < size; i++) {
                if(realData[i] == 0.0 && imagData[i] == 0.0) {
                    z++;
                }
            }
            return ((float)z/(float)size) * 100;
        }
        // currently un-used!
        // given a point in nxn matrix, returns the diagonalIndex (-n,..,0,..n,..,2n-2) that it should belong to.
        int getTargetDiagIndex(quantumSparseMatrix *qm, int i, int j) {
            // every element will be part of 2 diagonals. We choose one of them based on sparsity in each.
            // get diagonal index, based on distance or number of elements.
            int targetDiagIndex_1 = 2 * size, targetDiagIndex_2 = 2 * size;
            // loop through all possible diagonals (principal and anti)
            for(int k = -1 * size + 1; k <= 2 * size - 2; k++) {
                diagonal* kDiag = qm->getDiagonal(k);
                int* kCoords = kDiag->getCoords(size, k);
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
        int getTargetDiagIndex_onlydiags(int i, int j) {
            return j-i;
        }
        quantumSparseMatrix convertToQuantumSparse(std::vector<int> new_shape);
    private:
        float *realData;
        float *imagData;
};

#endif // SPARSE_TNQS_DENSEMATRIX_HPP