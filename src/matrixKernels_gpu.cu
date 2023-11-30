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
vector spmv_cuda(diaQMatrix A, vector x) {
	// ------------------ DEBUG ------------------
	std::cout << "\nUsing CUDA to calculate product of matrix and vector" << std::endl;
	// ------------------ DEBUG ------------------
	if (A.matrix_shape[1] != x.num_rows()) {
		throw std::invalid_argument("Not multiplyable");
	}

	vector y(A.matrix_shape[0], 0);
	float *y_real_values = y.getRealValues();
	float *y_imag_values = y.getImagValues();

	float *x_real_values = x.getRealValues();
	float *x_imag_values = x.getImagValues();

	long int n_diags = A.num_diags();
	long int *diagonal_indices = (long int *)malloc(n_diags * sizeof(long int));
	long int *cum_diagonal_lengths = (long int *)malloc(n_diags * sizeof(long int));
	long int num_elements = 0;
	long int k = 0;
	std::map<long int, diagonal> A_diagMap = A.getDiagonalMap();
	for (auto x : A_diagMap) {
		diagonal_indices[k] = x.first;
		if (k == 0) {
			cum_diagonal_lengths[k] = x.second.dLength;
		} else {
			cum_diagonal_lengths[k] = cum_diagonal_lengths[k - 1] + x.second.dLength;
		}
		k++;
		num_elements += x.second.dLength;
	}
	// ------------------ DEBUG ------------------
	// std::cout << "num_elements = " << num_elements << std::endl;
	// ------------------ DEBUG ------------------
	long int p = 0;
	float *real_data = (float *)malloc(num_elements * sizeof(float));
	float *imag_data = (float *)malloc(num_elements * sizeof(float));
	for (auto x : A_diagMap) {
		float *real_vals = x.second.getRealValues();
		float *imag_vals = x.second.getImagValues();
		for (int i = 0; i < x.second.dLength; i++) {
			real_data[p] = real_vals[i];
			imag_data[p++] = imag_vals[i];
		}
	}
	// ------------------ DEBUG ------------------
	// std::cout << "diagonal_indices: [";
	// for (int i = 0; i < n_diags - 1; i++) {
	// 	std::cout << diagonal_indices[i] << ", ";
	// }
	// std::cout << diagonal_indices[n_diags - 1] << "]" << std::endl;

	// std::cout << "cum_diagonal_lengths: [";
	// for (int i = 0; i < n_diags - 1; i++) {
	// 	std::cout << cum_diagonal_lengths[i] << ", ";
	// }
	// std::cout << cum_diagonal_lengths[n_diags - 1] << "]" << std::endl;

	// std::cout << "(num_elements = " << num_elements << ") [";
	// for (int i = 0; i < num_elements - 1; i++) {
	// 	std::cout << "(" << real_data[i] << "," << imag_data[i] << "), ";
	// }
	// std::cout << "(" << real_data[num_elements - 1] << "," << imag_data[num_elements - 1] << ")]" << std::endl;
	// ------------------ DEBUG ------------------
	int blockSize = 256;
	int gridSize = (A.matrix_shape[0] + blockSize - 1) / blockSize;

	// cuda allocation
	float *d_real_data, *d_imag_data, *d_x_real_values, *d_x_imag_values, *d_y_real_values, *d_y_imag_values;
	long int *d_diagonal_indices, *d_cum_diagonal_lengths;
	cudaMalloc((void **)&d_real_data, num_elements * sizeof(float));
	cudaMalloc((void **)&d_imag_data, num_elements * sizeof(float));
	cudaMalloc((void **)&d_x_real_values, x.num_rows() * sizeof(float));
	cudaMalloc((void **)&d_x_imag_values, x.num_rows() * sizeof(float));
	cudaMalloc((void **)&d_y_real_values, y.num_rows() * sizeof(float));
	cudaMalloc((void **)&d_y_imag_values, y.num_rows() * sizeof(float));
	cudaMalloc((void **)&d_diagonal_indices, n_diags * sizeof(long int));
	cudaMalloc((void **)&d_cum_diagonal_lengths, n_diags * sizeof(long int));
	// cuda copy
	cudaMemcpy(d_real_data, real_data, num_elements * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_imag_data, imag_data, num_elements * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_x_real_values, x_real_values, x.num_rows() * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_x_imag_values, x_imag_values, x.num_rows() * sizeof(float), cudaMemcpyHostToDevice);
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
	std::cout << "\nUsing CUDA to calculate product of two matrices" << std::endl;
	if(A.matrix_shape[1] != B.matrix_shape[0]) {
		throw std::invalid_argument("Not multiplyable");
	}
	// TODO
	return A;
}