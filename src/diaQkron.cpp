#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<diaQMatrix> kron_product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {

    #ifdef DEEP_DEBUG
        printf("\tdiaq::kron_product\n");
        printf("\tA Meta:\n");
        A->print_meta();
        printf("\tB Matrix:\n");
        B->print_meta();
    #endif

    #ifdef DEBUG
        // measure start timer
        printf("starting kron_product --");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    std::array<unsigned int, 2> shape_a = A->matrix_shape;
    std::array<unsigned int, 2> shape_b = B->matrix_shape;

    // map of unique A elements and their corresponding kron blocks
    std::map<std::pair<valType, valType>, std::shared_ptr<diaQMatrix> > unique_kron_blocks;

    // Calculate dimensions for the resulting matrix
    std::array<unsigned int, 2> result_shape;
    result_shape[0] = shape_a[0] * shape_b[0];
    result_shape[1] = shape_a[1] * shape_b[1];
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itA;

    #pragma omp parallel for
    for (unsigned int a = 0; a < A->diagonalMap.size(); a++) {
        auto itA = std::next(A->diagonalMap.begin(), a);
        int diagonal_index = itA->first;
        std::shared_ptr<diagonal> diag = itA->second;
        unsigned int diagonal_length = diag->dLength;

        #pragma omp parallel for
        for(unsigned int diagonal_position = 0; diagonal_position < diagonal_length; diagonal_position++) {
            // skippihg zero elements
            if(diag->realValues[diagonal_position] == 0.0 && diag->imagValues[diagonal_position] == 0.0) {
                continue;
            }
            std::shared_ptr<diaQMatrix> kron_block;
            // dynamic programming for unique kron blocks
            #pragma omp critical
            {
                if(unique_kron_blocks.find(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position])) == unique_kron_blocks.end()) {
                    kron_block = multiply_by_scalar(B, diag->realValues[diagonal_position], diag->imagValues[diagonal_position]);
                    unique_kron_blocks.insert(std::pair<std::pair<valType, valType>, std::shared_ptr<diaQMatrix> >(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]), kron_block));
                } else {
                    kron_block = unique_kron_blocks.find(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]))->second;
                }
            }

            std::array<unsigned int, 2> A_pos = A->getMatrixPosition(diagonal_index, diagonal_position);
            phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itK;

            #pragma omp parallel for
            for (unsigned int b = 0; b < kron_block->diagonalMap.size(); b++) {
                auto itK = std::next(kron_block->diagonalMap.begin(), b);
                int kron_block_diag_index = itK->first;
                std::shared_ptr<diagonal> kron_block_diag = itK->second;
                unsigned int kron_block_diag_length = kron_block_diag->dLength;

                #pragma omp parallel for
                for(unsigned int kron_block_diag_position = 0; kron_block_diag_position < kron_block_diag_length; kron_block_diag_position++) {

                    std::array<unsigned int, 2> B_mat_pos = kron_block->getMatrixPosition(kron_block_diag_index, kron_block_diag_position);
                    // int res_mat_pos[2] = {A_pos[0] * shape_b[0] + B_mat_pos[0], A_pos[1] * shape_b[1] + B_mat_pos[1]};
                    // std::array<unsigned int, 2> res_mat_pos = std::make_shared<int[]>(2){A_pos[0] * shape_b[0] + B_mat_pos[0], A_pos[1] * shape_b[1] + B_mat_pos[1]};
                    std::array<unsigned int, 2> res_mat_pos;
                    res_mat_pos[0] = A_pos[0] * shape_b[0] + B_mat_pos[0];
                    res_mat_pos[1] = A_pos[1] * shape_b[1] + B_mat_pos[1];
                    std::array<int, 2> res_diag_pos = result->getDiagonalPosition(res_mat_pos);

                    #pragma omp critical
                    {
                        result->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], result->getDiagonalLength(res_diag_pos[0]), kron_block_diag->realValues[kron_block_diag_position], kron_block_diag->imagValues[kron_block_diag_position]);
                    }
                }
            }
        }
    }

    // setting dIndices and dPointers
    result->dIndices.resize(result->diagonalMap.size());
    result->dPointers.resize(result->diagonalMap.size());
    #pragma omp parallel for
    for(unsigned int i = 0; i < result->diagonalMap.size(); i++) {
        auto it = std::next(result->diagonalMap.begin(), i);
        result->dIndices[i] = it->first;
        result->dPointers[i] = it->second;
    }

    // // free unique_kron_blocks
    // #pragma omp parallel for
    // for (int a = 0; a < unique_kron_blocks.size(); a++) {
    //     auto it = std::next(unique_kron_blocks.begin(), a);
    //     it->second->free();
    // }
    // we don't need to free unique_kron_blocks, since we are using shared_ptr

    #ifdef DEEP_DEBUG
        printf("\tkron_product Result Meta:\n");
        result->print_meta();
    #endif


    #ifdef DEBUG
        // measure end timer
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t kron_product took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return result;
}

