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

    // Calculate dimensions for the resulting matrix
    std::array<unsigned int, 2> result_shape = {shape_a[0] * shape_b[0], shape_a[1] * shape_b[1]};
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);

    // First pass: collect all result diagonal indices and their max lengths
    std::map<int, unsigned int> diag_lengths;
    std::map<std::pair<valType, valType>, std::shared_ptr<diaQMatrix>> unique_kron_blocks;
    for (size_t a = 0; a < A->dIndices.size(); a++) {
        int a_diag_index = A->dIndices[a];
        unsigned int a_diag_length = A->getDiagonalLengthInternal(a_diag_index);
        valType* a_real_vals = A->realData + A->diagOffsets[a];
        valType* a_imag_vals = A->imagData + A->diagOffsets[a];
        for (unsigned int a_pos = 0; a_pos < a_diag_length; a_pos++) {
            valType real_a = a_real_vals[a_pos];
            valType imag_a = a_imag_vals[a_pos];
            if (real_a == 0.0 && imag_a == 0.0) continue;
            std::shared_ptr<diaQMatrix> kron_block;
            auto key = std::make_pair(real_a, imag_a);
            auto it = unique_kron_blocks.find(key);
            if (it == unique_kron_blocks.end()) {
                kron_block = multiply_by_scalar(B, real_a, imag_a);
                unique_kron_blocks[key] = kron_block;
            } else {
                kron_block = it->second;
            }
            for (size_t b = 0; b < kron_block->dIndices.size(); b++) {
                int b_diag_index = kron_block->dIndices[b];
                unsigned int b_diag_length = kron_block->getDiagonalLengthInternal(b_diag_index);
                for (unsigned int b_pos = 0; b_pos < b_diag_length; b_pos++) {
                    valType real_b = kron_block->realData[kron_block->diagOffsets[b] + b_pos];
                    valType imag_b = kron_block->imagData[kron_block->diagOffsets[b] + b_pos];
                    if (real_b == 0.0 && imag_b == 0.0) continue;
                    std::array<unsigned int, 2> A_mat_pos = A->getMatrixPosition(a_diag_index, a_pos);
                    std::array<unsigned int, 2> B_mat_pos = kron_block->getMatrixPosition(b_diag_index, b_pos);
                    std::array<unsigned int, 2> res_mat_pos = {A_mat_pos[0] * shape_b[0] + B_mat_pos[0], A_mat_pos[1] * shape_b[1] + B_mat_pos[1]};
                    std::array<int, 2> res_diag_pos = result->getDiagonalPosition(res_mat_pos);
                    int res_diag_index = res_diag_pos[0];
                    unsigned int res_diag_pos_in_diag = res_diag_pos[1];
                    unsigned int diag_len = result->getDiagonalLengthInternal(res_diag_index);
                    diag_lengths[res_diag_index] = std::max(diag_lengths[res_diag_index], diag_len);
                }
            }
        }
    }
    // Allocate result matrix storage
    std::vector<int> new_dIndices;
    std::vector<unsigned int> new_diagOffsets;
    unsigned int offset = 0;
    for (const auto& kv : diag_lengths) {
        new_dIndices.push_back(kv.first);
        new_diagOffsets.push_back(offset);
        offset += kv.second;
    }
    std::vector<valType> new_realData(offset, 0.0);
    std::vector<valType> new_imagData(offset, 0.0);
    // Second pass: fill values
    for (size_t a = 0; a < A->dIndices.size(); a++) {
        int a_diag_index = A->dIndices[a];
        unsigned int a_diag_length = A->getDiagonalLengthInternal(a_diag_index);
        valType* a_real_vals = A->realData + A->diagOffsets[a];
        valType* a_imag_vals = A->imagData + A->diagOffsets[a];
        for (unsigned int a_pos = 0; a_pos < a_diag_length; a_pos++) {
            valType real_a = a_real_vals[a_pos];
            valType imag_a = a_imag_vals[a_pos];
            if (real_a == 0.0 && imag_a == 0.0) continue;
            std::shared_ptr<diaQMatrix> kron_block;
            auto key = std::make_pair(real_a, imag_a);
            kron_block = unique_kron_blocks[key];
            for (size_t b = 0; b < kron_block->dIndices.size(); b++) {
                int b_diag_index = kron_block->dIndices[b];
                unsigned int b_diag_length = kron_block->getDiagonalLengthInternal(b_diag_index);
                for (unsigned int b_pos = 0; b_pos < b_diag_length; b_pos++) {
                    valType real_b = kron_block->realData[kron_block->diagOffsets[b] + b_pos];
                    valType imag_b = kron_block->imagData[kron_block->diagOffsets[b] + b_pos];
                    if (real_b == 0.0 && imag_b == 0.0) continue;
                    std::array<unsigned int, 2> A_mat_pos = A->getMatrixPosition(a_diag_index, a_pos);
                    std::array<unsigned int, 2> B_mat_pos = kron_block->getMatrixPosition(b_diag_index, b_pos);
                    std::array<unsigned int, 2> res_mat_pos = {A_mat_pos[0] * shape_b[0] + B_mat_pos[0], A_mat_pos[1] * shape_b[1] + B_mat_pos[1]};
                    std::array<int, 2> res_diag_pos = result->getDiagonalPosition(res_mat_pos);
                    int res_diag_index = res_diag_pos[0];
                    unsigned int res_diag_pos_in_diag = res_diag_pos[1];
                    auto it_diag = std::find(new_dIndices.begin(), new_dIndices.end(), res_diag_index);
                    unsigned int diag_vec_idx = std::distance(new_dIndices.begin(), it_diag);
                    unsigned int diag_offset = new_diagOffsets[diag_vec_idx];
                    new_realData[diag_offset + res_diag_pos_in_diag] += real_b;
                    new_imagData[diag_offset + res_diag_pos_in_diag] += imag_b;
                }
            }
        }
    }
    // Set result matrix data
    result->dIndices = new_dIndices;
    result->diagOffsets = new_diagOffsets;
    if (offset > 0) {
        result->realData = aligned_alloc_helper(offset * sizeof(valType));
        result->imagData = aligned_alloc_helper(offset * sizeof(valType));
        #pragma omp parallel for
        for (unsigned int i = 0; i < offset; ++i) {
            result->realData[i] = new_realData[i];
            result->imagData[i] = new_imagData[i];
        }
    } else {
        result->realData = nullptr;
        result->imagData = nullptr;
    }

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

    // First pass: collect all diagonal indices and lengths
    std::map<int, unsigned int> diag_lengths;
    for (size_t k = 0; k < A->dIndices.size(); ++k) {
        int dIndex = A->dIndices[k];
        unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
        for(unsigned int rep = 0; rep < N; rep++) {
            unsigned int skip_places = (rep) * (dLength + abs(dIndex));
            for(unsigned int i = 0; i < dLength; i++) {
                std::array<unsigned int, 2> mat_pos = result->getMatrixPosition(dIndex, i + skip_places);
                std::array<int, 2> diag_pos = result->getDiagonalPosition(mat_pos);
                int diag_idx = diag_pos[0];
                unsigned int diag_pos_in_diag = diag_pos[1];
                unsigned int diag_len = result->getDiagonalLengthInternal(diag_idx);
                diag_lengths[diag_idx] = std::max(diag_lengths[diag_idx], diag_len);
            }
        }
    }
    // Allocate
    std::vector<int> new_dIndices;
    std::vector<unsigned int> new_diagOffsets;
    unsigned int offset = 0;
    for (const auto& kv : diag_lengths) {
        new_dIndices.push_back(kv.first);
        new_diagOffsets.push_back(offset);
        offset += kv.second;
    }
    std::vector<valType> new_realData(offset, 0.0);
    std::vector<valType> new_imagData(offset, 0.0);
    // Second pass: fill values
    for (size_t k = 0; k < A->dIndices.size(); ++k) {
        int dIndex = A->dIndices[k];
        unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
        valType* real_vals = A->realData + A->diagOffsets[k];
        valType* imag_vals = A->imagData + A->diagOffsets[k];
        for(unsigned int rep = 0; rep < N; rep++) {
            unsigned int skip_places = (rep) * (dLength + abs(dIndex));
            for(unsigned int i = 0; i < dLength; i++) {
                std::array<unsigned int, 2> mat_pos = result->getMatrixPosition(dIndex, i + skip_places);
                std::array<int, 2> diag_pos = result->getDiagonalPosition(mat_pos);
                int diag_idx = diag_pos[0];
                unsigned int diag_pos_in_diag = diag_pos[1];
                auto it_diag = std::find(new_dIndices.begin(), new_dIndices.end(), diag_idx);
                unsigned int diag_vec_idx = std::distance(new_dIndices.begin(), it_diag);
                unsigned int diag_offset = new_diagOffsets[diag_vec_idx];
                new_realData[diag_offset + diag_pos_in_diag] += real_vals[i];
                new_imagData[diag_offset + diag_pos_in_diag] += imag_vals[i];
            }
        }
    }
    // Set result matrix data
    result->dIndices = new_dIndices;
    result->diagOffsets = new_diagOffsets;
    if (offset > 0) {
        result->realData = aligned_alloc_helper(offset * sizeof(valType));
        result->imagData = aligned_alloc_helper(offset * sizeof(valType));
        #pragma omp parallel for
        for (unsigned int i = 0; i < offset; ++i) {
            result->realData[i] = new_realData[i];
            result->imagData[i] = new_imagData[i];
        }
    } else {
        result->realData = nullptr;
        result->imagData = nullptr;
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

    unsigned int A_size = A->matrix_shape[0];
    unsigned int last_y_offset = (N-1) * A_size;

    #pragma omp parallel for
    for(unsigned int y_offset = 0; y_offset <= last_y_offset; y_offset += A_size) {
        for (size_t k = 0; k < A->dIndices.size(); ++k) {
            int dIndex = A->dIndices[k];
            unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
            valType *real_vals = A->realData + A->diagOffsets[k];
            valType *imag_vals = A->imagData + A->diagOffsets[k];

            unsigned int x_inner_offset = (dIndex > 0) ? dIndex : 0;
            unsigned int y_inner_offset = (dIndex < 0) ? -dIndex : 0;

            unsigned int x_offset = y_offset + x_inner_offset;
            unsigned int new_y_offset = y_offset + y_inner_offset;

            #pragma omp parallel for
            for (unsigned int y_idx = new_y_offset; y_idx < dLength + new_y_offset; y_idx++) {
                unsigned int x_idx = x_offset + (y_idx - new_y_offset);
                unsigned int i = y_idx - new_y_offset;
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

    for (size_t k = 0; k < A->dIndices.size(); ++k) {
        int dIndex = A->dIndices[k];
        unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
        valType *real_vals = A->realData + A->diagOffsets[k];
        valType *imag_vals = A->imagData + A->diagOffsets[k];
        switch(dIndex) {
            case -3: {
                int dIndex_local = -1 * q_diff_exp - 1;
                unsigned int dLength_local = getDiagonalLength(dIndex_local, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < n; rep++) {
                    unsigned int skip_places = rep * (dLength_local - dIndex_local);
                    #if defined(SIMD_ENABLED)
                    #pragma omp simd
                    #endif
                    for(unsigned int i = 0; i < dLength_local; i++) {
                        if(i % 2 == 0) {
                            unsigned int x_idx = i + skip_places;
                            unsigned int y_idx = i + skip_places - dIndex_local;
                            y_real_values[y_idx] += real_vals[0] * x_real_values[x_idx] - imag_vals[0] * x_imag_values[x_idx];
                            y_imag_values[y_idx] += real_vals[0] * x_imag_values[x_idx] + imag_vals[0] * x_real_values[x_idx];
                        }
                    }
                }
                break;
            }
            case -2: {
                int dIndex_local = -1 * q_diff_exp;
                unsigned int dLength_local = getDiagonalLength(dIndex_local, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < n; rep++) {
                    unsigned int skip_places = rep * (dLength_local - dIndex_local);
                    #if defined(SIMD_ENABLED)
                    #pragma omp simd
                    #endif
                    for(unsigned int i = 0; i < dLength_local/2; i++) {
                        unsigned int x_idx = i + skip_places;
                        unsigned int y_idx = i + skip_places - dIndex_local;
                        y_real_values[y_idx] += real_vals[0] * x_real_values[x_idx] - imag_vals[0] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[0] * x_imag_values[x_idx] + imag_vals[0] * x_real_values[x_idx];

                        x_idx = i + skip_places + 1;
                        y_idx = i + skip_places - dIndex_local + 1;
                        y_real_values[y_idx] += real_vals[1] * x_real_values[x_idx] - imag_vals[1] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[1] * x_imag_values[x_idx] + imag_vals[1] * x_real_values[x_idx];

                    }
                }
                break;
            }
            case -1: {
                break;
            }
            case 0: {
                break;
            }
            case 1: {
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

    // Use new contiguous API: dIndices, diagOffsets, realData, imagData
    #pragma omp parallel for collapse(2)
    for (unsigned int rep = 0; rep < before_N; rep++) {
        for (unsigned int j = 0; j < after_N; j++) {
            for (size_t a = 0; a < gate->dIndices.size(); a++) {
                int dIndex = gate->dIndices[a];
                unsigned int dLength = gate->getDiagonalLengthInternal(dIndex);
                valType *real_vals = gate->realData + gate->diagOffsets[a];
                valType *imag_vals = gate->imagData + gate->diagOffsets[a];

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

    // Use new contiguous API: dIndices, diagOffsets, realData, imagData
    #pragma omp parallel for collapse(2)
    for (unsigned int j = 0; j < N; j++) {
        for (size_t a = 0; a < A->dIndices.size(); a++) {
            int dIndex = A->dIndices[a];
            unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
            valType *real_vals = A->realData + A->diagOffsets[a];
            valType *imag_vals = A->imagData + A->diagOffsets[a];
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

    // Use new contiguous API: dIndices, diagOffsets, realData, imagData
    #pragma omp parallel for
    for (size_t a = 0; a < gate->dIndices.size(); a++) {
        int dIndex = gate->dIndices[a];
        unsigned int dLength = gate->getDiagonalLengthInternal(dIndex);
        valType *real_vals = gate->realData + gate->diagOffsets[a];
        valType *imag_vals = gate->imagData + gate->diagOffsets[a];

        switch(dIndex) {
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
    // Use new contiguous API: dIndices, diagOffsets, realData, imagData
    #pragma omp parallel for
    for(size_t a = 0; a < A->dIndices.size(); a++) {
        int dIndex = A->dIndices[a];
        unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
        valType *real_vals = A->realData + A->diagOffsets[a];
        valType *imag_vals = A->imagData + A->diagOffsets[a];

        // Use new contiguous storage API
        unsigned int new_diag_length = result->getDiagonalLength(dIndex * n);
        unsigned int new_diag_offset = result->diagOffsets.size() > 0 ? result->diagOffsets.back() + result->getDiagonalLengthInternal(result->dIndices.back()) : 0;
        std::vector<valType> temp_real(new_diag_length, 0.0);
        std::vector<valType> temp_imag(new_diag_length, 0.0);
        #pragma omp parallel for collapse(2)
        for(unsigned int j = 0; j < n; j++) {
            for(unsigned int i = 0; i < dLength; i++) {
                temp_real[j + i * n] = real_vals[i];
                temp_imag[j + i * n] = imag_vals[i];
            }
        }
        result->dIndices.push_back(dIndex * n);
        result->diagOffsets.push_back(new_diag_offset);
        // No need to push diagLengths; use getDiagonalLengthInternal
        if(result->realData == nullptr) {
            result->realData = (valType*)malloc(new_diag_length * sizeof(valType));
            result->imagData = (valType*)malloc(new_diag_length * sizeof(valType));
        }
        memcpy(result->realData + new_diag_offset, temp_real.data(), new_diag_length * sizeof(valType));
        memcpy(result->imagData + new_diag_offset, temp_imag.data(), new_diag_length * sizeof(valType));
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
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);

    // Prepare new API storage
    std::vector<int> new_dIndices;
    std::vector<unsigned int> new_diagOffsets;
    // No need for new_diagLengths; use getDiagonalLengthInternal when needed
    std::vector<valType> new_realData;
    std::vector<valType> new_imagData;

    unsigned int offset = 0;

    #pragma omp parallel for schedule(dynamic)
    for(size_t a = 0; a < A->dIndices.size(); a++) {
        int dIndex = A->dIndices[a];
        unsigned int dLength = A->getDiagonalLengthInternal(dIndex);
        valType *real_vals = A->realData + A->diagOffsets[a];
        valType *imag_vals = A->imagData + A->diagOffsets[a];

        int new_diag_index = dIndex * after_N;
        unsigned int new_diag_length = result->getDiagonalLength(new_diag_index);

        // Allocate temp storage for this diagonal
        std::vector<valType> temp_real(new_diag_length, 0.0);
        std::vector<valType> temp_imag(new_diag_length, 0.0);

        for(unsigned int rep = 0; rep < before_N; rep++) {
            unsigned int skip_places = rep * (after_N * (dLength + abs(dIndex)));
            for(unsigned int i = 0; i < dLength; i++) {
                valType each_real = real_vals[i];
                valType each_imag = imag_vals[i];
                if(each_real != 0 || each_imag != 0) {
                    #if defined(SIMD_ENABLED)
                    #pragma omp simd
                    #endif
                    for(unsigned int j = 0; j < after_N; j++) {
                        unsigned int new_idx = skip_places + i * after_N + j;
                        temp_real[new_idx] = each_real;
                        temp_imag[new_idx] = each_imag;
                    }
                }
            }
        }

        // Store diagonal info
        #pragma omp critical
        {
            new_dIndices.push_back(new_diag_index);
            new_diagOffsets.push_back(offset);
            // No need to push diagLengths; use getDiagonalLengthInternal
            new_realData.insert(new_realData.end(), temp_real.begin(), temp_real.end());
            new_imagData.insert(new_imagData.end(), temp_imag.begin(), temp_imag.end());
            offset += new_diag_length;
        }
    }

    // Set result matrix data
    result->dIndices = new_dIndices;
    result->diagOffsets = new_diagOffsets;
    // No need to assign diagLengths; contiguous API only
    result->realData = new_realData.data();
    result->imagData = new_imagData.data();

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t identity_kron_matrix_kron_identity took %.3f milliseconds\n", duration.count() / 1000.0);
    #endif

    // A->free();

    return result;
}

std::shared_ptr<diaQMatrix> kron_product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, valType c) {
    return multiply_by_scalar(kron_product(A, B), c, 1.0);
}

} // namespace diaq