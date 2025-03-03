#include <cstring>
#include <cstdlib>
#include <string>

#include "../include/diaq.hpp"

std::shared_ptr<diaq::diaQMatrix> testQuantumSparseMatrix(std::unordered_map<int, std::shared_ptr<diaq::diagonal> > dm) {
    std::shared_ptr<diaq::diaQMatrix> m = std::make_shared<diaq::diaQMatrix>(dm, 6);
    m->print();
    return m;
}

std::string checkResult(std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::diaQMatrix> B) {
    if(A->diagonalMap.size() != B->diagonalMap.size()) {
        // A->print();
        return "false - size mis-match";
    }
    const diaq::valType epsilon = 0.00002;
    std::unordered_map<int, std::shared_ptr<diaq::diagonal> >::iterator itA, itB;
    for(itA = A->diagonalMap.begin(); itA != A->diagonalMap.end(); itA++) {
        diaq::valType *a_real_values = itA->second->realValues;
        diaq::valType *a_imag_values = itA->second->imagValues;
        auto itB = B->diagonalMap.find(itA->first);
        if(itB == B->diagonalMap.end()) {
            // A->print();
            std::cout << "error with diag idx - " << itA->second->dIndex << std::endl;
            return "false - dIndex mis-match";
        }
        if(itB->second->dLength != itA->second->dLength) { 
            // A->print();
            std::cout << "error with diag idx - " << itA->second->dIndex << std::endl;
            return "false - dLength mis-match";
        }
        else {
            diaq::valType *b_real_values = itB->second->realValues;
            diaq::valType *b_imag_values = itB->second->imagValues;
            for(unsigned int i = 0; i < itA->second->dLength; i++) {
                if(b_real_values[i] - a_real_values[i] > epsilon) {
                    // print where the error is
                    std::cout << "error with diag idx and i - " << itA->second->dIndex << " " << i << std::endl;
                    std::cout << "Correct value: " << a_real_values[i] << std::endl;
                    std::cout << "Wrong value: " << b_real_values[i] << std::endl;
                    return "false - Real mis-match";
                }
                if(b_imag_values[i] - a_imag_values[i] > epsilon) {
                    // print where the error is
                    std::cout << "error with diag idx and i - " << itA->second->dIndex << " " << i << std::endl;
                    std::cout << "Correct value: " << a_imag_values[i] << std::endl;
                    std::cout << "Wrong value: " << b_imag_values[i] << std::endl;
                    return "false - Imag mis-match";
                }
            }
        }
    }
    return "true";
}

std::string check_vectors(std::shared_ptr<diaq::vector> a, std::shared_ptr<diaq::vector> b) {
    if(a->numRows != b->numRows) {
        return "false - length mis-match";
    }
    diaq::valType *a_real_values = a->realValues;
    diaq::valType *a_imag_values = a->imagValues;
    diaq::valType *b_real_values = b->realValues;
    diaq::valType *b_imag_values = b->imagValues;
    const diaq::valType epsilon = 0.00002;
    for(size_t i = 0; i < a->num_rows(); i++) {
        if(std::abs(a_real_values[i] - b_real_values[i]) > epsilon) {
            return "false - Real mis-match";
        }
        if(std::abs(a_imag_values[i] - b_imag_values[i]) > epsilon) {
            return "false - Imag mis-match";
        }
    }
    return "true";
}

void kron_test(std::shared_ptr<diaq::denseMatrix> A24, std::shared_ptr<diaq::denseMatrix> B24) {
        A24->print();
        std::cout << " -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> q_A24 = A24->convertToQuantumSparse(A24->matrix_shape);
        q_A24->print();
        std::cout << " -- " << std::endl;
        B24->print();
        std::cout << " -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> q_B24 = B24->convertToQuantumSparse(B24->matrix_shape);
        q_B24->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- dense kron product -- " << std::endl;
        std::shared_ptr<diaq::denseMatrix> p = diaq::dense_kron_product(A24, B24);
        p->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- correct answer -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> dp = p->convertToQuantumSparse(p->matrix_shape);
        dp->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- sparse kron product -- " << std::endl;
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
        std::shared_ptr<diaq::diaQMatrix> res = kron_product(q_A24, q_B24);
        // end timer
        auto end = std::chrono::high_resolution_clock::now();
        // calculate time
        std::chrono::duration<double> elapsed_seconds = end - start;
        std::cout << " -- " << std::endl;
        std::cout << "elapsed time: " << elapsed_seconds.count() << "s\n";
        std::cout << " -- " << std::endl;
        res->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Kron Product check -- " << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << checkResult(dp, res) << std::endl;
        std::cout << " -- " << std::endl;
}

