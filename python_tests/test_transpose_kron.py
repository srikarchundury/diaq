"""transpose (2-D and tensor permutations) and matrix_kron_identity against numpy, on random sparse inputs.

  python python_tests/run_with_gpu_module.py python_tests/test_transpose_kron.py
"""
import numpy as np

import diaq as dq

rng = np.random.default_rng(1)
worst = 0.0
for trial in range(100):
    r, c = (int(x) for x in rng.integers(1, 10, size=2))
    a = (rng.random((r, c)) < 0.3) * (rng.standard_normal((r, c)) + 1j * rng.standard_normal((r, c)))
    A = dq.from_numpy(a)
    worst = max(worst, float(np.max(np.abs(dq.to_numpy(dq.transpose(A)) - a.T), initial=0.0)))
    n = 1 << int(rng.integers(0, 3))
    K = dq.matrix_kron_identity(dq.from_numpy(a), int(np.log2(n)))
    worst = max(worst, float(np.max(np.abs(dq.to_numpy(K) - np.kron(a, np.eye(n))), initial=0.0)))
print("max abs difference", worst)
assert worst == 0.0
print("ok")

# tensor permutations: rank 3 and 4, result laid out as (first half of the axes) x (second half)
worst = 0.0
for trial in range(60):
    rank = int(rng.integers(3, 5))
    shape = tuple(int(x) for x in rng.integers(2, 4, size=rank))
    t = (rng.random(shape) < 0.3) * (rng.standard_normal(shape) + 1j * rng.standard_normal(shape))
    order = [int(x) for x in rng.permutation(rank)]
    T = dq.from_numpy(t.flatten(), shape)
    got = dq.to_numpy(dq.transpose(T, order))
    p = np.transpose(t, order)
    half = rank // 2
    want = p.reshape(int(np.prod(p.shape[:half])), int(np.prod(p.shape[half:])))
    worst = max(worst, float(np.max(np.abs(got.reshape(want.shape) - want), initial=0.0)))
print("tensor permutations: max abs difference", worst)
assert worst == 0.0
print("ok")
