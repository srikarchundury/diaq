cmake_minimum_required(VERSION 3.14)
project(diaq LANGUAGES CXX)

# ===== macOS: keep libc++ headers/runtime consistent (Homebrew clang case) =====
if(APPLE)
  # Ensure Python & system libc++ ABI expectations align
  if(NOT DEFINED CMAKE_OSX_DEPLOYMENT_TARGET)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "13.0" CACHE STRING "" FORCE)
  endif()

  # If using Homebrew LLVM clang, force SDK libc++ headers (avoid HB libc++ headers)
  if(CMAKE_CXX_COMPILER MATCHES "/opt/homebrew/.*/llvm/.*/bin/clang\\+\\+"
     OR CMAKE_CXX_COMPILER MATCHES "/opt/homebrew/opt/llvm/bin/clang\\+\\+")
    message(WARNING "Building with Homebrew clang: forcing SDK libc++ headers to match /usr/lib/libc++.1.dylib")

    if(NOT CMAKE_OSX_SYSROOT)
      execute_process(COMMAND xcrun --show-sdk-path
                      OUTPUT_VARIABLE _SDKROOT
                      OUTPUT_STRIP_TRAILING_WHITESPACE)
      set(CMAKE_OSX_SYSROOT "${_SDKROOT}" CACHE PATH "" FORCE)
    endif()

    set(_SDK_LIBCXX "${CMAKE_OSX_SYSROOT}/usr/include/c++/v1")
    add_compile_options(-nostdinc++)
    include_directories(SYSTEM "${_SDK_LIBCXX}")
    add_link_options(-lc++)
  endif()

  set(CMAKE_MACOSX_RPATH ON)
endif()

# ===== Colors for pretty messages =====
string(ASCII 27 Esc)
set(Reset       "${Esc}[m")
set(BoldBlue    "${Esc}[1;34m")
set(BoldGreen   "${Esc}[1;32m")
set(BoldRed     "${Esc}[1;31m")
set(BoldYellow  "${Esc}[1;33m")

# ===== C++ standard & global warnings (no -march globally) =====
message(STATUS "${BoldBlue}>>> Setting compiler flags and C++ standard${Reset}")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Keep warnings loud; don't hide useful ones
add_compile_options(
  -Wall -Wextra
  -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function
  -Wno-sign-compare
  -fPIC
)

include(CheckCXXCompilerFlag)

# ===== Layout (dirs & deps) =====
set(SRC_DIR   ${CMAKE_SOURCE_DIR}/src)
set(INC_DIR   ${CMAKE_SOURCE_DIR}/include)
set(TESTS_DIR ${CMAKE_SOURCE_DIR}/tests)
set(CPP_TESTS_DIR ${CMAKE_SOURCE_DIR}/cpp_tests)

set(PHMAP_DIR   ${CMAKE_SOURCE_DIR}/dependencies/parallel-hashmap)
add_subdirectory(${PHMAP_DIR}) # header-only but fine to add; keep consistent
set(PYBIND11_DIR ${CMAKE_SOURCE_DIR}/dependencies/pybind11)

# Headers for our code + phmap
include_directories(${INC_DIR} ${PHMAP_DIR})

# ===== OpenMP =====
find_package(OpenMP REQUIRED)
if(OpenMP_CXX_FOUND)
  message(STATUS "${BoldGreen}>>> OpenMP found! Flags: ${OpenMP_CXX_FLAGS}${Reset}")
else()
  message(FATAL_ERROR "${BoldRed}OpenMP not found!${Reset}")
endif()

