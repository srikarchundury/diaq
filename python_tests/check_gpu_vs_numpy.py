"""GPU spMV, dq_times_np and product (SpGEMM) against numpy on a random 9-diagonal complex matrix:
  python python_tests/check_gpu_vs_numpy.py
"""
import time, numpy as np, diaq_gpu as d
rng = np.random.default_rng(0); n = 4096
A = np.zeros((n, n), complex)
for off in range(-4, 5):
    k = np.arange(max(0, -off), min(n, n - off)); A[k, k + off] = rng.standard_normal(len(k)) + 1j * rng.standard_normal(len(k))
x = rng.standard_normal(n) + 1j * rng.standard_normal(n)
B = rng.standard_normal((n, 64)) + 1j * rng.standard_normal((n, 64))
M = d.from_numpy(A)
y = d.to_numpy_vector(d.spMV(M, d.from_numpy_vector(x)))
print('spMV max rel err', np.max(np.abs(y - A @ x)) / np.max(np.abs(A @ x)))
C = d.dq_times_np(M, B)
print('dq_times_np max rel err', np.max(np.abs(C - A @ B)) / np.max(np.abs(A @ B)))
P = d.to_numpy(d.product(M, M))
print('product max rel err', np.max(np.abs(P - A @ A)) / np.max(np.abs(A @ A)))
# product of two matrices with different diagonal sets (pairs summing to the same result diagonal)
A2 = np.zeros((n, n), complex)
for off in (-7, -2, 0, 3, 11):
    k = np.arange(max(0, -off), min(n, n - off)); A2[k, k + off] = rng.standard_normal(len(k)) + 1j * rng.standard_normal(len(k))
P2 = d.to_numpy(d.product(M, d.from_numpy(A2)))
print('product (mixed diagonals) max rel err', np.max(np.abs(P2 - A @ A2)) / np.max(np.abs(A @ A2)))
