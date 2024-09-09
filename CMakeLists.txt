cmake_minimum_required(VERSION 3.0)
project(diaq)

# Check if DEBUG variable is set
if(DEFINED DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
    add_definitions(-DDEBUG)  # Define DEBUG preprocessor flag
endif()

if(DEFINED DEEP_DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
    add_definitions(-DDEEP_DEBUG)  # Define DEEP_DEBUG preprocessor flag
endif()

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
	${SRC_DIR}/matrixKernels_gpu.hpp
	${SRC_DIR}/matrixKernels_gpu.cu
)

# Set include directories
include_directories(${INC_DIR})

# Check if CUDA_ENABLED variable is set
if(DEFINED CUDA_ENABLED)
    message(STATUS "CUDA is enabled")
    find_package(CUDA REQUIRED)
    set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS};-std=c++11)  # Add necessary NVCC flags here
    set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS};-Xcompiler -fPIC)  # Add -fPIC flag for CUDA compilation
    cuda_add_library(diaq SHARED ${SOURCES} ${CUDA_SOURCES})
    add_definitions(-DCUDA_ENABLED)  # Define CUDA_ENABLED preprocessor flag
    target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-march=native>) # Use -march=native for CPU vectorization
    target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-O3>) # Use -O3 optimization level
    # target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-Wall>) # Enable all warnings
    # target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-Wextra>) # Enable extra warnings
    target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-mavx2>) # Support for AVX2
    target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-msse2>) # Support for SSE2
    set_property(TARGET diaq PROPERTY POSITION_INDEPENDENT_CODE ON) # Add -fPIC flag for CUDA sources
    set(BUILD_TYPE "gpu_build")
else()
    message(STATUS "CUDA is not enabled")
    add_library(diaq SHARED ${SOURCES})
    target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-march=native>) # Use -march=native for CPU for automatic vectorization
    target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-O3>) # Use -O3 optimization level
    # target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-Wall>) # Enable all warnings
    # target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-Wextra>) # Enable extra warnings
    target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-mavx2>) # Support for AVX2
    target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-msse2>) # Support for SSE2
    set_property(TARGET diaq PROPERTY POSITION_INDEPENDENT_CODE ON) # Add -fPIC flag for non-CUDA sources
    set(BUILD_TYPE "cpu_build")

    # option(ENABLE_GPROF "Enable gprof profiling" OFF)
    # if(ENABLE_GPROF)
    #     message(STATUS "gprof profiling is enabled")
    #     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
    #     set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
    # endif()

endif()

# Check if PAPI_ON variable is set
if(DEFINED PAPI_ON)
    target_link_libraries(diaq $ENV{PAPI_DIR}/lib/libpapi.so)
    message(STATUS "PAPI is linked")
endif()

# Check if MAKE_TESTS variable is set
if(DEFINED MAKE_TESTS)
    # Compile the tests.cpp file
    add_executable(tests ${TESTS_DIR}/tests.cpp)
    # Link your library to the tests
    target_link_libraries(tests diaq)
    # Link PAPI library if PAPI_ON is defined to tests
    if(DEFINED PAPI_ON)
        target_link_libraries(tests $ENV{PAPI_DIR}/lib/libpapi.so)
    endif()
endif()


# Set the output directory for the compiled libraries and executables
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/${BUILD_TYPE})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
