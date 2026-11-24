#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./build.sh [cpu|gpu|all] [cmake-options]

Targets (default = cpu):
  cpu   Build CPU-only
  gpu   Build CUDA (Linux only)
  all   Build both

Common CMake options:
  -DDEBUG=ON                      (default OFF)
  -DDEEP_DEBUG=ON                 (default OFF)
  -DAVOID_ZERO_DIAGS=ON           (default ON)
  -DCUDA_ENABLED=ON               (auto for 'gpu')
  -DPAPI=ON                       (default OFF)
  -DMAKE_TESTS=ON                 (default ON)
  -DMANUAL_SIMD=ON                (default ON)
  -DMAKE_TEST_FOR_DISASSEMBLY=ON  (default OFF)
  -DBUILD_PYTHON=ON               (default ON)
  -DPython3_EXECUTABLE=/path/python3
USAGE
}

# --- Parse target (default cpu) ---
target="${1:-cpu}"
case "$target" in
  -h|--help|help) usage; exit 0 ;;
  cpu|gpu|all) shift || true ;;
  *) echo "Unknown target: $target"; echo; usage; exit 1 ;;
esac

echo "=== Target: $target ==="
echo "CMake overrides:"
for arg in "${@:-}"; do echo "  $arg"; done
echo

uname_s="$(uname -s)"

# Parallelism
cores=1
if command -v nproc >/dev/null 2>&1; then
  cores="$(nproc)"
elif [[ "$uname_s" == "Darwin" ]]; then
  cores="$(sysctl -n hw.ncpu)"
fi

# Arrays (init BEFORE use)
cmake_omp_args=()
cmake_py_args=()

# --- macOS: prefer Homebrew LLVM, wire up OpenMP for AppleClang ---
if [[ "$uname_s" == "Darwin" ]]; then
  # Prefer Homebrew LLVM if available and CC/CXX not set
  if command -v brew >/dev/null 2>&1; then
    llvm_prefix="$(brew --prefix llvm 2>/dev/null || true)"
    if [[ -n "${llvm_prefix:-}" && -z "${CC:-}" && -z "${CXX:-}" ]]; then
      export CC="$llvm_prefix/bin/clang"
      export CXX="$llvm_prefix/bin/clang++"
      echo "Using Homebrew LLVM: CC=$CC, CXX=$CXX"
    fi
  fi

  # If using AppleClang, wire up libomp
  if [[ -n "${CXX:-}" ]] && "$CXX" --version 2>/dev/null | grep -qi "apple clang"; then
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

# Prefer a concrete Python3 unless user overrides via -DPython3_EXECUTABLE
if command -v python3 >/dev/null 2>&1; then
  cmake_py_args+=(-DPython3_EXECUTABLE="$(command -v python3)")
fi

should_install_python() {
  # Read the cache first: under `set -o pipefail`, `cmake ... | grep -q` fails when grep exits early and cmake gets
  # SIGPIPE, so the install was skipped at random.
  local bdir="$1" cache
  cache="$(cmake -LA -N "$bdir" 2>/dev/null || true)"
  grep -q '^BUILD_PYTHON:BOOL=ON$' <<< "$cache"
}

# --- CPU build ---
if [[ "$target" == "cpu" || "$target" == "all" ]]; then
  rm -rf cpu_build && mkdir cpu_build
  cmake_args=(
    -S . -B cpu_build
    -DCMAKE_BUILD_TYPE=Release
    -DMANUAL_SIMD=ON
    -DMAKE_TESTS=ON
    -DAVOID_ZERO_DIAGS=ON
    -DBUILD_PYTHON=ON
  )
  (( ${#cmake_omp_args[@]} )) && cmake_args+=( "${cmake_omp_args[@]}" )
  (( ${#cmake_py_args[@]} )) && cmake_args+=( "${cmake_py_args[@]}" )
  (( $# )) && cmake_args+=( "$@" )

  cmake "${cmake_args[@]}"
  cmake --build cpu_build -j "$cores"
  if should_install_python "cpu_build"; then
    cmake --install cpu_build
  fi
fi

# --- GPU build (Linux only) ---
if [[ "$target" == "gpu" || "$target" == "all" ]]; then
  if [[ "$uname_s" == "Darwin" ]]; then
    echo "Note: CUDA is not supported on macOS. Skipping GPU build."
  else
    rm -rf gpu_build && mkdir gpu_build
    cmake_args=(
      -S . -B gpu_build
      -DCMAKE_BUILD_TYPE=Release
      -DAVOID_ZERO_DIAGS=ON
      -DMAKE_TESTS=ON
      -DCUDA_ENABLED=ON
      -DMANUAL_SIMD=ON
      -DBUILD_PYTHON=ON
    )
    (( ${#cmake_omp_args[@]} )) && cmake_args+=( "${cmake_omp_args[@]}" )
    (( ${#cmake_py_args[@]} )) && cmake_args+=( "${cmake_py_args[@]}" )
    (( $# )) && cmake_args+=( "$@" )

    cmake "${cmake_args[@]}"
    cmake --build gpu_build -j "$cores"
    if should_install_python "gpu_build"; then
      cmake --install gpu_build
    fi
  fi
fi

echo "Done."
