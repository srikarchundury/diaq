#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<denseMatrix> dense_kron_product(std::shared_ptr<denseMatrix> A, std::shared_ptr<denseMatrix> B) {
    // A: m x n
    // B: p x q
    // C: mp x nq

    std::array<unsigned int, 2> shape_a = A->matrix_shape;
    std::array<unsigned int, 2> shape_b = B->matrix_shape;

    // Calculate dimensions for the resulting matrix
    std::array<unsigned int, 2> d;
    d[0] = shape_a[0] * shape_b[0];
    d[1] = shape_a[1] * shape_b[1];
    #if NUM_BYTES_ALIGNED == -1
        valType *real_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
        valType *imag_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
    #else
        valType *real_res = aligned_alloc_helper(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1] * sizeof(valType));
        valType *imag_res = aligned_alloc_helper(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1] * sizeof(valType));
        #pragma omp parallel for
        for(unsigned int i = 0; i < shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1]; i++) {
            real_res[i] = 0.0;
            imag_res[i] = 0.0;
        }
    #endif
    // std::shared_ptr<denseMatrix> result = new denseMatrix(&d, real_res, imag_res);
    std::shared_ptr<denseMatrix> result = std::make_shared<denseMatrix>(d, real_res, imag_res);

    // Iterate through the rows of matrix A
    for (unsigned int i = 0; i < A->matrix_shape[0]; i++) {

        // Iterate through the columns of matrix A
        for (unsigned int j = 0; j < A->matrix_shape[1]; j++) {

            // Iterate through the rows of matrix B
            for (unsigned int k = 0; k < B->matrix_shape[0]; k++) {

                // Iterate through the columns of matrix B
                for (unsigned int l = 0; l < B->matrix_shape[1]; l++) {

                    // Calculate the resulting indices in the new matrix
                    unsigned int newIndexI = i * B->matrix_shape[0] + k;
                    unsigned int newIndexJ = j * B->matrix_shape[1] + l;

                    // Multiply the element of A by the element of B
                    std::complex<valType> newElement = A->get(i, j) * B->get(k, l);

                    // Add the resulting element to the appropriate position in the result denseMatrix
                    result->set(newIndexI, newIndexJ, newElement);
                }
            }
        }
    }
    return result;
}

std::shared_ptr<vector> MV(std::shared_ptr<denseMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
    if(A->matrix_shape[1] != x->numRows) {
        throw std::invalid_argument("Not multiplyable");
    }
    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;
    // std::shared_ptr<vector> y = new vector(A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;
    for(unsigned int i = 0; i < A->matrix_shape[0]; i++) {
        valType res_real = 0.0;
        valType res_imag = 0.0;
        for(unsigned int j = 0; j < A->matrix_shape[1]; j++) {
            std::complex<valType> elem = A->get(i, j);
            res_real += elem.real() * x_real_values[j] - elem.imag() * x_imag_values[j];
            res_imag += elem.real() * x_imag_values[j] + elem.imag() * x_real_values[j];
        }
        y_real_values[i] = res_real;
        y_imag_values[i] = res_imag;
    }
    return y;
}

/**
 * @brief dense matrix multiplication (C = A.B)
 * 
 * @param A denseMatrix
 * @param B denseMatrix
 * 
 * @return denseMatrix  C
 */
std::shared_ptr<denseMatrix> denseProduct(std::shared_ptr<denseMatrix> A, std::shared_ptr<denseMatrix> B) {
    std::array<unsigned int, 2> shape_a = A->matrix_shape;
    std::array<unsigned int, 2> shape_b = B->matrix_shape;
    if(shape_a[1] != shape_b[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    #if NUM_BYTES_ALIGNED == -1
        valType *real_res = (valType *)calloc(shape_a[0] * shape_b[1], sizeof(valType));
        valType *imag_res = (valType *)calloc(shape_a[0] * shape_b[1], sizeof(valType));
    #else
        valType *real_res = aligned_alloc_helper(shape_a[0] * shape_b[1] * sizeof(valType));
        valType *imag_res = aligned_alloc_helper(shape_a[0] * shape_b[1] * sizeof(valType));
        #pragma omp parallel for
        for(unsigned int i = 0; i < shape_a[0] * shape_b[1]; i++) {
            real_res[i] = 0.0;
            imag_res[i] = 0.0;
        }
    #endif
    std::array<unsigned int, 2> d;
    d[0] = A->matrix_shape[0];
    d[1] = B->matrix_shape[1];
    // std::shared_ptr<denseMatrix> result = new denseMatrix(&d, real_res, imag_res);
    std::shared_ptr<denseMatrix> result = std::make_shared<denseMatrix>(d, real_res, imag_res);
    for(unsigned int i = 0; i < shape_a[0]; i++) {
        for(unsigned int k = 0; k < shape_b[1]; k++) {
            std::complex<valType> res = 0.0;
            for(unsigned int j = 0; j < shape_b[0]; j++) {
                res += A->get(i, j) * B->get(j, k);
            }
            result->set(i, k, res);
        }
    }
    return result;
}

} // namespace diaq