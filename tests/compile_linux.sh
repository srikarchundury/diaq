#!/bin/bash

PYTHON_INCLUDE=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")

if [ "$1" == "cuda" ]; then
    g++ --std=c++11 tests.cpp -g -fopenmp -lpthread -mavx2 -o tests.o
    nvcc -std=c++11 -Xcompiler -fopenmp ../src/conversions_gpu.cu -lcudart -lpthread -lpython3.8 -DCUDA_ENABLED -o conversions_gpu.o
    g++ tests.o conversions_gpu.o -g -lcudart -lpthread -DCUDA_ENABLED -o gpu_tests
if [ "$1" == "clean" ]; then
    rm tests*.o gpu_tests cpu_tests
else
    # g++ --std=c++11 tests_cpu.cpp -I/mnt/beegfs/schundu3/thesis/s-tnqs/lib64/python3.8/site-packages/pybind11/include -I$PYTHON_INCLUDE -g -fopenmp -lpthread -mavx2 -lpython3.8 -o tests
    g++ --std=c++11 tests_cpu.cpp -g -fopenmp -lpthread -mavx2 -o cpu_tests
fi
