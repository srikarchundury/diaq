#include "matrixKernels_gpu.hpp"   // diaq::valType, diaq::diaQMatrix, diaq::vector
#include <cuda_runtime.h>

#include <cmath>
#include <cstdio>
#include <cstdint>
#include <memory>
#include <stdexcept>
#include <vector>

#ifndef HAMSIM_TPB
#define HAMSIM_TPB 256
#endif

namespace diaq {

// -------------------------------------------------------------------------------------
// CUDA error helper
// -------------------------------------------------------------------------------------
static inline void cudaCheck(cudaError_t err, const char *msg) {
	if (err != cudaSuccess) {
		std::fprintf(stderr, "CUDA error (%s): %s\n", msg, cudaGetErrorString(err));
		throw std::runtime_error(std::string("CUDA failure: ") + msg);
	}
}

// -------------------------------------------------------------------------------------
// Device-resident diaQ matrix view (H only)
// -------------------------------------------------------------------------------------
struct DeviceDiaQ {
	std::array<unsigned int,2> shape{0,0};

	// host metadata copies
	std::vector<int> dIndices;
	std::vector<unsigned int> diagOffsets;
	std::vector<unsigned int> diagLens;
	unsigned int totalLength = 0;

	// device metadata
	int *d_dIndices = nullptr;
	unsigned int *d_diagOffsets = nullptr;
	unsigned int *d_diagLens = nullptr;

	// device values
	valType *d_real = nullptr;
	valType *d_imag = nullptr;

