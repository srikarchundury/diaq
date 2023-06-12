# sparse-tnqs #
Sparse Tensor Network based Quantum Simulation

* This repo hosts the high performance numerical library that is tailored to work best for the sparsity seen in most quantum simulations.

### About this Project ###
<ul>
<li> <a href="https://pages.github.ncsu.edu/tnqs/sparse-tnqs/" target="_blank">TNQS</a> </li>
<li> <a href="https://www.overleaf.com/project/634d7c5f9cdfe07d6b005919" target="_blank">OVERLEAF</a> </li>
</ul>

## Installation ##
* Clone this repo
* Test cases
```
cd tests
./compile_linux.sh
(or)
./compile_mac.sh

./a.out		# runs a bunch of testcases
./a.out 1 	# runs tensordot
./a.out 2	# runs tensor transpose
./a.out 3	# runs getMatrixPosition and getTensorPosition
./a.out 4	# runs tensor transpose another example
./a.out 5	# runs using operator overloading
```
