#ifndef DIAQ_MATRIXKERNELS_HPP
#define DIAQ_MATRIXKERNELS_HPP

#include "diaQMatrix.hpp"
#include "denseMatrix.hpp"
#include "vector.hpp"
#include "config.hpp"

long int getDiagonalLength(long int dIndex, std::vector<long int> shape);
diagonal multiplyDiagonals(std::vector<long int> shapeA, std::vector<long int> shapeB, long int indexA, long int indexB, diagonal diagA, diagonal diagB);
diaQMatrix product(diaQMatrix A, diaQMatrix B);
denseMatrix denseProduct(denseMatrix A, denseMatrix B);
diagonal addElements(diagonal A, diagonal B);
diaQMatrix add(diaQMatrix A, diaQMatrix B);
std::complex<float> trace(diaQMatrix A);
diaQMatrix reshape(diaQMatrix A, std::vector<long int> new_tensor_shape);
std::vector<long int> newTensorShape(std::vector<long int> tensor_shape_A, std::vector<long int> tensor_shape_B, std::vector<long int> axis_A, std::vector<long int> axis_B);
std::vector<long int> modifyTensorShape(std::vector<long int> tShape, std::vector<long int> axes);
diaQMatrix transpose(diaQMatrix A, std::vector<long int> new_order);
diaQMatrix tensordot(diaQMatrix A, diaQMatrix B, std::vector<std::vector<long int> > axes);
diaQMatrix array(diaQMatrix A);
diaQMatrix einsum(diaQMatrix A, std::vector<long int> axes);
diaQMatrix operator*(const diaQMatrix &A, const diaQMatrix &B);
diaQMatrix operator+(const diaQMatrix &A, const diaQMatrix &B);
vector spMV(diaQMatrix A, vector x);
vector MV(denseMatrix A, vector x);

#endif // DIAQ_MATRIXKERNELS_HPP