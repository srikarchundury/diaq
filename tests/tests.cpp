
#include "../include/qSparse.hpp"


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
        // A.print();
        return "false - 1";
    }
    std::map<int, diagonal> dmA = A.getDiagonalMap();
    std::map<int, diagonal> dmB = B.getDiagonalMap();
    std::map<int, diagonal>::iterator itA, itB;
    for(itA = dmA.begin(); itA != dmA.end(); itA++) {
        auto itB = dmB.find(itA->first);
        if(itB == dmB.end()) {
            // A.print();
            return "false - 2";
        }
        if(itB->second.getValues().size() != itA->second.getValues().size()) { 
            // A.print();
            std::cout << "error with diag idx - " << itA->second.getIndex() << std::endl;
            return "false - 3";
        }
        else {
            for(int i = 0; i < itA->second.getValues().size(); i++) {
                if(itB->second.getValue(i) != itA->second.getValue(i)) {
                    // A.print();
                    std::cout << "error with diag idx - " << itA->second.getIndex() << std::endl;
                    return "false - 4";
                }
            }
        }
    }
    // A.print();
    return "true";
}


int main() {
    std::vector<std::vector<denseMatrix> > testCases;

    // test case 0
    denseMatrix A0(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    });
    denseMatrix B0(5, {
        2,0,0,0,0,
        0,3,0,0,0,
        0,0,4,0,0,
        0,0,0,5,0,
        0,0,0,0,6,
    });
    std::vector<denseMatrix> testCase0;
    testCase0.push_back(A0);
    testCase0.push_back(B0);
    testCases.push_back(testCase0);

    // test case 1
    denseMatrix A1(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    });
    denseMatrix B1(5, {
        0,0,2,0,0,
        0,0,0,3,0,
        0,0,0,0,4,
        0,0,0,0,0,
        0,0,0,0,0,
    });
    std::vector<denseMatrix> testCase1;
    testCase1.push_back(A1);
    testCase1.push_back(B1);
    testCases.push_back(testCase1);


    // test case 2
    denseMatrix A2(5, {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    });
    denseMatrix B2(5, {
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
        0,0,3,0,0,
        0,0,0,4,0,
    });
    std::vector<denseMatrix> testCase2;
    testCase2.push_back(A2);
    testCase2.push_back(B2);
    testCases.push_back(testCase2);



    // test case 3
    denseMatrix A3(5, {
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
        0,0,0,1,0,
    });
    denseMatrix B3(5, {
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
        0,0,3,0,0,
        0,0,0,4,0,
    });
    std::vector<denseMatrix> testCase3;
    testCase3.push_back(A3);
    testCase3.push_back(B3);
    testCases.push_back(testCase3);



    // test case 4
    denseMatrix A4(5, {
        0,0,1,0,0,
        0,0,0,1,0,
        0,0,0,0,1,
        0,0,0,0,0,
        0,0,0,0,0,
    });
    denseMatrix B4(5, {
        2,0,0,0,0,
        0,3,0,0,0,
        0,0,4,0,0,
        0,0,0,5,0,
        0,0,0,0,6,
    });
    std::vector<denseMatrix> testCase4;
    testCase4.push_back(A4);
    testCase4.push_back(B4);
    testCases.push_back(testCase4);


    // test case 5 - GHZ 3 qubit unitary simulation
    denseMatrix A5(8, {
        1,0,0,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
        0,0,1,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,1,0,
        0,0,0,0,0,1,0,0,
    });
    denseMatrix B5(8, {
        1,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,0,0,1,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,1,0,0,
        0,0,1,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
    });
    std::vector<denseMatrix> testCase5;
    testCase5.push_back(A5);
    testCase5.push_back(B5);
    testCases.push_back(testCase5);


    // test case 6
    denseMatrix A6(8, {
        1,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,1,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    });
    denseMatrix B6(8, {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,1,0,0,
    });
    std::vector<denseMatrix> testCase6;
    testCase6.push_back(A6);
    testCase6.push_back(B6);
    testCases.push_back(testCase6);


    // test case 7
    denseMatrix A7(8, {
        0,0,2,0,0,0,0,0,
        0,0,0,3,0,0,0,0,
        0,0,0,0,4,0,0,0,
        0,0,0,0,0,5,0,0,
        0,0,0,0,0,0,6,0,
        0,0,0,0,0,0,0,7,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    });
    denseMatrix B7(8, {
        0,0,0,0,8,0,0,0,
        0,0,0,0,0,9,0,0,
        0,0,0,0,0,0,10,0,
        0,0,0,0,0,0,0,11,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    });
    std::vector<denseMatrix> testCase7;
    testCase7.push_back(A7);
    testCase7.push_back(B7);
    testCases.push_back(testCase7);


    // test case 8
    denseMatrix A8(8, {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        2,0,0,0,0,0,0,0,
        0,3,0,0,0,0,0,0,
        0,0,4,0,0,0,0,0,
        0,0,0,5,0,0,0,0,
        0,0,0,0,6,0,0,0,
        0,0,0,0,0,7,0,0,
    });
    denseMatrix B8(8, {
        8,0,0,0,0,0,0,0,
        0,9,0,0,0,0,0,0,
        0,0,10,0,0,0,0,0,
        0,0,0,11,0,0,0,0,
        0,0,0,0,12,0,0,0,
        0,0,0,0,0,13,0,0,
        0,0,0,0,0,0,14,0,
        0,0,0,0,0,0,0,15,
    });
    std::vector<denseMatrix> testCase8;
    testCase8.push_back(A8);
    testCase8.push_back(B8);
    testCases.push_back(testCase8);

    // test case 9
    denseMatrix A9(8, {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
    });
    denseMatrix B9(8, {
        0,0,5,0,0,0,0,0,
        0,0,0,6,0,0,0,0,
        0,0,0,0,7,0,0,0,
        0,0,0,0,0,8,0,0,
        0,0,0,0,0,0,9,0,
        0,0,0,0,0,0,0,10,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    });
    std::vector<denseMatrix> testCase9;
    testCase9.push_back(A9);
    testCase9.push_back(B9);
    testCases.push_back(testCase9);


    // test case 10
    denseMatrix A10(8, {
        0,0,1,0,0,0,0,0,
        0,0,0,2,0,0,0,0,
        0,0,0,0,3,0,0,0,
        0,0,0,0,0,4,0,0,
        0,0,0,0,0,0,5,0,
        0,0,0,0,0,0,0,6,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    });
    denseMatrix B10(8, {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        7,0,0,0,0,0,0,0,
        0,8,0,0,0,0,0,0,
        0,0,9,0,0,0,0,0,
        0,0,0,10,0,0,0,0,
    });
    std::vector<denseMatrix> testCase10;
    testCase10.push_back(A10);
    testCase10.push_back(B10);
    testCases.push_back(testCase10);


    // test case 11
    denseMatrix A11(8, {
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
        0,0,0,0,5,0,0,0,
        0,0,0,0,0,6,0,0,
        0,0,0,0,0,0,7,0,
        0,0,0,0,0,0,0,8,
    });
    denseMatrix B11(8, {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        9,0,0,0,0,0,0,0,
        0,10,0,0,0,0,0,0,
        0,0,11,0,0,0,0,0,
        0,0,0,12,0,0,0,0,
    });
    std::vector<denseMatrix> testCase11;
    testCase11.push_back(A11);
    testCase11.push_back(B11);
    testCases.push_back(testCase11);


    // test case 12
    denseMatrix A12(8, {
        1,0,0,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
        0,0,1,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,1,0,
        0,0,0,0,0,1,0,0,
    });
    denseMatrix B12(8, {
        1,0,0,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
        0,0,1,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,1,0,
        0,0,0,0,0,1,0,0,
    });
    std::vector<denseMatrix> testCase12;
    testCase12.push_back(A12);
    testCase12.push_back(B12);
    testCases.push_back(testCase12);


    // test case 13
    denseMatrix A13(8, {
        0,0,1,0,0,0,0,0,
        0,0,0,2,0,0,0,0,
        0,0,0,0,3,0,0,0,
        0,0,0,0,0,4,0,0,
        0,0,0,0,0,0,5,0,
        0,0,0,0,0,0,0,6,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    });
    denseMatrix B13(8, {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        7,0,0,0,0,0,0,0,
        0,8,0,0,0,0,0,0,
        0,0,9,0,0,0,0,0,
        0,0,0,10,0,0,0,0,
        0,0,0,0,11,0,0,0,
        0,0,0,0,0,12,0,0,
    });
    std::vector<denseMatrix> testCase13;
    testCase13.push_back(A13);
    testCase13.push_back(B13);
    testCases.push_back(testCase13);


    // test case 14
    denseMatrix A14(16, {
        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,
        0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,
        0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,
    });
    denseMatrix B14(16, {
        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,
    });
    std::vector<denseMatrix> testCase14;
    testCase14.push_back(A14);
    testCase14.push_back(B14);
    testCases.push_back(testCase14);

    
    denseMatrix A15(16, {
        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,11,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,14,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,
    });
    denseMatrix B15(16, {
        0,0,17,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,18,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,19,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,21,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,22,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,23,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,24,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,25,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,26,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,27,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,28,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,29,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    });
    std::vector<denseMatrix> testCase15;
    testCase15.push_back(A15);
    testCase15.push_back(B15);
    testCases.push_back(testCase15);


    denseMatrix A16(16, {
        0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    });
    denseMatrix B16(16, {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,17,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,18,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,19,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,21,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,22,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,23,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,24,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,25,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,26,0,0,
    });
    std::vector<denseMatrix> testCase16;
    testCase16.push_back(A16);
    testCase16.push_back(B16);
    testCases.push_back(testCase16);

    denseMatrix A17(8, {
        1,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,1,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
        0,0,0,0,0,1,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,1,0,
    });
    denseMatrix B17(8, {
        2,3,0,0,0,0,0,0,
        0,0,0,0,0,0,3,2,
        0,0,2,3,0,0,0,0,
        0,0,0,0,3,2,0,0,
        0,0,0,0,2,3,0,0,
        0,0,3,2,0,0,0,0,
        0,0,0,0,0,0,2,3,
        3,2,0,0,0,0,0,0,
    });
    std::vector<denseMatrix> testCase17;
    testCase17.push_back(A17);
    testCase17.push_back(B17);
    testCases.push_back(testCase17);


    denseMatrix A18(8, {
        0,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
        0,0,0,0,5,0,0,0,
        0,0,0,0,0,6,0,0,
        0,0,0,0,0,0,7,0,
    });
    denseMatrix B18(8, {
        0,0,0,0,0,0,8,0,
        0,0,0,0,0,0,0,9,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    });
    std::vector<denseMatrix> testCase18;
    testCase18.push_back(A18);
    testCase18.push_back(B18);
    testCases.push_back(testCase18);

    denseMatrix A19(8, {
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,2,0,0,
        0,0,0,0,0,0,3,0,
        0,0,0,0,0,0,0,4,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    });
    denseMatrix B19(8, {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        5,0,0,0,0,0,0,0,
        0,6,0,0,0,0,0,0,
        0,0,7,0,0,0,0,0,
        0,0,0,8,0,0,0,0,
    });
    std::vector<denseMatrix> testCase19;
    testCase19.push_back(A19);
    testCase19.push_back(B19);
    testCases.push_back(testCase19);


    denseMatrix A20(8, {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
    });
    denseMatrix B20(8, {
        9,0,0,0,0,0,0,0,
        0,10,0,0,0,0,0,0,
        0,0,11,0,0,0,0,0,
        0,0,0,12,0,0,0,0,
        0,0,0,0,13,0,0,0,
        0,0,0,0,0,14,0,0,
        0,0,0,0,0,0,15,0,
        0,0,0,0,0,0,0,16,
    });
    std::vector<denseMatrix> testCase20;
    testCase20.push_back(A20);
    testCase20.push_back(B20);
    testCases.push_back(testCase20);


    denseMatrix A21(8, {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
    });
    denseMatrix B21(8, {
        0,0,0,0,5,0,0,0,
        0,0,0,0,0,6,0,0,
        0,0,0,0,0,0,7,0,
        0,0,0,0,0,0,0,8,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    });
    std::vector<denseMatrix> testCase21;
    testCase21.push_back(A21);
    testCase21.push_back(B21);
    testCases.push_back(testCase21);


    denseMatrix A22(8, {
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
        0,0,0,0,0,5,0,0,
        0,0,0,0,6,0,0,0,
        0,0,0,0,0,0,0,7,
        0,0,0,0,0,0,8,0,
    });
    denseMatrix B22(8, {
        9,10,0,0,0,0,0,0,
        0,0,0,0,0,0,11,12,
        0,0,13,14,0,0,0,0,
        0,0,0,0,15,16,0,0,
        0,0,0,0,17,18,0,0,
        0,0,19,20,0,0,0,0,
        0,0,0,0,0,0,21,22,
        23,24,0,0,0,0,0,0,
    });
    std::vector<denseMatrix> testCase22;
    testCase22.push_back(A22);
    testCase22.push_back(B22);
    testCases.push_back(testCase22);


    denseMatrix A23(8, {
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,0,0,0,0,3,0,
        0,0,0,0,0,0,0,4,
        0,0,0,0,5,0,0,0,
        0,0,0,0,0,6,0,0,
        0,0,7,0,0,0,0,0,
        0,0,0,8,0,0,0,0,
    });
    denseMatrix B23(8, {
        9,10,0,0,0,0,0,0,
        0,0,0,0,0,0,11,12,
        0,0,0,0,0,0,13,14,
        15,16,0,0,0,0,0,0,
        0,0,0,0,17,18,0,0,
        0,0,19,20,0,0,0,0,
        0,0,21,22,0,0,0,0,
        0,0,0,0,23,24,0,0,
    });
    std::vector<denseMatrix> testCase23;
    testCase23.push_back(A23);
    testCase23.push_back(B23);
    testCases.push_back(testCase23);

    for(int i = 0; i < testCases.size(); i++) {
        // if(i == 20) {
            std::cout << "test case " << i << std::endl;
            denseMatrix p = denseProduct(testCases[i][0], testCases[i][1]);
            // p.print();
            // std::cout << " --- " << std::endl;
            quantumSparseMatrix dp = p.convertToQuantumSparse();
            // dp.print();
            // std::cout << " --- " << std::endl;
            quantumSparseMatrix qp = product(testCases[i][0].convertToQuantumSparse(), testCases[i][1].convertToQuantumSparse());
            // qp.print();
            std::string check = checkResult(dp, qp);
            std::cout << check << std::endl;
        // }
    }
    return 0;
}