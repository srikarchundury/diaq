#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

// overloading operators
std::shared_ptr<diaQMatrix> operator*(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B) {
    return product(A, B);
}

/**
 * @brief diagonal matrix multiplication
 * 
 * @param A diagonal A index
 * @param B diagonal B index
 * @param A diagonal A
 * @param B diagonal B
 * 
 * @return NULL if zero, else diagonal C
 */
unsigned int getDiagonalLength(int dIndex, std::array<unsigned int, 2> shape) {
    // std::cout << "diag_Index = " << dIndex << " ";
    unsigned int lenRes;
    if(dIndex < 0) {
        lenRes = shape[0] + dIndex;
    } else if(dIndex > 0) {
        lenRes = shape[1] - dIndex;
    }  else {
        lenRes = (shape[0] > shape[1])?shape[1]:shape[0];
    }
    if (lenRes > shape[0]) {
        lenRes = shape[0];
    }
    else if(lenRes > shape[1]) {
        lenRes = shape[1];
    }
    // std::cout << "lenRes = " << lenRes << std::endl;
    return lenRes;
}

unsigned int getOptimalBlockSize(unsigned int loopCount, unsigned int lenA, unsigned int lenB) {
    unsigned int totalLen = loopCount + lenA + lenB;
    size_t totalBytes = static_cast<size_t>(totalLen) * sizeof(valType) * 2;

    // Consider the smallest length among lenA, lenB, and lenRes
    unsigned int minLen = std::min({lenA, lenB, loopCount});

    // Adjust block size based on both totalBytes and the smallest length
    if (totalBytes <= 16 * 1024 && minLen >= 128) return 128;
    else if (totalBytes <= 64 * 1024 && minLen >= 256) return 256;
    else if (totalBytes <= 256 * 1024 && minLen >= 512) return 512;
    else if (totalBytes <= 512 * 1024 && minLen >= 1024) return 1024;
    else if (totalBytes <= 1024 * 1024 && minLen >= 2048) return 2048;
    else if (totalBytes <= 2 * 1024 * 1024 && minLen >= 4096) return 4096;
    else return std::min(8192u, minLen);
}

