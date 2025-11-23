#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x) {
    std::shared_ptr<vector> y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spMV(A, x, y);
    // x goes out of scope here and would be deleted by shared_ptr!
    return y;
}

// ------------- START OF SPMV ------------- //

// ---------------------------------------------
// // // first version
// void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
//     #ifdef CUDA_ENABLED
//         return spmv_cuda(A, x);
//     #else
//     #ifdef DEEP_DEBUG
//         std::cout << " --- " << std::endl;
//         std::cout << " --- spMV --- " << std::endl;
//         std::cout << " --- " << std::endl;
//         A->print();
//         std::cout << " --- times --- " << std::endl;
//         x->print();
//         std::cout << " --- " << std::endl;
//         printf("Analyzing SpM\n");
//         A->print_meta();
//         printf("Analyzing V\n");
//         x->print_meta();
//         printf("Analyzing Y\n");
//         y->print_meta();
//     #endif

//     #ifdef DEBUG
//         // measure start timer
//         printf("starting spMV --");
//         std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
//     #endif

//     valType *y_real_values = y->realValues;
//     valType *y_imag_values = y->imagValues;

//     valType *x_real_values = x->realValues;
//     valType *x_imag_values = x->imagValues;

//     size_t total_diagonals = A->dIndices.size();

//     unsigned int batchSize = 4;
//     // #pragma omp parallel for // can't parallelize, because there's overwrite across diagonals!, but I batch them? run each batch in parallel and get 4 times the speed?
//     for (size_t batch_start = 0; batch_start < total_diagonals; batch_start += batchSize) {
//         size_t batch_end = std::min(batch_start + batchSize, total_diagonals);

//         for (size_t a = batch_start; a < batch_end; ++a) {
//     // #pragma omp parallel for // this can be sequential since there will be less than 200 diagonals overall!
//     // for (size_t a = 0; a < total_diagonals; ++a) {
//             int dIndex = A->dIndices[a];
//             std::shared_ptr<diagonal> d = A->dPointers[a];
//             unsigned int dLength = d->dLength;

//             valType *real_vals = d->realValues;
//             valType *imag_vals = d->imagValues;

//             if(dIndex < 0) { // negative diagonals
//                 unsigned int simd_start = 0;
//                 for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
//                     if ((simd_start % VEC_WIDTH == 0) && ((simd_start - dIndex) % VEC_WIDTH == 0)) {
//                         break;
//                     }
//                 }
//                 if (simd_start + VEC_WIDTH > dLength)
//                     simd_start = dLength;  // no aligned region found
            
//                 unsigned int simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

//                 // #pragma omp critical
//                 // {
//                     // printf("Negative diagonal!!\n");
//                     #if VEC_TYPE == 2
//                         run_spmv_avx512_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
//                     #elif VEC_TYPE == 1
//                         run_spmv_avx_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength); 
//                     #elif VEC_TYPE == 0
//                         run_spmv_sse_1(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
//                     #else // run without vectorization
//                         #pragma omp simd
//                         for (unsigned int i = 0; i < dLength; i++) {
//                             unsigned int x_idx = i;
//                             unsigned int y_idx = i - dIndex;
//                             y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
//                             y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
//                         }
//                     #endif
//                 // }
//             }

//             else if(dIndex > 0) { // positive diagonals
//                 // --- Alignment scan for both i and i + dIndex ---
//                 unsigned int simd_start = 0;
//                 for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
//                     if ((simd_start % VEC_WIDTH == 0) && ((simd_start + dIndex) % VEC_WIDTH == 0)) {
//                         break;
//                     }
//                 }
//                 if (simd_start + VEC_WIDTH > dLength)
//                     simd_start = dLength;  // no aligned region

//                 unsigned int simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

