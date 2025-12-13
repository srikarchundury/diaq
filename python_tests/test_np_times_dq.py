import numpy as np
import diaq as dq

a = np.arange(0, 2**8).reshape(2**4, 2**4)
dq_a = dq.from_numpy(a)

b = np.arange(0, 2**8).reshape(2**4, 2**4)
dq_b = dq.from_numpy(b)

expected_result = np.matmul(a, b)

result = dq.np_times_dq(a, dq_b)

try:
	np.testing.assert_allclose(result, expected_result, atol=1e-7, rtol=1e-7)
	print("#" * 50)
	print("\033[92m\033[1mTest PASSED for np_times_dq.\033[0m")
	print("#" * 50)
except AssertionError:
	print("#" * 50)
	print("\033[91m\033[1mTest FAILED for np_times_dq.\033[0m")
	print("#" * 50)
	raise AssertionError