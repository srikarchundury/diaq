import numpy as np
import dia_lite as qs

a = np.array([1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0]).reshape(2,2,2,2)
b = np.array([1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0]).reshape(2,2,2,2)

axes = [(2,), (1,)]

res_np = np.tensordot(a, b, axes)

res_qs = qs.tensordot(
    qs.from_numpy(a.flatten(), a.shape),
    qs.from_numpy(b.flatten(), b.shape),
    axes
)

print("Testing tensordot : ", (
    res_np == np.array(qs.to_numpy(res_qs)).reshape(res_qs.tensor_shape)
    ).all())