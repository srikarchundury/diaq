#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
	#include "conversions_gpu.hpp"
	#include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

// ------------------------------------------------------------
// expm_taylor_scaled
// signature: (A, max_iterations, scale_cutoff, tolerance)
// ------------------------------------------------------------
std::shared_ptr<diaQMatrix> expm_taylor_scaled(
	std::shared_ptr<diaQMatrix> A,
	int max_iterations,
	valType scale_cutoff,
	valType tolerance
) {
	#ifdef DEBUG
		printf("starting expm_taylor_scaled -- ");
		std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
	#endif

	// Fast path: diagonal => exact exp (ignore scale_cutoff, but keep API)
	if (A->num_diags() == 1) {
		std::shared_ptr<diaQMatrix> res = expm_taylor(A, max_iterations, scale_cutoff, tolerance);
		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
			std::chrono::duration<double, std::micro> duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
			printf("\t\t expm_taylor_scaled took %f milliseconds\n", duration.count() / 1000.0);
		#endif
		return res;
	}

	valType norm_est = A->estimate_1norm();
	#ifdef DEEP_DEBUG
		printf("expm_taylor_scaled: Estimated ||A||_1 = %.6f\n", norm_est);
	#endif

	const valType eps = (valType)1e-12;
	valType scaled_norm = norm_est + eps;

	int s = (scaled_norm > scale_cutoff)
		? (int)std::ceil(std::log2(scaled_norm / scale_cutoff))
		: 0;

	if (s > 10) {
		printf("\033[93m[WARNING]\033[0m expm_taylor_scaled: scaling exponent s = %d is large (‖A‖₁ = %.3f)\n", s, norm_est);
	}

	// A_scaled = A / 2^s
	valType inv_scale = std::ldexp((valType)1.0, -s); // 2^{-s}
	std::shared_ptr<diaQMatrix> A_scaled = std::make_shared<diaQMatrix>(*A);
	A_scaled->scale_by_real(inv_scale);

	// IMPORTANT: DO NOT overwrite the user's tolerance with a heuristic.
	// Optionally tighten slightly for stability under repeated squaring:
	valType tol_scaled = std::max((valType)1e-15, tolerance * inv_scale);

	#ifdef DEEP_DEBUG
		printf("expm_taylor_scaled: norm_est = %.6f, scaled_norm = %.6f, s = %d, inv_scale = %.6e, tol_scaled = %.2e\n",
			norm_est, scaled_norm, s, inv_scale, tol_scaled);
	#endif

	std::shared_ptr<diaQMatrix> U = expm_taylor(A_scaled, max_iterations, scale_cutoff, tol_scaled);

	// undo scaling: exp(A) = exp(A/2^s)^(2^s)
	U = pow(U, 1 << s);
	// for (int i = 0; i < s; i++) {
	// 	U = product(U, U);
	// }

	#ifdef DEBUG
		std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
		std::chrono::duration<double, std::micro> duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_taylor_scaled took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return U;
}


// ------------------------------------------------------------
// expm_taylor
// signature: (A, max_iterations, scale_cutoff, tolerance)
// NOTE: scale_cutoff is unused here; kept for uniform API.
// ------------------------------------------------------------
std::shared_ptr<diaQMatrix> expm_taylor(
	std::shared_ptr<diaQMatrix> A,
	int max_iterations,
	valType /*scale_cutoff*/,
	valType tolerance
) {
	#ifdef DEBUG
		printf("starting expm_taylor -- ");
		std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
	#endif

	std::shared_ptr<diaQMatrix> result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

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
			std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
			std::chrono::duration<double, std::micro> duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
			printf("\t\t expm_taylor took %f milliseconds\n", duration.count() / 1000.0);
		#endif
		return result;
	}

	std::shared_ptr<diaQMatrix> X = A->copy();
	std::shared_ptr<diaQMatrix> term = std::make_shared<identityMatrix>(A->matrix_shape[0]); // X^0 / 0! = I

	int i;
	for (i = 1; i <= max_iterations; i++) {
		term = product(term, X);
		term->divide_by_int(i);
		result->add(term);

		if (term->norm() < tolerance) break;
	}

	if (i == max_iterations) {
		printf("Warning: expm_taylor reached max iterations (%d) without convergence.\n", max_iterations);
	}

	#ifdef DEBUG
		std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
		std::chrono::duration<double, std::micro> duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_taylor took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return result;
}