std::shared_ptr<diaQMatrix> identity_kron_matrix(unsigned int n, std::shared_ptr<diaQMatrix> A) {

    #ifdef DEEP_DEBUG
        printf("\tdiaq::identity_kron_matrix\n");
        printf("\tA Meta:\n");
        A->print_meta();
    #endif

    #ifdef DEBUG
        // measure start timer
        printf("starting identity_kron_matrix --");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    unsigned int N = 1L << n;

    // assume a nxn identity matrix, which has one diagonal of length N, in index 0.
    // we just repeat A, N times in the result matrix
    std::array<unsigned int, 2> result_shape = {N * A->matrix_shape[0], N * A->matrix_shape[1]};
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for (unsigned int i = 0; i < diagMap.size(); i++) {
        auto it = std::next(diagMap.begin(), i);
        int dIndex = it->first;
        std::shared_ptr<diagonal> diag = it->second;
        // printf("A's diagonal\n");
        // diag->print();
        unsigned int dLength = diag->dLength;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        // result diag
        unsigned int new_dLength = result->getDiagonalLength(dIndex); // TODO: there should be a better way to get this using n and dLength.
        // std::shared_ptr<diagonal> newDiag = new diagonal(dIndex, new_dLength);
        std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(dIndex, new_dLength);
        valType *newDiag_real_vals = newDiag->realValues;
        valType *newDiag_imag_vals = newDiag->imagValues;

        #pragma omp parallel for
        for(unsigned int rep = 0; rep < N; rep++) {
            unsigned int skip_places = (rep) * (dLength + abs(dIndex));
            #pragma omp parallel for
            for(unsigned int i = 0; i < dLength; i++) {
                newDiag_real_vals[i + skip_places] = real_vals[i];
                newDiag_imag_vals[i + skip_places] = imag_vals[i];
            }
        }
        // #pragma omp critical
        result->setDiagonal(dIndex, newDiag);
    }

    #ifdef DEBUG
        // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix took %f milliseconds\n", duration.count()/1000.0);
    #endif

    // A->free();

    return result;
}

