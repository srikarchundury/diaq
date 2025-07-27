cmake_minimum_required(VERSION 3.0)
project(diaq)

# Colors for messages
string(ASCII 27 Esc)
set(Reset "${Esc}[m")
set(BoldBlue "${Esc}[1;34m")
set(BoldGreen "${Esc}[1;32m")
set(BoldRed "${Esc}[1;31m")
set(BoldYellow "${Esc}[1;33m")

# =====================================================
# Compiler and standard settings
# =====================================================
message(STATUS "${BoldBlue}>>> Setting compiler flags and C++ standard${Reset}")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-unknown-pragmas -Wno-unused-parameter -Wno-unused-variable -Wno-c++17-extensions -Wno-pass-failed=transform-warning")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")

include(CheckCXXCompilerFlag)

# =====================================================
# Directories and dependencies
# =====================================================
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(INC_DIR ${CMAKE_SOURCE_DIR}/include)
set(TESTS_DIR ${CMAKE_SOURCE_DIR}/tests)

# Parallel Hashmap
set(PHMAP_DIR ${CMAKE_SOURCE_DIR}/dependencies/parallel-hashmap)
add_subdirectory(${PHMAP_DIR})

# Pybind11
set(PYBIND11_DIR ${CMAKE_SOURCE_DIR}/dependencies/pybind11)

# Includes
include_directories(${INC_DIR} ${PHMAP_DIR})

# =====================================================
# OpenMP
# =====================================================
find_package(OpenMP REQUIRED)
if(OpenMP_CXX_FOUND)
    message(STATUS "${BoldGreen}>>> OpenMP found! Flags: ${OpenMP_CXX_FLAGS}${Reset}")
else()
    message(FATAL_ERROR "${BoldRed}OpenMP not found!${Reset}")
endif()

# =====================================================
# Build options
# =====================================================
option(DEBUG "Enable debugging mode" OFF)
option(DEEP_DEBUG "Enable deep debugging mode" OFF)
option(CUDA_ENABLED "Enable CUDA support" OFF)
option(PAPI "Enable PAPI support" OFF)
option(MAKE_TESTS "Enable building tests" OFF)
option(MAKE_TEST_FOR_DISASSEMBLY "Enable building test_for_disassembly" OFF)
option(BUILD_PYTHON "Build Python bindings using pybind11" OFF)

message(STATUS "${BoldYellow}>>> Build options:${Reset}")
message(STATUS "  DEBUG = ${DEBUG}")
message(STATUS "  DEEP_DEBUG = ${DEEP_DEBUG}")
message(STATUS "  CUDA_ENABLED = ${CUDA_ENABLED}")
message(STATUS "  PAPI = ${PAPI}")
message(STATUS "  MAKE_TESTS = ${MAKE_TESTS}")
message(STATUS "  MAKE_TEST_FOR_DISASSEMBLY = ${MAKE_TEST_FOR_DISASSEMBLY}")
message(STATUS "  BUILD_PYTHON = ${BUILD_PYTHON}")

