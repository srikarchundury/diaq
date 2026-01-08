#include "matrixKernels_gpu.hpp"
#include "matrixKernels.hpp"

namespace diaq {

// ------------------------------------------------------------
// expm_taylor_scaled_cuda
// signature: (A, max_iterations, scale_cutoff, tolerance)
// ------------------------------------------------------------
std::shared_ptr<diaQMatrix> expm_taylor_scaled_cuda(
	std::shared_ptr<diaQMatrix> A,
	int max_iterations,
	valType scale_cutoff,
	valType tolerance
) {
	#ifdef DEBUG
		printf("starting expm_taylor_scaled_cuda -- ");
		auto start = std::chrono::high_resolution_clock::now();
	#endif

	// Fast path: single diagonal case
	if (A->num_diags() == 1) {
		auto res = expm_taylor_cuda(A, max_iterations, scale_cutoff, tolerance);
		#ifdef DEBUG
			auto end = std::chrono::high_resolution_clock::now();
			auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
			printf("\t\t expm_taylor_scaled_cuda took %f milliseconds\n", duration.count() / 1000.0);
		#endif
		return res;
	}

	valType norm_est = A->estimate_1norm();
	#ifdef DEEP_DEBUG
		printf("expm_taylor_scaled_cuda: Estimated ||A||_1 = %.6f\n", norm_est);
	#endif

	const valType eps = (valType)1e-12;
	valType scaled_norm = norm_est + eps;

	int s = (scaled_norm > scale_cutoff)
		? (int)std::ceil(std::log2(scaled_norm / scale_cutoff))
		: 0;

	if (s > 10) {
		printf("\033[93m[WARNING]\033[0m expm_taylor_scaled_cuda: scaling exponent s = %d is large (‖A‖₁ = %.3f)\n",
			   s, norm_est);
	}

	// A_scaled = A / 2^s (do NOT mutate A)
	valType inv_scale = std::ldexp((valType)1.0, -s); // 2^{-s}
	auto A_scaled = std::make_shared<diaQMatrix>(*A);
	A_scaled->scale_by_real(inv_scale);

	// Do NOT override caller tolerance. Optionally tighten for squaring stability:
	valType tol_scaled = std::max((valType)1e-15, tolerance * inv_scale);

	#ifdef DEEP_DEBUG
		printf("expm_taylor_scaled_cuda: norm_est = %.6f, scaled_norm = %.66f, s = %d, inv_scale = %.6e, tol_scaled = %.2e\n",
			   norm_est, scaled_norm, s, inv_scale, tol_scaled);
	#endif

	// Compute exp(A/2^s) on CUDA
	auto U = expm_taylor_cuda(A_scaled, max_iterations, scale_cutoff, tol_scaled);

	// Scale-and-square: exp(A) = exp(A/2^s)^(2^s) => square s times
	U = pow_cuda(U, 1 << s);
	// for (int i = 0; i < s; i++) {
	// 	U = product_cuda(U, U);
	// }

	#ifdef DEBUG
		auto end = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_taylor_scaled_cuda took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return U;
}


// ------------------------------------------------------------
// expm_taylor_cuda
// signature: (A, max_iterations, scale_cutoff, tolerance)
// NOTE: scale_cutoff unused; kept for uniform API.
// ------------------------------------------------------------
std::shared_ptr<diaQMatrix> expm_taylor_cuda(
	std::shared_ptr<diaQMatrix> A,
	int max_iterations,
	valType /*scale_cutoff*/,
	valType tolerance
) {
	#ifdef DEBUG
		printf("starting <spME:expm_taylor_cuda> -- ");
		auto start = std::chrono::high_resolution_clock::now();
	#endif

	auto result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

	// Optional diagonal fast-path (host). Keep minimal.
	if (A->num_diags() == 1) {
		unsigned int dLength = A->getDiagonalLengthInternal(A->dIndices[0]);
		valType *real_vals = A->realData + A->diagOffsets[0];
		valType *imag_vals = A->imagData + A->diagOffsets[0];

		valType *res_real_vals = result->realData + result->diagOffsets[0];
		valType *res_imag_vals = result->imagData + result->diagOffsets[0];

		#pragma omp parallel for
		for (unsigned int i = 0; i < dLength; i++) {
			valType a_i = real_vals[i];
			valType b_i = imag_vals[i];
			valType exp_a = std::exp(a_i);
			valType cos_b = std::cos(b_i);
			valType sin_b = std::sin(b_i);
			res_real_vals[i] = exp_a * cos_b;
			res_imag_vals[i] = exp_a * sin_b;
		}

		#ifdef DEBUG
			auto end = std::chrono::high_resolution_clock::now();
			auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
			printf("\t\t expm_taylor_cuda took %f milliseconds\n", duration.count() / 1000.0);
		#endif
		return result;
	}

	auto term = std::make_shared<identityMatrix>(A->matrix_shape[0]);

	int i;
	for (i = 1; i <= max_iterations; i++) {
		term = product_cuda(term, A);
		term->divide_by_int(i);
		result->add(term);

		if (term->norm() < tolerance) break;
	}

	if (i == max_iterations) {
		printf("Warning: expm_taylor_cuda reached max iterations (%d) without convergence.\n", max_iterations);
	}

	#ifdef DEBUG
		auto end = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_taylor_cuda took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return result;
}


// ------------------------------------------------------------
// expm_negative_taylor_cuda
// signature: (A, t, max_iterations, scale_cutoff, tolerance)
// NOTE: scale_cutoff unused; kept for uniform API.
// ------------------------------------------------------------
std::shared_ptr<diaQMatrix> expm_negative_taylor_cuda(
	std::shared_ptr<diaQMatrix> A,
	valType t,
	int max_iterations,
	valType /*scale_cutoff*/,
	valType tolerance
) {
	#ifdef DEBUG
		printf("starting <spME:expm_negative_taylor_cuda> -- ");
		auto start = std::chrono::high_resolution_clock::now();
	#endif

	auto result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

	if (A->num_diags() == 1) {
		unsigned int dLength = A->getDiagonalLengthInternal(A->dIndices[0]);
		valType *real_vals = A->realData + A->diagOffsets[0];
		valType *imag_vals = A->imagData + A->diagOffsets[0];

		valType *res_real_vals = result->realData + result->diagOffsets[0];
		valType *res_imag_vals = result->imagData + result->diagOffsets[0];

		#pragma omp parallel for
		for (unsigned int i = 0; i < dLength; i++) {
			valType a_i = real_vals[i];
			valType b_i = imag_vals[i];
			valType t_a = t * a_i;
			valType t_b = t * b_i;
			valType exp_b = std::exp(t_b);
			valType cos_ta = std::cos(t_a);
			valType sin_ta = std::sin(t_a);
			res_real_vals[i] = exp_b * cos_ta;
			res_imag_vals[i] = -exp_b * sin_ta;
		}

		#ifdef DEBUG
			auto end = std::chrono::high_resolution_clock::now();
			auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
			printf("\t\t expm_negative_taylor_cuda took %f milliseconds\n", duration.count() / 1000.0);
		#endif
		return result;
	}

	auto X = A->copy_and_scale_by_imag(-1.0 * t);
	auto term = std::make_shared<identityMatrix>(A->matrix_shape[0]);

	int i;
	for (i = 1; i <= max_iterations; i++) {
		term = product_cuda(term, X);
		term->divide_by_int(i);
		result->add(term);

		if (term->norm() < tolerance) break;
	}

	if (i == max_iterations) {
		printf("Warning: expm_negative_taylor_cuda reached max iterations (%d) without convergence.\n", max_iterations);
	}

	#ifdef DEBUG
		auto end = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_negative_taylor_cuda took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return result;
}


// ------------------------------------------------------------
// expm_negative_taylor_scaled_cuda
// signature: (A, t, max_iterations, scale_cutoff, tolerance)
// ------------------------------------------------------------
std::shared_ptr<diaQMatrix> expm_negative_taylor_scaled_cuda(
	std::shared_ptr<diaQMatrix> A,
	valType t,
	int max_iterations,
	valType scale_cutoff,
	valType tolerance
) {
	#ifdef DEBUG
		printf("starting expm_negative_taylor_scaled_cuda -- ");
		auto start = std::chrono::high_resolution_clock::now();
	#endif

	if (A->num_diags() == 1) {
		auto res = expm_negative_taylor_cuda(A, t, max_iterations, scale_cutoff, tolerance);
		#ifdef DEBUG
			auto end = std::chrono::high_resolution_clock::now();
			auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
			printf("\t\t expm_negative_taylor_scaled_cuda took %f milliseconds\n", duration.count() / 1000.0);
		#endif
		return res;
	}

	valType norm_est = A->estimate_1norm();
	#ifdef DEEP_DEBUG
		printf("expm_negative_taylor_scaled_cuda: Estimated ||A||_1 = %.6f\n", norm_est);
	#endif

	const valType eps = (valType)1e-12;
	valType scaled_norm = std::abs(t) * norm_est + eps;

	int s = (scaled_norm > scale_cutoff)
		? (int)std::ceil(std::log2(scaled_norm / scale_cutoff))
		: 0;

	if (s > 10) {
		printf("\033[93m[WARNING]\033[0m expm_negative_taylor_scaled_cuda: scaling exponent s = %d is large (‖A‖₁ = %.3f)\n",
			   s, norm_est);
	}

	valType scaled_t  = std::ldexp(t, -s);               // t / 2^s
	valType inv_scale = std::ldexp((valType)1.0, -s);    // 2^{-s}

	// Keep caller’s tolerance; optionally tighten for squaring stability
	valType tol_scaled = std::max((valType)1e-15, tolerance * inv_scale);

	#ifdef DEEP_DEBUG
		printf("expm_negative_taylor_scaled_cuda: norm_est = %.6f, scaled_norm = %.6f, s = %d, scaled_t = %.6f, tol_scaled = %.2e\n",
			norm_est, scaled_norm, s, scaled_t, tol_scaled);
	#endif

	auto U = expm_negative_taylor_cuda(A, scaled_t, max_iterations, scale_cutoff, tol_scaled);

	// Scale-and-square (square s times)
	U = pow_cuda(U, 1 << s);
	// for (int i = 0; i < s; i++) {
	// 	U = product_cuda(U, U);
	// }

	#ifdef DEBUG
		auto end = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_negative_taylor_scaled_cuda took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return U;
}

} // namespace diaq
