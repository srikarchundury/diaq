# Compiler
CXX := g++
NVCC := nvcc
# Flags
CXXFLAGS := -std=c++11 -g -fopenmp -lpthread -mavx2
NVCCFLAGS := -std=c++11
LIBS := -L/usr/local/cuda/lib64 -lcudart -lpthread -lpython3.8

# Python include directory
PYTHON_INCLUDE := $(shell python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")


again: clean all

all: gpu_tests cpu_tests

gpu_tests: tests.o conversions_gpu.o
	$(CXX) $^ -o $@ ${CXXFLAGS} $(LIBS) -DCUDA_ENABLED

cpu_tests: tests_cpu.o
	$(CXX) $^ -o $@ $(CXXFLAGS)

tests.o: tests.cpp
	$(CXX) -c $< -o $@ $(CXXFLAGS)

conversions_gpu.o: ../src/conversions_gpu.cu
	$(NVCC) -c $< -o $@ $(NVCCFLAGS) $(LIBS) -DCUDA_ENABLED

tests_cpu.o: tests.cpp
	$(CXX) -c $< -o $@ $(CXXFLAGS)

clean:
	rm -f *.o gpu_tests cpu_tests
