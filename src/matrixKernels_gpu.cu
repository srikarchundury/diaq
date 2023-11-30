#include "matrixKernels_gpu.hpp"


__global__ void spmv_kernel(long int num_diags, long int num_elements, long int *diagonal_indices, long int *cum_diagonal_lengths, float *real_data, float *imag_data, float *x_real_values, float *x_imag_values, float *y_real_values, float *y_imag_values) {
	int n = blockIdx.x * blockDim.x + threadIdx.x;
	if(n < gridDim.x * blockDim.x && n < num_diags) {
		long int dIndex = diagonal_indices[n];
		long int dLength = cum_diagonal_lengths[n] - cum_diagonal_lengths[n-1];
		for(int i = 0; i < dLength; i++) {
			long int offset;
			if (n == 0) {
				offset = i;
			} else {
				offset = i + cum_diagonal_lengths[n-1];
			}
			long int x_idx = (dIndex < 0)? i : dIndex + i;
			long int y_idx = (dIndex < 0)? i - dIndex : i;

			// ------------------ DEBUG ------------------
			// printf("dLength = %ld, dIndex = %ld, dPos = %d, final_offset = %ld\tx_idx = %ld, y_idx = %ld\n", dLength, dIndex, i, offset, x_idx, y_idx);
			// ------------------ DEBUG ------------------

			float real_val = real_data[offset] * x_real_values[x_idx] - imag_data[offset] * x_imag_values[x_idx];
            float imag_val = real_data[offset] * x_imag_values[x_idx] + imag_data[offset] * x_real_values[x_idx];

            atomicAdd(&y_real_values[y_idx], real_val);
            atomicAdd(&y_imag_values[y_idx], imag_val);
		}
	}
	return;
}
/*
 * 	Product of matrix and vector (spMV)
 * 	@param A - matrix
 * 	@param x - vector
 * 	@return y = A * x
*/
vector spmv_cuda(diaQMatrix *A, vector *x) {
	// ------------------ DEBUG ------------------
	std::cout << "\nUsing CUDA to calculate product of matrix and vector" << std::endl;
	// ------------------ DEBUG ------------------
	if (A->matrix_shape[1] != x->num_rows()) {
		throw std::invalid_argument("Not multiplyable");
	}

	vector y(A->matrix_shape[0], 0);
	float *y_real_values = y.getRealValues();
	float *y_imag_values = y.getImagValues();

	float *x_real_values = x->getRealValues();
	float *x_imag_values = x->getImagValues();

	long int n_diags;
	long int *diagonal_indices;
	long int *cum_diagonal_lengths;
	long int num_elements;
	float *real_data;
	float *imag_data;
	A->getDiagFlatData(&n_diags, diagonal_indices, cum_diagonal_lengths, &num_elements, real_data, imag_data);

	// ------------------ DEBUG ------------------
	std::cout << "diagonal_indices: [";
	for (int i = 0; i < n_diags - 1; i++) {
		std::cout << diagonal_indices[i] << ", ";
	}
	std::cout << diagonal_indices[n_diags - 1] << "]" << std::endl;

	std::cout << "cum_diagonal_lengths: [";
	for (int i = 0; i < n_diags - 1; i++) {
		std::cout << cum_diagonal_lengths[i] << ", ";
	}
	std::cout << cum_diagonal_lengths[n_diags - 1] << "]" << std::endl;

	std::cout << "(num_elements = " << num_elements << ") [";
	for (int i = 0; i < num_elements - 1; i++) {
		std::cout << "(" << real_data[i] << "," << imag_data[i] << "), ";
	}
	std::cout << "(" << real_data[num_elements - 1] << "," << imag_data[num_elements - 1] << ")]" << std::endl;
	// ------------------ DEBUG ------------------
	int blockSize = 256;
	int gridSize = (A->matrix_shape[0] + blockSize - 1) / blockSize;

	// cuda allocation
	float *d_real_data, *d_imag_data, *d_x_real_values, *d_x_imag_values, *d_y_real_values, *d_y_imag_values;
	long int *d_diagonal_indices, *d_cum_diagonal_lengths;
	cudaMalloc((void **)&d_real_data, num_elements * sizeof(float));
	cudaMalloc((void **)&d_imag_data, num_elements * sizeof(float));
	cudaMalloc((void **)&d_x_real_values, x->num_rows() * sizeof(float));
	cudaMalloc((void **)&d_x_imag_values, x->num_rows() * sizeof(float));
	cudaMalloc((void **)&d_y_real_values, y.num_rows() * sizeof(float));
	cudaMalloc((void **)&d_y_imag_values, y.num_rows() * sizeof(float));
	cudaMalloc((void **)&d_diagonal_indices, n_diags * sizeof(long int));
	cudaMalloc((void **)&d_cum_diagonal_lengths, n_diags * sizeof(long int));
	// cuda copy
	cudaMemcpy(d_real_data, real_data, num_elements * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_imag_data, imag_data, num_elements * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_x_real_values, x_real_values, x->num_rows() * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_x_imag_values, x_imag_values, x->num_rows() * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_y_real_values, y_real_values, y.num_rows() * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_y_imag_values, y_imag_values, y.num_rows() * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_diagonal_indices, diagonal_indices, n_diags * sizeof(long int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_cum_diagonal_lengths, cum_diagonal_lengths, n_diags * sizeof(long int), cudaMemcpyHostToDevice);
	// cuda kernel
	spmv_kernel<<<gridSize, blockSize>>>(n_diags, num_elements, d_diagonal_indices, d_cum_diagonal_lengths, d_real_data, d_imag_data, d_x_real_values, d_x_imag_values, d_y_real_values, d_y_imag_values);
	// cuda copy back just y
	cudaMemcpy(y_real_values, d_y_real_values, y.num_rows() * sizeof(float), cudaMemcpyDeviceToHost);
	cudaMemcpy(y_imag_values, d_y_imag_values, y.num_rows() * sizeof(float), cudaMemcpyDeviceToHost);
	// cuda free
	cudaFree(d_real_data);
	cudaFree(d_imag_data);
	cudaFree(d_x_real_values);
	cudaFree(d_x_imag_values);
	cudaFree(d_y_real_values);
	cudaFree(d_y_imag_values);
	cudaFree(d_diagonal_indices);
	cudaFree(d_cum_diagonal_lengths);
	// free
	free(diagonal_indices);
	free(cum_diagonal_lengths);
	free(real_data);
	free(imag_data);

	return y;
}

__global__ void product_kernel() {
	// TODO
	return;
}
/*
 * 	Product of two matrices (spMspM)
 * 	@param A - first matrix
 * 	@param B - second matrix
 * 	@return C = A * B
*/
diaQMatrix product_cuda(diaQMatrix *A, diaQMatrix *B) {
	std::cout << "\nUsing CUDA to calculate product of two matrices" << std::endl;
	if(A->matrix_shape[1] != B->matrix_shape[0]) {
		throw std::invalid_argument("Not multiplyable");
	}
	// let's convert to  diagonal indices, cummulative lengths and flattened realData and flattened imagData to be able to send to GPU later
	// for A
	long int A_n_diags;
	long int *A_diagonal_indices;
	long int *A_cum_diagonal_lengths;
	long int A_num_elements;
	float *A_real_data;
	float *A_imag_data;
	A->getDiagFlatData(&A_n_diags, A_diagonal_indices, A_cum_diagonal_lengths, &A_num_elements, A_real_data, A_imag_data);
	// for B
	long int B_n_diags;
	long int *B_diagonal_indices;
	long int *B_cum_diagonal_lengths;
	long int B_num_elements;
	float *B_real_data;
	float *B_imag_data;
	B->getDiagFlatData(&B_n_diags, B_diagonal_indices, B_cum_diagonal_lengths, &B_num_elements, B_real_data, B_imag_data);

	// ------------------ DEBUG A ------------------
	std::cout << "A_n_diags = " << A_n_diags << std::endl;
	std::cout << "A_num_elements = " << A_num_elements << std::endl;
	std::cout << "A_diagonal_indices: [";
	for (int i = 0; i < A_n_diags - 1; i++) {
		std::cout << A_diagonal_indices[i] << ", ";
	}
	std::cout << A_diagonal_indices[A_n_diags - 1] << "]" << std::endl;
	std::cout << "A_cum_diagonal_lengths: [";
	for (int i = 0; i < A_n_diags - 1; i++) {
		std::cout << A_cum_diagonal_lengths[i] << ", ";
	}
	std::cout << A_cum_diagonal_lengths[A_n_diags - 1] << "]" << std::endl;
	std::cout << "(A_num_elements = " << A_num_elements << ") [";
	for (int i = 0; i < A_num_elements - 1; i++) {
		std::cout << "(" << A_real_data[i] << "," << A_imag_data[i] << "), ";
	}
	std::cout << "(" << A_real_data[A_num_elements - 1] << "," << A_imag_data[A_num_elements - 1] << ")]" << std::endl;
	// ------------------ DEBUG A ------------------
	std::cout << "---" << std::endl;
	// ------------------ DEBUG B ------------------
	std::cout << "B_n_diags = " << B_n_diags << std::endl;
	std::cout << "B_num_elements = " << B_num_elements << std::endl;
	std::cout << "B_diagonal_indices: [";
	for (int i = 0; i < B_n_diags - 1; i++) {
		std::cout << B_diagonal_indices[i] << ", ";
	}
	std::cout << B_diagonal_indices[B_n_diags - 1] << "]" << std::endl;
	std::cout << "B_cum_diagonal_lengths: [";
	for (int i = 0; i < B_n_diags - 1; i++) {
		std::cout << B_cum_diagonal_lengths[i] << ", ";
	}
	std::cout << B_cum_diagonal_lengths[B_n_diags - 1] << "]" << std::endl;
	std::cout << "(B_num_elements = " << B_num_elements << ") [";
	for (int i = 0; i < B_num_elements - 1; i++) {
		std::cout << "(" << B_real_data[i] << "," << B_imag_data[i] << "), ";
	}
	std::cout << "(" << B_real_data[B_num_elements - 1] << "," << B_imag_data[B_num_elements - 1] << ")]" << std::endl;
	// ------------------ DEBUG B ------------------

	return *A;
}