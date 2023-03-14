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
        denseMatrix(const int s, std::vector<std::complex<double>> array) {
            size = s;
            data = array;
            shape.push_back(s);
            shape.push_back(s);
        }
        denseMatrix(std::vector<int> *d, std::vector<std::complex<double>> array) {
            data = array;
            shape = *d;
            size = shape[0];
        }
        std::vector<std::complex<double> > getData() {
            return data;
        }
        int getSize() {
            return size;
        }
        int getDim(int i) {
            return shape[i];
        }
        std::vector<int> getShape() {
            return shape;
        }
        void set(int i, int j, std::complex<double> val) {
            data[shape[1] * i + j] = val;
        }
        std::complex<double> get(int i, int j) {
            return data[shape[1] * i + j];
        }
        void print() {
            for (int i = 0; i < data.size(); i++) {
                if((i+1)%shape[1] == 0) {
                    std::cout << data[i] << std::endl;
                }
                else {
                    std::cout << data[i] << ",";
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
            for(int i = 0; i < data.size(); i++) {
                if(data[i] == 0.0) {
                    z++;
                }
            }
            return ((float)z/(float)data.size()) * 100;
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
        int denseCapacity() {
            int c = 1;
            for(int i = 0; i < shape.size(); i++) {
                c = c * shape[i];
            }
            return c;
        }
        quantumSparseMatrix convertToQuantumSparse(std::vector<int> new_shape);
    private:
        int size;
        std::vector<std::complex<double>> data;
};

#endif // SPARSE_TNQS_DENSEMATRIX_HPP