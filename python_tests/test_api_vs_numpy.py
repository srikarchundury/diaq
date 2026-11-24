"""Every main API function against numpy on random diagonal-sparse complex matrices (square and rectangular).

  python python_tests/test_api_vs_numpy.py
Exits 1 and lists the failing checks if any result differs from numpy.
"""
import sys

import numpy as np

import diaq as dq

rng = np.random.default_rng(3)
failures = []


def rand(r, c, n_diags=None, fill=0.7):
    A = np.zeros((r, c), complex)
    offs = rng.choice(np.arange(-(r - 1), c), size=min(n_diags or rng.integers(1, 6), r + c - 1), replace=False)
    for o in offs:
        k = np.arange(max(0, -o), min(r, c - o))
        keep = rng.random(len(k)) < fill
        A[k[keep], k[keep] + o] = rng.standard_normal(keep.sum()) + 1j * rng.standard_normal(keep.sum())
    return A


def check(name, got, want, tol=1e-10):
    got, want = np.asarray(got), np.asarray(want)
    if got.shape != want.shape:
        got = got.reshape(want.shape) if got.size == want.size else got
    scale = max(1.0, float(np.max(np.abs(want), initial=0.0)))
    if got.shape != want.shape or not np.all(np.isfinite(got)):
        failures.append(f"{name}: shape {got.shape} vs {want.shape} or non-finite values")
        return
    err = float(np.max(np.abs(got - want), initial=0.0)) / scale
    if err > tol:
        failures.append(f"{name}: relative error {err:.2e}")


M = lambda a: dq.from_numpy(a)
N = lambda m: np.array(dq.to_numpy(m))
V = lambda x: dq.from_numpy_vector(x)
NV = lambda v: np.array(dq.to_numpy_vector(v))

for trial in range(25):
    r, c, k = (int(x) for x in rng.integers(2, 12, size=3))
    A, A2, B = rand(r, c), rand(r, c), rand(c, k)
    S = rand(r, r)
    x = rng.standard_normal(c) + 1j * rng.standard_normal(c)
    check("round trip", N(M(A)), A)
    check("add", N(dq.add(M(A), M(A2))), A + A2)
    check("multiply_by_scalar", N(dq.multiply_by_scalar(M(A), 0.5, -2.0)), A * (0.5 - 2j))
    check("adjoint", N(dq.adjoint(M(A))), A.conj().T)
    check("transpose", N(dq.transpose(M(A))), A.T)
    check("product", N(dq.product(M(A), M(B))), A @ B)
    check("spMV", NV(dq.spMV(M(A), V(x))), A @ x)
    check("trace", dq.trace(M(S)), np.trace(S))
    check("pow 3", N(dq.pow(M(S / 4), 3)), np.linalg.matrix_power(S / 4, 3))
    check("pow 4", N(dq.pow(M(S / 4), 4)), np.linalg.matrix_power(S / 4, 4))
    B2 = rand(int(rng.integers(2, 5)), int(rng.integers(2, 5)))
    check("kroneckerProduct", N(dq.kroneckerProduct(M(A), M(B2))), np.kron(A, B2))
    s1, s2 = (int(v) for v in rng.integers(0, 3, size=2))
    I1, I2 = np.eye(1 << s1), np.eye(1 << s2)
    Sq = rand(r, r)
    check("identity_kron_matrix", N(dq.identity_kron_matrix(s1, M(Sq))), np.kron(I1, Sq))
    check("matrix_kron_identity", N(dq.matrix_kron_identity(M(Sq), s2)), np.kron(Sq, I2))
    check("identity_kron_matrix_kron_identity", N(dq.identity_kron_matrix_kron_identity(s1, M(Sq), s2)),
          np.kron(np.kron(I1, Sq), I2))
    big = np.kron(np.kron(I1, Sq), I2)
    xb = rng.standard_normal(big.shape[1]) + 1j * rng.standard_normal(big.shape[1])
    y = V(np.zeros(big.shape[0], complex))
    check("identity_kron_matrix_kron_identity_times_vector",
          NV(dq.identity_kron_matrix_kron_identity_times_vector(s1, M(Sq), s2, V(xb), y)), big @ xb)
    y = V(np.zeros(Sq.shape[0] << s1, complex))
    xi = rng.standard_normal(Sq.shape[1] << s1) + 0j
    check("identity_kron_matrix_times_vector", NV(dq.identity_kron_matrix_times_vector(s1, M(Sq), V(xi), y)),
          np.kron(I1, Sq) @ xi)
    y = V(np.zeros(Sq.shape[0] << s2, complex))
    xm = rng.standard_normal(Sq.shape[1] << s2) + 0j
    check("matrix_kron_identity_times_vector", NV(dq.matrix_kron_identity_times_vector(M(Sq), s2, V(xm), y)),
          np.kron(Sq, I2) @ xm)

try:
    from scipy.linalg import expm
    for trial in range(5):
        n = int(rng.integers(2, 10))
        H = rand(n, n, 3)
        H = (H + H.conj().T) / 8
        check("expm", N(dq.expm(M(H), 100, 1.0, 1e-14)), expm(H), 1e-8)
        check("expm_negative (exp(-i t H))", N(dq.expm_negative(M(H), 0.3, 100, 1.0, 1e-14)), expm(-1j * 0.3 * H),
              1e-8)
except ImportError:
    print("scipy not installed: expm checks skipped")

if failures:
    from collections import Counter
    for name, count in Counter(f.split(":")[0] for f in failures).items():
        print(f"FAILED {name} ({count} cases), e.g. {next(f for f in failures if f.startswith(name))}")
    sys.exit(1)
print("ok")
