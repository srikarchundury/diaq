# DIAQ #
A better DIA format that reduces storage compared to Scipy's DIA format. This numerical library offers DIAQ matrices, matricized tensors, and a set of kernels specifically tailored for efficient quantum simulations.

### About this Project ###
<ul>
<li> <a href="https://pages.github.ncsu.edu/qsparse/diaq/" target="_blank"> QSparse </a> </li>
<li> <a href="https://www.overleaf.com/project/634d7c5f9cdfe07d6b005919" target="_blank">OVERLEAF</a> </li>
</ul>

## Installation ##
* Clone this repo
* Build both CPU and GPU builds
```
	./run_builds.sh
```
* Test cases
```
	cd cpu_build/bin
	./tests		# runs a bunch of spMspM testcases (around 46 testcases as of now)
	./tests 1
	./test 2
	./test 3 and so on.. for different operations
```
