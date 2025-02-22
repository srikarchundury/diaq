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
	],
	[
		[10, 11, 12, 13, 14, 15],
		[16, 17, 18, 19, 20, 21],
		[22, 23, 24, 25, 26, 27],
		[28, 29, 30, 31, 32, 33],
		[34, 35, 36, 37, 38, 39],
		[40, 41, 42, 43, 44, 45]
	],
	[
		np.random.rand(64, 64).tolist()
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
	assert np.testing.assert_allclose(c1, c2, rtol=1e-5, atol=1e-8) == None
	print("Passed.")
	print("--")
	print("====================================")