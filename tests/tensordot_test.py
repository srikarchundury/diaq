import numpy as np
import diaq as dq

a = np.array([1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0]).reshape(2,2,2,2)
b = np.array([1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0]).reshape(2,2,2,2)

axes = [(2,), (1,)]

res_np = np.tensordot(a, b, axes)

res_dq = dq.tensordot(
    dq.from_numpy(a.flatten(), a.shape),
    dq.from_numpy(b.flatten(), b.shape),
    axes
)

# res_dq.print()

print("Testing tensordot : ", (
    res_np == np.array(dq.to_numpy(res_dq)).reshape(res_dq.shape)
).all())