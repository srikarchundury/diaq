#!/bin/bash
set -e
set -x

if [[ $1 == "cpu" || $1 == "all" ]]
then
    rm -rf cpu_build
    mkdir cpu_build
    cd cpu_build
    # cmake -DENABLE_GPROF=ON ..
    cmake .. -DCMAKE_BUILD_TYPE=Debug
    cmake ..
    make -j 4
    cd ..
fi

if [[ $1 == "gpu" || $1 == "all" ]]
then
    rm -rf gpu_build
    mkdir gpu_build
    cd gpu_build
    CUDA_ENABLED=1 cmake ..
    make -j 4
    cd ..
fi