// implement all functions here
// UPDATE: Implement Kernels in include/kernels.hpp

#include "quantumSparseMatrix.hpp"
#include "denseMatrix.hpp"


unsigned long long int sparse_add_counter = 0;
unsigned long long int sparse_mul_counter = 0;

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
        return diagonal(0);
    }
    else if(indexA + indexB <= -1 * size) {
        return diagonal(0);
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
            offsetB = offsetA;
            offsetA = 0;
        }
        else if(indexB < 0) {
            // std::cout << "jump,offsetA,offsetB " << jump << "," << offsetA << "," << offsetB << std::endl;
            if(offsetA > offsetB) {
                offsetB = abs(indexA + indexB);
                offsetA = 0;
            }
            else {
                offsetA = abs(indexA + indexB);
                offsetB = 0;
            }
        }
        else if(indexB == 0) {
            offsetB = offsetA;
            offsetA = 0;
        }
    }
    else if(indexA < 0) {
        if(indexB > 0) {
            // std::cout << "jump,offsetA,offsetB " << jump << "," << offsetA << "," << offsetB << std::endl;
            // std::cout << "lenDiagA,lenDiagB,lenRes " << lenDiagA << "," << lenDiagB << "," << lenRes << std::endl;
            // jump decides how many positions to skip for each diagonal, depends on the length of the shorter diagonal.
            if(lenDiagB < lenDiagA) {
                jump = lenRes - lenDiagB;
            }
            else if(lenDiagA < lenDiagB) {
                jump = lenRes - lenDiagA;
            }
            else {
                jump = abs(indexA);
            }
            offsetA = 0;
            offsetB = 0;
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
            offsetA = offsetB;
            offsetB = 0;
        }
        else if(indexB == 0) {
            offsetA = 0;
            offsetB = 0;
        }
    }
    int k = 0;
    int jump_cpy = jump;
    while(jump) {
        res.addElement(0);
        jump--;
        k++;
    }
    // std::cout << k << std::endl;
    // std::cout << "jump,offsetA,offsetB " << jump << "," << offsetA << "," << offsetB << std::endl;
    while(k < lenRes && k + offsetA - jump_cpy < lenDiagA && k + offsetB - jump_cpy < lenDiagB) {
        res.addElement(valuesA[k + offsetA - jump_cpy] * valuesB[k + offsetB - jump_cpy]);
        k++;
        sparse_mul_counter++;
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
    sparse_add_counter = 0;
    sparse_mul_counter = 0;
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
            // std::cout << " ------ diags ------ " << std::endl;
            // itA->second.print();
            // itB->second.print();
            // std::cout << " ------ diags ------ " << std::endl;
            // std::cout << " --- " << std::endl;
            diagonal diagNew = multiplyDiagonals(A.getSize(), itA->first, itB->first, itA->second, itB->second);
            if(diagNew.getValues().size() != 0) {
                // std::cout << " ------ new diag ------ " << std::endl;
                // diagNew.print();
                // std::cout << " ------ new diag ------ " << std::endl;
                result->addDiagonal(itA->first + itB->first, diagNew);
                sparse_add_counter += (A.getSize() - abs(itA->first + itB->first));
                // std::cout << " ------ result ------ " << std::endl;
                // result->print();
                // std::cout << " ------ result ------ " << std::endl;
            }
        }
    }
    result->pruneMatrix();
    // std::cout << " ------ final result ------ " << std::endl;
    // result->print();
    // std::cout << " ------ final result ------ " << std::endl;
    std::cout << "Additions: " << sparse_add_counter << " Multiplications: " << sparse_mul_counter << std::endl;
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
    unsigned long long int add_counter = 0;
    unsigned long long int mul_counter = 0;
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
                add_counter++;
                mul_counter++;
            }
        }
    }
    std::cout << "Additions: " << add_counter << " Multiplications: " << mul_counter << std::endl;
    return result;
}