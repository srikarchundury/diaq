#!/bin/bash

rm -rf cpu_build
mkdir cpu_build
cd cpu_build
cmake ..
make

cd ..

rm -rf gpu_build
mkdir gpu_build
cd gpu_build
CUDA_ENABLED=1 cmake ..
make

