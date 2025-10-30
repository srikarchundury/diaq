# cmake_minimum_required(VERSION 3.0)
cmake_minimum_required(VERSION 3.14)
project(diaq)

# macOS specifics
if(APPLE)
  # Enable modern rpath handling on macOS
  set(CMAKE_MACOSX_RPATH ON)
endif()

# ==============================================
# Colors for messages
# ==============================================
string(ASCII 27 Esc)
set(Reset "${Esc}[m")
set(BoldBlue "${Esc}[1;34m")
set(BoldGreen "${Esc}[1;32m")
set(BoldRed "${Esc}[1;31m")
set(BoldYellow "${Esc}[1;33m")

# ==============================================
# Compiler & standard
# ==============================================
message(STATUS "${BoldBlue}>>> Setting compiler flags and C++ standard${Reset}")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-sign-compare -fPIC")

include(CheckCXXCompilerFlag)

# ==============================================
# Directories and dependencies
# ==============================================
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(INC_DIR ${CMAKE_SOURCE_DIR}/include)
set(TESTS_DIR ${CMAKE_SOURCE_DIR}/tests)

set(PHMAP_DIR ${CMAKE_SOURCE_DIR}/dependencies/parallel-hashmap)
add_subdirectory(${PHMAP_DIR})

set(PYBIND11_DIR ${CMAKE_SOURCE_DIR}/dependencies/pybind11)
include_directories(${INC_DIR} ${PHMAP_DIR})

# ==============================================
# OpenMP
# ==============================================
find_package(OpenMP REQUIRED)
if(OpenMP_CXX_FOUND)
    message(STATUS "${BoldGreen}>>> OpenMP found! Flags: ${OpenMP_CXX_FLAGS}${Reset}")
else()
    message(FATAL_ERROR "${BoldRed}OpenMP not found!${Reset}")
endif()

# ==============================================
# Build options
# ==============================================
option(DEBUG "Enable debugging mode" OFF)
option(DEEP_DEBUG "Enable deep debugging mode" OFF)
option(CUDA_ENABLED "Enable CUDA support" OFF)
option(SIMD_ENABLED "Enable SIMD" ON)
option(PAPI "Enable PAPI support" OFF)
option(MAKE_TESTS "Enable building tests" OFF)
option(MAKE_TEST_FOR_DISASSEMBLY "Enable building test_for_disassembly" OFF)
option(BUILD_PYTHON "Build Python bindings using pybind11" ON)

message(STATUS "${BoldYellow}>>> Build options:${Reset}")
message(STATUS "  DEBUG = ${DEBUG}")
message(STATUS "  DEEP_DEBUG = ${DEEP_DEBUG}")
message(STATUS "  CUDA_ENABLED = ${CUDA_ENABLED}")
message(STATUS "  SIMD_ENABLED = ${SIMD_ENABLED}")
message(STATUS "  PAPI = ${PAPI}")
message(STATUS "  MAKE_TESTS = ${MAKE_TESTS}")
message(STATUS "  MAKE_TEST_FOR_DISASSEMBLY = ${MAKE_TEST_FOR_DISASSEMBLY}")
message(STATUS "  BUILD_PYTHON = ${BUILD_PYTHON}")

