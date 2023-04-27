#include "denseMatrix.hpp"

#include <omp.h>

denseMatrix quantumSparseMatrix::convertToDenseMatrix(std::vector<int> new_shape) {
    float *real_data = (float *)malloc(shape[0] * shape[1] * sizeof(float));
    float *imag_data = (float *)malloc(shape[0] * shape[1] * sizeof(float));
    std::map<int, diagonal>::iterator it;
    int x, y;
    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        float *real_vals = it->second.getRealValues();
        float *imag_vals = it->second.getImagValues();
        if (it->first == 0) {
            x = 0;
            y = 0;
        }
        else if (it->first > 0) {
            x = 0;
            y = it->first;
        }
        else {
            x = -1 * it->first;
            y = 0;
        }
        for (int i = 0; i < it->second.dLength; i++) {
            real_data[ shape[1] * x + y ] = real_vals[i];
            imag_data[ shape[1] * x + y ] = imag_vals[i];
            x++;
            y++;
        }
    }
    denseMatrix d(&new_shape, real_data, imag_data);
    denseMatrix d(&new_shape, data);
    d.tensor_shape = tensor_shape;
    return d;
}

quantumSparseMatrix denseMatrix::convertToQuantumSparse(std::vector<int> new_shape) {
    // counting the number of diagonals in a matrix that isn't a perfect square.
    // int s = 0;
    // for(int i = 0; i < new_shape.size(); i++) {
    //     s = s + new_shape[i];
    // }
    // std::cout << "converting dense to sparse" << std::endl;
    std::map<int, diagonal> diagMap;    
    quantumSparseMatrix qm(diagMap, &new_shape);
    for(int i = -1 * qm.shape[0]; i < qm.shape[1]; i++) {
        qm.createDiagonal(i);
    }
    for(int i = 0; i < shape[0]; i++) {
        for(int j = 0; j < shape[1]; j++) {
            // std::cout << "In thread: " << omp_get_thread_num() << std::endl;
            std::vector<int> pos{i, j};
            std::vector<int> d_pos = qm.getDiagonalPosition(pos);
            // std::cout << "(" << i << "," << j << ")" << " " << d_pos[0] << " at pos " << d_pos[1] << std::endl;
            qm.setDiagonalElement(d_pos[0], d_pos[1], qm.getDiagonalLength(d_pos[0]), realData[i * new_shape[1] + j], imagData[i * new_shape[1] + j]);
        }
    }
    qm.pruneMatrix();
    qm.tensor_shape = tensor_shape;
    return qm;
}

// conversion from numpy to our format
quantumSparseMatrix from_numpy(std::vector<std::complex<float>> vals, std::vector<int> shape) {
    float *real_vals = (float *)malloc(vals.size() * sizeof(float));
    float *imag_vals = (float *)malloc(vals.size() * sizeof(float));
    for(int i = 0; i < vals.size(); i++) {
        real_vals[i] = vals[i].real();
        imag_vals[i] = vals[i].imag();
    }
    int l = shape.size();
    if(l>2) {
        std::vector<int> orig_shape = shape;
        l = shape.size();
        std::vector<int> new_shape{1,1};
        int i = l / 2;
        #pragma unroll
        for(int r = 0; r < i ; r++) {
            new_shape[0] = new_shape[0] * shape[r];
        }
        #pragma unroll
        for(int r = i; r < l ; r++) {
            new_shape[1] = new_shape[1] * shape[r];
        }
        return denseMatrix(&new_shape, real_vals, imag_vals, &orig_shape).convertToQuantumSparse(new_shape);
    }
    else {
        return denseMatrix(&shape, real_vals, imag_vals, &shape).convertToQuantumSparse(shape);
    }
}

std::complex<float> *to_numpy(quantumSparseMatrix A) {
    return A.convertToDenseMatrix(A.shape).getData();
}