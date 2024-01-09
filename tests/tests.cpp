#include <cstring>
#include <cstdlib>
#include <string>

#include "../include/diaq.hpp"

diaq::diaQMatrix testQuantumSparseMatrix(std::map<long int, diaq::diagonal> dm) {
    diaq::diaQMatrix m = diaq::diaQMatrix(dm, 6);
    m.print();
    return m;
}

std::string checkResult(diaq::diaQMatrix A, diaq::diaQMatrix B) {
    if(A.getSize() != B.getSize()) {
        // A.print();
        return "false - 1";
    }
    const diaq::valType epsilon = 0.00002;
    std::map<long int, diaq::diagonal> dmA = A.getDiagonalMap();
    std::map<long int, diaq::diagonal> dmB = B.getDiagonalMap();
    std::map<long int, diaq::diagonal>::iterator itA, itB;
    for(itA = dmA.begin(); itA != dmA.end(); itA++) {
        auto itB = dmB.find(itA->first);
        if(itB == dmB.end()) {
            // A.print();
            return "false - 2";
        }
        if(itB->second.dLength != itA->second.dLength) { 
            // A.print();
            // std::cout << "error with diag idx - " << itA->second.getIndex() << std::endl;
            return "false - 3";
        }
        else {
            for(long int i = 0; i < itA->second.dLength; i++) {
                if(itB->second.getRealValue(i) - itA->second.getRealValue(i) > epsilon) {
                    return "false - 4";
                }
                if(itB->second.getImagValue(i) - itA->second.getImagValue(i) > epsilon) {
                    return "false - 5";
                }
            }
        }
    }
    // A.print();
    return "true";
}

void kron_test(diaq::denseMatrix A24, diaq::denseMatrix B24) {
        A24.print();
        std::cout << " -- " << std::endl;
        diaq::diaQMatrix q_A24 = A24.convertToQuantumSparse(A24.matrix_shape);
        q_A24.print();
        std::cout << " -- " << std::endl;
        B24.print();
        std::cout << " -- " << std::endl;
        diaq::diaQMatrix q_B24 = B24.convertToQuantumSparse(B24.matrix_shape);
        q_B24.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- dense kron product -- " << std::endl;
        diaq::denseMatrix p = diaq::dense_kron_product(A24, B24);
        p.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- correct answer -- " << std::endl;
        diaq::diaQMatrix dp = p.convertToQuantumSparse(p.matrix_shape);
        dp.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- sparse kron product -- " << std::endl;
        diaq::diaQMatrix res = kron_product(q_A24, q_B24);
        res.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Kron Product check -- " << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << checkResult(dp, res) << std::endl;
        std::cout << " -- " << std::endl;
}

