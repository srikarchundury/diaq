"""DeviceMatrix (diaQ matrices kept in GPU memory) against numpy, and the time saved by uploading A once.

  python python_tests/test_device_matrix.py
"""
import time

import numpy as np

import diaq_gpu as d


def banded(n, offsets, rng):
    A = np.zeros((n, n), complex)
    for off in offsets:
        k = np.arange(max(0, -off), min(n, n - off))
        A[k, k + off] = rng.standard_normal(len(k)) + 1j * rng.standard_normal(len(k))
    return A


rng = np.random.default_rng(0)
n = 2048
A = banded(n, (-3, -1, 0, 2, 5), rng)
B = banded(n, (-7, -2, 0, 3, 11), rng)
x = rng.standard_normal(n) + 1j * rng.standard_normal(n)
dA, dB = d.to_device(d.from_numpy(A)), d.DeviceMatrix(d.from_numpy(B))
rel = lambda a, b: float(np.max(np.abs(a - b)) / np.max(np.abs(b)))
worst = 0.0
worst = max(worst, rel(d.to_numpy(dA.to_host()), A))
worst = max(worst, rel(d.to_numpy_vector(d.spMV(dA, d.from_numpy_vector(x))), A @ x))
worst = max(worst, rel(d.to_numpy(d.product(dA, dB).to_host()), A @ B))
worst = max(worst, rel(d.to_numpy(d.product(d.product(dA, dB), dA).to_host()), A @ B @ A))
worst = max(worst, rel(d.to_numpy(d.product(d.from_numpy(A), d.from_numpy(B))), A @ B))   # host API
single = banded(n, (4,), rng)
worst = max(worst, rel(d.to_numpy_vector(d.spMV(d.to_device(d.from_numpy(single)), d.from_numpy_vector(x))), single @ x))
small = banded(64, (-1, 0, 1), rng) / 4
worst = max(worst, rel(d.to_numpy(d.pow(d.from_numpy(small), 7)), np.linalg.matrix_power(small, 7)))
worst = max(worst, rel(d.to_numpy(d.pow(d.from_numpy(small), 8)), np.linalg.matrix_power(small, 8)))
print("max rel. error", f"{worst:.1e}")
assert worst < 1e-12, worst
try:
    import torch
    if torch.cuda.is_available():
        xr = torch.as_tensor(x.real, device="cuda").contiguous(); xi = torch.as_tensor(x.imag, device="cuda").contiguous()
        yr, yi = torch.empty_like(xr), torch.empty_like(xi)
        d.spmv_device(dA, xr.data_ptr(), xi.data_ptr(), yr.data_ptr(), yi.data_ptr(), torch.cuda.current_stream().cuda_stream)
        torch.cuda.synchronize()
        e = rel((yr + 1j * yi).cpu().numpy(), A @ x)
        print("spmv_device (torch pointers) rel. error", f"{e:.1e}")
        assert e < 1e-12
except ImportError:
    pass
# 200 products with one A: host API (A uploaded every call) vs DeviceMatrix (A uploaded once)
rowsA = banded(4096, (-2, -1, 0, 1, 2), rng)
Ah = d.matrix_kron_identity(d.from_numpy(rowsA), 6)        # 262144 x 262144 with 5 diagonals, built cheaply
xv = d.from_numpy_vector(rng.standard_normal(Ah.matrix_shape[0]) + 0j)
for label, mat in (("host matrix", Ah), ("DeviceMatrix", d.to_device(Ah))):
    d.spMV(mat, xv)
    t = time.perf_counter()
    for _ in range(200):
        d.spMV(mat, xv)
    print(f"200 x spMV, {label}: {time.perf_counter() - t:.3f} s")
print("ok")
