#ifndef DIAQ_CONFIG_HPP
#define DIAQ_CONFIG_HPP

#include <thread>
#include <iostream>
#include <omp.h>
#include <cstring>
#include <algorithm> // For std::min

#ifdef PAPI_ON
	#include <papi.h>
	#include <iomanip>
	#include <vector>
#endif

namespace diaq {

// ------- OpenMP related ------- //
#if defined(__x86_64__) || defined(_M_X64)
	#define HERE 1
	#define NUMBER_OF_OMP_THREADS (std::thread::hardware_concurrency())
	// #define NUMBER_OF_OMP_THREADS 32
#else
	#define HERE 2
	#define NUMBER_OF_OMP_THREADS 32
#endif
// #define NUMBER_OF_OMP_THREADS 16
// ------------------------------- //


// ------- Data type related ------- //
using valType = double; // double or float
#define VECTORIZATION_TYPE 1 // 0 for SSE, 1 for AVX, set -1 to run without vectorization
// ------- Vectorization related ------- //
// #if defined(__AVX__) || defined(__AVX2__)
// 	#define NUM_BYTES_ALIGNED _mm256_get_cache_line_size()
// #else
// 	#define NUM_BYTES_ALIGNED 4096
// #endif
#define NUM_BYTES_ALIGNED 128 // set -1 for unaligned then default behavior whatever compiler does it does!
valType* aligned_alloc_helper(size_t size); // see config.cpp
// ------------------------------- //


// ------- Debugging related ------- //
#define PRINT_WITH_LINE(fmt, ...) \
    printf("[File: %s, Line: %d] " fmt, __FILE__, __LINE__, ##__VA_ARGS__)
// ------------------------------- //


// ------- Cache related ------- //
#define TILE_SIZE 32
#define BLOCK_SIZE 128
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