void identity_kron_matrix_times_vector(unsigned int n, std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {

    #ifdef DEBUG
        // start timer
        printf("starting identity_kron_matrix_times_vector --");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    unsigned int N = 1L << n;

    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    // unsigned int y_len = y->numRows; // same as x->numRows;
    unsigned int A_size = A->matrix_shape[0];
    // I kron A has the same number of diagonals as A, but each diagonal has N times more G elements and more 0s that we don't need to care about.
    // So, we can just iterate through the diagonals of A and repeat each diagonal N times in the result vector. But offsets are important and different for each iteration, since each is essentially a block!
    // now for each diagonal in A
    // index in y and x goes from (0, block_idx * diag_length)

    unsigned int last_y_offset = (N-1) * A_size;

    #pragma omp parallel for
    for(unsigned int y_offset = 0; y_offset <= last_y_offset; y_offset += A_size) { // this is like traversing blocks in I kron A

        for (unsigned int di = 0; di < diagMap.size(); di++) {
            auto it = std::next(diagMap.begin(), di);
            // now we can do element wise!
            int dIndex = it->first;
            std::shared_ptr<diagonal> diag = it->second;
            unsigned int dLength = diag->dLength;
            valType *real_vals = diag->realValues;
            valType *imag_vals = diag->imagValues;

            unsigned int x_inner_offset = (dIndex > 0) ? dIndex : 0;
            unsigned int y_inner_offset = (dIndex < 0) ? -dIndex : 0;

            unsigned int x_offset = y_offset + x_inner_offset;
            unsigned int new_y_offset = y_offset + y_inner_offset;

            #pragma omp parallel for
            for (unsigned int y_idx = new_y_offset; y_idx < dLength + new_y_offset; y_idx++) {
                unsigned int x_idx = x_offset + (y_idx - new_y_offset); // adjust x_idx for each iteration
                unsigned int i = y_idx - new_y_offset; // if you want to match your original i loop
                #pragma omp atomic
                y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                #pragma omp atomic
                y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif
}


void identity_kron_matrix_times_vector(unsigned int n, std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger) {

    #ifdef DEBUG
        // start timer
        printf("starting identity_kron_matrix_times_vector --");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    n = 1L << n;

    unsigned int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    std::array<unsigned int, 2> new_gate_shape = {q_diff_exp, q_diff_exp};

    // std::shared_ptr<vector> y = new vector(n * A->matrix_shape[0]);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        std::shared_ptr<diagonal> diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        switch(diag->dIndex) {
            case -3: {
                int dIndex = -1 * q_diff_exp - 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < n; rep++) {
                    unsigned int skip_places = rep * (dLength - dIndex);
                    #if defined(SIMD_ENABLED)
                    #pragma omp simd
                    #endif
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            unsigned int x_idx = i + skip_places;
                            unsigned int y_idx = i + skip_places - dIndex;
                            y_real_values[y_idx] += real_vals[0] * x_real_values[x_idx] - imag_vals[0] * x_imag_values[x_idx];
                            y_imag_values[y_idx] += real_vals[0] * x_imag_values[x_idx] + imag_vals[0] * x_real_values[x_idx];
                        }
                    }
                }
                break;
            }
            case -2: {
                int dIndex = -1 * q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < n; rep++) {
                    unsigned int skip_places = rep * (dLength - dIndex);
                    #if defined(SIMD_ENABLED)
                    #pragma omp simd
                    #endif
                    for(unsigned int i = 0; i < dLength/2; i++) {
                        unsigned int x_idx = i + skip_places;
                        unsigned int y_idx = i + skip_places - dIndex;
                        y_real_values[y_idx] += real_vals[0] * x_real_values[x_idx] - imag_vals[0] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[0] * x_imag_values[x_idx] + imag_vals[0] * x_real_values[x_idx];

                        x_idx = i + skip_places + 1;
                        y_idx = i + skip_places - dIndex + 1;
                        y_real_values[y_idx] += real_vals[1] * x_real_values[x_idx] - imag_vals[1] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[1] * x_imag_values[x_idx] + imag_vals[1] * x_real_values[x_idx];

                    }
                }
                break;
            }
            case -1: {
                // int dIndex = -1;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // // something
                // dIndex = -1 * q_diff_exp + 1;
                // dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 0: {
                // int dIndex = 0;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 1: {
                // int dIndex = 1;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // // do something
                // dIndex = q_diff_exp - 1;
                // dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 2: {
                // int dIndex = q_diff_exp;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 3: {
                // int dIndex = q_diff_exp + 1;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t (non-adjacent) identity_kron_matrix_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void identity_kron_matrix_kron_identity_times_vector(unsigned int before, std::shared_ptr<diaQMatrix> gate, unsigned int after, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
    // logically combine matrix_kron_identity and identity_kron_matrix_times_vector

    #ifdef DEBUG
        // start timer
        printf("starting identity_kron_matrix_kron_identity_times_vector --");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        std::cout << "identity_kron_matrix_kron_identity_times_vector called" << std::endl;
        printf("gate matrix below\n");
        gate->print();
        printf("\t\tbefore = %u; after = %u\n", before, after);
    #endif

    unsigned int before_N = 1L << before;
    unsigned int after_N = 1L << after;

    // unsigned int x_length = x->numRows;
    // if(after * before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(after * before * gate->matrix_shape[0]);
    // y->print();
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;
    // PRINT_WITH_LINE("here\n");

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = gate->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for collapse(2)
    for (unsigned int rep = 0; rep < before_N; rep++) {
        for (unsigned int j = 0; j < after_N; j++) {
            for (unsigned int a = 0; a < diagMap.size(); a++) {
                auto it = std::next(diagMap.begin(), a);
                int dIndex = it->first;
                std::shared_ptr<diagonal> diag = it->second;
                unsigned int dLength = diag->dLength;
                valType *real_vals = diag->realValues;
                valType *imag_vals = diag->imagValues;

                unsigned int skip_places = rep * (after_N * (dLength + (dIndex < 0 ? -dIndex : dIndex)));
                unsigned int x_offset = (dIndex < 0 ? skip_places : after_N * dIndex + skip_places);
                unsigned int y_offset = (dIndex < 0 ? skip_places - after_N * dIndex : skip_places);

                #if defined(SIMD_ENABLED)
                #pragma omp simd
                #endif
                for (unsigned int i = 0; i < dLength; i++) {
                    unsigned int x_idx = x_offset + i * after_N + j;
                    unsigned int y_idx = y_offset + i * after_N + j;
                    y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                    y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                }
            }
        }
    }

    #ifdef DEBUG
        // // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void identity_kron_matrix_kron_identity_times_vector(unsigned int before, std::shared_ptr<diaQMatrix> gate, unsigned int after, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger) {

    #ifdef DEBUG
        // start timer
        printf("starting identity_kron_matrix_kron_identity_times_vector --");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    after = 1L << after;
    before = 1L << before;

    unsigned int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    // int *new_gate_shape = new int[2] {q_diff_exp, q_diff_exp};
    // std::shared_ptr<int> new_gate_shape = std::make_shared<int>(2) {q_diff_exp, q_diff_exp};
    std::array<unsigned int, 2> new_gate_shape = {q_diff_exp, q_diff_exp};

    // unsigned int x_length = x->numRows;
    // if(after * before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(after * before * gate->matrix_shape[0]);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = gate->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for (unsigned int a = 0; a < diagMap.size(); a++) {
        auto it = std::next(diagMap.begin(), a);
        std::shared_ptr<diagonal> diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        switch(diag->dIndex) {
            case -3: {
                int dIndex = -1 * q_diff_exp - 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            case -2: {
                int dIndex = -1 * q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i += 2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[1];
                        imag_val = imag_vals[1];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case -1: {
                int dIndex = -1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength/2; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                    for(unsigned int i = dLength/2; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[2];
                            valType imag_val = imag_vals[2];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                dIndex = -1 * q_diff_exp + 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 != 0) {
                            valType real_val = real_vals[1];
                            valType imag_val = imag_vals[1];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            case 0: {
                int dIndex = 0;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength/2; i+=2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[1];
                        imag_val = imag_vals[1];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                    for(unsigned int i = dLength/2; i < dLength; i+=2) {
                        valType real_val = real_vals[2];
                        valType imag_val = imag_vals[2];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[3];
                        imag_val = imag_vals[3];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 1: {
                int dIndex = 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength/2; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        // printf("y_real_values[%ld] = %f\n", y_idx, y_real_values[y_idx]);
                                        // printf("y_imag_values[%ld] = %f\n", y_idx, y_imag_values[y_idx]);
                                        // printf("x_real_values[%ld] = %f\n", x_idx, x_real_values[x_idx]);
                                        // printf("x_imag_values[%ld] = %f\n", x_idx, x_imag_values[x_idx]);
                                        // printf("real_val = %f\n", real_val);
                                        // printf("imag_val = %f\n", imag_val);
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                    for(unsigned int i = dLength/2; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[2];
                            valType imag_val = imag_vals[2];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                dIndex = q_diff_exp - 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 != 0) {
                            valType real_val = real_vals[1];
                            valType imag_val = imag_vals[1];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            case 2: {
                int dIndex = q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i += 2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[1];
                        imag_val = imag_vals[1];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 3: {
                int dIndex = q_diff_exp + 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            default: {
                break;
            }
        }

    }
    
    #ifdef DEBUG
        // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t (non-adjacent) identity_kron_matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void matrix_kron_identity_times_vector(std::shared_ptr<diaQMatrix> A, unsigned int n, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
    // logically combine matrix_kron_identity and spMV

    #ifdef DEBUG
        //start timer
        printf("starting matrix_kron_identity_times_vector --");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        printf("matrix_kron_identity_times_vector called\n");
        printf("A matrix below\n");
        A->print();
        printf("\t\n = %u\n", n);
    #endif

    unsigned int N = 1L << n;

    // unsigned int x_length = x->numRows;
    // if(before * A->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(before * A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    // (A kron I) times x = y
    #pragma omp parallel for collapse(2)
    for (unsigned int j = 0; j < N; j++) {
        for (unsigned int a = 0; a < diagMap.size(); a++) {
            auto it = std::next(diagMap.begin(), a);
            std::shared_ptr<diagonal> diag = it->second;
            valType *real_vals = diag->realValues;
            valType *imag_vals = diag->imagValues;
            int dIndex = it->first;
            unsigned int dLength = diag->dLength;
            for (unsigned int i = 0; i < dLength; i++) {
                valType real_i = real_vals[i];
                valType imag_i = imag_vals[i];
                // we can skip 0s
                if(real_i == 0 && imag_i == 0) {
                    continue;
                }
                // each element kinda becomes an I block (scalar val at i times I block), we don't need a multiplication op here at all, instead we can cover over values of A, N times as 1 times something is just something.
                unsigned int y_offset = i * N;
                unsigned int x_offset = i * N;
                int new_dIndex = dIndex * N;
                if(dIndex > 0) {
                    x_offset += new_dIndex;
                }
                else if(dIndex < 0) {
                    y_offset -= new_dIndex;
                }
                #pragma omp atomic
                y_real_values[j + y_offset] += real_i * x_real_values[j + x_offset] - imag_i * x_imag_values[j + x_offset];
                #pragma omp atomic
                y_imag_values[j + y_offset] += real_i * x_imag_values[j + x_offset] + imag_i * x_real_values[j + x_offset];
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

    #ifdef DEEP_DEBUG
        printf("matrix_kron_identity_times_vector done\n");
        printf("y vector below\n");
        y->print();
    #endif

}

void matrix_kron_identity_times_vector(std::shared_ptr<diaQMatrix> gate, unsigned int after, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger) {
    // logically combine matrix_kron_identity and spMV

    #ifdef DEBUG
        //start timer
        printf("starting matrix_kron_identity_times_vector --");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    after = 1L << after;

    unsigned int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    std::array<unsigned int, 2> new_gate_shape = {q_diff_exp, q_diff_exp};

    // unsigned int x_length = x->numRows;
    // if(before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(before * gate->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = gate->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for (unsigned int a = 0; a < diagMap.size(); a++) {
        auto it = std::next(diagMap.begin(), a);
        std::shared_ptr<diagonal> diag = it->second;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        switch(diag->dIndex) {
            case -3: {
                int dIndex = -1 * q_diff_exp - 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case -2: {
                int dIndex = -1 * q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] += %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[1];
                    each_imag = imag_vals[1];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                break;
            }
            case -1: {
                int dIndex = -1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength/2; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                for(unsigned int i = dLength/2; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[2];
                        valType each_imag = imag_vals[2];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                dIndex = -1 * q_diff_exp + 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i++) {
                    if( i% 2 != 0) {
                        valType each_real = real_vals[1];
                        valType each_imag = imag_vals[1];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 0: {
                int dIndex = 0;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength/2; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[1];
                    each_imag = imag_vals[1];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                for(unsigned int i = dLength/2; i < dLength; i+=2) {
                    valType each_real = real_vals[2];
                    valType each_imag = imag_vals[2];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[3];
                    each_imag = imag_vals[3];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                break;
            }
            case 1: {
                int dIndex = 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength/2; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                for(unsigned int i = dLength/2; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[2];
                        valType each_imag = imag_vals[2];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                dIndex = q_diff_exp - 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i++) {
                    if( i% 2 != 0) {
                        valType each_real = real_vals[1];
                        valType each_imag = imag_vals[1];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 2: {
                int dIndex = q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[1];
                    each_imag = imag_vals[1];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                break;
            }
            case 3: {
                int dIndex = q_diff_exp + 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t (non-adjacent) matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

std::shared_ptr<diaQMatrix> matrix_kron_identity(std::shared_ptr<diaQMatrix> A, unsigned int n) { // we can combine this with operations that happen later.

    #ifdef DEBUG
        // start timer
        printf("starting matrix_kron_identity -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    n = 1L << n;

    // assume a nxn identity matrix, which has one diagonal of length n, in index 0.
    // we just repeat A, n times in the result matrix
    std::array<unsigned int, 2> result_shape = {n * A->matrix_shape[0], n * A->matrix_shape[1]};
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for(unsigned int di = 0; di < diagMap.size(); di++) {
        auto it = std::next(diagMap.begin(), di);
        int dIndex = it->first;
        std::shared_ptr<diagonal> diag = it->second;
        unsigned int dLength = diag->dLength;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        // result diag
        // std::shared_ptr<diagonal> newDiag = new diagonal(dIndex * n, result->getDiagonalLength(dIndex * n));
        std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(dIndex * n, result->getDiagonalLength(dIndex * n));

        valType *newDiag_real_vals = newDiag->realValues;
        valType *newDiag_imag_vals = newDiag->imagValues;

        #pragma omp parallel for collapse(2)
        for(unsigned int j = 0; j < n; j++) {
            for(unsigned int i = 0; i < dLength; i++) {
                newDiag_real_vals[j + i * n] = real_vals[i];
                newDiag_imag_vals[j + i * n] = imag_vals[i];
            }
        }
        // #pragma omp critical
        result->setDiagonal(dIndex * n, newDiag);
    }
    // result->pruneMatrix();

    #ifdef DEBUG
        // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t matrix_kron_identity took %f milliseconds\n", duration.count()/1000.0);
    #endif

    // A->free();

    return result;
}

std::shared_ptr<diaQMatrix> identity_kron_matrix_kron_identity(unsigned int before, std::shared_ptr<diaQMatrix> A, unsigned int after) {
    #ifdef DEBUG
        printf("starting identity_kron_matrix_kron_identity -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- identity_kron_matrix_kron_identity --- " << std::endl;
        std::cout << " --- " << std::endl;
        A->print();
        std::cout << " --- " << std::endl;
        std::cout << "before = " << before << std::endl;
        std::cout << "after = " << after << std::endl;
        std::cout << " --- " << std::endl;
    #endif

    unsigned int before_N = 1L << before;
    unsigned int after_N = 1L << after;

    std::array<unsigned int, 2> result_shape = {before_N * A->matrix_shape[0] * after_N, before_N * A->matrix_shape[1] * after_N};
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    // // #pragma omp parallel for
    // for(int di = 0; di < diagMap.size(); di++) {
    //     auto it = std::next(diagMap.begin(), di);
    //     int dIndex = it->first;
    //     std::shared_ptr<diagonal> diag = it->second;
    //     int dLength = diag->dLength;
    //     valType *real_vals = diag->realValues;
    //     valType *imag_vals = diag->imagValues;

    //     int new_diag_index = dIndex * after_N;
    //     int new_diag_length = result->getDiagonalLength(new_diag_index);
    //     std::shared_ptr<diagonal> newDiag = new diagonal(new_diag_index, new_diag_length);
    //     valType *newDiag_real_vals = newDiag->realValues;
    //     valType *newDiag_imag_vals = newDiag->imagValues;

    //     // #pragma omp parallel for
    //     for(int rep = 0; rep < before_N; rep++) {
    //         int skip_places = (rep) * (dLength + abs(new_diag_index));
    //         // #pragma omp parallel for
    //         for(unsigned int i = 0; i < dLength; i++) {
    //             newDiag_real_vals[i + skip_places] = real_vals[i];
    //             newDiag_imag_vals[i + skip_places] = imag_vals[i];
    //         }
    //     }
    
    //     #pragma omp critical
    //     result->setDiagonal(dIndex * after_N, newDiag);
    // }

    // #pragma omp parallel for
    // for(unsigned int di = 0; di < A->diagonalMap.size(); di++) {
    //     auto it = std::next(A->diagonalMap.begin(), di);
    #pragma omp parallel for
    for(size_t d = 0; d < A->dIndices.size(); d++) {
        int dIndex = A->dIndices[d];
        std::shared_ptr<diagonal> diag = A->dPointers[d];
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        unsigned int dLength = diag->dLength;

        int new_diag_index = dIndex * after_N;
        unsigned int new_diag_length = result->getDiagonalLength(new_diag_index);
        // std::shared_ptr<diagonal> newDiag = new diagonal(new_diag_index, new_diag_length);
        std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(new_diag_index, new_diag_length);
        valType *newDiag_real_vals = newDiag->realValues;
        valType *newDiag_imag_vals = newDiag->imagValues;

        #pragma omp parallel for
        for(unsigned int rep = 0; rep < before_N; rep++) {
            unsigned int skip_places = rep * (after_N * (dLength + abs(dIndex)));

            #pragma omp parallel for
            for(unsigned int i = 0; i < dLength; i++) {
                valType each_real = real_vals[i];
                valType each_imag = imag_vals[i];
                if(each_real != 0 || each_imag != 0) {

                    #if defined(SIMD_ENABLED)
                    #pragma omp simd
                    #endif
                    for(unsigned int j = 0; j < after_N; j++) {
                        unsigned int new_idx = skip_places + i * after_N + j;
                        newDiag_real_vals[new_idx] = each_real;
                        newDiag_imag_vals[new_idx] = each_imag;
                    }

                }
            }
        }
        result->diagonalMap.insert({new_diag_index, newDiag});
    }

    // record dIndices and dPointers
    for (const auto& pair : result->diagonalMap) {
        result->dIndices.push_back(pair.first);
        result->dPointers.push_back(pair.second);
    }

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t identity_kron_matrix_kron_identity took %.3f milliseconds\n", duration.count() / 1000.0);
    #endif

    // A->free();

    return result;
}

std::shared_ptr<diaQMatrix> kron_product_old(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
    // A: m x n
    // B: p x q
    // C: mp x nq
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- kron product --- " << std::endl;
        std::cout << " --- " << std::endl;
        A->print();
        std::cout << " --- times --- " << std::endl;
        B->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        // start timer
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    std::array<unsigned int, 2> shape_a = A->matrix_shape;
    std::array<unsigned int, 2> shape_b = B->matrix_shape;

    // map of combination of A diagonal index, A diagonal position to multiply_by_scalar matrix. The individual blocks of matrices: A11 * B, A12 * B, A21 * B, A22 * B, ...
    std::map<std::pair<int, int>, std::pair<valType, valType>> kron_map;

    // map of unique A elements and their corresponding kron blocks
    std::map<std::pair<valType, valType>, std::shared_ptr<diaQMatrix> > unique_kron_blocks;

    // Calculate dimensions for the resulting matrix
    std::array<unsigned int, 2> result_shape;
    result_shape[0] = shape_a[0] * shape_b[0];
    result_shape[1] = shape_a[1] * shape_b[1];
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itA;

    // printf("kron here 0\n");

    // for each element in A, do multiply_by_scalar with B and add to kron_list.
    // paralleize this later. TODO
    for (itA = A->diagonalMap.begin(); itA != A->diagonalMap.end(); itA++) {
        int diagonal_index = itA->first;
        std::shared_ptr<diagonal> diag = itA->second;
        unsigned int diagonal_length = diag->dLength;

        #pragma omp parallel for
        for(unsigned int diagonal_position = 0; diagonal_position < diagonal_length; diagonal_position++) {
            // skippihg zero elements
            if(diag->realValues[diagonal_position] == 0.0 && diag->imagValues[diagonal_position] == 0.0) {
                continue;
            }

            // printf("kron here 1\n");

            std::shared_ptr<diaQMatrix> kron_block;
            // dynamic programming for unique kron blocks
            if(unique_kron_blocks.find(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position])) == unique_kron_blocks.end()) {
                kron_block = multiply_by_scalar(B, diag->realValues[diagonal_position], diag->imagValues[diagonal_position]);
                // printf("printing kron_block\n");
                // kron_block->print();
                // store in unique_kron_blocks
                unique_kron_blocks.insert(std::pair<std::pair<valType, valType>, std::shared_ptr<diaQMatrix> >(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]), kron_block));
            }

            // printf("kron here 2\n");

            std::array<unsigned int, 2> A_pos = A->getMatrixPosition(diagonal_index, diagonal_position);
            std::pair<int, int> key = std::make_pair(A_pos[0], A_pos[1]);
            std::pair<valType, valType> val = std::make_pair(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]);
            kron_map.insert(std::pair<std::pair<int, int>, std::pair<valType, valType>>(key, val));
        }
    }
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << "kron_map.size() = " << kron_map.size() << std::endl;
        std::cout << " --- " << std::endl;
    #endif

    // pre-allocate resutl's diagonals and paralleize this below later,! TODO

    // traverse kron_map and add to result.
    std::map<std::pair<int, int>, std::pair<valType, valType>>::iterator it;
    #pragma omp parallel
    {
        #pragma omp single
        for (it = kron_map.begin(); it != kron_map.end(); it++) {
            #pragma omp task
            {
                // for each element in A
                int A_mat_pos[2];
                A_mat_pos[0] = it->first.first;
                A_mat_pos[1] = it->first.second;
                // get kron_block from unique_kron_blocks
                std::shared_ptr<diaQMatrix> kron_block = unique_kron_blocks.find(it->second)->second;

                // we now have to add to result's res_diag_index at res_diag_pos
                phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > kron_block_diagMap = kron_block->diagonalMap;
                phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itK;

                #pragma omp parallel
                {
                    #pragma omp single
                    for (itK = kron_block_diagMap.begin(); itK != kron_block_diagMap.end(); itK++) {
                        #pragma omp task
                        {
                            int kron_block_diag_index = itK->first;
                            std::shared_ptr<diagonal> kron_block_diag = itK->second;
                            unsigned int kron_block_diag_length = kron_block_diag->dLength;

                            #pragma omp parallel for
                            for(unsigned int kron_block_diag_position = 0; kron_block_diag_position < kron_block_diag_length; kron_block_diag_position++) {

                                std::array<unsigned int, 2> B_mat_pos = kron_block->getMatrixPosition(kron_block_diag_index, kron_block_diag_position);
                                std::array<unsigned int, 2> res_mat_pos = result->getMatrixPosition(A_mat_pos[0] * shape_b[0] + B_mat_pos[0], A_mat_pos[1] * shape_b[1] + B_mat_pos[1]);
                                std::array<int, 2> res_diag_pos = result->getDiagonalPosition(res_mat_pos);

                                #ifdef DEEP_DEBUG
                                    std::cout << "A_mat_pos = (" << A_mat_pos[0] << ", " << A_mat_pos[1] << ")" << std::endl;
                                    std::cout << "B_mat_pos = (" << B_mat_pos[0] << ", " << B_mat_pos[1] << ")" << std::endl;
                                    std::cout << "res_mat_pos = (" << res_mat_pos[0] << ", " << res_mat_pos[1] << ")" << std::endl;
                                    std::cout << "res_diag_pos = (" << res_diag_pos[0] << ", " << res_diag_pos[1] << ")" << std::endl;
                                #endif

                                result->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], result->getDiagonalLength(res_diag_pos[0]), kron_block_diag->realValues[kron_block_diag_position], kron_block_diag->imagValues[kron_block_diag_position]);
                            }
                        }
                    }
                }
            }
        }
    }

    // setting dIndices and dPointers
    result->dIndices.resize(result->diagonalMap.size());
    result->dPointers.resize(result->diagonalMap.size());
    #pragma omp parallel for
    for(unsigned int i = 0; i < result->diagonalMap.size(); i++) {
        auto it = std::next(result->diagonalMap.begin(), i);
        result->dIndices[i] = it->first;
        result->dPointers[i] = it->second;
    }

    // result->pruneMatrix(); // Prune the resulting matrix if necessary; we don't actually need this :thinking

    // // for now let's just convert to dense, do the kron product and convert back to diaq
    // denseMatrix denseA = A.convertToDenseMatrix(A->shape);
    // denseMatrix denseB = B.convertToDenseMatrix(B->shape);
    // denseMatrix denseC = dense_kron_product(denseA, denseB);
    // diaQMatrix result = denseC.convertToDiaQ(denseC->shape);

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- kron result --- " << std::endl;
        std::cout << " --- " << std::endl;
        result->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t Kron product took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return result;
}

std::shared_ptr<diaQMatrix> kron_product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, valType c) {
    return multiply_by_scalar(kron_product(A, B), c, 1.0);
}

} // namespace diaq