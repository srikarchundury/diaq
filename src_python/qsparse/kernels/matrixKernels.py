from ..denseMatrix import denseMatrix
from ..quantumSparseMatrix import quantumSparseMatrix
from ..diagonal import diagonal

import math


def multiplyDiagonals(size, indexA, indexB, diagA, diagB):
	valuesA = diagA.getValues()
	valuesB = diagB.getValues()
	if indexA + indexB >= size:
		return diagonal(0, [])
	elif indexA + indexB <= -1 * size:
		return diagonal(0, [])
	res = diagonal(indexA + indexB, [])
	lenDiagA = size - abs(indexA)
	lenDiagB = size - abs(indexB)
	lenRes = size - abs(indexA + indexB)
	offsetA = abs(indexA)
	offsetB = abs(indexB)
	jump = 0
	if indexA > 0:
		if indexB > 0:
			offsetB = offsetA
			offsetA = 0
		elif indexB < 0:
			if offsetA > offsetB:
				offsetB = abs(indexA + indexB)
				offsetA = 0
			else:
				offsetA = abs(indexA + indexB)
				offsetB = 0
		elif indexB == 0:
			offsetB = offsetA
			offsetA = 0
	elif indexA < 0:
		if indexB > 0:
			if lenDiagB < lenDiagA:
				jump = lenRes - lenDiagB
			elif lenDiagA < lenDiagB:
				jump = lenRes - lenDiagA
			else:
				jump = abs(indexA)
			offsetA = 0
			offsetB = 0
		elif indexB < 0:
			offsetA = offsetB
			offsetB = 0
		elif indexB == 0:
			offsetA = 0
			offsetB = 0
	elif indexA == 0:
		if indexB > 0:
			offsetA = 0
			offsetB = 0
		elif indexB < 0:
			offsetA = offsetB
			offsetB = 0
		elif indexB == 0:
			offsetA = 0
			offsetB = 0
	k = 0
	jump_cpy = jump
	while(jump):
		res.addElement(0)
		jump -= 1
		k += 1
	while(k < lenRes and k + offsetA - jump_cpy < lenDiagA and k + offsetB - jump_cpy < lenDiagB):
		r = valuesA[k + offsetA - jump_cpy] * valuesB[k + offsetB - jump_cpy]
		res.addElement(r)
		k += 1
	while(k < lenRes):
		res.addElement(0)
		k += 1
	return res

def product(A, B):
	if A.getSize() != B.getSize():
		return {"error": "unequal matrix sizes"}
	result = quantumSparseMatrix()
	mapA = A.getDiagonalMap()
	mapB = B.getDiagonalMap()
	for kA, vA in mapA.items():
		for kB, vB in mapB.items():
			diagNew = multiplyDiagonals(A.getSize(), kA, kB, vA, vB)
			if len(diagNew.getValues()) != 0:
				result.addDiagonal(kA + kB, diagNew)
	result.pruneMatrix()
	return result

def denseProduct(A, B):
	if A.getSize() != B.getSize():
		return {"error": "unequal matrix sizes"}
	n = A.getSize()
	resArray = [0] * (n * n)
	result = denseMatrix(n, resArray)
	for i in range(n):
		for j in range(n):
			for k in range(n):
				result.set(i, j, result.get(i, j) + A.get(i, k) * B.get(k, j))
	return result