//                 // #pragma omp critical
//                 // {
//                     // printf("Positive diagonal!!\n");
//                     #if VEC_TYPE == 2
//                             run_spmv_avx512_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
//                     #elif VEC_TYPE == 1
//                             run_spmv_avx_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
//                     #elif VEC_TYPE == 0
//                         run_spmv_sse_2(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
//                     #else // run without vectorization
//                         #pragma omp simd
//                         for (unsigned int i = 0; i < dLength; i++) {
//                             unsigned int x_idx = dIndex + i;
//                             unsigned int y_idx = i;
//                             y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
//                             y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
//                         }
//                     #endif
//                 // }
//             }

//             else { // 0th diagonal
//                 // Find the first aligned index
//                 unsigned int simd_start = 0;
//                 for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
//                     if ((simd_start % VEC_WIDTH == 0) &&
//                         ((x_real_values == nullptr || ((uintptr_t)&x_real_values[simd_start]) % 64 == 0)) &&
//                         ((y_real_values == nullptr || ((uintptr_t)&y_real_values[simd_start]) % 64 == 0))) {
//                         break;
//                     }
//                 }
//                 if (simd_start + VEC_WIDTH > dLength)
//                     simd_start = dLength;
            
//                 unsigned int simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

//                 // #pragma omp critical
//                 // {
//                     // printf("Zero diagonal!!\n");
//                     #if VEC_TYPE == 2
//                             run_spmv_avx512_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
//                     #elif VEC_TYPE == 1
//                             run_spmv_avx_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
//                     #elif VEC_TYPE == 0
//                         run_spmv_sse_0(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
//                     #else // run without vectorization
//                         #pragma omp simd
//                         for (unsigned int i = 0; i < dLength; i++) {
//                             y_real_values[i] += real_vals[i] * x_real_values[i] - imag_vals[i] * x_imag_values[i];
//                             y_imag_values[i] += real_vals[i] * x_imag_values[i] + imag_vals[i] * x_real_values[i];
//                         }
//                     #endif
//                 // }
//             }
//         } // if used outer blokcing!
//     }

//     #ifdef DEEP_DEBUG
//         std::cout << " --- " << std::endl;
//         std::cout << " --- spMV result --- " << std::endl;
//         std::cout << " --- " << std::endl;
//         y->print();
//         std::cout << " --- " << std::endl;
//     #endif

//     #ifdef DEBUG
//         // measure end time
//         std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
//         // calculate duration
//         auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
//         // log duration
//         printf("\t\t spMV took %f milliseconds\n", duration.count()/1000.0);
//     #endif

//     #endif
// }

// ---------------------------------------------
// // second version
// void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
// 	#ifdef CUDA_ENABLED
//         return spmv_cuda(A, x);
//     #else
// 		#ifdef DEEP_DEBUG
// 			std::cout << " --- " << std::endl;
// 			std::cout << " --- spMV --- " << std::endl;
// 			std::cout << " --- " << std::endl;
// 			A->print();
// 			std::cout << " --- times --- " << std::endl;
// 			x->print();
// 			std::cout << " --- " << std::endl;
// 			printf("Analyzing SpM\n");
// 			A->print_meta();
// 			printf("Analyzing V\n");
// 			x->print_meta();
// 			printf("Analyzing Y\n");
// 			y->print_meta();
// 		#endif

// 		#ifdef DEBUG
// 			std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
// 		#endif

// 		const size_t total_diagonals = A->dIndices.size();
// 		const size_t N = y->numRows;
// 		const unsigned int num_batches = 5;

//         valType* x_real_values = x->realValues;
// 		valType* x_imag_values = x->imagValues;

// 		std::vector<std::shared_ptr<vector>> y_locals(num_batches);
// 		y_locals[0] = y;
// 		for (unsigned int i = 1; i < num_batches; ++i)
// 			y_locals[i] = y->copy();

//         #ifdef DEBUG
//             auto allocate_end = std::chrono::high_resolution_clock::now();
//             auto allocate_duration = std::chrono::duration_cast<std::chrono::microseconds>(allocate_end - start);
//             printf("\t\t spMV allocation took %f milliseconds\n", allocate_duration.count()/1000.0);
//         #endif

