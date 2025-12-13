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
		unsigned int aIdx = idx;
		unsigned int dLength = A->getDiagonalLengthInternal(A->dIndices[aIdx]);
		diaq::valType *real_vals = A->realData + A->diagOffsets[aIdx];
		diaq::valType *imag_vals = A->imagData + A->diagOffsets[aIdx];
		for (unsigned int i = 0; i < dLength; ++i) {
			real_vals[i] = dist(rng);
			imag_vals[i] = dist(rng);
		}
	}

	printf("===== \n");
	printf("Matrix A metadata:\n");
	A->print_meta();
	printf("===== \n");

	for (size_t idx = 0; idx < diag_positions_B.size(); ++idx) {
		int dIndex = diag_positions_B[idx];
		unsigned int bIdx = idx;
		unsigned int dLength = B->getDiagonalLengthInternal(B->dIndices[bIdx]);
		diaq::valType *real_vals = B->realData + B->diagOffsets[bIdx];
		diaq::valType *imag_vals = B->imagData + B->diagOffsets[bIdx];
		for (unsigned int i = 0; i < dLength; ++i) {
			real_vals[i] = dist(rng);
			imag_vals[i] = dist(rng);
		}
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
		int aIdx = idx;
		int offset = diag_positions_A[aIdx];
		unsigned int dLength = A->getDiagonalLengthInternal(A->dIndices[aIdx]);
		diaq::valType *real_vals = A->realData + A->diagOffsets[aIdx];
		diaq::valType *imag_vals = A->imagData + A->diagOffsets[aIdx];
		for (unsigned int i = 0; i < dLength; ++i) {
			int row = (offset >= 0) ? i : i - offset;
			int col = row + offset;
			denseA[row * size + col] = std::complex<double>(real_vals[i], imag_vals[i]);
		}
	}

	for (size_t idx = 0; idx < diag_positions_B.size(); ++idx) {
		int bIdx = idx;
		int offset = diag_positions_B[bIdx];
		unsigned int dLength = B->getDiagonalLengthInternal(B->dIndices[bIdx]);
		diaq::valType *real_vals = B->realData + B->diagOffsets[bIdx];
		diaq::valType *imag_vals = B->imagData + B->diagOffsets[bIdx];
		for (unsigned int i = 0; i < dLength; ++i) {
			int row = (offset >= 0) ? i : i - offset;
			int col = row + offset;
			denseB[row * size + col] = std::complex<double>(real_vals[i], imag_vals[i]);
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