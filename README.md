# **DiaQ**  

DiaQ is a high-performance numerical library with a better DIA (diagonal) matrix format that reduces storage compared to SciPy's DIA format.  
It provides **DiaQ matrices**, matricized tensors, and a set of kernels specifically tailored for **efficient quantum simulations**.  

[![arXiv](https://img.shields.io/badge/arXiv-2405.01250-B31B1B.svg)](https://arxiv.org/abs/2405.01250)

---

## **About This Project**

DiaQ is part of the [**qsparse**](https://pages.github.ncsu.edu/qsparse/diaq/) project, which focuses on sparse-aware simulation frameworks for quantum computing.  

It integrates with other repositories in the **qsparse** organization:  
- **[benchmarks](https://github.com/qsparse/benchmarks)** – Integrates DiaQ with Unitary and Hamiltonian simulations, and collects performance metrics on ARC (NC State) and Frontier (ORNL).  
- **[NWQ-Sim](https://github.com/qsparse/nwq-sim)** – A modified copy of the NWQ-Sim simulator from PNNL, with DiaQ extensions.  
- **[numbackend](https://github.com/qsparse/numbackend)** – An interface layer for connecting exaTN and TNQVM with multiple numerical backends (TensorFlow, PyTorch, TAL-SH, etc.).  
- **[opt_einsum](https://github.com/qsparse/opt_einsum)** – A patched version of the original `opt_einsum` library with support for sparse backends.  

---

## **Installation**

### **1. Clone the repository with submodules**
```bash
git clone --recurse-submodules https://github.com/qsparse/diaq.git
```
If you cloned without `--recurse-submodules`, run:
```bash
git submodule update --init --recursive
```

---

### **2. Build using `build.sh`**

The `build.sh` script is the single entry point for building DiaQ.  

```bash
./build.sh <cpu|gpu|all> [cmake-options]
```

#### **Examples:**
```bash
./build.sh cpu                            # Build CPU-only version
./build.sh gpu -DDEBUG=ON                 # Build GPU version with debugging
./build.sh cpu -DBUILD_PYTHON=ON          # Build CPU version + Python bindings
./build.sh all -DPAPI=ON -DBUILD_PYTHON=ON  # Build CPU & GPU with PAPI and Python bindings
```

---

### **3. Python bindings (via CMake)**

To build and install the Python module into your current environment:
```bash
./build.sh cpu -DBUILD_PYTHON=ON
```
or for GPU:
```bash
./build.sh gpu -DBUILD_PYTHON=ON
```

> **Note:** There is no separate `setup.py` or `remake_python.sh`. All Python binding installation is handled by CMake during the build.

---

## **Optional CMake Flags**

- `-DDEBUG=ON` – Enable debugging mode  
- `-DDEEP_DEBUG=ON` – Enable deep debugging mode  
- `-DPAPI=ON` – Enable PAPI performance counters  
- `-DMAKE_TESTS=ON` – Build test suite  
- `-DMAKE_TEST_FOR_DISASSEMBLY=ON` – Build disassembly test target  

---

## **Running Tests**

If you built with `-DMAKE_TESTS=ON`, you can run:
```bash
./cpu_build/bin/tests list
./cpu_build/bin/tests test 12
./cpu_build/bin/tests kron_1
./cpu_build/bin/tests spmv_8
```
(See `tests.cpp` for more test examples.)

---

## **Quick Start (Python)**

Here is a small Python example comparing a `tensordot` done using NumPy vs DiaQ:

```python
import numpy as np
import diaq as qs

# Input tensors
a1 = np.arange(16).reshape(2,2,2,2)
a2 = np.arange(16,32).reshape(2,2,2,2)

# NumPy baseline
res1 = np.tensordot(a1, a2, ((2,), (1,)))
qres1 = qs.from_numpy(res1.flatten(), res1.shape)
qres1.print()  # Expected reference result

# Convert inputs to DiaQ format
qa1 = qs.from_numpy(a1.flatten(), a1.shape)
qa2 = qs.from_numpy(a2.flatten(), a2.shape)

# Reshape to align contracted dimensions
qa1_reshaped = qs.reshape(qa1, (8,2))
qa2_reshaped = qs.reshape(qa2, (2,8))

# DiaQ product (equivalent to tensordot)
qres2 = qs.product(qa1_reshaped, qa2_reshaped)
qres2.print()  # DiaQ result

# Validation with NumPy
an1 = a1.transpose(0,1,3,2)
an2 = a2.transpose(1,0,2,3)
anres1 = np.dot(an1.reshape(8,2), an2.reshape(2,8))

assert (anres1.reshape(2,2,2,2,2,2) == res1).all()
```

This shows how you can convert NumPy arrays into DiaQ's sparse-aware format and perform operations using DiaQ kernels.

---

## **Quick Start (C++)**

Once DiaQ is built, you can link it into your C++ project.  

### **1. Build DiaQ and set install directory**
```bash
./build.sh cpu
```
Assume DiaQ is located at `/path/to/diaq`. The library will be in `cpu_build/lib` and headers in `include/`.

### **2. CMake Integration**
In your project's `CMakeLists.txt`:
```cmake
if(DEFINED USE_DIAQ)
    if(USE_DIAQ)
        add_compile_definitions(USE_DIAQ)

        # DIAQ_INSTALL_DIR should be passed in at CMake configure time
        if(NOT DEFINED DIAQ_INSTALL_DIR)
            message(FATAL_ERROR "Please pass -DDIAQ_INSTALL_DIR=<path to DiaQ>")
        endif()

        include_directories(${DIAQ_INSTALL_DIR}/include)
        link_directories(${DIAQ_INSTALL_DIR}/cpu_build/lib)
    endif()
endif()
```

### **3. Example C++ Integration**
```cpp
#include <iostream>
#include "diaq.hpp"

int main() {
    auto m1 = diaq::from_vector({1,2,3,4}, {2,2});
    auto m2 = diaq::from_vector({5,6,7,8}, {2,2});

    auto res = diaq::product(m1, m2);
    res.print();

    return 0;
}
```

### **4. Build your project**
```bash
cmake -DUSE_DIAQ=1 -DDIAQ_INSTALL_DIR=/path/to/diaq ..
make
```

---

## **How DiaQ Fits in the qsparse Ecosystem**

DiaQ provides the **core kernels and sparse matrix formats** used in the larger qsparse ecosystem.  

- It powers the **[benchmarks](https://github.com/qsparse/benchmarks)** repository for measuring performance of Unitary and Hamiltonian simulations.  
- It integrates with **[NWQ-Sim](https://github.com/qsparse/nwq-sim)** for distributed tensor-network simulations.
- It connects through **[numbackend](https://github.com/qsparse/numbackend)** and **[opt_einsum](https://github.com/qsparse/opt_einsum)** to leverage high-performance numerical libraries and optimal tensor contraction paths.  

---

## **Citing**

If you use DiaQ in your work, please cite the [arXiv paper (arXiv:2405.01250)](https://arxiv.org/abs/2405.01250):  

```bibtex
@misc{diaq2024,
  title     = {DiaQ: Sparse Quantum Simulation with Diagonal-Aware Kernels},
  author    = {Chundury, Srikar and Li, Jiajia and et al.},
  year      = {2024},
  eprint    = {2405.01250},
  archivePrefix = {arXiv},
  primaryClass  = {quant-ph}
}
```