std::shared_ptr<diagonal> multiplyDiagonals(std::array<unsigned int, 2> shapeA, std::array<unsigned int, 2> shapeB, int indexA, int indexB, std::shared_ptr<diagonal> diagA, std::shared_ptr<diagonal> diagB, int res_index, std::shared_ptr<diagonal> res, bool overwrite) {
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- multiplyDiagonals --- " << std::endl;
        std::cout << " --- " << std::endl;
        std::cout << " --- indexA = " << indexA << std::endl;
        std::cout << " --- indexB = " << indexB << std::endl;
        std::cout << " --- " << std::endl;
        diagA->print_meta();
        diagB->print_meta();
        std::cout << " --- " << std::endl;
    #endif
    unsigned int lenRes = res->dLength;
    // if (res_index <= 0 && static_cast<int>(shapeA[0]) <= abs(res_index)) {
    //     #ifdef DEEP_DEBUG
    //         std::cout << " --- returning NULL --- " << std::endl;
    //     #endif
    //     return NULL;
    // } else if (res_index > 0 && static_cast<int>(shapeB[1]) <= res_index) {
    //     #ifdef DEEP_DEBUG
    //         std::cout << " --- returning NULL --- " << std::endl;
    //     #endif
    //     return NULL;
    // }
    unsigned int lenDiagA = diagA->dLength;
    unsigned int lenDiagB = diagB->dLength;

    // std::cout << "diagonal length = " << lenRes << std::endl;
    int offsetA = abs(indexA);  // Absolute value of indexA
    int offsetB = abs(indexB);  // Absolute value of indexB
    int jump = 0;  // Initialize jump

    // Case 1: indexA is above the main diagonal (indexA > 0)
    if (indexA > 0) { 
        if (indexB > 0) { 
            // Align both diagonals by setting offsetB = offsetA
            offsetB = offsetA;
            offsetA = 0;
        } 
        else if (indexB < 0) {
            // Align diagonals based on their relative distance from the main diagonal
            if (offsetA > offsetB) {
                offsetB = abs(res_index);  // Align indexB to the result index
                offsetA = 0;
            } else {
                offsetA = abs(res_index);  // Align indexA to the result index
                offsetB = 0;
            }
        } 
        else { 
            // indexA is above the main diagonal, indexB is on it
            offsetB = offsetA;
            offsetA = 0;
        }
    } 

    // Case 2: indexA is below the main diagonal (indexA < 0)
    else if (indexA < 0) { 
        if (indexB > 0) { 
            // Case where indexA is below and indexB is above the main diagonal
            // Calculate the "jump" based on the shortest diagonal
            if (lenDiagB < lenDiagA) {
                jump = lenRes - lenDiagB;  // Jump past extra elements in diagonal A
            } else if (lenDiagA < lenDiagB) {
                jump = lenRes - lenDiagA;  // Jump past extra elements in diagonal B
            } else {
                // If both diagonals are the same length, jump based on res_index
                jump = (res_index < 0) ? abs(indexB) : abs(indexA);
            }
            // After calculating the jump, reset both offsets
            offsetA = 0;
            offsetB = 0;
        } 
        else if (indexB < 0) { 
            // Both diagonals are below the main diagonal, swap the offsets
            std::swap(offsetA, offsetB); 
            offsetB = 0;
        } 
        else { 
            // indexA is below the main diagonal, indexB is on it
            offsetA = 0;
            offsetB = 0;
        }
    } 

    // Case 3: indexA is exactly on the main diagonal (indexA == 0)
    else { 
        if (indexB < 0) { 
            // Align indexA with indexB, reset indexB
            offsetA = offsetB;
            offsetB = 0;
        } else {
            // Both diagonals are on the main diagonal
            offsetA = 0;
            offsetB = 0;
        }
    }

    // Apply the jump if necessary
    int k = (jump != 0) ? jump : 0;  // Set k to jump if jump > 0

	valType *real_vals_a = diagA->realValues;
    valType *imag_vals_a = diagA->imagValues;
    valType *real_vals_b = diagB->realValues;
    valType *imag_vals_b = diagB->imagValues;
	valType *real_vals_final = res->realValues;
    valType *imag_vals_final = res->imagValues;

    #ifdef DEEP_DEBUG
        std::cout << "k=" << k << std::endl;
        std::cout << "lenRes,jump,offsetA,offsetB " << lenRes << "," << jump << "," << offsetA << "," << offsetB << std::endl;
    #endif


    // we compute this just once instead of doing it inside blocks!
    unsigned int max_lenRes   = lenRes - k;
    unsigned int max_lenDiagA = lenDiagA - (k + offsetA - jump);
    unsigned int max_lenDiagB = lenDiagB - (k + offsetB - jump);
    unsigned int loop_count   = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});
    unsigned int loop_start   = k;
    unsigned int loop_end     = k + loop_count;
    unsigned int a_offset     = offsetA - jump;
    unsigned int b_offset     = offsetB - jump;

    // unsigned int blockSize = getOptimalBlockSize(loop_count, lenDiagA, lenDiagB);
    unsigned int blockSize = BLOCK_SIZE / 4;

    // BLOCKED over result diagonal using blockSize
    #pragma omp parallel for
	for (unsigned int block_start = loop_start; block_start < loop_end; block_start += blockSize) {
        unsigned int block_end = std::min(block_start + blockSize, loop_end);

        #if VEC_TYPE == 0
            // TODO, change to match avx512 later
            run_sse(block_start, block_end, offsetA, offsetB, jump, lenDiagA, lenDiagB,
                    real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
        #elif VEC_TYPE == 1
            run_avx(block_start, block_end, a_offset, b_offset,
                real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final, overwrite);
        #elif VEC_TYPE == 2
            run_avx512(block_start, block_end, a_offset, b_offset,
                       real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final, overwrite);
        #elif VEC_TYPE == 3
            run_mac(block_start, block_end, a_offset, b_offset,
                     real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final, overwrite);
        #elif VEC_TYPE == -1
            run_without_vectorization(block_start, block_end, a_offset, b_offset,
                       real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final, overwrite);
        #endif
    }

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- result --- " << std::endl;
        res->print_meta();
        std::cout << " --- " << std::endl;
    #endif

    return res;
}

