# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)
# set(CMAKE_CXX_EXTENSIONS OFF)
#### comment out above to use C++11!! Currently using C++17, we can always change it back to C++11 if needed, the code is compatible with C++11

cmake_minimum_required(VERSION 3.0)
project(diaq)

# for warnings!
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-unknown-pragmas -Wno-unused-parameter -Wno-unused-variable")

include(CheckCXXCompilerFlag)

# Parallel Hashmap directory
set(PHMAP_DIR /mnt/beegfs/schundu3/thesis/parallel-hashmap)
# Add include directories
include_directories(${INC_DIR} ${PHMAP_DIR})

# Look for OpenMP package and set OpenMP flags
find_package(OpenMP REQUIRED)
if(OpenMP_CXX_FOUND)
    message(STATUS "OpenMP flags detected: ${OpenMP_CXX_FLAGS}")
else()
    message(FATAL_ERROR "OpenMP flags were not found!")
endif()

option(DEBUG "Enable debugging mode" OFF)
if(DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
    add_definitions(-DDEBUG)  # Define DEBUG preprocessor flag
endif()

option(DEEP_DEBUG "Enable deep debugging mode" OFF)
if(DEEP_DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
    add_definitions(-DDEEP_DEBUG)  # Define DEEP_DEBUG preprocessor flag
endif()

# L1 cache size detection!
file(READ "/sys/devices/system/cpu/cpu0/cache/index0/size" L1_SIZE_RAW)
string(REGEX MATCH "[0-9]+" L1_SIZE_NUM "${L1_SIZE_RAW}")
message(STATUS "********** L1 cache size detected: ${L1_SIZE_NUM} KB **********")
math(EXPR L1_SIZE_BYTES "${L1_SIZE_NUM} * 1024")
message(STATUS "L1 cache size detected: ${L1_SIZE_BYTES} bytes")
add_compile_definitions(L1_CACHE_SIZE_BYTES=${L1_SIZE_BYTES})

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

# set(CMAKE_CXX_FLAGS "-Wall -Wextra")
# set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

# Check if PAPI_ON variable is set
if(DEFINED PAPI_ON)
    message(STATUS "PAPI is enabled")
    # you might need to module avail papi and load it before you get here!
    message(STATUS "PAPI_DIR: $ENV{PAPI_DIR}")
    include_directories($ENV{PAPI_DIR}/include)
    add_definitions(-DPAPI_ON)  # Define PAPI_ON preprocessor flag
endif()

# Set the source files
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(INC_DIR ${CMAKE_SOURCE_DIR}/include)
set(TESTS_DIR ${CMAKE_SOURCE_DIR}/tests)

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

# Set include directories
include_directories(${INC_DIR})

# Add option for CUDA_ENABLED, default is OFF
option(CUDA_ENABLED "Enable CUDA support" OFF)
# Check if CUDA_ENABLED variable is set
if(CUDA_ENABLED)
        message(STATUS "CUDA is enabled")

        # Find CUDA package and set NVCC flags for CUDA compilation
        find_package(CUDA REQUIRED)

        # Set necessary NVCC flags for CUDA compilation
        set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -std=c++11)  # Ensure C++11 standard for CUDA
        set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -Xcompiler -fPIC)  # Add -fPIC flag for CUDA

        # Find OpenMP (if you need it for CPU parallelism)
        find_package(OpenMP REQUIRED)

        # Create shared CUDA library
        cuda_add_library(diaq SHARED ${SOURCES} ${CUDA_SOURCES})

        # Add preprocessor definition for CUDA
        add_definitions(-DCUDA_ENABLED)

        # Set compiler flags for C++ (CPU side)
        target_compile_options(diaq PRIVATE 
            $<$<COMPILE_LANGUAGE:CXX>:-march=native>  # Use -march=native for CPU vectorization
            $<$<COMPILE_LANGUAGE:CXX>:-O3>             # Use -O3 optimization level
        )

        # # Check for AVX-512 support
        # check_cxx_compiler_flag("-mavx512f" COMPILER_SUPPORTS_AVX512F)
        # check_cxx_compiler_flag("-mavx2" COMPILER_SUPPORTS_AVX2)
        # check_cxx_compiler_flag("-msse2" COMPILER_SUPPORTS_SSE2)

        # # Set the flags accordingly
        # if (COMPILER_SUPPORTS_AVX512F)
        #     message(STATUS "Compiling with AVX512F support")
        #     add_compile_options(-mavx512f)
        #     add_definitions(-DUSE_AVX512)
        # elseif (COMPILER_SUPPORTS_AVX2)
        #     message(STATUS "Compiling with AVX2 support")
        #     add_compile_options(-mavx2)
        #     add_definitions(-DUSE_AVX2)
        # elseif (COMPILER_SUPPORTS_SSE2)
        #     message(STATUS "Compiling with SSE2 support")
        #     add_compile_options(-msse2)
        #     add_definitions(-DUSE_SSE2)
        # else()
        #     message(STATUS "No SIMD support detected - compiling scalar")
        #     add_definitions(-DUSE_SCALAR)
        # endif()

        # Set position-independent code (PIC) for shared libraries
        set_property(TARGET diaq PROPERTY POSITION_INDEPENDENT_CODE ON)

        # Set the build type to GPU-based build
        set(BUILD_TYPE "gpu_build")