	void free_device() {
		if (d_dIndices)    cudaFree(d_dIndices);
		if (d_diagOffsets) cudaFree(d_diagOffsets);
		if (d_diagLens)    cudaFree(d_diagLens);
		if (d_real)        cudaFree(d_real);
		if (d_imag)        cudaFree(d_imag);
		d_dIndices = nullptr;
		d_diagOffsets = nullptr;
		d_diagLens = nullptr;
		d_real = nullptr;
		d_imag = nullptr;
	}
	~DeviceDiaQ() { free_device(); }
};

static inline void upload_structure(DeviceDiaQ &A) {
	const unsigned int numDiags = (unsigned int)A.dIndices.size();
	if (numDiags == 0) {
		A.d_dIndices = nullptr;
		A.d_diagOffsets = nullptr;
		A.d_diagLens = nullptr;
		return;
	}

	cudaCheck(cudaMalloc(&A.d_dIndices,    numDiags * sizeof(int)),          "malloc dIndices");
	cudaCheck(cudaMalloc(&A.d_diagOffsets, numDiags * sizeof(unsigned int)), "malloc diagOffsets");
	cudaCheck(cudaMalloc(&A.d_diagLens,    numDiags * sizeof(unsigned int)), "malloc diagLens");

	cudaCheck(cudaMemcpy(A.d_dIndices,    A.dIndices.data(),    numDiags * sizeof(int),          cudaMemcpyHostToDevice), "H2D dIndices");
	cudaCheck(cudaMemcpy(A.d_diagOffsets, A.diagOffsets.data(), numDiags * sizeof(unsigned int), cudaMemcpyHostToDevice), "H2D diagOffsets");
	cudaCheck(cudaMemcpy(A.d_diagLens,    A.diagLens.data(),    numDiags * sizeof(unsigned int), cudaMemcpyHostToDevice), "H2D diagLens");
}

static inline DeviceDiaQ upload_matrix_values_once(const std::shared_ptr<diaQMatrix> &H) {
	if (!H) throw std::runtime_error("upload_matrix_values_once: H is null");

	DeviceDiaQ dH;
	dH.shape = H->matrix_shape;
	dH.dIndices = H->dIndices;
	dH.diagOffsets = H->diagOffsets;
	dH.totalLength = H->totalLength;

	dH.diagLens.resize(dH.dIndices.size());
	for (unsigned int k = 0; k < (unsigned int)dH.dIndices.size(); ++k) {
		dH.diagLens[k] = H->getDiagonalLengthInternal(dH.dIndices[k]);
	}

	upload_structure(dH);

	// values to device ONCE
	if (dH.totalLength > 0) {
		cudaCheck(cudaMalloc(&dH.d_real, dH.totalLength * sizeof(valType)), "malloc H.real");
		cudaCheck(cudaMalloc(&dH.d_imag, dH.totalLength * sizeof(valType)), "malloc H.imag");
		cudaCheck(cudaMemcpy(dH.d_real, H->realData, dH.totalLength * sizeof(valType), cudaMemcpyHostToDevice), "H2D H.real");
		cudaCheck(cudaMemcpy(dH.d_imag, H->imagData, dH.totalLength * sizeof(valType), cudaMemcpyHostToDevice), "H2D H.imag");
	} else {
		dH.d_real = nullptr;
		dH.d_imag = nullptr;
	}

	return dH;
}

// -------------------------------------------------------------------------------------
// Simple diagonal-sparse SpMV: y = A * x
// Row-parallel: 1 thread per row
// Complexity: O(numRows * numDiags) -- good when numDiags is small.
// -------------------------------------------------------------------------------------
__global__ void spmv_row_diag_sparse_kernel(
	unsigned int numRows,
	unsigned int numCols,
	unsigned int numDiags,
	const int * __restrict__ dIndices,
	const unsigned int * __restrict__ diagOffsets,
	const unsigned int * __restrict__ diagLens,
	const valType * __restrict__ A_real,
	const valType * __restrict__ A_imag,
	const valType * __restrict__ x_real,
	const valType * __restrict__ x_imag,
	valType * __restrict__ y_real,
	valType * __restrict__ y_imag
) {
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
	if (i >= numRows) return;

	valType sum_r = 0.0;
	valType sum_i = 0.0;

	for (unsigned int k = 0; k < numDiags; ++k) {
		int d = dIndices[k];

		// diagonal element at (row i, col j)
		int j = (int)i + d;
		if (j < 0 || (unsigned int)j >= numCols) continue;

		// position along diagonal storage (must match diaQMatrix packing)
		// If d >= 0: element (i, i+d) stored at position p=i
		// If d < 0 : element (i, i+d) stored at position p=i+d (since row is shifted down)
		int p = (d >= 0) ? (int)i : ((int)i + d);
		if (p < 0) continue;

		unsigned int len = diagLens[k];
		if ((unsigned int)p >= len) continue;

		unsigned int idxA = diagOffsets[k] + (unsigned int)p;

		valType ar = A_real[idxA];
		valType ai = A_imag[idxA];

		valType xr = x_real[(unsigned int)j];
		valType xi = x_imag[(unsigned int)j];

		// (ar + i ai) * (xr + i xi)
		sum_r += ar * xr - ai * xi;
		sum_i += ar * xi + ai * xr;
	}

	y_real[i] = sum_r;
	y_imag[i] = sum_i;
}

static inline void spmv_device(
	const DeviceDiaQ &A,
	const valType *d_x_real,
	const valType *d_x_imag,
	valType *d_y_real,
	valType *d_y_imag
) {
	const unsigned int M = A.shape[0];
	const unsigned int N = A.shape[1];
	const unsigned int numDiags = (unsigned int)A.dIndices.size();

	if (M == 0 || N == 0) return;

	if (numDiags == 0 || A.totalLength == 0) {
		cudaCheck(cudaMemset(d_y_real, 0, M * sizeof(valType)), "memset y_real");
		cudaCheck(cudaMemset(d_y_imag, 0, M * sizeof(valType)), "memset y_imag");
		return;
	}

	const int tpb = HAMSIM_TPB;
	int blocks = (int)((M + (unsigned int)tpb - 1U) / (unsigned int)tpb);
	if (blocks <= 0) blocks = 1;

	spmv_row_diag_sparse_kernel<<<blocks, tpb>>>(
		M, N, numDiags,
		A.d_dIndices, A.d_diagOffsets, A.d_diagLens,
		A.d_real, A.d_imag,
		d_x_real, d_x_imag,
		d_y_real, d_y_imag
	);
	cudaCheck(cudaGetLastError(), "spmv_row_diag_sparse_kernel launch");
}

// -------------------------------------------------------------------------------------
// Vector kernels
// -------------------------------------------------------------------------------------
__global__ void vec_copy(unsigned int n, const valType *src_r, const valType *src_i, valType *dst_r, valType *dst_i) {
	unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx >= n) return;
	dst_r[idx] = src_r[idx];
	dst_i[idx] = src_i[idx];
}