# ===== Build options =====
option(DEBUG                      "Enable debugging mode"                             OFF)
option(DEEP_DEBUG                 "Enable deep debugging mode"                        OFF)
option(CUDA_ENABLED               "Enable CUDA support"                               OFF)
option(MANUAL_SIMD                "Enable manual SIMD kernel selection"               ON)
option(PAPI                       "Enable PAPI support"                               OFF)
option(MAKE_TESTS                 "Enable building tests"                             ON)
option(MAKE_TEST_FOR_DISASSEMBLY  "Enable building test_for_disassembly"              OFF)
option(BUILD_PYTHON               "Build Python bindings using pybind11"              ON)
option(AVOID_ZERO_DIAGS           "Avoid storing zero diagonals in sparse matrices"   ON)

message(STATUS "${BoldYellow}>>> Build options:${Reset}")
message(STATUS "  DEBUG = ${DEBUG}")
message(STATUS "  DEEP_DEBUG = ${DEEP_DEBUG}")
message(STATUS "  CUDA_ENABLED = ${CUDA_ENABLED}")
message(STATUS "  MANUAL_SIMD = ${MANUAL_SIMD}")
message(STATUS "  PAPI = ${PAPI}")
message(STATUS "  MAKE_TESTS = ${MAKE_TESTS}")
message(STATUS "  MAKE_TEST_FOR_DISASSEMBLY = ${MAKE_TEST_FOR_DISASSEMBLY}")
message(STATUS "  BUILD_PYTHON = ${BUILD_PYTHON}")
message(STATUS "  AVOID_ZERO_DIAGS = ${AVOID_ZERO_DIAGS}")

if(DEBUG OR DEEP_DEBUG)
  set(CMAKE_BUILD_TYPE Debug)
  add_definitions(-DDEBUG)
  if(DEEP_DEBUG)
    add_definitions(-DDEEP_DEBUG)
  endif()
  if(AVOID_ZERO_DIAGS)
    add_definitions(-DAVOID_ZERO_DIAGS)
  endif()
elseif(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

# ===== Cache detection (for kernel tuning) =====
set(L1_SIZE_BYTES 32768) # default 32 KiB
if(UNIX AND NOT APPLE)
  if(EXISTS "/sys/devices/system/cpu/cpu0/cache/index0/size")
    file(READ "/sys/devices/system/cpu/cpu0/cache/index0/size" L1_SIZE_RAW)
    string(REGEX MATCH "[0-9]+" L1_SIZE_NUM "${L1_SIZE_RAW}")
    if(L1_SIZE_NUM)
      math(EXPR L1_SIZE_BYTES "${L1_SIZE_NUM} * 1024")
    endif()
  endif()
elseif(APPLE)
  set(L1_SIZE_BYTES 65536)
endif()
add_compile_definitions(L1_CACHE_SIZE_BYTES=${L1_SIZE_BYTES})
message(STATUS "${BoldBlue}>>> Detected L1 cache size: ${L1_SIZE_BYTES} bytes${Reset}")

# ===== Arch detection =====
if(CMAKE_SYSTEM_PROCESSOR MATCHES "arm64|aarch64")
  set(DIAQ_ARCH_ARM64 ON)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64|i386|i686")
  set(DIAQ_ARCH_X86 ON)
endif()

if(APPLE AND DIAQ_ARCH_ARM64)
  set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "" FORCE)
endif()

# ===== Common sources =====
set(SOURCES
  # --- .hpp files ---
  ${SRC_DIR}/config.hpp
  ${SRC_DIR}/denseMatrix.hpp
  ${SRC_DIR}/diagonal.hpp
  ${SRC_DIR}/diaQMatrix.hpp
  ${SRC_DIR}/specialMatrices.hpp
  ${SRC_DIR}/vector.hpp
  ${SRC_DIR}/conversions.hpp
  ${SRC_DIR}/kernels.hpp
  ${SRC_DIR}/simd_kernels.hpp
  ${SRC_DIR}/matrixKernels.hpp
  ${SRC_DIR}/norms.hpp
  ${SRC_DIR}/vectorKernels.hpp
  ${SRC_DIR}/helpers.hpp
  # --- .cpp files ---
  ${SRC_DIR}/config.cpp
  ${SRC_DIR}/conversions.cpp
  ${SRC_DIR}/simd_kernels.cpp
  ${SRC_DIR}/matrixKernels.cpp
  ${SRC_DIR}/spGEMM.cpp
  ${SRC_DIR}/spME.cpp
  ${SRC_DIR}/spKron.cpp
  ${SRC_DIR}/denseKernels.cpp
  ${SRC_DIR}/additionKernels.cpp
  ${SRC_DIR}/reshapeKernels.cpp
  ${SRC_DIR}/transposeKernels.cpp
  ${SRC_DIR}/tensordotKernels.cpp
  ${SRC_DIR}/spMV_blocked.cpp
  # ${SRC_DIR}/spMV.cpp
  ${SRC_DIR}/norms.cpp
  ${SRC_DIR}/vectorKernels.cpp
  ${SRC_DIR}/helpers.cpp
)

