#ifndef DIAQ_MATRIXKERNELS_HPP
#define DIAQ_MATRIXKERNELS_HPP

#include "diaQMatrix.hpp"
#include "denseMatrix.hpp"
#include "specialMatrices.hpp"
#include "vector.hpp"
#include "config.hpp"
#include "simd_kernels.hpp"
#include "helpers.hpp"

namespace diaq {

std::shared_ptr<diaQMatrix> product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B);
std::shared_ptr<denseMatrix> denseProduct(std::shared_ptr<denseMatrix> A, std::shared_ptr<denseMatrix> B);
std::shared_ptr<diaQMatrix> add(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B);
std::complex<valType> trace(std::shared_ptr<diaQMatrix> A);
std::shared_ptr<diaQMatrix> reshape(std::shared_ptr<diaQMatrix> A, std::vector<unsigned int> new_tensor_shape);
std::shared_ptr<diaQMatrix> matrix_reshape(std::shared_ptr<diaQMatrix> A, std::array<unsigned int, 2> matrix_shape);
std::vector<unsigned int> newTensorShape(std::vector<unsigned int> tensor_shape_A, std::vector<unsigned int> tensor_shape_B, std::vector<unsigned int> axis_A, std::vector<unsigned int> axis_B);
std::vector<unsigned int> modifyTensorShape(std::vector<unsigned int> tShape, std::vector<unsigned int> axes);
std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A, std::vector<unsigned int> new_order);
std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A);

std::array<unsigned int, 2> getMatrixShape(std::vector<unsigned int> tensor_shape);
std::vector<unsigned int> getTenPos(const std::vector<unsigned int>& ten_pos_A,
                                     const std::vector<unsigned int>& ten_pos_B,
                                     const std::vector<unsigned int>& axes_A,
                                     const std::vector<unsigned int>& axes_B,
                                     const std::vector<unsigned int>& shape_A,
                                     const std::vector<unsigned int>& shape_B);
std::shared_ptr<diaQMatrix> tensordot(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned int> > axes);
std::shared_ptr<diaQMatrix> tensordot1(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned int> > axes);
std::shared_ptr<diaQMatrix> array(std::shared_ptr<diaQMatrix> A);
std::shared_ptr<diaQMatrix> einsum(std::shared_ptr<diaQMatrix> A, std::vector<unsigned int> axes);
std::shared_ptr<diaQMatrix> operator*(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B);
std::shared_ptr<diaQMatrix> operator+(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B);

void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y);
std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x);
std::shared_ptr<vector> MV(std::shared_ptr<denseMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y);

std::shared_ptr<denseMatrix> dense_kron_product(std::shared_ptr<denseMatrix> A, std::shared_ptr<denseMatrix> B);
std::shared_ptr<diaQMatrix> kron_product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B);
std::shared_ptr<diaQMatrix> kron_product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, valType c);

std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger);

std::shared_ptr<diaQMatrix> identity_kron_matrix(unsigned int n, std::shared_ptr<diaQMatrix> res);
void identity_kron_matrix_times_vector(unsigned int n, std::shared_ptr<diaQMatrix> v, std::shared_ptr<vector> x, std::shared_ptr<vector> y);
void identity_kron_matrix_times_vector(unsigned int n, std::shared_ptr<diaQMatrix> v, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger);
std::shared_ptr<diaQMatrix> matrix_kron_identity(std::shared_ptr<diaQMatrix> A, unsigned int n);
std::shared_ptr<diaQMatrix> identity_kron_matrix_kron_identity(unsigned int n, std::shared_ptr<diaQMatrix> v, unsigned int m);

void matrix_kron_identity_times_vector(std::shared_ptr<diaQMatrix> gate, unsigned int before, std::shared_ptr<vector> x, std::shared_ptr<vector> y);
void matrix_kron_identity_times_vector(std::shared_ptr<diaQMatrix> gate, unsigned int before, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger);
void identity_kron_matrix_kron_identity_times_vector(unsigned int after, std::shared_ptr<diaQMatrix> gate, unsigned int before, std::shared_ptr<vector> x, std::shared_ptr<vector> y);
void identity_kron_matrix_kron_identity_times_vector(unsigned int after, std::shared_ptr<diaQMatrix> gate, unsigned int before, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger);

std::shared_ptr<diaQMatrix> dagger(std::shared_ptr<diaQMatrix> A);
std::shared_ptr<diaQMatrix> conjbar(std::shared_ptr<diaQMatrix> A);

std::shared_ptr<diaQMatrix> multiply_by_scalar(std::shared_ptr<diaQMatrix> A, valType real, valType imag);

std::shared_ptr<diaQMatrix> expm_negative_taylor(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations, valType tolerance);
std::shared_ptr<diaQMatrix> expm_negative_taylor_scaled(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations, valType scale_cutoff);
std::shared_ptr<diaQMatrix> matrix_power(std::shared_ptr<diaQMatrix> U, int exponent);
std::shared_ptr<diaQMatrix> expm_negative_pade(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations);

} // namespace diaq

#endif // DIAQ_MATRIXKERNELS_HPP