int main(int argc, char **argv) {

    #ifdef PAPI_ON
        diaq::initPAPI();
    #endif

    std::vector<std::vector<std::shared_ptr<diaq::denseMatrix> > > testCases;

    // test case 0
    diaq::valType a0[25] = {
        0,0,0,0,0,
        0,0,0,0,0,
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A0 = std::make_shared<diaq::denseMatrix>(5, a0);
    diaq::valType b0[25] = {
        2,0,0,0,0,
        0,3,0,0,0,
        0,0,4,0,0,
        0,0,0,5,0,
        0,0,0,0,6,
    };
    std::shared_ptr<diaq::denseMatrix> B0 = std::make_shared<diaq::denseMatrix>(5, b0);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase0;
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
    std::shared_ptr<diaq::denseMatrix> A1 = std::make_shared<diaq::denseMatrix>(5, a1);
    diaq::valType b1[25] = {
        0,0,2,0,0,
        0,0,0,3,0,
        0,0,0,0,4,
        0,0,0,0,0,
        0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B1 = std::make_shared<diaq::denseMatrix>(5, b1);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase1;
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
    std::shared_ptr<diaq::denseMatrix> A2 = std::make_shared<diaq::denseMatrix>(5, a2);
    diaq::valType b2[25] = {
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
        0,0,3,0,0,
        0,0,0,4,0,
    };
    std::shared_ptr<diaq::denseMatrix> B2 = std::make_shared<diaq::denseMatrix>(5, b2);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase2;
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
    std::shared_ptr<diaq::denseMatrix> A3 = std::make_shared<diaq::denseMatrix>(5, a3);
    diaq::valType b3[25] = {
        0,0,0,0,0,
        1,0,0,0,0,
        0,2,0,0,0,
        0,0,3,0,0,
        0,0,0,4,0,
    };
    std::shared_ptr<diaq::denseMatrix> B3 = std::make_shared<diaq::denseMatrix>(5, b3);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase3;
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
    std::shared_ptr<diaq::denseMatrix> A4 = std::make_shared<diaq::denseMatrix>(5, a4);
    diaq::valType b4[25] = {
        2,0,0,0,0,
        0,3,0,0,0,
        0,0,4,0,0,
        0,0,0,5,0,
        0,0,0,0,6,
    };
    std::shared_ptr<diaq::denseMatrix> B4 = std::make_shared<diaq::denseMatrix>(5, b4);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase4;
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
    std::shared_ptr<diaq::denseMatrix> A5 = std::make_shared<diaq::denseMatrix>(8, a5);
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
    std::shared_ptr<diaq::denseMatrix> B5 = std::make_shared<diaq::denseMatrix>(8, b5);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase5;
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
    std::shared_ptr<diaq::denseMatrix> A6 = std::make_shared<diaq::denseMatrix>(8, a6);
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
    std::shared_ptr<diaq::denseMatrix> B6 = std::make_shared<diaq::denseMatrix>(8, b6);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase6;
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
    std::shared_ptr<diaq::denseMatrix> A7 = std::make_shared<diaq::denseMatrix>(8, a7);
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
    std::shared_ptr<diaq::denseMatrix> B7 = std::make_shared<diaq::denseMatrix>(8, b7);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase7;
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
    std::shared_ptr<diaq::denseMatrix> A8 = std::make_shared<diaq::denseMatrix>(8, a8);
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
    std::shared_ptr<diaq::denseMatrix> B8 = std::make_shared<diaq::denseMatrix>(8, b8);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase8;
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
    std::shared_ptr<diaq::denseMatrix> A9 = std::make_shared<diaq::denseMatrix>(8, a9);
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
    std::shared_ptr<diaq::denseMatrix> B9 = std::make_shared<diaq::denseMatrix>(8, b9);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase9;
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
    std::shared_ptr<diaq::denseMatrix> A10 = std::make_shared<diaq::denseMatrix>(8, a10);
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
    std::shared_ptr<diaq::denseMatrix> B10 = std::make_shared<diaq::denseMatrix>(8, b10);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase10;
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
    std::shared_ptr<diaq::denseMatrix> A11 = std::make_shared<diaq::denseMatrix>(8, a11);
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
    std::shared_ptr<diaq::denseMatrix> B11 = std::make_shared<diaq::denseMatrix>(8, b11);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase11;
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
    std::shared_ptr<diaq::denseMatrix> A12 = std::make_shared<diaq::denseMatrix>(8, a12);
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
    std::shared_ptr<diaq::denseMatrix> B12 = std::make_shared<diaq::denseMatrix>(8, b12);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase12;
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
    std::shared_ptr<diaq::denseMatrix> A13 = std::make_shared<diaq::denseMatrix>(8, a13);
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
    std::shared_ptr<diaq::denseMatrix> B13 = std::make_shared<diaq::denseMatrix>(8, b13);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase13;
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
    std::shared_ptr<diaq::denseMatrix> A14 = std::make_shared<diaq::denseMatrix>(16, a14);
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
    std::shared_ptr<diaq::denseMatrix> B14 = std::make_shared<diaq::denseMatrix>(16, b14);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase14;
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
    std::shared_ptr<diaq::denseMatrix> A15 = std::make_shared<diaq::denseMatrix>(16, a15);
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
    std::shared_ptr<diaq::denseMatrix> B15 = std::make_shared<diaq::denseMatrix>(16, b15);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase15;
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
    std::shared_ptr<diaq::denseMatrix> A16 = std::make_shared<diaq::denseMatrix>(16, a16);
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
    std::shared_ptr<diaq::denseMatrix> B16 = std::make_shared<diaq::denseMatrix>(16, b16);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase16;
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
    std::shared_ptr<diaq::denseMatrix> A17 = std::make_shared<diaq::denseMatrix>(8, a17);
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
    std::shared_ptr<diaq::denseMatrix> B17 = std::make_shared<diaq::denseMatrix>(8, b17);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase17;
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
    std::shared_ptr<diaq::denseMatrix> A18 = std::make_shared<diaq::denseMatrix>(8, a18);
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
    std::shared_ptr<diaq::denseMatrix> B18 = std::make_shared<diaq::denseMatrix>(8, b18);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase18;
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
    std::shared_ptr<diaq::denseMatrix> A19 = std::make_shared<diaq::denseMatrix>(8, a19);
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
    std::shared_ptr<diaq::denseMatrix> B19 = std::make_shared<diaq::denseMatrix>(8, b19);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase19;
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
    std::shared_ptr<diaq::denseMatrix> A20 = std::make_shared<diaq::denseMatrix>(8, a20);
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
    std::shared_ptr<diaq::denseMatrix> B20 = std::make_shared<diaq::denseMatrix>(8, b20);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase20;
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
    std::shared_ptr<diaq::denseMatrix> A21 = std::make_shared<diaq::denseMatrix>(8, a21);
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
    std::shared_ptr<diaq::denseMatrix> B21 = std::make_shared<diaq::denseMatrix>(8, b21);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase21;
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
    std::shared_ptr<diaq::denseMatrix> A22 = std::make_shared<diaq::denseMatrix>(8, a22);
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
    std::shared_ptr<diaq::denseMatrix> B22 = std::make_shared<diaq::denseMatrix>(8, b22);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase22;
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
    std::shared_ptr<diaq::denseMatrix> A23 = std::make_shared<diaq::denseMatrix>(8, a23);
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
    std::shared_ptr<diaq::denseMatrix> B23 = std::make_shared<diaq::denseMatrix>(8, b23);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase23;
    testCase23.push_back(A23);
    testCase23.push_back(B23);
    testCases.push_back(testCase23);

    // -----------------------------------------
    unsigned int *shapeA24 = new unsigned int[2]{3, 6};
    diaq::valType a24[18] = {
        1,2,3,4,5,6,
        7,8,9,10,11,12,
        13,14,15,16,17,18,
    };
    std::shared_ptr<diaq::denseMatrix> A24 = std::make_shared<diaq::denseMatrix>(&shapeA24, a24);
    unsigned int *shapeB24 = new unsigned int[2]{6, 2};
    diaq::valType b24[12] = {
        1,2,
        3,4,
        5,6,
        7,8,
        9,10,
        11,12,
    };
    std::shared_ptr<diaq::denseMatrix> B24 = std::make_shared<diaq::denseMatrix>(&shapeB24, b24);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase24;
    testCase24.push_back(A24);
    testCase24.push_back(B24);
    testCases.push_back(testCase24);

    // -----------------------------------------
    unsigned int *shapeA25 = new unsigned int[2]{3, 6};
    diaq::valType a25[18] = {
        1,2,3,4,5,6,
        7,8,9,10,11,12,
        13,14,15,16,17,18
    };
    std::shared_ptr<diaq::denseMatrix> A25 = std::make_shared<diaq::denseMatrix>(&shapeA25, a25);
    unsigned int *shapeB25 = new unsigned int[2]{6, 4};
    diaq::valType b25[24] = {
        20,21,22,23,
        24,25,26,27,
        28,29,30,31,
        32,33,34,35,
        36,37,38,39,
        40,41,42,43,
    };
    std::shared_ptr<diaq::denseMatrix> B25 = std::make_shared<diaq::denseMatrix>(&shapeB25, b25);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase25;
    testCase25.push_back(A25);
    testCase25.push_back(B25);
    testCases.push_back(testCase25);


    // -----------------------------------------
    unsigned int *shapeA26 = new unsigned int[2]{3, 6};
    diaq::valType a26[18] = {
        0,0,0,1,0,0,
        0,0,0,0,2,0,
        0,0,0,0,0,3,
    };
    std::shared_ptr<diaq::denseMatrix> A26 = std::make_shared<diaq::denseMatrix>(&shapeA26, a26);
    unsigned int *shapeB26 = new unsigned int[2]{6, 4};
    diaq::valType b26[24] = {
        0,4,0,0,
        0,0,5,0,
        0,0,0,6,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B26 = std::make_shared<diaq::denseMatrix>(&shapeB26, b26);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase26;
    testCase26.push_back(A26);
    testCase26.push_back(B26);
    testCases.push_back(testCase26);


    // -----------------------------------------
    unsigned int *shapeA27 = new unsigned int[2]{3, 6};
    diaq::valType a27[18] = {
        0,0,0,1,0,0,
        0,0,0,0,2,0,
        0,0,0,0,0,3,
    };
    std::shared_ptr<diaq::denseMatrix> A27 = std::make_shared<diaq::denseMatrix>(&shapeA27, a27);
    unsigned int *shapeB27 = new unsigned int[2]{6, 4};
    diaq::valType b27[24] = {
        0,0,0,0,
        0,0,0,0,
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
    };
    std::shared_ptr<diaq::denseMatrix> B27 = std::make_shared<diaq::denseMatrix>(&shapeB27, b27);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase27;
    testCase27.push_back(A27);
    testCase27.push_back(B27);
    testCases.push_back(testCase27);

    // -----------------------------------------
    unsigned int *shapeA28 = new unsigned int[2]{3, 6};
    diaq::valType a28[18] = {
        0,0,0,1,0,0,
        0,0,0,0,2,0,
        0,0,0,0,0,3,
    };
    std::shared_ptr<diaq::denseMatrix> A28 = std::make_shared<diaq::denseMatrix>(&shapeA28, a28);
    unsigned int *shapeB28 = new unsigned int[2]{6, 4};
    diaq::valType b28[24] = {
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
        0,0,0,0,
        0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B28 = std::make_shared<diaq::denseMatrix>(&shapeB28, b28);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase28;
    testCase28.push_back(A28);
    testCase28.push_back(B28);
    testCases.push_back(testCase28);


        // -----------------------------------------
    unsigned int *shapeA29 = new unsigned int[2]{3, 6};
    diaq::valType a29[18] = {
        0,0,0,0,0,0,
        1,0,0,0,0,0,
        0,2,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A29 = std::make_shared<diaq::denseMatrix>(&shapeA29, a29);
    unsigned int *shapeB29 = new unsigned int[2]{6, 4};
    diaq::valType b29[24] = {
        0,4,0,0,
        0,0,5,0,
        0,0,0,6,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B29 = std::make_shared<diaq::denseMatrix>(&shapeB29, b29);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase29;
    testCase29.push_back(A29);
    testCase29.push_back(B29);
    testCases.push_back(testCase29);


    // -----------------------------------------
    unsigned int *shapeA30 = new unsigned int[2]{3, 6};
    diaq::valType a30[18] = {
        0,0,0,0,0,0,
        1,0,0,0,0,0,
        0,2,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A30 = std::make_shared<diaq::denseMatrix>(&shapeA30, a30);
    unsigned int *shapeB30 = new unsigned int[2]{6, 4};
    diaq::valType b30[24] = {
        0,0,0,0,
        0,0,0,0,
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
    };
    std::shared_ptr<diaq::denseMatrix> B30 = std::make_shared<diaq::denseMatrix>(&shapeB30, b30);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase30;
    testCase30.push_back(A30);
    testCase30.push_back(B30);
    testCases.push_back(testCase30);

    // -----------------------------------------
    unsigned int *shapeA31 = new unsigned int[2]{3, 6};
    diaq::valType a31[18] = {
        0,0,0,0,0,0,
        1,0,0,0,0,0,
        0,2,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A31 = std::make_shared<diaq::denseMatrix>(&shapeA31, a31);
    unsigned int *shapeB31 = new unsigned int[2]{6, 4};
    diaq::valType b31[24] = {
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
        0,0,0,0,
        0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B31 = std::make_shared<diaq::denseMatrix>(&shapeB31, b31);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase31;
    testCase31.push_back(A31);
    testCase31.push_back(B31);
    testCases.push_back(testCase31);
    

    // -----------------------------------------
    unsigned int *shapeA32 = new unsigned int[2]{3, 6};
    diaq::valType a32[18] = {
        1,0,0,0,0,0,
        0,2,0,0,0,0,
        0,0,3,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A32 = std::make_shared<diaq::denseMatrix>(&shapeA32, a32);
    unsigned int *shapeB32 = new unsigned int[2]{6, 4};
    diaq::valType b32[24] = {
        0,4,0,0,
        0,0,5,0,
        0,0,0,6,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B32 = std::make_shared<diaq::denseMatrix>(&shapeB32, b32);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase32;
    testCase32.push_back(A32);
    testCase32.push_back(B32);
    testCases.push_back(testCase32);


    // -----------------------------------------
    unsigned int *shapeA33 = new unsigned int[2]{3, 6};
    diaq::valType a33[18] = {
        1,0,0,0,0,0,
        0,2,0,0,0,0,
        0,0,3,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A33 = std::make_shared<diaq::denseMatrix>(&shapeA33, a33);
    unsigned int *shapeB33 = new unsigned int[2]{6, 4};
    diaq::valType b33[24] = {
        0,0,0,0,
        0,0,0,0,
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
    };
    std::shared_ptr<diaq::denseMatrix> B33 = std::make_shared<diaq::denseMatrix>(&shapeB33, b33);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase33;
    testCase33.push_back(A33);
    testCase33.push_back(B33);
    testCases.push_back(testCase33);

    // -----------------------------------------
    unsigned int *shapeA34 = new unsigned int[2]{3, 6};
    diaq::valType a34[18] = {
        1,0,0,0,0,0,
        0,2,0,0,0,0,
        0,0,3,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A34 = std::make_shared<diaq::denseMatrix>(&shapeA34, a34);
    unsigned int *shapeB34 = new unsigned int[2]{6, 4};
    diaq::valType b34[24] = {
        4,0,0,0,
        0,5,0,0,
        0,0,6,0,
        0,0,0,7,
        0,0,0,0,
        0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B34 = std::make_shared<diaq::denseMatrix>(&shapeB34, b34);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase34;
    testCase34.push_back(A34);
    testCase34.push_back(B34);
    testCases.push_back(testCase34);

    // -----------------------------------------
    unsigned int *shapeA35 = new unsigned int[2]{3, 6};
    diaq::valType a35[18] = {
        0,0,0,0,5,0,
        0,0,0,0,0,6,
        0,0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A35 = std::make_shared<diaq::denseMatrix>(&shapeA35, a35);
    unsigned int *shapeB35 = new unsigned int[2]{6, 2};
    diaq::valType b35[12] = {
        0,0,
        0,0,
        0,0,
        0,0,
        0,0,
        4,0,
    };
    std::shared_ptr<diaq::denseMatrix> B35 = std::make_shared<diaq::denseMatrix>(&shapeB35, b35);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase35;
    testCase35.push_back(A35);
    testCase35.push_back(B35);
    testCases.push_back(testCase35);


    // -----------------------------------------
    unsigned int *shapeA36 = new unsigned int[2]{3, 6};
    diaq::valType a36[18] = {
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        5,0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A36 = std::make_shared<diaq::denseMatrix>(&shapeA36, a36);
    unsigned int *shapeB36 = new unsigned int[2]{6, 4};
    diaq::valType b36[24] = {
        0,0,0,10,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
        0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B36 = std::make_shared<diaq::denseMatrix>(&shapeB36, b36);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase36;
    testCase36.push_back(A36);
    testCase36.push_back(B36);
    testCases.push_back(testCase36);


    // -----------------------------------------
    unsigned int *shapeA37 = new unsigned int[2]{3, 6};
    diaq::valType a37[18] = {
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        1,0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> A37 = std::make_shared<diaq::denseMatrix>(&shapeA37, a37);
    unsigned int *shapeB37 = new unsigned int[2]{6, 2};
    diaq::valType b37[12] = {
        0,2,
        0,0,
        0,0,
        0,0,
        0,0,
        0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B37 = std::make_shared<diaq::denseMatrix>(&shapeB37, b37);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase37;
    testCase37.push_back(A37);
    testCase37.push_back(B37);
    testCases.push_back(testCase37);

    // -----------------------------------------
    unsigned int *shapeA38 = new unsigned int[2]{16, 4};
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
    std::shared_ptr<diaq::denseMatrix> A38 = std::make_shared<diaq::denseMatrix>(&shapeA38, a38);
    unsigned int *shapeB38 = new unsigned int[2]{4, 16};
    diaq::valType b38[64] = {
        8,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,
        0,0,10,0,0,0,0,0,0,0,0,11,0,0,0,0,
        0,0,0,0,12,0,0,0,0,0,0,0,0,13,0,0,
        0,0,0,0,0,0,14,0,0,0,0,0,0,0,0,15,
    };
    std::shared_ptr<diaq::denseMatrix> B38 = std::make_shared<diaq::denseMatrix>(&shapeB38, b38);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase38;
    testCase38.push_back(A38);
    testCase38.push_back(B38);
    testCases.push_back(testCase38);

    // -----------------------------------------
    unsigned int *shapeA39 = new unsigned int[2]{16, 4};
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
    std::shared_ptr<diaq::denseMatrix> A39 = std::make_shared<diaq::denseMatrix>(&shapeA39, a39);
    unsigned int *shapeB39 = new unsigned int[2]{4, 16};
    diaq::valType b39[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,14,0,0,0,0,0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B39 = std::make_shared<diaq::denseMatrix>(&shapeB39, b39);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase39;
    testCase39.push_back(A39);
    testCase39.push_back(B39);
    testCases.push_back(testCase39);


    // -----------------------------------------
    unsigned int *shapeA40 = new unsigned int[2]{16, 4};
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
    std::shared_ptr<diaq::denseMatrix> A40 = std::make_shared<diaq::denseMatrix>(&shapeA40, a40);
    unsigned int *shapeB40 = new unsigned int[2]{4, 16};
    diaq::valType b40[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B40 = std::make_shared<diaq::denseMatrix>(&shapeB40, b40);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase40;
    testCase40.push_back(A40);
    testCase40.push_back(B40);
    testCases.push_back(testCase40);


    // -----------------------------------------
    unsigned int *shapeA41 = new unsigned int[2]{16, 4};
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
    std::shared_ptr<diaq::denseMatrix> A41 = std::make_shared<diaq::denseMatrix>(&shapeA41, a41);
    unsigned int *shapeB41 = new unsigned int[2]{4, 16};
    diaq::valType b41[64] = {
        8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B41 = std::make_shared<diaq::denseMatrix>(&shapeB41, b41);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase41;
    testCase41.push_back(A41);
    testCase41.push_back(B41);
    testCases.push_back(testCase41);

    // -----------------------------------------
    unsigned int *shapeA42 = new unsigned int[2]{16, 4};
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
    std::shared_ptr<diaq::denseMatrix> A42 = std::make_shared<diaq::denseMatrix>(&shapeA42, a42);
    unsigned int *shapeB42 = new unsigned int[2]{4, 16};
    diaq::valType b42[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,
    };
    std::shared_ptr<diaq::denseMatrix> B42 = std::make_shared<diaq::denseMatrix>(&shapeB42, b42);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase42;
    testCase42.push_back(A42);
    testCase42.push_back(B42);
    testCases.push_back(testCase42);

    // -----------------------------------------
    unsigned int *shapeA43 = new unsigned int[2]{16, 4};
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
    std::shared_ptr<diaq::denseMatrix> A43 = std::make_shared<diaq::denseMatrix>(&shapeA43, a43);
    unsigned int *shapeB43 = new unsigned int[2]{4, 16};
    diaq::valType b43[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B43 = std::make_shared<diaq::denseMatrix>(&shapeB43, b43);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase43;
    testCase43.push_back(A43);
    testCase43.push_back(B43);
    testCases.push_back(testCase43);

    // -----------------------------------------
    unsigned int *shapeA44 = new unsigned int[2]{16, 4};
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
    std::shared_ptr<diaq::denseMatrix> A44 = std::make_shared<diaq::denseMatrix>(&shapeA44, a44);
    unsigned int *shapeB44 = new unsigned int[2]{4, 16};
    diaq::valType b44[64] = {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,11,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B44 = std::make_shared<diaq::denseMatrix>(&shapeB44, b44);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase44;
    testCase44.push_back(A44);
    testCase44.push_back(B44);
    testCases.push_back(testCase44);

    // -----------------------------------------
    unsigned int *shapeA45 = new unsigned int[2]{16, 4};
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
    std::shared_ptr<diaq::denseMatrix> A45 = std::make_shared<diaq::denseMatrix>(&shapeA45, a45);
    unsigned int *shapeB45 = new unsigned int[2]{4, 16};
    diaq::valType b45[64] = {
        0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    };
    std::shared_ptr<diaq::denseMatrix> B45 = std::make_shared<diaq::denseMatrix>(&shapeB45, b45);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase45;
    testCase45.push_back(A45);
    testCase45.push_back(B45);
    testCases.push_back(testCase45);

    // -----------------------------------------
    unsigned int *shapeA46 = new unsigned int[2]{32, 2};
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
    std::shared_ptr<diaq::denseMatrix> A46 = std::make_shared<diaq::denseMatrix>(&shapeA46, a46);
    unsigned int *shapeB46 = new unsigned int[2]{2, 8};
    diaq::valType b46[64] = {
        1,0,0,1,0,0,0,0,
        0,0,0,0,0,1,1,0,
    };
    std::shared_ptr<diaq::denseMatrix> B46 = std::make_shared<diaq::denseMatrix>(&shapeB46, b46);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase46;
    testCase46.push_back(A46);
    testCase46.push_back(B46);
    testCases.push_back(testCase46);


    // -----------------------------------------
    unsigned int *shapeA47 = new unsigned int[2]{8, 2};
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
    std::shared_ptr<diaq::denseMatrix> A47 = std::make_shared<diaq::denseMatrix>(&shapeA47, a47);
    unsigned int *shapeB47 = new unsigned int[2]{2, 2};
    diaq::valType b47[4] = {
        0.707107,0,
        0,-0.707107,
    };
    std::shared_ptr<diaq::denseMatrix> B47 = std::make_shared<diaq::denseMatrix>(&shapeB47, b47);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase47;
    testCase47.push_back(A47);
    testCase47.push_back(B47);
    testCases.push_back(testCase47);

    // -----------------------------------------
    unsigned int *shapeA48 = new unsigned int[2]{4, 5};
    diaq::valType a48[20] = {
        1, 2, 3, 4, 5,
        6, 7, 8, 9, 10,
        11, 12, 13, 14, 15,
        16, 17, 18, 19, 20,
    };
    std::shared_ptr<diaq::denseMatrix> A48 = std::make_shared<diaq::denseMatrix>(&shapeA48, a48);
    unsigned int *shapeB48 = new unsigned int[2]{5, 3};
    diaq::valType b48[15] = {
        1, 6, 11,
        2, 7, 12,
        3, 8, 13,
        4, 9, 14,
        5, 10, 15,
    };
    std::shared_ptr<diaq::denseMatrix> B48 = std::make_shared<diaq::denseMatrix>(&shapeB48, b48);
    std::vector<std::shared_ptr<diaq::denseMatrix> > testCase48;
    testCase48.push_back(A48);
    testCase48.push_back(B48);
    testCases.push_back(testCase48);

    if(argc == 1) {
        for(unsigned int i = 0; i < testCases.size(); i++) {
            std::cout << "test case - " << i;
            std::shared_ptr<diaq::denseMatrix> p = denseProduct(testCases[i][0], testCases[i][1]);
            // std::cout << std::endl << " ---- dense product ---- " << std::endl;
            // p->print();
            // std::cout << " ---- dense product ---- " << std::endl;
            std::shared_ptr<diaq::diaQMatrix> dp = p->convertToQuantumSparse();
            // std::cout << " ---- correct answer ---- " << std::endl;
            // dp->print();
            // std::cout << " ---- correct answer ---- " << std::endl;
            std::shared_ptr<diaq::diaQMatrix> first = testCases[i][0]->convertToQuantumSparse();
            // std::cout << " -- first -- " << std::endl;
            // first->print();
            // std::cout << " -- first -- " << std::endl;
            std::shared_ptr<diaq::diaQMatrix> second = testCases[i][1]->convertToQuantumSparse();
            // std::cout << " -- second -- " << std::endl;
            // second->print();
            // std::cout << " -- second -- " << std::endl;
            std::shared_ptr<diaq::diaQMatrix> qp = product(first, second);
            // std::cout << " -- qp -- " << std::endl;
            // qp->print();
            // std::cout << " -- qp -- " << std::endl;
            std::string check = checkResult(dp, qp);
            std::cout << " = " << check << std::endl;
        }
    }
    else if (strcmp(argv[1], "check_openmp") == 0) {
        // Run OpenMP all thread tests! check if parallel regions are being multi-threaded
        printf("NUMBER_OF_OMP_THREADS is set to:  %d\n", NUMBER_OF_OMP_THREADS);
        #pragma omp parallel
        {
            #pragma omp single
            {
                std::cout << "\n================================================= \nNUMBER OF THREADS via omp_get_num_threads = " << omp_get_num_threads() << 
                            "\n================================================= \n" << std::endl;
            }
        }
    }
    else if(strcmp(argv[1], "reshape") == 0) {
        // testing reshape operations
        B8->print();
        std::cout << " -- " << std::endl;
        std::vector<unsigned int> dims{8,8};
        std::shared_ptr<diaq::diaQMatrix> q_B8 = B8->convertToQuantumSparse(dims);
        q_B8->print();
        std::cout << " -- " << std::endl;

        std::vector<unsigned int> new_dims{4, 16};
        std::shared_ptr<diaq::diaQMatrix> reshaped_q_B8 = reshape(q_B8, new_dims);
        reshaped_q_B8->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Tensor Reshape Done -- " << std::endl;
        std::cout << " -- " << std::endl;
        // testing matrix_reshape
        unsigned int *new_mat_dims = new unsigned int[2]{4, 16};
        std::shared_ptr<diaq::diaQMatrix> matrix_reshaped_q_B8 = matrix_reshape(q_B8, new_mat_dims);
        matrix_reshaped_q_B8->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Matrix Reshape Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "matrix_transpose") == 0) {
        // testing matrix transposition operation
        A24->print();
        std::cout << " -- " << std::endl;

        std::vector<unsigned int> dims{3,6};
        std::shared_ptr<diaq::diaQMatrix> q_A24 = A24->convertToQuantumSparse(dims);
        q_A24->print();
        std::cout << " -- " << std::endl;

        std::vector<unsigned int> axes{};
        std::shared_ptr<diaq::diaQMatrix> res = transpose(q_A24, axes);
        res->print();
        std::cout << " -- " << std::endl;

        res->convertToDenseMatrix(res->matrix_shape)->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Matrix Transpose Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "pos") == 0) {
        // testing getMatrixPosition and getTensorPosition
        A24->shape = std::vector<unsigned int>{3,3,2};
        A24->print();
        std::cout << " -- " << std::endl;
        std::vector<unsigned int> dims{3,6};
        std::shared_ptr<diaq::diaQMatrix> q_A24 = A24->convertToQuantumSparse(dims);
        q_A24->print();
        std::cout << " -- " << std::endl;

        unsigned int di = 2;
        unsigned int dp = 2;

        std::cout << "getting element in diaq::diagonal idx = " << di << " position = " << dp << std::endl;
        // unsigned int *mat_pos = q_A24->getMatrixPosition(di, dp);
        std::shared_ptr<unsigned int[]> mat_pos = q_A24->getMatrixPosition(di, dp);
        std::cout << "matrix position - " << mat_pos[0] << "," << mat_pos[1] << std::endl;

        std::vector<unsigned int> ten_pos = q_A24->getTensorPosition(di, dp);
        std::cout << "tensor position - " << ten_pos[0] << "," << ten_pos[1] << "," << ten_pos[2] << std::endl;

        std::cout << "reading element from dense version: " << A24->getItem(ten_pos) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- getMatrixPosition and getTensorPosition Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "tensor_transpose") == 0) {
        // testing tensor transposition operation
        std::cout << " --example1-- " << std::endl;
        A24->print();
        std::cout << " -- " << std::endl;

        std::vector<unsigned int> dims{3,6};
        std::shared_ptr<diaq::diaQMatrix> q_A24 = A24->convertToQuantumSparse(dims);
        q_A24->shape = std::vector<unsigned int>{3,3,2};
        q_A24->print();
        std::cout << " -- " << std::endl;

        std::vector<unsigned int> order{};
        std::shared_ptr<diaq::diaQMatrix> res = transpose(q_A24, order);
        std::cout << " -- " << std::endl;
        res->print();
        std::cout << " -- " << std::endl;
        res->convertToDenseMatrix(res->matrix_shape)->print();

        // another example
        // testing tensor transposition operation
        std::cout << " --example2-- " << std::endl;
        A47->print();
        std::cout << " -- " << std::endl;

        std::shared_ptr<diaq::diaQMatrix> q_A47 = A47->convertToQuantumSparse(A47->matrix_shape);
        q_A47->shape = std::vector<unsigned int>{2,2,2,2};
        q_A47->print();
        std::cout << " -- " << std::endl;

        res = transpose(q_A47, order);
        std::cout << " -- " << std::endl;
        res->print();
        std::cout << " -- " << std::endl;
        res->convertToDenseMatrix(res->matrix_shape)->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Tensor Transpose Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "operator_overloading_product") == 0) {
        // testing operator overloading
        const std::string str_i = "30";
        unsigned int i = std::stoi(str_i);
        std::cout << "test case - " << i;
        std::shared_ptr<diaq::denseMatrix> p = denseProduct(testCases[i][0], testCases[i][1]);
        std::cout << std::endl << " ---- dense product ---- " << std::endl;
        p->print();
        std::cout << " ---- dense product ---- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> dp = p->convertToQuantumSparse(p->matrix_shape);
        std::cout << " ---- correct answer ---- " << std::endl;
        dp->print();
        std::cout << " ---- correct answer ---- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> first = testCases[i][0]->convertToQuantumSparse(testCases[i][0]->matrix_shape);
        std::cout << " -- first -- " << std::endl;
        first->print();
        std::cout << " -- first -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> second = testCases[i][1]->convertToQuantumSparse(testCases[i][1]->matrix_shape);
        std::cout << " -- second -- " << std::endl;
        second->print();
        std::cout << " -- second -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qp = (first) * (second);
        std::cout << " -- qp -- " << std::endl;
        qp->print();
        std::cout << " -- qp -- " << std::endl;
        std::string check = checkResult(dp, qp);
        std::cout << " = " << check << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- Operator * Overloading Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "flatten") == 0) {
        // testing flatten operation
        std::cout << " --example1-- " << std::endl;
        A24->print();
        std::cout << " -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> q_A24 = A24->convertToQuantumSparse(A24->matrix_shape);
        q_A24->print();
        std::cout << " -- " << std::endl;
        std::complex<diaq::valType> *values = q_A24->flatten();
        for (unsigned int i = 0; i < q_A24->matrix_shape[0] * q_A24->matrix_shape[1]; i++) {
            std::cout << values[i] << " ";
        }
        std::cout << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- Flatten Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "operator_overloading_transpose") == 0) {
        // tranpose using matrix->transpose instead of transpose(matrix, order)
        std::shared_ptr<diaq::diaQMatrix> q_A47 = A47->convertToQuantumSparse(A47->matrix_shape);
        q_A47->shape = std::vector<unsigned int>{2,2,2,2};
        q_A47->print();
        std::cout << " -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> res = diaq::transpose(q_A47, std::vector<unsigned int>{});
        res->print();
        std::cout << " -- " << std::endl;
        res->convertToDenseMatrix(res->matrix_shape)->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Transpose Test Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "spmv_1") == 0) {
        // testing spMV here.
        std::cout << " --matrix-- " << std::endl;
        A25->print();
        std::cout << " --sparse_matrix-- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> q_A25 = A25->convertToQuantumSparse(A25->matrix_shape);
        q_A25->print();
        std::cout << " --x-- " << std::endl;
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(A25->matrix_shape[1], 1.0);
        x->print();
        std::cout << " --MV-- " << std::endl;
        std::shared_ptr<diaq::vector> dense_y = std::make_shared<diaq::vector>(A25->matrix_shape[0], 0.0);
        dense_y = diaq::MV(A25, x, dense_y);
        dense_y->print();
        std::cout << " --spMV-- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(A25->matrix_shape[0], 0.0);
        diaq::spMV(q_A25, x, y);
        y->print();
        std::cout << " -- " << std::endl;
        std::cout << "Checking correctness: ";
        std::cout << check_vectors(dense_y, y) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "spmv_2") == 0) {
        // matrix_shape (8,8)
        // tensor_shape (8,8)
        // (dIndex=-1) [(0.707107,0),(0,0),(0.707107,0),(0,0),(0.707107,0),(0,0),(0.707107,0)]
        // (dIndex=0) [(0.707107,0),(-0.707107,0),(0.707107,0),(-0.707107,0),(0.707107,0),(-0.707107,0),(0.707107,0),(-0.707107,0)]
        // (dIndex=1) [(0.707107,0),(0,0),(0.707107,0),(0,0),(0.707107,0),(0,0),(0.707107,0)]
        // --- times ---
        // length (8) [(0.279931,0.085921), (0.279931,0.085921), (0,0), (0,0), (0,0), (0,0), (0.126182,0.631137), (0.126182,0.631137)]
        // ---
        // ---
        // --- spMV result ---
        // ---
        // length (8) [(0.395882,0.121511), (-5.55112e-17,-2.08167e-17), (0,0), (0,0), (0,0), (0,0), (0.178448,0.892563), (-5.55112e-17,0)]
        // testing spMV here.
        diaq::valType h_val = (diaq::valType) ((diaq::valType)1.0 / std::sqrt((diaq::valType)2.0));
        unsigned int *shape_mat = new unsigned int[2]{8, 8};
        diaq::valType mat_vals[64] = {
            h_val,                h_val,                0,                0,                0,                0,                0,                0,

            h_val,                -1 * h_val,                0,                0,                0,                0,                0,                0,
            
            0,                0,                h_val,                h_val,                0,                0,                0,                0,
            
            0,                0,                h_val,                -1 * h_val,                0,                0,                0,                0,
            
            0,                0,                0,                0,                h_val,                h_val,                0,                0,
            
            0,                0,                0,                0,                h_val,                -1 * h_val,                0,                0,
            
            0,                0,                0,                0,                0,                0,                h_val,                h_val,
            
            0,                0,                0,                0,                0,                0,                h_val,                -1 * h_val,
        };
        std::cout << " --matrix-- " << std::endl;
        std::shared_ptr<diaq::denseMatrix> mat = std::make_shared<diaq::denseMatrix>(&shape_mat, mat_vals);
        mat->print();
        std::cout << " --sparse_matrix-- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> mat_dq = mat->convertToQuantumSparse(mat->matrix_shape);
        mat_dq->print();
        std::cout << " --x-- " << std::endl;
        diaq::valType x_real_vals[8] = {0.279931, 0.279931, 0, 0, 0, 0, 0.126182, 0.126182};
        diaq::valType x_imag_vals[8] = {0.085921, 0.085921, 0, 0, 0, 0, 0.631137, 0.631137};
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(8, x_real_vals, x_imag_vals);
        x->print();
        std::cout << " --MV-- " << std::endl;
        std::shared_ptr<diaq::vector> dense_y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        dense_y = diaq::MV(mat, x, dense_y);
        dense_y->print();
        std::cout << " --spMV-- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        diaq::spMV(mat_dq, x, y);
        y->print();
        std::cout << " -- " << std::endl;
        std::cout << "Checking correctness: ";
        std::cout << check_vectors(dense_y, y) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "spmv_3") == 0) {
        // diaq::valType h_val = (diaq::valType) ((diaq::valType)1.0 / std::sqrt((diaq::valType)2.0));
        unsigned int *shape_mat = new unsigned int[2]{8, 8};
        diaq::valType mat_vals_real[64] = {
            0,                0,                0,                0,                0,                0,                0,                0,

            0,                0,                0,                0,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0,                0,
        };
        diaq::valType mat_vals_imag[64] = {
            0,                -1,                0,                0,                0,                0,                0,                0,

            1,                0,                0,                0,                0,                0,                0,                0,
            
            0,                0,                0,                -1,                0,                0,                0,                0,
            
            0,                0,                1,                0,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                -1,                0,                0,
            
            0,                0,                0,                0,                1,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0,                -1,
            
            0,                0,                0,                0,                0,                0,                1,                0,
        };
        std::cout << " --matrix-- " << std::endl;
        std::shared_ptr<diaq::denseMatrix> mat = std::make_shared<diaq::denseMatrix>(&shape_mat, mat_vals_real, mat_vals_imag);
        mat->print();
        std::cout << " --sparse_matrix-- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> mat_dq = mat->convertToQuantumSparse(mat->matrix_shape);
        mat_dq->print();
        std::cout << " --x-- " << std::endl;
        diaq::valType x_real_vals[8] = {0.395882, 0.000000, 0.785682, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000};
        diaq::valType x_imag_vals[8] = {0.121511, 0.000000, 0.459582, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000};
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(8, x_real_vals, x_imag_vals);
        x->print();
        std::cout << " --MV-- " << std::endl;
        std::shared_ptr<diaq::vector> dense_y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        dense_y = diaq::MV(mat, x, dense_y);
        dense_y->print();
        std::cout << " --spMV-- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        diaq::spMV(mat_dq, x, y);
        y->print();
        std::cout << " -- " << std::endl;
        std::cout << "Checking correctness: ";
        std::cout << check_vectors(dense_y, y) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "spmv_4") == 0) {
        //  -- unitary matrix --
        // matrix_shape (8,8)
        // tensor_shape (8,8)
        // (dIndex=-1) [(0,0),(0,0),(0,0),(0,0),(1,0),(0,0),(1,0)]
        // (dIndex=0) [(1,0),(1,0),(1,0),(1,0),(0,0),(0,0),(0,0),(0,0)]
        // (dIndex=1) [(0,0),(0,0),(0,0),(0,0),(1,0),(0,0),(1,0)]
        // -- current vector --
        // length (8) [(0.279931,0.085921), (0.000000,0.000000), (0.126182,0.631137), (0.000000,0.000000), (0.279931,0.085921), (0.000000,0.000000), (0.126182,0.631137), (0.000000,0.000000)]
        // diaq::valType h_val = (diaq::valType) ((diaq::valType)1.0 / std::sqrt((diaq::valType)2.0));
        unsigned int *shape_mat = new unsigned int[2]{8, 8};
        diaq::valType mat_vals_real[64] = {
            1,                0,                0,                0,                0,                0,                0,                0,

            0,                1,                0,                0,                0,                0,                0,                0,
            
            0,                0,                1,                0,                0,                0,                0,                0,
            
            0,                0,                0,                1,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                1,                0,                0,
            
            0,                0,                0,                0,                1,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0,                1,
            
            0,                0,                0,                0,                0,                0,                1,                0,
        };
        std::cout << " --matrix-- " << std::endl;
        std::shared_ptr<diaq::denseMatrix> mat = std::make_shared<diaq::denseMatrix>(&shape_mat, mat_vals_real);
        mat->print();
        std::cout << " --sparse_matrix-- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> mat_dq = mat->convertToQuantumSparse(mat->matrix_shape);
        mat_dq->print();
        std::cout << " --x-- " << std::endl;
        diaq::valType x_real_vals[8] = {0.279931, 0.000000, 0.126182, 0.000000, 0.279931, 0.000000, 0.126182, 0.000000};
        diaq::valType x_imag_vals[8] = {0.085921, 0.000000, 0.631137, 0.000000, 0.085921, 0.000000, 0.631137, 0.000000};
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(8, x_real_vals, x_imag_vals);
        x->print();
        std::cout << " --MV-- " << std::endl;
        std::shared_ptr<diaq::vector> dense_y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        dense_y = diaq::MV(mat, x, dense_y);
        dense_y->print();
        std::cout << " --spMV-- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        diaq::spMV(mat_dq, x, y);
        y->print();
        std::cout << " -- " << std::endl;
        std::cout << "Checking correctness: ";
        std::cout << check_vectors(dense_y, y) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "spmv_5") == 0) {
        // diaq::valType h_val = (diaq::valType) ((diaq::valType)1.0 / std::sqrt((diaq::valType)2.0));
        unsigned int *shape_mat = new unsigned int[2]{8, 8};
        diaq::valType mat_vals_real[64] = {
            0,                1,                0,                0,                0,                0,                0,                0,

            1,                0,                0,                0,                0,                0,                0,                0,
            
            0,                0,                0,                1,                0,                0,                0,                0,
            
            0,                0,                1,                0,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                1,                0,                0,
            
            0,                0,                0,                0,                1,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0,                1,
            
            0,                0,                0,                0,                0,                0,                1,                0,
        };
        std::cout << " --matrix-- " << std::endl;
        std::shared_ptr<diaq::denseMatrix> mat = std::make_shared<diaq::denseMatrix>(&shape_mat, mat_vals_real);
        mat->print();
        std::cout << " --sparse_matrix-- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> mat_dq = mat->convertToQuantumSparse(mat->matrix_shape);
        mat_dq->print();
        std::cout << " --x-- " << std::endl;
        diaq::valType x_real_vals[8] = {1.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000};
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(8, x_real_vals);
        x->print();
        std::cout << " --MV-- " << std::endl;
        std::shared_ptr<diaq::vector> dense_y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        dense_y = diaq::MV(mat, x, dense_y);
        dense_y->print();
        std::cout << " --spMV-- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        diaq::spMV(mat_dq, x, y);
        y->print();
        std::cout << " -- " << std::endl;
        std::cout << "Checking correctness: ";
        std::cout << check_vectors(dense_y, y) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "spmv_6") == 0) {
        unsigned int *shape_mat = new unsigned int[2]{8, 8};
        diaq::valType mat_vals_real[64] = {
            -0.483542,                0,                -0.152339,                0,                0,                0,                0,                0,

            0,                -0.483542,                0,                -0.152339,                0,                0,                0,                0,
            
            0.234435,                0,                -0.481306,                0,                0,                0,                0,                0,
            
            0,                0.234435,                0,                -0.481306,                0,                0,                0,                0,
            
            0,                0,                0,                0,                -0.483542,                0,                -0.152339,                0,
            
            0,                0,                0,                0,                0,                -0.483542,                0,                -0.152339,
            
            0,                0,                0,                0,                0.234435,                0,                -0.481306,                0,
            
            0,                0,                0,                0,                0,                0.234435,                0,                -0.481306,
        };
        diaq::valType mat_vals_imag[64] = {
            0,                0,                0.861963,                0,                0,                0,                0,                0,

            0,                0,                0,                0.861963,                0,                0,                0,                0,
            
            0.843343,                0,                0.0464493,                0,                0,                0,                0,                0,
            
            0,                0.843343,                0,                0.0464493,                0,                0,                0,                0,
            
            0,                0,                0,                0,                0,                0,                0.861963,                0,
            
            0,                0,                0,                0,                0,                0,                0,                0.861963,
            
            0,                0,                0,                0,                0.843343,                0,                0.0464493,                0,
            
            0,                0,                0,                0,                0,                0.843343,                0,                0.0464493,
        };
        std::cout << " --matrix-- " << std::endl;
        std::shared_ptr<diaq::denseMatrix> mat = std::make_shared<diaq::denseMatrix>(&shape_mat, mat_vals_real, mat_vals_imag);
        mat->print();
        std::cout << " --sparse_matrix-- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> mat_dq = mat->convertToQuantumSparse(mat->matrix_shape);
        mat_dq->print();
        std::cout << " --x-- " << std::endl;
        diaq::valType x_real_vals[8] = {0.603145, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000};
        diaq::valType x_imag_vals[8] = {0,0,-0.797631,0,0,0,0,0};
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(8, x_real_vals, x_imag_vals);
        x->print();
        std::cout << " --MV-- " << std::endl;
        std::shared_ptr<diaq::vector> dense_y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        dense_y = diaq::MV(mat, x, dense_y);
        dense_y->print();
        std::cout << " --spMV-- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat_dq->shape[0], 0.0);
        diaq::spMV(mat_dq, x, y);
        y->print();
        std::cout << " -- " << std::endl;
        std::cout << "Checking correctness: ";
        std::cout << check_vectors(dense_y, y) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "spmv_7") == 0) {
        // matrix_shape (16,16)
        // tensor_shape (16,16)
        // (dIndex=-1) [(0,1),(0,1),(0,1),(0,1),(0,1),(0,1),(0,1),(0,1),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0)]
        // (dIndex=1) [(0,-1),(0,-1),(0,-1),(0,-1),(0,-1),(0,-1),(0,-1),(0,-1),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0),(0,0)]
        // -- current vector --
        // length (16) [(0.000000,0.000000), (0.000000,0.000000), (0.000000,1.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000), (0.000000,0.000000)]
        #if NUM_BYTES_ALIGNED == -1
            diaq::valType *reals = (diaq::valType *)calloc(15, sizeof(diaq::valType));
            diaq::valType *imags = (diaq::valType *)calloc(15, sizeof(diaq::valType));
        #else
            diaq::valType *reals = (diaq::valType *)aligned_alloc(NUM_BYTES_ALIGNED, 15 * sizeof(diaq::valType));
            diaq::valType *imags = (diaq::valType *)aligned_alloc(NUM_BYTES_ALIGNED, 15 * sizeof(diaq::valType));
            #pragma omp parallel for
            for(size_t i = 0; i < 15; i++) {
                reals[i] = 0;
                imags[i] = 0;
            }
        #endif
        for(int i = 0; i < 8; i++) imags[i] = 1;
        std::shared_ptr<diaq::diagonal> d1 = std::make_shared<diaq::diagonal>(-1, 15, reals, imags);

        #if NUM_BYTES_ALIGNED == -1
            diaq::valType *r = (diaq::valType *)calloc(15, sizeof(diaq::valType));
            diaq::valType *im = (diaq::valType *)calloc(15, sizeof(diaq::valType));
        #else
            diaq::valType *r = (diaq::valType *)aligned_alloc(NUM_BYTES_ALIGNED, 15 * sizeof(diaq::valType));
            diaq::valType *im = (diaq::valType *)aligned_alloc(NUM_BYTES_ALIGNED, 15 * sizeof(diaq::valType));
            #pragma omp parallel for
            for(size_t i = 0; i < 15; i++) {
                r[i] = 0;
                im[i] = 0;
            }
        #endif
        for(int i = 0; i < 8; i++) im[i] = -1;
        std::shared_ptr<diaq::diagonal> d2 = std::make_shared<diaq::diagonal>(1, 15, r, im);

        std::shared_ptr<diaq::diaQMatrix> q_mat = std::make_shared<diaq::diaQMatrix>((unsigned int)16);
        q_mat->setDiagonal(-1, d1);
        q_mat->setDiagonal(1, d2);

        printf("Matrix:\n");
        q_mat->print();

        std::cout << " --x-- " << std::endl;
        diaq::valType x_real_vals[16] = {0};
        diaq::valType x_imag_vals[16] = {0};
        x_imag_vals[2] = 1.0;
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(16, x_real_vals, x_imag_vals);
        x->print();
        std::cout << " --MV-- " << std::endl;
        std::shared_ptr<diaq::vector> dense_y = std::make_shared<diaq::vector>(16, 0.0);
        dense_y = diaq::MV(q_mat->convertToDenseMatrix(), x, dense_y);
        dense_y->print();
        std::cout << " --spMV-- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(dense_y->numRows);
        diaq::spMV(q_mat, x, y);
        y->print();
        std::cout << " -- " << std::endl;
        std::cout << "Checking correctness: ";
        std::cout << check_vectors(dense_y, y) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "spmv_8") == 0) {
        // matrix_shape (16,16)
        // tensor_shape (16,16)
        // (dIndex=0) (dLength=16) [(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0)]

        #if NUM_BYTES_ALIGNED == -1
            diaq::valType *reals = (diaq::valType *)calloc(16, sizeof(diaq::valType));
            diaq::valType *imags = (diaq::valType *)calloc(16, sizeof(diaq::valType));
        #else
            diaq::valType *reals = (diaq::valType *)aligned_alloc(NUM_BYTES_ALIGNED, 16 * sizeof(diaq::valType));
            diaq::valType *imags = (diaq::valType *)aligned_alloc(NUM_BYTES_ALIGNED, 16 * sizeof(diaq::valType));
            #pragma omp parallel for
            for(size_t i = 0; i < 16; i++) {
                reals[i] = 0;
                imags[i] = 0;
            }
        #endif

        for(int i = 0; i < 8; i++) {
            reals[i] = 1;
        }
        for(int i = 8; i < 16; i++) {
            reals[i] = -1;
        }
        
        std::shared_ptr<diaq::diagonal> d0 = std::make_shared<diaq::diagonal>(0, 16, reals, imags);
        std::shared_ptr<diaq::diaQMatrix> q_mat_1 = std::make_shared<diaq::diaQMatrix>((unsigned int)16);
        q_mat_1->setDiagonal(0, d0);

        std::shared_ptr<diaq::identityMatrix> q_mat = std::make_shared<diaq::identityMatrix>((unsigned int)16);

        printf("Matrix:\n");
        q_mat->print();

        std::cout << " --x-- " << std::endl;
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(16, 1.0, 0.0);
        x->print();
        std::cout << " --MV-- " << std::endl;

        std::shared_ptr<diaq::vector> dense_y = std::make_shared<diaq::vector>(16, 0.0);
        dense_y = diaq::MV(q_mat->convertToDenseMatrix(), x, dense_y);
        dense_y->print();

        std::cout << " --spMV-- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(dense_y->numRows);
        diaq::spMV(q_mat, x, y);
        y->print();
        
        std::cout << " -- " << std::endl;
        std::cout << "Checking correctness: ";
        std::cout << check_vectors(dense_y, y) << std::endl;
        std::cout << " -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "matrix_kron_identity_times_vector") == 0) {
        std::cout << " -- testing matrix_kron_identity_times_vector -- " << std::endl;
        diaq::valType prime_vals[16] = {
            2, 3, 5, 7,
            11, 13, 17, 19,
            23, 29, 31, 37,
            41, 43, 47, 53
        };
        unsigned int *shape = new unsigned int[2]{4, 4};
        std::shared_ptr<diaq::denseMatrix> dense_prime_matrix = std::make_shared<diaq::denseMatrix>(&shape, prime_vals);
        std::shared_ptr<diaq::diaQMatrix> gate_matrix = dense_prime_matrix->convertToQuantumSparse();
        std::cout << " -- gate_matrix -- " << std::endl;
        gate_matrix->print();

        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::diaQMatrix> mat = diaq::kron_product(gate_matrix, id4);
        std::cout << " -- matrix kron I -- " << std::endl;
        mat->print();

        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(16, 1.0);
        std::shared_ptr<diaq::vector> correct_y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        diaq::spMV(mat, x, correct_y);
        printf(" -- correct answer -- \n");
        correct_y->print();

        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        diaq::matrix_kron_identity_times_vector(gate_matrix, (unsigned int)2, x, y);
        y->print();

        std::cout << "Checking correctness: ";
        std::cout << check_vectors(correct_y, y) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "matrix_kron_identity_times_vector_1") == 0) {
        // testing matrix_kron_identity_times_vector
        std::cout << " -- testing matrix_kron_identity_times_vector -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qspa = A23->convertToQuantumSparse();
        // qspa->deleteDiagonal(-4);
        // qspa->deleteDiagonal(4);
        qspa->print();
        std::shared_ptr<diaq::diaQMatrix> mat = diaq::matrix_kron_identity(qspa, (unsigned int)2);
        mat->print();

        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(mat->shape[0], 1.0, 0.0);
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        std::shared_ptr<diaq::vector> correct_y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        diaq::spMV(mat, x, correct_y);

        printf(" -- correct answer -- \n");
        correct_y->print();

        printf(" -- new way to do it -- \n");
        diaq::matrix_kron_identity_times_vector(qspa, (unsigned int)2, x, y);
        y->print();

        std::cout << "Checking correctness: ";
        std::cout << check_vectors(correct_y, y) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "matrix_kron_identity_times_vector_2") == 0) {
        // matrix_shape (2,2)
        // tensor_shape (2,2)
        // (dIndex=-1) (dLength=1) [(0.707107,0)]
        // (dIndex=0) (dLength=2) [(0.707107,0),(-0.707107,0)]
        // (dIndex=1) (dLength=1) [(0.707107,0)]
        //         after = 3
        std::cout << " -- testing matrix_kron_identity_times_vector_2 -- " << std::endl;
        diaq::valType reals[4] = { // 2 qubit gate, all elements 4x4
            0.707107, 0.707107,
            0.707107, -0.707107
        }; // Hadamard gate
        unsigned int after = 3; // qubits after gate

        unsigned int *s = new unsigned int[2]{2,2};
        std::shared_ptr<diaq::denseMatrix> denseGate = std::make_shared<diaq::denseMatrix>(&s, reals);
        std::shared_ptr<diaq::diaQMatrix> gate = denseGate->convertToQuantumSparse();
        gate->print();

        std::shared_ptr<diaq::diaQMatrix> mat = diaq::matrix_kron_identity(gate, after);
        mat->print();

        // setting x vector to ket 0
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        x->realValues[0] = 1.0; // set to ket 0

        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        std::shared_ptr<diaq::vector> correct_y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        diaq::spMV(mat, x, correct_y);

        printf(" -- correct answer -- \n");
        correct_y->print();

        printf(" -- new way to do it -- \n");
        diaq::matrix_kron_identity_times_vector(gate, after, x, y);
        y->print();

        std::cout << "Checking correctness: ";
        std::cout << check_vectors(correct_y, y) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "identity_kron_matrix_kron_identity_times_vector_1") == 0) {
        // testing identity_kron_matrix_kron_identity_times_vector
        std::cout << " -- testing identity_kron_matrix_kron_identity_times_vector -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qspa = A23->convertToQuantumSparse();
        // qspa->deleteDiagonal(0);
        // qspa->deleteDiagonal(4);
        qspa->print();
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(64, 1.0);
        std::shared_ptr<diaq::diaQMatrix> mat = diaq::matrix_kron_identity(qspa, (unsigned int)2);
        mat->print();
        std::shared_ptr<diaq::vector> correct_y = std::make_shared<diaq::vector>((unsigned int)2 * mat->shape[0], 0.0);
        diaq::identity_kron_matrix_times_vector((unsigned int)1, mat, x, correct_y);
        printf(" -- correct answer -- \n");
        correct_y->print();

        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(64, 0.0);
        diaq::identity_kron_matrix_kron_identity_times_vector((unsigned int)1, qspa, (unsigned int)2, x, y);
        y->print();

        std::cout << "Checking correctness: ";
        std::cout << check_vectors(correct_y, y) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "identity_kron_matrix_kron_identity_times_vector_2") == 0) {
        diaq::valType reals[16] = { // 2 qubit gate, all elements 16x16
            1, 0, 1, 0,
            0, 0, 0, 0,
            1, 0, 1, 0,
            0, 0, 0, 0
        };
        unsigned int *s = new unsigned int[2]{4,4};
        std::shared_ptr<diaq::denseMatrix> denseGate = std::make_shared<diaq::denseMatrix>(&s, reals);
        std::shared_ptr<diaq::diaQMatrix> gate = denseGate->convertToQuantumSparse();
        gate->print();

        unsigned int before = 1; // qubits before gate
        unsigned int after = 2; // qubits after gate
        unsigned int vec_length = 1 << (before + 2 + after);

        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(vec_length, 1.0);
        std::shared_ptr<diaq::diaQMatrix> mat = diaq::identity_kron_matrix(before, gate);

        // mat->print();

        std::shared_ptr<diaq::diaQMatrix> I_after = (std::shared_ptr<diaq::diaQMatrix> ) (std::make_shared<diaq::identityMatrix>(1L << after));
        std::shared_ptr<diaq::diaQMatrix> u_mat = diaq::kron_product(mat, I_after);

        u_mat->print();

        std::shared_ptr<diaq::vector> correct_y = std::make_shared<diaq::vector>(vec_length, 0.0);

        diaq::spMV(u_mat, x, correct_y);
        std::cout << " -- correct answer -- " << std::endl;
        correct_y->print();

        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(correct_y->numRows, 0.0);
        diaq::identity_kron_matrix_kron_identity_times_vector(before, gate, after, x, y);
        std::cout << " -- new way to do it -- " << std::endl;
        y->print();

        std::cout << "Checking correctness: ";
        std::cout << check_vectors(correct_y, y) << std::endl;
        std::cout << " -- " << std::endl;

    }
    else if(strcmp(argv[1], "identity_kron_matrix_kron_identity_times_vector_3") == 0) {
        // gate matrix below
        // matrix_shape (4,4)
        // tensor_shape (4,4)
        // (dIndex=0) (dLength=4) [(0.707107,0.707107),(0.707107,-0.707107),(0.707107,-0.707107),(0.707107,0.707107)]
        // after = 8; before = 2
        unsigned int before = 1;
        unsigned int after = 3;
        diaq::valType reals[16] = {
            0.707107, 0, 0, 0,
            0, 0.707107, 0, 0,
            0, 0, 0.707107, 0,
            0, 0, 0, 0.707107
        };
        diaq::valType imags[16] = {
            0.707107, 0, 0, 0,
            0, -0.707107, 0, 0,
            0, 0, -0.707107, 0,
            0, 0, 0, 0.707107
        };
        unsigned int *s = new unsigned int[2]{4,4};
        std::shared_ptr<diaq::denseMatrix> denseGate = std::make_shared<diaq::denseMatrix>(&s, reals, imags);
        std::shared_ptr<diaq::diaQMatrix> gate = denseGate->convertToQuantumSparse();
        gate->print(); // 2 qubit gate, 4x4 unitary matrix

        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>((1L << before) * (gate->shape[0]) * (1L << after), 1.0);
        std::shared_ptr<diaq::diaQMatrix> mat = diaq::matrix_kron_identity(gate, after);
        std::shared_ptr<diaq::vector> correct_y = std::make_shared<diaq::vector>((1L << before) * (gate->shape[0]) * (1L << after), 0.0);
        diaq::identity_kron_matrix_times_vector(before, mat, x, correct_y);
        std::cout << " -- correct answer -- " << std::endl;
        correct_y->print();

        std::cout << " -- new way to do it -- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(correct_y->numRows, 0.0);
        diaq::identity_kron_matrix_kron_identity_times_vector(before, gate, after, x, y);
        y->print();

        std::cout << "Checking correctness: ";
        std::cout << check_vectors(correct_y, y) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "tensordot_1") == 0) {
        // testing tensordot operation
        A24->shape = std::vector<unsigned int>{3,3,2};
        std::vector<unsigned int> dims_A{3,6};
        std::shared_ptr<diaq::diaQMatrix> q_A24 = A24->convertToQuantumSparse(dims_A);
        q_A24->print();
        std::cout << " -- " << std::endl;
        B24->shape = std::vector<unsigned int>{2,3,2};
        std::vector<unsigned int> dims_B{6,2};
        std::shared_ptr<diaq::diaQMatrix> q_B24 = B24->convertToQuantumSparse(dims_B);
        q_B24->print();
        std::cout << " -- " << std::endl;
        std::vector<unsigned int> axes_A{2};
        std::vector<unsigned int> axes_B{0};
        std::vector<std::vector<unsigned int>> axes{axes_A, axes_B};
        std::shared_ptr<diaq::diaQMatrix> res1 = diaq::tensordot1(q_A24, q_B24, axes);
        res1->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Tensordot Done -- " << std::endl;
        std::cout << " -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> res2 = diaq::tensordot(q_A24, q_B24, axes);
        res2->print();
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "tensordot_2") == 0) {
        diaq::valType first_m[16] = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 0, 1, 0,
        };
        unsigned int *shape_first_m = new unsigned int[2]{4,4};
        std::shared_ptr<diaq::denseMatrix> dfirst = std::make_shared<diaq::denseMatrix>(&shape_first_m, first_m);
        std::shared_ptr<diaq::diaQMatrix> q_first = dfirst->convertToQuantumSparse(dfirst->matrix_shape);
        q_first->shape = std::vector<unsigned int>{2,2,2,2};
        diaq::valType second_m[4] = {
            0.707107, 0,
            0, -0.707107,
        };
        unsigned int *shape_second_m = new unsigned int[2]{2,2};
        std::shared_ptr<diaq::denseMatrix> dsecond = std::make_shared<diaq::denseMatrix>(&shape_second_m, second_m);
        std::shared_ptr<diaq::diaQMatrix> q_second = dsecond->convertToQuantumSparse(dsecond->matrix_shape);
        q_second->shape = std::vector<unsigned int>{2,2};
        std::vector<unsigned int> axes_A{3};
        std::vector<unsigned int> axes_B{0};
        std::vector<std::vector<unsigned int>> axes{axes_A, axes_B};
        std::shared_ptr<diaq::diaQMatrix> res = tensordot(q_first, q_second, axes);
        res->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Tensordot Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "tensordot_3") == 0) {
        diaq::valType first_m[16] = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 0, 1, 0,
        };
        unsigned int *shape_first_m = new unsigned int[2]{4,4};
        std::shared_ptr<diaq::denseMatrix> dfirst = std::make_shared<diaq::denseMatrix>(&shape_first_m, first_m);
        std::shared_ptr<diaq::diaQMatrix> q_first = dfirst->convertToQuantumSparse(dfirst->matrix_shape);
        q_first->shape = std::vector<unsigned int>{2,2,2,2};
        printf(" --- q_first matrix --- \n");
        q_first->print();
        diaq::valType second_m[16] = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 0, 1, 0,
        };
        unsigned int *shape_second_m = new unsigned int[2]{4,4};
        std::shared_ptr<diaq::denseMatrix> dsecond = std::make_shared<diaq::denseMatrix>(&shape_second_m, second_m);
        std::shared_ptr<diaq::diaQMatrix> q_second = dsecond->convertToQuantumSparse(dsecond->matrix_shape);
        q_second->shape = std::vector<unsigned int>{2,2,2,2};
        printf(" --- q_second matrix --- \n");
        q_second->print();
        std::vector<unsigned int> axes_A{2};
        std::vector<unsigned int> axes_B{1};
        std::vector<std::vector<unsigned int>> axes{axes_A, axes_B};
        std::shared_ptr<diaq::diaQMatrix> res1 = diaq::tensordot1(q_first, q_second, axes);
        res1->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Tensordot Done -- " << std::endl;
        std::cout << " -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> res2 = diaq::tensordot(q_first, q_second, axes);
        res2->print();
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "format_conversion") == 0) {
        std::cout << "Testing Format Conversion" << std::endl;
        std::complex<diaq::valType> *values = new std::complex<diaq::valType>[18]{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18};
        std::vector<unsigned int> shape{3,3,2};
        std::shared_ptr<diaq::diaQMatrix> result = diaq::from_numpy(values, shape);
        result->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- From Numpy Done -- " << std::endl;
        std::cout << " -- " << std::endl;
        // test case 5 - GHZ 3 qubit unitary simulation
        std::cout << " -- Testing Multiplication --" << std::endl;
        std::complex<diaq::valType> *a = new std::complex<diaq::valType>[64]{
            {1,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0},
            {0,0}, {0,1}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0},
            {0,0}, {0,0}, {1,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0},
            {0,0}, {0,0}, {0,1}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0},
            {0,0}, {0,0}, {0,0}, {0,0}, {1,0}, {0,0}, {0,0}, {0,0},
            {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {1,0},
            {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {1,0}, {0,0},
            {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {1,0}, {0,0}, {0,0}
        };
        std::vector<unsigned int> a_shape{8, 8};
        std::complex<diaq::valType> *b = new std::complex<diaq::valType>[64]{
            1,0,0,0,0,0,0,0,
            0,1,0,0,0,0,0,0,
            0,0,0,0,0,0,1,0,
            0,0,0,0,0,0,0,1,
            0,0,0,0,1,0,0,0,
            0,0,0,0,0,1,0,0,
            0,0,1,0,0,0,0,0,
            0,0,0,1,0,0,0,0,
        };
        std::vector<unsigned int> b_shape{8, 8};

        std::shared_ptr<diaq::diaQMatrix> A =  diaq::from_numpy(a, a_shape);
        std::shared_ptr<diaq::diaQMatrix> B =  diaq::from_numpy(b, b_shape);
        std::shared_ptr<diaq::diaQMatrix> C = (A) * (B);
        C->print();
        std::cout << " -- " << std::endl;
        std::cout << " -- Multiplication Done -- " << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if (strcmp(argv[1], "kron_1") == 0 ) {
        // testing kron_product here
        std::cout << " -- test -- " << std::endl;
        kron_test(A33, B33);
    }
    else if (strcmp(argv[1], "kron_2") == 0 ) {
        // testing kron_product here
        std::cout << " -- kron test -- " << std::endl;
        kron_test(A4, B4);
    }
    else if (strcmp(argv[1], "kron_3") == 0 ) {
        // testing kron_product here
        std::cout << " -- kron test -- " << std::endl;
        kron_test(A14, B14);
    }
    else if(strcmp(argv[1], "kron_4") == 0 ) {
        std::cout << " -- testing kron_4 -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qspa = A25->convertToQuantumSparse();
        qspa->print();
        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::denseMatrix> dense_id4 = id4->convertToDenseMatrix();
        kron_test(A25, dense_id4);
    }
    else if(strcmp(argv[1], "kron_5") == 0 ) {
        std::cout << " -- testing kron_5 -- " << std::endl;
        std::shared_ptr<diaq::identityMatrix> id2 = std::make_shared<diaq::identityMatrix>((unsigned int)2);
        std::shared_ptr<diaq::denseMatrix> dense_id2 = id2->convertToDenseMatrix();
        std::shared_ptr<diaq::identityMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::denseMatrix> dense_id4 = id4->convertToDenseMatrix();

        std::shared_ptr<diaq::diaQMatrix> qspa = A25->convertToQuantumSparse();
        qspa->print();

        kron_test(A25, dense_id2);
        kron_test(dense_id4, A25);

        std::shared_ptr<diaq::diaQMatrix> sparse_k_p = diaq::kron_product(id2, qspa);
        sparse_k_p = diaq::kron_product(sparse_k_p, id4);

        std::shared_ptr<diaq::denseMatrix> dense_k_p = diaq::dense_kron_product(dense_id2, A25);
        dense_k_p = diaq::dense_kron_product(dense_k_p, dense_id4);

        std::cout << " -- Is Kron correct? -- " << std::endl;
        std::cout << checkResult(sparse_k_p, dense_k_p->convertToQuantumSparse()) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "identity_kron_matrix_1") == 0 ) {
        // testing identity_kron_matrix
        std::cout << " -- testing identity_kron_matrix -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qspa = B4->convertToQuantumSparse();
        qspa->print();
        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::diaQMatrix> res_correct = diaq::kron_product(id4, qspa);
        printf(" -- correct answer -- \n");
        res_correct->print();
        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::diaQMatrix> res = diaq::identity_kron_matrix((unsigned int)2, qspa );
        res->print();
        printf(" -- check -- \n");
        std::cout << checkResult(res, res_correct) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "matrix_kron_identity_1") == 0 ) {
        // testing matrix_kron_identity
        std::cout << " -- testing matrix_kron_identity -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qspa = A25->convertToQuantumSparse();
        qspa->print();
        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::diaQMatrix> res_correct = diaq::kron_product(qspa, id4);
        printf(" -- correct answer -- \n");
        res_correct->print();
        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::diaQMatrix> res = diaq::matrix_kron_identity(qspa, (unsigned int)2);
        res->print();
        printf(" -- check -- \n");
        std::cout << checkResult(res, res_correct) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "matrix_kron_identity_2") == 0 ) {
        // testing matrix_kron_identity
        std::cout << " -- testing matrix_kron_identity -- " << std::endl;
        diaq::valType x_vals[4] = {
            0, 1,
            1, 0
        };
        unsigned int *x_shape = new unsigned int[2]{2,2};
        std::shared_ptr<diaq::denseMatrix> X = std::make_shared<diaq::denseMatrix>(&x_shape, x_vals);
        std::shared_ptr<diaq::diaQMatrix> dq_X = X->convertToQuantumSparse();
        printf(" -- X -- \n");
        dq_X->print();

        std::shared_ptr<diaq::diaQMatrix> dq_X_X = diaq::kron_product(dq_X, dq_X);
        printf(" -- X kron X -- \n");
        dq_X_X->print();

        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::diaQMatrix> dq_X_X_IN = diaq::kron_product(dq_X_X, id4);
        printf(" -- correct answer -- \n");
        dq_X_X_IN->print();

        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::diaQMatrix> res = diaq::matrix_kron_identity(dq_X_X, (unsigned int)2);
        res->print();

        printf(" -- check -- \n");
        std::cout << checkResult(dq_X_X_IN, res) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "identity_kron_matrix_2") == 0 ) {
        // testing matrix_kron_identity
        std::cout << " -- testing matrix_kron_identity -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qspa = A23->convertToQuantumSparse();
        qspa->print();
        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::diaQMatrix> res_correct = diaq::kron_product(id4, qspa);
        printf(" -- correct answer -- \n");
        res_correct->print();
        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::diaQMatrix> res = diaq::identity_kron_matrix((unsigned int)2, qspa);
        res->print();
        printf(" -- check -- \n");
        std::cout << checkResult(res, res_correct) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "identity_kron_matrix_kron_identity_1") == 0 ) {
        // testing identity_kron_matrix_kron_identity
        std::cout << " -- testing identity_kron_matrix_kron_identity -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qspa = A23->convertToQuantumSparse();
        qspa->print();
        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::diaQMatrix> res_correct = diaq::kron_product(id4, qspa);
        res_correct = diaq::kron_product(res_correct, id4);
        printf(" -- correct answer -- \n");
        res_correct->print();
        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::diaQMatrix> res = diaq::identity_kron_matrix_kron_identity((unsigned int)2, qspa, (unsigned int)2);
        res->print();
        printf(" -- check -- \n");
        std::cout << checkResult(res, res_correct) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "identity_kron_matrix_kron_identity_2") == 0 ) {
        // testing identity_kron_matrix_kron_identity for another case
        std::cout << " -- testing identity_kron_matrix_kron_identity -- " << std::endl;
        diaq::valType prime_vals[16] = {
            2, 3, 5, 7,
            11, 13, 17, 19,
            23, 29, 31, 37,
            41, 43, 47, 53
        };
        unsigned int *shape = new unsigned int[2]{4, 4};
        std::shared_ptr<diaq::denseMatrix> dense_prime_matrix = std::make_shared<diaq::denseMatrix>(&shape, prime_vals);
        std::shared_ptr<diaq::diaQMatrix> gate_matrix = dense_prime_matrix->convertToQuantumSparse();
        gate_matrix->print();

        std::shared_ptr<diaq::diaQMatrix> id2 = std::make_shared<diaq::identityMatrix>((unsigned int)2);
        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);

        std::shared_ptr<diaq::diaQMatrix> res_correct = diaq::kron_product(id4, gate_matrix);
        res_correct = diaq::kron_product(res_correct, id4);
        printf(" -- correct answer -- \n");
        res_correct->print();

        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::diaQMatrix> res = diaq::identity_kron_matrix_kron_identity((unsigned int)2, gate_matrix, (unsigned int)2);
        res->print();

        printf(" -- check -- \n");
        std::cout << checkResult(res, res_correct) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "identity_kron_matrix_times_vector_1") == 0 ) {
        // testing identity_kron_matrix_times_vector
        std::cout << " -- testing identity_kron_matrix_times_vector -- " << std::endl;
        diaq::valType prime_vals[16] = {
            2, 3, 5, 7,
            11, 13, 17, 19,
            23, 29, 31, 37,
            41, 43, 47, 53
        };
        unsigned int *shape = new unsigned int[2]{4, 4};
        std::shared_ptr<diaq::denseMatrix> dense_prime_matrix = std::make_shared<diaq::denseMatrix>(&shape, prime_vals);
        std::shared_ptr<diaq::diaQMatrix> gate_matrix = dense_prime_matrix->convertToQuantumSparse();
        gate_matrix->print();
        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::diaQMatrix> mat = diaq::kron_product(id4, gate_matrix);
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(16, 1.0);
        std::shared_ptr<diaq::vector> correct_y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        diaq::spMV(mat, x, correct_y);
        printf(" -- correct answer -- \n");
        correct_y->print();
        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        diaq::identity_kron_matrix_times_vector((unsigned int)2, gate_matrix, x, y);
        y->print();

        std::cout << "Checking correctness: ";
        std::cout << check_vectors(correct_y, y) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "identity_kron_matrix_times_vector_2") == 0) {
        // vector x
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(128);
        x->imagValues[8] = 1.0;
        // matrix_shape (64,64)
        // tensor_shape (64,64)
        // (dIndex=0) [(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0),(-1,0)]
        unsigned int *shape = new unsigned int[2] {64, 64};
        std::shared_ptr<diaq::diaQMatrix> qspa = std::make_shared<diaq::diaQMatrix>(&shape);
        std::shared_ptr<diaq::diagonal> zero_d = std::make_shared<diaq::diagonal>(0, 64);
        diaq::valType *zero_d_real = zero_d->realValues;
        // diaq::valType *zero_d_imag = zero_d->imagValues;
        for(int i = 0; i < 48; i++) {
            zero_d_real[i] = 1.0;
        }
        for(int i = 48; i < 64; i++) {
            zero_d_real[i] = -1.0;
        }
        qspa->setDiagonal(0, zero_d);
        qspa->print();
        printf(" -- doing kron_product(qspa, I2) times vector x -- \n");
        std::shared_ptr<diaq::diaQMatrix> kp = diaq::kron_product(std::make_shared<diaq::identityMatrix>((unsigned int)2), qspa);
        printf(" -- kp -- \n");
        kp->print();
        printf(" -- let's test identity_kron_matrix function also here -- \n");
        std::shared_ptr<diaq::diaQMatrix> kp_2 = diaq::identity_kron_matrix((unsigned int)1, qspa);
        printf(" -- kp_2 -- \n");
        kp_2->print();
        printf(" -- \n");
        printf(" -- times x -- \n");
        x->print();
        printf(" -- gives -- \n");
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(kp_2->shape[0], 0.0);
        diaq::spMV(kp_2, x, y);
        y->print();
        printf(" -- Now doing identity_kron_matrix_times_vector -- \n");
        std::shared_ptr<diaq::vector> res_v = std::make_shared<diaq::vector>(y->numRows, 0.0);
        diaq::identity_kron_matrix_times_vector((unsigned int)1, qspa, x, res_v);
        res_v->print();

        // checking correctness
        std::cout << "Checking correctness: ";
        std::cout << check_vectors(y, res_v) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if(strcmp(argv[1], "identity_kron_matrix_times_vector_3") == 0 ) {
        // testing matrix_kron_identity
        std::cout << " -- testing identity_kron_matrix_times_vector -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qspa = A23->convertToQuantumSparse();
        qspa->print();
        std::shared_ptr<diaq::diaQMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        std::shared_ptr<diaq::diaQMatrix> mat = diaq::kron_product(id4, qspa);
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(32, 1.0);
        std::shared_ptr<diaq::vector> correct_y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        diaq::spMV(mat, x, correct_y);
        printf(" -- correct answer -- \n");
        correct_y->print();
        printf(" -- new way to do it -- \n");
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(mat->shape[0], 0.0);
        diaq::identity_kron_matrix_times_vector((unsigned int)2, qspa, x, y);
        y->print();

        std::cout << "Checking correctness: ";
        std::cout << check_vectors(correct_y, y) << std::endl;
        std::cout << " -- " << std::endl;   
    }
    else if (strcmp(argv[1], "id") == 0 ) {
        std::cout << " -- testing identity class -- " << std::endl;
        std::shared_ptr<diaq::identityMatrix> id4 = std::make_shared<diaq::identityMatrix>((unsigned int)4);
        id4->print();
        std::shared_ptr<diaq::identityMatrix> id2 = std::make_shared<diaq::identityMatrix>((unsigned int)2);
        id2->print();
    }
    else if (strcmp(argv[1], "permutation") == 0 ) {
        std::cout << " -- testing permutation class -- " << std::endl;
        std::vector<unsigned int> row_order{1,0,2,4,3};
        diaq::permutationMatrix *perm5 = new diaq::permutationMatrix((unsigned int)5, row_order);
        perm5->print();
        perm5->convertToDenseMatrix(perm5->matrix_shape)->print();
    }
    else if (strcmp(argv[1], "dagger") == 0 ) {
        std::cout << " -- testing dagger operation -- " << std::endl;
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(8, 2.0, 1.0);
        std::shared_ptr<diaq::vector> y_dagger = y->dagger();
        y_dagger->print();
        std::cout << " -- " << std::endl;
    }
    else if (strcmp(argv[1], "vector_multiply") == 0 ) {
        std::cout << " -- testing dagger operation -- " << std::endl;
        std::shared_ptr<diaq::vector> x = std::make_shared<diaq::vector>(8, 3.0, 1.0);
        std::shared_ptr<diaq::vector> y = std::make_shared<diaq::vector>(8, 2.0, 1.0);
        std::complex<diaq::valType> res = x->multiply(y);
        std::cout << res << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if (strcmp(argv[1], "multiplyMatrix_1") == 0) {
        std::cout << " -- testing multiplyMatrix -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> A = A23->convertToQuantumSparse();
        std::cout << " -- Mat A -- " << std::endl;
        A->print();
        std::shared_ptr<diaq::diaQMatrix> B = B23->convertToQuantumSparse();
        std::cout << " -- Mat B -- " << std::endl;
        B->print();

        std::shared_ptr<diaq::diaQMatrix> correct_ans = diaq::product(A, B);
        std::cout << " -- correct answer -- " << std::endl;
        correct_ans->print();
        std::cout << " -- " << std::endl;

        std::shared_ptr<diaq::diaQMatrix> C = A->multiplyMatrix(B);
        std::cout << " -- Mat C = A->multiplyMatrix(B) -- " << std::endl;
        C->print();
        std::cout << " -- " << std::endl;

        std::cout << " -- checking correctness -- " << std::endl;
        std::cout << checkResult(correct_ans, C) << std::endl;
        std::cout << " -- " << std::endl;
    }
    else if (strcmp(argv[1], "expm_negative") == 0 ) {
        std::cout << " -- Testing expm_negative -- " << std::endl;
        // Define a 2x2 matrix with specific real values for testing
        diaq::valType reals[4] = {
            0.707107, 0.707107,
            0.707107, -0.707107
        };

        // Set the dimensions of the matrix
        unsigned int *s = new unsigned int[2]{2, 2};

        // Create a dense matrix from the values
        std::shared_ptr<diaq::denseMatrix> denseGate = std::make_shared<diaq::denseMatrix>(&s, reals);

        // Convert the dense matrix to a diaQMatrix (sparse representation)
        std::shared_ptr<diaq::diaQMatrix> gate = denseGate->convertToQuantumSparse();
        std::cout << "--------------------------------" << std::endl;
        std::cout << "Original Matrix:" << std::endl;
        std::cout << "--------------------------------" << std::endl;
        gate->print();
        std::cout << "--------------------------------" << std::endl;

        // Time parameter for exponentiation
        diaq::valType time = 1.0; // Example time value for exp(-i * H * t)

        // Calculate the matrix exponentiation e^(-i * H * t) using expm_negative
        std::shared_ptr<diaq::diaQMatrix> result = diaq::expm_negative(gate, time);

        std::cout << "--------------------------------" << std::endl;
        // Print the result
        std::cout << "Result of exp(-i * H * t):" << std::endl;
        std::cout << "--------------------------------" << std::endl;
        result->print();
        std::cout << "--------------------------------" << std::endl;

        // Clean up
        // delete[] s;
        // delete denseGate;
        // delete gate;
        // delete result;

        std::cout << " -- End of test -- " << std::endl;
    }
    else if(strcmp(argv[1], "test") == 0) {
        #ifdef PAPI_ON
            diaq::startPAPI();
        #endif

        const std::string str_i = argv[2];
        unsigned int i = std::stoi(str_i);
        std::cout << "test case - " << i;
        std::shared_ptr<diaq::denseMatrix> p = denseProduct(testCases[i][0], testCases[i][1]);
        std::cout << std::endl << " ---- dense product ---- " << std::endl;
        p->print();
        std::cout << " ---- dense product ---- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> dp = p->convertToQuantumSparse(p->matrix_shape);
        std::cout << " ---- correct answer ---- " << std::endl;
        dp->print();
        std::cout << " ---- correct answer ---- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> first = testCases[i][0]->convertToQuantumSparse(testCases[i][0]->matrix_shape);
        std::cout << " -- first -- " << std::endl;
        first->print();
        std::cout << " -- first -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> second = testCases[i][1]->convertToQuantumSparse(testCases[i][1]->matrix_shape);
        std::cout << " -- second -- " << std::endl;
        second->print();
        std::cout << " -- second -- " << std::endl;
        std::shared_ptr<diaq::diaQMatrix> qp = product(first, second);
        std::cout << " -- qp -- " << std::endl;
        qp->print();
        std::cout << " -- qp -- " << std::endl;
        std::string check = checkResult(dp, qp);
        std::cout << " = " << check << std::endl;
        #ifdef PAPI_ON
            diaq::stopPAPI("test " + str_i);
        #endif
    }
    else if(strcmp(argv[1], "list") == 0) {
        // this lists all the tests above by strcmp second half of the string in else cases above!
        // call python script to list all the tests
        std::string command = "python tests/tests_list_tests.py";
        system(command.c_str());
    }
    #ifdef PAPI_ON
        diaq::cleanupPAPI();
    #endif
    return 0;
}
