#ifndef DIAQ_MATRIXKERNELS_HPP
#define DIAQ_MATRIXKERNELS_HPP

#include "diaQMatrix.hpp"
#include "denseMatrix.hpp"
#include "specialMatrices.hpp"
#include "vector.hpp"
#include "config.hpp"
#include "simd_kernels.hpp"

namespace diaq {

unsigned long int getDiagonalLength(long int dIndex, std::shared_ptr<unsigned long int[]> matrix_shape);
unsigned long int getDiagonalLength(long int dIndex, unsigned long int *matrix_shape);
std::shared_ptr<diagonal> multiplyDiagonals(unsigned long int *shapeA, unsigned long int *shapeB, long int indexA, long int indexB, std::shared_ptr<diagonal> diagA, std::shared_ptr<diagonal> diagB);
std::shared_ptr<diaQMatrix> product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B);
std::shared_ptr<denseMatrix> denseProduct(std::shared_ptr<denseMatrix> A, std::shared_ptr<denseMatrix> B);
std::shared_ptr<diagonal> addElements(std::shared_ptr<diagonal> A, std::shared_ptr<diagonal> B);
std::shared_ptr<diaQMatrix> add(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B);
std::complex<valType> trace(std::shared_ptr<diaQMatrix> A);
std::shared_ptr<diaQMatrix> reshape(std::shared_ptr<diaQMatrix> A, std::vector<unsigned long int> new_tensor_shape);
std::shared_ptr<diaQMatrix> matrix_reshape(std::shared_ptr<diaQMatrix> A, unsigned long int *matrix_shape);
std::vector<unsigned long int> newTensorShape(std::vector<unsigned long int> tensor_shape_A, std::vector<unsigned long int> tensor_shape_B, std::vector<unsigned long int> axis_A, std::vector<unsigned long int> axis_B);
std::vector<unsigned long int> modifyTensorShape(std::vector<unsigned long int> tShape, std::vector<unsigned long int> axes);
std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A, std::vector<unsigned long int> new_order);
std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A);
std::shared_ptr<diaQMatrix> tensordot(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned long int> > axes);
std::shared_ptr<diaQMatrix> tensordot1(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned long int> > axes);
std::shared_ptr<diaQMatrix> array(std::shared_ptr<diaQMatrix> A);
std::shared_ptr<diaQMatrix> einsum(std::shared_ptr<diaQMatrix> A, std::vector<unsigned long int> axes);
std::shared_ptr<diaQMatrix> operator*(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B);
std::shared_ptr<diaQMatrix> operator+(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B);

void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y);
std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x);
std::shared_ptr<vector> MV(std::shared_ptr<denseMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y);

std::shared_ptr<denseMatrix> dense_kron_product(std::shared_ptr<denseMatrix> A, std::shared_ptr<denseMatrix> B);
std::shared_ptr<diaQMatrix> kron_product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B);
std::shared_ptr<diaQMatrix> kron_product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, valType c);

std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned long int qubit_smaller, unsigned long int qubit_larger);

std::shared_ptr<diaQMatrix> identity_kron_matrix(unsigned long int n, std::shared_ptr<diaQMatrix> res);
void identity_kron_matrix_times_vector(unsigned long int n, std::shared_ptr<diaQMatrix> v, std::shared_ptr<vector> x, std::shared_ptr<vector> y);
void identity_kron_matrix_times_vector(unsigned long int n, std::shared_ptr<diaQMatrix> v, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned long int qubit_smaller, unsigned long int qubit_larger);
std::shared_ptr<diaQMatrix> matrix_kron_identity(std::shared_ptr<diaQMatrix> A, unsigned long int n);
std::shared_ptr<diaQMatrix> identity_kron_matrix_kron_identity(unsigned long int n, std::shared_ptr<diaQMatrix> v, unsigned long int m);

void matrix_kron_identity_times_vector(std::shared_ptr<diaQMatrix> gate, unsigned long int before, std::shared_ptr<vector> x, std::shared_ptr<vector> y);
void matrix_kron_identity_times_vector(std::shared_ptr<diaQMatrix> gate, unsigned long int before, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned long int qubit_smaller, unsigned long int qubit_larger);
void identity_kron_matrix_kron_identity_times_vector(unsigned long int after, std::shared_ptr<diaQMatrix> gate, unsigned long int before, std::shared_ptr<vector> x, std::shared_ptr<vector> y);
void identity_kron_matrix_kron_identity_times_vector(unsigned long int after, std::shared_ptr<diaQMatrix> gate, unsigned long int before, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned long int qubit_smaller, unsigned long int qubit_larger);

std::shared_ptr<diaQMatrix> dagger(std::shared_ptr<diaQMatrix> A);
std::shared_ptr<diaQMatrix> conjbar(std::shared_ptr<diaQMatrix> A);

std::shared_ptr<diaQMatrix> multiply_by_scalar(std::shared_ptr<diaQMatrix> A, valType real, valType imag);

std::shared_ptr<diaQMatrix> expm_negative(std::shared_ptr<diaQMatrix> A, valType t);

} // namespace diaq

#endif // DIAQ_MATRIXKERNELS_HPP