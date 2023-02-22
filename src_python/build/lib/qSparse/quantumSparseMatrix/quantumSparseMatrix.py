from ..diagonal import diagonal
from ..denseMatrix import denseMatrix

from ..clib import qSparseLib


class quantumSparseMatrix:
	def __init__(self, diagonals={}, shape=None):
		# mapping b/w diagonal index and a diagonal object
		print(qSparseLib)
		self.diagonalMap = diagonals
		self.shape = shape

	def getDiagonalMap(self):
		return self.diagonalMap

	def print(self):
		for k, v in self.diagonalMap.items():
			v.print()
	
	def createDiagonal(self, dIndex):
		if dIndex not in self.diagonalMap.keys():
			diagObj = diagonal(dIndex, [])
			self.diagonalMap[dIndex] = diagObj
		else:
			return {"error": "diagonal with index already exists"}
	
	def getDiagonal(self, dIndex):
		if dIndex not in self.diagonalMap.keys():
			self.createDiagonal(dIndex)
		return self.diagonalMap[dIndex]

	def addToDiagonal(self, dIndex, val):
		self.getDiagonal(dIndex).addElement(val)
	
	def setDiagonal(self, dIndex, diagNew):
		self.diagonalMap[dIndex] = diagNew
	
	def addDiagonal(self, dIndex, diagNew):
		if dIndex not in self.diagonalMap.keys():
			self.setDiagonal(dIndex, diagNew)
		else:
			diag = self.getDiagonal(dIndex)
			vals = diag.getValues()
			for i in range(len(vals)):
				diag.setValue(i, vals[i] + diagNew.getValue(i))

	def pruneMatrix(self):
		to_del = []
		for k, v in self.diagonalMap.items():
			counter = 0
			vals = v.getValues()
			for i in range(len(vals)):
				if vals[i] == 0.0:
					counter += 1
				else:
					break
			if counter == len(vals):
				to_del.append(k)
		for each in to_del:
			del self.diagonalMap[each]

	def convertToDenseMatrix(self, matrixSize):
		data = []
		for k, v in self.diagonalMap.items():
			vals = v.getValues()
			if k == 0:
				x = 0
				y = 0
			elif k > 0:
				x = 0
				y = k
			else:
				x = -1 * k
				y = 0
			for i in range(len(vals)):
				data[matrixSize * x + y] = vals[i]
				x += 1
				y += 1
		return data
	

	def __mul__(self, other):
    	# Check if the matrices are compatible for multiplication
		if len(self.diagonalMap) == 0 or len(other.diagonalMap) == 0:
			return quantumSparseMatrix({})
		if max(self.diagonalMap.keys()) < -min(other.diagonalMap.keys()) or min(self.diagonalMap.keys()) > -max(other.diagonalMap.keys()):
			return quantumSparseMatrix({})

        # Create a dictionary to store the result
		result = {}

        # Multiply each diagonal of self with the diagonals of other
		for diag1 in self.diagonalMap:
			for diag2 in other.diagonalMap:
				if diag1 + diag2 not in result:
					result[diag1 + diag2] = []

                # Multiply each pair of elements that lie on the same row and column
				for i in range(len(self.diagonalMap[diag1].getValues())):
					for j in range(len(other.diagonalMap[diag2].getValues())):
						result[diag1 + diag2].append(self.diagonalMap[diag1].getValues()[i] * other.diagonalMap[diag2].getValues()[j])

        # Create a new quantumSparseMatrix instance with the resulting dictionary
		for k, v in result.items():
			result[k] = diagonal(k, v)
		return quantumSparseMatrix(result)
	
	def pack(self):
		return qSparseLib