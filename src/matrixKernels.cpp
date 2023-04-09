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
int getDiagonalLength(int dIndex, std::vector<int> shape) {
    // std::cout << "diag_Index = " << dIndex << " ";
    int lenRes;
    if(dIndex < 0) {
        lenRes = shape[0] + dIndex;
    } else if(dIndex > 0) {
        lenRes = shape[1] - dIndex;
    }  else {
        lenRes = (shape[0] > shape[1])?shape[1]:shape[0];
    }
    if (lenRes > shape[0]) {
        lenRes = shape[0];
    }
    else if(lenRes > shape[1]) {
        lenRes = shape[1];
    }
    // std::cout << "lenRes = " << lenRes << std::endl;
    return lenRes;
}
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
    std::vector<int> res_dims{shapeA[0], shapeB[1]};
    int lenRes = getDiagonalLength(indexA + indexB, res_dims);
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
    // A.print();
    // B.print();
    if(A.shape[1] != B.shape[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    std::vector<int> d{A.shape[0], B.shape[1]};
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
            diagonal diagNew = multiplyDiagonals(A.shape, B.shape, itA->first, itB->first, itA->second, itB->second);
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
    // result->print();
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
    std::vector<int> d{A.shape[0], B.shape[1]};
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
    // TODO: need to re-write for tensor_shape, instead of shape.
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

std::vector<int> modifyTensorShape(std::vector<int> tShape, std::vector<int> axes) {
    std::vector<int> nShape;
    if(axes.size() == 0) {
        for(int i = tShape.size()-1; i >= 0; i--) {
            nShape.push_back(tShape[i]);
        }
    }
    else {
        for(int i = 0; i < axes.size(); i++) {
            nShape.push_back(tShape[axes[i]]);
        }
    }
    return nShape;
}

quantumSparseMatrix transpose(quantumSparseMatrix A, std::vector<int> new_order) {
    // std::cout << "transpose called for " << std::endl;
    // A.print();

    // tranpose of the diagonals
    if(A.tensor_shape.size() == 2) {
        std::vector<int> newShape{A.shape[1], A.shape[0]};
        std::map<int, diagonal> diagMap = A.getDiagonalMap();
        std::map<int, diagonal> newDiagMap;
        std::map<int, diagonal>::iterator it;
        for (it = diagMap.begin(); it != diagMap.end(); it++) {
            int ni = -1 * it->second.getIndex();
            it->second.setIndex(ni);
            newDiagMap.insert({ni, it->second});
        }
        quantumSparseMatrix p(newDiagMap, &newShape, &newShape);
        // std::cout << "transpose result " << std::endl;
        // p.print();
        p.pruneMatrix();
        return p;
    }
    // otherwise
    if(new_order.size() == 0) {
        for(int i = 0; i < A.tensor_shape.size(); i++) {
            new_order.push_back(A.tensor_shape.size()-i-1);
        }
    }
    // std::cout << "with new_order (";
    // for(int i = 0; i < new_order.size()-1; i++)
    //     std::cout << new_order[i] << ",";
    // std::cout << new_order[new_order.size()-1] << ")" << std::endl;
    // shape of result
    std::vector<int> new_tensor_shape = modifyTensorShape(A.tensor_shape, new_order);
    // std::cout << "gives new_tensor_shape (";
    // for(int i = 0; i < new_tensor_shape.size()-1; i++) {
    //     std::cout << new_tensor_shape[i] << ",";
    // }
    // std::cout << new_tensor_shape[new_tensor_shape.size()-1] << ")" << std::endl;
    // now, let's perform the transpose element by element
    int l = new_tensor_shape.size();
    // this shape is important! decides the length of diagonals! Hence, we have to re-write it to maximize length of diagonals, so that number of diagonls are minimized.
    std::vector<int> new_shape{1,1};
    int i = l / 2;
    for(int r = 0; r<i ; r++) {
        new_shape[0] = new_shape[0] * new_tensor_shape[r];
    }
    for(int r = i; r<l ; r++) {
        new_shape[1] = new_shape[1] * new_tensor_shape[r];
    }
    // res matrix/tensor
    std::map<int, diagonal> newDiagMap;
    quantumSparseMatrix res{newDiagMap, &new_shape, &new_tensor_shape};
    // iterate over all diagonals
    std::map<int, diagonal>::iterator it;
    std::map<int, diagonal> diagonalMap = A.getDiagonalMap();
    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        std::vector<std::complex<double> > vals = it->second.getValues();
        for(int i = 0; i < vals.size(); i++) {
            // std::cout << "(diagonal_idx, diagonal_pos) = (" << it->first << ", " << i << ")" << std::endl;
            // std::cout << "element = " << vals[i] << std::endl;
            std::vector<int> ten_pos = A.getTensorPosition(it->first, i);
            // std::cout << "tensor index = (";
            // for(int i = 0; i < ten_pos.size()-1; i++) {
            //     std::cout << ten_pos[i] << ",";
            // }
            // std::cout << ten_pos[ten_pos.size()-1] << ")" << std::endl;

            // modify ten_pos to perform the transposition using the new_order
            std::vector<int> new_ten_pos;
            for(int i=0; i < new_order.size(); i++) {
                new_ten_pos.push_back(ten_pos[new_order[i]]);
            }

            std::vector<int> d_pos = res.getDiagonalPosition(new_ten_pos);
            // std::cout << "(new_diagonal_idx, new_diagonal_pos) = (" << d_pos[0] << ", " << d_pos[1] << ")" << std::endl;
            int d_len = getDiagonalLength(d_pos[0], new_shape);
            res.setDiagonalElement(d_pos[0], d_pos[1], d_len, vals[i]);
            // std::cout << " -- " << std::endl;
        }
    }
    res.pruneMatrix();
    return res;
}

quantumSparseMatrix tensordot(quantumSparseMatrix A, quantumSparseMatrix B, std::vector<std::vector<int> > axes) {
    // std::cout << "--" << std::endl;
    // std::cout << "tensordot called for A - " << std::endl;
    // A.print();
    // std::cout << "and B - " << std::endl;
    // B.print();
    // std::cout << "with axes - " << axes[0][0] << " and " << axes[1][0] << std::endl;
    // std::cout << "--" << std::endl;

    quantumSparseMatrix res = quantumSparseMatrix(0);
    // move axes
    std::vector<int> order_A;
    std::vector<int> order_B{axes[1][0]};
    for(int i=0;i<A.tensor_shape.size();i++) {
        if(i != axes[0][0]) {
            order_A.push_back(i);
        }
    }
    for(int i=0;i<B.tensor_shape.size();i++) {
        if(i != axes[1][0]) {
            order_B.push_back(i);
        }
    }
    order_A.push_back(axes[0][0]);
    // std::cout << "with order_A (";
    // for(int i = 0; i < order_A.size()-1; i++)
    //     std::cout << order_A[i] << ",";
    // std::cout << order_A[order_A.size()-1] << ")" << std::endl;
    // std::cout << "with order_B (";
    // for(int i = 0; i < order_B.size()-1; i++)
    //     std::cout << order_B[i] << ",";
    // std::cout << order_B[order_B.size()-1] << ")" << std::endl;

    A = transpose(A, order_A);
    // A.print();
    B = transpose(B, order_B);
    // B.print();

    int totalA = A.shape[0] * A.shape[1];
    int totalB = B.shape[0] * B.shape[1];
    
    std::vector<int> new_shape_a{totalA / A.tensor_shape[axes[0][0]], A.tensor_shape[axes[0][0]]};
    std::vector<int> new_shape_b{B.tensor_shape[axes[1][0]], totalB / B.tensor_shape[axes[1][0]]};

    quantumSparseMatrix reshaped_A = reshape(A, new_shape_a);
    quantumSparseMatrix reshaped_B = reshape(B, new_shape_b);

    // std::cout << "after reshape A - " << std::endl;
    // reshaped_A.convertToDenseMatrix(reshaped_A.shape).print();
    // std::cout << "and B - " << std::endl;
    // reshaped_B.convertToDenseMatrix(reshaped_B.shape).print();

    res = product(reshaped_A, reshaped_B);

    // calculating result's tensor_shape
    res.tensor_shape = newTensorShape(A.tensor_shape, B.tensor_shape, axes[1][0], axes[0][0]);
    res.pruneMatrix();
    // std::cout << "dot result = " << std::endl;
    // res.print();
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

// overloading operators
quantumSparseMatrix operator*(const quantumSparseMatrix &A, const quantumSparseMatrix &B) {
    return product(A, B);
}
quantumSparseMatrix operator+(const quantumSparseMatrix &A, const quantumSparseMatrix &B) {
    return add(A, B);
}