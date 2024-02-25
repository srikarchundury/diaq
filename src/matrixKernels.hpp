#ifndef DIAQ_MATRIXKERNELS_HPP
#define DIAQ_MATRIXKERNELS_HPP

#include <type_traits>
#include <unordered_map>

#include "diaQMatrix.hpp"
#include "denseMatrix.hpp"
#include "vector.hpp"
#include "config.hpp"

namespace diaq {

long int getDiagonalLength(long int dIndex, long int *shape);
diagonal *multiplyDiagonals(long int *shapeA, long int *shapeB, long int indexA, long int indexB, diagonal *diagA, diagonal *diagB);
diaQMatrix *product(diaQMatrix *A, diaQMatrix *B);
denseMatrix *denseProduct(denseMatrix *A, denseMatrix *B);
diagonal *addElements(diagonal *A, diagonal *B);
diaQMatrix *add(diaQMatrix *A, diaQMatrix *B);
std::complex<valType> trace(diaQMatrix *A);
diaQMatrix *reshape(diaQMatrix *A, std::vector<long int> new_tensor_shape);
diaQMatrix *matrix_reshape(diaQMatrix *A, long int *matrix_shape);
std::vector<long int> newTensorShape(std::vector<long int> tensor_shape_A, std::vector<long int> tensor_shape_B, std::vector<long int> axis_A, std::vector<long int> axis_B);
std::vector<long int> modifyTensorShape(std::vector<long int> tShape, std::vector<long int> axes);
diaQMatrix *transpose(diaQMatrix *A, std::vector<long int> new_order);
diaQMatrix *transpose(diaQMatrix *A);
diaQMatrix *tensordot(diaQMatrix *A, diaQMatrix *B, std::vector<std::vector<long int> > axes);
diaQMatrix *array(diaQMatrix *A);
diaQMatrix *einsum(diaQMatrix *A, std::vector<long int> axes);
diaQMatrix *operator*(diaQMatrix &A, diaQMatrix &B);
diaQMatrix *operator+(diaQMatrix &A, diaQMatrix &B);
vector *spMV(diaQMatrix *A, vector *x);
vector *MV(denseMatrix *A, vector *x);

denseMatrix *dense_kron_product(denseMatrix *A, denseMatrix *B);
diaQMatrix *kron_product(diaQMatrix *A, diaQMatrix *B);
diaQMatrix *kron_product(diaQMatrix *A, diaQMatrix *B, valType c);

diaQMatrix *dagger(diaQMatrix *A);
diaQMatrix *conjbar(diaQMatrix *A);

} // namespace diaq

#endif // DIAQ_MATRIXKERNELS_HPP