"""tensordot against numpy.tensordot on random sparse tensors (rank 2-4, one or two contracted axes).

  python python_tests/test_tensordot_random.py
"""
import numpy as np

import diaq as dq

rng = np.random.default_rng(2)
worst = 0.0
for trial in range(150):
    ra, rb = (int(x) for x in rng.integers(2, 5, size=2))
    k = int(rng.integers(1, min(ra, rb, 2) + 1))
    shared = [int(x) for x in rng.integers(2, 4, size=k)]
    sa = [int(x) for x in rng.integers(2, 4, size=ra)]
    sb = [int(x) for x in rng.integers(2, 4, size=rb)]
    axa = [int(x) for x in rng.choice(ra, size=k, replace=False)]
    axb = [int(x) for x in rng.choice(rb, size=k, replace=False)]
    for i, (p, q) in enumerate(zip(axa, axb)):
        sa[p] = sb[q] = shared[i]
    a = (rng.random(sa) < 0.4) * (rng.standard_normal(sa) + 1j * rng.standard_normal(sa))
    b = (rng.random(sb) < 0.4) * (rng.standard_normal(sb) + 1j * rng.standard_normal(sb))
    want = np.tensordot(a, b, (axa, axb))
    res = dq.tensordot(dq.from_numpy(a.flatten(), a.shape), dq.from_numpy(b.flatten(), b.shape), axes=[axa, axb])
    got = np.array(dq.to_numpy(res)).reshape(want.shape)
    worst = max(worst, float(np.max(np.abs(got - want), initial=0.0)))
print("max abs difference", worst)
assert worst < 1e-12, worst
print("ok")