else()
        # Check if CUDA is enabled or not
        message(STATUS "CUDA is not enabled")

        # Add the diaq library as a shared library
        add_library(diaq SHARED ${SOURCES})

        # Set compilation options for the target (CPU vectorization, optimization)
        target_compile_options(diaq PRIVATE 
            $<$<COMPILE_LANGUAGE:CXX>:-march=native>  # Use -march=native for CPU for automatic vectorization
            $<$<COMPILE_LANGUAGE:CXX>:-O3>             # Use -O3 optimization level
        )

        # Read /proc/cpuinfo to detect hardware SIMD support
        file(READ "/proc/cpuinfo" CPUINFO_CONTENTS)

        # Set a variable based on detected flags
        if (CPUINFO_CONTENTS MATCHES "avx512f")
            message(STATUS "Detected AVX-512 in hardware")
            add_definitions(-DCPU_SUPPORTS_AVX512F)
        elseif (CPUINFO_CONTENTS MATCHES "avx2")
            message(STATUS "Detected AVX2 in hardware")
            add_definitions(-DCPU_SUPPORTS_AVX2)
        elseif (CPUINFO_CONTENTS MATCHES "sse2")
            message(STATUS "Detected SSE2 in hardware")
            add_definitions(-DCPU_SUPPORTS_SSE2)
        else()
            message(STATUS "No SIMD hardware support detected")
            add_definitions(-DCPU_SUPPORTS_SCALAR)
        endif()

        # Correctly link OpenMP to the `diaq` library
        target_link_libraries(diaq PRIVATE OpenMP::OpenMP_CXX)

        # Set position-independent code (PIC) for shared libraries
        set_property(TARGET diaq PROPERTY POSITION_INDEPENDENT_CODE ON)

        # Set build type to cpu_build (optional, depends on your needs)
        set(BUILD_TYPE "cpu_build")

        # Optionally enable gprof profiling if needed
        # option(ENABLE_GPROF "Enable gprof profiling" OFF)
        # if(ENABLE_GPROF)
        #     message(STATUS "gprof profiling is enabled")
        #     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
        #     set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
        # endif()
endif()

# Add option for PAPI_ON, default is OFF
option(PAPI_ON "Enable PAPI support" OFF)
if(PAPI_ON)
    target_link_libraries(diaq $ENV{PAPI_DIR}/lib/libpapi.so)
    message(STATUS "PAPI is linked")
endif()

# Add option for MAKE_TESTS, default is OFF
option(MAKE_TESTS "Enable building tests" OFF)
if(MAKE_TESTS)
    # Compile the tests.cpp file
    add_executable(tests ${TESTS_DIR}/tests.cpp)
    # Link the diaq library to the tests and OpenMP
    target_link_libraries(tests PRIVATE diaq OpenMP::OpenMP_CXX)
    # Link PAPI library if PAPI_ON is enabled
    if(PAPI_ON)
        target_link_libraries(tests $ENV{PAPI_DIR}/lib/libpapi.so)
    endif()
endif()

# Add option to make test_for_disassembly
option(MAKE_TEST_FOR_DISASSEMBLY "Enable building test_for_disassembly and its static lib" OFF)
if(MAKE_TEST_FOR_DISASSEMBLY)
    # Compile test_for_disassembly.cpp into an object file with minimal optimization
    add_library(test_for_disassembly_obj OBJECT ${TESTS_DIR}/test_for_disassembly.cpp)
    target_compile_options(test_for_disassembly_obj PRIVATE -O0)

    # Create a static library from the object
    add_library(test_for_disassembly_static STATIC $<TARGET_OBJECTS:test_for_disassembly_obj>)
    set_target_properties(test_for_disassembly_static PROPERTIES OUTPUT_NAME test_for_disassembly)

    # Link diaq and OpenMP to the object for static linking
    target_link_libraries(test_for_disassembly_static PRIVATE diaq OpenMP::OpenMP_CXX)

    # Optionally build an executable from the same object
    add_executable(test_for_disassembly_exec $<TARGET_OBJECTS:test_for_disassembly_obj>)
    target_link_libraries(test_for_disassembly_exec PRIVATE diaq OpenMP::OpenMP_CXX)

    # Link PAPI if enabled
    if(PAPI_ON)
        target_link_libraries(test_for_disassembly_static $ENV{PAPI_DIR}/lib/libpapi.so)
        target_link_libraries(test_for_disassembly_exec $ENV{PAPI_DIR}/lib/libpapi.so)
    endif()
endif()

# Set the output directory for the compiled libraries and executables
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/${BUILD_TYPE})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)