if(DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
    add_definitions(-DDEBUG)
endif()

if(DEEP_DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
    add_definitions(-DDEEP_DEBUG)
endif()

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_FLAGS_RELEASE "-O3")

# ==============================================
# Cache detection
# ==============================================
set(L1_SIZE_BYTES 32768) # safe default 32 KiB

if(UNIX AND NOT APPLE)
  if(EXISTS "/sys/devices/system/cpu/cpu0/cache/index0/size")
    file(READ "/sys/devices/system/cpu/cpu0/cache/index0/size" L1_SIZE_RAW)
    string(REGEX MATCH "[0-9]+" L1_SIZE_NUM "${L1_SIZE_RAW}")
    if(L1_SIZE_NUM)
      math(EXPR L1_SIZE_BYTES "${L1_SIZE_NUM} * 1024")
    endif()
  endif()
elseif(APPLE)
  # Try a few common L1 sizes; keep default if detection fails
  # Apple Silicon M1/M2/M3 typically 128 KiB L1I + 64 KiB L1D per core;
  # using 64 KiB is a reasonable conservative choice for data cache hints.
  set(L1_SIZE_BYTES 65536)
endif()

add_compile_definitions(L1_CACHE_SIZE_BYTES=${L1_SIZE_BYTES})
message(STATUS "${BoldBlue}>>> Detected L1 cache size: ${L1_SIZE_BYTES} bytes${Reset}")

# ==============================================
# SIMD option
# ==============================================
if(SIMD_ENABLED)
  add_definitions(-DSIMD_ENABLED)
  message(STATUS "${BoldGreen}>>> SIMD optimizations enabled${Reset}")

  # ==============================================
  # Auto-detect CPU SIMD capabilities (portable)
  # We avoid parsing /proc on macOS. Instead, infer by arch and compiler flags.
  # If you pass explicit flags (e.g., -mavx2), the compiler will set the macros.
  # We set *hints* for your code via compile definitions.
  # ==============================================
  if(APPLE)
    # Apple Silicon: use NEON/AdvSIMD
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "arm64|aarch64")
      add_definitions(-DCPU_SUPPORTS_NEON)
      message(STATUS "${BoldGreen}>>> CPU SIMD: NEON/AdvSIMD (Apple Silicon) assumed${Reset}")
    else()
      # Intel mac: prefer AVX2 if user compiles with -mavx2 or -march=native supports it.
      # We can't reliably probe here; leave scalar hint off and rely on compiler flags.
      message(STATUS "${BoldYellow}>>> On Intel macOS: pass -mavx2 if available to enable AVX2 code paths${Reset}")
    endif()
  elseif(UNIX AND NOT APPLE)
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
  else()
    # Fallback for other platforms
    add_definitions(-DCPU_SUPPORTS_SCALAR)
    message(STATUS "${BoldYellow}>>> Unknown platform; defaulting to SCALAR fallback${Reset}")
  endif()

else()
  message(STATUS "${BoldYellow}>>> SIMD_ENABLED set to OFF, skipping CPU SIMD detection${Reset}")
endif()

# ==============================================
# Sources
# ==============================================
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

# ==============================================
# CPU / GPU core library
# ==============================================
if(CUDA_ENABLED)
    message(STATUS "${BoldBlue}>>> Building GPU version${Reset}")
    find_package(CUDA REQUIRED)
    set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -std=c++11 -Xcompiler -fPIC)

    cuda_add_library(diaq_core SHARED ${SOURCES} ${CUDA_SOURCES})
    add_definitions(-DCUDA_ENABLED)
    target_compile_options(diaq_core PRIVATE -march=native -O3 ${OpenMP_CXX_FLAGS})
    target_link_libraries(diaq_core PRIVATE OpenMP::OpenMP_CXX)
    set_property(TARGET diaq_core PROPERTY POSITION_INDEPENDENT_CODE ON)
    set(BUILD_TYPE "gpu_build")

