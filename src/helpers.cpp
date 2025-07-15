#include "helpers.hpp"
#include <iostream>
#include <set>
#include <vector>
#include <cmath>
#include <algorithm>

namespace diaq {

std::string compare(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
	if (A->diagonalMap.size() != B->diagonalMap.size()) {
		std::cout << "Size mismatch: A has " << A->diagonalMap.size()
		          << ", B has " << B->diagonalMap.size() << std::endl;

		std::set<int> keysA, keysB;
		for (const auto& [k, _] : A->diagonalMap) keysA.insert(k);
		for (const auto& [k, _] : B->diagonalMap) keysB.insert(k);

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

	const valType epsilon = 0.00002;

	for (const auto& [dIdx, diagA] : A->diagonalMap) {
		auto itB = B->diagonalMap.find(dIdx);
		if (itB == B->diagonalMap.end()) {
			std::cout << "Missing diagonal index in B: " << dIdx << std::endl;
			return "false - dIndex mis-match";
		}

		auto diagB = itB->second;
		if (diagA->dLength != diagB->dLength) {
			std::cout << "Length mismatch at dIndex = " << dIdx << ": "
			          << diagA->dLength << " vs " << diagB->dLength << std::endl;
			return "false - dLength mis-match";
		}

		for (unsigned int i = 0; i < diagA->dLength; i++) {
			if (std::abs(diagA->realValues[i] - diagB->realValues[i]) > epsilon) {
				std::cout << "Real mismatch at dIndex = " << dIdx << ", i = " << i << std::endl;
				std::cout << "A: " << diagA->realValues[i] << ", B: " << diagB->realValues[i] << std::endl;
				return "false - Real mis-match";
			}
			if (std::abs(diagA->imagValues[i] - diagB->imagValues[i]) > epsilon) {
				std::cout << "Imag mismatch at dIndex = " << dIdx << ", i = " << i << std::endl;
				std::cout << "A: " << diagA->imagValues[i] << ", B: " << diagB->imagValues[i] << std::endl;
				return "false - Imag mis-match";
			}
		}
	}

	return "true";
}

} // namespace diaq
