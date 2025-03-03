#ifndef DIAQ_SPECIALMATRICES_HPP
#define DIAQ_SPECIALMATRICES_HPP

#include "diaQMatrix.hpp"
#include "diagonal.hpp"

namespace diaq {

class identityMatrix : public diaQMatrix, public std::enable_shared_from_this<identityMatrix> {
	public:
		identityMatrix(unsigned int s) : diaQMatrix(s) {
			#if NUM_BYTES_ALIGNED == -1
				valType *real = (valType *)calloc(s, sizeof(valType));
				valType *imag = (valType *)calloc(s, sizeof(valType));
			#else
				valType *real = aligned_alloc_helper(s * sizeof(valType));
				valType *imag = aligned_alloc_helper(s * sizeof(valType));
			#endif
			#pragma omp parallel for
			for(unsigned int i = 0; i < s; i++) {
				real[i] = (valType)1.0;
				imag[i] = (valType)0.0;
			}
			std::shared_ptr<diagonal> d = std::make_shared<diagonal>(0, s, real, imag);
			this->setDiagonal(0, d);
		}
};;

class permutationMatrix : public diaQMatrix, public std::enable_shared_from_this<permutationMatrix> {
	public:
		permutationMatrix(unsigned int s, std::vector<unsigned int> row_order) : diaQMatrix(s) {
			#if NUM_BYTES_ALIGNED == -1
				valType *real = (valType *)calloc(s * s, sizeof(valType));
			#else
				valType *real = aligned_alloc_helper(s * s * sizeof(valType));
			#endif
			for(unsigned int i = 0 ; i < s; i++) {
				for(unsigned int j = 0; j < s; j++) {
					if(j == row_order[i]) {
						real[i * s + j] = 1;
					} else {
						real[i * s + j] = 0;
					}
				}
			}
			std::shared_ptr<denseMatrix> d = std::make_shared<denseMatrix>(s, real);
			std::shared_ptr<diaQMatrix> qs = d->convertToQuantumSparse(this->matrix_shape);
			this->diagonalMap = qs->diagonalMap;
			this->matrix_shape = qs->matrix_shape;
			this->shape = qs->shape;
			this->size = qs->size;
		}
};;

} // namespace diaq

#endif // DIAQ_SPECIALMATRICES_HPP