// 		#pragma omp parallel
// 		{
// 			#pragma omp single nowait
// 			{
// 				for (unsigned int batch_id = 0; batch_id < (total_diagonals + num_batches - 1) / num_batches; ++batch_id) {
// 					#pragma omp task firstprivate(batch_id)
// 					{
// 						unsigned int tid = batch_id % num_batches;
// 						valType* y_real_values = y_locals[tid]->realValues;
// 						valType* y_imag_values = y_locals[tid]->imagValues;

// 						unsigned int batch_start = batch_id * num_batches;
// 						unsigned int batch_end = std::min(batch_start + num_batches, (unsigned int)total_diagonals);

// 						for (unsigned int a = batch_start; a < batch_end; ++a) {
// 							int dIndex = A->dIndices[a];
// 							std::shared_ptr<diagonal> d = A->dPointers[a];
// 							unsigned int dLength = d->dLength;

// 							valType* real_vals = d->realValues;
// 							valType* imag_vals = d->imagValues;

// 							unsigned int simd_start = 0;
// 							unsigned int simd_end = 0;

// 							if (dIndex < 0) {
// 								for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
// 									if ((simd_start % VEC_WIDTH == 0) && ((simd_start - dIndex) % VEC_WIDTH == 0)) break;
// 								}
// 								if (simd_start + VEC_WIDTH > dLength) simd_start = dLength;
// 								simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

// 								#if VEC_TYPE == 2
// 									run_spmv_avx512_1(simd_start, simd_end, x_real_values, x_imag_values,
// 										real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 								#elif VEC_TYPE == 1
//                                     run_spmv_avx_1(simd_start, simd_end, x_real_values, x_imag_values,
//                                         real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 								#elif VEC_TYPE == 0
// 									run_spmv_sse_1(x_real_values, x_imag_values,
// 										real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 								#else
// 									#pragma omp simd
// 									for (unsigned int i = 0; i < dLength; ++i) {
// 										unsigned int x_idx = i;
// 										unsigned int y_idx = i - dIndex;
// 										y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
// 										y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
// 									}
// 								#endif
// 							} else if (dIndex > 0) {
// 								for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
// 									if ((simd_start % VEC_WIDTH == 0) && ((simd_start + dIndex) % VEC_WIDTH == 0)) break;
// 								}
// 								if (simd_start + VEC_WIDTH > dLength) simd_start = dLength;
// 								simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

// 								#if VEC_TYPE == 2
// 									run_spmv_avx512_2(simd_start, simd_end, x_real_values, x_imag_values,
// 										real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 								#elif VEC_TYPE == 1
//                                     run_spmv_avx_2(simd_start, simd_end, x_real_values, x_imag_values,
//                                         real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 								#elif VEC_TYPE == 0
// 									run_spmv_sse_2(x_real_values, x_imag_values,
// 										real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 								#else
// 									#pragma omp simd
// 									for (unsigned int i = 0; i < dLength; ++i) {
// 										unsigned int x_idx = dIndex + i;
// 										unsigned int y_idx = i;
// 										y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
// 										y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
// 									}
// 								#endif
// 							} else {
// 								for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
// 									if ((simd_start % VEC_WIDTH == 0) &&
// 										((uintptr_t)&x_real_values[simd_start] % 64 == 0) &&
// 										((uintptr_t)&y_real_values[simd_start] % 64 == 0)) break;
// 								}
// 								if (simd_start + VEC_WIDTH > dLength) simd_start = dLength;
// 								simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

// 								#if VEC_TYPE == 2
// 									run_spmv_avx512_0(simd_start, simd_end, x_real_values, x_imag_values,
// 										real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 								#elif VEC_TYPE == 1
//                                     run_spmv_avx_0(simd_start, simd_end, x_real_values, x_imag_values,
//                                         real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 								#elif VEC_TYPE == 0
// 									run_spmv_sse_0(x_real_values, x_imag_values,
// 										real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 								#else
// 									#pragma omp simd
// 									for (unsigned int i = 0; i < dLength; ++i) {
// 										y_real_values[i] += real_vals[i] * x_real_values[i] - imag_vals[i] * x_imag_values[i];
// 										y_imag_values[i] += real_vals[i] * x_imag_values[i] + imag_vals[i] * x_real_values[i];
// 									}
// 								#endif
// 							}
// 						}
// 					} // end task
// 				}
// 			} // end single
// 		} // end parallel

