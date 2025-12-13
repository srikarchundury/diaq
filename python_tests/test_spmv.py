import diaq as dq
import numpy as np

# numpy vector of size 2048
x_np = np.random.rand(2048).astype(np.float32)
x_dq = dq.from_numpy_vector(x_np)
# x_dq.print_meta()

mat_np = np.random.rand(2048, 2048).astype(np.float32)
mat_dq = dq.from_numpy(mat_np)
# mat_dq.print_meta()

# correct answer
y_np = x_np
for _ in range(10):
	y_np = mat_np @ y_np

# perform spMV 10 times
y_dq = dq.spMV_ntimes(mat_dq, x_dq, 10)
y_dq_to_np = dq.to_numpy_vector(y_dq)

# verify correctness
assert np.allclose(y_np, y_dq_to_np), "spMV N times result does not match numpy result"
print("spMV N times test passed successfully!")