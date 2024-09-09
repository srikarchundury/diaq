#ifndef DIAQ_CONFIG_HPP
#define DIAQ_CONFIG_HPP

#include <thread>
#include <iostream>

#ifdef PAPI_ON
	#include <papi.h>
	#include <iomanip>
	#include <vector>
#endif

namespace diaq {

// ------- OpenMP related ------- //
#if defined(__x86_64__) || defined(_M_X64)
	#define HERE 1
	#define NUMBER_OF_OMP_THREADS (std::thread::hardware_concurrency()/2)
#else
	#define HERE 2
	#define NUMBER_OF_OMP_THREADS 32
#endif
// #define NUMBER_OF_OMP_THREADS 16

// ------- Vectorization related ------- //
// #if defined(__AVX__) || defined(__AVX2__)
// 	#define NUM_BYTES_ALIGNED _mm256_get_cache_line_size()
// #else
// 	#define NUM_BYTES_ALIGNED 4096
// #endif
#define NUM_BYTES_ALIGNED 256 // set -1 for unaligned then default behavior whatever compiler does it does!

// ------- Data type related ------- //
using valType = double; // double or float
#define VECTORIZATION_TYPE 1 // 0 for SSE, 1 for AVX, set -1 to run without vectorization

// ------- Debugging related ------- //
#define PRINT_WITH_LINE(fmt, ...) \
    printf("[File: %s, Line: %d] " fmt, __FILE__, __LINE__, ##__VA_ARGS__)

// ------- Cache related ------- //
#define TILE_SIZE 32
#define BLOCK_SIZE 128

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

} // namespace diaq

#endif // DIAQ_CONFIG_HPP