//         #ifdef DEBUG
//             auto compute_end = std::chrono::high_resolution_clock::now();
//             auto compute_duration = std::chrono::duration_cast<std::chrono::microseconds>(compute_end - start);
//             printf("\t\t spMV compute took %f milliseconds\n", compute_duration.count() / 1000.0);
//         #endif

// 		// Merge results back
// 		valType* y_real = y->realValues;
// 		valType* y_imag = y->imagValues;

// 		#pragma omp parallel for
// 		for (size_t i = 0; i < N; ++i) {
// 			for (unsigned int b = 1; b < num_batches; ++b) {
// 				y_real[i] += y_locals[b]->realValues[i];
// 				y_imag[i] += y_locals[b]->imagValues[i];
// 			}
// 		}

//         #ifdef DEBUG
//             auto merge_end = std::chrono::high_resolution_clock::now();
//             auto merge_duration = std::chrono::duration_cast<std::chrono::microseconds>(merge_end - compute_end);
//             printf("\t\t spMV merge took %f milliseconds\n", merge_duration.count() / 1000.0);
//         #endif

// 		#ifdef DEEP_DEBUG
// 			std::cout << " --- " << std::endl;
// 			std::cout << " --- spMV result --- " << std::endl;
// 			std::cout << " --- " << std::endl;
// 			y->print();
// 			std::cout << " --- " << std::endl;
// 		#endif

//     #endif
// 		#ifdef DEBUG
// 			std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
// 			auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
// 			printf("\t\t spMV took %f milliseconds\n", duration.count() / 1000.0);
// 		#endif
// }

// // ---------------------------------------------
// // // Aug 23rd 2025 written
// // Fast & correct: per-thread buffers + reduction
// void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
// 	#ifdef CUDA_ENABLED
// 		return spmv_cuda(A, x);
// 	#else
// 	#ifdef DEBUG
// 		std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
// 	#endif

// 	const size_t total_diagonals = A->dIndices.size();
// 	const size_t N = y->numRows;

// 	valType* x_real_values = x->realValues;
// 	valType* x_imag_values = x->imagValues;

// 	// One private y per thread
// 	int T = omp_get_max_threads();
// 	std::vector<std::shared_ptr<vector>> y_locals(T);
// 	for (int t = 0; t < T; ++t) {
// 		y_locals[t] = y->copy(); // same layout as y
// 		std::fill(y_locals[t]->realValues, y_locals[t]->realValues + N, (valType)0);
// 		std::fill(y_locals[t]->imagValues, y_locals[t]->imagValues + N, (valType)0);
// 	}

// 	#ifdef DEBUG
// 		auto alloc_end = std::chrono::high_resolution_clock::now();
// 		printf("\t\t spMV allocation took %f ms\n",
// 			std::chrono::duration_cast<std::chrono::microseconds>(alloc_end - start).count()/1000.0);
// 	#endif

// 	// Compute: each thread writes only to its own y_local
// 	#pragma omp parallel for schedule(static)
// 	for (size_t a = 0; a < total_diagonals; ++a) {
// 		int t = omp_get_thread_num();
// 		valType* y_real_values = y_locals[t]->realValues;
// 		valType* y_imag_values = y_locals[t]->imagValues;

// 		int dIndex = A->dIndices[a];
// 		std::shared_ptr<diagonal> d = A->dPointers[a];
// 		unsigned int dLength = d->dLength;

// 		valType* real_vals = d->realValues;
// 		valType* imag_vals = d->imagValues;

// 		unsigned int simd_start = 0, simd_end = 0;

