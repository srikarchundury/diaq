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
    else if(indexA + indexB <= -1 * size) {
        return NULL;
    }
    diagonal res(indexA + indexB);
    int lenDiagA = size - abs(indexA);
    int lenDiagB = size - abs(indexB);
    int lenRes = size - abs(indexA + indexB);
    int offsetA = abs(indexA);
    int offsetB = abs(indexB);
    int jump = 0;
    if(indexA > 0) {
        if(indexB > 0) {
            offsetA = 0;
        }
        else if(indexB < 0) {
            offsetA = 0;
        }
        else if(indexB == 0) {
            offsetB = offsetA;
            offsetA = 0;
        }
    }
    else if(indexA < 0) {
        if(indexB > 0) {
            offsetA = 0;
            offsetB = 0;
            jump = abs(indexA);
        }
        else if(indexB < 0) {
            offsetA = offsetB;
            offsetB = 0;
        }
        else if(indexB == 0) {
            offsetA = 0;
            offsetB = 0;
        }
    }
    else if(indexA == 0) {
        if(indexB > 0) {
            offsetA = 0;
            offsetB = 0;
        }
        else if(indexB < 0) {
            offsetA = 0;
        }
        else if(indexB == 0) {
            offsetA = 0;
            offsetB = 0;
        }
    }
    int k = 0;
    // std::cout << "jump,offsetA,offsetB " << jump << offsetA << offsetB << std::endl;
    int jump_cpy = jump;
    while(jump) {
        res.addElement(0);
        jump--;
        k++;
    }
    // std::cout << k << std::endl;
    while(k < lenRes && k + offsetA - jump_cpy < lenDiagA && k + offsetB - jump_cpy < lenDiagB) {
        res.addElement(valuesA[k + offsetA - jump_cpy] * valuesB[k + offsetB - jump_cpy]);
        k++;
    }
    while(k < lenRes) {
        res.addElement(0);
        k++;
    }
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
    quantumSparseMatrix* result = new quantumSparseMatrix(A.getSize());
    // quantumSparseMatrix* resptr = &result;
    std::map<int, diagonal> mapA = A.getDiagonalMap();
    std::map<int, diagonal> mapB = B.getDiagonalMap();
    std::map<int, diagonal>::iterator itA, itB;
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        for (itB = mapB.begin(); itB != mapB.end(); itB++) {
            // itA->second.print();
            // itB->second.print();
            // std::cout << " --- " << std::endl;
            diagonal diagNew = multiplyDiagonals(A.getSize(), itA->first, itB->first, itA->second, itB->second);
            if(diagNew.getValues().size() != 0) {
                // std::cout << " ------ new diag ------ " << std::endl;
                // diagNew.print();
                result->addDiagonal(itA->first + itB->first, diagNew);
                // std::cout << " ------ result ------ " << std::endl;
                // result->print();
            }
        }
    }
    result->pruneMatrix();
    return *result;
}

/**
 * @brief dense matrix multiplication (C = A.B)
 * 
 * @param A denseMatrix
 * @param B denseMatrix
 * 
 * @return denseMatrix  C
 */
denseMatrix denseProduct(denseMatrix A, denseMatrix B) {
    if(A.getSize() != B.getSize()) {
        throw std::invalid_argument("input matrices are of different dimensions, not compatible");
    }
    int n = A.getSize();
    std::vector<std::complex<double>> resArray;
    for(int i = 0; i < n * n; i++) {
        resArray.push_back(0);
    }
    denseMatrix result(n, resArray);
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            for(int k = 0; k < n; k++) {
                result.set(i, j, result.get(i, j) + A.get(i, k) * B.get(k, j));
            }
        }
    }
    return result;
}