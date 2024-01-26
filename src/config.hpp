#ifndef DIAQ_CONFIG_HPP
#define DIAQ_CONFIG_HPP

#include <thread>
#include <iostream>

#include "logger.hpp"

namespace diaq {

// #if defined(__x86_64__) || defined(_M_X64)
// 	#define NUMBER_OF_OMP_THREADS std::thread::hardware_concurrency()
// #else
// 	#define NUMBER_OF_OMP_THREADS 32
// #endif

#define NUMBER_OF_OMP_THREADS 16

// #if defined(__AVX__) || defined(__AVX2__)
// 	#define NUM_BYTES_ALIGNED _mm256_get_cache_line_size()
// #else
// 	#define NUM_BYTES_ALIGNED 4096
// #endif

#define NUM_BYTES_ALIGNED -1 // set -1 for unaligned then default behavior whatever compiler does it does!
using valType = double; // double or float
#define VECTORIZATION_TYPE 1 // 0 for SSE, 1 for AVX, set -1 to run without vectorization

extern Logger logger;

} // namespace diaq

#endif // DIAQ_CONFIG_HPP