// newer version of product function
std::shared_ptr<diaQMatrix> product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
	#ifdef CUDA_ENABLED
    	return product_cuda(A, B);
	#else

    #ifdef DEBUG
        std::cout << "starting product -- ";
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    std::array<unsigned int, 2> res_dims = {A->matrix_shape[0], B->matrix_shape[1]};
	std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(res_dims);

	phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal>> res_diags;
    std::unordered_map<int, std::vector<std::pair<int, int>>> res_index_sources;
	// Step 1: Precompute all res indices and allocate
    for (int res_idx = -(int)res_dims[0] + 1; res_idx <= (int)res_dims[1] - 1; ++res_idx) {
        std::vector<std::pair<int, int>> sources;
        for (int dA : A->dIndices) {
            int dB = res_idx - dA;
            if (B->diagonalMap.find(dB) != B->diagonalMap.end()) {
                sources.emplace_back(dA, dB);
                if (res_diags.find(res_idx) == res_diags.end()) {
                    unsigned int lenRes = getDiagonalLength(res_idx, res_dims);
                    res_diags[res_idx] = std::make_shared<diagonal>(res_idx, lenRes);
                }
            }
        }
        if (!sources.empty()) {
            res_index_sources[res_idx] = std::move(sources);
        }
    }
    std::vector<std::pair<int, std::vector<std::pair<int, int>>>> res_index_sources_vec;
    res_index_sources_vec.reserve(res_index_sources.size());
    for (std::unordered_map<int, std::vector<std::pair<int, int>>>::value_type & kv : res_index_sources) {
        res_index_sources_vec.emplace_back(kv.first, std::move(kv.second));
    }

    // #ifdef DEBUG
    //     auto precompute_end = std::chrono::high_resolution_clock::now();
    //     auto precompute_duration = std::chrono::duration_cast<std::chrono::microseconds>(precompute_end - start);
    //     printf("\t\t precompute took %f milliseconds\n", precompute_duration.count() / 1000.0);
    // #endif

    // Step 2: Main blocked compute loop (per result diagonal)
    // #pragma omp parallel for
    // for (size_t i = 0; i < res_index_sources_vec.size(); ++i) {
    //     int res_idx = res_index_sources_vec[i].first;
    //     const auto& sources = res_index_sources_vec[i].second;

    //     std::shared_ptr<diagonal> res_diag = res_diags[res_idx];
    //     if (!res_diag) continue;

    //     bool overwrite = sources.size() == 1;

    //     for (size_t s = 0; s < sources.size(); ++s) {
    //         const auto& [dA, dB] = sources[s];
    //         auto diagA = A->diagonalMap[dA];
    //         auto diagB = B->diagonalMap[dB];

    //         multiplyDiagonals(A->matrix_shape, B->matrix_shape,
    //                           dA, dB, diagA, diagB,
    //                           res_idx, res_diag, overwrite && (s == 0));
    //     }
    // }

    #pragma omp parallel
    {
        std::vector<std::pair<int, std::vector<std::pair<int, int>>>> my_work;
        #pragma omp for schedule(static)
        for (size_t i = 0; i < res_index_sources_vec.size(); ++i)
            my_work.push_back(res_index_sources_vec[i]);

        for (std::pair<int, std::vector<std::pair<int, int>>> & work_item : my_work) {
            int res_idx = work_item.first;
            std::vector<std::pair<int, int>> & sources = work_item.second;
            std::shared_ptr<diagonal> res_diag = res_diags[res_idx];
            if (!res_diag) continue;

            bool overwrite = sources.size() == 1;
            for (size_t s = 0; s < sources.size(); ++s) {
                const std::pair<int,int> & pairAB = sources[s];
                int dA = pairAB.first;
                int dB = pairAB.second;
                std::shared_ptr<diagonal> diagA = A->diagonalMap[dA];
                std::shared_ptr<diagonal> diagB = B->diagonalMap[dB];

                multiplyDiagonals(A->matrix_shape, B->matrix_shape, dA, dB, diagA, diagB, res_idx, res_diag, overwrite && (s == 0));
            }
        }
    }

    // #ifdef DEBUG
    //     auto compute_end = std::chrono::high_resolution_clock::now();
    //     auto compute_duration = std::chrono::duration_cast<std::chrono::microseconds>(compute_end - precompute_end);
    //     printf("\t\t compute took %f milliseconds\n", compute_duration.count() / 1000.0);
    // #endif

	// Step 3: Insert final non-empty result diagonals
    for (phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal>>::value_type & kv : res_diags) {
        int res_idx = kv.first;
        std::shared_ptr<diagonal> res_diag = kv.second;
        if (res_diag && !res_diag->isEmpty()) {
            result->diagonalMap.insert({res_idx, res_diag});
            result->dIndices.push_back(res_idx);
            result->dPointers.push_back(res_diag);
        }
    }

    // #ifdef DEBUG
    //     auto insert_end = std::chrono::high_resolution_clock::now();
    //     auto insert_duration = std::chrono::duration_cast<std::chrono::microseconds>(insert_end - compute_end);
    //     printf("\t\t insert took %f milliseconds\n", insert_duration.count() / 1000.0);
    // #endif

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        std::chrono::microseconds duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t product took %f milliseconds\n", duration.count() / 1000.0);
    #endif

	return result;

	#endif // !CUDA_ENABLED
}

