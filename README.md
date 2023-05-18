# sparse-tnqs #
Sparse Tensor Network based Quantum Simulation

* This repo hosts the high performance numerical library that is tailored to work best for the sparsity seen in most quantum simulations.

### About this Project ###
<ul>
<li> <a href="https://pages.github.ncsu.edu/tnqs/sparse-tnqs/" target="_blank">TNQS</a> </li>
<li> <a href="https://www.overleaf.com/project/634d7c5f9cdfe07d6b005919" target="_blank">OVERLEAF</a> </li>
</ul>

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
rm -r tool
mkdir tool
cd tool
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
