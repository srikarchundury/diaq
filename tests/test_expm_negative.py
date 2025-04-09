import diaq as dq
import numpy as np
from scipy.linalg import expm

# def scaled_expm_negative(dq_H, t, max_iterations=20, scale_cutoff=1.0):
# 	# Compute matrix norm in NumPy for rough scaling estimate
# 	H_np = dq.to_numpy(dq_H)
# 	norm_estimate = np.linalg.norm(H_np, ord=1)
# 	scaled_t = t * norm_estimate

# 	# Find s such that norm(H * t / 2^s) ≤ scale_cutoff
# 	s = max(0, int(np.ceil(np.log2(scaled_t / scale_cutoff))))  # ensure s ≥ 0
# 	scaled_t = t / (2**s)

# 	if s > 10:
# 		print(f"\033[91m[WARNING]\033[0m scaling exponent s={s} → possible loss of precision.")

# 	# Compute expm of scaled matrix
# 	dq_U = dq.expm_negative(dq_H, scaled_t, max_iterations=max_iterations)

# 	# Square result s times
# 	for _ in range(s):
# 		dq_U = dq.product(dq_U, dq_U)

# 	return dq_U

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
		[0.707107, 0.707107],
		[0.707107, -0.707107] # this is Hadamard gate, random test, Hermitian is different
	],
	[
		[10, 0, 0, 0, 21, 0],
		[0, 11, 0, 0, 0, 22],
		[19, 0, 12, 0, 0, 0],
		[0, 18, 0, 13, 0, 0],
		[0, 0, 17, 0, 14, 0],
		[20, 0, 0, 16, 0, 15]
	],
	[
		[10, 11, 12, 13, 14, 15],
		[16, 17, 18, 19, 20, 21],
		[22, 23, 24, 25, 26, 27],
		[28, 29, 30, 31, 32, 33],
		[34, 35, 36, 37, 38, 39],
		[40, 41, 42, 43, 44, 45]
	], # this gives numerical stability issues, how to fix? break early? the scaled version works

	np.random.rand(64, 64), # dense 6 qubits

	np.random.rand(128, 128), # dense 7 qubits

	np.random.rand(256, 256), # dense 8 qubits

	np.random.rand(512, 512), # dense 9 qubits

	np.random.rand(1024, 1024), # dense 10 qubits
]

t = 1.6

for i, mat in enumerate(matrices_test_cases):
	H = np.array(mat)
	print("====================================")
	print(f"Test case {i + 1}: Matrix size {H.shape[0]}x{H.shape[1]}: ", end=" ")
	# print("H:")
	# print(H)
	dq_H = dq.from_numpy(H)
	# dq_H.print()
	# print("--")

	# print("DIAQ expm below:")
	# dq_U = scaled_expm_negative(dq_H, t)
	dq_U = dq.expm_negative(dq_H, t)
	# dq_U.print()
	# print("--")

	# print("Correct expm below:")
	correct_U = expm(-1j * H * t)
	# dq_correct_U = dq.from_numpy(correct_U)
	# dq_correct_U.print()
	# print("--")

	# print("Testing correctness:")
	c2 = dq.to_numpy(dq_U)

	# print("correct_U:")
	# print(correct_U)

	# print("C2:")
	# print(c2)

	assert np.testing.assert_allclose(correct_U, c2, rtol=1e-5, atol=1e-5) == None
	print("\033[92m\033[1mPassed.\033[0m")
	print("--")
	print("====================================")