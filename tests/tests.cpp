
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

std::string checkResult(quantumSparseMatrix A, quantumSparseMatrix B) {
    if(A.getSize() != B.getSize()) {
        A.print();
        return "false";
    }
    std::map<int, diagonal> dmA = A.getDiagonalMap();
    std::map<int, diagonal> dmB = B.getDiagonalMap();
    std::map<int, diagonal>::iterator itA, itB;
    for(itA = dmA.begin(); itA != dmA.end(); itA++) {
        auto itB = dmB.find(itA->first);
        if(itB == dmB.end()) {
            A.print();
            return "false";
        }
        if(itB->second.getValues().size() != itA->second.getValues().size()) { 
            A.print();
            return "false";
        }
        else {
            for(int i = 0; i < itA->second.getValues().size(); i++) {
                if(itB->second.getValue(i) != itA->second.getValue(i)) {
                    A.print();
                    return "false";
                }
            }
        }
    }
    A.print();
    return "true";
}


int main() {
    std::vector<std::vector<quantumSparseMatrix> > testCases;

    // test case 0
    denseMatrix dmA0(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    });
    quantumSparseMatrix qmA0 = dmA0.convertToQuantumSparse(5);
    denseMatrix dmB0(5, {
        2,0,0,0,0,
        0,3,0,0,0,
        0,0,4,0,0,
        0,0,0,5,0,
        0,0,0,0,6,
    });
    quantumSparseMatrix qmB0 = dmB0.convertToQuantumSparse(5);
    denseMatrix dmRes0(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        2,0,0,0,0,
        0,3,0,0,0,
        0,0,4,0,0,
    });
    quantumSparseMatrix qmRes0 = dmRes0.convertToQuantumSparse(5);
    std::vector<quantumSparseMatrix> testCase0;
    testCase0.push_back(qmA0);
    testCase0.push_back(qmB0);
    testCase0.push_back(qmRes0);
    testCases.push_back(testCase0);

    // test case 1
    denseMatrix dmA1(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    });
    quantumSparseMatrix qmA1 = dmA1.convertToQuantumSparse(5);
    denseMatrix dmB1(5, {
        0,0,2,0,0,
        0,0,0,3,0,
        0,0,0,0,4,
        0,0,0,0,0,
        0,0,0,0,0,
    });
    quantumSparseMatrix qmB1 = dmB1.convertToQuantumSparse(5);
    denseMatrix dmRes1(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        0,0,2,0,0,
        0,0,0,3,0,
        0,0,0,0,4,
    });
    quantumSparseMatrix qmRes1 = dmRes1.convertToQuantumSparse(5);
    std::vector<quantumSparseMatrix> testCase1;
    testCase1.push_back(qmA1);
    testCase1.push_back(qmB1);
    testCase1.push_back(qmRes1);
    testCases.push_back(testCase1);


    // test case 2
    denseMatrix dmA2(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    });
    quantumSparseMatrix qmA2 = dmA2.convertToQuantumSparse(5);
    denseMatrix dmB2(5, {
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
        0,0,3,0,0,
        0,0,0,4,0,
    });
    quantumSparseMatrix qmB2 = dmB2.convertToQuantumSparse(5);
    denseMatrix dmRes2(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
    });
    quantumSparseMatrix qmRes2 = dmRes2.convertToQuantumSparse(5);
    std::vector<quantumSparseMatrix> testCase2;
    testCase2.push_back(qmA2);
    testCase2.push_back(qmB2);
    testCase2.push_back(qmRes2);
    testCases.push_back(testCase2);



    // test case 3
    denseMatrix dmA3(5, {
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
        0,0,0,1,0,
    });
    quantumSparseMatrix qmA3 = dmA3.convertToQuantumSparse(5);
    denseMatrix dmB3(5, {
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
        0,0,3,0,0,
        0,0,0,4,0,
    });
    quantumSparseMatrix qmB3 = dmB3.convertToQuantumSparse(5);
    denseMatrix dmRes3(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
        0,0,3,0,0,
    });
    quantumSparseMatrix qmRes3 = dmRes3.convertToQuantumSparse(5);
    std::vector<quantumSparseMatrix> testCase3;
    testCase3.push_back(qmA3);
    testCase3.push_back(qmB3);
    testCase3.push_back(qmRes3);
    testCases.push_back(testCase3);



    // test case 4
    denseMatrix dmA4(5, {
        0,0,1,0,0,
        0,0,0,1,0,
        0,0,0,0,1,
        0,0,0,0,0,
        0,0,0,0,0,
    });
    quantumSparseMatrix qmA4 = dmA4.convertToQuantumSparse(5);
    denseMatrix dmB4(5, {
        2,0,0,0,0,
        0,3,0,0,0,
        0,0,4,0,0,
        0,0,0,5,0,
        0,0,0,0,6,
    });
    quantumSparseMatrix qmB4 = dmB4.convertToQuantumSparse(5);
    denseMatrix dmRes4(5, {
        0,0,4,0,0,
        0,0,0,5,0,
        0,0,0,0,6,
        0,0,0,0,0,
        0,0,0,0,0,
    });
    quantumSparseMatrix qmRes4 = dmRes4.convertToQuantumSparse(5);
    std::vector<quantumSparseMatrix> testCase4;
    testCase4.push_back(qmA4);
    testCase4.push_back(qmB4);
    testCase4.push_back(qmRes4);
    testCases.push_back(testCase4);

    for(int i = 0; i < testCases.size(); i++) {
        std::cout << "test case " << i << " ";
        std::string check = checkResult(product(testCases[i][0], testCases[i][1]), testCases[i][2]);
        std::cout << check << std::endl;
    }
    return 0;
}