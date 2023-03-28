import numpy as np
import qsparse as qs

a1 = np.arange(16).reshape(2,2,2,2)
a2 = np.arange(16,32).reshape(2,2,2,2)
res1 = np.tensordot(a1,a2,((2,), (1,)))
qres1 = qs.from_numpy(res1.flatten(), res1.shape)
qres1.print() # this should be the actual answer

# converting to our format
qa1 = qs.from_numpy(a1.flatten(), a1.shape)
qa2 = qs.from_numpy(a2.flatten(), a2.shape)

# perform tensordot

# Move the axes to sum over to the end of "q1"
# and to the front of "q2"

# perform reshape to be compatible
qa1_reshaped = qs.reshape(qa1, (8,2))
qa2_reshaped = qs.reshape(qa2, (2,8))

qres2 = qs.product(qa1_reshaped, qa2_reshaped)
qres2.print()    # this is what we are getting


# doing the same thing in numpy
# an1 = a1.reshape(4,4)
# an2 = a2.reshape(4,4)

# permute based on axes?? -- TODO (2,2,2,2) x (2,2,2,2) over (2,) and (1,)
# move 3rd to last in A
# move 1st to first in B
an1 = a1.transpose(0,1,3,2)
an2 = a2.transpose(1,0,2,3)

anres1 = np.dot(an1.reshape(8,2), an2.reshape(2,8))
(anres1.reshape(2,2,2,2,2,2) == res1).all()