#include "conversions.hpp"

#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<denseMatrix> diaQMatrix::convertToDenseMatrix() {
    return this->convertToDenseMatrix(this->matrix_shape);
}

std::shared_ptr<denseMatrix> diaQMatrix::convertToDenseMatrix(std::array<unsigned int, 2> new_shape) {
    #if NUM_BYTES_ALIGNED == -1
        valType *real_data = (valType *)calloc(matrix_shape[0] * matrix_shape[1], sizeof(valType));
        valType *imag_data = (valType *)calloc(matrix_shape[0] * matrix_shape[1], sizeof(valType));
    #else
        valType *real_data = aligned_alloc_helper(matrix_shape[0] * matrix_shape[1] * sizeof(valType));
        valType *imag_data = aligned_alloc_helper(matrix_shape[0] * matrix_shape[1] * sizeof(valType));
    #endif

    unsigned int x, y;

    for(size_t i = 0; i < dIndices.size(); i++) {

        std::shared_ptr<diagonal> d = dPointers[i];

        valType *real_vals = d->realValues;
        valType *imag_vals = d->imagValues;
        if (d->dIndex == 0) {
            x = 0;
            y = 0;
        }
        else if (d->dIndex > 0) {
            x = 0;
            y = d->dIndex;
        }
        else {
            x = -1 * d->dIndex;
            y = 0;
        }
        #pragma omp parallel for
        for (unsigned int i = 0; i < d->dLength; i++) {
            // std::cout << "(" << real_vals[i] << "," << imag_vals[i] << ")" << std::endl;
            real_data[ matrix_shape[1] * (x+i) + (y+i) ] = real_vals[i];
            imag_data[ matrix_shape[1] * (x+i) + (y+i) ] = imag_vals[i];
        }
    }
    std::shared_ptr<denseMatrix> d = std::make_shared<denseMatrix>(new_shape, real_data, imag_data);
    d->shape = shape;
    return d;
}

std::shared_ptr<diaQMatrix> denseMatrix::convertToDiaQ() {
    return this->convertToDiaQ(this->shape);
}

std::shared_ptr<diaQMatrix> denseMatrix::convertToDiaQ(std::vector<unsigned int> new_shape) {
    return this->convertToDiaQ(std::array<unsigned int, 2>{new_shape[0], new_shape[1]});
}