int main(int argc, char **argv) {
    std::vector<std::vector<diaq::denseMatrix> > testCases;

    // test case 0
    diaq::valType a0[25] = {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    };
    diaq::denseMatrix A0(5, a0);
    diaq::valType b0[25] = {
        2,0,0,0,0,
        0,3,0,0,0,
        0,0,4,0,0,
        0,0,0,5,0,
        0,0,0,0,6,
    };
    diaq::denseMatrix B0(5, b0);
    std::vector<diaq::denseMatrix> testCase0;
    testCase0.push_back(A0);
    testCase0.push_back(B0);
    testCases.push_back(testCase0);

    // // test case 1
    diaq::valType a1[25] = {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    };
    diaq::denseMatrix A1(5, a1);
    diaq::valType b1[25] = {
        0,0,2,0,0,
        0,0,0,3,0,
        0,0,0,0,4,
        0,0,0,0,0,
        0,0,0,0,0,
    };
    diaq::denseMatrix B1(5, b1);
    std::vector<diaq::denseMatrix> testCase1;
    testCase1.push_back(A1);
    testCase1.push_back(B1);
    testCases.push_back(testCase1);


    // test case 2
    diaq::valType a2[25] = {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    };
    diaq::denseMatrix A2(5, a2);
    diaq::valType b2[25] = {
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
        0,0,3,0,0,
        0,0,0,4,0,
    };
    diaq::denseMatrix B2(5, b2);
    std::vector<diaq::denseMatrix> testCase2;
    testCase2.push_back(A2);
    testCase2.push_back(B2);
    testCases.push_back(testCase2);


    // test case 3
    diaq::valType a3[25] = {
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
        0,0,0,1,0,
    };
    diaq::denseMatrix A3(5, a3);
    diaq::valType b3[25] = {
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
        0,0,3,0,0,
        0,0,0,4,0,
    };
    diaq::denseMatrix B3(5, b3);
    std::vector<diaq::denseMatrix> testCase3;
    testCase3.push_back(A3);
    testCase3.push_back(B3);
    testCases.push_back(testCase3);



    // test case 4
    diaq::valType a4[25] = {
        0,0,1,0,0,
        0,0,0,1,0,
        0,0,0,0,1,
        0,0,0,0,0,
        0,0,0,0,0,
    };
    diaq::denseMatrix A4(5, a4);
    diaq::valType b4[25] = {
        2,0,0,0,0,
        0,3,0,0,0,
        0,0,4,0,0,
        0,0,0,5,0,
        0,0,0,0,6,
    };
    diaq::denseMatrix B4(5, b4);
    std::vector<diaq::denseMatrix> testCase4;
    testCase4.push_back(A4);
    testCase4.push_back(B4);
    testCases.push_back(testCase4);


    // test case 5 - GHZ 3 qubit unitary simulation
    diaq::valType a5[64] = {
        1,0,0,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
        0,0,1,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,1,0,
        0,0,0,0,0,1,0,0,
    };
    diaq::denseMatrix A5(8, a5);
    diaq::valType b5[64] = {
        1,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,0,0,1,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,1,0,0,
        0,0,1,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
    };
    diaq::denseMatrix B5(8, b5);
    std::vector<diaq::denseMatrix> testCase5;
    testCase5.push_back(A5);
    testCase5.push_back(B5);
    testCases.push_back(testCase5);


    // test case 6
    diaq::valType a6[64] = {
        1,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,1,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix A6(8, a6);
    diaq::valType b6[64] = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,1,0,0,
    };
    diaq::denseMatrix B6(8, b6);
    std::vector<diaq::denseMatrix> testCase6;
    testCase6.push_back(A6);
    testCase6.push_back(B6);
    testCases.push_back(testCase6);


    // test case 7
    diaq::valType a7[64] = {
        0,0,2,0,0,0,0,0,
        0,0,0,3,0,0,0,0,
        0,0,0,0,4,0,0,0,
        0,0,0,0,0,5,0,0,
        0,0,0,0,0,0,6,0,
        0,0,0,0,0,0,0,7,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix A7(8, a7);
    diaq::valType b7[64] = {
        0,0,0,0,8,0,0,0,
        0,0,0,0,0,9,0,0,
        0,0,0,0,0,0,10,0,
        0,0,0,0,0,0,0,11,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B7(8, b7);
    std::vector<diaq::denseMatrix> testCase7;
    testCase7.push_back(A7);
    testCase7.push_back(B7);
    testCases.push_back(testCase7);


    // test case 8
    diaq::valType a8[64] = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        2,0,0,0,0,0,0,0,
        0,3,0,0,0,0,0,0,
        0,0,4,0,0,0,0,0,
        0,0,0,5,0,0,0,0,
        0,0,0,0,6,0,0,0,
        0,0,0,0,0,7,0,0,
    };
    diaq::denseMatrix A8(8, a8);
    diaq::valType b8[64] = {
        8,0,0,0,0,0,0,0,
        0,9,0,0,0,0,0,0,
        0,0,10,0,0,0,0,0,
        0,0,0,11,0,0,0,0,
        0,0,0,0,12,0,0,0,
        0,0,0,0,0,13,0,0,
        0,0,0,0,0,0,14,0,
        0,0,0,0,0,0,0,15,
    };
    diaq::denseMatrix B8(8, b8);
    std::vector<diaq::denseMatrix> testCase8;
    testCase8.push_back(A8);
    testCase8.push_back(B8);
    testCases.push_back(testCase8);

    // test case 9
    diaq::valType a9[64] = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
    };
    diaq::denseMatrix A9(8, a9);
    diaq::valType b9[64] = {
        0,0,5,0,0,0,0,0,
        0,0,0,6,0,0,0,0,
        0,0,0,0,7,0,0,0,
        0,0,0,0,0,8,0,0,
        0,0,0,0,0,0,9,0,
        0,0,0,0,0,0,0,10,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B9(8, b9);
    std::vector<diaq::denseMatrix> testCase9;
    testCase9.push_back(A9);
    testCase9.push_back(B9);
    testCases.push_back(testCase9);


    // test case 10
    diaq::valType a10[64] = {
        0,0,1,0,0,0,0,0,
        0,0,0,2,0,0,0,0,
        0,0,0,0,3,0,0,0,
        0,0,0,0,0,4,0,0,
        0,0,0,0,0,0,5,0,
        0,0,0,0,0,0,0,6,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix A10(8, a10);
    diaq::valType b10[64] = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        7,0,0,0,0,0,0,0,
        0,8,0,0,0,0,0,0,
        0,0,9,0,0,0,0,0,
        0,0,0,10,0,0,0,0,
    };
    diaq::denseMatrix B10(8, a10);
    std::vector<diaq::denseMatrix> testCase10;
    testCase10.push_back(A10);
    testCase10.push_back(B10);
    testCases.push_back(testCase10);


    // test case 11
    diaq::valType a11[64] = {
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
        0,0,0,0,5,0,0,0,
        0,0,0,0,0,6,0,0,
        0,0,0,0,0,0,7,0,
        0,0,0,0,0,0,0,8,
    };
    diaq::denseMatrix A11(8, a11);
    diaq::valType b11[64] = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        9,0,0,0,0,0,0,0,
        0,10,0,0,0,0,0,0,
        0,0,11,0,0,0,0,0,
        0,0,0,12,0,0,0,0,
    };
    diaq::denseMatrix B11(8, b11);
    std::vector<diaq::denseMatrix> testCase11;
    testCase11.push_back(A11);
    testCase11.push_back(B11);
    testCases.push_back(testCase11);


    // test case 12
    diaq::valType a12[64] = {
        1,0,0,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
        0,0,1,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,1,0,
        0,0,0,0,0,1,0,0,
    };
    diaq::denseMatrix A12(8, a12);
    diaq::valType b12[64] = {
        1,0,0,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
        0,0,1,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,1,0,
        0,0,0,0,0,1,0,0,
    };
    diaq::denseMatrix B12(8, b12);
    std::vector<diaq::denseMatrix> testCase12;
    testCase12.push_back(A12);
    testCase12.push_back(B12);
    testCases.push_back(testCase12);


    // test case 13
    diaq::valType a13[64] = {
        0,0,1,0,0,0,0,0,
        0,0,0,2,0,0,0,0,
        0,0,0,0,3,0,0,0,
        0,0,0,0,0,4,0,0,
        0,0,0,0,0,0,5,0,
        0,0,0,0,0,0,0,6,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix A13(8, a13);
    diaq::valType b13[64] = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        7,0,0,0,0,0,0,0,
        0,8,0,0,0,0,0,0,
        0,0,9,0,0,0,0,0,
        0,0,0,10,0,0,0,0,
        0,0,0,0,11,0,0,0,
        0,0,0,0,0,12,0,0,
    };
    diaq::denseMatrix B13(8, b13);
    std::vector<diaq::denseMatrix> testCase13;
    testCase13.push_back(A13);
    testCase13.push_back(B13);
    testCases.push_back(testCase13);


    // test case 14
    diaq::valType a14[256] = {
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
    };
    diaq::denseMatrix A14(16, a14);
    diaq::valType b14[256] = {
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
    };
    diaq::denseMatrix B14(16, b14);
    std::vector<diaq::denseMatrix> testCase14;
    testCase14.push_back(A14);
    testCase14.push_back(B14);
    testCases.push_back(testCase14);

    // test case 15
    diaq::valType a15[256] = {
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
    };
    diaq::denseMatrix A15(16, a15);
    diaq::valType b15[256] = {
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
    };
    diaq::denseMatrix B15(16, b15);
    std::vector<diaq::denseMatrix> testCase15;
    testCase15.push_back(A15);
    testCase15.push_back(B15);
    testCases.push_back(testCase15);

    // test case 16
    diaq::valType a16[256] = {
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
    };
    diaq::denseMatrix A16(16, a16);
    diaq::valType b16[256] = {
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
    };
    diaq::denseMatrix B16(16, b16);
    std::vector<diaq::denseMatrix> testCase16;
    testCase16.push_back(A16);
    testCase16.push_back(B16);
    testCases.push_back(testCase16);


    // test case 17
    diaq::valType a17[64] = {
        1,0,0,0,0,0,0,0,
        0,1,0,0,0,0,0,0,
        0,0,1,0,0,0,0,0,
        0,0,0,1,0,0,0,0,
        0,0,0,0,0,1,0,0,
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,1,
        0,0,0,0,0,0,1,0,
    };
    diaq::denseMatrix A17(8, a17);
    diaq::valType b17[64] = {
        2,3,0,0,0,0,0,0,
        0,0,0,0,0,0,3,2,
        0,0,2,3,0,0,0,0,
        0,0,0,0,3,2,0,0,
        0,0,0,0,2,3,0,0,
        0,0,3,2,0,0,0,0,
        0,0,0,0,0,0,2,3,
        3,2,0,0,0,0,0,0,
    };
    diaq::denseMatrix B17(8, b17);
    std::vector<diaq::denseMatrix> testCase17;
    testCase17.push_back(A17);
    testCase17.push_back(B17);
    testCases.push_back(testCase17);

    // test case 18
    diaq::valType a18[64] = {
        0,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
        0,0,0,0,5,0,0,0,
        0,0,0,0,0,6,0,0,
        0,0,0,0,0,0,7,0,
    };
    diaq::denseMatrix A18(8, a18);
    diaq::valType b18[64] = {
        0,0,0,0,0,0,8,0,
        0,0,0,0,0,0,0,9,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B18(8, b18);
    std::vector<diaq::denseMatrix> testCase18;
    testCase18.push_back(A18);
    testCase18.push_back(B18);
    testCases.push_back(testCase18);

    // test case 19
    diaq::valType a19[64] = {
        0,0,0,0,1,0,0,0,
        0,0,0,0,0,2,0,0,
        0,0,0,0,0,0,3,0,
        0,0,0,0,0,0,0,4,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix A19(8, a19);
    diaq::valType b19[64] = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        5,0,0,0,0,0,0,0,
        0,6,0,0,0,0,0,0,
        0,0,7,0,0,0,0,0,
        0,0,0,8,0,0,0,0,
    };
    diaq::denseMatrix B19(8, b19);
    std::vector<diaq::denseMatrix> testCase19;
    testCase19.push_back(A19);
    testCase19.push_back(B19);
    testCases.push_back(testCase19);

    // test case 20
    diaq::valType a20[64] = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix A20(8, a20);
    diaq::valType b20[64] = {
        9,0,0,0,0,0,0,0,
        0,10,0,0,0,0,0,0,
        0,0,11,0,0,0,0,0,
        0,0,0,12,0,0,0,0,
        0,0,0,0,13,0,0,0,
        0,0,0,0,0,14,0,0,
        0,0,0,0,0,0,15,0,
        0,0,0,0,0,0,0,16,
    };
    diaq::denseMatrix B20(8, b20);
    std::vector<diaq::denseMatrix> testCase20;
    testCase20.push_back(A20);
    testCase20.push_back(B20);
    testCases.push_back(testCase20);

    // test case 21
    diaq::valType a21[64] = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
    };
    diaq::denseMatrix A21(8, a21);
    diaq::valType b21[64] = {
        0,0,0,0,5,0,0,0,
        0,0,0,0,0,6,0,0,
        0,0,0,0,0,0,7,0,
        0,0,0,0,0,0,0,8,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B21(8, b21);
    std::vector<diaq::denseMatrix> testCase21;
    testCase21.push_back(A21);
    testCase21.push_back(B21);
    testCases.push_back(testCase21);

    // test case 22
    diaq::valType a22[64] = {
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,3,0,0,0,0,0,
        0,0,0,4,0,0,0,0,
        0,0,0,0,0,5,0,0,
        0,0,0,0,6,0,0,0,
        0,0,0,0,0,0,0,7,
        0,0,0,0,0,0,8,0,
    };
    diaq::denseMatrix A22(8, a22);
    diaq::valType b22[64] = {
        9,10,0,0,0,0,0,0,
        0,0,0,0,0,0,11,12,
        0,0,13,14,0,0,0,0,
        0,0,0,0,15,16,0,0,
        0,0,0,0,17,18,0,0,
        0,0,19,20,0,0,0,0,
        0,0,0,0,0,0,21,22,
        23,24,0,0,0,0,0,0,
    };
    diaq::denseMatrix B22(8, b22);
    std::vector<diaq::denseMatrix> testCase22;
    testCase22.push_back(A22);
    testCase22.push_back(B22);
    testCases.push_back(testCase22);

    // test case 23
    diaq::valType a23[64] = {
        1,0,0,0,0,0,0,0,
        0,2,0,0,0,0,0,0,
        0,0,0,0,0,0,3,0,
        0,0,0,0,0,0,0,4,
        0,0,0,0,5,0,0,0,
        0,0,0,0,0,6,0,0,
        0,0,7,0,0,0,0,0,
        0,0,0,8,0,0,0,0,
    };
    diaq::denseMatrix A23(8, a23);
    diaq::valType b23[64] = {
        9,10,0,0,0,0,0,0,
        0,0,0,0,0,0,11,12,
        0,0,0,0,0,0,13,14,
        15,16,0,0,0,0,0,0,
        0,0,0,0,17,18,0,0,
        0,0,19,20,0,0,0,0,
        0,0,21,22,0,0,0,0,
        0,0,0,0,23,24,0,0,
    };
    diaq::denseMatrix B23(8, b23);
    std::vector<diaq::denseMatrix> testCase23;
    testCase23.push_back(A23);
    testCase23.push_back(B23);
    testCases.push_back(testCase23);

    // -----------------------------------------
    std::vector<long int> shapeA24{3, 6};
    diaq::valType a24[18] = {
        1,2,3,4,5,6,
        7,8,9,10,11,12,
        13,14,15,16,17,18,
    };
    diaq::denseMatrix A24(&shapeA24, a24);
    std::vector<long int> shapeB24{6, 2};
    diaq::valType b24[12] = {
        1,2,
        3,4,
        5,6,
        7,8,
        9,10,
        11,12,
    };
    diaq::denseMatrix B24(&shapeB24, b24);
    std::vector<diaq::denseMatrix> testCase24;
    testCase24.push_back(A24);
    testCase24.push_back(B24);
    testCases.push_back(testCase24);

    // -----------------------------------------
    std::vector<long int> shapeA25{3, 6};
    diaq::valType a25[18] = {
        1,2,3,4,5,6,
        7,8,9,10,11,12,
        13,14,15,16,17,18
    };
    diaq::denseMatrix A25(&shapeA25, a25);
    std::vector<long int> shapeB25{6,4};
    diaq::valType b25[24] = {
        20,21,22,23,
        24,25,26,27,
        28,29,30,31,
        32,33,34,35,
        36,37,38,39,
        40,41,42,43,
    };
    diaq::denseMatrix B25(&shapeB25, b25);
    std::vector<diaq::denseMatrix> testCase25;
    testCase25.push_back(A25);
    testCase25.push_back(B25);
    testCases.push_back(testCase25);


    // -----------------------------------------
    std::vector<long int> shapeA26{3, 6};
    diaq::valType a26[18] = {
        0,0,0,1,0,0,
        0,0,0,0,2,0,
        0,0,0,0,0,3,
    };
    diaq::denseMatrix A26(&shapeA26, a26);
    std::vector<long int> shapeB26{6,4};
    diaq::valType b26[24] = {
        0,4,0,0,
        0,0,5,0,
        0,0,0,6,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix B26(&shapeB26, b26);
    std::vector<diaq::denseMatrix> testCase26;
    testCase26.push_back(A26);
    testCase26.push_back(B26);
    testCases.push_back(testCase26);


    // -----------------------------------------
    std::vector<long int> shapeA27{3, 6};
    diaq::valType a27[18] = {
        0,0,0,1,0,0,
        0,0,0,0,2,0,
        0,0,0,0,0,3,
    };
    diaq::denseMatrix A27(&shapeA27, a27);
    std::vector<long int> shapeB27{6,4};
    diaq::valType b27[24] = {
        0,0,0,0,
        0,0,0,0,
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
    };
    diaq::denseMatrix B27(&shapeB27, b27);
    std::vector<diaq::denseMatrix> testCase27;
    testCase27.push_back(A27);
    testCase27.push_back(B27);
    testCases.push_back(testCase27);

    // -----------------------------------------
    std::vector<long int> shapeA28{3, 6};
    diaq::valType a28[18] = {
        0,0,0,1,0,0,
        0,0,0,0,2,0,
        0,0,0,0,0,3,
    };
    diaq::denseMatrix A28(&shapeA28, a28);
    std::vector<long int> shapeB28{6,4};
    diaq::valType b28[24] = {
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix B28(&shapeB28, b28);
    std::vector<diaq::denseMatrix> testCase28;
    testCase28.push_back(A28);
    testCase28.push_back(B28);
    testCases.push_back(testCase28);


        // -----------------------------------------
    std::vector<long int> shapeA29{3, 6};
    diaq::valType a29[18] = {
        0,0,0,0,0,0,
        1,0,0,0,0,0,
        0,2,0,0,0,0,
    };
    diaq::denseMatrix A29(&shapeA29, a29);
    std::vector<long int> shapeB29{6,4};
    diaq::valType b29[24] = {
        0,4,0,0,
        0,0,5,0,
        0,0,0,6,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix B29(&shapeB29, b29);
    std::vector<diaq::denseMatrix> testCase29;
    testCase29.push_back(A29);
    testCase29.push_back(B29);
    testCases.push_back(testCase29);


    // -----------------------------------------
    std::vector<long int> shapeA30{3, 6};
    diaq::valType a30[18] = {
        0,0,0,0,0,0,
        1,0,0,0,0,0,
        0,2,0,0,0,0,
    };
    diaq::denseMatrix A30(&shapeA30, a30);
    std::vector<long int> shapeB30{6,4};
    diaq::valType b30[24] = {
        0,0,0,0,
        0,0,0,0,
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
    };
    diaq::denseMatrix B30(&shapeB30, b30);
    std::vector<diaq::denseMatrix> testCase30;
    testCase30.push_back(A30);
    testCase30.push_back(B30);
    testCases.push_back(testCase30);

    // -----------------------------------------
    std::vector<long int> shapeA31{3, 6};
    diaq::valType a31[18] = {
        0,0,0,0,0,0,
        1,0,0,0,0,0,
        0,2,0,0,0,0,
    };
    diaq::denseMatrix A31(&shapeA31, a31);
    std::vector<long int> shapeB31{6,4};
    diaq::valType b31[24] = {
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix B31(&shapeB31, b31);
    std::vector<diaq::denseMatrix> testCase31;
    testCase31.push_back(A31);
    testCase31.push_back(B31);
    testCases.push_back(testCase31);
    

    // -----------------------------------------
    std::vector<long int> shapeA32{3, 6};
    diaq::valType a32[18] = {
        1,0,0,0,0,0,
        0,2,0,0,0,0,
        0,0,3,0,0,0,
    };
    diaq::denseMatrix A32(&shapeA32, a32);
    std::vector<long int> shapeB32{6,4};
    diaq::valType b32[24] = {
        0,4,0,0,
        0,0,5,0,
        0,0,0,6,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix B32(&shapeB32, b32);
    std::vector<diaq::denseMatrix> testCase32;
    testCase32.push_back(A32);
    testCase32.push_back(B32);
    testCases.push_back(testCase32);


    // -----------------------------------------
    std::vector<long int> shapeA33{3, 6};
    diaq::valType a33[18] = {
        1,0,0,0,0,0,
        0,2,0,0,0,0,
        0,0,3,0,0,0,
    };
    diaq::denseMatrix A33(&shapeA33, a33);
    std::vector<long int> shapeB33{6,4};
    diaq::valType b33[24] = {
        0,0,0,0,
        0,0,0,0,
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
    };
    diaq::denseMatrix B33(&shapeB33, b33);
    std::vector<diaq::denseMatrix> testCase33;
    testCase33.push_back(A33);
    testCase33.push_back(B33);
    testCases.push_back(testCase33);

    // -----------------------------------------
    std::vector<long int> shapeA34{3, 6};
    diaq::valType a34[18] = {
        1,0,0,0,0,0,
        0,2,0,0,0,0,
        0,0,3,0,0,0,
    };
    diaq::denseMatrix A34(&shapeA34, a34);
    std::vector<long int> shapeB34{6,4};
    diaq::valType b34[24] = {
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix B34(&shapeB34, b34);
    std::vector<diaq::denseMatrix> testCase34;
    testCase34.push_back(A34);
    testCase34.push_back(B34);
    testCases.push_back(testCase34);

    // -----------------------------------------
    std::vector<long int> shapeA35{3, 6};
    diaq::valType a35[18] = {
        0,0,0,0,5,0,
        0,0,0,0,0,6,
        0,0,0,0,0,0,
    };
    diaq::denseMatrix A35(&shapeA35, a35);
    std::vector<long int> shapeB35{6, 2};
    diaq::valType b35[12] = {
        0,0,
        0,0,
        0,0,
        0,0,
        0,0,
        4,0,
    };
    diaq::denseMatrix B35(&shapeB35, b35);
    std::vector<diaq::denseMatrix> testCase35;
    testCase35.push_back(A35);
    testCase35.push_back(B35);
    testCases.push_back(testCase35);


    // -----------------------------------------
    std::vector<long int> shapeA36{3, 6};
    diaq::valType a36[18] = {
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        5,0,0,0,0,0,
    };
    diaq::denseMatrix A36(&shapeA36, a36);
    std::vector<long int> shapeB36{6,4};
    diaq::valType b36[24] = {
        0,0,0,10,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix B36(&shapeB36, b36);
    std::vector<diaq::denseMatrix> testCase36;
    testCase36.push_back(A36);
    testCase36.push_back(B36);
    testCases.push_back(testCase36);


    // -----------------------------------------
    std::vector<long int> shapeA37{3, 6};
    diaq::valType a37[18] = {
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        1,0,0,0,0,0,
    };
    diaq::denseMatrix A37(&shapeA37, a37);
    std::vector<long int> shapeB37{6,2};
    diaq::valType b37[12] = {
        0,2,
        0,0,
        0,0,
        0,0,
        0,0,
        0,0,
    };
    diaq::denseMatrix B37(&shapeB37, b37);
    std::vector<diaq::denseMatrix> testCase37;
    testCase37.push_back(A37);
    testCase37.push_back(B37);
    testCases.push_back(testCase37);

    // -----------------------------------------
    std::vector<long int> shapeA38{16, 4};
    diaq::valType a38[64] = {
        8,0,0,0,
        0,0,0,0,
        0,9,0,0,
        0,0,0,0,
        0,0,10,0,
        0,0,0,0,
        0,0,0,11,
        0,0,0,0,
        0,0,0,0,
        12,0,0,0,
        0,0,0,0,
        0,13,0,0,
        0,0,0,0,
        0,0,14,0,
        0,0,0,0,
        0,0,0,15,
    };
    diaq::denseMatrix A38(&shapeA38, a38);
    std::vector<long int> shapeB38{4,16};
    diaq::valType b38[64] = {
        8,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,
        0,0,10,0,0,0,0,0,0,0,0,11,0,0,0,0,
        0,0,0,0,12,0,0,0,0,0,0,0,0,13,0,0,
        0,0,0,0,0,0,14,0,0,0,0,0,0,0,0,15,
    };
    diaq::denseMatrix B38(&shapeB38, b38);
    std::vector<diaq::denseMatrix> testCase38;
    testCase38.push_back(A38);
    testCase38.push_back(B38);
    testCases.push_back(testCase38);

    // -----------------------------------------
    std::vector<long int> shapeA39{16, 4};
    diaq::valType a39[64] = {
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,15,
    };
    diaq::denseMatrix A39(&shapeA39, a39);
    std::vector<long int> shapeB39{4,16};
    diaq::valType b39[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,14,0,0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B39(&shapeB39, b39);
    std::vector<diaq::denseMatrix> testCase39;
    testCase39.push_back(A39);
    testCase39.push_back(B39);
    testCases.push_back(testCase39);


    // -----------------------------------------
    std::vector<long int> shapeA40{16, 4};
    diaq::valType a40[64] = {
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,13,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix A40(&shapeA40, a40);
    std::vector<long int> shapeB40{4,16};
    diaq::valType b40[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B40(&shapeB40, b40);
    std::vector<diaq::denseMatrix> testCase40;
    testCase40.push_back(A40);
    testCase40.push_back(B40);
    testCases.push_back(testCase40);


    // -----------------------------------------
    std::vector<long int> shapeA41{16, 4};
    diaq::valType a41[64] = {
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        12,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix A41(&shapeA41, a41);
    std::vector<long int> shapeB41{4,16};
    diaq::valType b41[64] = {
        8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B41(&shapeB41, b41);
    std::vector<diaq::denseMatrix> testCase41;
    testCase41.push_back(A41);
    testCase41.push_back(B41);
    testCases.push_back(testCase41);

    // -----------------------------------------
    std::vector<long int> shapeA42{16, 4};
    diaq::valType a42[64] = {
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,11,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix A42(&shapeA42, a42);
    std::vector<long int> shapeB42{4,16};
    diaq::valType b42[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,
    };
    diaq::denseMatrix B42(&shapeB42, b42);
    std::vector<diaq::denseMatrix> testCase42;
    testCase42.push_back(A42);
    testCase42.push_back(B42);
    testCases.push_back(testCase42);

    // -----------------------------------------
    std::vector<long int> shapeA43{16, 4};
    diaq::valType a43[64] = {
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,10,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix A43(&shapeA43, a43);
    std::vector<long int> shapeB43{4,16};
    diaq::valType b43[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B43(&shapeB43, b43);
    std::vector<diaq::denseMatrix> testCase43;
    testCase43.push_back(A43);
    testCase43.push_back(B43);
    testCases.push_back(testCase43);

    // -----------------------------------------
    std::vector<long int> shapeA44{16, 4};
    diaq::valType a44[64] = {
        0,0,0,0,
        0,0,0,0,
        0,9,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix A44(&shapeA44, a44);
    std::vector<long int> shapeB44{4,16};
    diaq::valType b44[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,11,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B44(&shapeB44, b44);
    std::vector<diaq::denseMatrix> testCase44;
    testCase44.push_back(A44);
    testCase44.push_back(B44);
    testCases.push_back(testCase44);

    // -----------------------------------------
    std::vector<long int> shapeA45{16, 4};
    diaq::valType a45[64] = {
        8,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    diaq::denseMatrix A45(&shapeA45, a45);
    std::vector<long int> shapeB45{4,16};
    diaq::valType b45[64] = {
        0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    diaq::denseMatrix B45(&shapeB45, b45);
    std::vector<diaq::denseMatrix> testCase45;
    testCase45.push_back(A45);
    testCase45.push_back(B45);
    testCases.push_back(testCase45);

    // -----------------------------------------
    std::vector<long int> shapeA46{32, 2};
    diaq::valType a46[64] = {
        1,0,
        0,0,
        0,0,
        0,0,
        0,0,
        0,0,
        0,0,
        1,0,
        0,1,
        0,0,
        0,0,
        0,0,
        0,0,
        0,0,
        0,0,
        0,1,
        0,0,
        0,1,
        0,0,
        0,0,
        0,0,
        0,0,
        0,1,
        0,0,
        0,0,
        1,0,
        0,0,
        0,0,
        0,0,
        0,0,
        1,0,
        0,0,
    };
    diaq::denseMatrix A46(&shapeA46, a46);
    std::vector<long int> shapeB46{2,8};
    diaq::valType b46[64] = {
        1,0,0,1,0,0,0,0,
        0,0,0,0,0,1,1,0,
    };
    diaq::denseMatrix B46(&shapeB46, b46);
    std::vector<diaq::denseMatrix> testCase46;
    testCase46.push_back(A46);
    testCase46.push_back(B46);
    testCases.push_back(testCase46);


    // -----------------------------------------
    std::vector<long int> shapeA47{8, 2};
    diaq::valType a47[16] = {
        0.707107,0,
        0,0,
        0,0.707107,
        0,0,
        0,0,
        0,0.707107,
        0,0,
        0.707107,0,
    };
    diaq::denseMatrix A47(&shapeA47, a47);
    std::vector<long int> shapeB47{2,2};
    diaq::valType b47[4] = {
        0.707107,0,
        0,-0.707107,
    };
    diaq::denseMatrix B47(&shapeB47, b47);
    std::vector<diaq::denseMatrix> testCase47;
    testCase47.push_back(A47);
    testCase47.push_back(B47);
    testCases.push_back(testCase47);

    // -----------------------------------------
    std::vector<long int> shapeA48{4, 5};
    diaq::valType a48[20] = {
        1, 2, 3, 4, 5,
        6, 7, 8, 9, 10,
        11, 12, 13, 14, 15,
        16, 17, 18, 19, 20,
    };
    diaq::denseMatrix A48(&shapeA48, a48);
    std::vector<long int> shapeB48{5, 3};
    diaq::valType b48[15] = {
        1, 6, 11,
        2, 7, 12,
        3, 8, 13,
        4, 9, 14,
        5, 10, 15,
    };
    diaq::denseMatrix B48(&shapeB48, b48);
    std::vector<diaq::denseMatrix> testCase48;
    testCase48.push_back(A48);
    testCase48.push_back(B48);
    testCases.push_back(testCase48);

    if(argc == 1) {
        for(long int i = 0; i < testCases.size(); i++) {
            std::cout << "test case - " << i;
            diaq::denseMatrix p = denseProduct(testCases[i][0], testCases[i][1]);
            // std::cout << std::endl << " ---- dense product ---- " << std::endl;
            // p.print();
            // std::cout << " ---- dense product ---- " << std::endl;
            diaq::diaQMatrix dp = p.convertToQuantumSparse(p.matrix_shape);
            // std::cout << " ---- correct answer ---- " << std::endl;
            // dp.print();
            // std::cout << " ---- correct answer ---- " << std::endl;
            diaq::diaQMatrix first = testCases[i][0].convertToQuantumSparse(testCases[i][0].matrix_shape);
            // std::cout << " -- first -- " << std::endl;
            // first.print();
            // std::cout << " -- first -- " << std::endl;
            diaq::diaQMatrix second = testCases[i][1].convertToQuantumSparse(testCases[i][1].matrix_shape);
            // std::cout << " -- second -- " << std::endl;
            // second.print();
            // std::cout << " -- second -- " << std::endl;
            diaq::diaQMatrix qp = product(first, second);
            // std::cout << " -- qp -- " << std::endl;
            // qp.print();
            // std::cout << " -- qp -- " << std::endl;
            std::string check = checkResult(dp, qp);
            std::cout << " = " << check << std::endl;
        }
    }
    else if(strcmp(argv[1], "1") == 0) {
        // testing reshape operations
        B8.print();
        std::cout << " -- " << std::endl;
        std::vector<long int> dims{8,8};
        diaq::diaQMatrix q_B8 = B8.convertToQuantumSparse(dims);
        q_B8.print();
        std::cout << " -- " << std::endl;

        std::vector<long int> new_dims{4,16};
        diaq::diaQMatrix reshaped_q_B8 = reshape(q_B8, new_dims);
        reshaped_q_B8.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Reshape Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "2") == 0) {
        // testing matrix transposition operation
        A24.print();
        std::cout << " -- " << std::endl;

        std::vector<long int> dims{3,6};
        diaq::diaQMatrix q_A24 = A24.convertToQuantumSparse(dims);
        q_A24.print();
        std::cout << " -- " << std::endl;

        std::vector<long int> axes{};
        diaq::diaQMatrix res = transpose(q_A24, axes);
        res.print();
        std::cout << " -- " << std::endl;

        res.convertToDenseMatrix(res.matrix_shape).print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Matrix Transpose Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "3") == 0) {
        // testing getMatrixPosition and getTensorPosition
        A24.shape = std::vector<long int>{3,3,2};
        A24.print();
        std::cout << " -- " << std::endl;
        std::vector<long int> dims{3,6};
        diaq::diaQMatrix q_A24 = A24.convertToQuantumSparse(dims);
        q_A24.print();
        std::cout << " -- " << std::endl;

        long int di = 2;
        long int dp = 2;

        std::cout << "getting element in diaq::diagonal idx = " << di << " position = " << dp << std::endl;
        std::vector<long int> mat_pos = q_A24.getMatrixPosition(di, dp);
        std::cout << "matrix position - " << mat_pos[0] << "," << mat_pos[1] << std::endl;

        std::vector<long int> ten_pos = q_A24.getTensorPosition(di, dp);
        std::cout << "tensor position - " << ten_pos[0] << "," << ten_pos[1] << "," << ten_pos[2] << std::endl;

        std::cout << "reading element from dense version: " << A24.getItem(ten_pos) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- getMatrixPosition and getTensorPosition Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "4") == 0) {
        // testing tensor transposition operation
        std::cout << " --example1-- " << std::endl;
        A24.print();
        std::cout << " -- " << std::endl;

        std::vector<long int> dims{3,6};
        diaq::diaQMatrix q_A24 = A24.convertToQuantumSparse(dims);
        q_A24.shape = std::vector<long int>{3,3,2};
        q_A24.print();
        std::cout << " -- " << std::endl;

        std::vector<long int> order{};
        diaq::diaQMatrix res = transpose(q_A24, order);
        std::cout << " -- " << std::endl;
        res.print();
        std::cout << " -- " << std::endl;
        res.convertToDenseMatrix(res.matrix_shape).print();

        // another example
        // testing tensor transposition operation
        std::cout << " --example2-- " << std::endl;
        A47.print();
        std::cout << " -- " << std::endl;

        diaq::diaQMatrix q_A47 = A47.convertToQuantumSparse(A47.matrix_shape);
        q_A47.shape = std::vector<long int>{2,2,2,2};
        q_A47.print();
        std::cout << " -- " << std::endl;

        res = transpose(q_A47, order);
        std::cout << " -- " << std::endl;
        res.print();
        std::cout << " -- " << std::endl;
        res.convertToDenseMatrix(res.matrix_shape).print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Tensor Transpose Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "5") == 0) {
        // testing operator overloading
        const std::string str_i = "30";
        long int i = std::stoi(str_i);
        std::cout << "test case - " << i;
        diaq::denseMatrix p = denseProduct(testCases[i][0], testCases[i][1]);
        std::cout << std::endl << " ---- dense product ---- " << std::endl;
        p.print();
        std::cout << " ---- dense product ---- " << std::endl;
        diaq::diaQMatrix dp = p.convertToQuantumSparse(p.matrix_shape);
        std::cout << " ---- correct answer ---- " << std::endl;
        dp.print();
        std::cout << " ---- correct answer ---- " << std::endl;
        diaq::diaQMatrix first = testCases[i][0].convertToQuantumSparse(testCases[i][0].matrix_shape);
        std::cout << " -- first -- " << std::endl;
        first.print();
        std::cout << " -- first -- " << std::endl;
        diaq::diaQMatrix second = testCases[i][1].convertToQuantumSparse(testCases[i][1].matrix_shape);
        std::cout << " -- second -- " << std::endl;
        second.print();
        std::cout << " -- second -- " << std::endl;
        diaq::diaQMatrix qp = first * second;
        std::cout << " -- qp -- " << std::endl;
        qp.print();
        std::cout << " -- qp -- " << std::endl;
        std::string check = checkResult(dp, qp);
        std::cout << " = " << check << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- Operator * Overloading Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "6") == 0) {
        // testing flatten operation
        std::cout << " --example1-- " << std::endl;
        A24.print();
        std::cout << " -- " << std::endl;
        diaq::diaQMatrix q_A24 = A24.convertToQuantumSparse(A24.matrix_shape);
        q_A24.print();
        std::cout << " -- " << std::endl;
        std::vector<std::complex<diaq::valType>> values = q_A24.flatten();
        for (long int i = 0; i < values.size(); i++) {
            std::cout << values[i] << " ";
        }
        std::cout << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- Flatten Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "7") == 0) {
        // tranpose using matrix.transpose instead of transpose(matrix, order)
        diaq::diaQMatrix q_A47 = A47.convertToQuantumSparse(A47.matrix_shape);
        q_A47.shape = std::vector<long int>{2,2,2,2};
        q_A47.print();
        std::cout << " -- " << std::endl;
        diaq::diaQMatrix res = q_A47.transpose(std::vector<long int>{});
        res.print();
        std::cout << " -- " << std::endl;
        res.convertToDenseMatrix(res.matrix_shape).print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Transpose Test Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "spmv") == 0) {
        // testing spMV here.
        std::cout << " --matrix-- " << std::endl;
        A25.print();
        std::cout << " --sparse_matrix-- " << std::endl;
        diaq::diaQMatrix q_A25 = A25.convertToQuantumSparse(A25.matrix_shape);
        q_A25.print();
        std::cout << " --x-- " << std::endl;
        diaq::vector x(A25.matrix_shape[1], 1.0);
        for(int i = 0; i < x.num_rows(); i++) {
            x[i] = i;
        }
        x.print();
        std::cout << " --MV-- " << std::endl;
        diaq::vector dense_y = MV(A25, x);
        dense_y.print();
        std::cout << " --spMV-- " << std::endl;
        diaq::vector y = spMV(q_A25, x);
        y.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- spMV Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "9") == 0) {
        // testing tensordot operation
        A24.shape = std::vector<long int>{3,3,2};
        std::vector<long int> dims_A{3,6};
        diaq::diaQMatrix q_A24 = A24.convertToQuantumSparse(dims_A);
        q_A24.print();
        std::cout << " -- " << std::endl;
        B24.shape = std::vector<long int>{2,3,2};
        std::vector<long int> dims_B{6,2};
        diaq::diaQMatrix q_B24 = B24.convertToQuantumSparse(dims_B);
        q_B24.print();
        std::cout << " -- " << std::endl;
        std::vector<long int> axes_A{2};
        std::vector<long int> axes_B{0};
        std::vector<std::vector<long int>> axes{axes_A, axes_B};
        diaq::diaQMatrix res = tensordot(q_A24, q_B24, axes);
        res.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Tensordot Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "10") == 0) {
        diaq::valType first_m[16] = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 0, 1, 0,
        };
        std::vector<long int> shape_first_m{4,4};
        diaq::denseMatrix dfirst(&shape_first_m, first_m);
        diaq::diaQMatrix q_first = dfirst.convertToQuantumSparse(dfirst.matrix_shape);
        q_first.shape = std::vector<long int>{2,2,2,2};
        diaq::valType second_m[4] = {
            0.707107, 0,
            0, -0.707107,
        };
        std::vector<long int> shape_second_m{2,2};
        diaq::denseMatrix dsecond(&shape_second_m, second_m);
        diaq::diaQMatrix q_second = dsecond.convertToQuantumSparse(dsecond.matrix_shape);
        q_second.shape = std::vector<long int>{2,2};
        std::vector<long int> axes_A{3};
        std::vector<long int> axes_B{0};
        std::vector<std::vector<long int>> axes{axes_A, axes_B};
        diaq::diaQMatrix res = tensordot(q_first, q_second, axes);
        res.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Tensordot Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "11") == 0) {
        diaq::valType first_m[16] = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 0, 1, 0,
        };
        std::vector<long int> shape_first_m{4,4};
        diaq::denseMatrix dfirst(&shape_first_m, first_m);
        diaq::diaQMatrix q_first = dfirst.convertToQuantumSparse(dfirst.matrix_shape);
        q_first.shape = std::vector<long int>{2,2,2,2};
        diaq::valType second_m[16] = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 0, 1, 0,
        };
        std::vector<long int> shape_second_m{4,4};
        diaq::denseMatrix dsecond(&shape_second_m, second_m);
        diaq::diaQMatrix q_second = dsecond.convertToQuantumSparse(dsecond.matrix_shape);
        q_second.shape = std::vector<long int>{2,2,2,2};
        std::vector<long int> axes_A{2};
        std::vector<long int> axes_B{1};
        std::vector<std::vector<long int>> axes{axes_A, axes_B};
        diaq::diaQMatrix res = tensordot(q_first, q_second, axes);
        res.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Tensordot Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "12") == 0) {
        std::cout << "Testing Format Conversion" << std::endl;
        std::vector<std::complex<diaq::valType>> values{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18};
        std::vector<long int> shape{3,3,2};
        diaq::diaQMatrix result = diaq::from_numpy(values, shape);
        result.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- From Numpy Done -- " << std::endl;
        std::cout << " -- " << std::endl;
        // test case 5 - GHZ 3 qubit unitary simulation
        std::cout << " -- Testing Multiplication --" << std::endl;
        std::vector<std::complex<diaq::valType>> a{
            1,0,0,0,0,0,0,0,
            0,0,0,1,0,0,0,0,
            0,0,1,0,0,0,0,0,
            0,1,0,0,0,0,0,0,
            0,0,0,0,1,0,0,0,
            0,0,0,0,0,0,0,1,
            0,0,0,0,0,0,1,0,
            0,0,0,0,0,1,0,0,
        };
        std::vector<long int> a_shape{8, 8};
        std::vector<std::complex<diaq::valType>> b{
            1,0,0,0,0,0,0,0,
            0,1,0,0,0,0,0,0,
            0,0,0,0,0,0,1,0,
            0,0,0,0,0,0,0,1,
            0,0,0,0,1,0,0,0,
            0,0,0,0,0,1,0,0,
            0,0,1,0,0,0,0,0,
            0,0,0,1,0,0,0,0,
        };
        std::vector<long int> b_shape{8, 8};

        diaq::diaQMatrix A =  diaq::from_numpy(a, a_shape);
        diaq::diaQMatrix B =  diaq::from_numpy(b, b_shape);
        diaq::diaQMatrix C = A * B;
        C.print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Multiplication Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if (strcmp(argv[1], "kron") == 0 ) {
        // testing kron_product here
        std::cout << " -- test -- " << std::endl;
        kron_test(A0, A0);
        kron_test(B0, B0);
        kron_test(A1, A1);
        kron_test(B1, B1);
        kron_test(A2, A2);
        kron_test(A1, B1);
    }
    else if (strcmp(argv[1], "id") == 0 ) {
        std::cout << " -- testing identity class -- " << std::endl;
        diaq::identityMatrix id4((long int)4);
        id4.print();
        diaq::identityMatrix id2((long int)2);
        id2.print();
    }
    else if (strcmp(argv[1], "permutation") == 0 ) {
        std::cout << " -- testing permutation class -- " << std::endl;
        std::vector<long int> row_order{1,0,2,4,3};
        diaq::permutationMatrix perm5((long int)5, row_order);
        perm5.print();
        perm5.convertToDenseMatrix(perm5.matrix_shape).print();
    }
    else if(strcmp(argv[1], "test") == 0) {
        const std::string str_i = argv[2];
        long int i = std::stoi(str_i);
        std::cout << "test case - " << i;
        diaq::denseMatrix p = denseProduct(testCases[i][0], testCases[i][1]);
        std::cout << std::endl << " ---- dense product ---- " << std::endl;
        p.print();
        std::cout << " ---- dense product ---- " << std::endl;
        diaq::diaQMatrix dp = p.convertToQuantumSparse(p.matrix_shape);
        std::cout << " ---- correct answer ---- " << std::endl;
        dp.print();
        std::cout << " ---- correct answer ---- " << std::endl;
        diaq::diaQMatrix first = testCases[i][0].convertToQuantumSparse(testCases[i][0].matrix_shape);
        std::cout << " -- first -- " << std::endl;
        first.print();
        std::cout << " -- first -- " << std::endl;
        diaq::diaQMatrix second = testCases[i][1].convertToQuantumSparse(testCases[i][1].matrix_shape);
        std::cout << " -- second -- " << std::endl;
        second.print();
        std::cout << " -- second -- " << std::endl;
        diaq::diaQMatrix qp = product(first, second);
        std::cout << " -- qp -- " << std::endl;
        qp.print();
        std::cout << " -- qp -- " << std::endl;
        std::string check = checkResult(dp, qp);
        std::cout << " = " << check << std::endl;
    }
    return 0;
}