// dst += src
__global__ void vec_axpy(unsigned int n, const valType *src_r, const valType *src_i, valType *dst_r, valType *dst_i) {
	unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx >= n) return;
	dst_r[idx] += src_r[idx];
	dst_i[idx] += src_i[idx];
}

// out = (-i * scale) * in   => (a+ib)*(-i*scale) = (b*scale) + i(-a*scale)
__global__ void vec_mul_minus_i_scale(unsigned int n, valType scale, const valType *in_r, const valType *in_i, valType *out_r, valType *out_i) {
	unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx >= n) return;
	valType a = in_r[idx];
	valType b = in_i[idx];
	out_r[idx] = b * scale;
	out_i[idx] = -a * scale;
}

// -------------------------------------------------------------------------------------
// Apply one Taylor step: psi_out = exp(-i H dt) psi_in
// Uses only SpMV + vector ops.
// -------------------------------------------------------------------------------------
static inline void expm_action_taylor_device(
	const DeviceDiaQ &H,
	valType dt,
	int max_iterations,
	// buffers (device pointers)
	const valType *psi_in_r,
	const valType *psi_in_i,
	valType *psi_out_r,
	valType *psi_out_i,
	valType *term_r,
	valType *term_i,
	valType *tmp_r,
	valType *tmp_i
) {
	const unsigned int N = H.shape[1];
	const int tpb = HAMSIM_TPB;
	int blocks = (int)((N + (unsigned int)tpb - 1U) / (unsigned int)tpb);
	if (blocks <= 0) blocks = 1;

	// result = psi_in
	vec_copy<<<blocks, tpb>>>(N, psi_in_r, psi_in_i, psi_out_r, psi_out_i);
	// term = psi_in  (this is k=0 term)
	vec_copy<<<blocks, tpb>>>(N, psi_in_r, psi_in_i, term_r, term_i);
	cudaCheck(cudaGetLastError(), "init vec_copy launch");

	// For k = 1..m:
	// tmp  = H * term
	// term = (-i * dt / k) * tmp
	// result += term
	for (int k = 1; k <= max_iterations; ++k) {
		spmv_device(H, term_r, term_i, tmp_r, tmp_i);

		// term = (-i * (dt/k)) * tmp
		valType scale = dt / (valType)k;
		vec_mul_minus_i_scale<<<blocks, tpb>>>(N, scale, tmp_r, tmp_i, term_r, term_i);
		cudaCheck(cudaGetLastError(), "vec_mul_minus_i_scale launch");

		vec_axpy<<<blocks, tpb>>>(N, term_r, term_i, psi_out_r, psi_out_i);
		cudaCheck(cudaGetLastError(), "vec_axpy launch");
	}

	cudaCheck(cudaDeviceSynchronize(), "expm_action_taylor_device sync");
}