// ------------------------------------------------------------
// expm_negative_taylor
// signature: (A, t, max_iterations, scale_cutoff, tolerance)
// NOTE: scale_cutoff is unused here; kept for uniform API.
// ------------------------------------------------------------
std::shared_ptr<diaQMatrix> expm_negative_taylor(
	std::shared_ptr<diaQMatrix> A,
	valType t,
	int max_iterations,
	valType /*scale_cutoff*/,
	valType tolerance
) {
	#ifdef DEBUG
		printf("starting <spME:expm_negative_taylor> --- ");
		std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
	#endif

	std::shared_ptr<diaQMatrix> result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

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
			std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
			std::chrono::duration<double, std::micro> duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
			printf("\t\t expm_negative_taylor took %f milliseconds\n", duration.count() / 1000.0);
		#endif
		return result;
	}

	std::shared_ptr<diaQMatrix> X = A->copy_and_scale_by_imag(-1.0 * t);
	std::shared_ptr<diaQMatrix> term = std::make_shared<identityMatrix>(A->matrix_shape[0]);

	int i;
	for (i = 1; i <= max_iterations; i++) {
		term = product(term, X);
		term->divide_by_int(i);
		result->add(term);

		if (term->norm() < tolerance) break;
	}

	if (i == max_iterations) {
		printf("Warning: expm_negative_taylor reached max iterations (%d) without convergence.\n", max_iterations);
	}

	#ifdef DEBUG
		std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
		std::chrono::duration<double, std::micro> duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_negative_taylor took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return result;
}


// ------------------------------------------------------------
// expm_negative_taylor_scaled
// signature: (A, t, max_iterations, scale_cutoff, tolerance)
// ------------------------------------------------------------
std::shared_ptr<diaQMatrix> expm_negative_taylor_scaled(
	std::shared_ptr<diaQMatrix> A,
	valType t,
	int max_iterations,
	valType scale_cutoff,
	valType tolerance
) {
	#ifdef DEBUG
		printf("starting expm_negative_taylor_scaled -- ");
		std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
	#endif

	if (A->num_diags() == 1) {
		std::shared_ptr<diaQMatrix> res = expm_negative_taylor(A, t, max_iterations, scale_cutoff, tolerance);
		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
			std::chrono::duration<double, std::micro> duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
			printf("\t\t expm_negative_taylor_scaled took %f milliseconds\n", duration.count() / 1000.0);
		#endif
		return res;
	}

	valType norm_est = A->estimate_1norm();
	#ifdef DEEP_DEBUG
		printf("expm_negative_taylor_scaled: Estimated ||A||_1 = %.6f\n", norm_est);
	#endif

	const valType eps = (valType)1e-12;
	valType scaled_norm = std::abs(t) * norm_est + eps;

	int s = (scaled_norm > scale_cutoff)
		? (int)std::ceil(std::log2(scaled_norm / scale_cutoff))
		: 0;

	if (s > 10) {
		printf("\033[93m[WARNING]\033[0m expm_negative_taylor_scaled: scaling exponent s = %d is large (‖A‖₁ = %.3f)\n", s, norm_est);
	}

	// FIX: use ldexp instead of (1<<s) to avoid overflow + keep precision
	valType scaled_t = std::ldexp(t, -s);                 // t / 2^s
	valType inv_scale = std::ldexp((valType)1.0, -s);     // 2^{-s}

	// Keep caller’s tolerance; (optional) tighten for squaring stability
	valType tol_scaled = std::max((valType)1e-15, tolerance * inv_scale);

	#ifdef DEEP_DEBUG
		printf("expm_negative_taylor_scaled: norm_est = %.6f, scaled_norm = %.6f, s = %d, scaled_t = %.6f, tol_scaled = %.2e\n",
			norm_est, scaled_norm, s, scaled_t, tol_scaled);
	#endif

	std::shared_ptr<diaQMatrix> U = expm_negative_taylor(A, scaled_t, max_iterations, scale_cutoff, tol_scaled);

	// exp(A) = (exp(A / 2^s))^(2^s)
	U = pow(U, 1 << s);
	// for (int i = 0; i < s; i++) {
	// 	U = product(U, U);
	// }

	#ifdef DEBUG
		std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
		std::chrono::duration<double, std::micro> duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_negative_taylor_scaled took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return U;
}


