#include "conversions_gpu.hpp"

namespace diaq {

__global__ void convert_to_dq(
	long int size, long int matrix_size_x, long int matrix_size_y,
	long int* device_diagonal_idx, long int* device_diagonal_pos
) {
	// printf("kernel called with size: %ld, matrix_size_x: %ld, matrix_size_y: %ld\n", size, matrix_size_x, matrix_size_y);
	long int index = blockIdx.x * (blockDim.x * blockDim.y * blockDim.z) + threadIdx.z * (blockDim.x * blockDim.y) + threadIdx.y * blockDim.x + threadIdx.x;
	if (index < size) {
		// printf("index: %ld\n", index);
		// TODO: reduce this below function to a single line
		long int d_idx = ((index - matrix_size_y * (index / matrix_size_y)) % matrix_size_y) - (index / matrix_size_y);
		long int d_pos;
		if(d_idx <= 0) {
			d_pos = ((index - matrix_size_y * (index / matrix_size_y)) % matrix_size_y);
		} else {
			d_pos = ((index - matrix_size_y * (index / matrix_size_y)) % matrix_size_y) - d_idx;
		}
		// printf("index: %ld, dIndex: %ld, val:%ld\n", index, d_idx, d_pos);
		device_diagonal_idx[index] = d_idx;
		device_diagonal_pos[index] = d_pos;
	}
}
/*
 * 		Converts a NumPy array to diaQMatrix using CUDA
 * 		Parameters:
 * 			values: A vector of complex<valType> values
 * 			shape: A vector of long int values
 * 		Returns:
 * 			diaQMatrix
 * 		Note:
 * 			1. The shape vector should be of length 2
 * 			2. The values vector should be of length equal to the product of the elements of shape
 * 			3. The values vector should be in row-major order
 * 			4. The values vector should be a flattened version of the NumPy array 
*/
diaQMatrix *from_numpy_cuda(std::vector<std::complex<valType>> values, std::vector<long int> shape) {
	logger.log("Using CUDA to convert NumPy array to diaQMatrix");
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

	int totalDataSize = size;
	int threadsPerBlock = 256;
	int numBlocks = (totalDataSize + threadsPerBlock - 1) / threadsPerBlock;
	// launch kernel
	convert_to_dq<<<numBlocks, threadsPerBlock>>>(size, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);

	// int blockSize = 256;
	// dim3 threadsPerBlock(blockSize, blockSize);
	// dim3 numBlocks((matrix_size_x + blockSize - 1) / blockSize, (matrix_size_y + blockSize - 1) / blockSize);
	// // launch kernel
	// convert_to_dq<<<numBlocks, threadsPerBlock>>>(size, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);

	// why isn't the below working logically? – Have no clue
	// dim3 threadsPerBlock(4, 4, 4);
	// dim3 numBlocks(size/4, size/4, size/4);
	// // launch kernel
	// convert_to_dq<<<numBlocks, threadsPerBlock>>>(size, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);

	long int* host_diagonal_idx = (long int *)malloc(size * sizeof(long int));
	long int* host_diagonal_pos = (long int *)malloc(size * sizeof(long int));
	cudaMemcpy(host_diagonal_idx, device_diagonal_idx, size * sizeof(long int), cudaMemcpyDeviceToHost);
	cudaMemcpy(host_diagonal_pos, device_diagonal_pos, size * sizeof(long int), cudaMemcpyDeviceToHost);

	// Free memory on the device
	cudaFree(device_diagonal_idx);
	cudaFree(device_diagonal_pos);

	// -------------- DEBUG ---------------
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
	// -------------- DEBUG ---------------

	std::unordered_map<long int, diagonal*> diagMap;
	diaQMatrix *diaq_res = new diaQMatrix(diagMap, &matrix_shape, &shape);
	// #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS) schedule(dynamic)
	// for(long int i = -1 * matrix_size_x; i < matrix_size_y; i++) {
	// 	diaq_res->createDiagonal(i);
	// }
	#pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS) schedule(dynamic)
	for (long int i = 0; i < size; i++) {
		long int dIndex = host_diagonal_idx[i];
		long int dPos = host_diagonal_pos[i];
		diaq_res->setDiagonalElement(dIndex, dPos, diaq_res->getDiagonalLength(dIndex), values[i].real(), values[i].imag());
	}
	diaq_res->pruneMatrix();
	return diaq_res;
}
/*
 * 		Converts a diaQMatrix to denseMatrix using CUDA
 * 		Parameters:
 * 			d: A diaQMatrix
 * 			new_shape: A vector of long int values
 * 		Returns:
 * 			denseMatrix
*/
diaQMatrix *convertToQuantumSparse_cuda(denseMatrix *d, std::vector<long int> new_shape) {
	logger.log("Using CUDA to convert denseMatrix to diaQMatrix");
	valType *realData = d->getRealData();
	valType *ImagData = d->getImagData();
	long int size = d->size;
	long int matrix_size_x = new_shape[0]; // Assuming first dimension as rows
	long int matrix_size_y = new_shape[1]; // Assuming second dimension as columns

	// Allocate memory on the device for diaQMatrix map
	long int* device_diagonal_idx;
	long int* device_diagonal_pos;
	cudaMalloc(&device_diagonal_idx, size * sizeof(long int));
	cudaMalloc(&device_diagonal_pos, size * sizeof(long int));

	int totalDataSize = size;
	int threadsPerBlock = 1024;
	int numBlocks = (totalDataSize + threadsPerBlock - 1) / threadsPerBlock;
	// launch kernel
	convert_to_dq<<<numBlocks, threadsPerBlock>>>(size, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);

	// int blockSize = 256;
	// dim3 threadsPerBlock(blockSize, blockSize);
	// dim3 numBlocks((matrix_size_x + blockSize - 1) / blockSize, (matrix_size_y + blockSize - 1) / blockSize);
	// // launch kernel
	// convert_to_dq<<<numBlocks, threadsPerBlock>>>(size, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);

	// why doesnt the below work logically? – Have no clue
	// dim3 threadsPerBlock(4, 4, 4);
	// dim3 numBlocks(size/4, size/4, size/4);
	// // launch kernel
	// convert_to_dq<<<numBlocks, threadsPerBlock>>>(size, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);

	long int* host_diagonal_idx = (long int *)malloc(size * sizeof(long int));
	long int* host_diagonal_pos = (long int *)malloc(size * sizeof(long int));
	cudaMemcpy(host_diagonal_idx, device_diagonal_idx, size * sizeof(long int), cudaMemcpyDeviceToHost);
	cudaMemcpy(host_diagonal_pos, device_diagonal_pos, size * sizeof(long int), cudaMemcpyDeviceToHost);

	// Free memory on the device
	cudaFree(device_diagonal_idx);
	cudaFree(device_diagonal_pos);

	// -------------- DEBUG ---------------
	// std::cout << "Matrix shape" << std::endl;
	// for (long int i = 0; i < 2; i++) {
	//     std::cout << new_shape[i] << " ";
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
	// -------------- DEBUG ---------------

	std::unordered_map<long int, diagonal*> diagMap;
	diaQMatrix *diaq_res = new diaQMatrix(diagMap, &new_shape);
	// #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS) schedule(dynamic)
	// for(long int i = -1 * matrix_size_x; i < matrix_size_y; i++) {
	// 	diaq_res->createDiagonal(i);
	// }
	#pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS) schedule(dynamic)
	for (long int i = 0; i < size; i++) {
		long int dIndex = host_diagonal_idx[i];
		long int dPos = host_diagonal_pos[i];
		diaq_res->setDiagonalElement(dIndex, dPos, diaq_res->getDiagonalLength(dIndex), realData[i], ImagData[i]);
	}
	diaq_res->pruneMatrix();
	// d->free();
	return diaq_res;
}

} // namespace diaq