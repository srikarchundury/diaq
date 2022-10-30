
#include"denseMatrix.h"
#include"kernels.h"

using namespace std;


map<int, diagonal> testdiagonal() {
    // cout << "Testing diagonal class" << endl;
    diagonal aDiag(0);
    aDiag.addElement(1);
    aDiag.addElement(1);
    aDiag.addElement(1);
    aDiag.addElement(1);
    // aDiag.print(6);

    // anti-diagonal
    diagonal bDiag(9);
    bDiag.addElement(1);
    bDiag.addElement(-1);
    // bDiag.print(6);
    map<int, diagonal> dm;
    dm.insert({0, aDiag});
    dm.insert({9, bDiag});
    return dm;
}

quantumSparseMatrix testQuantumSparseMatrix(map<int, diagonal> dm) {
    quantumSparseMatrix m = quantumSparseMatrix(dm, 6);
    // m.print();
    return m;
}

denseMatrix testDense() {
    denseMatrix dm(6);
    dm.data = {
        1,0,0,0,0,0,
        0,1,0,0,0,0,
        0,0,1,0,0,0,
        0,0,0,1,0,0,
        0,0,0,0,0,1,
        0,0,0,0,-1,0,
    };
    // dm.print();
    return dm;
}

quantumSparseMatrix testConvertToSparse(denseMatrix dm, int matrixSize) {
    return dm.convertToQuantumSparse(matrixSize);
}

quantumSparseMatrix testProducts(quantumSparseMatrix A, quantumSparseMatrix B) {
    return;
}

int main() {
    // map<int, diagonal> dm = testdiagonal();
    // quantumSparseMatrix qm = testQuantumSparseMatrix(dm);
    // qm.print();
    // qm.addToDiagonal(0, 2);
    // qm.print();
    // qm.addToDiagonal(-1, 7);
    // qm.print();
    // qm.addToDiagonal(-1, 8);
    // qm.print();
    // qm.addToDiagonal(-1, 9);
    // qm.print();
    // qm.addToDiagonal(10, 90);
    // qm.print();

    // denseMatrix d = testDense();
    // quantumSparseMatrix qm = testConvertToSparse(d, 6);
    // qm.print();

    quantumSparseMatrix qm = testProducts(qm1, qm2);
    return 0;
}