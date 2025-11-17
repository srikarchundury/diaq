#include "simd_nosimd_kernels.hpp"

namespace diaq {

template<>
void run_without_vectorization<float>(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset,
		float *real_vals_a, float *imag_vals_a, float *real_vals_b, float *imag_vals_b, float *real_vals_final, float *imag_vals_final, bool overwrite) {
		#ifdef DEEP_DEBUG
		std::cout << "Starting run_without_vectorization -- " << std::endl;
		std::chrono::high_resolution_clock::time_point time_start = std::chrono::high_resolution_clock::now();
	#endif

	for (unsigned int k = start; k < end; ++k) {
		valType real_a = real_vals_a[k + a_offset];
		valType imag_a = imag_vals_a[k + a_offset];
		valType real_b = real_vals_b[k + b_offset];
		valType imag_b = imag_vals_b[k + b_offset];
		if (overwrite) {
			real_vals_final[k] = (real_a * real_b) - (imag_a * imag_b);
			imag_vals_final[k] = (real_a * imag_b) + (imag_a * real_b);
		} else {
			real_vals_final[k] += (real_a * real_b) - (imag_a * imag_b);
			imag_vals_final[k] += (real_a * imag_b) + (imag_a * real_b);
		}
	}

	#ifdef DEEP_DEBUG
		std::chrono::high_resolution_clock::time_point time_end = std::chrono::high_resolution_clock::now();
		std::chrono::microseconds duration = std::chrono::duration_cast<std::chrono::microseconds>(time_end - time_start);
		printf("\t\trun_without_vectorization took %f milliseconds\n", duration.count()/1000.0);
	#endif
}

template<>
void run_without_vectorization<double>(unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset,
		double *real_vals_a, double *imag_vals_a, double *real_vals_b, double *imag_vals_b, double *real_vals_final, double *imag_vals_final, bool overwrite) {
	#ifdef DEEP_DEBUG
		std::cout << "Starting run_without_vectorization -- " << std::endl;
		std::chrono::high_resolution_clock::time_point time_start = std::chrono::high_resolution_clock::now();
	#endif

	for (unsigned int k = start; k < end; ++k) {
		valType real_a = real_vals_a[k + a_offset];
		valType imag_a = imag_vals_a[k + a_offset];
		valType real_b = real_vals_b[k + b_offset];
		valType imag_b = imag_vals_b[k + b_offset];
		if (overwrite) {
			real_vals_final[k] = (real_a * real_b) - (imag_a * imag_b);
			imag_vals_final[k] = (real_a * imag_b) + (imag_a * real_b);
		} else {
			real_vals_final[k] += (real_a * real_b) - (imag_a * imag_b);
			imag_vals_final[k] += (real_a * imag_b) + (imag_a * real_b);
		}
	}

	#ifdef DEEP_DEBUG
		std::chrono::high_resolution_clock::time_point time_end = std::chrono::high_resolution_clock::now();
		std::chrono::microseconds duration = std::chrono::duration_cast<std::chrono::microseconds>(time_end - time_start);
		printf("\t\trun_without_vectorization took %f milliseconds\n", duration.count()/1000.0);
	#endif
}

} // namespace diaq