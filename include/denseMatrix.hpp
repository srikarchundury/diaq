#ifndef SPARSE_TNQS_DENSEMATRIX_HPP
#define SPARSE_TNQS_DENSEMATRIX_HPP

#include <iostream>
#include <string>
#include <vector>
#include <cmath>

#include "quantumSparseMatrix.hpp"


class denseMatrix {
    public:
        int size;
        std::vector<int> data;
        denseMatrix(const int s) {
            size = s;
            std::vector<int> array(s * s);
            data = array;
        }
        void print(string sep="x") {
            for (int i = 0; i < data.size(); i++) {
                if((i+1)%size == 0) {
                    std::cout << data[i] << std::endl;
                }
                else {
                    std::cout << data[i] << ",";
                }
            }
        }
        quantumSparseMatrix convertToQuantumSparse(int matrixSize) {
            std::cout << "converting dense to sparse" << std::endl;
            map<int, diagonal> diagMap;
            quantumSparseMatrix qm(diagMap, matrixSize);
            for(int i=0; i < size; i++) {
                for(int j=0; j < size; j++) {
                    int diagIndx = getTargetDiagIndex(&qm, i, j);
                    // std::cout << "(" << i << "," << j << ")" << " " << diagIndx << std::endl;
                    qm.addToDiagonal(diagIndx, data[i * size + j]);
                }
            }
            qm.pruneMatrix();
            return qm;
        }
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
        int isPartOf(int dIndex, int a, int b, int x, int y) {
            int p = x - y + b - a;
            if(dIndex >= size){
                p = x + y - a - b;
            }
            return p;
        }
};

#endif // SPARSE_TNQS_DENSEMATRIX_HPP