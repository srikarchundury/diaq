#include "../include/diaq.hpp"
#include <set>
#include <vector>
#include <iostream>
#include <cmath>

std::string checkResult(std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::diaQMatrix> B) {
    if (A->dIndices.size() != B->dIndices.size()) {
        std::cout << "Size mismatch: A has " << A->dIndices.size() << ", B has " << B->dIndices.size() << std::endl;
        std::set<int> keysA(A->dIndices.begin(), A->dIndices.end());
        std::set<int> keysB(B->dIndices.begin(), B->dIndices.end());
        std::vector<int> only_in_A, only_in_B;
        std::set_difference(keysA.begin(), keysA.end(), keysB.begin(), keysB.end(), std::back_inserter(only_in_A));
        std::set_difference(keysB.begin(), keysB.end(), keysA.begin(), keysA.end(), std::back_inserter(only_in_B));
        std::cout << "Diagonal indices only in A: ";
        for (auto d : only_in_A) std::cout << d << " ";
        std::cout << "\nDiagonal indices only in B: ";
        for (auto d : only_in_B) std::cout << d << " ";
        std::cout << std::endl;
        A->print();
        B->print();
        return "false - size mis-match";
    }

    const diaq::valType epsilon = 0.00002;
    for (size_t k = 0; k < A->dIndices.size(); ++k) {
        int dIdx = A->dIndices[k];
        int slotA = k;
        int slotB = -1;
        for (size_t kb = 0; kb < B->dIndices.size(); ++kb) {
            if (B->dIndices[kb] == dIdx) { slotB = kb; break; }
        }
        if (slotB == -1) {
            std::cout << "Missing diagonal index in B: " << dIdx << std::endl;
            return "false - dIndex mis-match";
        }
        unsigned int lenA = A->getDiagonalLength(dIdx);
        unsigned int lenB = B->getDiagonalLength(dIdx);
        if (lenA != lenB) {
            std::cout << "Length mismatch at dIndex = " << dIdx << ": " << lenA << " vs " << lenB << std::endl;
            return "false - dLength mis-match";
        }
        unsigned int offsetA = A->diagOffsets[slotA];
        unsigned int offsetB = B->diagOffsets[slotB];
        for (unsigned int i = 0; i < lenA; ++i) {
            if (std::abs(A->realData[offsetA + i] - B->realData[offsetB + i]) > epsilon) {
                std::cout << "Real mismatch at dIndex = " << dIdx << ", i = " << i << std::endl;
                std::cout << "A: " << A->realData[offsetA + i] << ", B: " << B->realData[offsetB + i] << std::endl;
                return "false - Real mis-match";
            }
            if (std::abs(A->imagData[offsetA + i] - B->imagData[offsetB + i]) > epsilon) {
                std::cout << "Imag mismatch at dIndex = " << dIdx << ", i = " << i << std::endl;
                std::cout << "A: " << A->imagData[offsetA + i] << ", B: " << B->imagData[offsetB + i] << std::endl;
                return "false - Imag mis-match";
            }
        }
    }
    return "true";
}
