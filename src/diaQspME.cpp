#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<diaQMatrix> expm_negative_taylor(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations, valType tolerance) {
    // Computes e^(-i * A * t) using the Taylor series expansion
    // e^(-i * A * t) ≈ I - i * A * t + (-i * A * t)^2 / 2! + (-i * A * t)^3 / 3! + ...
    // Stops when terms become negligibly small or reach a max iteration count.

    #ifdef DEBUG
        printf("starting expm_negative_taylor -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    // Initialize result and create 0th diagonal
    std::shared_ptr<diaQMatrix> result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

    if(A->num_diags() == 1 && A->getDiagonal(0) != nullptr) {

        std::shared_ptr<diagonal> d = A->getDiagonal(0);
        unsigned int dLength = d->dLength;
        valType *real_vals = d->realValues;
        valType *imag_vals = d->imagValues;

        std::shared_ptr<diagonal> res_diag = result->getDiagonal(0);
        valType *res_real_vals = res_diag->realValues;
        valType *res_imag_vals = res_diag->imagValues;

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
            printf("\t\t expm_negative_taylors took %f milliseconds\n", duration.count() / 1000.0);
        #endif

        return result;
    }

    std::shared_ptr<diaQMatrix> X = A->copy_and_scale_by_imag(-1.0 * t);

    // std::shared_ptr<diaQMatrix> X_power_i_whole_divided_by_i = new identityMatrix(A->matrix_shape[0]); // X pwoer 0 / 0! // result is already identity matrix currently
    std::shared_ptr<diaQMatrix> X_power_i_whole_divided_by_i = std::make_shared<identityMatrix>(A->matrix_shape[0]);
    // printf("X_power_i_whole_divided_by_i\n");
    // X_power_i_whole_divided_by_i->print_meta();

    int i;
    for(i = 1; i <= max_iterations; i++) {
        X_power_i_whole_divided_by_i = product(X_power_i_whole_divided_by_i, X);
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

std::shared_ptr<diaQMatrix> expm_negative_taylor_scaled(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations, valType scale_cutoff = 1.0) {
	#ifdef DEBUG
		printf("starting expm_negative_taylor_scaled -- ");
		std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
	#endif

    if (A->num_diags() == 1 && A->getDiagonal(0) != nullptr) {
        #ifdef DEBUG
            std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\t expm_negative_taylor_scaled took %f milliseconds\n", duration.count() / 1000.0);
        #endif

        return expm_negative_taylor(A, t, max_iterations, scale_cutoff);
    }

	// Step 1: Estimate the 1-norm and set tolerance!
	valType norm_est = A->estimate_1norm();
	const valType eps = (valType)1e-12;                 // small bias
    valType scaled_norm = t * norm_est + eps;           // nudge away from knife-edge
    int s = (scaled_norm > scale_cutoff)
        ? (int)std::ceil(std::log2(scaled_norm / scale_cutoff))
        : 0;
    valType tolerance = std::max((valType)1e-9, (valType)(1e-5 / (1 << s)));

	valType scaled_t = t / static_cast<valType>(1 << s); // t / 2^s

	if (s > 10) {
		printf("\033[93m[WARNING]\033[0m expm_negative_taylor_scaled: scaling exponent s = %d is large (‖A‖₁ = %.3f)\n", s, norm_est);
	}

	// Step 3: Compute e^{-i A t / 2^s}
	std::shared_ptr<diaQMatrix> U = expm_negative_taylor(A, scaled_t, max_iterations, tolerance);

	// Step 4: Square result s times
	for (int i = 0; i < s; i++) {
		U = product(U, U);
	}

	#ifdef DEBUG
		std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
		printf("\t\t expm_negative_taylor_scaled took %f milliseconds\n", duration.count() / 1000.0);
	#endif

	return U;
}

std::shared_ptr<diaQMatrix> expm_negative_pade(std::shared_ptr<diaQMatrix> A, valType t, int max_iterations) {
    #ifdef DEBUG
        printf("starting expm_negative_pade -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(A->matrix_shape[0]);

    // Efficient case: If A is purely diagonal, compute exact exponential
    if (A->num_diags() == 1 && A->getDiagonal(0) != nullptr) {
        result->createDiagonal(0);

        std::shared_ptr<diagonal> d = A->getDiagonal(0);
        unsigned int dLength = d->dLength;
        valType *real_vals = d->realValues;
        valType *imag_vals = d->imagValues;

        std::shared_ptr<diagonal> res_diag = result->getDiagonal(0);
        valType *res_real_vals = res_diag->realValues;
        valType *res_imag_vals = res_diag->imagValues;

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
            printf("\t\t expm_negative_pade took %f milliseconds\n", std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0);
        #endif

        return result;
    }

    constexpr valType pade_numer[7] = {1.0, 1.0, 0.5, 0.16666666666667, 0.04166666666667, 0.00833333333333, 0.00138888888889};
    constexpr valType pade_denom[7] = {1.0, 0.5, 0.16666666666667, 0.04166666666667, 0.00833333333333, 0.00138888888889, 0.00019841269841};

    // Compute norm of A
    valType norm_A = A->norm() * std::abs(t);
    int s = std::max(0, static_cast<int>(std::ceil(std::log2(norm_A / 5.4)))); // Scaling heuristic

    // Scale down A: A_s = (-i * t * A) / 2^s
    std::shared_ptr<diaQMatrix> A_s = A->copy_and_scale_by_imag(-1.0 * t / std::pow(2, s));

    #ifdef DEEP_DEBUG
        printf("A_s\n");
        A_s->print();
    #endif

    // Compute Padé approximation of e^X
    std::shared_ptr<diaQMatrix> U = std::make_shared<identityMatrix>(A->matrix_shape[0]);
    std::shared_ptr<diaQMatrix> V = std::make_shared<identityMatrix>(A->matrix_shape[0]);
    std::shared_ptr<diaQMatrix> X_power = A_s->copy(); // X^1

    for (int k = 1; k <= 6; k++) { // Degree-13 approximation (only need terms up to 6)
        X_power = product(X_power, A_s); // Compute X^(2k+1)
        U->addMatrixScaled(X_power, pade_numer[k], 0.0); // Add to U numerator
        V->addMatrixScaled(X_power, pade_denom[k], 0.0); // Add to V denominator
    }

    #ifdef DEEP_DEBUG
        printf("U: \n");
        U->print();
        printf("V: \n");
        V->print();
    #endif

    // Solve (V - U)X = V + U
    std::shared_ptr<diaQMatrix> V_minus_U = V->subtractMatrix(U);

    #ifdef DEEP_DEBUG
        printf("V_minus_U\n");
        V_minus_U->print();
    #endif

    std::shared_ptr<diaQMatrix> V_plus_U = V->addMatrix(U);

    #ifdef DEEP_DEBUG
        printf("V_plus_U\n");
        V_plus_U->print();
    #endif

    std::shared_ptr<diaQMatrix> inv_VmU = V_minus_U->inverse();

    #ifdef DEEP_DEBUG
        printf("inv_VmU\n");
        inv_VmU->print();
    #endif

    result = product(inv_VmU, V_plus_U);

    #ifdef DEEP_DEBUG
        printf("expA_s\n");
        result->print();
    #endif

    // Scale back using squaring
    for (int i = 0; i < s; i++) {
        result = product(result, result);
    }

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        printf("\t\t expm_negative_pade took %f milliseconds\n", std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0);
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

    std::shared_ptr<diaQMatrix> inv_matrix = std::make_shared<diaQMatrix>(this->matrix_shape[0], this->matrix_shape[1]);

    // Efficient case: If A is purely diagonal, principal
    if (num_diags() == 1 && getDiagonal(0) != nullptr) {
        std::shared_ptr<diagonal> diag = this->getDiagonal(0);
        unsigned int dLength = diag->dLength;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        // Create the inverse matrix
        inv_matrix->createDiagonal(0);
        std::shared_ptr<diagonal> inv_diag = inv_matrix->getDiagonal(0);

        valType *inv_real_vals = inv_diag->realValues;
        valType *inv_imag_vals = inv_diag->imagValues;

        #pragma omp parallel for
        for (unsigned int i = 0; i < dLength; i++) {
            valType a_i = real_vals[i];
            valType b_i = imag_vals[i];

            // Compute the complex reciprocal (1 / (a + ib))
            valType denom = a_i * a_i + b_i * b_i;
            if (denom == 0.0) {
                throw std::runtime_error("Matrix is singular, cannot compute inverse.");
            }

            inv_real_vals[i] = a_i / denom;
            inv_imag_vals[i] = -b_i / denom;
        }

        #ifdef DEBUG
            std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
            std::cout << "\t\t inverse took " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0 << " milliseconds" << std::endl;
        #endif

        return inv_matrix;
    }

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
        std::cout << "\t\t inverse took " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0 << " milliseconds" << std::endl;
    #endif

    return inv_matrix;

}

} // namespace diaq