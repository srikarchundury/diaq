#ifndef DIAQ_CONFIG_HPP
#define DIAQ_CONFIG_HPP

#include <iostream>
#include <thread>
#include <omp.h>
#include <cstring>
#include <algorithm>
#include <cstdlib>
#include <memory>
#include <map>
#include <numeric>
#include <cstddef>
#include <unordered_map>
#include <vector>
#include <complex>
#include <string>
#include <type_traits>
#include <limits>
#include <cassert>
#include <functional>
#include <random>

#include <parallel_hashmap/phmap.h>

#ifdef PAPI_ON
	#include <papi.h>
	#include <iomanip>
	#include <vector>
#endif

namespace diaq {

// ------- OpenMP related ------- //
#if defined(__x86_64__) || defined(_M_X64)
	#define NUMBER_OF_OMP_THREADS (std::thread::hardware_concurrency())
#else
	#define NUMBER_OF_OMP_THREADS 32
#endif
// #define NUMBER_OF_OMP_THREADS 16
// ------------------------------- //


// ------- Data type related ------- //
 // double or float
using valType = double;
// ------------------------------- //

// ------- Vectorization related ------- //
#define VECTORIZATION_TYPE 2 // 0 for SSE, 1 for AVX, 2 for AVX512, set -1 to run without vectorization
#define NUM_BYTES_ALIGNED 64 // choose 32 for AVX, 64 for AVX512, 16 for SSE, -1 for no vectorization
#define VEC_WIDTH 8 // since double and AVX512... Other combinations are: 
valType* aligned_alloc_helper(unsigned int size); // see config.cpp
// ------------------------------- //


// ------- Debugging related ------- //
#define PRINT_WITH_LINE(fmt, ...) \
    printf("[File: %s, Line: %d] " fmt, __FILE__, __LINE__, ##__VA_ARGS__)
// ------------------------------- //


// ------- Cache related ------- //
#define BLOCK_SIZE 64
// ------------------------------- //


// ------- PAPI related ------- //
#ifdef PAPI_ON
	// Initialize PAPI library, create EventSet, add events..
	void initPAPI();
	// Start counting
	void startPAPI();
	// Stop counting and print results
	void stopPAPI(std::string);
	// Cleanup PAPI resources
	void cleanupPAPI();
#endif
// ------------------------------- //

class OMPInitializer {
public:
    OMPInitializer() {
        omp_set_dynamic(1);
        omp_set_num_threads(NUMBER_OF_OMP_THREADS);

		// // testing
        // std::cout << "OMP settings initialized with " << NUMBER_OF_OMP_THREADS 
        //           << " threads. Max threads: " << omp_get_max_threads() << std::endl;

        // #pragma omp parallel
        // {
		// 	std::cout << "In parallel region? " << omp_in_parallel() << std::endl;
        //     #pragma omp single
        //     {
        //         std::cout << "Number of threads in parallel region: " 
        //                   << omp_get_num_threads() << std::endl;
        //     }
        // }
    }
};

static OMPInitializer omp_initializer;  // Global object to trigger initialization

} // namespace diaq

#endif // DIAQ_CONFIG_HPP