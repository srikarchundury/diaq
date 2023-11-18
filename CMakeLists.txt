cmake_minimum_required(VERSION 3.0)
project(diaq)

# Set the source files
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(INC_DIR ${CMAKE_SOURCE_DIR}/include)

set(SOURCES
    ${SRC_DIR}/config.hpp

	${SRC_DIR}/denseMatrix.hpp
	${SRC_DIR}/diagonal.hpp
	${SRC_DIR}/diaQMatrix.hpp
	${SRC_DIR}/vector.hpp

	${SRC_DIR}/conversions.hpp
	${SRC_DIR}/conversions.cpp
	${SRC_DIR}/kernels.hpp
	${SRC_DIR}/matrixKernels.hpp
	${SRC_DIR}/matrixKernels.cpp
	${SRC_DIR}/norms.hpp
	${SRC_DIR}/norms.cpp
	${SRC_DIR}/vectorKernels.hpp
	${SRC_DIR}/vectorKernels.cpp
)

set(CUDA_SOURCES
	${SRC_DIR}/conversions_gpu.hpp
	${SRC_DIR}/conversions_gpu.cu
)

# Set include directories
include_directories(${INC_DIR})

# Check if CUDA_ENABLED variable is set
if(DEFINED ENV{CUDA_ENABLED} AND "$ENV{CUDA_ENABLED}" STREQUAL "1")
    message(STATUS "CUDA is enabled")
    find_package(CUDA REQUIRED)
    set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS};-std=c++11)  # Add necessary NVCC flags here
    cuda_add_library(diaq ${SOURCES} ${CUDA_SOURCES})
else()
    message(STATUS "CUDA is not enabled")
    add_library(diaq ${SOURCES})
endif()

# Set the output directory for the compiled libraries and executables
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