# ===== SIMD backend: select ONE best, add per-target -m... flags =====
set(DIAQ_COMPILE_DEFS "")
unset(DIAQ_VEC_TYPE_VALUE)
set(DIAQ_SIMD_COMPILE_OPTS "")

if(MANUAL_SIMD)
  list(APPEND DIAQ_COMPILE_DEFS MANUAL_SIMD)
  if(DIAQ_ARCH_ARM64) # Apple
    list(APPEND SOURCES
      ${SRC_DIR}/simd_mac_kernels.hpp
      ${SRC_DIR}/simd_mac_kernels.cpp
    )
    list(APPEND DIAQ_COMPILE_DEFS CPU_SUPPORTS_NEON)
    set(DIAQ_VEC_TYPE_VALUE 3)
    message(STATUS "${BoldGreen}>>> SIMD backend: NEON/AdvSIMD (VEC_TYPE=3)${Reset}")

  elseif(DIAQ_ARCH_X86) # x86_64
    check_cxx_compiler_flag("-mavx512f" HAS_AVX512F)
    check_cxx_compiler_flag("-mavx2"    HAS_AVX2)
    check_cxx_compiler_flag("-msse2"    HAS_SSE2)

    if(HAS_AVX512F) # prioritize AVX-512 if available
      list(APPEND SOURCES
        ${SRC_DIR}/simd_avx512_kernels.hpp
        # ${SRC_DIR}/simd_avx512_kernels.cpp
        ${SRC_DIR}/simd_avx512_kernels_blocked.cpp
      )
      set(DIAQ_VEC_TYPE_VALUE 2)
      list(APPEND DIAQ_SIMD_COMPILE_OPTS -mavx512f -mavx512dq -mfma)
      list(APPEND DIAQ_COMPILE_DEFS CPU_SUPPORTS_AVX512F)
      message(STATUS "${BoldGreen}>>> SIMD backend: AVX-512 (VEC_TYPE=2)${Reset}")

    elseif(HAS_AVX2) # next, try AVX2
      list(APPEND SOURCES
        ${SRC_DIR}/simd_avx2_kernels.hpp
        ${SRC_DIR}/simd_avx2_kernels.cpp
      )
      set(DIAQ_VEC_TYPE_VALUE 1)
      list(APPEND DIAQ_SIMD_COMPILE_OPTS -mavx2 -mfma)
      list(APPEND DIAQ_COMPILE_DEFS CPU_SUPPORTS_AVX2)
      message(STATUS "${BoldGreen}>>> SIMD backend: AVX2 (VEC_TYPE=1)${Reset}")

    elseif(HAS_SSE2) # finally, try SSE2
      list(APPEND SOURCES
        ${SRC_DIR}/simd_sse_kernels.hpp
        ${SRC_DIR}/simd_sse_kernels.cpp
      )
      set(DIAQ_VEC_TYPE_VALUE 0)
      list(APPEND DIAQ_SIMD_COMPILE_OPTS -msse2)
      list(APPEND DIAQ_COMPILE_DEFS CPU_SUPPORTS_SSE2)
      message(STATUS "${BoldGreen}>>> SIMD backend: SSE2 (VEC_TYPE=0)${Reset}")

    else() # no SIMD support detected; fall back to auto vectorization of the compiler
      list(APPEND SOURCES
        ${SRC_DIR}/simd_nosimd_kernels.hpp
        ${SRC_DIR}/simd_nosimd_kernels.cpp
      )
      set(DIAQ_VEC_TYPE_VALUE -1)
      list(APPEND DIAQ_COMPILE_DEFS CPU_SUPPORTS_SCALAR)
      message(STATUS "${BoldYellow}>>> SIMD backend: SCALAR (VEC_TYPE=-1)${Reset}")
    endif()

  else() # unknown arch; fall back to auto vectorization again!
    check_cxx_compiler_flag("-mavx512f" HAS_AVX512F)
    check_cxx_compiler_flag("-mavx2"    HAS_AVX2)
    check_cxx_compiler_flag("-msse2"    HAS_SSE2)
    list(APPEND SOURCES
      ${SRC_DIR}/simd_nosimd_kernels.hpp
      ${SRC_DIR}/simd_nosimd_kernels.cpp
    )
    set(DIAQ_VEC_TYPE_VALUE -1)
    list(APPEND DIAQ_COMPILE_DEFS CPU_SUPPORTS_SCALAR)
    message(STATUS "${BoldYellow}>>> SIMD backend: SCALAR (VEC_TYPE=-1)${Reset}")
  endif()