if(DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
    add_definitions(-DDEBUG)
    message(STATUS "${BoldYellow}>>> Debugging mode enabled (-DDEBUG)${Reset}")
endif()

if(DEEP_DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
    add_definitions(-DDEEP_DEBUG)
    message(STATUS "${BoldYellow}>>> Deep Debugging mode enabled (-DDEEP_DEBUG)${Reset}")
endif()

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

# =====================================================
# Cache and SIMD detection
# =====================================================
file(READ "/sys/devices/system/cpu/cpu0/cache/index0/size" L1_SIZE_RAW)
string(REGEX MATCH "[0-9]+" L1_SIZE_NUM "${L1_SIZE_RAW}")
math(EXPR L1_SIZE_BYTES "${L1_SIZE_NUM} * 1024")
add_compile_definitions(L1_CACHE_SIZE_BYTES=${L1_SIZE_BYTES})
message(STATUS "${BoldBlue}>>> Detected L1 cache size: ${L1_SIZE_BYTES} bytes${Reset}")

file(READ "/proc/cpuinfo" CPUINFO_CONTENTS)
if (CPUINFO_CONTENTS MATCHES "avx512f")
    add_definitions(-DCPU_SUPPORTS_AVX512F)
    message(STATUS "${BoldGreen}>>> CPU SIMD: AVX-512 detected${Reset}")
elseif (CPUINFO_CONTENTS MATCHES "avx2")
    add_definitions(-DCPU_SUPPORTS_AVX2)
    message(STATUS "${BoldGreen}>>> CPU SIMD: AVX2 detected${Reset}")
elseif (CPUINFO_CONTENTS MATCHES "sse2")
    add_definitions(-DCPU_SUPPORTS_SSE2)
    message(STATUS "${BoldGreen}>>> CPU SIMD: SSE2 detected${Reset}")
else()
    add_definitions(-DCPU_SUPPORTS_SCALAR)
    message(STATUS "${BoldRed}>>> No SIMD detected, using SCALAR fallback${Reset}")
endif()

# =====================================================
# Optional PAPI
# =====================================================
if(PAPI)
    include_directories($ENV{PAPI_DIR}/include)
    add_definitions(-DPAPI_ON)
    message(STATUS "${BoldGreen}>>> PAPI enabled${Reset}")
endif()

# =====================================================
# Sources
# =====================================================
set(SOURCES
    ${SRC_DIR}/config.hpp
    ${SRC_DIR}/config.cpp
    ${SRC_DIR}/denseMatrix.hpp
    ${SRC_DIR}/diagonal.hpp
    ${SRC_DIR}/diaQMatrix.hpp
    ${SRC_DIR}/specialMatrices.hpp
    ${SRC_DIR}/vector.hpp
    ${SRC_DIR}/conversions.hpp
    ${SRC_DIR}/conversions.cpp
    ${SRC_DIR}/kernels.hpp
    ${SRC_DIR}/simd_kernels.hpp
    ${SRC_DIR}/simd_kernels.cpp
    ${SRC_DIR}/matrixKernels.hpp
    ${SRC_DIR}/matrixKernels.cpp
    ${SRC_DIR}/norms.hpp
    ${SRC_DIR}/norms.cpp
    ${SRC_DIR}/vectorKernels.hpp
    ${SRC_DIR}/vectorKernels.cpp
    ${SRC_DIR}/helpers.hpp
    ${SRC_DIR}/helpers.cpp
)

set(CUDA_SOURCES
    ${SRC_DIR}/conversions_gpu.hpp
    ${SRC_DIR}/conversions_gpu.cu
    ${SRC_DIR}/matrixKernels_gpu.hpp
    ${SRC_DIR}/matrixKernels_gpu.cu
)

# =====================================================
# CPU / GPU core library
# =====================================================
if(CUDA_ENABLED)
    message(STATUS "${BoldBlue}>>> Building GPU version${Reset}")
    find_package(CUDA REQUIRED)
    set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -std=c++11 -Xcompiler -fPIC)

    cuda_add_library(diaq_core SHARED ${SOURCES} ${CUDA_SOURCES})
    add_definitions(-DCUDA_ENABLED)
    target_compile_options(diaq_core PRIVATE -march=native -O3)
    set_property(TARGET diaq_core PROPERTY POSITION_INDEPENDENT_CODE ON)
    set(BUILD_TYPE "gpu_build")
else()
    message(STATUS "${BoldBlue}>>> Building CPU version${Reset}")
    add_library(diaq_core SHARED ${SOURCES})
    target_compile_options(diaq_core PRIVATE -march=native -O3)
    target_link_libraries(diaq_core PRIVATE OpenMP::OpenMP_CXX)
    set_property(TARGET diaq_core PROPERTY POSITION_INDEPENDENT_CODE ON)
    set(BUILD_TYPE "cpu_build")
endif()

if(PAPI)
    if(EXISTS "$ENV{PAPI_DIR}/lib/libpapi.so")
        target_link_libraries(diaq_core $ENV{PAPI_DIR}/lib/libpapi.so)
    else()
        message(FATAL_ERROR "${BoldRed}PAPI library not found at $ENV{PAPI_DIR}/lib/libpapi.so${Reset}")
    endif()
endif()

# =====================================================
# Tests and Disassembly targets
# =====================================================
if(MAKE_TESTS)
    message(STATUS "${BoldBlue}>>> Building tests.cpp${Reset}")
    add_executable(tests ${TESTS_DIR}/tests.cpp)
    target_link_libraries(tests PRIVATE diaq_core OpenMP::OpenMP_CXX)
    if(PAPI)
        target_link_libraries(tests $ENV{PAPI_DIR}/lib/libpapi.so)
    endif()
endif()

if(MAKE_TEST_FOR_DISASSEMBLY)
    message(STATUS "${BoldBlue}>>> Building test_for_disassembly${Reset}")
    add_library(test_for_disassembly_obj OBJECT ${TESTS_DIR}/test_for_disassembly.cpp)
    target_compile_options(test_for_disassembly_obj PRIVATE -O0)
    add_library(test_for_disassembly_static STATIC $<TARGET_OBJECTS:test_for_disassembly_obj>)
    set_target_properties(test_for_disassembly_static PROPERTIES OUTPUT_NAME test_for_disassembly)
    target_link_libraries(test_for_disassembly_static PRIVATE diaq_core OpenMP::OpenMP_CXX)

    add_executable(test_for_disassembly_exec $<TARGET_OBJECTS:test_for_disassembly_obj>)
    target_link_libraries(test_for_disassembly_exec PRIVATE diaq_core OpenMP::OpenMP_CXX)

    if(PAPI)
        target_link_libraries(test_for_disassembly_static $ENV{PAPI_DIR}/lib/libpapi.so)
        target_link_libraries(test_for_disassembly_exec $ENV{PAPI_DIR}/lib/libpapi.so)
    endif()
endif()

# =====================================================
# Output directories
# =====================================================
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/${BUILD_TYPE})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
message(STATUS "${BoldBlue}>>> Build output: ${CMAKE_BINARY_DIR}${Reset}")

# =====================================================
# Python bindings
# =====================================================
if(BUILD_PYTHON)
    message(STATUS "${BoldBlue}>>> Building Python bindings (pybind11)${Reset}")
    add_subdirectory(${PYBIND11_DIR})
    pybind11_add_module(diaq ${INC_DIR}/pythonWrappers.cpp)
    target_link_libraries(diaq PRIVATE diaq_core)

    # Try to pick up the Python executable from the environment first
    if(DEFINED ENV{VIRTUAL_ENV})
        set(Python3_EXECUTABLE "$ENV{VIRTUAL_ENV}/bin/python")
    elseif(DEFINED ENV{CONDA_PREFIX})
        set(Python3_EXECUTABLE "$ENV{CONDA_PREFIX}/bin/python")
    endif()
    find_package(Python3 COMPONENTS Interpreter REQUIRED)

    execute_process(
        COMMAND ${Python3_EXECUTABLE} -c "import site; print(site.getsitepackages()[0])"
        OUTPUT_VARIABLE PYTHON_SITE_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    message(STATUS "${BoldGreen}>>> Installing Python module directly into: ${PYTHON_SITE_DIR}${Reset}")
    install(TARGETS diaq LIBRARY DESTINATION ${PYTHON_SITE_DIR})
endif()
