#ifndef DIAQ_SPECIALMATRICES_HPP
#define DIAQ_SPECIALMATRICES_HPP

#include "diaQMatrix.hpp"
#include "diagonal.hpp"

namespace diaq {

class identityMatrix : public diaQMatrix {
	public:
		identityMatrix(long int s) : diaQMatrix(s) {
			valType *real_ones = (valType *)calloc(s, sizeof(valType));
			for(long int i = 0; i < s; i++) {
				real_ones[i] = 1;
			}
			valType *imag_zeros = (valType *)calloc(s, sizeof(valType));
			diagonal d(0, s, real_ones, imag_zeros);
			this->setDiagonal(0, d);
		}
};

class permutationMatrix : public diaQMatrix {
	public:
		permutationMatrix(long int s, std::vector<long int> row_order) : diaQMatrix(s) {
			valType *real_ones = (valType *)calloc(s * s, sizeof(valType));
			for(long int i = 0 ; i < s; i++) {
				for(long int j = 0; j < s; j++) {
					if(j == row_order[i]) {
						real_ones[i * s + j] = 1;
					} else {
						real_ones[i * s + j] = 0;
					}
				}
			}
			denseMatrix d(s, real_ones);
			diaQMatrix qs = d.convertToQuantumSparse(this->matrix_shape);
			this->setDiagonalMap(qs.getDiagonalMap());
			this->matrix_shape = qs.matrix_shape;
			this->shape = qs.shape;
			this->size = qs.size;
		}
};

} // namespace diaq

#endif // DIAQ_SPECIALMATRICES_HPP