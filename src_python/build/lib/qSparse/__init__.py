"""
qSparse.

"""

__version__ = "0.0.1"
__author__ = 'Srikar Chundury'
__credits__ = 'North Carolina State University'


from .benchmark import benchmark
from .denseMatrix import denseMatrix
from .diagonal import diagonal
from .kernels import matrixKernels, vectorKernels
from .quantumSparseMatrix import quantumSparseMatrix
# from .vector import vector


def to_qSparse(array):
	a = []
	for i in range(array.shape[0]):
		for j in range(d=array.shape[1]):
			a.append(array[i][j])
	return denseMatrix(array.shape[0], a).convertToQuantumSparse(array.shape[0])
