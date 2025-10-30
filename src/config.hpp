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
using valType = double; // double or float
// ------------------------------- //


// ------- Vectorization related ------- //
#if defined(SIMD_ENABLED)
  #if defined(CPU_SUPPORTS_AVX512F)
    #define VEC_TYPE 2 // AVX-512
    #define NUM_BYTES_ALIGNED 64
    #define VEC_WIDTH 8
  #elif defined(CPU_SUPPORTS_AVX2)
    #define VEC_TYPE 1 // AVX2
    #define NUM_BYTES_ALIGNED 32
    #define VEC_WIDTH 4
  #elif defined(CPU_SUPPORTS_SSE2)
    #define VEC_TYPE 0 // SSE2
    #define NUM_BYTES_ALIGNED 16
    #define VEC_WIDTH 2
  #elif defined(__aarch64__) || defined(__ARM_NEON)
    #define VEC_TYPE 3 // NEON/AdvSIMD
    #define NUM_BYTES_ALIGNED 16
    #define VEC_WIDTH 2
  #else
    #define VEC_TYPE -1
    #define NUM_BYTES_ALIGNED -1
    #define VEC_WIDTH 1
  #endif
#else
  #define VEC_TYPE -1
  #define NUM_BYTES_ALIGNED -1
  #define VEC_WIDTH 1
#endif

#define PREFETCH_DIST (2 * VEC_WIDTH)

#if defined(__x86_64__) || defined(_M_X64)
  #include <immintrin.h>
  #define DIAQ_PREFETCH_T0(addr) _mm_prefetch(reinterpret_cast<const char*>(addr), _MM_HINT_T0)
#elif defined(__aarch64__) || defined(__ARM_NEON)
  // Works on Apple Silicon (Clang/GCC)
  #define DIAQ_PREFETCH_T0(addr) __builtin_prefetch((addr), 0, PREFETCH_DIST)
#else
  #define DIAQ_PREFETCH_T0(addr) ((void)0)
#endif
#if defined(__x86_64__) || defined(_M_X64)
  #define DIAQ_X86_ONLY(code) do { code } while(0)
#else
  #define DIAQ_X86_ONLY(code) do { } while(0)
#endif


// ------- L1 Cache Auto-Detection or Override ------- //
#ifndef L1_CACHE_SIZE_BYTES
	// Fallback assumption: 32KB
	#define L1_CACHE_SIZE_BYTES 32768
#endif

// utilization ratio
#define CACHE_UTILIZATION 0.95
#define NUM_ARRAYS_ACCESSED 6

#define BLOCK_SIZE_RAW (int)((L1_CACHE_SIZE_BYTES * CACHE_UTILIZATION) / (NUM_ARRAYS_ACCESSED * sizeof(diaq::valType)))
#define BLOCK_SIZE ((BLOCK_SIZE_RAW / VEC_WIDTH) * VEC_WIDTH > 0 ? (BLOCK_SIZE_RAW / VEC_WIDTH) * VEC_WIDTH : VEC_WIDTH)
// Alloc helper
valType* aligned_alloc_helper(unsigned int size);
void print_simd_info();
// ------------------------------- //


// ------- Debugging related ------- //
#define PRINT_WITH_LINE(fmt, ...) \
    printf("[File: %s, Line: %d] " fmt, __FILE__, __LINE__, ##__VA_ARGS__)
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
        omp_set_dynamic(0);
		// omp_set_nested(1); // Enable nested parallelism // this is very bad!
        // omp_set_num_threads(NUMBER_OF_OMP_THREADS); // useless!

		if (!std::getenv("OMP_NUM_THREADS")) {
			// Fall back to how many CPUs we actually have in this cpuset.
			#ifdef __linux__
				cpu_set_t set; CPU_ZERO(&set);
				if (sched_getaffinity(0, sizeof(set), &set) == 0) {
					omp_set_num_threads(CPU_COUNT(&set));
				} else {
					omp_set_num_threads(std::max(1u, std::thread::hardware_concurrency()));
				}
			#else
				omp_set_num_threads(std::max(1u, std::thread::hardware_concurrency()));
			#endif
		}

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
