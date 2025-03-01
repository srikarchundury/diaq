#include "conversions.hpp"

#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<denseMatrix> diaQMatrix::convertToDenseMatrix() {
    return this->convertToDenseMatrix(this->matrix_shape);
}

std::shared_ptr<denseMatrix> diaQMatrix::convertToDenseMatrix(unsigned long int *new_shape) {
    #if NUM_BYTES_ALIGNED == -1
        valType *real_data = (valType *)calloc(matrix_shape[0] * matrix_shape[1], sizeof(valType));
        valType *imag_data = (valType *)calloc(matrix_shape[0] * matrix_shape[1], sizeof(valType));
    #else
        valType *real_data = aligned_alloc_helper(matrix_shape[0] * matrix_shape[1] * sizeof(valType));
        valType *imag_data = aligned_alloc_helper(matrix_shape[0] * matrix_shape[1] * sizeof(valType));
    #endif
    std::unordered_map<long int, std::shared_ptr<diagonal> >::iterator it;
    unsigned long int x, y;
    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        valType *real_vals = it->second->realValues;
        valType *imag_vals = it->second->imagValues;
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
        for (unsigned long int i = 0; i < it->second->dLength; i++) {
            // std::cout << "(" << real_vals[i] << "," << imag_vals[i] << ")" << std::endl;
            real_data[ matrix_shape[1] * (x+i) + (y+i) ] = real_vals[i];
            imag_data[ matrix_shape[1] * (x+i) + (y+i) ] = imag_vals[i];
        }
    }
    std::shared_ptr<denseMatrix> d = std::make_shared<denseMatrix>(&new_shape, real_data, imag_data);
    d->shape = shape;
    return d;
}

std::shared_ptr<diaQMatrix> denseMatrix::convertToQuantumSparse() {
    return this->convertToQuantumSparse(this->shape);
}

std::shared_ptr<diaQMatrix> denseMatrix::convertToQuantumSparse(std::vector<unsigned long int> new_shape) {
    unsigned long int *new_shape_arr = new unsigned long int[new_shape.size()];
    for (unsigned long int i = 0; i < new_shape.size(); i++) {
        new_shape_arr[i] = new_shape[i];
    }
    return this->convertToQuantumSparse(new_shape_arr);
}

