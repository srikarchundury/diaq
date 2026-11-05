"""matrix_reshape (module function and in-place method) against numpy's row-major reshape, on random sparse
matrices; run many times to catch the earlier heap corruption.

  python python_tests/test_matrix_reshape.py            (CPU module diaq)
  python python_tests/run_with_gpu_module.py python_tests/test_matrix_reshape.py
"""
import numpy as np

import diaq as dq

rng = np.random.default_rng(0)
worst = 0.0
for trial in range(200):
    r, c = (int(x) for x in rng.integers(1, 12, size=2))
    a = (rng.random((r, c)) < 0.3) * (rng.standard_normal((r, c)) + 1j * rng.standard_normal((r, c)))
    n = r * c
    divisors = [d for d in range(1, n + 1) if n % d == 0]
    r2 = int(rng.choice(divisors))
    c2 = n // r2
    A = dq.from_numpy(a)
    B = dq.to_numpy(dq.matrix_reshape(A, (r2, c2)))
    worst = max(worst, float(np.max(np.abs(B - a.reshape(r2, c2)), initial=0.0)))
    A2 = dq.from_numpy(a)
    same = A2.matrix_reshape((r2, c2))           # in place, returns the matrix
    worst = max(worst, float(np.max(np.abs(dq.to_numpy(same) - a.reshape(r2, c2)), initial=0.0)))
print("max abs difference", worst)
assert worst == 0.0
print("ok")
