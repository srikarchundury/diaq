#include "denseMatrix.hpp"
#include "config.hpp"
#include "diaQMatrix.hpp"
#include <omp.h>

denseMatrix diaQMatrix::convertToDenseMatrix(std::vector<long int> new_shape) {
    float *real_data = (float *)calloc(matrix_shape[0] * matrix_shape[1], sizeof(float));
    float *imag_data = (float *)calloc(matrix_shape[0] * matrix_shape[1], sizeof(float));
    std::map<long int, diagonal>::iterator it;
    long int x, y;
    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        float *real_vals = it->second.getRealValues();
        float *imag_vals = it->second.getImagValues();
        if (it->first == 0) {
            x = 0;
            y = 0;
        }
        else if (it->first > 0) {
            x = 0;
            y = it->first;
        }
        else {
            x = -1 * it->first;
            y = 0;
        }
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for (long int i = 0; i < it->second.dLength; i++) {
            // std::cout << "(" << real_vals[i] << "," << imag_vals[i] << ")" << std::endl;
            real_data[ matrix_shape[1] * (x+i) + (y+i) ] = real_vals[i];
            imag_data[ matrix_shape[1] * (x+i) + (y+i) ] = imag_vals[i];
        }
    }
    denseMatrix d(&new_shape, real_data, imag_data);
    d.shape = shape;
    return d;
}

diaQMatrix denseMatrix::convertToQuantumSparse(std::vector<long int> new_shape) {
    // counting the number of diagonals in a matrix that isn't a perfect square.
    // long int s = 0;
    // for(long int i = 0; i < new_shape.size(); i++) {
    //     s = s + new_shape[i];
    // }
    // std::cout << "converting dense to sparse" << std::endl;
    std::map<long int, diagonal> diagMap;    
    diaQMatrix qm(diagMap, &new_shape);
    // #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
    for(long int i = -1 * qm.matrix_shape[0]; i < qm.matrix_shape[1]; i++) {
        // TODO: This function calls .insert on a std::map and hence is thread-unsafe; need to think of a parallel insert
        // in std::map, else replace with some other datastructure.
        qm.createDiagonal(i);
    }
    // #pragma omp barrier
    #pragma omp parallel num_threads(NUMBER_OF_OMP_THREADS)
    for(long int i = 0; i < matrix_shape[0]; i++) {
        #pragma omp for
        for(long int j = 0; j < matrix_shape[1]; j++) {
            // std::cout << "In thread: " << omp_get_thread_num() << std::endl;
            std::vector<long int> pos{i, j};
            std::vector<long int> d_pos = qm.getDiagonalPosition(pos);
            // std::cout << "(" << i << "," << j << ")" << " " << d_pos[0] << " at pos " << d_pos[1] << std::endl;
            qm.setDiagonalElement(d_pos[0], d_pos[1], qm.getDiagonalLength(d_pos[0]), realData[i * new_shape[1] + j], imagData[i * new_shape[1] + j]);
        }
    }
    qm.pruneMatrix();
    qm.shape = shape;
    return qm;
}

diaQMatrix from_numpy(std::vector<std::complex<float>> vals, std::vector<long int> shape) {
    float *real_vals = (float *)malloc(vals.size() * sizeof(float));
    float *imag_vals = (float *)malloc(vals.size() * sizeof(float));
    
    #pragma omp parallel num_threads(NUMBER_OF_OMP_THREADS)
    for(long int i = 0; i < vals.size(); i++) {
        real_vals[i] = vals[i].real();
        imag_vals[i] = vals[i].imag();
    }

    long int rank = shape.size();
    if (rank > 2) {
        long int product = 1;
        for (long int val : shape) {
            product *= val;
        }
        long int sqrtProduct = static_cast<long int>(std::sqrt(product));
        // Find the closest factors of the product
        long int x = 1;
        long int y = product;
        for (long int i = sqrtProduct; i > 0; --i) {
            if (product % i == 0) {
                x = i;
                y = product / i;
                break;
            }
        }
        std::vector<long int> new_shape{x, y};
        std::vector<long int> orig_shape = shape;
        return denseMatrix(&new_shape, real_vals, imag_vals, &orig_shape).convertToQuantumSparse(new_shape);
    } else {
        return denseMatrix(&shape, real_vals, imag_vals, &shape).convertToQuantumSparse(shape);
    }
}

std::vector<std::complex<float> > to_numpy(diaQMatrix A) {
    denseMatrix d = A.convertToDenseMatrix(A.matrix_shape);
    return d.getData_forPy();
}

