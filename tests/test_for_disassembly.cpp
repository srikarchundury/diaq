#include <vector>
#include <complex>
#include <memory>
#include <random>
#include <iostream>
#include <cmath>
#include <cassert>

#include "../include/diaq.hpp"

const double TOLERANCE = 1e-8;

bool compare_dense_and_diaq_flat(const std::vector<std::complex<double>>& dense_flat, const std::vector<std::complex<double>>& diaq_flat, int size) {
	bool all_pass = true;
	for (int i = 0; i < size * size; ++i) {
		std::complex<double> expected = dense_flat[i];
		std::complex<double> actual = diaq_flat[i];
		if (std::abs(expected.real() - actual.real()) > TOLERANCE || std::abs(expected.imag() - actual.imag()) > TOLERANCE) {
			int row = i / size;
			int col = i % size;
			std::cout << "[MISMATCH] At (" << row << "," << col << "): Expected " << expected << ", got " << actual << std::endl;
			all_pass = false;
		}
	}
	return all_pass;
}

void test_diaQMatrix_product_validation() {

	const int size = 1024;
	std::vector<int> diag_positions_A = {0, 4, 8, 16, 32, 64, 128, 256, -4, -8, -16, -32, -64, -128, -256};
	std::vector<int> diag_positions_B = {1, 16, 32, 512, -1, -16, -32, -512};

	std::shared_ptr<diaq::diaQMatrix> A = std::make_shared<diaq::diaQMatrix>(size, size);
	std::shared_ptr<diaq::diaQMatrix> B = std::make_shared<diaq::diaQMatrix>(size, size);

	std::mt19937 rng(42);
	std::uniform_real_distribution<double> dist(0.0, 1.0);

	for (size_t idx = 0; idx < diag_positions_A.size(); ++idx) {
		int dIndex = diag_positions_A[idx];
		unsigned int dLength = A->getDiagonalLength(dIndex);
		std::shared_ptr<diaq::diagonal> diag = std::make_shared<diaq::diagonal>(dIndex, dLength);
		diaq::valType *real_vals = diag->realValues;
		diaq::valType *imag_vals = diag->imagValues;
		for (unsigned int i = 0; i < dLength; ++i) {
			real_vals[i] = dist(rng);
			imag_vals[i] = dist(rng);
		}
		A->addDiagonal(dIndex, diag);
	}

	printf("===== \n");
	printf("Matrix A metadata:\n");
	A->print_meta();
	printf("===== \n");

	for (size_t idx = 0; idx < diag_positions_B.size(); ++idx) {
		int dIndex = diag_positions_B[idx];
		unsigned int dLength = B->getDiagonalLength(dIndex);
		std::shared_ptr<diaq::diagonal> diag = std::make_shared<diaq::diagonal>(dIndex, dLength);
		diaq::valType *real_vals = diag->realValues;
		diaq::valType *imag_vals = diag->imagValues;
		for (unsigned int i = 0; i < dLength; ++i) {
			real_vals[i] = dist(rng);
			imag_vals[i] = dist(rng);
		}
		B->addDiagonal(dIndex, diag);
	}

	printf("===== \n");
	printf("Matrix B metadata:\n");
	B->print_meta();
	printf("===== \n");

	std::shared_ptr<diaq::diaQMatrix> C = diaq::product(A, B);

	printf("===== \n");
	printf("Matrix C (A * B) metadata:\n");
	C->print_meta();
	printf("===== \n");

	// Flatten to dense for verification
	std::vector<std::complex<double>> denseA(size * size, {0.0, 0.0});
	std::vector<std::complex<double>> denseB(size * size, {0.0, 0.0});
	std::vector<std::complex<double>> denseC(size * size, {0.0, 0.0});

	for (size_t idx = 0; idx < diag_positions_A.size(); ++idx) {
		int offset = diag_positions_A[idx];
		auto diag = A->getDiagonal(offset);
		assert(diag);  // Safety check
		for (unsigned int i = 0; i < diag->dLength; ++i) {
			int row = (offset >= 0) ? i : i - offset;
			int col = row + offset;
			denseA[row * size + col] = (*diag)[i];
		}
	}

	for (size_t idx = 0; idx < diag_positions_B.size(); ++idx) {
		int offset = diag_positions_B[idx];
		auto diag = B->getDiagonal(offset);
		assert(diag);  // Safety check
		for (unsigned int i = 0; i < diag->dLength; ++i) {
			int row = (offset >= 0) ? i : i - offset;
			int col = row + offset;
			denseB[row * size + col] = (*diag)[i];
		}
	}

	for (int i = 0; i < size; ++i) {
		for (int j = 0; j < size; ++j) {
			std::complex<double> sum = {0.0, 0.0};
			for (int k = 0; k < size; ++k) {
				sum += denseA[i * size + k] * denseB[k * size + j];
			}
			denseC[i * size + j] = sum;
		}
	}

	auto diaq_flat = diaq::to_numpy(C);

	bool result = compare_dense_and_diaq_flat(denseC, diaq_flat, size);
	if (result) {
		std::cout << "[SUCCESS] diaQMatrix product matches dense matrix product!" << std::endl;
	} else {
		std::cout << "[FAILURE] diaQMatrix product does NOT match dense matrix product!" << std::endl;
	}
}

int main() {
	diaq::print_simd_info();
	printf("VEC_WIDTH = %d\n", VEC_WIDTH);
	printf("VEC_TYPE = %d\n", VEC_TYPE);
	printf("NUM_BYTES_ALIGNED = %d\n", NUM_BYTES_ALIGNED);
	printf("BLOCK_SIZE = %d\n", BLOCK_SIZE);
	printf("NUMBER_OF_OMP_THREADS = %d\n", NUMBER_OF_OMP_THREADS);
	test_diaQMatrix_product_validation();
	return 0;
}
