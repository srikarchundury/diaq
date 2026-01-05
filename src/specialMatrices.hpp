#ifndef DIAQ_SPECIALMATRICES_HPP
#define DIAQ_SPECIALMATRICES_HPP

#include "diaQMatrix.hpp"
#include "diagonal.hpp"

namespace diaq {

class identityMatrix : public diaQMatrix {
	public:
		identityMatrix(unsigned int s)
			: diaQMatrix({s, s}, std::vector<int>{0}) // set diagonal indices before base constructor
		{
			// Storage is now allocated by base constructor
			if (realData && imagData) {
				unsigned int off = diagOffsets[0];
				#pragma omp parallel for
				for (unsigned int i = 0; i < s; ++i) {
					realData[off + i] = 1.0;
					imagData[off + i] = 0.0;
				}
			}
		}
};

class permutationMatrix : public diaQMatrix {
	public:
		permutationMatrix(unsigned int s, std::vector<unsigned int> row_order)
		: diaQMatrix({s, s}, std::vector<int>{0})  // or whatever, just ensure base is valid
		{
			#if NUM_BYTES_ALIGNED <= 0
				valType *real = (valType *)calloc(s * s, sizeof(valType));
			#else
				valType *real = aligned_alloc_helper(s * s * sizeof(valType));
				#pragma omp parallel for
				for (unsigned int i = 0; i < s*s; ++i) real[i] = 0.0;
			#endif

			for (unsigned int i = 0; i < s; i++) {
				for (unsigned int j = 0; j < s; j++) {
					real[i * s + j] = (j == row_order[i]) ? 1.0 : 0.0;
				}
			}

			std::shared_ptr<denseMatrix> d = std::make_shared<denseMatrix>(s, real);
			std::shared_ptr<diaQMatrix> qs = d->convertToDiaQ();

			this->freeStorage();      // free our current storage (if any)
			this->swap(*qs);          // now *this owns qs's buffers; qs owns ours (likely null)
		}
};

} // namespace diaq

#endif // DIAQ_SPECIALMATRICES_HPP