#include "conversions.hpp"

#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<denseMatrix> diaQMatrix::convertToDenseMatrix() {
    return this->convertToDenseMatrix(this->matrix_shape);
}

std::shared_ptr<denseMatrix> diaQMatrix::convertToDenseMatrix(std::array<unsigned int, 2> new_shape) {
    unsigned int nRows = new_shape[0];
    unsigned int nCols = new_shape[1];
    valType *real_data;
    valType *imag_data;
    #if NUM_BYTES_ALIGNED <= 0
        real_data = (valType *)calloc(nRows * nCols, sizeof(valType));
        imag_data = (valType *)calloc(nRows * nCols, sizeof(valType));
    #else
        real_data = aligned_alloc_helper(nRows * nCols * sizeof(valType));
        imag_data = aligned_alloc_helper(nRows * nCols * sizeof(valType));
    #endif

    // Fill dense matrix from diagonals
    for (size_t k = 0; k < dIndices.size(); k++) {
        int dIndex = dIndices[k];
        unsigned int len = diaq::getDiagonalLength(dIndex, new_shape);
        unsigned int offset = diagOffsets[k];
        for (unsigned int j = 0; j < len; j++) {
            std::array<unsigned int, 2> mat_pos = getMatrixPosition(dIndex, j);
            unsigned int fi = mat_pos[0] * nCols + mat_pos[1];
            real_data[fi] = realData[offset + j];
            imag_data[fi] = imagData[offset + j];
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
    return convertToDiaQ_cuda(shared_from_this(), new_shape);
#else
    // Collect all possible diagonal indices for the matrix
    std::vector<int> diag_indices;
    int min_diag = -static_cast<int>(new_shape[0]) + 1;
    int max_diag = static_cast<int>(new_shape[1]) - 1;
    // Fastest: sequential diagonal order
    std::vector<int> diag_order;
    for (int d = min_diag; d <= max_diag; ++d) {
        diag_order.push_back(d);
    }
    std::vector<int> nonzero_diags;
    std::vector<std::vector<valType>> real_diags;
    std::vector<std::vector<valType>> imag_diags;
    #pragma omp parallel for schedule(static)
    for (size_t idx = 0; idx < diag_order.size(); ++idx) {
        int d = diag_order[idx];
        unsigned int len = diaq::getDiagonalLength(d, new_shape);
        std::vector<valType> real_diag(len, 0.0);
        std::vector<valType> imag_diag(len, 0.0);
        bool all_zero = true;
        for (unsigned int j = 0; j < len; ++j) {
            std::array<unsigned int, 2> mat_pos = diaQMatrix(new_shape, std::vector<int>{d}).getMatrixPosition(d, j);
            unsigned int fi = mat_pos[0] * new_shape[1] + mat_pos[1];
            real_diag[j] = realData[fi];
            imag_diag[j] = imagData[fi];
            if (real_diag[j] != 0.0 || imag_diag[j] != 0.0) {
                all_zero = false;
            }
        }
        #pragma omp critical
        {
            if (!all_zero) {
                nonzero_diags.push_back(d);
                real_diags.push_back(real_diag);
                imag_diags.push_back(imag_diag);
            }
        }
    }
    std::shared_ptr<diaQMatrix> qm = std::make_shared<diaQMatrix>(new_shape, nonzero_diags, shape);

    // Fill only nonzero diagonals (parallelized)
    #pragma omp parallel for schedule(static)
    for (size_t idx = 0; idx < nonzero_diags.size(); ++idx) {
        int d = nonzero_diags[idx];
        unsigned int len = qm->getDiagonalLength(d);
        int slot = qm->findDiagonalSlot(d);
        if (slot < 0) continue;
        unsigned int offset = qm->diagOffsets[slot];
        for (unsigned int j = 0; j < len; ++j) {
            qm->realData[offset + j] = real_diags[idx][j];
            qm->imagData[offset + j] = imag_diags[idx][j];
        }
    }
    qm->shape = shape;
    return qm;
#endif
}

std::vector<std::complex<valType>> to_numpy(std::shared_ptr<diaQMatrix> A) {

    #ifdef DEBUG
        std::cout << "starting to_numpy -- ";
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    std::array<unsigned int, 2> matrix_shape = A->matrix_shape;
    unsigned long int total_elements = matrix_shape[0] * matrix_shape[1];
    std::vector<std::complex<valType>> vals(total_elements, std::complex<valType>(0.0, 0.0));

    #pragma omp parallel for
    for(size_t k = 0; k < A->dIndices.size(); ++k) {
        int dIndex = A->dIndices[k];
        unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
        valType* real_vals = A->realData + A->diagOffsets[k];
        valType* imag_vals = A->imagData + A->diagOffsets[k];
        for (unsigned int j = 0; j < dLength; ++j) {
            std::array<unsigned int, 2> mat_pos = A->getMatrixPosition(dIndex, j);
            unsigned int flat_index = mat_pos[0] * matrix_shape[1] + mat_pos[1];
            vals[flat_index] = std::complex<valType>(real_vals[j], imag_vals[j]);
        }
    }

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
        printf("\t\t to_numpy took %f milliseconds\n", duration / 1000.0);
    #endif

    return vals;
}

std::shared_ptr<diaQMatrix> from_numpy(std::complex<valType> *vals, std::vector<unsigned int> shape) {
#ifdef CUDA_ENABLED
    return from_numpy_cuda(vals, shape);
#else
#ifdef DEBUG
    printf(" starting from_numpy -- ");
    std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
#endif
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
        #if NUM_BYTES_ALIGNED <= 0
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
        // Collect only nonzero diagonals
        int min_diag = -static_cast<int>(shape[0]) + 1;
        int max_diag = static_cast<int>(shape[1]) - 1;
        // Fastest: sequential diagonal order
        std::vector<int> diag_order;
        for (int d = min_diag; d <= max_diag; ++d) {
            diag_order.push_back(d);
        }
        std::vector<int> nonzero_diags;
        std::vector<std::vector<valType>> real_diags;
        std::vector<std::vector<valType>> imag_diags;
        #pragma omp parallel for schedule(static)
        for (size_t idx = 0; idx < diag_order.size(); ++idx) {
            int d = diag_order[idx];
            unsigned int len = diaq::getDiagonalLength(d, std::array<unsigned int,2>{shape[0], shape[1]});
            std::vector<valType> real_diag(len, 0.0);
            std::vector<valType> imag_diag(len, 0.0);
            bool all_zero = true;
            for (unsigned int j = 0; j < len; ++j) {
                std::array<unsigned int, 2> mat_pos = diaQMatrix(std::array<unsigned int,2>{shape[0], shape[1]}, std::vector<int>{d}).getMatrixPosition(d, j);
                unsigned int fi = mat_pos[0] * shape[1] + mat_pos[1];
                real_diag[j] = vals[fi].real();
                imag_diag[j] = vals[fi].imag();
                if (real_diag[j] != 0.0 || imag_diag[j] != 0.0) {
                    all_zero = false;
                }
            }
            #pragma omp critical
            {
                if (!all_zero) {
                    nonzero_diags.push_back(d);
                    real_diags.push_back(real_diag);
                    imag_diags.push_back(imag_diag);
                }
            }
        }
        std::shared_ptr<diaQMatrix> qm = std::make_shared<diaQMatrix>(std::array<unsigned int,2>{shape[0], shape[1]}, nonzero_diags, shape);
        // Fill only nonzero diagonals (parallelized)
        #pragma omp parallel for schedule(static)
        for (size_t idx = 0; idx < nonzero_diags.size(); ++idx) {
            int d = nonzero_diags[idx];
            unsigned int len = qm->getDiagonalLength(d);
            int slot = qm->findDiagonalSlot(d);
            if (slot < 0) continue;
            unsigned int offset = qm->diagOffsets[slot];
            for (unsigned int j = 0; j < len; ++j) {
                qm->realData[offset + j] = real_diags[idx][j];
                qm->imagData[offset + j] = imag_diags[idx][j];
            }
        }

#ifdef DEEP_DEBUG
        std::cout << "from_numpy result below: " << std::endl;
        qm->print();
#endif

#ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
        printf("\t\t from_numpy took %f milliseconds\n", duration / 1000.0);
#endif

        return qm;
    }
#endif
}

std::shared_ptr<vector> from_numpy_vector(std::complex<valType> *vals, unsigned int M) {
    #if NUM_BYTES_ALIGNED <= 0
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