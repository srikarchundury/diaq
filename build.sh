#!/bin/bash
set -e

# --- Help / Usage ---
if [[ $# -lt 1 || "$1" == "help" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ./build.sh <cpu|gpu|all> [cmake-options]"
    echo
    echo "Build Targets:"
    echo "  cpu        Build CPU-only version"
    echo "  gpu        Build GPU (CUDA) version"
    echo "  all        Build both CPU and GPU versions"
    echo
    echo "Available CMake Options (defaults in brackets):"
    echo "  -DDEBUG=ON                      Enable debugging mode [OFF]"
    echo "  -DDEEP_DEBUG=ON                 Enable deep debugging mode [OFF]"
    echo "  -DCUDA_ENABLED=ON               Enable CUDA support (auto-set if you use 'gpu') [OFF]"
    echo "  -DPAPI=ON                       Enable PAPI performance counters [OFF]"
    echo "  -DMAKE_TESTS=ON                 Build tests [OFF]"
    echo "  -DSIMD_ENABLED=ON               Enable SIMD optimizations (CPU only) [ON]"
    echo "  -DMAKE_TEST_FOR_DISASSEMBLY=ON  Build disassembly test [OFF]"
    echo "  -DBUILD_PYTHON=ON               Build Python bindings (pybind11) [ON]"
    echo
    echo "Examples:"
    echo "  ./build.sh cpu"
    echo "  ./build.sh cpu -DBUILD_PYTHON=ON -DSIMD_ENABLED=ON"
    echo "  ./build.sh gpu -DDEBUG=ON"
    echo "  ./build.sh all -DPAPI=ON -DBUILD_PYTHON=ON"
    echo
    exit 0
fi

target="$1"
shift || true  # remaining args are CMake overrides

echo "CMake overrides:"
for arg in "$@"; do echo "  $arg"; done
echo

# --- macOS convenience: compiler + OpenMP hints ---
uname_s="$(uname -s)"
cmake_omp_args=()

if [[ "$uname_s" == "Darwin" ]]; then
  # Prefer Homebrew LLVM if present (so OpenMP “just works”)
  if command -v brew >/dev/null 2>&1; then
    llvm_prefix="$(brew --prefix llvm 2>/dev/null || true)"
    if [[ -n "$llvm_prefix" && -z "$CC" && -z "$CXX" ]]; then
      export CC="$llvm_prefix/bin/clang"
      export CXX="$llvm_prefix/bin/clang++"
      echo "Using Homebrew LLVM: CC=$CC, CXX=$CXX"
    fi
  fi

  # If we’re still on Apple Clang, add libomp flags so find_package(OpenMP) resolves
  # (Safe to pass even if using LLVM; CMake will ignore duplicates)
  if "$CXX" --version 2>/dev/null | grep -qi "apple clang"; then
    omp_prefix="$(brew --prefix libomp 2>/dev/null || echo /opt/homebrew/opt/libomp)"
    cmake_omp_args+=(
      -DOpenMP_C_FLAGS="-Xpreprocessor -fopenmp -I${omp_prefix}/include"
      -DOpenMP_C_LIB_NAMES="omp"
      -DOpenMP_omp_LIBRARY="${omp_prefix}/lib/libomp.dylib"
      -DOpenMP_CXX_FLAGS="-Xpreprocessor -fopenmp -I${omp_prefix}/include"
      -DOpenMP_CXX_LIB_NAMES="omp"
      -DOpenMP_CXX_LIBRARY="${omp_prefix}/lib/libomp.dylib"
      -DCMAKE_EXE_LINKER_FLAGS="-L${omp_prefix}/lib"
      -DCMAKE_SHARED_LINKER_FLAGS="-L${omp_prefix}/lib"
    )
    echo "Apple Clang detected: adding libomp flags via Homebrew (${omp_prefix})"
  fi
fi

# Helper to decide if BUILD_PYTHON ended up ON in the build dir
should_install_python () {
  local bdir="$1"
  if cmake -LA -N "$bdir" 2>/dev/null | grep -q "^BUILD_PYTHON:BOOL=ON$"; then
    return 0
  fi
  return 1
}

# --- CPU build ---
if [[ "$target" == "cpu" || "$target" == "all" ]]; then
  rm -rf cpu_build
  mkdir cpu_build
  cmake -S . -B cpu_build -DSIMD_ENABLED=ON -DBUILD_PYTHON=ON "${cmake_omp_args[@]}" "$@"
  cmake --build cpu_build -j

  if should_install_python "cpu_build"; then
    cmake --install cpu_build
  fi
fi

# --- GPU build ---
if [[ "$target" == "gpu" || "$target" == "all" ]]; then
  if [[ "$uname_s" == "Darwin" ]]; then
    echo "Note: CUDA is not supported on macOS. Skipping GPU build."
  else
    rm -rf gpu_build
    mkdir gpu_build
    cmake -S . -B gpu_build -DCUDA_ENABLED=ON "${cmake_omp_args[@]}" "$@"
    cmake --build gpu_build -j
    if should_install_python "gpu_build"; then
      cmake --install gpu_build
    fi
  fi
fi
