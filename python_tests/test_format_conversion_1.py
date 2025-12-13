import numpy as np
import sys
from colorama import Fore, Style

n_qubits = int(sys.argv[1]) if len(sys.argv) > 1 else 8

a = np.random.rand(2**n_qubits).astype(np.complex128)
print(type(a))
a = a.reshape(2**(n_qubits//2), 2**(n_qubits//2))
print(a.shape)

import diaq as dq

dq_a = dq.from_numpy(a)

dq_a.print()
dense_a = dq.to_numpy(dq_a)
print(dense_a)

res = np.array(dense_a).reshape(dq_a.shape)
print(res)

# Compare the original and the converted arrays
try:
	np.testing.assert_array_equal(a, res)
	print(Fore.GREEN + "Test passed" + Style.RESET_ALL)
except AssertionError:
	print(Fore.RED + "Test failed" + Style.RESET_ALL)