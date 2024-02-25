import numpy as np
import diaq as dq

a = np.array([1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0]).reshape(2,2,2,2)
b = np.array([1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0]).reshape(2,2,2,2)

a_dq = dq.from_numpy(a.flatten(), a.shape)
print("a_dq:")
a_dq.print()
print()
b_dq = dq.from_numpy(b.flatten(), b.shape)
print("b_dq:")
b_dq.print()
print()


reshaped_a_dq = dq.reshape(a_dq, (8, 2))
print("reshaped_a_dq:")
reshaped_a_dq.print()
print()

reshaped_b_dq = b_dq.reshape((1, 16))
print("reshaped_b_dq:")
reshaped_b_dq.print()
print()


reshaped_a_dq = dq.matrix_reshape(a_dq, (8, 2))
print("matrix reshaped_a_dq:")
reshaped_a_dq.print()
print()

reshaped_b_dq = b_dq.matrix_reshape((1, 16))
print("reshaped_b_dq:")
reshaped_b_dq.print()
print()