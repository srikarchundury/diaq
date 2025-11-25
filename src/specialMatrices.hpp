#ifndef DIAQ_SPECIALMATRICES_HPP
#define DIAQ_SPECIALMATRICES_HPP

#include "diaQMatrix.hpp"
#include "diagonal.hpp"

namespace diaq {

class identityMatrix : public diaQMatrix {
	public:
		identityMatrix(unsigned int s) : diaQMatrix(s) {
			#if NUM_BYTES_ALIGNED <= 0
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

			// Use new contiguous storage API
			this->dIndices = std::vector<int>{0};
			this->diagOffsets = std::vector<unsigned int>{0};
			this->realData = real;
			this->imagData = imag;
		}
};

class permutationMatrix : public diaQMatrix {
	public:
		permutationMatrix(unsigned int s, std::vector<unsigned int> row_order) : diaQMatrix(s) {
			#if NUM_BYTES_ALIGNED <= 0
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
			std::shared_ptr<diaQMatrix> qs = d->convertToDiaQ();
			// Copy new API fields
			this->dIndices = qs->dIndices;
			this->diagOffsets = qs->diagOffsets;
			// No need to set diagLengths; use getDiagonalLengthInternal
			this->realData = qs->realData;
			this->imagData = qs->imagData;
			this->matrix_shape = qs->matrix_shape;
			this->shape = qs->shape;
		}
};;

} // namespace diaq

#endif // DIAQ_SPECIALMATRICES_HPP