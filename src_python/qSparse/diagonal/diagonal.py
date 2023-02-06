

class diagonal:
	def __init__(self, di, values = []):
		self.dIndex = di
		self.values = values

	def getIndex(self):
		return self.dIndex

	def addElement(self, value):
		self.values.append(value)

	def setValue(self, i, val):
		self.values[i] = val

	def getValue(self, i):
		return self.values[i]

	def print(self):
		print("(dIndex=" + str(self.dIndex) + ") [", end ="")
		print(self.values, sep=",", end="")
		print("]")
	
	def getValues(self):
		return self.values
	
	def getCoords(self, matrixSize, dIndex):
		c = [0,0]
		if dIndex > matrixSize:
			c[0] = dIndex - matrixSize + 1
			c[1] = matrixSize - 1
		elif dIndex == 0:
			c[0], c[1] = 0, 0
		elif dIndex < 0:
			c[0], c[1] = -1 * dIndex, 0
		else:
			c[0], c[1] = 0, dIndex
		return c

	def getDIndex(self, coords, matrixSize):
		if coords[0] == 0:
			return coords[1]
		elif coords[1] == 0:
			return coords[0]
		return coords[1]

	def numNonZeros(self):
		count = 0
		for i in range(len(self.values)):
			if self.values[i] != 0:
				count += 1
		return count
