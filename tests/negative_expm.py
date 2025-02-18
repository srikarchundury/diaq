import diaq as dq
import numpy as np
from scipy.linalg import expm

H = np.diag([1, 2, 3, 4, 5])
t = 1.6
print(H)
print("--")
dq_H = dq.from_numpy(H)
dq_H.print()
print("--")


print("--")
print("Correct expm:")
correct_U = expm(-1j * H * t)
print(correct_U)


print("--")
print("Correct expm:")
dq_correct_U = dq.from_numpy(correct_U)
dq_correct_U.print()

print("--")
print("--")
print("DIAQ expm:")
dq_U = dq.expm_negative(dq_H, t)
dq_U.print()
print("--")