#ifdef CUDA_ENABLED
    // CUDA runtime
    #include "cuda_runtime_api.h"
    #include "cuda_runtime.h"
    #include "cuda_profiler_api.h"
    #include "device_launch_parameters.h"
    // CUDA is on
    __global__ void convert_to_dq(float* device_real_data, float* device_imag_data, long int size, long int matrix_size_x, long int matrix_size_y, long int* device_diagonal_indices, float* device_diagonal_real_data, float* device_diagonal_imag_data) {
        long int index = blockIdx.x * blockDim.x + threadIdx.x;
        if (index < size) {
            long int x = index / matrix_size_y;
            long int y = index % matrix_size_y;
            long int dIndex = x - y;
            long int dLength = matrix_size_y - abs(dIndex);

            // Calculate the offset in the diagonal arrays
            long int diagonal_offset = device_diagonal_indices[dIndex + matrix_size_y - 1] + y;

            // Store the diagonal index
            device_diagonal_indices[diagonal_offset] = dIndex;

            // Store the values in the correct offset of the diagonal arrays
            device_diagonal_real_data[diagonal_offset] = device_real_data[index];
            device_diagonal_imag_data[diagonal_offset] = device_imag_data[index];
        }
    }

    diaQMatrix from_numpy_cuda(std::vector<std::complex<float>> values, std::vector<long int> shape) {
        std::cout << "Using CUDA to convert NumPy array to diaQMatrix" << std::endl;
        long int size = values.size();
        int rank = shape.size();
        long int x, y;
        if(rank > 2) {
            // Flatten the first two dimensions while keeping the rest intact
            x = shape[0] * shape[1];
            y = 1;
            for (long int r = 2; r < rank; r++) {
                y *= shape[r];
            }
        } else {
            x = shape[0];
            y = shape[1];
        }
        std::vector<long int> matrix_shape{x, y};

        long int matrix_size_x = matrix_shape[0]; // Assuming first dimension as rows
        long int matrix_size_y = matrix_shape[1]; // Assuming second dimension as columns

        // Allocate memory on the device for input data
        float* device_real_data;
        float* device_imag_data;
        cudaMalloc(&device_real_data, size * sizeof(float));
        cudaMalloc(&device_imag_data, size * sizeof(float));

        float* host_real_data = (float *)malloc(size * sizeof(float));
        #pragma omp parallel num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < size; i++) {
            host_real_data[i] = values[i].real();
        }
        float* host_imag_data = (float *)malloc(size * sizeof(float));
        #pragma omp parallel num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < size; i++) {
            host_imag_data[i] = values[i].imag();
        }

        // Copy data from host to device
        cudaMemcpy(device_real_data, host_real_data, size * sizeof(float), cudaMemcpyHostToDevice);
        cudaMemcpy(device_imag_data, host_imag_data, size * sizeof(float), cudaMemcpyHostToDevice);

        // Allocate memory on the device for diaQMatrix map
        long int* device_diagonal_indices;
        float* device_diagonal_real_data;
        float* device_diagonal_imag_data;
        long int num_diagonals = matrix_size_x + matrix_size_y - 1;
        cudaMalloc(&device_diagonal_indices, num_diagonals * sizeof(long int));
        cudaMalloc(&device_diagonal_real_data, size * sizeof(float));
        cudaMalloc(&device_diagonal_imag_data, size * sizeof(float));

        // dim3 threadsPerBlock(16, 16);
        // dim3 numBlocks(10, 10);
        int totalDataSize = size;
        int threadsPerBlock = 256;
        // Calculate the number of blocks needed
        int numBlocks = (totalDataSize + threadsPerBlock - 1) / threadsPerBlock;
        // Hardcoded values for numBlocks and threadsPerBlock
        // Launch the kernel
        convert_to_dq<<<numBlocks, threadsPerBlock>>>(device_real_data, device_imag_data, size, matrix_size_x, matrix_size_y, device_diagonal_indices, device_diagonal_real_data, device_diagonal_imag_data);

        // Copy data from device to host if required
        long int* host_diagonal_indices = (long int *)malloc(num_diagonals * sizeof(long int));
        float* host_diagonal_real_data = (float *)malloc(size * sizeof(float));
        float* host_diagonal_imag_data = (float *)malloc(size * sizeof(float));
        cudaMemcpy(host_diagonal_indices, device_diagonal_indices, num_diagonals * sizeof(long int), cudaMemcpyDeviceToHost);
        cudaMemcpy(host_diagonal_real_data, device_diagonal_real_data, size * sizeof(float), cudaMemcpyDeviceToHost);
        cudaMemcpy(host_diagonal_imag_data, device_diagonal_imag_data, size * sizeof(float), cudaMemcpyDeviceToHost);

        // Free memory on the device
        cudaFree(device_real_data);
        cudaFree(device_imag_data);
        cudaFree(device_diagonal_indices);

        std::map<long int, diagonal> diagMap;
        long int k = 0;
        for (long int i = 0; i < num_diagonals; i++) {
            long int dIndex = host_diagonal_indices[i];
            long int dLength = matrix_size_y - abs(dIndex);
            float* real_vals = (float *)malloc(dLength * sizeof(float));
            float* imag_vals = (float *)malloc(dLength * sizeof(float));
            for (long int j = 0; j < dLength; j++) {
                real_vals[j] = host_diagonal_real_data[k];
                imag_vals[j] = host_diagonal_imag_data[k];
                k++;
            }
            diagonal d(dIndex, dLength, real_vals, imag_vals);
            diagMap.insert(std::pair<long int, diagonal>(dIndex, d));
        }
        return diaQMatrix(diagMap, &matrix_shape, &shape);
    }
#else
    // CUDA is off
    diaQMatrix from_numpy_cuda(std::vector<std::complex<float>> vals, std::vector<long int> shape) {
        std::cout << "CUDA is not supported on this system. Using CPU to convert NumPy array to diaQMatrix" << std::endl;
        return from_numpy(vals, shape);
    }
#endif