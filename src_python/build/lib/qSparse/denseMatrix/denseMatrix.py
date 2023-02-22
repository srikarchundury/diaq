from ..quantumSparseMatrix import quantumSparseMatrix

class denseMatrix:
	def __init__(self, size, array):
		self.size = size
		self.data = array
	
	def getSize(self):
		return self.size

	def set(self, i, j, val):
		self.data[self.size * i + j] = val

	def get(self, i, j):
		return self.data[self.size * i + j]
	
	def print(self):
		for i in range(len(self.data)):
			if((i+1) % self.size == 0):
				print(self.data[i])
			else:
				print(self.data[i], end=",")
	
	def isPartOf(self, dIndex, a, b, x, y):
		p = x - y + b - a
		if(dIndex >= self.size):
			p = x + y - a - b
		return p
	
	def sparsity(self):
		z = 0
		for i in range(len(self.data)):
			if(self.data[i] == 0.0):
				z += 1
		return (float(z)/float(self.data.size())) * 100
	
	def getTargetDiagIndex_onlydiags(self, i, j):
		return j-i

	def __mul__(self, B):
		if self.getSize() != B.getSize():
			return {"error": "unequal matrix sizes"}
		n = self.getSize()
		resArray = [0] * (n * n)
		result = denseMatrix(n, resArray)
		for i in range(n):
			for j in range(n):
				for k in range(n):
					result.set(i, j, result.get(i, j) + self.get(i, k) * B.get(k, j))
		return result

	def convertToQuantumSparse(self):
		qm = quantumSparseMatrix()
		for i in range(self.size):
			for j in range(self.size):
				diagIndx = self.getTargetDiagIndex_onlydiags(i, j)
				qm.addToDiagonal(diagIndx, self.data[i * self.size + j])
		qm.pruneMatrix()
		return qm
