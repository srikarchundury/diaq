import diaq as dq
import numpy as np
import sys
from colorama import Fore, Style

# print help to use sys.argv[0]
if len(sys.argv) != 2:
	print(f"Usage: python {sys.argv[0]} [vector_size]")
	exit(1)

vec_size = int(sys.argv[1])
x_np = np.random.rand(vec_size) + 1j * np.random.rand(vec_size)
x_dq = dq.from_numpy_vector(x_np)
# x_dq.print_meta()

mat_np = np.random.rand(vec_size, vec_size)
mat_dq = dq.from_numpy(mat_np)
mat_dq.print_meta()

# correct answer
y_np = mat_np @ x_np

# perform spMV 10 times
y_dq = dq.spMV(mat_dq, x_dq)
y_dq_to_np = dq.to_numpy_vector(y_dq)

# verify correctness
try:
	np.testing.assert_allclose(y_np, y_dq_to_np, rtol=1e-5, atol=1e-5)
	print(Fore.GREEN + "spMV test passed!" + Style.RESET_ALL)
except AssertionError as e:
	print(Fore.RED + "spMV test failed!" + Style.RESET_ALL)
	print(e)
