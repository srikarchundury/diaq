#include <iostream>
#include <vector>
#include <map>
#include <complex>
#include <cmath>
#include <omp.h>
#include "diaQMatrix.hpp"

// CUDA libraries
#include "cuda_runtime_api.h"
#include "cuda_runtime.h"
#include "cuda_profiler_api.h"
#include "device_launch_parameters.h"

__global__ void convert_to_dq(
	long int size, long int matrix_size_x, long int matrix_size_y,
	long int* device_diagonal_idx, long int* device_diagonal_pos
) {
	long int index = blockIdx.x * blockDim.x + threadIdx.x;
	if (index < size) {
		long int mat_x = index / matrix_size_y;
		long int flatIndex = index - matrix_size_y * mat_x;
		long int mat_y = flatIndex % matrix_size_y;
		long int d_idx = mat_y - mat_x;
		long int d_pos;
		if(d_idx <= 0) {
			d_pos = mat_y;
		} else {
			d_pos = mat_y - d_idx;
		}
		// printf("index: %ld, x: %ld, y: %ld, dIndex: %ld, val:%ld\n", index, mat_x, mat_y, d_idx, d_pos);
		device_diagonal_idx[index] = d_idx;
		device_diagonal_pos[index] = d_pos;
	}
}

diaQMatrix from_numpy_cuda(std::vector<std::complex<float>> values, std::vector<long int> shape) {
	std::cout << "Using CUDA to convert NumPy array to diaQMatrix" << std::endl;
	long int size = values.size();
	int rank = shape.size();
	long int x, y;
	if(rank > 2) {
		long int product = 1;
		for (long int val : shape) {
			product *= val;
		}
		long int sqrtProduct = (long int)sqrt(product);
		// Find the closest factors of the product
		x = 1;
		y = product;
		for (long int i = sqrtProduct; i > 0; --i) {
			if (product % i == 0) {
				x = i;
				y = product / i;
				break;
			}
		}
	} else {
		x = shape[0];
		y = shape[1];
	}
	std::vector<long int> matrix_shape{x, y};

	long int matrix_size_x = matrix_shape[0]; // Assuming first dimension as rows
	long int matrix_size_y = matrix_shape[1]; // Assuming second dimension as columns

	// Allocate memory on the device for diaQMatrix map
	long int* device_diagonal_idx;
	long int* device_diagonal_pos;
	cudaMalloc(&device_diagonal_idx, size * sizeof(long int));
	cudaMalloc(&device_diagonal_pos, size * sizeof(long int));

	// dim3 threadsPerBlock(16, 16);
	// dim3 numBlocks(size/16,size/16);
	int totalDataSize = size;
	int threadsPerBlock = 256;
	// Calculate the number of blocks needed
	int numBlocks = (totalDataSize + threadsPerBlock - 1) / threadsPerBlock;
	// Hardcoded values for numBlocks and threadsPerBlock
	// Launch the kernel
	convert_to_dq<<<numBlocks, threadsPerBlock>>>(size, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);

	long int* host_diagonal_idx = (long int *)malloc(size * sizeof(long int));
	long int* host_diagonal_pos = (long int *)malloc(size * sizeof(long int));
	cudaMemcpy(host_diagonal_idx, device_diagonal_idx, size * sizeof(long int), cudaMemcpyDeviceToHost);
	cudaMemcpy(host_diagonal_pos, device_diagonal_pos, size * sizeof(long int), cudaMemcpyDeviceToHost);

	// Free memory on the device
	cudaFree(device_diagonal_idx);
	cudaFree(device_diagonal_pos);

	// std::cout << "Matrix shape" << std::endl;
	// for (long int i = 0; i < 2; i++) {
	//     std::cout << matrix_shape[i] << " ";
	// }
	// std::cout << std::endl;

	// std::cout << "Diagonal indices" << std::endl;
	// for (long int i = 0; i < size; i++) {
	//     std::cout << host_diagonal_idx[i] << " ";
	// }
	// std::cout << std::endl;
	// std::cout << "Diagonal positions" << std::endl;
	// for (long int i = 0; i < size; i++) {
	//     std::cout << host_diagonal_pos[i] << " ";
	// }
	// std::cout << std::endl;

	std::map<long int, diagonal> diagMap;
	diaQMatrix diaq_res(diagMap, &matrix_shape, &shape);
	for(long int i = -1 * matrix_size_x; i < matrix_size_y; i++) {
		// TODO: This function calls .insert on a std::map and hence is thread-unsafe; need to think of a parallel insert
		// in std::map, else replace with some other datastructure.
		diaq_res.createDiagonal(i);
	}
	#pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
	for (long int i = 0; i < size; i++) {
		long int dIndex = host_diagonal_idx[i];
		long int dPos = host_diagonal_pos[i];
		diaq_res.setDiagonalElement(dIndex, dPos, diaq_res.getDiagonalLength(dIndex), values[i].real(), values[i].imag());
	}
	diaq_res.pruneMatrix();
	return diaq_res;
}