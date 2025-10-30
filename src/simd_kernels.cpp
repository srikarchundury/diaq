#include "simd_kernels.hpp"
#include "diagonal.hpp"

namespace diaq {

bool diagonal::isEmpty() {
	bool found_nonzero = false;

	#pragma omp parallel
	{
		bool local_found = false;

		#pragma omp for nowait
		for (unsigned int i = 0; i < dLength; ++i) {
			if (found_nonzero || local_found) continue;

			if (realValues[i] != 0.0 || imagValues[i] != 0.0) {
				local_found = true;
			}
		}

		if (local_found) {
			#pragma omp atomic write
			found_nonzero = true;
		}
	}

	return !found_nonzero;
}

} // namespace diaq