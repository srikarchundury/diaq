import numpy as np
import sys
from colorama import Fore, Style

# -----------------------------------------------------------------------------
# Usage
# -----------------------------------------------------------------------------
if len(sys.argv) != 4:
	print(f"Usage: python {sys.argv[0]} [matrix_size] [power_n] ['gpu' or 'cpu']")
	sys.exit(1)

n = int(sys.argv[1])
p = int(sys.argv[2])
backend = sys.argv[3].lower()

if backend not in ["cpu", "gpu"]:
	print("Backend must be either 'cpu' or 'gpu'")
	sys.exit(1)

if p < 0:
	print("power_n must be >= 0")
	sys.exit(1)

if backend == "cpu":
	import diaq as dq
else:
	import diaq_gpu as dq

# -----------------------------------------------------------------------------
# Build random matrix
# -----------------------------------------------------------------------------
np.random.seed(0)

A_np = np.random.rand(n, n).astype(np.float64)
A_dq = dq.from_numpy(A_np)

A_dq.print_meta()

# -----------------------------------------------------------------------------
# Reference: NumPy matrix power
# -----------------------------------------------------------------------------
A_pow_np = np.linalg.matrix_power(A_np, p)

# -----------------------------------------------------------------------------
# diaQ: matrix power
# -----------------------------------------------------------------------------
A_pow_dq = dq.pow(A_dq, p)
A_pow_dq_np = dq.to_numpy(A_pow_dq)

# -----------------------------------------------------------------------------
# Correctness check
# -----------------------------------------------------------------------------
try:
	np.testing.assert_allclose(
		A_pow_np,
		A_pow_dq_np,
		rtol=1e-5,
		atol=1e-5
	)
	print(Fore.GREEN + f"pow test passed! (n={n}, p={p}, backend={backend})" + Style.RESET_ALL)
except AssertionError as e:
	print(Fore.RED + f"pow test failed! (n={n}, p={p}, backend={backend})" + Style.RESET_ALL)
	print(e)
	sys.exit(2)
