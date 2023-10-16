import numpy as np
a = 0.00000001 * np.arange(0,2**32)
a = a.reshape(2**16, 2**16)
import dia_lite as qs
qa = qs.from_numpy(a.flatten(), a.shape)
res = np.array(qs.to_numpy(qa)).reshape(qa.shape)