#include "conversions.hpp"

#ifdef CUDA_ENABLED
	#include "conversions_gpu.hpp"
#endif

namespace diaq {

denseMatrix *diaQMatrix::convertToDenseMatrix(std::vector<long int> new_shape) {
    valType *real_data = (valType *)calloc(matrix_shape[0] * matrix_shape[1], sizeof(valType));
    valType *imag_data = (valType *)calloc(matrix_shape[0] * matrix_shape[1], sizeof(valType));
    std::unordered_map<long int, diagonal*>::iterator it;
    long int x, y;
    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        valType *real_vals = it->second->getRealValues();
        valType *imag_vals = it->second->getImagValues();
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
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS) schedule(dynamic)
        for (long int i = 0; i < it->second->dLength; i++) {
            // std::cout << "(" << real_vals[i] << "," << imag_vals[i] << ")" << std::endl;
            real_data[ matrix_shape[1] * (x+i) + (y+i) ] = real_vals[i];
            imag_data[ matrix_shape[1] * (x+i) + (y+i) ] = imag_vals[i];
        }
    }
    denseMatrix *d = new denseMatrix(&new_shape, real_data, imag_data);
    d->shape = shape;
    // comment below line for tests.cpp
    // this->free();
    return d;
}

diaQMatrix *denseMatrix::convertToQuantumSparse() {
    return this->convertToQuantumSparse(this->shape);
}

diaQMatrix *denseMatrix::convertToQuantumSparse(std::vector<long int> new_shape) {
    #ifdef CUDA_ENABLED
        return convertToQuantumSparse_cuda(this, new_shape);
    #else
    // counting the number of diagonals in a matrix that isn't a perfect square.
    // long int s = 0;
    // for(long int i = 0; i < new_shape.size(); i++) {
    //     s = s + new_shape[i];
    // }
    // std::cout << "converting dense to sparse" << std::endl;
    diaQMatrix *qm = new diaQMatrix(&new_shape);
    // printf("printing empty matrix");
    // qm->print();
    // #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS) schedule(dynamic)
    // for(long int i = -1 * qm->matrix_shape[0]; i < qm->matrix_shape[1]; i++) {
    //     qm->createDiagonal(i);
    // }
    // #pragma omp barrier
    for(long int i = 0; i < matrix_shape[0]; i++) {
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS) schedule(dynamic)
        for(long int j = 0; j < matrix_shape[1]; j++) {
            // std::cout << "In thread: " << omp_get_thread_num() << std::endl;
            std::vector<long int> pos{i, j};
            std::vector<long int> d_pos = qm->getDiagonalPosition(pos);
            long int d_len = qm->getDiagonalLength(d_pos[0]);
            // std::cout << "(" << i << "," << j << ")" << " " << d_pos[0] << " at pos " << d_pos[1] << std::endl;
            if(realData[i * new_shape[1] + j] != 0.0 || imagData[i * new_shape[1] + j] != 0.0) {
                // printf("realData[%ld] = %f, imagData[%ld] = %f\n", i * new_shape[1] + j, realData[i * new_shape[1] + j], i * new_shape[1] + j, imagData[i * new_shape[1] + j]);
                qm->setDiagonalElement(d_pos[0], d_pos[1], d_len, realData[i * new_shape[1] + j], imagData[i * new_shape[1] + j]);
            }
        }
    }
    // qm->pruneMatrix();
    qm->shape = shape;
    // comment below line for tests.cpp
    // this->free();
    return qm;
    #endif
}

std::vector<std::complex<valType> > to_numpy(diaQMatrix *A) {
    denseMatrix *d = A->convertToDenseMatrix(A->matrix_shape);
    // comment below line for tests.cpp
    // A->free();
    return d->getData_forPy();
}

diaQMatrix *from_numpy(std::vector<std::complex<valType>> vals, std::vector<long int> shape) {
    #ifdef CUDA_ENABLED
        return from_numpy_cuda(vals, shape);
    #else
        valType *real_vals = (valType *)malloc(vals.size() * sizeof(valType));
        valType *imag_vals = (valType *)malloc(vals.size() * sizeof(valType));
        
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS) schedule(dynamic)
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
            denseMatrix *d = new denseMatrix(&new_shape, real_vals, imag_vals, &orig_shape);
            return d->convertToQuantumSparse(new_shape);
        } else {
            denseMatrix *d = new denseMatrix(&shape, real_vals, imag_vals, &shape);
            return d->convertToQuantumSparse(shape);
        }
    #endif
}

} // namespace diaq