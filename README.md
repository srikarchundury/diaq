# DiaQ

DiaQ is a high-performance C++/CUDA library for diagonal-aware sparse linear algebra, purpose-built for quantum Hamiltonian simulation workloads. It provides a compact diagonal-sparse matrix format, HPC-optimized kernels for sparse matrix operations, tensor contraction utilities, and seamless Python bindings — all designed around the structural sparsity of quantum Hamiltonians.

[![arXiv](https://img.shields.io/badge/arXiv-2405.01250-B31B1B.svg)](https://arxiv.org/abs/2405.01250)
[![ACM ICS 2026](https://img.shields.io/badge/ACM%20ICS%202026-10.1145%2F3797905.3807869-0077B5.svg)](https://doi.org/10.1145/3797905.3807869)

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](LICENSE)

## Features

### DiaQ Sparse Format
DiaQ stores matrices in a **diagonal-major layout**: only active (non-zero) diagonals are kept, packed back-to-back into contiguous, SIMD-aligned buffers. Real and imaginary parts are stored in a **structure-of-arrays (SoA)** layout for maximum vectorization efficiency. Unlike SciPy's DIA format, DiaQ allocates storage proportional to the true number of non-zeros — no padding to the full matrix dimension regardless of diagonal offset.

A **two-phase design** underlies every kernel: a lightweight structural dry-run propagates only diagonal indices to determine the exact output sparsity pattern, enabling a single preallocated contiguous buffer before any numerical work begins. This eliminates dynamic allocation inside inner loops and yields predictable, cache-friendly memory access.

### Kernel Suite

| Kernel | Function | Complexity |
|--------|----------|------------|
| **SpMV** | Sparse matrix × vector | O(d · N) |
| **SpGEMM** | Sparse matrix × matrix (diagonal-pair enumeration) | O(d_A · d_B · N) |
| **SpME** | Sparse matrix exponential (Taylor series + scaling-and-squaring) | depends on d, t |
| **kron / kroneckerProduct** | Kronecker product A ⊗ B | O(d_A · d_B · N²) |
| **adjoint** | Hermitian conjugate (in-place or out-of-place) | O(d · N) |
| **add** | Matrix addition | O(d · N) |
| **multiply_by_scalar** | Complex scalar scaling | O(d · N) |
| **pow / matrix_power** | Integer matrix power (repeated squaring) | O(log(n) · d² · N) |
| **trace** | Matrix trace | O(N) |
| **norms** | Matrix and vector norms | O(d · N) |

Structured Kronecker helpers (`identity_kron_matrix`, `matrix_kron_identity`, `identity_kron_matrix_kron_identity`) and their fused matrix–vector variants are also provided for embedding single-qubit gates into multi-qubit state spaces efficiently.

### Tensor Operations
- `reshape` — reinterpret a DiaQ matrix under a new tensor shape
- `transpose` — permute tensor axes
- `tensordot` — general tensor contraction (drop-in for `np.tensordot`)
- `matrix_reshape` — reshape to explicit 2-D matrix dimensions

### SIMD Backends
Selected automatically at compile time (or overridden via `-DMANUAL_SIMD=ON`):

| Backend | ISA | Target |
|---------|-----|--------|
| AVX-512 | x86-64 | Intel Skylake-SP+, AMD Zen 4+ |
| AVX2 | x86-64 | Intel Haswell+, AMD Zen+ |
| SSE2 | x86-64 | Baseline x86-64 |
| NEON | ARM64 | Apple Silicon, ARM Cortex-A |
| Scalar | any | Portable fallback |

### GPU (CUDA) Support
GPU kernels mirror the CPU kernel suite with a layout-consistent preallocated design:
- GPU SpMV: single-diagonal fast path + general row-parallel kernel
- GPU SpGEMM: one thread block per result diagonal
- Fused Hamiltonian simulation kernel (`spHamSim_gpu_all_fused`) for end-to-end time evolution on-device
- Separate `diaq_gpu` Python module for GPU-accelerated workflows

### Python Interface
- **pybind11** bindings exposing the full kernel suite to Python
- `from_numpy` / `to_numpy` matrix converters; `from_numpy_vector` / `to_numpy_vector` for state vectors
- Compatible with NumPy, SciPy, and Qiskit workflows
- `install_info()` for build and backend diagnostics

## Architecture

DiaQ's performance model is built around three principles. First, **diagonal awareness**: the format and every kernel are co-designed so that sparsity patterns in the output are determined structurally before any arithmetic, enabling single-pass preallocated execution. Second, **SIMD-first inner loops**: each diagonal segment maps to a tight streaming loop with fused complex FMA operations, software prefetching, and masked tail handling, achieving near-peak memory bandwidth. Third, **backend portability**: a unified CMake build system selects the best available SIMD backend and optional CUDA path at compile time, so the same source tree runs efficiently from Apple Silicon laptops to HPC nodes and NVIDIA H100 GPUs.


## Installation

### 1. Clone with submodules

```bash
git clone --recurse-submodules https://github.com/srikarchundury/diaq.git
cd diaq
```

If cloned without submodules:

```bash
git submodule update --init --recursive
```

### 2. Build with build.sh

Use build.sh as the primary build entry point:

```bash
./build.sh [cpu|gpu|all] [cmake-options]
```

Notes:

- Default target is cpu when omitted.
- gpu target is supported on Linux with CUDA.
- On macOS, gpu builds are skipped by the script.

Examples:

```bash
./build.sh cpu
./build.sh cpu -DDEBUG=ON
./build.sh gpu -DBUILD_PYTHON=ON
./build.sh all -DPAPI=ON -DMANUAL_SIMD=ON
```

### 3. Python bindings

Python module installation is handled by CMake during build/install. There is no separate setup.py workflow.

CPU module:

```bash
./build.sh cpu -DBUILD_PYTHON=ON
```

GPU module:

```bash
./build.sh gpu -DBUILD_PYTHON=ON
```

The default Python module names are:

- diaq (CPU build)
- diaq_gpu (CUDA build)

## Build Options

Common CMake options supported by build.sh:

- -DDEBUG=ON: Enable debug mode.
- -DDEEP_DEBUG=ON: Enable deeper debug checks.
- -DAVOID_ZERO_DIAGS=ON: Skip storing zero diagonals.
- -DCUDA_ENABLED=ON: Enable CUDA path (auto-set for gpu target).
- -DPAPI=ON: Enable PAPI counters.
- -DMAKE_TESTS=ON: Build C++ tests.
- -DMANUAL_SIMD=ON: Enable manual SIMD backend selection.
- -DMAKE_TEST_FOR_DISASSEMBLY=ON: Build disassembly-oriented target.
- -DBUILD_PYTHON=ON: Build and install Python bindings.
- -DPython3_EXECUTABLE=/path/to/python3: Pin Python interpreter used by CMake.

## Running Tests

When built with -DMAKE_TESTS=ON, run from repository root:

```bash
./cpu_build/bin/tests list
./cpu_build/bin/tests test 12
./cpu_build/bin/tests kron_1
./cpu_build/bin/tests spmv_8
```

Notes:

- The list command prints registered test names.
- Additional test entry points are implemented in cpp_tests/test_main.cpp.

## Quick Start (Python)

### Sparse Matrix–Vector Multiplication (SpMV)

```python
import numpy as np
import diaq as dq

# Build a diagonal-sparse Hamiltonian (e.g., Pauli-Z on 2 qubits)
H_np = np.diag([1.0, -1.0, -1.0, 1.0]).astype(np.complex128)
H = dq.from_numpy(H_np)       # auto-detects diagonal structure

# Initial state |00⟩ = [1, 0, 0, 0]
psi = dq.from_numpy_vector(np.array([1, 0, 0, 0], dtype=np.complex128))

# Apply H to psi: y = H @ psi
y = dq.spMV(H, psi)

result = np.array(dq.to_numpy_vector(y))
print(result)   # [1.+0.j  0.+0.j  0.+0.j  0.+0.j]  (H|00⟩ = |00⟩)
```

### Sparse Matrix–Matrix Multiplication (SpGEMM)

```python
import numpy as np
import diaq as dq

# Build two diagonal-sparse matrices and multiply them
H_np = np.diag([1.0, -1.0, 1.0, -1.0]).astype(np.complex128)
H    = dq.from_numpy(H_np)

# SpGEMM: C = H @ H  (Pauli-Z is self-inverse: Z² = I)
H2 = dq.product(H, H)

H2_np = dq.to_numpy(H2)
np.testing.assert_allclose(H2_np, np.eye(4, dtype=np.complex128), atol=1e-12)
```

### Matrix Exponential (SpME)

```python
import numpy as np
import diaq as dq

# Time-evolution operator U = exp(-i H t) for a diagonal Hamiltonian
H_np = np.diag([1.0, -1.0, 1.0, -1.0]).astype(np.complex128)
H    = dq.from_numpy(H_np)
t    = 0.5

U  = dq.expm_negative(H, t)       # scaling-and-squaring Taylor series
U_np = dq.to_numpy(U)

# Validate against NumPy's dense expm
from scipy.linalg import expm
expected = expm(-1j * H_np * t)
np.testing.assert_allclose(U_np, expected, atol=1e-10)
```

### Kronecker Product

```python
import numpy as np
import diaq as dq

# Embed a single-qubit X gate into a 2-qubit system: X ⊗ I₂
X_np = np.array([[0, 1], [1, 0]], dtype=np.complex128)
X    = dq.from_numpy(X_np)
I2   = dq.identityMatrix(2)

XI = dq.kroneckerProduct(X, I2)   # 4×4 sparse matrix
XI_np = dq.to_numpy(XI)

expected = np.kron(X_np, np.eye(2, dtype=np.complex128))
np.testing.assert_allclose(XI_np, expected, atol=1e-12)
```

### Tensor Contraction (tensordot)

```python
import numpy as np
import diaq as dq

# Input tensors
a1 = np.arange(16, dtype=np.complex128).reshape(2, 2, 2, 2)
a2 = np.arange(16, 32, dtype=np.complex128).reshape(2, 2, 2, 2)

# Convert to DiaQ
q1 = dq.from_numpy(a1)
q2 = dq.from_numpy(a2)

# tensordot(a1, a2, axes=((2,),(1,))) via reshape + SpGEMM
q1r = dq.reshape(q1, [8, 2])
q2r = dq.reshape(q2, [2, 8])
qres = dq.product(q1r, q2r)

res_dq = dq.to_numpy(qres)   # shape (8, 8)

# NumPy reference: contract axis 2 of a1 with axis 1 of a2 → shape (2,2,2,2,2,2)
res_np = np.tensordot(a1, a2, axes=((2,), (1,)))

np.testing.assert_allclose(res_dq, res_np.reshape(8, 8), rtol=1e-10, atol=1e-12)
```

## Quick Start (C++)

### 1. Build DiaQ

```bash
./build.sh cpu
```

Headers are in include. Built libraries are under cpu_build/lib.

### 2. Integrate with CMake

```cmake
if(USE_DIAQ)
    if(NOT DEFINED DIAQ_INSTALL_DIR)
        message(FATAL_ERROR "Please pass -DDIAQ_INSTALL_DIR=<path-to-diaq>")
    endif()

    include_directories(${DIAQ_INSTALL_DIR}/include)
    link_directories(${DIAQ_INSTALL_DIR}/cpu_build/lib)
    add_compile_definitions(USE_DIAQ)
endif()
```

### 3. Example

```cpp
#include <iostream>
#include "diaq.hpp"

int main() {
    diaq::valType vals[16] = {
        2, 3, 5, 7,
        11, 13, 17, 19,
        23, 29, 31, 37,
        41, 43, 47, 53
    };

    auto dense = std::make_shared<diaq::denseMatrix>(4, vals);
    auto gate = dense->convertToDiaQ();
    auto id4 = std::make_shared<diaq::identityMatrix>(4);

    auto kron = diaq::kron_product(id4, gate);
    auto x = std::make_shared<diaq::vector>(16, 1.0);
    auto y = std::make_shared<diaq::vector>(kron->shape[0], 0.0);

    diaq::spMV(kron, x, y);
    y->print();
    return 0;
}
```

### 4. Build your project

```bash
cmake -DUSE_DIAQ=1 -DDIAQ_INSTALL_DIR=/path/to/diaq ..
cmake --build .
```

## Citation

If you use DiaQ in your research, please cite:

```bibtex
@inproceedings{chundury2026diagonalbudgetedtrotterization,
    author = {Chundury, Srikar and Burgstahler, Blake and Li, Jiajia and Suh, In-Saeng and Mueller, Frank},
    title = {Diagonal-Budgeted Trotterization for Efficient Quantum Hamiltonian Simulation},
    year = {2026},
    booktitle = {Proceedings of the 2026 International Conference on Supercomputing (ICS '26)},
    address = {Belfast, United Kingdom},
    month = {July},
    doi = {10.1145/3797905.3807869},
    isbn = {979-8-4007-2522-7/2026/07},
    publisher = {Association for Computing Machinery}
}
```

```bibtex
@misc{chundury2024diaqefficientstatevectorquantum,
    title = {DiaQ: Efficient State-Vector Quantum Simulation},
    author = {Srikar Chundury and Jiajia Li and In-Saeng Suh and Frank Mueller},
    year = {2024},
    eprint = {2405.01250},
    archivePrefix = {arXiv},
    primaryClass = {quant-ph},
    url = {https://arxiv.org/abs/2405.01250}
}
```

## License

DiaQ is licensed under the [BSD 3-Clause License](LICENSE).
