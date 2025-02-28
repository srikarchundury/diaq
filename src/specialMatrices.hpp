#ifndef DIAQ_SPECIALMATRICES_HPP
#define DIAQ_SPECIALMATRICES_HPP

#include "diaQMatrix.hpp"
#include "diagonal.hpp"

namespace diaq {

class identityMatrix : public diaQMatrix {
	public:
		identityMatrix(long int s) : diaQMatrix(s) {
			#if NUM_BYTES_ALIGNED == -1
				valType *real = (valType *)calloc(s, sizeof(valType));
				valType *imag = (valType *)calloc(s, sizeof(valType));
			#else
				valType *real = aligned_alloc_helper(s * sizeof(valType));
				valType *imag = aligned_alloc_helper(s * sizeof(valType));
				#pragma omp parallel for
				for(long int i = 0; i < s; i++) {
					real[i] = (valType)1.0;
					imag[i] = (valType)0.0;
				}
			#endif
			diagonal *d = new diagonal(0, s, real, imag);
			this->setDiagonal(0, d);
		}
};

class permutationMatrix : public diaQMatrix {
	public:
		permutationMatrix(long int s, std::vector<long int> row_order) : diaQMatrix(s) {
			#if NUM_BYTES_ALIGNED == -1
				valType *real = (valType *)calloc(s * s, sizeof(valType));
			#else
				valType *real = aligned_alloc_helper(s * s * sizeof(valType));
			#endif
			for(long int i = 0 ; i < s; i++) {
				for(long int j = 0; j < s; j++) {
					if(j == row_order[i]) {
						real[i * s + j] = 1;
					} else {
						real[i * s + j] = 0;
					}
				}
			}
			denseMatrix *d = new denseMatrix(s, real);
			diaQMatrix *qs = d->convertToQuantumSparse(this->matrix_shape);
			this->setDiagonalMap(qs->getDiagonalMap());
			this->matrix_shape = qs->matrix_shape;
			this->shape = qs->shape;
			this->size = qs->size;
		}
};

} // namespace diaq

#endif // DIAQ_SPECIALMATRICES_HPP