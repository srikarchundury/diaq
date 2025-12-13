import numpy as np
import diaq as dq

size = 1024
np.random.seed(42)

# Create zero matrices
A = np.zeros((size, size), dtype=np.complex128)
B = np.zeros((size, size), dtype=np.complex128)

# 15 diagonals in A
diag_offsets_A = [0, 4, 8, 16, 32, 64, 128, 256, -4, -8, -16, -32, -64, -128, -256]
for offset in diag_offsets_A:
    diag_len = size - abs(offset)
    values = np.random.rand(diag_len) + 1j * np.random.rand(diag_len)
    A += np.diag(values, k=offset)

# 8 diagonals in B
diag_offsets_B = [1, 16, 32, 512, -1, -16, -32, -512]
for offset in diag_offsets_B:
    diag_len = size - abs(offset)
    values = np.random.rand(diag_len) + 1j * np.random.rand(diag_len)
    B += np.diag(values, k=offset)

C = np.dot(A, B)
correct_dq_C = dq.from_numpy(C)
correct_dq_C.print_meta()

dq_A = dq.from_numpy(A)
dq_B = dq.from_numpy(B)

dq_C = dq.product(dq_A, dq_B)
dq_C.print_meta()

dense_dq_C = dq.to_numpy(dq_C)

np.testing.assert_allclose(dense_dq_C, C, rtol=1e-12, atol=1e-12)