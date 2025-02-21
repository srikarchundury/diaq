import diaq as dq
import numpy as np
from scipy.linalg import expm

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
	]
]

t = 1.6

for mat in matrices_test_cases:
	H = np.array(mat)
	print("====================================")
	print("H:")
	print(H)
	dq_H = dq.from_numpy(H)
	dq_H.print()
	print("--")

	print("Correct expm:")
	correct_U = expm(-1j * H * t)
	print("Correct expm:")
	print(correct_U)
	dq_correct_U = dq.from_numpy(correct_U)
	dq_correct_U.print()
	print("--")

	print("DIAQ expm:")
	dq_U = dq.expm_negative(dq_H, t)
	dq_U.print()
	print("--")
	print("Testing correctness:")
	c1 = dq.to_numpy(dq_correct_U)
	c2 = dq.to_numpy(dq_U)
	np.testing.assert_allclose(c1, c2, rtol=1e-5, atol=1e-8)
	print("Passed.")
	print("--")
	print("====================================")