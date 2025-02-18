#include "conversions.hpp"

#ifdef CUDA_ENABLED
	#include "conversions_gpu.hpp"
#endif

namespace diaq {

valType *diaQMatrix::getRealValues() {
    denseMatrix *d = this->convertToDenseMatrix();
    return d->getRealData();
}

valType *diaQMatrix::getImagValues() {
    denseMatrix *d = this->convertToDenseMatrix();
    return d->getImagData();
}

denseMatrix *diaQMatrix::convertToDenseMatrix() {
    return this->convertToDenseMatrix(this->matrix_shape);
}

denseMatrix *diaQMatrix::convertToDenseMatrix(long int *new_shape) {
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
        #pragma omp parallel for
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
    long int *new_shape_arr = new long int[new_shape.size()];
    for (long int i = 0; i < new_shape.size(); i++) {
        new_shape_arr[i] = new_shape[i];
    }
    return this->convertToQuantumSparse(new_shape_arr);
}

diaQMatrix *denseMatrix::convertToQuantumSparse(long int *new_shape) {
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
    // #pragma omp parallel for
    // for(long int i = -1 * qm->matrix_shape[0]; i < qm->matrix_shape[1]; i++) {
    //     qm->createDiagonal(i);
    // }
    // #pragma omp barrier

    #pragma omp parallel for
    for(long int i = 0; i < matrix_shape[0]; i++) {
        for(long int j = 0; j < matrix_shape[1]; j++) {
            // std::cout << "In thread: " << omp_get_thread_num() << std::endl;
            long int *pos = new long int[2];
            pos[0] = i;
            pos[1] = j;
            long int *d_pos = qm->getDiagonalPosition(pos);
            long int d_len = qm->getDiagonalLength(d_pos[0]);
            // std::cout << "(" << i << "," << j << ")" << " " << d_pos[0] << " at pos " << d_pos[1] << std::endl;
            if(realData[i * new_shape[1] + j] != 0.0 || imagData[i * new_shape[1] + j] != 0.0) {
                // printf("realData[%ld] = %f, imagData[%ld] = %f\n", i * new_shape[1] + j, realData[i * new_shape[1] + j], i * new_shape[1] + j, imagData[i * new_shape[1] + j]);
                #pragma omp critical
                {
                    qm->setDiagonalElement(d_pos[0], d_pos[1], d_len, realData[i * new_shape[1] + j], imagData[i * new_shape[1] + j]);
                }
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

std::complex<valType> *to_numpy(diaQMatrix *A) {
    // // This is bad, but I don't have a better way to do this right now.
    // denseMatrix *d = A->convertToDenseMatrix(A->matrix_shape);
    // // comment below line for tests.cpp
    // // A->free();
    // return d->getData_forPy();

    // directly from diaQMatrix object, let's create a std::complex<valType> array
    // TODO: This still needs a reshape to the original shape of the tensor. Can we avoid that too? I have to look at pybind11 stuff!!
    long int *matrix_shape = A->matrix_shape;
    long int total_elements = matrix_shape[0] * matrix_shape[1];
    std::complex<valType> *vals = (std::complex<valType> *)malloc(total_elements * sizeof(std::complex<valType>));
    std::fill(vals, vals + total_elements, std::complex<valType>(0.0, 0.0));

    #pragma omp parallel
    {
        #pragma omp single
        for (auto it = A->diagonalMap.begin(); it != A->diagonalMap.end(); it++) {
            #pragma omp task
            {
                long int dIndex = it->first;
                long int dLength = it->second->dLength;
                valType *real_vals = it->second->getRealValues();
                valType *imag_vals = it->second->getImagValues();

                #pragma omp parallel for
                for (long int i = 0; i < dLength; i++) {
                    long int *mat_pos = A->getMatrixPosition(dIndex, i);
                    long int flat_index = mat_pos[0] * matrix_shape[1] + mat_pos[1];
                    vals[flat_index] = std::complex<valType>(real_vals[i], imag_vals[i]);
                }
            }
        }
        #pragma omp taskwait
    }

    return vals;
}

diaQMatrix *from_numpy(std::complex<valType> *vals, std::vector<long int> shape) {
    #ifdef CUDA_ENABLED
        return from_numpy_cuda(vals, shape);
    #else
        long int vals_len = 1;
        for (long int val : shape) {
            vals_len *= val;
        }

        long int rank = shape.size();
        if (rank > 2) { // higher-order tensor!
            long int product = vals_len;
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
            long int *new_shape = new long int[2];
            new_shape[0] = y;
            new_shape[1] = x;

            #if NUM_BYTES_ALIGNED == -1
                valType *real_vals = (valType *)calloc(vals_len, sizeof(valType));
                valType *imag_vals = (valType *)calloc(vals_len, sizeof(valType));
            #else
                valType *real_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, vals_len * sizeof(valType));
                valType *imag_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, vals_len * sizeof(valType));
            #endif
            #pragma omp parallel for
            for(long int i = 0; i < vals_len; i++) {
                real_vals[i] = vals[i].real();
                imag_vals[i] = vals[i].imag();
            }

            denseMatrix *d = new denseMatrix(&new_shape, real_vals, imag_vals, shape);
            return d->convertToQuantumSparse(new_shape);

        }  else { // matrix!

            long int *mat_shape = new long int[2];
            mat_shape[0] = shape[0];
            mat_shape[1] = shape[1];

            diaQMatrix *qm = new diaQMatrix(&mat_shape);

            #pragma omp parallel for
            for(long int flatIndex = 0; flatIndex < vals_len; flatIndex++) {
                valType r = vals[flatIndex].real();
                valType i = vals[flatIndex].imag();
                if (r != 0.0 || i != 0.0) {
                    long int *d_pos = qm->getDiagonalPositionByFlatIndex(flatIndex);
                    long int d_len = qm->getDiagonalLength(d_pos[0]);
                    #pragma omp critical
                    {
                        qm->setDiagonalElement(d_pos[0], d_pos[1], d_len, r, i);
                    }
                }
            }
            return qm;
        }
    #endif
}

vector *from_numpy_vector(std::complex<valType> *vals, size_t M) {
    valType *real_vals = (valType *)malloc(M * sizeof(valType));
    valType *imag_vals = (valType *)malloc(M * sizeof(valType));
    
    #pragma omp parallel for
    for(long int i = 0; i < M; i++) {
        real_vals[i] = vals[i].real();
        imag_vals[i] = vals[i].imag();
    }

    vector *v = new vector(M, real_vals, imag_vals);
    return v;
}

std::complex<valType> *to_numpy_vector(vector *v) {
    size_t M = v->numRows_;
    std::complex<valType> *vals = (std::complex<valType> *)malloc(M * sizeof(std::complex<valType>));
    valType *real_vals = v->getRealValues();
    valType *imag_vals = v->getImagValues();
    #pragma omp parallel for
    for(long int i = 0; i < M; i++) {
        vals[i] = std::complex<valType>(real_vals[i], imag_vals[i]);
    }
    return vals;
}

} // namespace diaq