std::shared_ptr<diaQMatrix> denseMatrix::convertToDiaQ(std::array<unsigned int, 2> new_shape) {
    #ifdef CUDA_ENABLED
        return convertToDiaQ_cuda(this, new_shape);
    #else
    // counting the number of diagonals in a matrix that isn't a perfect square.
    // int s = 0;
    // for(int i = 0; i < new_shape.size(); i++) {
    //     s = s + new_shape[i];
    // }
    // std::cout << "converting dense to sparse" << std::endl;
    std::shared_ptr<diaQMatrix> qm = std::make_shared<diaQMatrix>(new_shape);
    // printf("printing empty matrix");
    // qm->print();
    // #pragma omp parallel for
    // for(int i = -1 * qm->matrix_shape[0]; i < qm->matrix_shape[1]; i++) {
    //     qm->createDiagonal(i);
    // }
    // #pragma omp barrier

    #pragma omp parallel for
    for(unsigned int i = 0; i < matrix_shape[0]; i++) {
        for(unsigned int j = 0; j < matrix_shape[1]; j++) {
            // std::cout << "In thread: " << omp_get_thread_num() << std::endl;
            std::array<unsigned int, 2> pos;
            pos[0] = i;
            pos[1] = j;
            std::array<int, 2> d_pos = qm->getDiagonalPosition(pos);
            unsigned int d_len = qm->getDiagonalLength(d_pos[0]);
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

    // assigning dIndices and dPointers
    qm->dIndices.resize(qm->diagonalMap.size());
    qm->dPointers.resize(qm->diagonalMap.size());
    #pragma omp parallel for
    for (size_t a = 0; a < qm->diagonalMap.size(); a++) {
        auto it = std::next(qm->diagonalMap.begin(), a);
        int dIndex = it->first;
        std::shared_ptr<diagonal> d = it->second;
        qm->dIndices[a] = dIndex;
        qm->dPointers[a] = d;
    }

    // qm->pruneMatrix();
    qm->shape = shape;
    // comment below line for tests.cpp
    // this->free();
    return qm;
    #endif
}

std::vector<std::complex<valType>> to_numpy(std::shared_ptr<diaQMatrix> A) {

    #ifdef DEBUG
        std::cout << "starting to_numpy -- ";
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    std::array<unsigned int, 2> matrix_shape = A->matrix_shape;
    unsigned long int total_elements = matrix_shape[0] * matrix_shape[1];
    std::vector<std::complex<valType>> vals(total_elements, std::complex<valType>(0.0, 0.0));

    #pragma omp parallel for
    for(size_t i = 0; i < A->dIndices.size(); i++) {

        std::shared_ptr<diagonal> d = A->dPointers[i];

        int dIndex = d->dIndex;
        unsigned int dLength = d->dLength;

        valType *real_vals = d->realValues;
        valType *imag_vals = d->imagValues;

        #pragma omp parallel for
        for (unsigned int j = 0; j < dLength; j++) {
            std::array<unsigned int, 2> mat_pos = A->getMatrixPosition(dIndex, j);
            unsigned int flat_index = mat_pos[0] * matrix_shape[1] + mat_pos[1];
            vals[flat_index] = std::complex<valType>(real_vals[j], imag_vals[j]);
        }
    }

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t to_numpy took %f milliseconds\n", duration.count() / 1000.0);
    #endif

    return vals;
}

std::shared_ptr<diaQMatrix> from_numpy(std::complex<valType> *vals, std::vector<unsigned int> shape) {

    #ifdef DEBUG
        printf(" starting from_numpy -- ");
        auto start = std::chrono::high_resolution_clock::now();
    #endif


    #ifdef CUDA_ENABLED
        return from_numpy_cuda(vals, shape);
    #else
        long unsigned int vals_len = 1;
        for (unsigned int val : shape) {
            vals_len *= val;
        }

        unsigned int rank = shape.size();

        #ifdef DEEP_DEBUG
            std::cout << "Rank: " << rank << std::endl;
            std::cout << "Shape: ";
            for (unsigned int i = 0; i < rank; i++) {
                std::cout << shape[i] << " ";
            }
            std::cout << std::endl;
            std::cout << "Vals (atlaeat one?): ";
            for (unsigned int i = 0; i < vals_len/1000 + 1 ; i++) {
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
            for(unsigned int i = 0; i < vals_len; i++) {
                real_vals[i] = vals[i].real();
                imag_vals[i] = vals[i].imag();
            }
            unsigned int product = vals_len;
            unsigned int sqrtProduct = static_cast<unsigned int>(std::sqrt(product));
            // Find the closest factors of the product
            unsigned int x = 1;
            unsigned int y = product;
            for (unsigned int i = sqrtProduct; i > 0; --i) {
                if (product % i == 0) {
                    x = i;
                    y = product / i;
                    break;
                }
            }
            std::array<unsigned int, 2> new_shape = {x, y};

            std::shared_ptr<denseMatrix> d = std::make_shared<denseMatrix>(new_shape, real_vals, imag_vals, shape);
            return d->convertToDiaQ(new_shape);

        }  else { // matrix!

            std::shared_ptr<diaQMatrix> qm = std::make_shared<diaQMatrix>(shape[0], shape[1]);

            #pragma omp parallel
            {
                std::vector<std::tuple<int, unsigned int, valType, valType>> local_updates;

                #pragma omp for nowait
                for (long unsigned int flatIndex = 0; flatIndex < vals_len; flatIndex++) {
                    valType r = vals[flatIndex].real();
                    valType i = vals[flatIndex].imag();
                    if (r != 0.0 || i != 0.0) {
                        std::array<int, 2> d_pos = qm->getDiagonalPositionByFlatIndex(flatIndex);
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

            // printf(" -- before assigning dindices and dpointers -- \n");
            qm->dIndices.resize(qm->diagonalMap.size());
            qm->dPointers.resize(qm->diagonalMap.size());

            #pragma omp parallel for
            for (size_t a = 0; a < qm->diagonalMap.size(); a++) {
                auto it = std::next(qm->diagonalMap.begin(), a);
                int dIndex = it->first;
                std::shared_ptr<diagonal> d = it->second;
                qm->dIndices[a] = dIndex;
                // printf("\t qm->dIndices[%ld] = %d\n", a, dIndex);
                qm->dPointers[a] = d;
            }

            // printf(" -- after assigning dindices and dpointers -- \n");

            #ifdef DEEP_DEBUG
                std::cout << "from_numpy result below: " << std::endl;
                qm->print();
            #endif

            #ifdef DEBUG
                auto end = std::chrono::high_resolution_clock::now();
                auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
                printf("\t\t from_numpy took %f milliseconds\n", duration.count() / 1000.0);
            #endif

            return qm;
        }
    #endif
}

std::shared_ptr<vector> from_numpy_vector(std::complex<valType> *vals, unsigned int M) {
    #if NUM_BYTES_ALIGNED == -1
        valType *real_vals = (valType *)calloc(M, sizeof(valType));
        valType *imag_vals = (valType *)calloc(M, sizeof(valType));
    #else
        valType *real_vals = aligned_alloc_helper(M * sizeof(valType));
        valType *imag_vals = aligned_alloc_helper(M * sizeof(valType));
    #endif

    #pragma omp parallel for
    for(unsigned int i = 0; i < M; i++) {
        real_vals[i] = vals[i].real();
        imag_vals[i] = vals[i].imag();
    }

    std::shared_ptr<vector> v = std::make_shared<vector>(M, real_vals, imag_vals);
    return v;
}

std::vector<std::complex<valType>> to_numpy_vector(std::shared_ptr<vector> v) {
    unsigned int M = v->numRows;
    std::vector<std::complex<valType>> vals(M);
    valType *real_vals = v->realValues;
    valType *imag_vals = v->imagValues;
    #pragma omp parallel for
    for(unsigned int i = 0; i < M; i++) {
        vals[i] = std::complex<valType>(real_vals[i], imag_vals[i]);
    }
    return vals;
}

} // namespace diaq