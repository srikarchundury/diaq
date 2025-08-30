#!/bin/bash
# set -e
# set -x

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
    echo "  -DCUDA_ENABLED=ON                Enable CUDA support (auto-set if you use 'gpu') [OFF]"
    echo "  -DPAPI=ON                        Enable PAPI performance counters [OFF]"
    echo "  -DMAKE_TESTS=ON                  Build tests [OFF]"
    echo "  -DSIMD_ENABLED=ON                Enable SIMD optimizations (CPU only) [ON]"
    echo "  -DMAKE_TEST_FOR_DISASSEMBLY=ON   Build disassembly test [OFF]"
    echo "  -DBUILD_PYTHON=ON                Build Python bindings (pybind11) [ON]"
    echo
    echo "Examples:"
    echo "  ./build.sh cpu"
    echo "  ./build.sh cpu -DBUILD_PYTHON=ON -DSIMD_ENABLED=ON"
    echo "  ./build.sh gpu -DDEBUG=ON"
    echo "  ./build.sh all -DPAPI=ON -DBUILD_PYTHON=ON"
    echo
    echo "Note: Any additional CMake options are forwarded directly."
    echo
    exit 0
fi

# print chosen overrides
echo "CMake overrides:"
for arg in "${@:2}"; do
    echo "  $arg"
done
echo

# --- CPU build ---
if [[ $1 == "cpu" || $1 == "all" ]]; then
    rm -rf cpu_build
    mkdir cpu_build
    cd cpu_build
    cmake -DSIMD_ENABLED=ON -DBUILD_PYTHON=ON "${@:2}" ..
    make -j
    # Check if BUILD_PYTHON was explicitly set to OFF, otherwise default is ON
    build_python_on=1
    for arg in "${@:2}"; do
        if [[ "$arg" == "-DBUILD_PYTHON=OFF" ]]; then
            build_python_on=0
            break
        fi
    done
    if [[ $build_python_on -eq 1 ]]; then
        cmake --install .
    fi
    cd ..
fi

# --- GPU build ---
if [[ $1 == "gpu" || $1 == "all" ]]; then
    rm -rf gpu_build
    mkdir gpu_build
    cd gpu_build
    cmake -DCUDA_ENABLED=ON "${@:2}" ..
    make -j
    # If Python bindings are built, install into site-packages
    if [[ "${@:2}" == *"BUILD_PYTHON=ON"* ]]; then
        cmake --install .
    fi
    cd ..
fi
