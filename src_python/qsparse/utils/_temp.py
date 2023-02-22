import numpy as np

class quantumSparseMatrix:
    def __init__(self, diagonals):
        self.diagonals = diagonals

    def __mul__(self, other):
        # Check if the matrices are compatible for multiplication
        if len(self.diagonals) == 0 or len(other.diagonals) == 0:
            return quantumSparseMatrix({})
        if max(self.diagonals.keys()) < -min(other.diagonals.keys()) or min(self.diagonals.keys()) > -max(other.diagonals.keys()):
            return quantumSparseMatrix({})

        # Create a dictionary to store the result
        result = {}

        # Multiply each diagonal of self with the diagonals of other
        for diag1 in self.diagonals:
            for diag2 in other.diagonals:
                if diag1 + diag2 not in result:
                    result[diag1 + diag2] = []

                # Multiply each pair of elements that lie on the same row and column
                for i in range(len(self.diagonals[diag1])):
                    for j in range(len(other.diagonals[diag2])):
                        result[diag1 + diag2].append(self.diagonals[diag1][i] * other.diagonals[diag2][j])

        # Create a new quantumSparseMatrix instance with the resulting dictionary
        return quantumSparseMatrix(result)


def quantumSparseMatrix_tensordot(a, b, axes=2):
    # Handle the case where one of the matrices is empty
    if len(a.diagonals) == 0 or len(b.diagonals) == 0:
        return quantumSparseMatrix({})

    # Handle the case where the axes argument is an integer
    if isinstance(axes, int):
        if axes < 0:
            axes = max(len(a.diagonals), len(b.diagonals)) + axes
        axes1 = list(range(len(a.diagonals) - axes, len(a.diagonals)))
        axes2 = list(range(axes))

    # Handle the case where the axes argument is a tuple of integers
    elif isinstance(axes, tuple):
        axes1, axes2 = axes
        if isinstance(axes1, int):
            axes1 = [axes1]
        if isinstance(axes2, int):
            axes2 = [axes2]

    # Handle the case where the axes argument is a tuple of tuples
    elif isinstance(axes, tuple) and len(axes) == 2 and isinstance(axes[0], tuple) and isinstance(axes[1], tuple):
        axes1, axes2 = axes

    # Compute the size of the resulting tensor
    size1 = 1
    for axis in axes1:
        if axis in a.diagonals:
            size1 *= len(a.diagonals[axis])
    size2 = 1
    for axis in axes2:
        if axis in b.diagonals:
            size2 *= len(b.diagonals[axis])

    # Compute the axes to sum over
    sum_axes1 = set(a.diagonals.keys()) - set(axes1)
    sum_axes2 = set(b.diagonals.keys()) - set(axes2)

    # Compute the resulting diagonal elements
    diagonals = {}
    for diag1 in a.diagonals:
        for diag2 in b.diagonals:
            new_diag = diag1 + diag2
            if new_diag not in diagonals:
                diagonals[new_diag] = []
            if all(axis in a.diagonals for axis in axes1) and all(axis in b.diagonals for axis in axes2):
                for i in range(len(a.diagonals[diag1])):
                    for j in range(len(b.diagonals[diag2])):
                        product = a.diagonals[diag1][i] * b.diagonals[diag2][j]
                        if all(diag not in sum_axes1 and i[axis1] == j[axis2] for axis1, diag in enumerate(a.diagonals) for axis2, _ in enumerate(b.diagonals)):
                            diagonals[new_diag].append(product)
            else:
                for element1 in a.diagonals[diag1]:
                    for element2 in b.diagonals[diag2]:
                        product = element1 * element2
                        if all(diag not in sum_axes1 and i[axis1] == j[axis2] for axis1, diag in enumerate(a.diagonals) for axis2, _ in enumerate(b.diagonals)):
                            diagonals[new_diag].append(product)

    # Create a new quantumSparseMatrix instance with the resulting dictionary
    return quantumSparseMatrix(diagonals)


def multiply_dense_matrices(matrix1, matrix2):
    result = np.dot(matrix1, matrix2)
    return result

# Example matrices
quantumSparseMatrix1 = quantumSparseMatrix({
    0: [1, 3, 5, 7],
    1: [2, 4, 6]
})

quantumSparseMatrix2 = quantumSparseMatrix({
    0: [1, 3, 5],
    -1: [2, 4, 6],
    1: [8]
})

denseMatrix1 = np.array([[1, 2, 0, 0],
                        [0, 3, 4, 0],
                        [0, 0, 5, 6],
                        [0, 0, 0, 7]])

denseMatrix2 = np.array([[1, 0, 0],
                        [0, 2, 0],
                        [0, 0, 3],
                        [4, 5, 6]])

# Test the quantumSparseMatrix multiplication
result1 = quantumSparseMatrix1 * quantumSparseMatrix2
print("Quantum Sparse Matrix multiplication result:")
print(result1.diagonals)

# Test the dense matrix multiplication
result2 = multiply_dense_matrices(denseMatrix1, denseMatrix2)
print("Dense matrix multiplication result:")
print(result2)


def ndarray_to_quantumSparseMatrix(array):
    # Convert the ndarray to a dictionary of non-empty diagonals
    diagonals = {}
    for i in range(-array.shape[0]+1, array.shape[1]):
        diagonal = array.diagonal(i)
        if not np.all(diagonal == 0):
            diagonals[i] = diagonal.tolist()

    # Create a new quantumSparseMatrix instance from the dictionary of diagonals
    return quantumSparseMatrix(diagonals)
