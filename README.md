# sparse-tnqs #
Sparse Tensor Network based Quantum Simulation

### Links ###
* [GIT IO PAGE](https://pages.github.ncsu.edu/tnqs/sparse-tnqs/)
* [Overleaf](https://www.overleaf.com/project/634d7c5f9cdfe07d6b005919)

*As of now, this project is only for a custom numeric library tweaked to work best for sparse tensor-network based quantum simulations. This is part of Dr. Frank's quantum computing course project: [QC-22](https://pages.github.ncsu.edu/fmuelle/qc22/ "QC-22")*

## Motivation ##
* Quantum circuit simulation can be posed as a directed graph problem, where each node is a "tensor" representing the quantum gate (unitary matrix) operation on a set of input qubits.
* The state of these input qubits evolves as the quantum circuit proceeds in time steps. With each state evolution, we are essentially performing a "contraction" (multiplication) of the input tensor (vector/matrix) with a gate tensor (X, Y, Z, CX, CCX etc) until we reach the end of the circuit.
* The order in which is contraction is performed is crucial for performance; just like how order of n matrix multiplications is crucial for performance.
* There are algorithms to get the most optimal path (like opt_einsum). Read "Algorithms for Tensor Network Contraction Ordering" under literature_survey.
* Once an optimal path is chosen, the complex quantum circuit which had multiple intermediate gates/tensors, boils down to just one big really sparse unitary matrix. Modern simulation tools like qiskit have methods to get this unitary for any given quantum circuit.

## Scope of this project ##
* We focus only on the sparsity introduced in above-mentioned simulation and create a new library that performs the "contraction" better in terms of memory, thereby reducing overall quantum simulation time.

## Problem Statement ##
* Analyze intermediate unitaries for sparsity.
    * Follow the contraction path (opt_einsum) and analyze how the unitary of the circuit evolves over time steps.
* New data structure format to store sparse unitaries efficiently.
    * Make use of diagonals and anti-diagonals.
    * Estimate the time and space complexities for kernel algorithmics involved (Matrix-Vector, Matrix-Matrix).
* Implement the new data structure and kernels in c++ and expose as a custom library.
    * Handle Conversions between this new format and numPy.
    * Kernels:
        * Vector to Vector multiplication
        * Vector to Matrix multiplication
        * Matrix to Matrix multiplication - (used in contraction in tensor-network based simulations).
    * Compare performance using metrics- #flops, memory (kB) and #intops (number of floats/doubles that can be represented with just integers).


## Installation ##
* git clone this repo

* test cases
```
cd tests
./run.sh
./a.out
```

* getting dependencies with "cnpy" (a c++ tool that read numpy based files)
```
cd benchmarks
rm -r tool/*
git clone https://github.com/rogersce/cnpy.git
source /opt/rh/devtoolset-8/enable .
cmake3 cnpy -DCMAKE_INSTALL_PREFIX=.
make
make install
```

* compiling this library
```
export export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
g++ -o bench benchmarks.cpp -Itool/include -Ltool -lcnpy -lz --std=c++11
```

* Testing benchmarks

* To run a circuit chain mulitplication using the usual dense algorithm
```
./bench ghz 5 dense
```

* To run a circuit chain mulitplication using our new sparse algorithm (NOTE: this first converts dense numpy arryays into our sparse structure and then proceeds in sparse fashion)
```
./bench ham 6 sparse
```

* To check results
```
./bench mermin_bell 7 compare
```


## references ##
* https://sparse.tamu.edu  - UF sparse matrices