// // current version
// std::shared_ptr<diaQMatrix> product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
// 	#ifdef DEBUG
//         std::cout << "starting product -- ";
//         std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
// 	#endif

// 	#ifdef CUDA_ENABLED
// 	    return product_cuda(A, B);
// 	#else

// 	std::array<unsigned int, 2> res_dims = {A->matrix_shape[0], B->matrix_shape[1]};
// 	std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(res_dims);

// 	// Step 1: Precompute which diag pairs contribute to which result diag
//     phmap::parallel_flat_hash_map<int, std::vector<std::pair<int, int>>> res_index_sources;
// 	phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal>> res_diags;

//     res_index_sources.reserve(A->dIndices.size() * B->dIndices.size() + 10);
// 	res_diags.reserve(A->dIndices.size() * B->dIndices.size() + 10);

//     // #pragma omp parallel for collapse(2)
//     for(size_t a = 0; a < A->dIndices.size(); a++) {
//         for(size_t b = 0; b < B->dIndices.size(); b++) {

//             int dA = A->dIndices[a];
//             int dB = B->dIndices[b];
// 			int res_idx = dA + dB;

// 			if ((res_idx < -(int)res_dims[0] + 1) || (res_idx > (int)res_dims[1] - 1)) continue;
// 			unsigned int lenRes = getDiagonalLength(res_idx, res_dims);
// 			if (lenRes <= 0) continue;

//             res_index_sources[res_idx].emplace_back(dA, dB);
// 			res_diags.try_emplace(res_idx, std::make_shared<diagonal>(res_idx, lenRes));
// 		}
// 	}

//     std::vector<int> res_indices;
//     res_indices.reserve(res_index_sources.size());
//     for (const auto& pair : res_index_sources) {
//         res_indices.push_back(pair.first);
//     }

// 	// Step 2.a: Main blocked compute loop (per result diagonal), single diagnal result!
//     #pragma omp parallel for
//     for(size_t i = 0; i < res_indices.size(); ++i) {
// 		int res_idx = res_indices[i];
//         auto it = res_index_sources.find(res_idx);
// 		auto& sources = it->second;

//         // if sources has just one pair, we can just do the multiplication and insert the result
//         if (sources.size() != 1) continue;

//         std::shared_ptr<diagonal> res_diag = res_diags[res_idx];

//         auto [dA, dB] = sources[0];
//         auto itA = A->diagonalMap.find(dA);
//         auto itB = B->diagonalMap.find(dB);
//         if (itA == A->diagonalMap.end() || itB == B->diagonalMap.end()) continue;

//         std::shared_ptr<diagonal> diagA = itA->second;
//         std::shared_ptr<diagonal> diagB = itB->second;

//         multiplyDiagonals(
//             A->matrix_shape,
//             B->matrix_shape,
//             dA,
//             dB,
//             diagA,
//             diagB,
//             res_idx,
//             res_diag
//         );

//         // insert the result
//         if(!res_diag->isEmpty()) {
//             result->diagonalMap.insert({res_idx, res_diag});
//         }
// 	}

//     // Step 2: Main blocked compute loop (per result diagonal)
//     #pragma omp parallel for
//     for(size_t i = 0; i < res_indices.size(); ++i) {
// 		int res_idx = res_indices[i];
//         auto it = res_index_sources.find(res_idx);
// 		auto& sources = it->second;

//         if (sources.size() == 1) continue; // already computed in step 2.a, skip!

// 		std::shared_ptr<diagonal> res_diag = res_diags[res_idx];

// 		for (const auto& [dA, dB] : sources) {
// 			auto itA = A->diagonalMap.find(dA);
// 			auto itB = B->diagonalMap.find(dB);
// 			if (itA == A->diagonalMap.end() || itB == B->diagonalMap.end()) continue;

// 			std::shared_ptr<diagonal> diagA = itA->second;
// 			std::shared_ptr<diagonal> diagB = itB->second;

//             multiplyDiagonals(
//                 A->matrix_shape,
//                 B->matrix_shape,
//                 dA,
//                 dB,
//                 diagA,
//                 diagB,
//                 res_idx,
//                 res_diag
//             );
// 		}

//         // insert the result
// 		if (res_diag && res_diag->dLength > 0 && !res_diag->isEmpty()) {
// 			result->diagonalMap.insert({res_idx, res_diag});
// 		}
// 	}

//     #ifdef DEBUG
//         std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
//         auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
//         printf("\t\t product took %f milliseconds\n", duration.count()/1000.0);
// 	#endif

// 	return result;

// 	#endif // !CUDA_ENABLED
// }
// --------------------------------------------------------------------------------------------------- //

} // namespace diaq