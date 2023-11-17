#!/bin/bash

PYTHON_INCLUDE=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")

if [ "$1" == "cuda" ]; then
    nvcc -I/mnt/beegfs/schundu3/thesis/s-tnqs/lib64/python3.8/site-packages/pybind11/include -I$PYTHON_INCLUDE -std=c++11 -Xcompiler -fopenmp -o cuda_tests tests.cpp -lcudart -lpthread -lpython3.8 -DCUDA_ENABLED
else
    g++ --std=c++11 tests.cpp -I/mnt/beegfs/schundu3/thesis/s-tnqs/lib64/python3.8/site-packages/pybind11/include -I$PYTHON_INCLUDE -g -fopenmp -lpthread -mavx2 -lpython3.8 -o tests
fi