else() # MANUAL_SIMD is OFF: rely on auto-vectorization, but still target best ISA
  check_cxx_compiler_flag("-mavx512f" HAS_AVX512F)
  check_cxx_compiler_flag("-mavx2"    HAS_AVX2)
  check_cxx_compiler_flag("-msse2"    HAS_SSE2)

  list(APPEND SOURCES
    ${SRC_DIR}/simd_nosimd_kernels.hpp
    ${SRC_DIR}/simd_nosimd_kernels.cpp
  )
  set(DIAQ_VEC_TYPE_VALUE -1)
  list(APPEND DIAQ_COMPILE_DEFS CPU_SUPPORTS_SCALAR)

  if(HAS_AVX512F)
    list(APPEND DIAQ_SIMD_COMPILE_OPTS -mavx512f -mavx512dq -mfma)
    message(STATUS "${BoldGreen}>>> SIMD disabled: auto-vectorization target AVX-512 (VEC_TYPE=-1)${Reset}")
  elseif(HAS_AVX2)
    list(APPEND DIAQ_SIMD_COMPILE_OPTS -mavx2 -mfma)
    message(STATUS "${BoldGreen}>>> SIMD disabled: auto-vectorization target AVX2 (VEC_TYPE=-1)${Reset}")
  elseif(HAS_SSE2)
    list(APPEND DIAQ_SIMD_COMPILE_OPTS -msse2)
    message(STATUS "${BoldGreen}>>> SIMD disabled: auto-vectorization target SSE2 (VEC_TYPE=-1)${Reset}")
  else()
    message(STATUS "${BoldYellow}>>> SIMD disabled: SCALAR only, no extra ISA flags (VEC_TYPE=-1)${Reset}")
  endif()
endif()

if(AVOID_ZERO_DIAGS)
  list(APPEND DIAQ_COMPILE_DEFS AVOID_ZERO_DIAGS)
endif()

# ===== CUDA (optional) =====
set(CUDA_SOURCES
  # --- .hpp files ---
  ${SRC_DIR}/conversions_gpu.hpp
  ${SRC_DIR}/matrixKernels_gpu.hpp
  # --- .cu files ---
  ${SRC_DIR}/conversions_gpu.cu
  ${SRC_DIR}/matrixKernels_gpu.cu
  ${SRC_DIR}/spGEMM_gpu.cu
  ${SRC_DIR}/spMV_gpu.cu
)

