import numpy as np

def tensor_transpose(tensor, axes):
    if len(axes) != len(set(axes)):
        raise ValueError("Duplicate axes are not allowed.")
    if sorted(axes) != list(range(len(axes))):
        raise ValueError("Axes should contain all integers from 0 to n-1.")
    if len(axes) != len(tensor.shape):
        raise ValueError("Axes length must match the tensor's number of dimensions.")

    def transpose_recursive(arr, axes):
        if len(axes) == 2:
            return np.transpose(arr)

        axis = axes[0]
        rest_axes = axes[1:]

        # Permute axes to align the current axis to the front
        arr = np.moveaxis(arr, axis, 0)

        # Calculate the new shape and reshape the array into a matrix
        shape = arr.shape
        new_shape = (shape[0], np.prod(shape[1:]))
        reshaped_arr = np.reshape(arr, new_shape)

        # Transpose the reshaped matrix
        transposed = np.transpose(reshaped_arr)

        # Calculate the new shape after transposition
        new_shape_after_transpose = (shape[0],) + tuple(shape[i] for i in rest_axes)

        # Reshape back into the tensor shape
        transposed = np.reshape(transposed, new_shape_after_transpose)

        # Apply recursive transpose for the rest of the axes
        transposed = transpose_recursive(transposed, rest_axes)

        return transposed

    return transpose_recursive(tensor, axes)

# Example tensor
tensor = np.array([[[1, 2, 3],
                    [4, 5, 6]],
                   [[7, 8, 9],
                    [10, 11, 12]]])

print("Original Tensor:")
print(tensor.shape)

# Transpose the tensor
axes = (2, 1, 0)
result = tensor_transpose(tensor, axes)
print("\nTransposed Tensor:")
print(result.shape)

print("---comparison---")
print(np.transpose(tensor, axes).shape)
print(result.shape)
print(np.transpose(tensor, axes).flatten())
print(result.flatten())
