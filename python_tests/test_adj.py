import numpy as np
import sys
from colorama import Fore, Style

# -----------------------------------------------------------------------------
# Usage
# -----------------------------------------------------------------------------
if len(sys.argv) != 3:
	print(f"Usage: python {sys.argv[0]} [matrix_size] ['gpu' or 'cpu']")
	sys.exit(1)

n = int(sys.argv[1])
backend = sys.argv[2].lower()

if backend not in ["cpu", "gpu"]:
	print("Backend must be either 'cpu' or 'gpu'")
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
# Reference: NumPy adjoint (conjugate transpose)
# -----------------------------------------------------------------------------
A_adj_np = np.conj(A_np.T)

# -----------------------------------------------------------------------------
# diaQ: adjoint
# -----------------------------------------------------------------------------
A_adj_dq = dq.adjoint(A_dq)
A_adj_dq_np = dq.to_numpy(A_adj_dq)

# -----------------------------------------------------------------------------
# Correctness check
# -----------------------------------------------------------------------------
try:
	np.testing.assert_allclose(
		A_adj_np,
		A_adj_dq_np,
		rtol=1e-5,
		atol=1e-5
	)
	print(Fore.GREEN + f"adjoint test passed! (n={n}, backend={backend})" + Style.RESET_ALL)
except AssertionError as e:
	print(Fore.RED + f"adjoint test failed! (n={n}, backend={backend})" + Style.RESET_ALL)
	print(e)
	sys.exit(2)
