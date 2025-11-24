#include "helpers.hpp"
#include <iostream>
#include <set>
#include <vector>
#include <cmath>
#include <algorithm>

namespace diaq {

unsigned int getDiagonalLength(int dIndex, std::array<unsigned int, 2> mat_shape) {
    unsigned int lenRes;
    if (dIndex < 0) {
        lenRes = mat_shape[0] + dIndex;
    } else if (dIndex > 0) {
        lenRes = mat_shape[1] - dIndex;
    } else {
        if (mat_shape[0] > mat_shape[1]) {
            lenRes = mat_shape[1];
        } else {
            lenRes = mat_shape[0];
        }
    }
    if (lenRes > mat_shape[0]) {
        lenRes = mat_shape[0];
    } else if (lenRes > mat_shape[1]) {
        lenRes = mat_shape[1];
    }
    return lenRes;
}

std::string compare(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
	if (A->dIndices.size() != B->dIndices.size()) {
		std::cout << "Size mismatch: A has " << A->dIndices.size()
				  << ", B has " << B->dIndices.size() << std::endl;

		std::vector<int> only_in_A(A->dIndices.begin(), A->dIndices.end());
		std::vector<int> only_in_B(B->dIndices.begin(), B->dIndices.end());

		std::vector<int> diff_A, diff_B;
		std::set_difference(only_in_A.begin(), only_in_A.end(), only_in_B.begin(), only_in_B.end(), std::back_inserter(diff_A));
		std::set_difference(only_in_B.begin(), only_in_B.end(), only_in_A.begin(), only_in_A.end(), std::back_inserter(diff_B));

		std::cout << "Diagonal indices only in A: ";
		for (int d : diff_A) std::cout << d << " ";
		std::cout << "\nDiagonal indices only in B: ";
		for (int d : diff_B) std::cout << d << " ";
		std::cout << std::endl;

		return "false - size mis-match";
	}

	const valType epsilon = 0.00002;

	for (size_t d = 0; d < A->dIndices.size(); ++d) {
		int dIdx = A->dIndices[d];
		int bIdx = -1;
		for (size_t k = 0; k < B->dIndices.size(); ++k) {
			if (B->dIndices[k] == dIdx) { bIdx = static_cast<int>(k); break; }
		}
		if (bIdx == -1) {
			std::cout << "Missing diagonal index in B: " << dIdx << std::endl;
			return "false - dIndex mis-match";
		}

		unsigned int aIdx = std::distance(A->dIndices.begin(), std::find(A->dIndices.begin(), A->dIndices.end(), dIdx));
		bIdx = std::distance(B->dIndices.begin(), std::find(B->dIndices.begin(), B->dIndices.end(), dIdx));
		unsigned int lenA = A->getDiagonalLengthInternal(A->dIndices[aIdx]);
		unsigned int lenB = B->getDiagonalLengthInternal(B->dIndices[bIdx]);
		if (lenA != lenB) {
			std::cout << "Length mismatch at dIndex = " << dIdx << ": " << lenA << " vs " << lenB << std::endl;
			return "false - dLength mis-match";
		}

		valType* realA = A->realData + A->diagOffsets[d];
		valType* imagA = A->imagData + A->diagOffsets[d];
		valType* realB = B->realData + B->diagOffsets[bIdx];
		valType* imagB = B->imagData + B->diagOffsets[bIdx];
		for (unsigned int i = 0; i < lenA; i++) {
			if (std::abs(realA[i] - realB[i]) > epsilon) {
				std::cout << "Real mismatch at dIndex = " << dIdx << ", i = " << i << std::endl;
				std::cout << "A: " << realA[i] << ", B: " << realB[i] << std::endl;
				return "false - Real mis-match";
			}
			if (std::abs(imagA[i] - imagB[i]) > epsilon) {
				std::cout << "Imag mismatch at dIndex = " << dIdx << ", i = " << i << std::endl;
				std::cout << "A: " << imagA[i] << ", B: " << imagB[i] << std::endl;
				return "false - Imag mis-match";
			}
		}
	}

	return "true";
}

} // namespace diaq
