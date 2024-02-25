import numpy as np

def coo_tensordot(A_data, A_coords, B_data, B_coords, axes_A, axes_B):
    # Get dimensions of tensors A and B
    shape_A = tuple(np.max(A_coords, axis=0) + 1)
    shape_B = tuple(np.max(B_coords, axis=0) + 1)

    # Ensure the specified axes are valid
    if not (0 <= axes_A < len(shape_A) and 0 <= axes_B < len(shape_B)):
        raise ValueError("Invalid axes specified.")

    # Determine the sizes of the dimensions to be contracted
    size_A = shape_A[axes_A]
    size_B = shape_B[axes_B]

    # Create empty arrays to represent the result in COO format
    result_data = []
    result_coords = []

    # Iterate over the non-zero entries of A and B
    for i in range(len(A_data)):
        for j in range(len(B_data)):
            # Check if the coordinates along the contracted axes match
            if A_coords[i][axes_A] == B_coords[j][axes_B]:
                # Perform the dot product and store the result
                result_value = A_data[i] * B_data[j]
                result_coord = tuple(
                    coord_A if k != axes_A else coord_B
                    for k, (coord_A, coord_B) in enumerate(zip(A_coords[i], B_coords[j]))
                )
                result_data.append(result_value)
                result_coords.append(result_coord)

    # Convert result_data and result_coords to NumPy arrays
    result_data = np.array(result_data)
    result_coords = np.array(result_coords)

    return result_data, result_coords

# Example tensors in COO format
A_data = np.array([2, 3, 1])
A_coords = np.array([[1, 2, 3], [0, 1, 3], [2, 3, 4]])
B_data = np.array([1, 4, 2])
B_coords = np.array([[0, 2], [1, 3], [2, 4]])

# Choose the axes along which to contract
axes_A = 2  # Choose the axis of tensor A to contract
axes_B = 0  # Choose the axis of tensor B to contract

# Perform the tensor dot product
result_data, result_coords = coo_tensordot(A_data, A_coords, B_data, B_coords, axes_A, axes_B)

# Print the result
print(result_data)
print(result_coords)
