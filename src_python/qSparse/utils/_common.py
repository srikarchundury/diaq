from ..quantumSparseMatrix import quantumSparseMatrix
from ..diagonal import diagonal

# def einsum(subscripts, *operands):
#     print(subscripts, operands)
#     subscripts_list = subscripts.split('->')
#     input_subscripts = subscripts_list[0].split(',')
#     output_subscripts = subscripts_list[1]

#     # # Check number of input operands matches number of input subscripts
#     # if len(input_subscripts) != len(operands):
#     #     raise ValueError("Number of operands does not match number of input subscripts")

#     # # Check that all subscripts are unique
#     # all_subscripts = ''.join(input_subscripts) + output_subscripts
#     # if len(all_subscripts) != len(set(all_subscripts)):
#     #     raise ValueError("Subscripts must be unique")

#     # Determine the order of each input operand's dimensions
#     input_orders = []
#     for i, subscript in enumerate(input_subscripts):
#         order = []
#         for dim in subscript:
#             order.append(operands[i].shape.index(operands[i].shape[dim]))
#         input_orders.append(order)

#     # Determine the order of the output operand's dimensions
#     output_order = []
#     for dim in output_subscripts:
#         output_order.append(operands[0].shape.index(operands[0].shape[dim]))

#     # Call tensordot with appropriate parameters
#     result = operands[0]
#     for i in range(1, len(operands)):
#         result = tensordot(result, operands[i], axes=(input_orders[i], input_orders[i]))

#     result = transpose(result, output_order)
#     return result

def einsum(expression, *operands):
    print(expression, operands)
    # subscripts = expression.split('->')[0].split(',')
    # output_subscript = expression.split('->')[1] if '->' in expression else None
    # num_operands = len(subscripts)

    # # make sure the number of operands matches the number of subscripts
    # if num_operands != len(operands):
    #     raise ValueError(f"einsum() requires {num_operands} operands but got {len(operands)}")

    # # create a list of axes for each input tensor
    # input_axes = []
    # for subscript in subscripts:
    #     axes = []
    #     for c in subscript:
    #         if c.isalpha():
    #             axes.append(ord(c) - ord('a'))
    #     input_axes.append(axes)

    # # create a list of output axes for the output tensor
    # output_axes = []
    # if output_subscript:
    #     for c in output_subscript:
    #         if c.isalpha():
    #             output_axes.append(ord(c) - ord('a'))

    # # perform the contraction
    # result = operands[0]
    # for i in range(1, num_operands):
    #     tensor = operands[i]
    #     axes = input_axes[i]
    #     # transpose the tensor axes to match the order of the input subscripts
    #     transpose_order = [axes.index(j) for j in range(len(axes))]
    #     tensor = transpose(tensor, transpose_order)
    #     # perform the contraction along the specified axes
    #     result = tensordot(result, tensor, axes=(output_axes, axes))
        
    return None


def transpose(matrix, order=None):
    diagonals = matrix.getDiagonalMap()
    if order is None:
        order = reversed(range(len(diagonals)))

    transposed = {}
    for i in order:
        if i in diagonals:
            transposed[-i] = diagonals[i].getValues().copy()

    for k, v in transposed.items():
        transposed[k] = diagonal(k, v)
    return quantumSparseMatrix(transposed)


def tensordot(a, b, axes=2):
    return None
    # Handle the case where one of the matrices is empty
    if len(a.diagonalMap) == 0 or len(b.diagonalMap) == 0:
        return quantumSparseMatrix({})

    # Handle the case where the axes argument is an integer
    if isinstance(axes, int):
        if axes < 0:
            axes = max(len(a.diagonalMap.getValues()), len(b.diagonalMap.getValues())) + axes
        axes1 = list(range(len(a.diagonalMap.getValues()) - axes, len(a.diagonalMap.getValues())))
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
        if axis in a.diagonalMap:
            size1 *= len(a.diagonalMap[axis].getValues())
    size2 = 1
    for axis in axes2:
        if axis in b.diagonalMap:
            size2 *= len(b.diagonalMap[axis].getValues())

    # Compute the axes to sum over
    sum_axes1 = set(a.diagonalMap.keys()) - set(axes1)
    sum_axes2 = set(b.diagonalMap.keys()) - set(axes2)

    # Compute the resulting diagonal elements
    diagonals = {}
    for diag1 in a.diagonalMap:
        for diag2 in b.diagonalMap:
            new_diag = diag1 + diag2
            if new_diag not in diagonals:
                diagonals[new_diag] = []
            if all(axis in a.diagonalMap for axis in axes1) and all(axis in b.diagonalMap for axis in axes2):
                for i in range(len(a.diagonalMap[diag1].getValues())):
                    for j in range(len(b.diagonalMap[diag2].getValues())):
                        product = a.diagonalMap[diag1][i] * b.diagonalMap[diag2][j]
                        if all(diag not in sum_axes1 and i[axis1] == j[axis2] for axis1, diag in enumerate(a.diagonalMap) for axis2, _ in enumerate(b.diagonalMap)):
                            diagonals[new_diag].append(product)
            else:
                for element1 in a.diagonalMap[diag1].getValues():
                    for element2 in b.diagonalMap[diag2].getValues():
                        product = element1 * element2
                        if all(diag not in sum_axes1 and i[axis1] == j[axis2] for axis1, diag in enumerate(a.diagonalMap) for axis2, _ in enumerate(b.diagonalMap)):
                            diagonals[new_diag].append(product)

    # Create a new quantumSparseMatrix instance with the resulting dictionary
    for k, v in diagonals.items():
        diagonals[k] = diagonal(k, v)
    return quantumSparseMatrix(diagonals)
