#include "quantumSparseMatrix.hpp"
#include "denseMatrix.hpp"


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
diagonal multiplyDiagonals(std::vector<int> dimsA, std::vector<int> dimsB, int indexA, int indexB, diagonal diagA, diagonal diagB) {
    std::vector<std::complex<double> > valuesA = diagA.getValues();
    std::vector<std::complex<double> > valuesB = diagB.getValues();
    if(indexA + indexB >= dimsB[0]) {
        return diagonal(0);
    }
    else if(indexA + indexB <= -1 * dimsA[0]) {
        return diagonal(0);
    }
    diagonal res(indexA + indexB);
    int lenDiagA = diagA.getSize();
    int lenDiagB = diagB.getSize();
    // result matrix has dimensions {dimsA[0], dimsB[1]}
    // TODO
    int lenRes;
    if(indexA + indexB < 0) {
        lenRes = dimsA[0] + indexA + indexB;
    } else if(indexA + indexB > 0) {
        lenRes = dimsB[1] - indexA - indexB;
    }  else {
        lenRes = (dimsA[0] > dimsB[1])?dimsB[1]:dimsA[0];
    }
    // std::cout << "diagonal length = " << lenRes << std::endl;
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
                if(indexA + indexB < 0) {
                    jump = abs(indexA) - abs(dimsA[0] - dimsB[1]);
                } else {
                    jump = abs(indexA);
                }
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
    if(A.getDim(1) != B.getDim(0)) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    std::vector<int> d{A.getDim(0), B.getDim(1)};
    quantumSparseMatrix* result = new quantumSparseMatrix(&d);
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
            diagonal diagNew = multiplyDiagonals(A.getDims(), B.getDims(), itA->first, itB->first, itA->second, itB->second);
            if(diagNew.getValues().size() != 0) {
                // std::cout << " ------ new diag ------ " << std::endl;
                // diagNew.print();
                // std::cout << " ------ new diag ------ " << std::endl;
                result->addDiagonal(itA->first + itB->first, diagNew);
                // std::cout << " ------ result ------ " << std::endl;
                // result->print();
                // std::cout << " ------ result ------ " << std::endl;
            } else {
                // std::cout << "diagonal does not exist" << std::endl;
            }
        }
    }
    result->pruneMatrix();
    // std::cout << " ------ final result ------ " << std::endl;
    // result->print();
    // std::cout << " ------ final result ------ " << std::endl;
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
    std::vector<int> dims_a = A.getDims();
    std::vector<int> dims_b = B.getDims();
    if(dims_a[1] != dims_b[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    std::vector<std::complex<double>> resArray;
    for(int i = 0; i < dims_a[0] * dims_b[1]; i++) {
        resArray.push_back(0);
    }
    std::vector<int> d{A.getDim(0), B.getDim(1)};
    denseMatrix result(&d, resArray);
    for(int i = 0; i < dims_a[0]; i++) {
        for(int k = 0; k < dims_b[1]; k++) {
            std::complex<double> res = 0.0;
            for(int j = 0; j < dims_b[0]; j++) {
                res += A.get(i, j) * B.get(j, k);
            }
            result.set(i, k, res);
        }
    }
    return result;
}

/**
* @brief adds two quantumSparseMatrix matrices (C = A + B)
* @param A quantumSparseMatrix
* @param B quantumSparseMatrix
* @return quantumSparseMatrix C
*/
diagonal addElements(diagonal A, diagonal B) {
    std::vector<std::complex<double> > valsA = A.getValues();
    std::vector<std::complex<double> > valsB = B.getValues();
    if(valsA.size() != valsB.size() ) {
        throw std::invalid_argument("diagonals are of different lengths!");
    }
    for(int i=0; i < valsA.size(); i++) {
        valsA[i] = valsA[i] + valsB[i];
    }
    return diagonal(A.getIndex(), &valsA);
}

quantumSparseMatrix add(quantumSparseMatrix A, quantumSparseMatrix B) {
    if(A.getSize() != B.getSize()) {
        throw std::invalid_argument("input matrices are of different dimensions, not compatible");
    }
    quantumSparseMatrix* result = new quantumSparseMatrix(A.getSize());
    std::map<int, diagonal> mapA = A.getDiagonalMap();
    std::map<int, diagonal> mapB = B.getDiagonalMap();
    std::map<int, diagonal>::iterator itA, itB;
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        itB = mapB.find(itA->first);
        if (itB == mapB.end()) {
            result->addDiagonal(itA->first, itA->second);
        } else {
            result->addDiagonal(itA->first, addElements(itA->second, itB->second));
        }
    }
    // result->pruneMatrix();
    return *result;
}


std::complex<double> trace(quantumSparseMatrix A) {
    std::complex<double> t;
    std::map<int, diagonal>::iterator itA;
    std::map<int, diagonal> mapA = A.getDiagonalMap();
    itA = mapA.find(0);
    if(itA == mapA.end()) {
        return t;
    }
    for(int i=0; i < itA->second.getSize(); i++) {
        t += itA->second.getValue(i);
    }
    return t;
}

quantumSparseMatrix reshape(quantumSparseMatrix A, std::vector<int> dims) {
    denseMatrix d = A.convertToDenseMatrix(dims);
    return d.convertToQuantumSparse(dims);
}

quantumSparseMatrix tensordot(quantumSparseMatrix A, quantumSparseMatrix B, std::vector<std::vector<int> > axes) {
    std::cout << "tensordot called for A - " << std::endl;
    A.print();
    std::cout << "and B - " << std::endl;
    B.print();
    std::cout << "with axes - " << axes[0][0] << " and " << axes[1][0] << std::endl;
    int last_dim_a = axes[0][0];
    int first_dim_b = axes[1][0];
    int remA = A.getDim(0) * A.getDim(1) / last_dim_a;
    int remB = B.getDim(0) * B.getDim(1) / first_dim_b;
    std::vector<int> new_dim_a{remA, last_dim_a};
    std::vector<int> new_dim_b{first_dim_b, remB};
    quantumSparseMatrix reshaped_A = reshape(A, new_dim_a);
    quantumSparseMatrix reshaped_B = reshape(B, new_dim_b);
    quantumSparseMatrix res = product(reshaped_A, reshaped_B);
    return res;
}

// quantumSparseMatrix einsum() {
//     return res;
// }