from ..diagonal import diagonal

class quantumSparseMatrix:
	def __init__(self, s):
		# mapping b/w diagonal index and a diagonal object
		self.diagonalMap = {}
		self.size = s
	
	def getSize(self):
		return self.size

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
				data[self.size * x + y] = vals[i]
				x += 1
				y += 1
		return data
