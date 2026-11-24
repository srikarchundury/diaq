#include <map>
// diaQspGEMM.cpp
#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

#include <unordered_map>
#include <vector>
#include <utility>
#include <algorithm>
#include <cmath>
#include <chrono>
#include <cstdio>
#include <iostream>

// ================= CPU spGEMM tiling knobs =================
#ifndef CPU_RES_BLOCK
	#define CPU_RES_BLOCK 4
#endif

#ifndef CPU_ELEM_BLOCK
	#define CPU_ELEM_BLOCK 2048
#endif
// ===========================================================

namespace diaq {

std::shared_ptr<diaQMatrix> operator*(std::shared_ptr<diaQMatrix> &A,
                                    std::shared_ptr<diaQMatrix> &B) {
    return product(A, B);
}

unsigned int getDiagonalLengthHelper(int dIndex,
                                     const std::array<unsigned int, 2> &shape) {
    unsigned int lenRes;
    if (dIndex < 0) {
        lenRes = shape[0] + dIndex;
    } else if (dIndex > 0) {
        lenRes = shape[1] - dIndex;
    } else {
        lenRes = (shape[0] > shape[1]) ? shape[1] : shape[0];
    }
    if (lenRes > shape[0]) {
        lenRes = shape[0];
    } else if (lenRes > shape[1]) {
        lenRes = shape[1];
    }
    return lenRes;
}

void multiplyDiagonalsSegment(
    const std::array<unsigned int, 2> &shapeA,
    const std::array<unsigned int, 2> &shapeB,
    int indexA,
    int indexB,
    int res_index,
    valType *real_vals_a,
    valType *imag_vals_a,
    unsigned int lenDiagA,
    valType *real_vals_b,
    valType *imag_vals_b,
    unsigned int lenDiagB,
    valType *real_vals_final,
    valType *imag_vals_final,
    unsigned int lenRes,
    bool overwrite,
    unsigned int tile_start,   // segment [tile_start, tile_end)
    unsigned int tile_end)     // end exclusive
{
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- multiplyDiagonalsSegment --- " << std::endl;
        std::cout << " --- " << std::endl;
        std::cout << " --- indexA = " << indexA << std::endl;
        std::cout << " --- indexB = " << indexB << std::endl;
        std::cout << " --- res_index = " << res_index << std::endl;
        std::cout << " --- lenA = " << lenDiagA << " lenB = " << lenDiagB
                << " lenRes = " << lenRes << std::endl;
        std::cout << " --- " << std::endl;
    #endif

    if (lenRes == 0) {
        return;
    }
    if (tile_end <= tile_start) {
        return;
    }
    if (tile_start >= lenRes) {
        return;
    }
    if (tile_end > lenRes) {
        tile_end = lenRes;
    }

    int offsetA = std::abs(indexA);
    int offsetB = std::abs(indexB);
    int jump = 0;

    // Case 1: indexA is above the main diagonal (indexA > 0)
    if (indexA > 0) {
        if (indexB > 0) {
            // Align both diagonals by setting offsetB = offsetA
            offsetB = offsetA;
            offsetA = 0;
        } else if (indexB < 0) {
            // Align diagonals based on their relative distance from the main diagonal
            if (offsetA > offsetB) {
                offsetB = std::abs(res_index);
                offsetA = 0;
            } else {
                offsetA = std::abs(res_index);
                offsetB = 0;
            }
        } else {
            // indexA is above the main diagonal, indexB is on it
            offsetB = offsetA;
            offsetA = 0;
        }
    }
    // Case 2: indexA is below the main diagonal (indexA < 0)
    else if (indexA < 0) {
        if (indexB > 0) {
            // Case where indexA is below and indexB is above the main diagonal
            if (lenDiagB < lenDiagA) {
                jump = (int)(lenRes - lenDiagB);
            } else if (lenDiagA < lenDiagB) {
                jump = (int)(lenRes - lenDiagA);
            } else {
                jump = (res_index < 0) ? std::abs(indexB) : std::abs(indexA);
            }
            offsetA = 0;
            offsetB = 0;
        } else if (indexB < 0) {
            // Both diagonals are below the main diagonal, swap the offsets
            int tmp = offsetA;
            offsetA = offsetB;
            offsetB = tmp;
            offsetB = 0;
        } else {
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
            offsetA = 0;
            offsetB = 0;
        }
    }

    int k = (jump != 0) ? jump : 0;

    #ifdef DEEP_DEBUG
        std::cout << "k=" << k << std::endl;
        std::cout << "lenRes,jump,offsetA,offsetB " << lenRes << "," << jump << ","
                << offsetA << "," << offsetB << std::endl;
    #endif

    // Compute loop bounds once
    unsigned int max_lenRes   = lenRes;
    if (k < (int)lenRes) {
        max_lenRes = lenRes - (unsigned int)k;
    } else {
        // No work if jump >= lenRes
        return;
    }

    int a_shift = k + offsetA - jump;
    int b_shift = k + offsetB - jump;

    if (a_shift >= (int)lenDiagA) {
        return;
    }
    if (b_shift >= (int)lenDiagB) {
        return;
    }

    unsigned int max_lenDiagA = lenDiagA - (unsigned int)a_shift;
    unsigned int max_lenDiagB = lenDiagB - (unsigned int)b_shift;

    unsigned int loop_count;
    if (max_lenRes < max_lenDiagA) {
        if (max_lenRes < max_lenDiagB) {
            loop_count = max_lenRes;
        } else {
            loop_count = max_lenDiagB;
        }
    } else {
        if (max_lenDiagA < max_lenDiagB) {
            loop_count = max_lenDiagA;
        } else {
            loop_count = max_lenDiagB;
        }
    }

    unsigned int loop_start_internal = (unsigned int)k;
    unsigned int loop_end_internal   = loop_start_internal + loop_count;

    // Clamp to tile segment
    unsigned int loop_start = loop_start_internal;
    if (loop_start < tile_start) {
        loop_start = tile_start;
    }
    unsigned int loop_end = loop_end_internal;
    if (loop_end > tile_end) {
        loop_end = tile_end;
    }
    if (loop_end <= loop_start) {
        return;
    }

    int a_offset = (int)(offsetA - jump);
    int b_offset = (int)(offsetB - jump);

    // We can still block inside the tile if desired
    unsigned int blockSize = BLOCK_SIZE / 4;
    if (blockSize == 0) {
        blockSize = 1;
    }

    unsigned int block_start;
    for (block_start = loop_start; block_start < loop_end; block_start += blockSize) {
        unsigned int block_end = block_start + blockSize;
        if (block_end > loop_end) {
            block_end = loop_end;
        }

        #if VEC_TYPE == 0
            // TODO: change SSE kernel signature to match AVX/AVX512, but keep old call for now
            run_sse(block_start,
                    block_end,
                    offsetA,
                    offsetB,
                    jump,
                    lenDiagA,
                    lenDiagB,
                    real_vals_a,
                    imag_vals_a,
                    real_vals_b,
                    imag_vals_b,
                    real_vals_final,
                    imag_vals_final);
        #elif VEC_TYPE == 1
            run_avx(block_start,
                    block_end,
                    a_offset,
                    b_offset,
                    real_vals_a,
                    imag_vals_a,
                    real_vals_b,
                    imag_vals_b,
                    real_vals_final,
                    imag_vals_final,
                    overwrite);
        #elif VEC_TYPE == 2
            run_avx512(block_start,
                        block_end,
                        a_offset,
                        b_offset,
                        real_vals_a,
                        imag_vals_a,
                        real_vals_b,
                        imag_vals_b,
                        real_vals_final,
                        imag_vals_final,
                        overwrite);
        #elif VEC_TYPE == 3
            run_mac(block_start,
                    block_end,
                    a_offset,
                    b_offset,
                    real_vals_a,
                    imag_vals_a,
                    real_vals_b,
                    imag_vals_b,
                    real_vals_final,
                    imag_vals_final,
                    overwrite);
        #elif VEC_TYPE == -1
            run_without_vectorization(block_start,
                                        block_end,
                                        a_offset,
                                        b_offset,
                                        real_vals_a,
                                        imag_vals_a,
                                        real_vals_b,
                                        imag_vals_b,
                                        real_vals_final,
                                        imag_vals_final,
                                        overwrite);
        #endif // VEC_TYPE
    }
}

std::shared_ptr<diaQMatrix> product(std::shared_ptr<diaQMatrix> A,
                                    std::shared_ptr<diaQMatrix> B) {
    #ifdef CUDA_ENABLED

        std::shared_ptr result = product_cuda(A, B);

    #else // !CUDA_ENABLED

        #ifdef DEBUG
            printf("starting <spGEMM> --- ");
            std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
        #endif

        // Basic dimension check
        if (A->matrix_shape[1] != B->matrix_shape[0]) {
            throw std::runtime_error("diaQMatrix product: dimension mismatch.");
        }

        std::array<unsigned int, 2> res_dims;
        res_dims[0] = A->matrix_shape[0];
        res_dims[1] = B->matrix_shape[1];

        //--------------------------------------------------------------------------
        // Build index -> slot maps for A and B
        //--------------------------------------------------------------------------

        std::unordered_map<int, unsigned int> AIndexToSlot;
        std::unordered_map<int, unsigned int> BIndexToSlot;

        for (int sA = 0; sA < A->dIndices.size(); ++sA) {
            int idxA = A->dIndices[sA];
            AIndexToSlot[idxA] = sA;
        }

        for (int sB = 0; sB < B->dIndices.size(); ++sB) {
            int idxB = B->dIndices[sB];
            BIndexToSlot[idxB] = sB;
        }

        //--------------------------------------------------------------------------
        // Step 1: Precompute which result diagonals exist and their sources
        //--------------------------------------------------------------------------

        std::vector<int> resDiagIndices;
        std::vector< std::vector< std::pair<int,int> > > resSources;

        // Every pair (dA, dB) contributes to dC = dA + dB: enumerate the pairs, O(numA * numB), instead of
        // scanning every possible result diagonal against A's diagonals, O((rows + cols) * numA) hash lookups.
        // Same result diagonals (ascending) and, within one, the pairs in the order of A's diagonals, as before.
        {
            const int minResIdx = -(int)res_dims[0] + 1;
            const int maxResIdx =  (int)res_dims[1] - 1;
            std::map<int, std::vector< std::pair<int,int> > > byResult;
            for (size_t sA = 0; sA < A->dIndices.size(); ++sA) {
                const int dA = A->dIndices[sA];
                for (size_t sB = 0; sB < B->dIndices.size(); ++sB) {
                    const int dB = B->dIndices[sB];
                    const int dC = dA + dB;
                    if (dC < minResIdx || dC > maxResIdx) continue;
                    byResult[dC].emplace_back(dA, dB);
                }
            }
            for (auto &entry : byResult) {
                resDiagIndices.push_back(entry.first);
                resSources.push_back(std::move(entry.second));
            }
        }

        unsigned int numRes = (unsigned int)resDiagIndices.size();

        //--------------------------------------------------------------------------
        // Step 2: Allocate result diaQMatrix with these diagonals
        //--------------------------------------------------------------------------

        std::shared_ptr<diaQMatrix> result =
            std::make_shared<diaQMatrix>(res_dims, resDiagIndices);
        // Diagonal order is now symmetric: 0, -1, +1, -2, +2, ...

        // result->realData and result->imagData are assumed zero-initialized
        // and result->diagOffsets already set. diagLengths not used.

        //--------------------------------------------------------------------------
        // Step 3: 2D tiled compute over (result diagonal slot, element index)
        //--------------------------------------------------------------------------

        // Tile sizes in diagonal-space and element-space.
        // These can be tuned later.
        const unsigned int RES_BLOCK  = (unsigned int)CPU_RES_BLOCK;    // diagonals per tile
        const unsigned int ELEM_BLOCK = (unsigned int)CPU_ELEM_BLOCK;   // elements per tile

        unsigned int numResTiles =
            (numRes + RES_BLOCK - 1) / RES_BLOCK;

        #pragma omp parallel
        {
            unsigned int tileId;

            #pragma omp for schedule(static)
            for (tileId = 0; tileId < numResTiles; ++tileId) {
                unsigned int res_base = tileId * RES_BLOCK;
                unsigned int res_end  = res_base + RES_BLOCK;
                if (res_end > numRes) {
                    res_end = numRes;
                }

                // Find max diagonal length in this tile
                unsigned int max_len_in_tile = 0;
                unsigned int rs;
                for (rs = res_base; rs < res_end; ++rs) {
                    unsigned int lenRes = getDiagonalLengthHelper(resDiagIndices[rs], res_dims);
                    if (lenRes > max_len_in_tile) {
                        max_len_in_tile = lenRes;
                    }
                }

                if (max_len_in_tile == 0) {
                    continue;
                }

                unsigned int j_base;
                for (j_base = 0; j_base < max_len_in_tile; j_base += ELEM_BLOCK) {
                    unsigned int j_end = j_base + ELEM_BLOCK;
                    if (j_end > max_len_in_tile) {
                        j_end = max_len_in_tile;
                    }

                    // Process the 2D tile:
                    //  res_slot in [res_base, res_end),
                    //  j in [j_base, j_end)
                    for (rs = res_base; rs < res_end; ++rs) {
                        unsigned int lenRes = getDiagonalLengthHelper(resDiagIndices[rs], res_dims);
                        if (j_base >= lenRes) {
                            continue;
                        }
                        unsigned int j_tile_end = j_end;
                        if (j_tile_end > lenRes) {
                            j_tile_end = lenRes;
                        }

                        int this_res_idx = resDiagIndices[rs];

                        valType *C_real =
                            result->getDiagonalRealPtr(rs);
                        valType *C_imag =
                            result->getDiagonalImagPtr(rs);

                        std::vector< std::pair<int,int> > &sources = resSources[rs];
                        bool overwrite = (sources.size() == 1);

                        unsigned int s;
                        for (s = 0; s < sources.size(); ++s) {
                            int dA = sources[s].first;
                            int dB = sources[s].second;

                            std::unordered_map<int, unsigned int>::iterator itA =
                                AIndexToSlot.find(dA);
                            std::unordered_map<int, unsigned int>::iterator itB =
                                BIndexToSlot.find(dB);

                            if (itA == AIndexToSlot.end()) {
                                continue;
                            }
                            if (itB == BIndexToSlot.end()) {
                                continue;
                            }

                            unsigned int slotA = itA->second;
                            unsigned int slotB = itB->second;

                            valType *A_real =
                                A->getDiagonalRealPtr(slotA);
                            valType *A_imag =
                                A->getDiagonalImagPtr(slotA);
                            unsigned int lenA = A->getDiagonalLengthInternal(A->dIndices[slotA]);

                            valType *B_real =
                                B->getDiagonalRealPtr(slotB);
                            valType *B_imag =
                                B->getDiagonalImagPtr(slotB);
                            unsigned int lenB = B->getDiagonalLengthInternal(B->dIndices[slotB]);

                            multiplyDiagonalsSegment(
                                A->matrix_shape,
                                B->matrix_shape,
                                dA,
                                dB,
                                this_res_idx,
                                A_real,
                                A_imag,
                                lenA,
                                B_real,
                                B_imag,
                                lenB,
                                C_real,
                                C_imag,
                                lenRes,
                                overwrite && (s == 0),
                                j_base,
                                j_tile_end);
                        }
                    }
                }
            }
        } // end of parallel region

        #ifdef DEBUG
            std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
            std::chrono::microseconds duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("spGEMM product took %.3f ms\n", duration.count() / 1000.0);
        #endif

    #endif // !CUDA_ENABLED

    #ifdef AVOID_ZERO_DIAGS
        #ifdef DEEP_DEBUG
            std::cout << "Pruning zero diagonals from result matrix." << std::endl;
            std::chrono::high_resolution_clock::time_point start_prune =
                std::chrono::high_resolution_clock::now();
        #endif

        result->pruneMatrix();

        #ifdef DEEP_DEBUG
            std::chrono::high_resolution_clock::time_point end_prune =
                std::chrono::high_resolution_clock::now();
            std::chrono::microseconds duration_prune =
                std::chrono::duration_cast<std::chrono::microseconds>(end_prune - start_prune);
            printf("\t\t pruneMatrix took %f milliseconds\n",
                duration_prune.count() / 1000.0);
        #endif

    #endif // AVOID_ZERO_DIAGS

    return result;

}

} // namespace diaq