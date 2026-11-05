"""spmm_dia_device (DIA x dense on GPU data pointers) against a dense product, through torch tensors on the GPU.
Plain script (this directory has a pytest.py that shadows the pytest package):

  python python_tests/test_spmm_dia_device.py
"""
import torch

import diaq_gpu

CASES = [(4096, 4096, 64, [-3, -1, 0, 2, 5]), (1000, 1200, 1, [0, 7, -9]), (300, 200, 17, list(range(-40, 41, 3))),
         (64, 64, 3, list(range(-63, 64)))]


def check(dtype, M, K, R, offs):
    torch.manual_seed(0)
    off = torch.tensor(offs, dtype=torch.int64, device="cuda")
    r = torch.arange(M, device="cuda")
    V = torch.randn(len(offs), M, dtype=dtype, device="cuda")
    A = torch.zeros(M, K, dtype=dtype, device="cuda")
    for k, o in enumerate(offs):
        ok = (r + o >= 0) & (r + o < K)
        V[k][~ok] = 0
        A[r[ok], r[ok] + o] = V[k][ok]
    B = torch.randn(K, R, dtype=dtype, device="cuda")
    C = torch.empty(M, R, dtype=dtype, device="cuda")
    diaq_gpu.spmm_dia_device(off.data_ptr(), V.data_ptr(), len(offs), M, K, B.data_ptr(), R, C.data_ptr(),
                             dtype.is_complex, torch.cuda.current_stream().cuda_stream)
    ref = A @ B
    return float((C - ref).abs().max() / ref.abs().max())


if __name__ == "__main__":
    worst = 0.0
    for dtype in (torch.complex128, torch.float64):
        for case in CASES:
            err = check(dtype, *case)
            worst = max(worst, err)
            print(dtype, case[:3], len(case[3]), "diagonals: max rel. error", f"{err:.1e}")
    assert worst < 1e-13, worst
    print("ok")
