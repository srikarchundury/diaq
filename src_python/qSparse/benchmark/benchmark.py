from ..denseMatrix import denseMatrix
from ..kernels import denseProduct, product

from scipy.io import mmread
import numpy as np


class benchmark:
	def __init__(self):
		self.data_dir = "../../data"
	
	def getDenseMatrix(self, npz_path):
		arr = np.load(npz_path, "arr_0")
		arr = arr["arr_0"]
		array = []
		for i in range(arr.shape[0]):
			for j in range(arr.shape[1]):
				array.append(arr[i][j])
		return denseMatrix(arr.shape[0], array)

	def prepare(self, circuit, qubits, num_gates):
		if circuit == "vqeprep":
			dir = self.data_dir + "/benchmarks/" + circuit + "/" + qubits + "/"
		if circuit == "qaoa":
			dir = self.data_dir + "/other/" + circuit + "/" + qubits + "/"
		else:
			dir = self.data_dir + "/benchmarks/" + circuit + "/" + qubits + "/"

		matrices = []
		for i in range(1, num_gates+1):
			d = self.getDenseMatrix(dir + "gate_" + str(i) + ".npz")
			m = d.convertToQuantumSparse(pow(2, int(qubits)))
			matrices.append(m)
		return matrices

	def performMultiplications(self, matrices):
		result = product(matrices[1], matrices[0])
		for i in range(2, len(matrices)):
			result = product(matrices[i], result)
		return result

	def performDenseMultiplications(self, matrices):
		result = denseProduct(matrices[1], matrices[0])
		for i in range(2, len(matrices)):
			result = denseProduct(matrices[i], result)
		return result

	def prepareDense(self, circuit, qubits, num_gates):
		if circuit == "vqeprep":
			dir = self.data_dir + "/benchmarks/" + circuit + "/" + qubits + "/"
		if circuit == "qaoa":
			dir = self.data_dir + "/other/" + circuit + "/" + qubits + "/"
		else:
			dir = self.data_dir + "/benchmarks/" + circuit + "/" + qubits + "/"

		matrices = []
		for i in range(1, num_gates+1):
			d = self.getDenseMatrix(dir + "gate_" + str(i) + ".npz")
			matrices.append(d)

		return matrices

	def checkResult(self, A, B):
		errors = []
		if A.getSize() != B.getSize():
			print("sizes don't match - ", A.getSize(), B.getSize())
			errors.append(1)
		mapA = A.getDiagonalMap()
		mapB = B.getDiagonalMap()
		for kA, vA in mapA.items():
			if kA not in mapB.keys():
				errors.append(2)
			elif len(mapB[kA].getValues()) != len(vA.getValues()):
				errors.append(3)
			else:
				for i in range(len(vA.getValues())):
					if vA.getValue(i) != mapB[kA].getValue(i):
						print("error with diag idx - ", kA)
						errors.append(4)
		return errors

	def get_num_gates(self, cir, qubits):
		if cir == "vqeprep":
			return 41
		if cir == "ghz":
			i = 0
		if cir == "ham":
			i = 1
		if cir == "mermin_bell":
			i = 2
		if cir == "qaoa":
			i = 3
		if cir == "shortham":
			i = 4
		j = int(qubits) - 3
		gates = [
			2,3,4,5,6,7,8,9,
			9,13,17,21,25,29,33,37,
			11,18,25,34,43,54,65,78,
			8,8,8,8,8,8,8,8,
			0,0,0,0,0,0,17,0
		]
		return gates[i * 8 + j]

	def readAsDense(self, filePath):
		d = mmread(filePath)
		d = d.toarray()
		array = []
		for i in range(d.shape[0]):
			for j in range(d.shape[1]):
				array.append(d[i][j])
		return denseMatrix(d.shape[0], array)
	
	def readAsSparse(self, filePath):
		d = self.readAsDense(filePath)
		return d.convertToQuantumSparse(d.getSize())
	
	def run(self, type="supermarq", circuit="ghz", version="compare", qubits="5", file1="cryg2500", file2="cryg2500"):
		if type in ["supermarq", "other"]:
			num_gates = self.get_num_gates(circuit, qubits)
			if version == "dense":
				denseMatrices = self.prepareDense(circuit, qubits, num_gates)
				d = self.performDenseMultiplications(denseMatrices)
				d.print()
			elif version == "sparse":
				sparseMatrices = self.prepare(circuit, qubits, num_gates)
				q = self.performMultiplications(sparseMatrices)
				q.print()
			elif version == "compare":
				print("running dense version...")
				denseMatrices = self.prepareDense(circuit, qubits, num_gates)
				d = self.performDenseMultiplications(denseMatrices)
				d.print()
				print("running sparse version...")
				sparseMatrices = self.prepare(circuit, qubits, num_gates)
				q = self.performMultiplications(sparseMatrices)
				q.print()
				print("comparing results...")
				errors = self.checkResult(q, d.convertToQuantumSparse(pow(2, int(qubits))))
				return len(errors)
		elif type == "suitesparse":
			if version == "dense":
				denseA = self.readAsDense(self.data_dir + "/suitesparse/" + file1 + ".mtx")
				denseB = self.readAsDense(self.data_dir + "/suitesparse/" + file2 + ".mtx")
				d = denseProduct(denseA, denseB)
			elif version == "sparse":
				sparseA = self.readAsSparse(self.data_dir + "/suitesparse/" + file1 + ".mtx")
				sparseB = self.readAsSparse(self.data_dir + "/suitesparse/" + file2 + ".mtx")
				q = product(sparseA, sparseB)
			elif version == "compare":
				print("running dense version...")
				denseA = self.readAsDense(self.data_dir + "/suitesparse/" + file1 + ".mtx")
				denseB = self.readAsDense(self.data_dir + "/suitesparse/" + file2 + ".mtx")
				d = denseProduct(denseA, denseB)
				print("running sparse version...")
				sparseA = self.readAsSparse(self.data_dir + "/suitesparse/" + file1 + ".mtx")
				sparseB = self.readAsSparse(self.data_dir + "/suitesparse/" + file2 + ".mtx")
				q = product(sparseA, sparseB)
				print("comparing results...")
				errors = self.checkResult(q, d.convertToQuantumSparse(denseA.getSize()))
				return len(errors)
		else:
			print("something wrong!")
			return 1
