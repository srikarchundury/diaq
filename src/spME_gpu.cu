#include "matrixKernels_gpu.hpp"
#include "matrixKernels.hpp"

namespace diaq {

std::shared_ptr<diaQMatrix> expm_taylor_scaled_cuda(std::shared_ptr<diaQMatrix> A, int max_iterations, valType scale_cutoff) {
	#ifdef DEBUG
		printf("starting expm_taylor_scaled_cuda -- ");
		std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
	#endif

	// Fast path: single diagonal case
	if (A->num_diags() == 1) {
		return expm_taylor_cuda(A, max_iterations, scale_cutoff);
	}

	// Step 1: Estimate ||A||_1 and choose scaling exponent s
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

	// Step 2: Form A_scaled = A / 2^s (do NOT mutate A)
	valType inv_scale = std::ldexp((valType)1.0, -s); // 2^{-s}
	std::shared_ptr<diaQMatrix> A_scaled = std::make_shared<diaQMatrix>(*A); // requires copy-ctor
	A_scaled->scale_by_real(inv_scale);

	// Tolerance schedule (same as CPU version)
	valType scale = std::ldexp((valType)1.0, s); // 2^s
	valType tolerance = std::max((valType)1e-9, (valType)((valType)1e-5 / scale));

	#ifdef DEEP_DEBUG
		printf("expm_taylor_scaled_cuda: norm_est = %.6f, scaled_norm = %.6f, s = %d, inv_scale = %.6e, tolerance = %.2e\n",
			   norm_est, scaled_norm, s, inv_scale, tolerance);
	#endif

	// Step 3: Compute exp(A / 2^s) on CUDA
	std::shared_ptr<diaQMatrix> U = expm_taylor_cuda(A_scaled, max_iterations, tolerance);

	// Step 4: Scale-and-square: exp(A) = (exp(A/2^s))^(2^s)
	U = pow_cuda(U, 1 << s);

	#ifdef DEBUG
		std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_taylor_scaled_cuda took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return U;
}

std::shared_ptr<diaQMatrix> expm_taylor_cuda(std::shared_ptr<diaQMatrix> A, int max_iterations, valType tolerance) {
    // Computes e^(A) using the Taylor series expansion
    // e^(A) ≈ I + A + A^2 / 2! + A^3 / 3! + ...
    // Stops when terms become negligibly small or reach a max iteration count.

    #ifdef DEBUG
        printf("starting <spME:expm_taylor_cuda> -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    // Initialize result and create 0th diagonal
    std::shared_ptr<diaQMatrix> result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

    std::shared_ptr<diaQMatrix> X_power_i_whole_divided_by_i = std::make_shared<identityMatrix>(A->matrix_shape[0]);
    
    int i;

    for(i = 1; i <= max_iterations; i++) {
        X_power_i_whole_divided_by_i = product_cuda(X_power_i_whole_divided_by_i, A);
        X_power_i_whole_divided_by_i->divide_by_int(i);

        result->add(X_power_i_whole_divided_by_i);

        // Check convergence
        if (X_power_i_whole_divided_by_i->norm() < tolerance) break;

    }

    if(i == max_iterations) {
        printf("Warning: expm_taylor reached max iterations (%d) without convergence.\n", max_iterations);
    }

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t expm_taylor took %f milliseconds\n", duration.count() / 1000.0);
    #endif

    return result;
}

std::shared_ptr<diaQMatrix> expm_negative_taylor_cuda(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations, valType tolerance) {
    // Computes e^(-i * A * t) using the Taylor series expansion
    // e^(-i * A * t) ≈ I - i * A * t + (-i * A * t)^2 / 2! + (-i * A * t)^3 / 3! + ...
    // Stops when terms become negligibly small or reach a max iteration count.

    #ifdef DEBUG
        printf("starting <spME:expm_negative_taylor_cuda> -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    // Initialize result and create 0th diagonal
    std::shared_ptr<diaQMatrix> result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

    if(A->num_diags() == 1) {
        unsigned int dLength = A->getDiagonalLengthInternal(A->dIndices[0]);
        valType *real_vals = A->realData + A->diagOffsets[0];
        valType *imag_vals = A->imagData + A->diagOffsets[0];
        valType *res_real_vals = result->realData + result->diagOffsets[0];
        valType *res_imag_vals = result->imagData + result->diagOffsets[0];
        // Compute exact exp(-i A t) for diagonal elements
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
            std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\t expm_negative_taylors_cuda took %f milliseconds\n", duration.count() / 1000.0);
        #endif
        return result;
    }

    std::shared_ptr<diaQMatrix> X = A->copy_and_scale_by_imag(-1.0 * t);

    // std::shared_ptr<diaQMatrix> X_power_i_whole_divided_by_i = new identityMatrix(A->matrix_shape[0]); // X pwoer 0 / 0! // result is already identity matrix currently
    std::shared_ptr<diaQMatrix> X_power_i_whole_divided_by_i = std::make_shared<identityMatrix>(A->matrix_shape[0]);
    // printf("X_power_i_whole_divided_by_i\n");
    // X_power_i_whole_divided_by_i->print_meta();

    int i;
    // TODO: an we move this loop to GPU?
    for(i = 1; i <= max_iterations; i++) {
        X_power_i_whole_divided_by_i = product_cuda(X_power_i_whole_divided_by_i, X);
        X_power_i_whole_divided_by_i->divide_by_int(i);
        // printf("X_power_i_whole_divided_by_i\n");
        // X_power_i_whole_divided_by_i->print();

        result->add(X_power_i_whole_divided_by_i);

        // Check convergence
        // if (i % 5 == 0 && X_power_i_whole_divided_by_i->norm() < tolerance) break;
        if (X_power_i_whole_divided_by_i->norm() < tolerance) break;

    }

    if(i == max_iterations) {
        printf("Warning: expm_negative_taylor reached max iterations (%d) without convergence.\n", max_iterations);
    }

    // printf("Taylor converged at iteration %d with norm %.2e\n", i, X_power_i_whole_divided_by_i->norm());

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t expm_negative took %f milliseconds\n", duration.count() / 1000.0);
    #endif

    return result;
}

std::shared_ptr<diaQMatrix> expm_negative_taylor_scaled_cuda(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations, valType scale_cutoff) {
	#ifdef DEBUG
		printf("starting expm_negative_taylor_scaled_cuda -- ");
		std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
	#endif

    if (A->num_diags() == 1) {
        #ifdef DEBUG
            std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\t expm_negative_taylor_scaled_cuda took %f milliseconds\n", duration.count() / 1000.0);
        #endif
        return expm_negative_taylor_cuda(A, t, max_iterations, scale_cutoff);
    }

	// Step 1: Estimate the 1-norm and set tolerance!
	valType norm_est = A->estimate_1norm();
    #ifdef DEEP_DEBUG
        printf("expm_negative_taylor_scaled_cuda: Estimated 1-norm of A: %.6f\n", norm_est);
    #endif

    const valType eps = (valType)1e-12;                 // small bias
    valType scaled_norm = t * norm_est + eps;           // nudge away from knife-edge
    int s = (scaled_norm > scale_cutoff)
        ? (int)std::ceil(std::log2(scaled_norm / scale_cutoff))
        : 0;

    // valType tolerance = std::max((valType)1e-9, (valType)(1e-5 / (1 << s)));
    valType scale = std::ldexp((valType)1.0, s);  // 1 * 2^s in floating point
    valType tolerance = std::max((valType)1e-9, (valType)(1e-5 / scale));

	valType scaled_t = t / static_cast<valType>(1 << s); // t / 2^s

    #ifdef DEEP_DEBUG
        printf("expm_negative_taylor_scaled_cuda: norm_est = %.6f, scaled_norm = %.6f, s = %d, scaled_t = %.6f, tolerance = %.6e\n",
            norm_est, scaled_norm, s, scaled_t, tolerance);
    #endif

	if (s > 10) {
		printf("\033[93m[WARNING]\033[0m expm_negative_taylor_scaled_cuda: High scaling factor s = %d may indicate slow convergence.\n", s);
	}

	// Step 3: Compute e^{-i A t / 2^s}
	std::shared_ptr<diaQMatrix> U = expm_negative_taylor_cuda(A, scaled_t, max_iterations, tolerance);

	// // Step 4: Square result s times // old way to do this!
	// for (int i = 0; i < s; i++) {
	// 	U = product_cuda(U, U);
	// }
    // new way to do this! so we avoid host-device transfers s times!!
    U = pow_cuda(U, s);

	#ifdef DEBUG
		std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_negative_taylor_scaled_cuda took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return U;
}

} // namespace diaq
