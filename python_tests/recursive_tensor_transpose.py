import numpy as np
import diaq as dq

def matrix_transpose(matrix):
	return np.transpose(matrix)

def tensor_transpose(tensor, axes=None):
	if len(tensor.shape) == 2:
		return matrix_transpose(tensor)
	else:
		if axes is None:
			axes = list(range(len(tensor.shape)))
		transposed_dims = tuple(tensor.shape[axis] for axis in axes)
		transposed_tensor = np.zeros(transposed_dims, dtype=tensor.dtype)
		for i in range(tensor.shape[0]):
			indices = [slice(None)] * len(axes)
			indices[axes[0]] = i
			smaller_tensor = tensor[tuple(indices)]
			print("smaller_tensor:", smaller_tensor.shape)
			print("smaller_tensor:", smaller_tensor)
			transposed_smaller_tensor = tensor_transpose(smaller_tensor, axes[1:])
			print("transposed_smaller_tensor:", transposed_smaller_tensor.shape)
			print("transposed_smaller_tensor:", transposed_smaller_tensor)
			indices[axes[0]] = slice(None)  # Resetting the index for assignment
			indices[axes[1]] = i
			transposed_tensor[tuple(indices)] = transposed_smaller_tensor
		return transposed_tensor

sample_tensor = np.array([
	[[1, 2], [3, 4]],
	[[5, 6], [7, 8]],
	[[9, 10], [11, 12]]
])

# Transpose the tensor
print("Original tensor:", sample_tensor)
print("Original dims:", sample_tensor.shape)
print("------")
result = tensor_transpose(sample_tensor)
print("Transposed tensor using recursion:", result)
print("Transposed dims:", result.shape)
print("------")
print("------")
result_numpy = np.transpose(sample_tensor)
print("Original tensor using numpy:", np.array(sample_tensor))
print("Original dims:", np.array(sample_tensor).shape)
print("Transposed tensor using numpy:", result_numpy)
print("dims:", result_numpy.shape)
print("----")
# result_diaq = dq.transpose(sample_tensor)
# print("Transposed tensor using diaq:", result_diaq)