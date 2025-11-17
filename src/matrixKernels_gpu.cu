#include "matrixKernels_gpu.hpp"

#include <cstdlib>
#include <cstdio>
#include <array>
#include <memory>

#ifdef DEBUG
#include <iostream>
#endif

namespace diaq {

// Custom atomicAdd for double (for older architectures without native double atomics)
__device__ double atomicAdddouble(double* address, double val) {
    unsigned long long* address_as_ull = (unsigned long long*)address;
    unsigned long long old = *address_as_ull;
    unsigned long long assumed;

    do {
        assumed = old;
        double old_val = __longlong_as_double((long long)assumed);
        double new_val = old_val + val;
        unsigned long long new_bits = (unsigned long long)__double_as_longlong(new_val);
        old = atomicCAS(address_as_ull, assumed, new_bits);
    } while (assumed != old);

    return __longlong_as_double((long long)old);
}

// ============================================================================
// NOTE: Old SPMV kernel using atomics is commented out (kept for reference).
// It works but uses atomicAdd, which can be slow and cause contention.
// ============================================================================
//
// __global__ void spmv_kernel(int num_diags, int num_elements, int *diagonal_indices,
//                             int *cum_diagonal_lengths, valType *real_data,
//                             valType *imag_data, valType *x_real_values,
//                             valType *x_imag_values, valType *y_real_values,
//                             valType *y_imag_values) {
//     int n = blockIdx.x * blockDim.x + threadIdx.x;
//     if (n < gridDim.x * blockDim.x && n < num_diags) {
//         int dIndex = diagonal_indices[n];
//         int dLength = cum_diagonal_lengths[n] - cum_diagonal_lengths[n - 1];
//         for (int i = 0; i < dLength; i++) {
//             int offset;
//             if (n == 0) {
//                 offset = i;
//             } else {
//                 offset = i + cum_diagonal_lengths[n - 1];
//             }
//             int x_idx = (dIndex < 0) ? i : dIndex + i;
//             int y_idx = (dIndex < 0) ? i - dIndex : i;
//
//             valType real_val = real_data[offset] * x_real_values[x_idx]
//                              - imag_data[offset] * x_imag_values[x_idx];
//             valType imag_val = real_data[offset] * x_imag_values[x_idx]
//                              + imag_data[offset] * x_real_values[x_idx];
//
//             // this is bad! (contention and atomics)
//             atomicAdd(&y_real_values[y_idx], real_val);
//             atomicAdd(&y_imag_values[y_idx], imag_val);
//         }
//     }
// }

// this is inspired from the paper Dr. Li shared with me. It works, but have to
// compare with the above kernel. I have a feeling it'll be better because
// there's no atomicAdd.

// Optimized SPMV for DIA format:
//
// Each thread computes one row y_row_idx:
//   y[y_row_idx] = sum_diag_k A_diag_k(row, col) * x[col]
//
// Instead of scanning diagonals *per (row, col)* (O(num_rows * num_cols * num_diags)),
// we scan *per row + diag* (O(num_rows * num_diags)), which is much better when
// num_diags << num_cols.
__global__ void spmv_dia_kernel(unsigned int num_rows,
                                unsigned int num_cols,
                                unsigned int num_diags,
                                unsigned int num_elements,
                                int* diagonal_indices,
                                unsigned int* cum_diagonal_lengths,
                                valType* real_data,
                                valType* imag_data,
                                valType* x_real_values,
                                valType* x_imag_values,
                                valType* y_real_values,
                                valType* y_imag_values) {

    unsigned int y_row_idx = blockDim.x * blockIdx.x + threadIdx.x;

    if (y_row_idx >= num_rows) {
        return;
    }

    valType real_dot = static_cast<valType>(0.0);
    valType imag_dot = static_cast<valType>(0.0);

    // Loop over all diagonals
    for (unsigned int d_num = 0; d_num < num_diags; ++d_num) {
        int d_idx = diagonal_indices[d_num];

        // Diagonal length for this d_num:
        unsigned int diag_length;
        if (d_num == 0) {
            diag_length = cum_diagonal_lengths[0];
        } else {
            diag_length = cum_diagonal_lengths[d_num] - cum_diagonal_lengths[d_num - 1];
        }

        // For each diagonal, figure out if this row has a non-zero element.
        unsigned int d_pos;
        unsigned int x_row_idx;

        if (d_idx >= 0) {
            // Diagonal above / on main diagonal:
            //   row = i, col = i + d_idx
            // For given row = y_row_idx:
            //   d_pos = y_row_idx, col = y_row_idx + d_idx
            d_pos = y_row_idx;
            if (d_pos >= diag_length) {
                continue;
            }
            x_row_idx = y_row_idx + static_cast<unsigned int>(d_idx);
            if (x_row_idx >= num_cols) {
                continue;
            }
        } else {
            // Diagonal below main diag:
            //   row = i - d_idx, col = i,  for i = 0..diag_length-1
            // For given row = y_row_idx:
            //   we solve y_row_idx = i - d_idx => i = y_row_idx + d_idx
            int i_index = static_cast<int>(y_row_idx) + d_idx;
            if (i_index < 0) {
                continue;
            }
            d_pos = static_cast<unsigned int>(i_index);
            if (d_pos >= diag_length) {
                continue;
            }
            x_row_idx = static_cast<unsigned int>(i_index);
            if (x_row_idx >= num_cols) {
                continue;
            }
        }

        // Offset into flattened diagonal data
        unsigned int offset_in_data;
        if (d_num == 0) {
            offset_in_data = d_pos;
        } else {
            offset_in_data = d_pos + cum_diagonal_lengths[d_num - 1];
        }

        if (offset_in_data >= num_elements) {
            // Safety check; should never happen if getDiagFlatData is correct.
            continue;
        }

        valType a_real = real_data[offset_in_data];
        valType a_imag = imag_data[offset_in_data];

        valType x_real = x_real_values[x_row_idx];
        valType x_imag = x_imag_values[x_row_idx];

        real_dot += a_real * x_real - a_imag * x_imag;
        imag_dot += a_real * x_imag + a_imag * x_real;
    }

    y_real_values[y_row_idx] = real_dot;
    y_imag_values[y_row_idx] = imag_dot;
}

/*
 *  Product of matrix and vector (spMV)
 *  @param A - matrix
 *  @param x - vector
 *  @return y = A * x
*/
std::shared_ptr<vector> spmv_cuda(std::shared_ptr<diaQMatrix> A,
                                  std::shared_ptr<vector> x) {
    // ------------------ DEBUG ------------------
    // logger.log("Using CUDA to calculate product of matrix and vector");
    // ------------------ DEBUG ------------------

    if (A->matrix_shape[1] != x->num_rows()) {
        throw std::invalid_argument("Not multiplyable");
    }

    std::shared_ptr<vector> y =
        std::make_shared<vector>((unsigned int)A->matrix_shape[0],
                                 (valType)0.0);

    valType* y_real_values = y->realValues;
    valType* y_imag_values = y->imagValues;

    valType* x_real_values = x->realValues;
    valType* x_imag_values = x->imagValues;

    unsigned int n_diags;
    int* diagonal_indices;
    unsigned int* cum_diagonal_lengths;
    unsigned int num_elements;
    valType* real_data;
    valType* imag_data;

    A->getDiagFlatData(&n_diags,
                       &diagonal_indices,
                       &cum_diagonal_lengths,
                       &num_elements,
                       &real_data,
                       &imag_data);

#ifdef DEBUG
    // ------------------ DEBUG ------------------
    std::cout << "diagonal_indices: [";
    if (n_diags > 0) {
        for (unsigned int i = 0; i + 1 < n_diags; ++i) {
            std::cout << diagonal_indices[i] << ", ";
        }
        std::cout << diagonal_indices[n_diags - 1];
    }
    std::cout << "]" << std::endl;

    std::cout << "cum_diagonal_lengths: [";
    if (n_diags > 0) {
        for (unsigned int i = 0; i + 1 < n_diags; ++i) {
            std::cout << cum_diagonal_lengths[i] << ", ";
        }
        std::cout << cum_diagonal_lengths[n_diags - 1];
    }
    std::cout << "]" << std::endl;

    std::cout << "(num_elements = " << num_elements << ") [";
    if (num_elements > 0) {
        for (unsigned int i = 0; i + 1 < num_elements; ++i) {
            std::cout << "(" << real_data[i] << "," << imag_data[i] << "), ";
        }
        std::cout << "(" << real_data[num_elements - 1]
                  << "," << imag_data[num_elements - 1] << ")";
    }
    std::cout << "]" << std::endl;
    // ------------------ DEBUG ------------------
#endif

    // cuda allocation
    valType *d_real_data, *d_imag_data;
    valType *d_x_real_values, *d_x_imag_values;
    valType *d_y_real_values, *d_y_imag_values;
    int* d_diagonal_indices;
    unsigned int* d_cum_diagonal_lengths;

    cudaMalloc((void**)&d_real_data, num_elements * sizeof(valType));
    cudaMalloc((void**)&d_imag_data, num_elements * sizeof(valType));
    cudaMalloc((void**)&d_x_real_values, x->num_rows() * sizeof(valType));
    cudaMalloc((void**)&d_x_imag_values, x->num_rows() * sizeof(valType));
    cudaMalloc((void**)&d_y_real_values, y->num_rows() * sizeof(valType));
    cudaMalloc((void**)&d_y_imag_values, y->num_rows() * sizeof(valType));
    cudaMalloc((void**)&d_diagonal_indices, n_diags * sizeof(int));
    cudaMalloc((void**)&d_cum_diagonal_lengths, n_diags * sizeof(unsigned int));

    // cuda copy inputs
    cudaMemcpy(d_real_data, real_data,
               num_elements * sizeof(valType),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_imag_data, imag_data,
               num_elements * sizeof(valType),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_x_real_values, x_real_values,
               x->num_rows() * sizeof(valType),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_x_imag_values, x_imag_values,
               x->num_rows() * sizeof(valType),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_diagonal_indices, diagonal_indices,
               n_diags * sizeof(int),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_cum_diagonal_lengths, cum_diagonal_lengths,
               n_diags * sizeof(unsigned int),
               cudaMemcpyHostToDevice);

    // We do NOT need to copy y_* from host to device; kernel overwrites them.
    cudaMemset(d_y_real_values, 0, y->num_rows() * sizeof(valType));
    cudaMemset(d_y_imag_values, 0, y->num_rows() * sizeof(valType));

    // cuda kernel launch: 1D over rows
    unsigned int num_rows = A->matrix_shape[0];
    int threadsPerBlock = 256;
    int numBlocks = (int)((num_rows + (unsigned int)threadsPerBlock - 1)
                          / (unsigned int)threadsPerBlock);

    spmv_dia_kernel<<<numBlocks, threadsPerBlock>>>(
        A->matrix_shape[0],
        A->matrix_shape[1],
        n_diags,
        num_elements,
        d_diagonal_indices,
        d_cum_diagonal_lengths,
        d_real_data,
        d_imag_data,
        d_x_real_values,
        d_x_imag_values,
        d_y_real_values,
        d_y_imag_values
    );

    // cuda copy back just y
    cudaMemcpy(y_real_values, d_y_real_values,
               y->num_rows() * sizeof(valType),
               cudaMemcpyDeviceToHost);
    cudaMemcpy(y_imag_values, d_y_imag_values,
               y->num_rows() * sizeof(valType),
               cudaMemcpyDeviceToHost);

    // cuda free
    cudaFree(d_real_data);
    cudaFree(d_imag_data);
    cudaFree(d_x_real_values);
    cudaFree(d_x_imag_values);
    cudaFree(d_y_real_values);
    cudaFree(d_y_imag_values);
    cudaFree(d_diagonal_indices);
    cudaFree(d_cum_diagonal_lengths);

    // free host-side flattened data
    free(diagonal_indices);
    free(cum_diagonal_lengths);
    free(real_data);
    free(imag_data);

    return y;
}

__global__ void product_kernel(unsigned int num_diags_A,
                               int* A_diag_indices,
                               unsigned int* A_cum_diagonal_lengths,
                               unsigned int A_num_elements,
                               valType* A_real_data,
                               valType* A_imag_data,
                               unsigned int num_diags_B,
                               int* B_diag_indices,
                               unsigned int* B_cum_diagonal_lengths,
                               unsigned int B_num_elements,
                               valType* B_real_data,
                               valType* B_imag_data,
                               unsigned int num_diags_C,
                               int* C_diag_indices,
                               unsigned int* C_cum_diagonal_lengths,
                               unsigned int C_num_elements,
                               valType* C_real_data,
                               valType* C_imag_data) {
    unsigned int d_a = blockIdx.x * blockDim.x + threadIdx.x;
    if (d_a < num_diags_A) {
        int dIndex_A = A_diag_indices[d_a];

#ifdef DEBUG
        // ------------------ DEBUG ------------------
        printf("product_kernel: d_a = %u, dIndex_A = %d\n",
               d_a, dIndex_A);
        // ------------------ DEBUG ------------------
#endif

        for (unsigned int d_b = 0; d_b < num_diags_B; ++d_b) {
            int dIndex_B = B_diag_indices[d_b];
         int dIndex_C = dIndex_A + dIndex_B;
#ifndef DEBUG
         (void)dIndex_C;
#else
         // ------------------ DEBUG ------------------
         printf("diagonal A %d + diagonal B %d = diagonal C %d\n",
             dIndex_A, dIndex_B, dIndex_C);
         // ------------------ DEBUG ------------------
#endif
            // TODO: actual diagonal-wise multiplication & accumulation into C.
        }
    }
}

/*
 *  Product of two matrices (spMspM)
 *  @param A - first matrix
 *  @param B - second matrix
 *  @return C = A * B
 *
 *  NOTE: As written here, product_kernel is still just a structural stub.
 *  C_real_data / C_imag_data remain all zeros. The DIA layout and GPU
 *  plumbing are correct; what's missing is the actual multiplication logic
 *  inside product_kernel.
*/
std::shared_ptr<diaQMatrix> product_cuda(std::shared_ptr<diaQMatrix> A,
                                         std::shared_ptr<diaQMatrix> B) {
    // logger.log("Using CUDA to calculate product of two matrices");
    if (A->matrix_shape[1] != B->matrix_shape[0]) {
        throw std::invalid_argument("Not multiplyable");
    }

    // let's convert to diagonal indices, cumulative lengths and flattened
    // realData and flattened imagData to be able to send to GPU later
    // for A
    unsigned int A_n_diags;
    int* A_diagonal_indices;
    unsigned int* A_cum_diagonal_lengths;
    unsigned int A_num_elements;
    valType* A_real_data;
    valType* A_imag_data;
    A->getDiagFlatData(&A_n_diags,
                       &A_diagonal_indices,
                       &A_cum_diagonal_lengths,
                       &A_num_elements,
                       &A_real_data,
                       &A_imag_data);
    // for B
    unsigned int B_n_diags;
    int* B_diagonal_indices;
    unsigned int* B_cum_diagonal_lengths;
    unsigned int B_num_elements;
    valType* B_real_data;
    valType* B_imag_data;
    B->getDiagFlatData(&B_n_diags,
                       &B_diagonal_indices,
                       &B_cum_diagonal_lengths,
                       &B_num_elements,
                       &B_real_data,
                       &B_imag_data);

#ifdef DEBUG
    // ------------------ DEBUG ------------------
    std::cout << "A_n_diags = " << A_n_diags << std::endl;
    std::cout << "A_num_elements = " << A_num_elements << std::endl;
    std::cout << "A_diagonal_indices: [";
    if (A_n_diags > 0) {
        for (unsigned int i = 0; i + 1 < A_n_diags; ++i) {
            std::cout << A_diagonal_indices[i] << ", ";
        }
        std::cout << A_diagonal_indices[A_n_diags - 1];
    }
    std::cout << "]" << std::endl;

    std::cout << "A_cum_diagonal_lengths: [";
    if (A_n_diags > 0) {
        for (unsigned int i = 0; i + 1 < A_n_diags; ++i) {
            std::cout << A_cum_diagonal_lengths[i] << ", ";
        }
        std::cout << A_cum_diagonal_lengths[A_n_diags - 1];
    }
    std::cout << "]" << std::endl;

    std::cout << "(A_num_elements = " << A_num_elements << ") [";
    if (A_num_elements > 0) {
        for (unsigned int i = 0; i + 1 < A_num_elements; ++i) {
            std::cout << "(" << A_real_data[i] << "," << A_imag_data[i] << "), ";
        }
        std::cout << "(" << A_real_data[A_num_elements - 1]
                  << "," << A_imag_data[A_num_elements - 1] << ")";
    }
    std::cout << "]" << std::endl;
    std::cout << "---" << std::endl;

    std::cout << "B_n_diags = " << B_n_diags << std::endl;
    std::cout << "B_num_elements = " << B_num_elements << std::endl;
    std::cout << "B_diagonal_indices: [";
    if (B_n_diags > 0) {
        for (unsigned int i = 0; i + 1 < B_n_diags; ++i) {
            std::cout << B_diagonal_indices[i] << ", ";
        }
        std::cout << B_diagonal_indices[B_n_diags - 1];
    }
    std::cout << "]" << std::endl;

    std::cout << "B_cum_diagonal_lengths: [";
    if (B_n_diags > 0) {
        for (unsigned int i = 0; i + 1 < B_n_diags; ++i) {
            std::cout << B_cum_diagonal_lengths[i] << ", ";
        }
        std::cout << B_cum_diagonal_lengths[B_n_diags - 1];
    }
    std::cout << "]" << std::endl;

    std::cout << "(B_num_elements = " << B_num_elements << ") [";
    if (B_num_elements > 0) {
        for (unsigned int i = 0; i + 1 < B_num_elements; ++i) {
            std::cout << "(" << B_real_data[i] << "," << B_imag_data[i] << "), ";
        }
        std::cout << "(" << B_real_data[B_num_elements - 1]
                  << "," << B_imag_data[B_num_elements - 1] << ")";
    }
    std::cout << "]" << std::endl;
    // ------------------ DEBUG ------------------
#endif

    // CUDA stuff - Preparation Phase
    // std::cout << "Preparation Phase" << std::endl;
    std::array<unsigned int, 2> C_matrix_shape;
    C_matrix_shape[0] = A->matrix_shape[0];
    C_matrix_shape[1] = B->matrix_shape[1];
    std::shared_ptr<diaQMatrix> C =
        std::make_shared<diaQMatrix>(C_matrix_shape);

    // number of diagonals in C : A_matrix_shape[0] + B_matrix_shape[1] - 1
    unsigned int C_n_diags =
        A->matrix_shape[0] + B->matrix_shape[1] - 1;

    int* C_diagonal_indices =
        (int*)std::malloc(C_n_diags * sizeof(int));
    unsigned int* C_cum_diagonal_lengths =
        (unsigned int*)std::malloc(C_n_diags * sizeof(unsigned int));

    for (unsigned int i = 0; i < C_n_diags; ++i) {
        C_diagonal_indices[i] =
            (int)i - (int)B->matrix_shape[1];
    }

    unsigned int C_num_elements = 0;
    for (unsigned int i = 0; i < C_n_diags; ++i) {
        int diag_idx = C_diagonal_indices[i];
        unsigned int diag_length = C->getDiagonalLength(diag_idx);
        C_num_elements += diag_length;
        C_cum_diagonal_lengths[i] = C_num_elements;
    }

    valType* C_real_data =
        (valType*)std::malloc(C_num_elements * sizeof(valType));
    valType* C_imag_data =
        (valType*)std::malloc(C_num_elements * sizeof(valType));

    // set them to 0
    for (unsigned int i = 0; i < C_num_elements; ++i) {
        C_real_data[i] = static_cast<valType>(0.0);
        C_imag_data[i] = static_cast<valType>(0.0);
    }

#ifdef DEBUG
    // ------------------ DEBUG C ------------------
    std::cout << "---" << std::endl;
    std::cout << "C_n_diags = " << C_n_diags << std::endl;
    std::cout << "C_diagonal_indices: [";
    if (C_n_diags > 0) {
        for (unsigned int i = 0; i + 1 < C_n_diags; ++i) {
            std::cout << C_diagonal_indices[i] << ", ";
        }
        std::cout << C_diagonal_indices[C_n_diags - 1];
    }
    std::cout << "]" << std::endl;

    std::cout << "C_cum_diagonal_lengths: [";
    if (C_n_diags > 0) {
        for (unsigned int i = 0; i + 1 < C_n_diags; ++i) {
            std::cout << C_cum_diagonal_lengths[i] << ", ";
        }
        std::cout << C_cum_diagonal_lengths[C_n_diags - 1];
    }
    std::cout << "]" << std::endl;

    std::cout << "(C_num_elements = " << C_num_elements << ") [";
    if (C_num_elements > 0) {
        for (unsigned int i = 0; i + 1 < C_num_elements; ++i) {
            std::cout << "(" << C_real_data[i] << "," << C_imag_data[i] << "), ";
        }
        std::cout << "(" << C_real_data[C_num_elements - 1]
                  << "," << C_imag_data[C_num_elements - 1] << ")";
    }
    std::cout << "]" << std::endl;
    std::cout << "---" << std::endl;
    // ------------------ DEBUG C ------------------
#endif

    // cuda stuff - Allocation Phase
    // std::cout << "Allocation Phase" << std::endl;
    valType *d_A_real_data, *d_A_imag_data;
    valType *d_B_real_data, *d_B_imag_data;
    valType *d_C_real_data, *d_C_imag_data;

    int* d_A_diagonal_indices;
    int* d_B_diagonal_indices;
    int* d_C_diagonal_indices;

    unsigned int* d_A_cum_diagonal_lengths;
    unsigned int* d_B_cum_diagonal_lengths;
    unsigned int* d_C_cum_diagonal_lengths;

    // A
    cudaMalloc((void**)&d_A_real_data, A_num_elements * sizeof(valType));
    cudaMalloc((void**)&d_A_imag_data, A_num_elements * sizeof(valType));
    // B
    cudaMalloc((void**)&d_B_real_data, B_num_elements * sizeof(valType));
    cudaMalloc((void**)&d_B_imag_data, B_num_elements * sizeof(valType));
    // C
    cudaMalloc((void**)&d_C_real_data, C_num_elements * sizeof(valType));
    cudaMalloc((void**)&d_C_imag_data, C_num_elements * sizeof(valType));

    // A
    cudaMalloc((void**)&d_A_diagonal_indices, A_n_diags * sizeof(int));
    cudaMalloc((void**)&d_A_cum_diagonal_lengths, A_n_diags * sizeof(unsigned int));
    // B
    cudaMalloc((void**)&d_B_diagonal_indices, B_n_diags * sizeof(int));
    cudaMalloc((void**)&d_B_cum_diagonal_lengths, B_n_diags * sizeof(unsigned int));
    // C
    cudaMalloc((void**)&d_C_diagonal_indices, C_n_diags * sizeof(int));
    cudaMalloc((void**)&d_C_cum_diagonal_lengths, C_n_diags * sizeof(unsigned int));

    // cuda copy
    // A
    cudaMemcpy(d_A_real_data, A_real_data,
               A_num_elements * sizeof(valType),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_A_imag_data, A_imag_data,
               A_num_elements * sizeof(valType),
               cudaMemcpyHostToDevice);
    // B
    cudaMemcpy(d_B_real_data, B_real_data,
               B_num_elements * sizeof(valType),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_B_imag_data, B_imag_data,
               B_num_elements * sizeof(valType),
               cudaMemcpyHostToDevice);
    // C
    cudaMemcpy(d_C_real_data, C_real_data,
               C_num_elements * sizeof(valType),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_C_imag_data, C_imag_data,
               C_num_elements * sizeof(valType),
               cudaMemcpyHostToDevice);
    // A
    cudaMemcpy(d_A_diagonal_indices, A_diagonal_indices,
               A_n_diags * sizeof(int),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_A_cum_diagonal_lengths, A_cum_diagonal_lengths,
               A_n_diags * sizeof(unsigned int),
               cudaMemcpyHostToDevice);
    // B
    cudaMemcpy(d_B_diagonal_indices, B_diagonal_indices,
               B_n_diags * sizeof(int),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_B_cum_diagonal_lengths, B_cum_diagonal_lengths,
               B_n_diags * sizeof(unsigned int),
               cudaMemcpyHostToDevice);
    // C
    cudaMemcpy(d_C_diagonal_indices, C_diagonal_indices,
               C_n_diags * sizeof(int),
               cudaMemcpyHostToDevice);
    cudaMemcpy(d_C_cum_diagonal_lengths, C_cum_diagonal_lengths,
               C_n_diags * sizeof(unsigned int),
               cudaMemcpyHostToDevice);

    // cuda kernel
    int blockSize = 256;
    int gridSize = (int)((C_n_diags + (unsigned int)blockSize - 1)
                         / (unsigned int)blockSize);

    product_kernel<<<gridSize, blockSize>>>(
        A_n_diags,
        d_A_diagonal_indices,
        d_A_cum_diagonal_lengths,
        A_num_elements,
        d_A_real_data,
        d_A_imag_data,
        B_n_diags,
        d_B_diagonal_indices,
        d_B_cum_diagonal_lengths,
        B_num_elements,
        d_B_real_data,
        d_B_imag_data,
        C_n_diags,
        d_C_diagonal_indices,
        d_C_cum_diagonal_lengths,
        C_num_elements,
        d_C_real_data,
        d_C_imag_data
    );

    // cuda copy back just C
    cudaMemcpy(C_real_data, d_C_real_data,
               C_num_elements * sizeof(valType),
               cudaMemcpyDeviceToHost);
    cudaMemcpy(C_imag_data, d_C_imag_data,
               C_num_elements * sizeof(valType),
               cudaMemcpyDeviceToHost);

    // cuda free
    cudaFree(d_A_real_data);
    cudaFree(d_A_imag_data);
    cudaFree(d_B_real_data);
    cudaFree(d_B_imag_data);
    cudaFree(d_C_real_data);
    cudaFree(d_C_imag_data);
    cudaFree(d_A_diagonal_indices);
    cudaFree(d_A_cum_diagonal_lengths);
    cudaFree(d_B_diagonal_indices);
    cudaFree(d_B_cum_diagonal_lengths);
    cudaFree(d_C_diagonal_indices);
    cudaFree(d_C_cum_diagonal_lengths);

    // Construct back diaQMatrix C from flattened data
    C->setDiagFlatData(C_n_diags,
                       C_diagonal_indices,
                       C_cum_diagonal_lengths,
                       C_real_data,
                       C_imag_data);

    // free host flattened data
    free(A_diagonal_indices);
    free(A_cum_diagonal_lengths);
    free(A_real_data);
    free(A_imag_data);
    free(B_diagonal_indices);
    free(B_cum_diagonal_lengths);
    free(B_real_data);
    free(B_imag_data);
    free(C_diagonal_indices);
    free(C_cum_diagonal_lengths);
    free(C_real_data);
    free(C_imag_data);

    return C;
}

} // namespace diaq