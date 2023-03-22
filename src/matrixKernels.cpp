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
diagonal multiplyDiagonals(std::vector<int> shapeA, std::vector<int> shapeB, int indexA, int indexB, diagonal diagA, diagonal diagB) {
    std::vector<std::complex<double> > valuesA = diagA.getValues();
    std::vector<std::complex<double> > valuesB = diagB.getValues();
    if(indexA + indexB >= shapeB[1]) {
        return diagonal(0);
    }
    else if(indexA + indexB <= -1 * shapeA[0]) {
        return diagonal(0);
    }
    diagonal res(indexA + indexB);
    int lenDiagA = diagA.getSize();
    int lenDiagB = diagB.getSize();
    // result matrix has dimensions {shapeA[0], shapeB[1]}
    // TODO
    int lenRes;
    if(indexA + indexB < 0) {
        lenRes = shapeA[0] + indexA + indexB;
    } else if(indexA + indexB > 0) {
        lenRes = shapeB[1] - indexA - indexB;
    }  else {
        lenRes = (shapeA[0] > shapeB[1])?shapeB[1]:shapeA[0];
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
                    // jump = abs(indexA) - abs(shapeA[0] - shapeB[1]);
                    jump = abs(indexB);
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
    // std::cout << "lenRes,jump,offsetA,offsetB " << lenRes << "," << jump << "," << offsetA << "," << offsetB << std::endl;
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
            diagonal diagNew = multiplyDiagonals(A.getShape(), B.getShape(), itA->first, itB->first, itA->second, itB->second);
            if(diagNew.getValues().size() != 0 && !diagNew.isEmpty()) {
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
    std::vector<int> shape_a = A.shape;
    std::vector<int> shape_b = B.shape;
    if(shape_a[1] != shape_b[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    std::vector<std::complex<double>> resArray;
    for(int i = 0; i < shape_a[0] * shape_b[1]; i++) {
        resArray.push_back(0);
    }
    std::vector<int> d{A.getDim(0), B.getDim(1)};
    denseMatrix result(&d, resArray);
    for(int i = 0; i < shape_a[0]; i++) {
        for(int k = 0; k < shape_b[1]; k++) {
            std::complex<double> res = 0.0;
            for(int j = 0; j < shape_b[0]; j++) {
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

quantumSparseMatrix reshape(quantumSparseMatrix A, std::vector<int> shape) {
    // TODO: redo this without denseMatrix conversion in between.
    denseMatrix d = A.convertToDenseMatrix(shape);
    return d.convertToQuantumSparse(shape);
}

std::vector<int> newTensorShape(std::vector<int> tensor_shape_A, std::vector<int> tensor_shape_B, int axis_A, int axis_B) {
    std::vector<int> res;
    for(int i = 0; i < tensor_shape_A.size(); i++) {
        if(i != axis_A) {
            res.push_back(tensor_shape_A[i]);
        }
    }
    for(int i = 0; i < tensor_shape_B.size(); i++) {
        if(i != axis_B) {
            res.push_back(tensor_shape_B[i]);
        }
    }
    return res;
}

quantumSparseMatrix transpose(quantumSparseMatrix A, std::vector<int> axes) {
    // std::cout << "transpose called for A - " << std::endl;
    // A.print();
    // std::cout << "with axes - ";
    // for(int i = 0; i < axes.size(); i++)
    //     std::cout << axes[i] << " ";
    // std::cout << std::endl;
    // transpose -> sign switch all diagonals
    // TODO: switch according to the given axes? -- confused here
    std::map<int, diagonal> diagMap = A.getDiagonalMap();
    std::map<int, diagonal> newDiagMap;
    std::map<int, diagonal>::iterator it;
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        int ni = -1 * it->second.getIndex();
        it->second.setIndex(ni);
        newDiagMap.insert({ni, it->second});
    }
    std::vector<int> newShape{A.shape[1], A.shape[0]};
    return quantumSparseMatrix(newDiagMap, newShape, A.tensor_shape);
}

quantumSparseMatrix tensordot(quantumSparseMatrix A, quantumSparseMatrix B, std::vector<std::vector<int> > axes) {
    std::cout << "--" << std::endl;
    std::cout << "tensordot called for A - " << std::endl;
    A.print();
    std::cout << "and B - " << std::endl;
    B.print();
    std::cout << "with axes - " << axes[0][0] << " and " << axes[1][0] << std::endl;
    std::cout << "--" << std::endl;

    quantumSparseMatrix res = quantumSparseMatrix(0);

    /* calculate tensordot - 1*/
    int totalA = A.shape[0] * A.shape[1];
    int totalB = B.shape[0] * B.shape[1];
    
    std::vector<int> new_shape_a{totalA / A.tensor_shape[axes[0][0]], A.tensor_shape[axes[0][0]]};
    std::vector<int> new_shape_b{B.tensor_shape[axes[1][0]], totalB / B.tensor_shape[axes[1][0]]};
    // std::vector<int> new_shape_a{A.tensor_shape[axes[0][0]], totalA / A.tensor_shape[axes[0][0]]};
    // std::vector<int> new_shape_b{totalB / B.tensor_shape[axes[1][0]], B.tensor_shape[axes[1][0]]};

    // permute first

    quantumSparseMatrix reshaped_A = reshape(A, new_shape_a);
    quantumSparseMatrix reshaped_B = reshape(B, new_shape_b);

    // std::cout << "after reshape A - " << std::endl;
    // reshaped_A.convertToDenseMatrix(reshaped_A.shape).print();
    // std::cout << "and B - " << std::endl;
    // reshaped_B.convertToDenseMatrix(reshaped_B.shape).print();

    // reshaped_A = transpose(reshaped_A, axes[0]);
    // reshaped_B = transpose(reshaped_B, axes[1]);

    res = product(reshaped_A, reshaped_B);
    /* calculate tensordot*/

    /* calculate tensordot - 2*/
    // std::vector<int> new_shape_a{A.tensor_shape[0], A.tensor_shape[1]};
    // std::vector<int> new_shape_b{B.tensor_shape[0], B.tensor_shape[1]};
    // if(new_shape_a[1] < new_shape_b[0]) {
    //     while(new_shape_a[1] < new_shape_b[0]) {
    //         if(new_shape_b[0] == 0) {
    //             throw std::invalid_argument("not possible");
    //         }
    //         new_shape_b[0] = new_shape_b[0] / 2;
    //         new_shape_b[1] = new_shape_b[1] * 2;
    //     }
    //     res = product(reshape(A, new_shape_a), reshape(B, new_shape_b));
    // }
    // else if(new_shape_a[1] > new_shape_b[0]) {
    //     while(new_shape_a[1] != new_shape_b[0]) {
    //         if(new_shape_a[1] == 0) {
    //             throw std::invalid_argument("not possible");
    //         }
    //         new_shape_a[1] = new_shape_a[1] / 2;
    //         new_shape_a[0] = new_shape_a[0] * 2;
    //     }
    //     res = product(reshape(A, new_shape_a), reshape(B, new_shape_b));
    // }
    // else {
    //     res = product(A,B);
    // }
    /* calculate tensordot*/

    res.tensor_shape = newTensorShape(A.tensor_shape, B.tensor_shape, axes[0][0], axes[1][0]);
    return res;
}

quantumSparseMatrix array(quantumSparseMatrix A) {
    // std::cout << "array called for A - " << std::endl;
    // A.print();
    return A;
}

quantumSparseMatrix einsum(quantumSparseMatrix A, std::vector<int> axes) {
    return A;
}