cmake_minimum_required(VERSION 3.0)
project(diaq)

# Set the source files
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(INC_DIR ${CMAKE_SOURCE_DIR}/include)
set(TESTS_DIR ${CMAKE_SOURCE_DIR}/tests)

set(SOURCES
    ${SRC_DIR}/config.hpp


	${SRC_DIR}/denseMatrix.hpp
	${SRC_DIR}/diagonal.hpp
	${SRC_DIR}/diaQMatrix.hpp
	${SRC_DIR}/Vector.hpp


	${SRC_DIR}/conversions.cpp

    ${SRC_DIR}/kernels.hpp

	${SRC_DIR}/matrixKernels.cpp

    ${SRC_DIR}/norms.hpp


	${SRC_DIR}/vectorKernels.cpp
)

# Set include directories
include_directories(${INC_DIR})


add_library(diaq ${SOURCES})
target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-march=native>) # Use -march=native for CPU
target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-O3>) # Use -O3 optimization level
# target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-Wall>) # Enable all warnings
# target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-Wextra>) # Enable extra warnings
target_compile_options(diaq PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-msse4.2>) # Support for SSE4.2
set_property(TARGET diaq PROPERTY POSITION_INDEPENDENT_CODE ON) # Add -fPIC flag for non-CUDA sources
set(BUILD_TYPE "cpu_build")

# Compile the tests.cpp file
add_executable(tests ${TESTS_DIR}/tests.cpp)
# Link your library to the tests
target_link_libraries(tests diaq)

# Set the output directory for the compiled libraries and executables
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/${BUILD_TYPE})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