# ===== Core library target =====
if(CUDA_ENABLED)
  message(STATUS "${BoldBlue}>>> Building GPU version${Reset}")
  find_package(CUDA REQUIRED)
  set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -std=c++11 -Xcompiler -fPIC)
  # If SIMD compile opts were chosen, forward them to nvcc's host compiler
  if(DIAQ_SIMD_COMPILE_OPTS)
    foreach(_opt IN LISTS DIAQ_SIMD_COMPILE_OPTS)
      list(APPEND CUDA_NVCC_FLAGS -Xcompiler ${_opt})
    endforeach()
  endif()
  cuda_add_library(diaq_core SHARED ${SOURCES} ${CUDA_SOURCES})
  # Apply SIMD compile options to the target when present
  if(DIAQ_SIMD_COMPILE_OPTS)
    target_compile_options(diaq_core PUBLIC ${DIAQ_SIMD_COMPILE_OPTS} -O3)
  else()
    target_compile_options(diaq_core PUBLIC -O3)
  endif()
  target_link_libraries(diaq_core OpenMP::OpenMP_CXX)
  # Ensure CPU-specific compile defs (e.g., CPU_SUPPORTS_AVX512F) are visible to the target
  if(DIAQ_COMPILE_DEFS)
    target_compile_definitions(diaq_core PUBLIC CUDA_ENABLED ${DIAQ_COMPILE_DEFS})
  else()
    target_compile_definitions(diaq_core PUBLIC CUDA_ENABLED)
  endif()
  if(DEBUG)
    target_compile_definitions(diaq_core PUBLIC DEBUG)
  endif()
  if(DEEP_DEBUG)
    target_compile_definitions(diaq_core PUBLIC DEEP_DEBUG)
  endif()
  set(BUILD_TYPE "gpu_build")
else()
  message(STATUS "${BoldBlue}>>> Building CPU version${Reset}")
  add_library(diaq_core SHARED ${SOURCES})
  if(DIAQ_SIMD_COMPILE_OPTS)
    target_compile_options(diaq_core PUBLIC ${DIAQ_SIMD_COMPILE_OPTS} -O3)
  else()
    target_compile_options(diaq_core PUBLIC -O3)
  endif()
  if(DEBUG)
    target_compile_definitions(diaq_core PUBLIC DEBUG)
  endif()
  if(DEEP_DEBUG)
    target_compile_definitions(diaq_core PUBLIC DEEP_DEBUG)
  endif()
  target_link_libraries(diaq_core PUBLIC OpenMP::OpenMP_CXX)
  set(BUILD_TYPE "cpu_build")
endif()

# Ensure OpenMP compile flags are visible to all TUs (Linux Clang/GCC safety net)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  target_compile_options(diaq_core PUBLIC -fopenmp)
  target_link_options(diaq_core PUBLIC -fopenmp)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  target_compile_options(diaq_core PUBLIC -fopenmp)
  target_link_options(diaq_core PUBLIC -fopenmp)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "IntelLLVM")
  target_compile_options(diaq_core PUBLIC -qopenmp)
  target_link_options(diaq_core PUBLIC -qopenmp)
endif()

set_property(TARGET diaq_core PROPERTY POSITION_INDEPENDENT_CODE ON)

# Compile-time defs to the core target
if(DIAQ_COMPILE_DEFS)
  target_compile_definitions(diaq_core PUBLIC ${DIAQ_COMPILE_DEFS})
endif()
if(DEFINED DIAQ_VEC_TYPE_VALUE)
  target_compile_definitions(diaq_core PUBLIC VEC_TYPE=${DIAQ_VEC_TYPE_VALUE})
endif()

