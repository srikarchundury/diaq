import numpy as np
import scipy.linalg
import diaq as dq

# Define a small 2x2 Hermitian matrix
H = np.array([[0.707107, 0.707107],
				[0.707107, -0.707107]], dtype=np.complex128)

# Define time for exponentiation
t = 1.0

# Compute exp(-i * H * t) using scipy for comparison
expected_result = scipy.linalg.expm(-1j * H * t)
print("--")
print("Expected Result (Scipy):")
print(expected_result)
print("--")

# Convert matrix to dq's format
gate = dq.from_numpy(H)
print("--")
print("Gate:")
gate.print()
print("--")

# Compute exp(-i * H * t) using dq's library function
result = dq.expm_negative(gate, t)
print("--")
print("\nResult from dq library:")
result.print()
print("--")

dq_result = dq.to_numpy(result).reshape(2, 2)
print("--")
print("\nResult converted to numpy:")
print(dq_result)
print("--")

# Verify the results are close
if np.allclose(dq_result, expected_result, atol=1e-5):
	print("\nThe results are close! dq's expm_negative function is working as expected.")
else:
	print("\nThere is a discrepancy between the results. Further investigation may be needed.")
