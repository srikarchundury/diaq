#ifndef DIAQ_CONFIG_HPP
#define DIAQ_CONFIG_HPP

#include <thread>
#include <iostream>

#if defined(__x86_64__) || defined(_M_X64)
	#define NUMBER_OF_OMP_THREADS std::thread::hardware_concurrency()
#else
	#define NUMBER_OF_OMP_THREADS 32
#endif

// #if defined(__AVX__) || defined(__AVX2__)
// 	#define NUM_BYTES_ALIGNED _mm256_get_cache_line_size()
// #else
// 	#define NUM_BYTES_ALIGNED 4096
// #endif

#define NUM_BYTES_ALIGNED -1 // set -1 for unaligned then default behavior whatever compiler does it does!
using valType = float; // double has issues, working on it!! TODO
#define VECTORIZATION_TYPE 1 // 0 for SSE, 1 for AVX

#include "logger.hpp"
extern Logger logger;

#endif // DIAQ_CONFIG_HPP