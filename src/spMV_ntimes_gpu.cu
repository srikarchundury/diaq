#include "matrixKernels_gpu.hpp"

#include <vector>
#include <stdexcept>
#include <iostream>
#include <chrono>

namespace diaq {

// Forward declarations, kernels defined in spmv_gpu.cu
__global__ void spmv_single_diag_kernel(
	unsigned int len,
	int dIndex,
	unsigned int offset,
	unsigned int numRows,
	unsigned int numCols,
	const valType * __restrict__ A_real,
	const valType * __restrict__ A_imag,
	const valType * __restrict__ x_real,
	const valType * __restrict__ x_imag,
	valType * __restrict__ y_real,
	valType * __restrict__ y_imag
);

__global__ void spmv_row_kernel(
	unsigned int numRows,
	unsigned int numCols,
	int numDiags,
	const int * __restrict__ dIndices,
	const unsigned int * __restrict__ diagOffsets,
	const unsigned int * __restrict__ diagLens,
	const valType * __restrict__ A_real,
	const valType * __restrict__ A_imag,
	const valType * __restrict__ x_real,
	const valType * __restrict__ x_imag,
	valType * __restrict__ y_real,
	valType * __restrict__ y_imag
);

static inline void cudaCheck(cudaError_t err, const char *msg)
{
	if (err != cudaSuccess) {
		std::cerr << "CUDA error (" << msg << "): " << cudaGetErrorString(err) << std::endl;
		throw std::runtime_error(std::string("CUDA failure: ") + msg);
	}
}

// convenience wrapper to return new vector
std::shared_ptr<vector> spMV_ntimes_cuda(std::shared_ptr<diaQMatrix> A,
                     std::shared_ptr<vector> x,
                        int num_times) {
    std::shared_ptr<vector> y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spMV_ntimes_cuda(A, x, y, num_times);
    return y;
}

// -----------------------------------------------------------------------------
// Core GPU spMV N times: y = A^num_times * x  (via repeated SpMV on device)
// -----------------------------------------------------------------------------
void spMV_ntimes_cuda(std::shared_ptr<diaQMatrix> A,
		      std::shared_ptr<vector> x,
		      std::shared_ptr<vector> y,
		      int num_times)
{
	#ifdef DEBUG
		printf("starting <spMV_n_times_gpu> --- ");
		auto start = std::chrono::high_resolution_clock::now();
	#endif

	if (num_times < 0) {
		throw std::runtime_error("spmv_ntimes_cuda: num_times must be >= 0");
	}

	unsigned int M = A->matrix_shape[0];
	unsigned int N = A->matrix_shape[1];

	// Dimension checks
	if (x->numRows != N) {
		throw std::runtime_error("spmv_ntimes_cuda: dimension mismatch (x length vs A.cols)");
	}
	if (y->numRows != M) {
		throw std::runtime_error("spmv_ntimes_cuda: dimension mismatch (y length vs A.rows)");
	}

	// If num_times == 0, output is just x (only valid if M == N)
	if (num_times == 0) {
		if (M != N) {
			throw std::runtime_error("spmv_ntimes_cuda: num_times==0 requires square matrix (M==N) to copy x -> y");
		}
		for (unsigned int i = 0; i < M; ++i) {
			y->realValues[i] = x->realValues[i];
			y->imagValues[i] = x->imagValues[i];
		}
		return;
	}

	unsigned int numDiags = static_cast<unsigned int>(A->dIndices.size());
	if (numDiags == 0) {
		// Zero matrix => result is zero for any positive power
		for (unsigned int i = 0; i < M; ++i) {
			y->realValues[i] = 0.0;
			y->imagValues[i] = 0.0;
		}
		return;
	}

	// ---------------- Host-side diagonal metadata ----------------
	std::vector<int> h_dIndices(numDiags);
	std::vector<unsigned int> h_diagOffsets(numDiags);
	std::vector<unsigned int> h_diagLens(numDiags);

	for (unsigned int k = 0; k < numDiags; ++k) {
		int d = A->dIndices[k];
		h_dIndices[k] = d;
		h_diagOffsets[k] = A->diagOffsets[k];
		h_diagLens[k] = A->getDiagonalLengthInternal(d);
	}

	std::size_t totalLength = A->totalLength;

	// ---------------- Device allocations (one-time) ----------------
	valType *d_A_real = nullptr, *d_A_imag = nullptr;
	valType *d_in_real = nullptr, *d_in_imag = nullptr;
	valType *d_out_real = nullptr, *d_out_imag = nullptr;

	int *d_dIndices = nullptr;
	unsigned int *d_diagOffsets = nullptr;
	unsigned int *d_diagLens = nullptr;

	cudaCheck(cudaMalloc(&d_A_real, totalLength * sizeof(valType)), "malloc d_A_real");
	cudaCheck(cudaMalloc(&d_A_imag, totalLength * sizeof(valType)), "malloc d_A_imag");
	cudaCheck(cudaMemcpy(d_A_real, A->realData, totalLength * sizeof(valType), cudaMemcpyHostToDevice), "copy A_real H2D");
	cudaCheck(cudaMemcpy(d_A_imag, A->imagData, totalLength * sizeof(valType), cudaMemcpyHostToDevice), "copy A_imag H2D");

	// Input buffer starts as x (size N)
	cudaCheck(cudaMalloc(&d_in_real, N * sizeof(valType)), "malloc d_in_real");
	cudaCheck(cudaMalloc(&d_in_imag, N * sizeof(valType)), "malloc d_in_imag");
	cudaCheck(cudaMemcpy(d_in_real, x->realValues, N * sizeof(valType), cudaMemcpyHostToDevice), "copy x_real H2D");
	cudaCheck(cudaMemcpy(d_in_imag, x->imagValues, N * sizeof(valType), cudaMemcpyHostToDevice), "copy x_imag H2D");

	// Output buffer is size M
	cudaCheck(cudaMalloc(&d_out_real, M * sizeof(valType)), "malloc d_out_real");
	cudaCheck(cudaMalloc(&d_out_imag, M * sizeof(valType)), "malloc d_out_imag");
    cudaCheck(cudaMemset(d_out_real, 0, M * sizeof(valType)), "memset d_out_real init");
    cudaCheck(cudaMemset(d_out_imag, 0, M * sizeof(valType)), "memset d_out_imag init");

	// Metadata needed only for multi-diagonal case
	if (numDiags > 1) {
		cudaCheck(cudaMalloc(&d_dIndices, numDiags * sizeof(int)), "malloc d_dIndices");
		cudaCheck(cudaMalloc(&d_diagOffsets, numDiags * sizeof(unsigned int)), "malloc d_diagOffsets");
		cudaCheck(cudaMalloc(&d_diagLens, numDiags * sizeof(unsigned int)), "malloc d_diagLens");

		cudaCheck(cudaMemcpy(d_dIndices, h_dIndices.data(), numDiags * sizeof(int), cudaMemcpyHostToDevice), "copy dIndices H2D");
		cudaCheck(cudaMemcpy(d_diagOffsets, h_diagOffsets.data(), numDiags * sizeof(unsigned int), cudaMemcpyHostToDevice), "copy diagOffsets H2D");
		cudaCheck(cudaMemcpy(d_diagLens, h_diagLens.data(), numDiags * sizeof(unsigned int), cudaMemcpyHostToDevice), "copy diagLens H2D");
	}

	const int threadsPerBlock = 256;
	const int maxBlocks = 65535;

	// Precompute launch bounds
	int blocksRows = (static_cast<int>(M) + threadsPerBlock - 1) / threadsPerBlock;
	if (blocksRows > maxBlocks) blocksRows = maxBlocks;

	// Single-diagonal precompute
	int single_d = 0;
	unsigned int single_off = 0;
	unsigned int single_len = 0;
	int blocksLen = 0;

	if (numDiags == 1) {
		single_d = h_dIndices[0];
		single_off = h_diagOffsets[0];
		single_len = h_diagLens[0];
		blocksLen = (static_cast<int>(single_len) + threadsPerBlock - 1) / threadsPerBlock;
		if (blocksLen > maxBlocks) blocksLen = maxBlocks;
	}

	// ---------------- Repeated SpMV loop (device-only) ----------------
	for (int t = 0; t < num_times; ++t) {

		if (numDiags == 1) {
			// This kernel does y += ..., so we must clear output each iteration
			cudaCheck(cudaMemset(d_out_real, 0, M * sizeof(valType)), "memset d_out_real");
			cudaCheck(cudaMemset(d_out_imag, 0, M * sizeof(valType)), "memset d_out_imag");

			spmv_single_diag_kernel<<<blocksLen, threadsPerBlock>>>(
				single_len,
				single_d,
				single_off,
				M,
				N,
				d_A_real,
				d_A_imag,
				d_in_real,
				d_in_imag,
				d_out_real,
				d_out_imag
			);
		} else {
			// Row kernel overwrites y[row] = acc, so no memset needed
			spmv_row_kernel<<<blocksRows, threadsPerBlock>>>(
				M,
				N,
				static_cast<int>(numDiags),
				d_dIndices,
				d_diagOffsets,
				d_diagLens,
				d_A_real,
				d_A_imag,
				d_in_real,
				d_in_imag,
				d_out_real,
				d_out_imag
			);
		}

		// If more iterations remain, ping-pong buffers:
		// Next "in" should be current "out".
		// Note: this assumes square multiply after first step (M should equal N).
		if (t != num_times - 1) {
			if (M != N) {
				// After first multiply, vector length becomes M; cannot feed into next multiply unless M==N
				throw std::runtime_error("spmv_ntimes_cuda: repeated SpMV requires square matrix (M==N) for num_times > 1");
			}
			std::swap(d_in_real, d_out_real);
			std::swap(d_in_imag, d_out_imag);
			// Now d_out_* will be overwritten next iteration; fine.
		}
	}

    #ifdef DEBUG
        cudaCheck(cudaDeviceSynchronize(), "sync after kernels");
    #endif

    // Check kernel launch status (final)
	cudaCheck(cudaGetLastError(), "kernel launch");

	// ---------------- Copy result back ----------------
	cudaCheck(cudaMemcpy(y->realValues, d_out_real, M * sizeof(valType), cudaMemcpyDeviceToHost), "copy y_real D2H");
	cudaCheck(cudaMemcpy(y->imagValues, d_out_imag, M * sizeof(valType), cudaMemcpyDeviceToHost), "copy y_imag D2H");

	// ---------------- Cleanup ----------------
	if (d_dIndices) cudaFree(d_dIndices);
	if (d_diagOffsets) cudaFree(d_diagOffsets);
	if (d_diagLens) cudaFree(d_diagLens);

	cudaFree(d_A_real);
	cudaFree(d_A_imag);

	cudaFree(d_in_real);
	cudaFree(d_in_imag);

	cudaFree(d_out_real);
	cudaFree(d_out_imag);

	#ifdef DEBUG
		auto end = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
		printf("spMV_n_times_gpu completed in %.3f ms\n", duration / 1000.0);
	#endif
}

} // namespace diaq
