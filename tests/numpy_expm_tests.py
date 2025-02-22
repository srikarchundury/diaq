import numpy as np
import math

# Function to compute matrix exponential, e^(-i * A * t)
# using expansion: e^(-i * A * t) = I + X + X^2 / 2! + X^3 / 3! + ... where X = A * -1.0 * i * t
def matrix_exponential(A, t, tol=1e-14, max_iter=100):
	# Define the identity matrix
	result = np.eye(A.shape[0], dtype=complex)
	X = -1.0j * t * A  # Compute X = A * -1.0 * i * t
	X_power_i_whole_divided_by_i = np.eye(A.shape[0], dtype=complex)  # Initialize X^i to I

	# Loop through the series expansion
	for i in range(1, max_iter + 1):

		X_power_i_whole_divided_by_i = np.dot(X_power_i_whole_divided_by_i, X) # calculate X^i / i!

		X_power_i_whole_divided_by_i = X_power_i_whole_divided_by_i / i

		result = result + X_power_i_whole_divided_by_i

		# # If the norm of the term is small, stop early
		if np.linalg.norm(X_power_i_whole_divided_by_i) < tol:
			break

	return result


def matrix_exponential_2(A, t, tol=1e-14, max_iter=100):
    # Scaling factor to prevent overflow
    norm_A = np.linalg.norm(A, ord=np.inf) * abs(t)
    s = max(1, int(np.ceil(np.log2(norm_A))))  # Choose s such that A/s has a small norm

    # Compute e^(-i A t / s)
    result = np.eye(A.shape[0], dtype=complex)
    X = (-1.0j * t * A) / s  # Scale matrix
    X_power_i_whole_divided_by_i = np.eye(A.shape[0], dtype=complex)

    for i in range(1, max_iter + 1):
        X_power_i_whole_divided_by_i = np.dot(X_power_i_whole_divided_by_i, X) / i
        result = result + X_power_i_whole_divided_by_i
        
        # Stop early if the added term is sufficiently small
        if np.linalg.norm(X_power_i_whole_divided_by_i, ord=np.inf) < tol:
            break

    # Squaring step to recover original scale
    for _ in range(s):
        result = np.dot(result, result)

    return result


matrices_test_cases = [
	[
		[1, 0, 0, 0],
		[0, 2, 0, 0],
		[0, 0, 3, 0],
		[0, 0, 0, 4]
	],
	[
		[1, 5, 0, 0],
		[0, 2, 6, 0],
		[0, 0, 3, 7],
		[0, 0, 0, 4]
	],
	[
		[1, 5, 0, 0],
		[8, 2, 6, 0],
		[0, 9, 3, 7],
		[0, 0, 10, 4]
	],
	[
		[1, 0, 5, 0],
		[0, 2, 0, 6],
		[7, 0, 3, 0],
		[0, 8, 0, 4]
	],
	[
		[10, 11, 12, 13, 14, 15],
		[16, 17, 18, 19, 20, 21],
		[22, 23, 24, 25, 26, 27],
		[28, 29, 30, 31, 32, 33],
		[34, 35, 36, 37, 38, 39],
		[40, 41, 42, 43, 44, 45]
	]
]

import scipy as sc
import scipy.linalg as sc_linalg
def test_matrix_exponential(matrix):
	A = np.array(matrix, dtype=complex)
	t = 1.6
	exp_A = matrix_exponential(A, t)
	scipy_exp_A = sc_linalg.expm(-1j * t * A)
	return np.testing.assert_allclose(exp_A, scipy_exp_A, rtol=1e-5, atol=1e-8) == None

for mat in matrices_test_cases:
	print(test_matrix_exponential(mat))