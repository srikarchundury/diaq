# DiaQ #
A better DIA format that reduces storage compared to Scipy's DIA format. This numerical library offers DiaQ matrices, matricized tensors, and a set of kernels specifically tailored for efficient quantum simulations.

### About this Project ###
<ul>
<li> <a href="https://pages.github.ncsu.edu/qsparse/diaq/" target="_blank"> qsparse </a> </li>
</ul>

## Installation ##

* Clone this repo

* Build both CPU and GPU builds
```
	./run_builds.sh cpu
```

* Install python libary diaq
```
	./remake_python.sh cpu
```

* Optionally, with any of the 2 above bash scripts, attach -DDEBUG=1, -DDEEP_DEBUG=1

* (use -DMAKE_TESTS=1) Test cases (please see tests.cpp or run first one below)
```
	./cpu_build/bin/tests list
	./cpu_build/bin/tests test 12
	./cpu_build_bin/tests kron_1
	./cpu_build_bin/tests spmv_8
	and so on..
```
