import numpy as np
a = np.arange(0, 2**8)
a = a.reshape(2**4, 2**4)
import diaq as dq
dq_a = dq.from_numpy(a.flatten(), a.shape)
dq_a.print()
res = np.array(dq.to_numpy(dq_a)).reshape(dq_a.shape)