// -------------------------------------------------------------------------------------
// Inputs:
// - t = TOTAL evolution time
// - r = number of timesteps (uniform), dt = t / r
// - Each timestep applies exp(-i H dt) via Taylor action on the state vector
//
// Transfers: H H2D once, psi0 H2D once, final psi D2H once.
// -------------------------------------------------------------------------------------
std::shared_ptr<vector> hamiltonian_simulation_cuda(
	std::shared_ptr<diaQMatrix> H,
	std::shared_ptr<vector> psi0,
	valType t,
	long unsigned r,
	int max_iterations,
	valType /*scale_cutoff*/,
	valType /*tolerance*/
) {
	if (!H)   throw std::runtime_error("hamiltonian_simulation_cuda: H is null");
	if (!psi0) throw std::runtime_error("hamiltonian_simulation_cuda: psi0 is null");

	if (H->matrix_shape[0] != H->matrix_shape[1]) {
		throw std::runtime_error("hamiltonian_simulation_cuda: H must be square");
	}
	if (psi0->numRows != H->matrix_shape[1]) {
		throw std::runtime_error("hamiltonian_simulation_cuda: psi0 dimension mismatch");
	}

	const unsigned int N = H->matrix_shape[1];
	if (N == 0) {
		return std::make_shared<vector>(0, 0.0, 0.0);
	}

	// Upload H once
	DeviceDiaQ dH = upload_matrix_values_once(H);

	// Allocate vectors on device
	valType *d_a_r = nullptr, *d_a_i = nullptr; // current state
	valType *d_b_r = nullptr, *d_b_i = nullptr; // next state
	valType *d_term_r = nullptr, *d_term_i = nullptr;
	valType *d_tmp_r  = nullptr, *d_tmp_i  = nullptr;

	cudaCheck(cudaMalloc(&d_a_r,    N * sizeof(valType)), "malloc state real");
	cudaCheck(cudaMalloc(&d_a_i,    N * sizeof(valType)), "malloc state imag");
	cudaCheck(cudaMalloc(&d_b_r,    N * sizeof(valType)), "malloc next real");
	cudaCheck(cudaMalloc(&d_b_i,    N * sizeof(valType)), "malloc next imag");
	cudaCheck(cudaMalloc(&d_term_r, N * sizeof(valType)), "malloc term real");
	cudaCheck(cudaMalloc(&d_term_i, N * sizeof(valType)), "malloc term imag");
	cudaCheck(cudaMalloc(&d_tmp_r,  N * sizeof(valType)), "malloc tmp real");
	cudaCheck(cudaMalloc(&d_tmp_i,  N * sizeof(valType)), "malloc tmp imag");

	// Upload psi0 once
	cudaCheck(cudaMemcpy(d_a_r, psi0->realValues, N * sizeof(valType), cudaMemcpyHostToDevice), "H2D psi0.real");
	cudaCheck(cudaMemcpy(d_a_i, psi0->imagValues, N * sizeof(valType), cudaMemcpyHostToDevice), "H2D psi0.imag");

	// timestepping
	if (r == 0) {
		// no evolution: output = psi0
		std::shared_ptr<vector> out = std::make_shared<vector>(N, 0.0, 0.0);
		cudaCheck(cudaMemcpy(out->realValues, d_a_r, N * sizeof(valType), cudaMemcpyDeviceToHost), "D2H out.real");
		cudaCheck(cudaMemcpy(out->imagValues, d_a_i, N * sizeof(valType), cudaMemcpyDeviceToHost), "D2H out.imag");

		cudaFree(d_a_r); cudaFree(d_a_i);
		cudaFree(d_b_r); cudaFree(d_b_i);
		cudaFree(d_term_r); cudaFree(d_term_i);
		cudaFree(d_tmp_r); cudaFree(d_tmp_i);
		return out;
	}

	valType dt = t / (valType)r;

	for (long unsigned step = 0; step < r; ++step) {
		expm_action_taylor_device(
			dH, dt, max_iterations,
			d_a_r, d_a_i,
			d_b_r, d_b_i,
			d_term_r, d_term_i,
			d_tmp_r, d_tmp_i
		);

		// swap current/next
		std::swap(d_a_r, d_b_r);
		std::swap(d_a_i, d_b_i);
	}

	// Copy final vector back once
	std::shared_ptr<vector> out = std::make_shared<vector>(N, 0.0, 0.0);
	cudaCheck(cudaMemcpy(out->realValues, d_a_r, N * sizeof(valType), cudaMemcpyDeviceToHost), "D2H out.real");
	cudaCheck(cudaMemcpy(out->imagValues, d_a_i, N * sizeof(valType), cudaMemcpyDeviceToHost), "D2H out.imag");

	// cleanup
	cudaFree(d_a_r); cudaFree(d_a_i);
	cudaFree(d_b_r); cudaFree(d_b_i);
	cudaFree(d_term_r); cudaFree(d_term_i);
	cudaFree(d_tmp_r); cudaFree(d_tmp_i);
	// dH freed by destructor

	return out;
}

} // namespace diaq
