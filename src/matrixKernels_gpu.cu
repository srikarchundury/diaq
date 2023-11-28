#include "matrixKernels_gpu.hpp"


__global__ void spmv_kernel(const diaQMatrix A, float *x_real_values, float *x_imag_values, float *y_real_values, float *y_imag_values) {
	return;
}
/*
 * 	Product of matrix and vector (spMV)
 * 	@param A - matrix
 * 	@param x - vector
 * 	@return y = A * x
*/
vector spmv_cuda(diaQMatrix A, vector x) {
	std::cout << "Using CUDA to calculate product of matrix and vector" << std::endl;
	if (A.matrix_shape[1] != x.num_rows()) {
		throw std::invalid_argument("Not multiplyable");
	}
	vector y(A.matrix_shape[0], 0);
	float *y_real_values = y.getRealValues();
	float *y_imag_values = y.getImagValues();

	float *x_real_values = x.getRealValues();
	float *x_imag_values = x.getImagValues();

	int blockSize = 256;
	int gridSize = (A.matrix_shape[0] + blockSize - 1) / blockSize;
	spmv_kernel<<<gridSize, blockSize>>>(A, x_real_values, x_imag_values, y_real_values, y_imag_values);
	cudaDeviceSynchronize();
	return y;
}

__global__ void product_kernel(float *a_real_values, float *a_imag_values, float *b_real_values, float *b_imag_values, float *c_real_values, float *c_imag_values) {
	// TODO
	return;
}
/*
 * 	Product of two matrices (spMspM)
 * 	@param A - first matrix
 * 	@param B - second matrix
 * 	@return C = A * B
*/
diaQMatrix product_cuda(diaQMatrix A, diaQMatrix B) {
	std::cout << "Using CUDA to calculate product of two matrices" << std::endl;
	if(A.matrix_shape[1] != B.matrix_shape[0]) {
		throw std::invalid_argument("Not multiplyable");
	}
	// TODO
	return A;
}