// 		if (dIndex < 0) {
// 			for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
// 				if ((simd_start % VEC_WIDTH == 0) && ((simd_start - dIndex) % VEC_WIDTH == 0)) break;
// 			}
// 			if (simd_start + VEC_WIDTH > dLength) simd_start = dLength;
// 			simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

// 			#if VEC_TYPE == 2
// 				run_spmv_avx512_1(simd_start, simd_end, x_real_values, x_imag_values,
// 					real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 			#elif VEC_TYPE == 1
// 				run_spmv_avx_1(simd_start, simd_end, x_real_values, x_imag_values,
// 					real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 			#elif VEC_TYPE == 0
// 				run_spmv_sse_1(x_real_values, x_imag_values,
// 					real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 			#else
// 				#pragma omp simd
// 				for (unsigned int i = 0; i < dLength; ++i) {
// 					unsigned int x_idx = i;
// 					unsigned int y_idx = i - dIndex;
// 					y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
// 					y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
// 				}
// 			#endif
// 		}
// 		else if (dIndex > 0) {
// 			for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
// 				if ((simd_start % VEC_WIDTH == 0) && ((simd_start + dIndex) % VEC_WIDTH == 0)) break;
// 			}
// 			if (simd_start + VEC_WIDTH > dLength) simd_start = dLength;
// 			simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

// 			#if VEC_TYPE == 2
// 				run_spmv_avx512_2(simd_start, simd_end, x_real_values, x_imag_values,
// 					real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 			#elif VEC_TYPE == 1
// 				run_spmv_avx_2(simd_start, simd_end, x_real_values, x_imag_values,
// 					real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 			#elif VEC_TYPE == 0
// 				run_spmv_sse_2(x_real_values, x_imag_values,
// 					real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 			#else
// 				#pragma omp simd
// 				for (unsigned int i = 0; i < dLength; ++i) {
// 					unsigned int x_idx = dIndex + i;
// 					unsigned int y_idx = i;
// 					y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
// 					y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
// 				}
// 			#endif
// 		}
// 		else { // dIndex == 0
// 			for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
// 				if ((simd_start % VEC_WIDTH == 0) &&
// 					((uintptr_t)&x_real_values[simd_start] % 64 == 0) &&
// 					((uintptr_t)&y_real_values[simd_start] % 64 == 0)) break;
// 			}
// 			if (simd_start + VEC_WIDTH > dLength) simd_start = dLength;
// 			simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);

// 			#if VEC_TYPE == 2
// 				run_spmv_avx512_0(simd_start, simd_end, x_real_values, x_imag_values,
// 					real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 			#elif VEC_TYPE == 1
// 				run_spmv_avx_0(simd_start, simd_end, x_real_values, x_imag_values,
// 					real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 			#elif VEC_TYPE == 0
// 				run_spmv_sse_0(x_real_values, x_imag_values,
// 					real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
// 			#else
// 				#pragma omp simd
// 				for (unsigned int i = 0; i < dLength; ++i) {
// 					y_real_values[i] += real_vals[i] * x_real_values[i] - imag_vals[i] * x_imag_values[i];
// 					y_imag_values[i] += real_vals[i] * x_imag_values[i] + imag_vals[i] * x_real_values[i];
// 				}
// 			#endif
// 		}
// 	}

// 	#ifdef DEBUG
// 		auto compute_end = std::chrono::high_resolution_clock::now();
// 		printf("\t\t spMV compute took %f ms\n",
// 			std::chrono::duration_cast<std::chrono::microseconds>(compute_end - alloc_end).count()/1000.0);
// 	#endif

// 	// Reduction: y = sum_t y_locals[t]
// 	valType* y_real = y->realValues;
// 	valType* y_imag = y->imagValues;

// 	#pragma omp parallel for
// 	for (size_t i = 0; i < N; ++i) {
// 		valType sr = 0, si = 0;
// 		for (int t = 0; t < T; ++t) {
// 			sr += y_locals[t]->realValues[i];
// 			si += y_locals[t]->imagValues[i];
// 		}
// 		y_real[i] = sr;
// 		y_imag[i] = si;
// 	}

