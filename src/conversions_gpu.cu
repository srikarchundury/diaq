#include "conversions_gpu.hpp"

namespace diaq {

__global__ void convert_to_dq(
	unsigned long int size, unsigned long int matrix_size_x, unsigned long int matrix_size_y,
	long int* device_diagonal_idx, unsigned long int* device_diagonal_pos
) {
	long int index = blockIdx.x * (blockDim.x * blockDim.y * blockDim.z) + threadIdx.z * (blockDim.x * blockDim.y) + threadIdx.y * blockDim.x + threadIdx.x;
	if (index < size) {
		long int d_idx = ((index - matrix_size_y * (index / matrix_size_y)) % matrix_size_y) - (index / matrix_size_y);
		unsigned long int d_pos = (d_idx <= 0) ? ((index - matrix_size_y * (index / matrix_size_y)) % matrix_size_y) : ((index - matrix_size_y * (index / matrix_size_y)) % matrix_size_y) - d_idx;
		device_diagonal_idx[index] = d_idx;
		device_diagonal_pos[index] = d_pos;
	}
}

std::shared_ptr<diaQMatrix> from_numpy_cuda(std::complex<valType> *values, std::vector<unsigned long int> shape) {
	unsigned long int product = 1;
	for (unsigned long int val : shape) {
		product *= val;
	}
	int rank = shape.size();
	unsigned long int x, y;
	if(rank > 2) {
		unsigned long int sqrtProduct = (unsigned long int)sqrt(product);
		x = 1;
		y = product;
		for (unsigned long int i = sqrtProduct; i > 0; --i) {
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
	auto matrix_shape = std::make_shared<unsigned long int[]>(2);
	matrix_shape[0] = x;
	matrix_shape[1] = y;
	unsigned long int matrix_size_x = matrix_shape[0];
	unsigned long int matrix_size_y = matrix_shape[1];

	long int* device_diagonal_idx;
	unsigned long int* device_diagonal_pos;
	cudaMalloc(&device_diagonal_idx, product * sizeof(long int));
	cudaMalloc(&device_diagonal_pos, product * sizeof(unsigned long int));

	unsigned long int totalDataSize = product;
	int threadsPerBlock = 256;
	int numBlocks = (totalDataSize + threadsPerBlock - 1) / threadsPerBlock;
	convert_to_dq<<<numBlocks, threadsPerBlock>>>(product, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);

	auto host_diagonal_idx = std::make_shared<long int[]>(product);
	auto host_diagonal_pos = std::make_shared<unsigned long int[]>(product);
	cudaMemcpy(host_diagonal_idx.get(), device_diagonal_idx, product * sizeof(long int), cudaMemcpyDeviceToHost);
	cudaMemcpy(host_diagonal_pos.get(), device_diagonal_pos, product * sizeof(unsigned long int), cudaMemcpyDeviceToHost);

	cudaFree(device_diagonal_idx);
	cudaFree(device_diagonal_pos);

	std::unordered_map<long int, std::shared_ptr<diagonal>> diagMap;
	auto diaq_res = std::make_shared<diaQMatrix>(diagMap, matrix_shape.get(), shape);
	#pragma omp parallel for
	for (unsigned long int i = 0; i < product; i++) {
		long int dIndex = host_diagonal_idx[i];
		unsigned long int dPos = host_diagonal_pos[i];
		diaq_res->setDiagonalElement(dIndex, dPos, diaq_res->getDiagonalLength(dIndex), values[i].real(), values[i].imag());
	}
	diaq_res->pruneMatrix();
	return diaq_res;
}

std::shared_ptr<diaQMatrix> convertToQuantumSparse_cuda(std::shared_ptr<denseMatrix> d, std::shared_ptr<unsigned long int[]> new_shape) {
	valType *realData = d->getRealData();
	valType *ImagData = d->getImagData();
	unsigned long int size = d->size;
	unsigned long int matrix_size_x = new_shape[0];
	unsigned long int matrix_size_y = new_shape[1];

	long int* device_diagonal_idx;
	unsigned long int* device_diagonal_pos;
	cudaMalloc(&device_diagonal_idx, size * sizeof(long int));
	cudaMalloc(&device_diagonal_pos, size * sizeof(unsigned long int));

	int totalDataSize = size;
	int threadsPerBlock = 1024;
	int numBlocks = (totalDataSize + threadsPerBlock - 1) / threadsPerBlock;
	convert_to_dq<<<numBlocks, threadsPerBlock>>>(size, matrix_size_x, matrix_size_y, device_diagonal_idx, device_diagonal_pos);

	auto host_diagonal_idx = std::make_shared<long int[]>(size);
	auto host_diagonal_pos = std::make_shared<unsigned long int[]>(size);
	cudaMemcpy(host_diagonal_idx.get(), device_diagonal_idx, size * sizeof(long int), cudaMemcpyDeviceToHost);
	cudaMemcpy(host_diagonal_pos.get(), device_diagonal_pos, size * sizeof(unsigned long int), cudaMemcpyDeviceToHost);

	cudaFree(device_diagonal_idx);
	cudaFree(device_diagonal_pos);

	std::unordered_map<long int, std::shared_ptr<diagonal>> diagMap;
	auto diaq_res = std::make_shared<diaQMatrix>(diagMap, new_shape.get());
	#pragma omp parallel for
	for (unsigned long int i = 0; i < size; i++) {
		long int dIndex = host_diagonal_idx[i];
		unsigned long int dPos = host_diagonal_pos[i];
		diaq_res->setDiagonalElement(dIndex, dPos, diaq_res->getDiagonalLength(dIndex), realData[i], ImagData[i]);
	}
	diaq_res->pruneMatrix();
	return diaq_res;
}

} // namespace diaq
