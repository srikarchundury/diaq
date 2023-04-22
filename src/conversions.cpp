#include "denseMatrix.hpp"

#include <omp.h>

denseMatrix quantumSparseMatrix::convertToDenseMatrix(std::vector<int> new_shape) {
    std::vector<std::complex<double>> data(denseCapacity());
    std::map<int, diagonal>::iterator it;
    int x, y;
    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        std::vector<std::complex<double> > vals = it->second.getValues();
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
        #pragma omp parallel for
        for (int i = 0; i < vals.size(); i++) {
            data[ shape[1] * x + y ] = vals[i];
            x++;
            y++;
        }
    }
    #pragma omp barrier
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
    #pragma omp parallel for
    for(int i = -1 * qm.shape[0]; i < qm.shape[1]; i++) {
        std::vector<std::complex<double> > vals(qm.getDiagonalLength(i), 0);
        diagonal newDiag(i, &vals);
        #pragma omp critical
        qm.setDiagonal(i, newDiag);
    }
    #pragma omp barrier
    for(int i = 0; i < shape[0]; i++) {
        #pragma omp parallel for
        for(int j = 0; j < shape[1]; j++) {
            // std::cout << "In thread: " << omp_get_thread_num() << std::endl;
            std::vector<int> pos{i, j};
            std::vector<int> d_pos = qm.getDiagonalPosition(pos);
            // std::cout << "(" << i << "," << j << ")" << " " << d_pos[0] << " at pos " << d_pos[1] << std::endl;
            // #pragma omp critical
            qm.setDiagonalElement(d_pos[0], d_pos[1], qm.getDiagonalLength(d_pos[0]), data[i * new_shape[1] + j]);
        }
    }
    #pragma omp barrier
    qm.pruneMatrix();
    qm.tensor_shape = tensor_shape;
    return qm;
}

// conversion from numpy to our format
quantumSparseMatrix from_numpy(std::vector<std::complex<double>> vals, std::vector<int> shape) {
    int l = shape.size();
    if(l>2) {
        std::vector<int> orig_shape = shape;
        // if(l%2 != 0 && shape[l/2]%2 == 0) {
        //     shape.push_back(1);
        //     int k = l / 2;
        //     for(int i = k+2; i < shape.size() ; i++) {
        //         shape[i] = shape[i-1];
        //     }
        //     shape[k] = shape[k] / 2;
        //     shape[k+1] = shape[k];
        // }
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
        return denseMatrix(&new_shape, vals, &orig_shape).convertToQuantumSparse(new_shape);
    }
    else {
        return denseMatrix(&shape, vals, &shape).convertToQuantumSparse(shape);
    }
}

std::vector<std::complex<double>> to_numpy(quantumSparseMatrix A) {
    return A.convertToDenseMatrix(A.shape).getData();
}