std::shared_ptr<diaQMatrix> denseMatrix::convertToQuantumSparse(unsigned long int *new_shape) {
    #ifdef CUDA_ENABLED
        return convertToQuantumSparse_cuda(this, new_shape);
    #else
    // counting the number of diagonals in a matrix that isn't a perfect square.
    // long int s = 0;
    // for(long int i = 0; i < new_shape.size(); i++) {
    //     s = s + new_shape[i];
    // }
    // std::cout << "converting dense to sparse" << std::endl;
    std::shared_ptr<diaQMatrix> qm = std::make_shared<diaQMatrix>(&new_shape);
    // printf("printing empty matrix");
    // qm->print();
    // #pragma omp parallel for
    // for(long int i = -1 * qm->matrix_shape[0]; i < qm->matrix_shape[1]; i++) {
    //     qm->createDiagonal(i);
    // }
    // #pragma omp barrier

    #pragma omp parallel for
    for(unsigned long int i = 0; i < matrix_shape[0]; i++) {
        for(unsigned long int j = 0; j < matrix_shape[1]; j++) {
            // std::cout << "In thread: " << omp_get_thread_num() << std::endl;
            std::shared_ptr<unsigned long int[]> pos = std::shared_ptr<unsigned long int[]>(new unsigned long int[2]);
            pos[0] = i;
            pos[1] = j;
            std::shared_ptr<long int[]> d_pos = qm->getDiagonalPosition(pos);
            unsigned long int d_len = qm->getDiagonalLength(d_pos[0]);
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

std::complex<valType> *to_numpy(std::shared_ptr<diaQMatrix> A) {
    // // This is bad, but I don't have a better way to do this right now.
    // std::shared_ptr<denseMatrix> d = A->convertToDenseMatrix(A->matrix_shape);
    // // comment below line for tests.cpp
    // // A->free();
    // return d->getData_forPy();

    // directly from diaQMatrix object, let's create a std::complex<valType> array
    // TODO: This still needs a reshape to the original shape of the tensor. Can we avoid that too? I have to look at pybind11 stuff!!
    unsigned long int *matrix_shape = A->matrix_shape;
    unsigned long int total_elements = matrix_shape[0] * matrix_shape[1];
    std::complex<valType> *vals = (std::complex<valType> *)malloc(total_elements * sizeof(std::complex<valType>));
    std::fill(vals, vals + total_elements, std::complex<valType>(0.0, 0.0));

    #pragma omp parallel for
    for (unsigned long int i = 0; i < A->diagonalMap.size(); i++) {
        auto it = std::next(A->diagonalMap.begin(), i);
        long int dIndex = it->first;
        unsigned long int dLength = it->second->dLength;
        valType *real_vals = it->second->realValues;
        valType *imag_vals = it->second->imagValues;

        #pragma omp parallel for
        for (unsigned long int i = 0; i < dLength; i++) {
            std::shared_ptr<unsigned long int[]> mat_pos = A->getMatrixPosition(dIndex, i);
            unsigned long int flat_index = mat_pos[0] * matrix_shape[1] + mat_pos[1];
            vals[flat_index] = std::complex<valType>(real_vals[i], imag_vals[i]);
        }
    }
    return vals;
}

std::shared_ptr<diaQMatrix> from_numpy(std::complex<valType> *vals, std::vector<unsigned long int> shape) {
    #ifdef CUDA_ENABLED
        return from_numpy_cuda(vals, shape);
    #else
        unsigned long int vals_len = 1;
        for (unsigned long int val : shape) {
            vals_len *= val;
        }

        unsigned long int rank = shape.size();

        #ifdef DEEP_DEBUG
            std::cout << "Rank: " << rank << std::endl;
            std::cout << "Shape: ";
            for (unsigned long int i = 0; i < rank; i++) {
                std::cout << shape[i] << " ";
            }
            std::cout << std::endl;
            std::cout << "Vals: ";
            for (unsigned long int i = 0; i < vals_len; i++) {
                std::cout << vals[i] << " ";
            }
            std::cout << std::endl;
        #endif

        if (rank > 2) { // higher-order tensor!
            #if NUM_BYTES_ALIGNED == -1
                valType *real_vals = (valType *)calloc(vals_len, sizeof(valType));
                valType *imag_vals = (valType *)calloc(vals_len, sizeof(valType));
            #else
                valType *real_vals = aligned_alloc_helper(vals_len * sizeof(valType));
                valType *imag_vals = aligned_alloc_helper(vals_len * sizeof(valType));
            #endif

            #pragma omp parallel for
            for(unsigned long int i = 0; i < vals_len; i++) {
                real_vals[i] = vals[i].real();
                imag_vals[i] = vals[i].imag();
            }
            unsigned long int product = vals_len;
            unsigned long int sqrtProduct = static_cast<unsigned long int>(std::sqrt(product));
            // Find the closest factors of the product
            unsigned long int x = 1;
            unsigned long int y = product;
            for (unsigned long int i = sqrtProduct; i > 0; --i) {
                if (product % i == 0) {
                    x = i;
                    y = product / i;
                    break;
                }
            }
            unsigned long int *new_shape = new unsigned long int[2];
            new_shape[0] = y;
            new_shape[1] = x;

            std::shared_ptr<denseMatrix> d = std::make_shared<denseMatrix>(&new_shape, real_vals, imag_vals, shape);
            return d->convertToQuantumSparse(new_shape);

        }  else { // matrix!

            unsigned long int *mat_shape = new unsigned long int[2];
            mat_shape[0] = shape[0];
            mat_shape[1] = shape[1];

            std::shared_ptr<diaQMatrix> qm = std::make_shared<diaQMatrix>(&mat_shape);

            #pragma omp parallel
            {
                std::vector<std::tuple<long int, unsigned long int, valType, valType>> local_updates;

                #pragma omp for nowait
                for (unsigned long int flatIndex = 0; flatIndex < vals_len; flatIndex++) {
                    valType r = vals[flatIndex].real();
                    valType i = vals[flatIndex].imag();
                    if (r != 0.0 || i != 0.0) {
                        std::shared_ptr<long int[]> d_pos = qm->getDiagonalPositionByFlatIndex(flatIndex);
                        local_updates.emplace_back(d_pos[0], d_pos[1], r, i);
                    }
                }

                // Merge results into the matrix in parallel
                #pragma omp critical
                {
                    for (const auto& update : local_updates) {
                        qm->setDiagonalElement(std::get<0>(update), std::get<1>(update), qm->getDiagonalLength(std::get<0>(update)), std::get<2>(update), std::get<3>(update));
                    }
                }
            }
            #ifdef DEEP_DEBUG
                std::cout << "from_numpy: " << std::endl;
                qm->print();
            #endif
            return qm;
        }
    #endif
}

std::shared_ptr<vector> from_numpy_vector(std::complex<valType> *vals, size_t M) {
    valType *real_vals = (valType *)malloc(M * sizeof(valType));
    valType *imag_vals = (valType *)malloc(M * sizeof(valType));
    
    #pragma omp parallel for
    for(unsigned long int i = 0; i < M; i++) {
        real_vals[i] = vals[i].real();
        imag_vals[i] = vals[i].imag();
    }

    std::shared_ptr<vector> v = std::make_shared<vector>(M, real_vals, imag_vals);
    return v;
}

std::complex<valType> *to_numpy_vector(std::shared_ptr<vector> v) {
    size_t M = v->numRows;
    std::complex<valType> *vals = (std::complex<valType> *)malloc(M * sizeof(std::complex<valType>));
    valType *real_vals = v->realValues;
    valType *imag_vals = v->imagValues;
    #pragma omp parallel for
    for(unsigned long int i = 0; i < M; i++) {
        vals[i] = std::complex<valType>(real_vals[i], imag_vals[i]);
    }
    return vals;
}

} // namespace diaq