else()
    message(STATUS "${BoldBlue}>>> Building CPU version${Reset}")
    # On macOS, using Apple Clang, OpenMP isn't built-in.
    if(APPLE)
        message(STATUS "${BoldYellow}>>> macOS detected. If OpenMP fails, use Homebrew LLVM.${Reset}")
    endif()
    add_library(diaq_core SHARED ${SOURCES})

    # ==============================================
    # Compiler-specific tuning
    # ==============================================
    if (CMAKE_CXX_COMPILER_ID STREQUAL "Cray")
        message(STATUS "${BoldYellow}>>> Cray compiler detected: adding libsci and preload fix${Reset}")
        target_compile_options(diaq_core PRIVATE -O3 -h aggressive --std=c++17 -fopenmp)
        target_link_libraries(diaq_core PRIVATE OpenMP::OpenMP_CXX)
        # Link libsci (Cray optimized math)
        find_library(LIBSCI NAMES sci_cray_mp PATHS /opt/cray/pe/lib64)
        if(LIBSCI)
            target_link_libraries(diaq_core PRIVATE ${LIBSCI})
        endif()
        # Export LD_PRELOAD automatically
        set_property(TARGET diaq_core APPEND PROPERTY INSTALL_RPATH_USE_LINK_PATH TRUE)
    else()
        # GNU or other compilers
        message(STATUS "${BoldYellow}>>> GNU compiler detected: applying OpenMP flags globally${Reset}")

        # Apply flags globally to avoid ignored pragmas in headers
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS} -fopenmp")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS} -fopenmp")

        target_compile_options(diaq_core PRIVATE -march=native -O3)
        target_link_libraries(diaq_core PRIVATE OpenMP::OpenMP_CXX)
    endif()

    set_property(TARGET diaq_core PROPERTY POSITION_INDEPENDENT_CODE ON)
    set(BUILD_TYPE "cpu_build")
endif()

# ==============================================
# Optional PAPI
# ==============================================
if(PAPI)
    include_directories($ENV{PAPI_DIR}/include)
    add_definitions(-DPAPI_ON)
    if(EXISTS "$ENV{PAPI_DIR}/lib/libpapi.so")
        target_link_libraries(diaq_core $ENV{PAPI_DIR}/lib/libpapi.so)
    else()
        message(FATAL_ERROR "${BoldRed}PAPI library not found at $ENV{PAPI_DIR}/lib/libpapi.so${Reset}")
    endif()
endif()

# ==============================================
# Tests
# ==============================================
if(MAKE_TESTS)
    add_executable(tests ${TESTS_DIR}/tests.cpp)
    target_link_libraries(tests PRIVATE diaq_core OpenMP::OpenMP_CXX)
endif()

if(MAKE_TEST_FOR_DISASSEMBLY)
    add_library(test_for_disassembly_obj OBJECT ${TESTS_DIR}/test_for_disassembly.cpp)
    target_compile_options(test_for_disassembly_obj PRIVATE -O0)
    add_library(test_for_disassembly_static STATIC $<TARGET_OBJECTS:test_for_disassembly_obj>)
    set_target_properties(test_for_disassembly_static PROPERTIES OUTPUT_NAME test_for_disassembly)
    target_link_libraries(test_for_disassembly_static PRIVATE diaq_core OpenMP::OpenMP_CXX)
endif()

# ==============================================
# Output directories
# ==============================================
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/${BUILD_TYPE})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
message(STATUS "${BoldBlue}>>> Build output: ${CMAKE_BINARY_DIR}${Reset}")

# ==============================================
# Python bindings with RPATH fix
# ==============================================
if(BUILD_PYTHON)
    message(STATUS "${BoldBlue}>>> Building Python bindings (pybind11)${Reset}")
    add_subdirectory(${PYBIND11_DIR})
    pybind11_add_module(diaq ${INC_DIR}/pythonWrappers.cpp)
    target_link_libraries(diaq PRIVATE diaq_core)

    # # RPATH fix: ensure Python module can find libdiaq_core.so
    # set_target_properties(diaq PROPERTIES
    #     BUILD_RPATH "${LIBRARY_OUTPUT_PATH}"
    #     INSTALL_RPATH "${LIBRARY_OUTPUT_PATH}"
    # )

    # RPATH for Python extension to find libdiaq_core
    if(APPLE)
        # Use @loader_path so the extension can find the sibling lib in ../lib
        set_target_properties(diaq PROPERTIES
            BUILD_RPATH "${LIBRARY_OUTPUT_PATH}"
            INSTALL_RPATH "@loader_path/../lib;@rpath;${LIBRARY_OUTPUT_PATH}"
            MACOSX_RPATH ON
        )
    else()
        set_target_properties(diaq PROPERTIES
            BUILD_RPATH "${LIBRARY_OUTPUT_PATH}"
            INSTALL_RPATH "${LIBRARY_OUTPUT_PATH}"
        )
    endif()

    # Find Python installation path
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
