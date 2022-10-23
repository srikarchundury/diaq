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
    print("\nremoved for analysis - \n", marked)
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



cir_name = "ghz"
n_qubits = 4
special = supermarq.benchmarks.ghz.GHZ(num_qubits=n_qubits)
special_circ = special.circuit()
print(special_circ)
special_circ = remove_odd_gates(special_circ)
special_tn, special_frontier, special_qubits = get_tn(special_circ)
special_tn.graph()

# contraction path identification and contraction operations
i_inds = tuple(f'i0_q{q}' for q in special_qubits)
f_inds = tuple(f'i{special_frontier[q]}_q{q}' for q in special_qubits)

# using `lib` (argv 3) to contract
contracted_special_tn = special_tn.contract(inplace=False, backend='sparse')
final_sparse = contracted_special_tn.to_dense(f_inds, i_inds)
print(final_sparse)
print("#"*50)
contracted_special_tn = special_tn.contract(inplace=False, backend='numpy')
final_numpy = contracted_special_tn.to_dense(f_inds, i_inds)
print(final_numpy)

print(final_numpy == final_sparse.todense())