std::shared_ptr<diaQMatrix> expm_negative_pade(
	std::shared_ptr<diaQMatrix> A,
	valType t,
	int max_iterations,
	valType scale_cutoff,
	valType tolerance
) {
	#ifdef DEBUG
		printf("starting expm_negative_pade -- ");
		std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
	#endif

	// Efficient case: If A is purely diagonal, compute exact exponential
	if (A->num_diags() == 1) {
		std::shared_ptr<diaQMatrix> result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

		unsigned int dLength = A->getDiagonalLengthInternal(A->dIndices[0]);
		valType *real_vals = A->realData + A->diagOffsets[0];
		valType *imag_vals = A->imagData + A->diagOffsets[0];

		valType *res_real_vals = result->realData + result->diagOffsets[0];
		valType *res_imag_vals = result->imagData + result->diagOffsets[0];

		#pragma omp parallel for
		for (unsigned int i = 0; i < dLength; i++) {
			valType t_a = t * real_vals[i];
			valType t_b = t * imag_vals[i];
			valType exp_b = std::exp(t_b);
			valType cos_ta = std::cos(t_a);
			valType sin_ta = std::sin(t_a);
			res_real_vals[i] = exp_b * cos_ta;
			res_imag_vals[i] = -exp_b * sin_ta;
		}

		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
			printf("\t\t expm_negative_pade took %f milliseconds\n",
				std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0);
		#endif
		return result;
	}

	valType norm_X = A->norm() * std::abs(t);

	const valType eps = (valType)1e-12;
	valType scaled_norm = norm_X + eps;

	int s = (scaled_norm > scale_cutoff)
		? (int)std::ceil(std::log2(scaled_norm / scale_cutoff))
		: 0;

	if (s > 10) {
		printf("\033[93m[WARNING]\033[0m expm_negative_pade: scaling exponent s = %d is large (||-itA|| ≈ %.3f)\n", s, norm_X);
	}

	// Scale down: X = (-i * t * A) / 2^s
	valType scaled_t = std::ldexp(t, -s); // t / 2^s
	std::shared_ptr<diaQMatrix> X = A->copy_and_scale_by_imag(-1.0 * scaled_t);

	#ifdef DEEP_DEBUG
		printf("X (scaled)\n");
		X->print();
	#endif

	constexpr valType pade_numer[7] = {
		(valType)1.0,
		(valType)1.0,
		(valType)0.5,
		(valType)0.16666666666667,
		(valType)0.04166666666667,
		(valType)0.00833333333333,
		(valType)0.00138888888889
	};

	constexpr valType pade_denom[7] = {
		(valType)1.0,
		(valType)0.5,
		(valType)0.16666666666667,
		(valType)0.04166666666667,
		(valType)0.00833333333333,
		(valType)0.00138888888889,
		(valType)0.00019841269841
	};

	// U = sum_{k=0..6} numer[k] * X^k
	// V = sum_{k=0..6} denom[k] * X^k
	std::shared_ptr<diaQMatrix> U = std::make_shared<identityMatrix>(A->matrix_shape[0]);
	std::shared_ptr<diaQMatrix> V = std::make_shared<identityMatrix>(A->matrix_shape[0]);

	// Apply k=0 coefficients (both 1.0): already included by identity matrices.

	// X_power = X^1
	std::shared_ptr<diaQMatrix> X_power = X->copy();

	// Add k=1 term
	U->addMatrixScaled(X_power, pade_numer[1], (valType)0.0);
	V->addMatrixScaled(X_power, pade_denom[1], (valType)0.0);

	int k_max = std::min(6, std::max(1, max_iterations)); // keep your max_iterations argument meaningful

	for (int k = 2; k <= k_max; k++) {
		X_power = product(X_power, X); // now X_power = X^k

		U->addMatrixScaled(X_power, pade_numer[k], (valType)0.0);
		V->addMatrixScaled(X_power, pade_denom[k], (valType)0.0);

		// Optional early stop for safety (cheap)
		if (X_power->norm() < tolerance) break;
	}

	#ifdef DEEP_DEBUG
		printf("U: \n"); U->print();
		printf("V: \n"); V->print();
	#endif

	// -----------------------------
	// Solve  (V - U)^{-1} (V + U)
	// -----------------------------
	std::shared_ptr<diaQMatrix> V_minus_U = V->subtractMatrix(U);
	std::shared_ptr<diaQMatrix> V_plus_U  = V->addMatrix(U);

	#ifdef DEEP_DEBUG
		printf("V_minus_U\n"); V_minus_U->print();
		printf("V_plus_U\n");  V_plus_U->print();
	#endif

	std::shared_ptr<diaQMatrix> inv_VmU = V_minus_U->inverse();
	std::shared_ptr<diaQMatrix> result  = product(inv_VmU, V_plus_U);

	#ifdef DEEP_DEBUG
		printf("expX (scaled)\n");
		result->print();
	#endif

	// // Scale back using squaring
	result = pow(result, 1 << s);
	// for (int i = 0; i < s; i++) {
	// 	result = product(result, result);
	// }

	#ifdef DEBUG
		std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
		printf("\t\t expm_negative_pade took %f milliseconds\n",
			std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0);
	#endif

	return result;
}

