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
    echo "Available CMake Options:"
    echo "  -DDEBUG=ON                  Enable debugging mode"
    echo "  -DDEEP_DEBUG=ON              Enable deep debugging mode"
    echo "  -DCUDA_ENABLED=ON            Enable CUDA support (auto-set if you use 'gpu')"
    echo "  -DPAPI=ON                    Enable PAPI performance counters"
    echo "  -DMAKE_TESTS=ON              Build tests"
    echo "  -DMAKE_TEST_FOR_DISASSEMBLY=ON  Build disassembly test"
    echo "  -DBUILD_PYTHON=ON            Build Python bindings (pybind11)"
    echo
    echo "Examples:"
    echo "  ./build.sh cpu"
    echo "  ./build.sh cpu -DBUILD_PYTHON=ON"
    echo "  ./build.sh gpu -DDEBUG=ON"
    echo "  ./build.sh all -DPAPI=ON -DBUILD_PYTHON=ON"
    echo
    echo "Note: Any additional CMake options are forwarded directly."
    exit 0
fi

# --- CPU build ---
if [[ $1 == "cpu" || $1 == "all" ]]; then
    rm -rf cpu_build
    mkdir cpu_build
    cd cpu_build
    cmake "${@:2}" ..
    make -j
    # If Python bindings are built, install into site-packages
    if [[ "${@:2}" == *"BUILD_PYTHON=ON"* ]]; then
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
