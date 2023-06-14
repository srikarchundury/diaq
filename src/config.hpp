#include <thread>
#include <iostream>

#if defined(__x86_64__) || defined(_M_X64)
	#define NUMBER_OF_OMP_THREADS std::thread::hardware_concurrency()
#else
	#define NUMBER_OF_OMP_THREADS 32
#endif
