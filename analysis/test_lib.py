import sys
import supermarq
import cirq_superstaq as css
import supermarq as sm
import cirq
import cirq.contrib.quimb as ccq
import quimb
import quimb.tensor as qtn

# removing all measurements, initial and final hadamards - all?
def remove_odd_gates(circ, gates_removed = ['']):
    if "--without-h" in sys.argv:
        gates_removed.append("H")
    all_moments = list(circ._moments)
    marked = []
    for i, moment in enumerate(all_moments):
        for op in moment:
            if str(op.gate) in gates_removed or hasattr(op.gate, '_is_measurement_') or not cirq.has_unitary(op.gate):
                marked.append((i, op))
    # print("\nremoved for analysis - \n", marked)
    circ.batch_remove(marked)
    circ._moments = [e for e in circ._moments if e != cirq.Moment()]
    print("\nreduced circuit - \n", circ)
    return circ

def get_tn(circ):
    aq = circ.all_qubits()
    tensors, qubit_frontier, _ = ccq.circuit_to_tensors(circ, aq, initial_state=None)
    return qtn.TensorNetwork(tensors), qubit_frontier, aq

def analyse(tensor, precision=3):
    # check for overall sparsity
    # check diagnal sparsity
    # check intops - number of floats/complex numbers that can be represented using just integers
    unique = {}
    for i in range(len(tensor)):
        for j in range(len(tensor[i])):
            c = round(tensor[i][j], precision)
            if c in unique.keys():
                unique[c] += 1
            else:
                unique[c] = 1
    return unique



cir_name = sys.argv[1]
n_qubits = int(sys.argv[2])
lib = str(sys.argv[3])

if cir_name == 'ghz':
    special = supermarq.benchmarks.ghz.GHZ(num_qubits=n_qubits)
    special_circ = special.circuit()
    # print(special_circ)

elif cir_name == 'bit_code':
    special = supermarq.benchmarks.bit_code.BitCode(n_qubits, 1, [1]*n_qubits)
    special_circ = special.circuit()
    # print(special_circ)

elif cir_name == 'ham':
    special = supermarq.benchmarks.hamiltonian_simulation.HamiltonianSimulation(n_qubits, 1, 1)
    special_circ = special.circuit()
    # print(special_circ)

elif cir_name == 'mermin_bell':
    special = supermarq.benchmarks.mermin_bell.MerminBell(n_qubits)
    special_circ = special.circuit()
    # print(special_circ)

elif cir_name == 'phase_code':
    special = supermarq.benchmarks.phase_code.PhaseCode(n_qubits, 1, [1]*n_qubits)
    special_circ = special.circuit()
    # print(special_circ)

# errors as of now
elif cir_name == 'qaoa':
    special = supermarq.benchmarks.qaoa_fermionic_swap_proxy.QAOAFermionicSwapProxy(n_qubits)
    special_circ = special.circuit()
    # print(special_circ)

# errors as of now
elif cir_name == 'vqe':
    special = supermarq.benchmarks.vqe_proxy.VQEProxy(n_qubits, 1)
    special_circ = special.circuit()
    # print(special_circ)

else:
    raise Exception("not one of (ghz, bit_code, ham, mermin_bell, phase_code, qaoa, vqe). Check args")


special_circ = remove_odd_gates(special_circ)
special_tn, special_frontier, special_qubits = get_tn(special_circ)
special_tn.graph()

# contraction path identification and contraction operations
i_inds = tuple(f'i0_q{q}' for q in special_qubits)
f_inds = tuple(f'i{special_frontier[q]}_q{q}' for q in special_qubits)

# using `lib` (argv 3) to contract
contracted_special_tn = special_tn.contract(inplace=False, backend=lib)
final = contracted_special_tn.to_dense(f_inds, i_inds)
from pprint import pprint
pprint(analyse(final))