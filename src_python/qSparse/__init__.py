"""
qsparse.

"""

__version__ = "0.0.1"
__author__ = 'Srikar Chundury'
__credits__ = 'North Carolina State University'


from .benchmark import benchmark
from .denseMatrix import denseMatrix
from .diagonal import diagonal
from .kernels import matrixKernels, vectorKernels
from .kernels import matrixKernels, vectorKernels
from .utils import *
# from .vector import vector


def to_qsparse(array):
	# Convert the ndarray to a dictionary of non-empty diagonals
    import numpy as np
    diagonals = {}
    for i in range(-array.shape[0]+1, array.shape[1]):
        d = array.diagonal(i)
        if not np.all(d == 0):
            diagonals[i] = d.tolist()

    # Create a new quantumSparseMatrix instance from the dictionary of diagonals
    for k, v in diagonals.items():
        diagonals[k] = diagonal(k, v)
    return quantumSparseMatrix(diagonals, array.shape)

