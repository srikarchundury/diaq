import numpy as np

def tensordot(a, b, axes):
    # Permute axes
    a_permuted = np.transpose(a, axes[0])
    b_permuted = np.transpose(b, axes[1])
    
    # Compute shape of resulting tensor
    result_shape = a_permuted.shape[:-len(axes[0])] + b_permuted.shape[len(axes[1]):]
    
    # Reshape tensors
    a_reshaped = a_permuted.reshape(-1, np.prod(a_permuted.shape[-len(axes[0]):]))
    b_reshaped = b_permuted.reshape(np.prod(b_permuted.shape[:-len(axes[1])]), -1)
    
    # Perform element-wise multiplication
    result = np.dot(a_reshaped, b_reshaped)
    
    # Summation along contracted axes
    result = np.sum(result, axis=-1)
    
    # Reshape result
    result = result.reshape(result_shape)
    
    return result

A = np.array([[[1, 2], [3, 4]], [[5, 6], [7, 8]], [[9, 10], [11, 12]]])
B = np.array([[[0, 1], [2, 3]], [[4, 5], [6, 7]], [[8, 9], [10, 11]]])

axes = ((1,), (2,))  # Use tuples instead of lists for axes

result_tensor = tensordot(A, B, axes)
print(result_tensor)