# ===== Optional PAPI =====
if(PAPI)
  include_directories($ENV{PAPI_DIR}/include)
  target_compile_definitions(diaq_core PUBLIC PAPI_ON)
  if(EXISTS "$ENV{PAPI_DIR}/lib/libpapi.so")
    target_link_libraries(diaq_core $ENV{PAPI_DIR}/lib/libpapi.so)
  else()
    message(FATAL_ERROR "${BoldRed}PAPI library not found at $ENV{PAPI_DIR}/lib/libpapi.so${Reset}")
  endif()
endif()

# ===== Tests (optional) =====
if(MAKE_TESTS)
  file(GLOB CPP_TEST_SOURCES
      ${CPP_TESTS_DIR}/*.cpp
  )
  add_executable(tests
      ${CPP_TEST_SOURCES}
  )
  # Set output directory based on the active binary dir
  set(TEST_BIN_DIR ${CMAKE_BINARY_DIR}/bin)
  set_target_properties(tests PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${TEST_BIN_DIR})
  target_link_libraries(tests PRIVATE diaq_core OpenMP::OpenMP_CXX)
  # mirror OpenMP compile flags for tests too (header pragmas)
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(tests PRIVATE -fopenmp)
    target_link_options(tests PRIVATE -fopenmp)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(tests PRIVATE -fopenmp)
    target_link_options(tests PRIVATE -fopenmp)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "IntelLLVM")
    target_compile_options(tests PRIVATE -qopenmp)
    target_link_options(tests PRIVATE -qopenmp)
  endif()
endif()

if(MAKE_TEST_FOR_DISASSEMBLY)
  add_library(test_for_disassembly_obj OBJECT ${TESTS_DIR}/test_for_disassembly.cpp)
  target_compile_options(test_for_disassembly_obj PRIVATE -O0)
  add_library(test_for_disassembly_static STATIC $<TARGET_OBJECTS:test_for_disassembly_obj>)
  set_target_properties(test_for_disassembly_static PROPERTIES OUTPUT_NAME test_for_disassembly)
  target_link_libraries(test_for_disassembly_static PRIVATE diaq_core OpenMP::OpenMP_CXX)
endif()

# ===== Output dirs =====
# Use the real build directory (cpu_build, gpu_build, or whatever -B specified)
set(LIBRARY_OUTPUT_PATH     ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH  ${CMAKE_BINARY_DIR}/bin)
message(STATUS "${BoldBlue}>>> Build output: ${CMAKE_BINARY_DIR}${Reset}")

# ===== Python bindings (pybind11) =====
if(BUILD_PYTHON)
  message(STATUS "${BoldBlue}>>> Building Python bindings (pybind11)${Reset}")
  add_subdirectory(${PYBIND11_DIR})
  pybind11_add_module(diaq ${INC_DIR}/pythonWrappers.cpp)
  target_link_libraries(diaq PRIVATE diaq_core)

  # Ensure the module also compiles with OpenMP flags (its TUs include your headers)
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(diaq PRIVATE -fopenmp)
    target_link_options(diaq PRIVATE -fopenmp)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(diaq PRIVATE -fopenmp)
    target_link_options(diaq PRIVATE -fopenmp)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "IntelLLVM")
    target_compile_options(diaq PRIVATE -qopenmp)
    target_link_options(diaq PRIVATE -qopenmp)
  endif()

  if(APPLE)
    set_target_properties(diaq PROPERTIES
      BUILD_RPATH   "${LIBRARY_OUTPUT_PATH}"
      INSTALL_RPATH "@loader_path/../lib;@rpath;${LIBRARY_OUTPUT_PATH}"
      MACOSX_RPATH  ON
    )
  else()
    set_target_properties(diaq PROPERTIES
      BUILD_RPATH   "${LIBRARY_OUTPUT_PATH}"
      INSTALL_RPATH "\$ORIGIN/../lib;${LIBRARY_OUTPUT_PATH}"
    )
  endif()

  # Install into the active env’s site-packages
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
  install(FILES ${LIBRARY_OUTPUT_PATH}/libdiaq_core.so DESTINATION ${PYTHON_SITE_DIR})
endif()
