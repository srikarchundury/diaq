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

} // namespace diaq

#endif // DIAQ_SPECIALMATRICES_HPP