// 	#ifdef DEBUG
// 		std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
// 		printf("\t\t spMV total took %f ms\n",
// 			std::chrono::duration_cast<std::chrono::microseconds>(end - start).count()/1000.0);
// 	#endif
// 	#endif
// }

// ---------------------------------------------
// // 4th version: no critical section, does not use task parallelism...
// // Thread local buffers + reduction
void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
    #ifdef CUDA_ENABLED
        {
            std::shared_ptr<vector> tmp = spmv_cuda(A, x);
            if (tmp) {
                unsigned int M = y->num_rows();
                // copy tmp into y
                #pragma omp parallel for
                for (unsigned int i = 0; i < M; ++i) {
                    y->realValues[i] = tmp->realValues[i];
                    y->imagValues[i] = tmp->imagValues[i];
                }
            }
            return;
        }
    #else
    #ifdef DEEP_DEBUG
        std::cout << " --- spMV --- " << std::endl;
        A->print();
        x->print();
        A->print_meta();
        x->print_meta();
        y->print_meta();
    #endif
    
    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif
    
        valType *x_real_values = x->realValues;
        valType *x_imag_values = x->imagValues;
    
        size_t total_diagonals = A->dIndices.size();
        size_t N = y->numRows;
    
        // Use at most as many threads as there are diagonals
        int max_threads = omp_get_max_threads();
        int num_threads = std::min((int)total_diagonals, max_threads);
    
        // Prepare thread-local y buffers outside parallel region
        std::vector<std::shared_ptr<vector>> y_locals(num_threads);
        for (int t = 0; t < num_threads; ++t)
            y_locals[t] = y->copy();  // uses aligned alloc
    
    #pragma omp parallel num_threads(num_threads)
    {
        int tid = omp_get_thread_num();
        valType *y_real_values = y_locals[tid]->realValues;
        valType *y_imag_values = y_locals[tid]->imagValues;
    
    #pragma omp for schedule(static)
        for (size_t a = 0; a < total_diagonals; ++a) {
            int dIndex = A->dIndices[a];
            std::shared_ptr<diagonal> d = A->dPointers[a];
            unsigned int dLength = d->dLength;
    
            valType *real_vals = d->realValues;
            valType *imag_vals = d->imagValues;
    
            // Find aligned SIMD region
            unsigned int simd_start = 0;
            for (; simd_start + VEC_WIDTH <= dLength; ++simd_start) {
                bool aligned = false;
                if (dIndex < 0)
                    aligned = (simd_start % VEC_WIDTH == 0) && ((simd_start - dIndex) % VEC_WIDTH == 0);
                else if (dIndex > 0)
                    aligned = (simd_start % VEC_WIDTH == 0) && ((simd_start + dIndex) % VEC_WIDTH == 0);
                else
                    aligned = (simd_start % VEC_WIDTH == 0);
                if (aligned) break;
            }
            if (simd_start + VEC_WIDTH > dLength)
                simd_start = dLength;
            unsigned int simd_end = dLength - ((dLength - simd_start) % VEC_WIDTH);
    
            // Select and call appropriate kernel
            if (dIndex < 0) {
    #if VEC_TYPE == 2
                run_spmv_avx512_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                  y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 1
                run_spmv_avx_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                  y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 0
                run_spmv_sse_1(x_real_values, x_imag_values, real_vals, imag_vals,
                               y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 3
                run_spmv_mac_1(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                y_real_values, y_imag_values, dIndex, dLength);
    #else
                #if defined(SIMD_ENABLED)
                #pragma omp simd
                #endif
                for (unsigned int i = 0; i < dLength; i++) {
                    unsigned int x_idx = i;
                    unsigned int y_idx = i - dIndex;
                    y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                    y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                }
    #endif
            } else if (dIndex > 0) {
    #if VEC_TYPE == 2
                run_spmv_avx512_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                  y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 1
                run_spmv_avx_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                  y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 0
                run_spmv_sse_2(x_real_values, x_imag_values, real_vals, imag_vals,
                               y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 3
                run_spmv_mac_2(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                               y_real_values, y_imag_values, dIndex, dLength);
    #else
                #if defined(SIMD_ENABLED)
                #pragma omp simd
                #endif
                for (unsigned int i = 0; i < dLength; i++) {
                    unsigned int x_idx = dIndex + i;
                    unsigned int y_idx = i;
                    y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                    y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                }
    #endif
            } else {
    #if VEC_TYPE == 2
                run_spmv_avx512_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                  y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 1
                run_spmv_avx_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                                  y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 0
                run_spmv_sse_0(x_real_values, x_imag_values, real_vals, imag_vals,
                               y_real_values, y_imag_values, dIndex, dLength);
    #elif VEC_TYPE == 3
                run_spmv_mac_0(simd_start, simd_end, x_real_values, x_imag_values, real_vals, imag_vals,
                               y_real_values, y_imag_values, dIndex, dLength);
    #else
                #if defined(SIMD_ENABLED)
                #pragma omp simd
                #endif
                for (unsigned int i = 0; i < dLength; i++) {
                    y_real_values[i] += real_vals[i] * x_real_values[i] - imag_vals[i] * x_imag_values[i];
                    y_imag_values[i] += real_vals[i] * x_imag_values[i] + imag_vals[i] * x_real_values[i];
                }
    #endif
            }
        }
    } // end parallel region
    
        // Final merge
        valType *y_real = y->realValues;
        valType *y_imag = y->imagValues;
        #pragma omp parallel for
    for (size_t i = 0; i < N; ++i) {
        valType sum_r = 0.0;
        valType sum_i = 0.0;
        #if defined(SIMD_ENABLED)
        #pragma omp simd
        #endif
        for (int t = 0; t < num_threads; ++t) {
            sum_r += y_locals[t]->realValues[i];
            sum_i += y_locals[t]->imagValues[i];
        }
        y_real[i] = sum_r;
        y_imag[i] = sum_i;
    }
    
    
    #ifdef DEEP_DEBUG
        std::cout << " --- spMV result --- " << std::endl;
        y->print();
    #endif
    
    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t spMV took %f milliseconds\n", duration.count() / 1000.0);
    #endif
    #endif // not CUDA
}

// ------------- END OF SPMV ------------- //



std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger) {

    // DID NOT IMPLEMENT YET!
    // TODO: PLS IMPLEMENT!!

    #ifdef DEBUG
        // measure start timer
        printf("starting spMV --");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    unsigned int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    std::array<unsigned int, 2> new_gate_shape = {q_diff_exp, q_diff_exp};

    // if(A->matrix_shape[1] != x->numRows) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(A->matrix_shape[0], 0.0, 0.0);
    // valType *y_real_values = y->realValues;
    // valType *y_imag_values = y->imagValues;
    // valType *x_real_values = x->realValues;
    // valType *x_imag_values = x->imagValues;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel
    {
        #pragma omp single
        {
            for (it = diagMap.begin(); it != diagMap.end(); it++) {
                #pragma omp task
                {
                    std::shared_ptr<diagonal> diag = it->second;
                    // valType *real_vals = diag->realValues;
                    // valType *imag_vals = diag->imagValues;
                    switch(diag->dIndex) {
                        case -3: {
                            // int dIndex = -1 * q_diff_exp - 1;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case -2: {
                            // int dIndex = -1 * q_diff_exp;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case -1: {
                            // int dIndex = -1;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            // // something
                            // dIndex = -1 * q_diff_exp + 1;
                            // dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 0: {
                            // int dIndex = 0;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 1: {
                            // int dIndex = 1;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            // // do something
                            // dIndex = q_diff_exp - 1;
                            // dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 2: {
                            // int dIndex = q_diff_exp;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 3: {
                            // int dIndex = q_diff_exp + 1;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                    }
                }
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t (non-adjacent) spMV took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return y;
}

} // namespace diaq
