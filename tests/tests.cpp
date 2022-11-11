
#include "../include/denseMatrix.hpp"
#include "../include/matrixKernels.cpp"


std::map<int, diagonal> testdiagonal() {
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
    std::map<int, diagonal> dm;
    dm.insert({0, aDiag});
    dm.insert({9, bDiag});
    return dm;
}

quantumSparseMatrix testQuantumSparseMatrix(std::map<int, diagonal> dm) {
    quantumSparseMatrix m = quantumSparseMatrix(dm, 6);
    m.print();
    return m;
}

int main() {
    // std::map<int, diagonal> dm = testdiagonal();
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

    // dense tests
    denseMatrix dmA(6, {
        1,0,0,0,0,0,
        1,1,0,0,0,0,
        0,1,1,0,0,0,
        0,0,1,1,0,0,
        0,0,0,1,1,0,
        0,0,0,0,1,1,
    });
    // dmA.print();
    quantumSparseMatrix qmA = dmA.convertToQuantumSparse(6);
    qmA.print();
    std::cout << "multiplied with" << std::endl;
    denseMatrix dmB(6, {
        1,0,0,0,0,0,
        7,2,0,0,0,0,
        0,8,3,0,0,0,
        0,0,9,4,0,0,
        0,0,0,10,5,0,
        0,0,0,0,11,6,
    });
    // dmB.print();
    quantumSparseMatrix qmB = dmB.convertToQuantumSparse(6);
    qmB.print();
    std::cout << "gives" << std::endl;
    // testing product
    product(qmA, qmB).print();

    return 0;
}