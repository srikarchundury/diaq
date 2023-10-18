# DIA Lite #
A better DIA format that reduces storage compared to Scipy's DIA format. This numerical library offers DIAQ matrices, matricized tensors, and a set of kernels specifically tailored for efficient quantum simulations.

### About this Project ###
<ul>
<li> <a href="https://pages.github.ncsu.edu/qsparse/diaq/" target="_blank"> QSparse </a> </li>
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