std::shared_ptr<vector> bicgstab_solve(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> b, valType tol, int max_iter) {
    unsigned int n = b->numRows;

    std::shared_ptr<vector> x = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> p = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> v = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> s = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> t = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> p_old = std::make_shared<vector>(n, 0.0);

    std::shared_ptr<vector> r = b->subtract(A->multiplyVector(x));  // Initial residual
    std::shared_ptr<vector> r_tilde = r->copy();

    valType rho = 1.0, alpha = 1.0, omega = 1.0;

    for (int iter = 0; iter < max_iter; iter++) {
        valType rho_new = r_tilde->dot(r);
        if (std::abs(rho_new) < 1e-14) break;

        valType beta = (rho_new / rho) * (alpha / omega);
        rho = rho_new;

        #pragma omp parallel for
        for (unsigned int i = 0; i < n; i++) {
            // p[i] = r[i] + beta * (p_old[i] - omega * v[i]);
            p->realValues[i] = r->realValues[i] + beta * (p_old->realValues[i] - omega * v->realValues[i]);
            p->imagValues[i] = r->imagValues[i] + beta * (p_old->imagValues[i] - omega * v->imagValues[i]);
        }

        v = A->multiplyVector(p);
        alpha = rho / r_tilde->dot(v);

        #pragma omp parallel for
        for (unsigned int i = 0; i < n; i++) {
            s->realValues[i] = r->realValues[i] - alpha * v->realValues[i];
            s->imagValues[i] = r->imagValues[i] - alpha * v->imagValues[i];
        }

        if (s->norm() < tol) {

            #pragma omp parallel for
            for (unsigned int i = 0; i < n; i++) {
                // x[i] += alpha * p[i];
                x->realValues[i] += alpha * p->realValues[i];
                x->imagValues[i] += alpha * p->imagValues[i];
            }
            break;
        }

        t = A->multiplyVector(s);
        omega = t->dot(s) / t->dot(t);
        
        #pragma omp parallel for
        for (unsigned int i = 0; i < n; i++) {
            // x[i] += alpha * p[i] + omega * s[i];
            // r[i] = s[i] - omega * t[i];
            x->realValues[i] += alpha * p->realValues[i] + omega * s->realValues[i];
            x->imagValues[i] += alpha * p->imagValues[i] + omega * s->imagValues[i];

            r->realValues[i] = s->realValues[i] - omega * t->realValues[i];
            r->imagValues[i] = s->imagValues[i] - omega * t->imagValues[i];
        }

        if (r->norm() < tol) break;
    }

    return x;
}

std::shared_ptr<diaQMatrix> diaQMatrix::inverse() {
    // matrix inverse!
    // has to be square!!

    #ifdef DEBUG
        printf("starting inverse -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    // Efficient case: purely diagonal
    if (num_diags() == 1) {
        // Allocate a matrix with the main diagonal present
        std::shared_ptr<diaQMatrix> inv_matrix = std::make_shared<identityMatrix>(this->matrix_shape[0]);

        unsigned int dLength = getDiagonalLengthInternal(dIndices[0]);
        valType *real_vals = realData + diagOffsets[0];
        valType *imag_vals = imagData + diagOffsets[0];

        valType *inv_real_vals = inv_matrix->realData + inv_matrix->diagOffsets[0];
        valType *inv_imag_vals = inv_matrix->imagData + inv_matrix->diagOffsets[0];

		#pragma omp parallel for
        for (unsigned int i = 0; i < dLength; i++) {
            valType a_i = real_vals[i];
            valType b_i = imag_vals[i];

            valType denom = a_i * a_i + b_i * b_i;
            if (denom == 0.0) {
                throw std::runtime_error("Matrix is singular, cannot compute inverse.");
            }

            inv_real_vals[i] = a_i / denom;
            inv_imag_vals[i] = -b_i / denom;
        }

		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
			std::cout << "\t\t inverse took "
					<< std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
                  << " ms" << std::endl;
		#endif
        
		return inv_matrix;
    }

    std::shared_ptr<diaQMatrix> inv_matrix = std::make_shared<diaQMatrix>(this->matrix_shape[0], this->matrix_shape[1]);

    // Solve for each column of the identity matrix
    for (unsigned int col = 0; col < matrix_shape[1]; col++) {
        std::shared_ptr<vector> b = std::make_shared<vector>(matrix_shape[1], 0.0);
        b->realValues[col] = 1.0;

        std::shared_ptr<vector> x = bicgstab_solve(shared_from_this(), b, 1e-10, 1000);

        // Store the solution x as the corresponding column in inv_matrix
        for (unsigned int row = 0; row < matrix_shape[0]; row++) {
            inv_matrix->set(row, col, x->realValues[row], x->imagValues[row]);
        }
    }

    #ifdef DEEP_DEBUG
        printf("inverse done: ");
        inv_matrix->print();
    #endif

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::micro> duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("spME:expm_negative_taylor took %.3f ms\n", duration.count() / 1000.0);
    #endif

    return inv_matrix;

}

} // namespace diaq