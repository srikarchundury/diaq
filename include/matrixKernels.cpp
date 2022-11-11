// implement all functions here
// UPDATE: Implement Kernels in include/kernels.hpp

#include "quantumSparseMatrix.hpp"

// ----------------------------------------------------------------
//
// Matrix arithmetic
//
// ----------------------------------------------------------------

/**
 * @brief diagonal matrix multiplication
 * 
 * @param A diagonal A index
 * @param B diagonal B index
 * @param A diagonal A
 * @param B diagonal B
 * 
 * @return NULL if zero, else diagonal C
 */
diagonal multiplyDiagonals(int size, int indexA, int indexB, diagonal diagA, diagonal diagB) {
    std::vector<std::complex<double> > valuesA = diagA.getValues();
    std::vector<std::complex<double> > valuesB = diagB.getValues();
    if(indexA + indexB >= size) {
        return NULL;
    }
    diagonal res(indexA + indexB);
    int lenDiagA = size - abs(indexA);
    int lenDiagB = size - abs(indexB);
    int lenRes = size - abs(indexA + indexB);
    if(indexA > 0) {
        int k=0;
        while(k<lenRes) {
            // TODO: needs to be changed to incorporate offsets
            res.addElement(valuesA[k] * valuesB[k]);
            k++;
        }
    }
    else {
        int k=0;
        while(k<lenRes) {
            res.addElement(valuesA[k] * valuesB[k]);
            k++;
        }
    }
    // res.print();
    return res;
}

/**
 * @brief quantum sparse matrix multiplication (C = A.B)
 * 
 * @param A quantumSparseMatrix
 * @param B quantumSparseMatrix
 * 
 * @return quantumSparseMatrix  C
 */
quantumSparseMatrix product(quantumSparseMatrix A, quantumSparseMatrix B) {
    if(A.getSize() != B.getSize()) {
        throw std::invalid_argument("input matrices are of different dimensions, not compatible");
    }
    std::map<int, diagonal> resultMap;
    quantumSparseMatrix result(resultMap, A.getSize());
    std::map<int, diagonal> mapA = A.getDiagonalMap();
    std::map<int, diagonal> mapB = B.getDiagonalMap();
    std::map<int, diagonal>::iterator itA, itB;
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        for (itB = mapB.begin(); itB != mapB.end(); itB++) {
            diagonal diagNew = multiplyDiagonals(A.getSize(), itA->first, itB->first, itA->second, itB->second);
            if(diagNew.getValues().size() != 0) {
                result.addDiagonal(itA->first + itB->first, diagNew);
            }
        }
    }
    return result;
}