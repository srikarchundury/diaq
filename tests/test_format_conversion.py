import sys
import os
import re
import h5py
import numpy as np
import scipy as sc
import diaq as dq
from qiskit.quantum_info import state_fidelity, Statevector
from qiskit_aer import AerSimulator
from qiskit import transpile, QuantumCircuit
from qiskit.circuit.library import PauliEvolutionGate
from time import perf_counter

# sys.path.insert(0, '/ccs/home/schundu3/qsparse/ham_benchmarks')
sys.path.insert(0, '/mnt/beegfs/schundu3/thesis/ham_benchmarks')
from hamlib_functions.hamlib.hamlib_snippets import *

statevector_simulator = AerSimulator(method='statevector')

global precalculated_diaq_Us, precalculated_Us


def read_qiskit_hdf5_new(fname_hdf5: str, key: str):
	"""
	Read the operator object from HDF5 at specified key to qiskit SparsePauliOp
	format.
	"""
	def _generate_string(term):
		# change X0 Z3 to XIIZ
		indices = [
			(m.group(1), int(m.group(2)))
			for m in re.finditer(r'([A-Z])(\d+)', term)
		]
		return ''.join(
			[next((char for char, idx in indices if idx == i), 'I')
			 for i in range(max(idx for _, idx in indices) + 1)]
		)

	def _append_ids(pstrings):
		# append Ids to strings
		return [p + 'I' * (max(map(len, pstrings)) - len(p)) for p in pstrings]

	with h5py.File(fname_hdf5, 'r', libver='latest') as f:
		pattern = r'([\d.]+) \[([^\]]+)\]' # OLD REGEX
		pattern = r'\(?([\d.-]+(?:[+-][\d.]+j)?)\)? \[([^\]]+)\]'
		matches = re.findall(pattern, f[key][()].decode("utf-8"))
		labels = [_generate_string(m[1]) for m in matches]
		coeffs = [complex(match[0]).real for match in matches]
		op = SparsePauliOp(_append_ids(labels), coeffs)
	return op

def calculate_Us(H_array, exact_times):
	global precalculated_Us
	precalculated_Us = []
	global precalculated_diaq_Us
	precalculated_diaq_Us = []
	for time in exact_times:
		U = sc.linalg.expm(-1j * time * H_array)
		# precalculated_Us.append(U)
		dq_U = dq.from_numpy(U)
		precalculated_diaq_Us.append(dq_U)


def run_numpy(H_array, initial_state, exact_times):
	exact_evolution = []
	for time in exact_times:
		dense_U = sc.linalg.expm(-1j * time * H_array)
		exact_evolution.append(initial_state.evolve(dense_U))
	scipy_final_state = exact_evolution[-1]
	return scipy_final_state

def run_diaq(dq_H, diaq_initial_state, exact_times):
	for i, t in enumerate(exact_times):
		# dq_U = dq.expm_negative(dq_H, t) # TODO: READ: we can use this when H has just one diagonal, since I have implemented only that much so far. Clever-er techniques are needed to do matrix exponentiation for matrices with multiple diagnoals, more than just one principal diagonal.
		dq_U = precalculated_diaq_Us[i]
		diaq_final_state = dq.spMV(dq_U, diaq_initial_state)
	return diaq_final_state

def run_qiskit(sp_op, initial_state, final_time):
	evolution_gate = PauliEvolutionGate(sp_op, time=final_time)
	qc = QuantumCircuit(sp_op.num_qubits)
	qc.initialize(initial_state.data, range(sp_op.num_qubits))
	qc.append(evolution_gate, range(sp_op.num_qubits))
	qc.save_statevector()
	transpiled_qc = transpile(qc, statevector_simulator)
	result = statevector_simulator.run(transpiled_qc).result()
	final_statevector = result.get_statevector()
	return final_statevector


import sys
HDF5_FILE = sys.argv[1]
HDF5_KEY = sys.argv[2]

ITRS = 1

MAX_QUBITS = 30
final_time = 1.6

if not os.path.exists(HDF5_FILE):
	print(f"File {HDF5_FILE} not found.", flush=True)

sp_op = read_qiskit_hdf5_new(HDF5_FILE, HDF5_KEY)
num_qubits = sp_op.num_qubits
if num_qubits > MAX_QUBITS:
	print(f"Number of qubits {num_qubits} exceeds the maximum allowed {MAX_QUBITS}.", flush=True)

print("num_qubits: ", num_qubits, flush=True)
print("Chosen key: ", HDF5_KEY, flush=True)
# print("Hamiltonian: ", sp_op, flush=True)

H_array = sp_op.to_matrix()
print(H_array, flush=True)
print(type(H_array), flush=True)


dq_H = dq.from_numpy(H_array)
dq_H.print_meta()


