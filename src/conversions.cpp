#include "denseMatrix.hpp"

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
        for (int i = 0; i < vals.size(); i++) {
            data[ shape[1] * x + y ] = vals[i];
            x++;
            y++;
        }
    }
    denseMatrix d(&new_shape, data);
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
    quantumSparseMatrix qm(diagMap, new_shape);
    for(int i=0; i < shape[0]; i++) {
        for(int j=0; j < shape[1]; j++) {
            int diagIndx = getTargetDiagIndex_onlydiags(i, j);
            // std::cout << "(" << i << "," << j << ")" << " " << diagIndx << std::endl;
            qm.addToDiagonal(diagIndx, data[i * new_shape[1] + j]);
        }
    }
    qm.pruneMatrix();
    return qm;
}