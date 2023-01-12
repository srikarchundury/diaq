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
* Analyze intermediate unitaries for sparsity. [:heavy_check_mark:]
    * Follow the contraction path (opt_einsum) and analyze how the unitary of the circuit evolves over time steps.
* New data structure format to store sparse unitaries efficiently.
    * Make use of diagonals and anti-diagonals. [:heavy_check_mark:]
    * Estimate the time and space complexities for kernel algorithmics involved (Matrix-Vector, Matrix-Matrix). [:heavy_check_mark:]
* Implement the new data structure and kernels in c++ and expose as a custom library.
    * Handle Conversions between this new format and numPy. [:heavy_check_mark:]
    * Kernels:
        * Vector to Vector multiplication [delayed, removed from scope of qc-22 course project]
        * Vector to Matrix multiplication [delayed, removed from scope of qc-22 course project]
        * Matrix to Matrix multiplication - (used in contraction in tensor-network based simulations). [:heavy_check_mark:]
    * Compare performance using metrics- #flops, memory (kB) and #intops (number of floats/doubles that can be represented with just integers). [In-progess, compared #flops algorithmically]


## Installation ##
* Clone this repo and get data required for testing (this data is generated using qiskit's unitary simulator)

```
pip install gdown
gdown 12NhkuVehssVq28-ZGqyhIsra4GIfD8KA
tar -xvf data.tar.gz
git clone https://github.ncsu.edu/tnqs/sparse-tnqs.git
cd sparse-tnqs
```

* Test cases
```
cd tests
./run.sh
./a.out
```

* Getting dependencies with "cnpy" (a c++ tool that read numpy based files)
```
cd benchmarks
rm -r tool/*
cd tool/
git clone https://github.com/rogersce/cnpy.git
source /opt/rh/devtoolset-8/enable .
cmake3 cnpy -DCMAKE_INSTALL_PREFIX=.
make
make install
```

* Compiling this library, alternatively use run.sh
```
g++ -o bench benchmarks.cpp -Itool/include -Ltool -lcnpy -lz --std=c++11
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/tool/
```

* Testing benchmarks

    * To run a circuit chain mulitplication using the usual dense algorithm
    ```
    ./bench supermarq ghz 5 dense
    ```

    * To run a circuit chain mulitplication using our new sparse algorithm (NOTE: this first converts dense numpy arryays into our sparse structure and then proceeds in sparse fashion)
    ```
    ./bench supermarq ham 6 sparse
    ```

    * To check results
    ```
    ./bench supermarq mermin_bell 7 compare
    ```

* Testing suitesparse matrices

    * To run a circuit chain mulitplication using the usual dense algorithm
    ```
    ./bench suitesparse cryg2500 cryg2500 compare
    ```

* Testing max-cut unitary simulation

    * To run a circuit chain mulitplication; compare results
    ```
    ./bench other qaoa 4 compare
    ```


## References ##
* https://github.com/SupertechLabs/SupermarQ - Supermarq benchmarks
* https://sparse.tamu.edu  - previously UF sparse matrices - sparse diagonal benchmarking using pcrystk02, denormal, cryg10000, apache1 etc. NOTE: only cryg2500 runs in finite time as of now, because of the dense to sparse conversion step.
