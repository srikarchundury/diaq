import numpy as np
import diaq as dq

a = np.array([1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0]).reshape(2,2,2,2)
b = np.array([1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0]).reshape(2,2,2,2)

axes = [(2,), (1,)]

res_np = np.tensordot(a, b, axes)

a_dq = dq.from_numpy(a.flatten(), a.shape)
a_dq.print()
b_dq = dq.from_numpy(b.flatten(), b.shape)
b_dq.print()

res_dq = dq.tensordot(
	a_dq, b_dq, axes=axes
)

res_dq.print()

res_dq.print_meta()

same = bool((res_np == np.array(dq.to_numpy(res_dq)).reshape(res_dq.shape)).all())
print("Testing tensordot : ", same)
assert same, "tensordot differs from numpy.tensordot"
