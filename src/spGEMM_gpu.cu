#include "matrixKernels_gpu.hpp"
#include <unordered_map>
#include <vector>
#include <utility>
#include <stdexcept>
#include <cstdio>

#ifndef SPGEMM_TPB
#define SPGEMM_TPB 256
#endif

#ifndef SPGEMM_TILE_T
#define SPGEMM_TILE_T 256
#endif

namespace diaq {

// -----------------------------------------------------------------------------
// Helper: diagonal length (same logic as in diaQspGEMM.cpp)
// -----------------------------------------------------------------------------
static inline unsigned int getDiagonalLengthHelper(
    int dIndex,
    const std::array<unsigned int, 2> &shape)
{
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

// -----------------------------------------------------------------------------
// GPU kernel: block per result diagonal, threads over positions t
// and sequential over contributing (dA, dB) pairs.
// -----------------------------------------------------------------------------
__global__ void product_kernel(
    int numRes,
    const int * __restrict__ resDiagIndices,
    const unsigned int * __restrict__ resDiagOffsets,
    const unsigned int * __restrict__ resDiagLens,
    const unsigned int * __restrict__ resPairOffset,
    const int * __restrict__ pair_dA,
    const int * __restrict__ pair_dB,
    const unsigned int * __restrict__ pairSlotA,
    const unsigned int * __restrict__ pairSlotB,
    const unsigned int * __restrict__ A_diagOffsets,
    const unsigned int * __restrict__ A_diagLens,
    const unsigned int * __restrict__ B_diagOffsets,
    const unsigned int * __restrict__ B_diagLens,
    const valType * __restrict__ A_real,
    const valType * __restrict__ A_imag,
    const valType * __restrict__ B_real,
    const valType * __restrict__ B_imag,
    valType * __restrict__ C_real,
    valType * __restrict__ C_imag
) {
    int resSlot = blockIdx.x;
    if (resSlot >= numRes) return;

    int dC = resDiagIndices[resSlot];
    unsigned int offC = resDiagOffsets[resSlot];
    unsigned int lenC = resDiagLens[resSlot];

    unsigned int pairStart = resPairOffset[resSlot];
    unsigned int pairEnd   = resPairOffset[resSlot + 1];

    // Loop over contributing pairs
    for (unsigned int p = pairStart; p < pairEnd; ++p) {
        int dA = pair_dA[p];
        int dB = pair_dB[p];

        unsigned int slotA = pairSlotA[p];
        unsigned int slotB = pairSlotB[p];

        unsigned int offA = A_diagOffsets[slotA];
        unsigned int lenA = A_diagLens[slotA];

        unsigned int offB = B_diagOffsets[slotB];
        unsigned int lenB = B_diagLens[slotB];

        bool first = (p == pairStart);

        // Tiled traversal over t along result diagonal
        for (unsigned int t0 = 0; t0 < lenC; t0 += SPGEMM_TILE_T) {
            unsigned int tEnd = t0 + SPGEMM_TILE_T;
            if (tEnd > lenC) tEnd = lenC;

            // Parallel within this tile
            for (unsigned int t = t0 + threadIdx.x; t < tEnd; t += blockDim.x) {

                int i, j;
                if (dC >= 0) {
                    i = static_cast<int>(t);
                    j = static_cast<int>(t) + dC;
                } else {
                    i = static_cast<int>(t) - dC;
                    j = static_cast<int>(t);
                }

                int pA = (dA >= 0) ? i : (i + dA);
                int pB = (dB >= 0) ? (i + dA) : j;

                if (pA < 0 || pB < 0) continue;
                if ((unsigned int)pA >= lenA || (unsigned int)pB >= lenB) continue;

                unsigned int idxA = offA + (unsigned int)pA;
                unsigned int idxB = offB + (unsigned int)pB;
                unsigned int idxC = offC + t;

                valType ar = A_real[idxA];
                valType ai = A_imag[idxA];
                valType br = B_real[idxB];
                valType bi = B_imag[idxB];

                valType cr = ar * br - ai * bi;
                valType ci = ar * bi + ai * br;

                if (first) {
                    C_real[idxC] = cr;
                    C_imag[idxC] = ci;
                } else {
                    C_real[idxC] += cr;
                    C_imag[idxC] += ci;
                }
            }

            // Ensure the block finishes this tile for this pair before next tile/pair
            __syncthreads();
        }
    }
}

// -----------------------------------------------------------------------------
// Host-side product_cuda: precompute diagonal pairs, flatten metadata, launch kernel.
// -----------------------------------------------------------------------------
std::shared_ptr<diaQMatrix> product_cuda(std::shared_ptr<diaQMatrix> A,
                                         std::shared_ptr<diaQMatrix> B) {
    #ifdef DEBUG
        printf("starting <spGEMM:product_cuda> --- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    // Basic dimension check (same as CPU version)
    if (A->matrix_shape[1] != B->matrix_shape[0]) {
        throw std::runtime_error("diaQMatrix product_cuda: dimension mismatch.");
    }

    std::array<unsigned int, 2> res_dims;
    res_dims[0] = A->matrix_shape[0];
    res_dims[1] = B->matrix_shape[1];

    // -------------------------------------------------------------------------
    // Build index -> slot maps for A and B (host-side)
    // -------------------------------------------------------------------------
    std::unordered_map<int, unsigned int> AIndexToSlot;
    std::unordered_map<int, unsigned int> BIndexToSlot;

    for (int sA = 0; sA < static_cast<int>(A->dIndices.size()); ++sA) {
        int idxA = A->dIndices[static_cast<std::size_t>(sA)];
        AIndexToSlot[idxA] = static_cast<unsigned int>(sA);
    }

    for (int sB = 0; sB < static_cast<int>(B->dIndices.size()); ++sB) {
        int idxB = B->dIndices[static_cast<std::size_t>(sB)];
        BIndexToSlot[idxB] = static_cast<unsigned int>(sB);
    }

    // -------------------------------------------------------------------------
    // Step 1: Precompute which result diagonals exist and their (dA, dB) sources
    // -------------------------------------------------------------------------
    std::vector<int> resDiagIndices;                         // result diagonal indices dC
    std::vector< std::vector< std::pair<int,int> > > resSources; // per result diag: list of (dA, dB)

    int minResIdx = -static_cast<int>(res_dims[0]) + 1;
    int maxResIdx =  static_cast<int>(res_dims[1]) - 1;

    for (int res_idx = minResIdx; res_idx <= maxResIdx; ++res_idx) {
        std::vector< std::pair<int,int> > sources_here;

        for (int sA = 0; sA < static_cast<int>(A->dIndices.size()); ++sA) {
            int dA = A->dIndices[static_cast<std::size_t>(sA)];
            int dB = res_idx - dA;

            auto itB = BIndexToSlot.find(dB);
            if (itB != BIndexToSlot.end()) {
                // Store diagonal indices; slots can be recovered from maps
                sources_here.emplace_back(dA, dB);
            }
        }

        if (!sources_here.empty()) {
            resDiagIndices.push_back(res_idx);
            resSources.push_back(std::move(sources_here));
        }
    }

    unsigned int numRes = static_cast<unsigned int>(resDiagIndices.size());
    if (numRes == 0) {
        // No result diagonals: return an empty matrix
        return std::make_shared<diaQMatrix>(res_dims);
    }

    // -------------------------------------------------------------------------
    // Step 2: Allocate result diaQMatrix on host with these diagonals
    // -------------------------------------------------------------------------
    std::shared_ptr<diaQMatrix> result =
        std::make_shared<diaQMatrix>(res_dims, resDiagIndices);

    // -------------------------------------------------------------------------
    // Step 3: Build host-side metadata arrays
    // -------------------------------------------------------------------------
    // Result-diagonal metadata
    std::vector<int>          h_resDiagIndices(numRes);
    std::vector<unsigned int> h_resDiagOffsets(numRes);
    std::vector<unsigned int> h_resDiagLens(numRes);

    for (unsigned int r = 0; r < numRes; ++r) {
        h_resDiagIndices[r] = resDiagIndices[r];
        h_resDiagOffsets[r] = result->diagOffsets[r];
        h_resDiagLens[r]    = getDiagonalLengthHelper(resDiagIndices[r], res_dims);
    }

    unsigned int numA = static_cast<unsigned int>(A->dIndices.size());
    unsigned int numB = static_cast<unsigned int>(B->dIndices.size());

    std::vector<unsigned int> h_A_diagOffsets(numA);
    std::vector<unsigned int> h_A_diagLens(numA);
    std::vector<unsigned int> h_B_diagOffsets(numB);
    std::vector<unsigned int> h_B_diagLens(numB);

    for (unsigned int s = 0; s < numA; ++s) {
        h_A_diagOffsets[s] = A->diagOffsets[s];
        h_A_diagLens[s]    = A->getDiagonalLengthInternal(A->dIndices[s]);
    }
    for (unsigned int s = 0; s < numB; ++s) {
        h_B_diagOffsets[s] = B->diagOffsets[s];
        h_B_diagLens[s]    = B->getDiagonalLengthInternal(B->dIndices[s]);
    }

    // Flatten pair structure
    std::vector<unsigned int> h_resPairOffset(numRes + 1);
    unsigned int totalPairs = 0;
    for (unsigned int r = 0; r < numRes; ++r) {
        h_resPairOffset[r] = totalPairs;
        totalPairs += static_cast<unsigned int>(resSources[r].size());
    }
    h_resPairOffset[numRes] = totalPairs;

    std::vector<int>          h_pair_dA(totalPairs);
    std::vector<int>          h_pair_dB(totalPairs);
    std::vector<unsigned int> h_pairSlotA(totalPairs);
    std::vector<unsigned int> h_pairSlotB(totalPairs);

    {
        unsigned int p = 0;
        for (unsigned int r = 0; r < numRes; ++r) {
            for (const auto &pr : resSources[r]) {
                int dA = pr.first;
                int dB = pr.second;

                auto itA = AIndexToSlot.find(dA);
                auto itB = BIndexToSlot.find(dB);
                if (itA == AIndexToSlot.end() || itB == BIndexToSlot.end()) {
                    continue; // should not happen
                }

                h_pair_dA[p]    = dA;
                h_pair_dB[p]    = dB;
                h_pairSlotA[p]  = itA->second;
                h_pairSlotB[p]  = itB->second;
                ++p;
            }
        }
        // In case any pair was skipped, adjust totalPairs (defensive)
        totalPairs = p;
        h_resPairOffset[numRes] = totalPairs;
    }

    // -------------------------------------------------------------------------
    // Step 4: Allocate device memory and copy data
    // -------------------------------------------------------------------------
    // Data arrays
    valType *d_A_real = nullptr, *d_A_imag = nullptr;
    valType *d_B_real = nullptr, *d_B_imag = nullptr;
    valType *d_C_real = nullptr, *d_C_imag = nullptr;

    cudaMalloc(&d_A_real, A->totalLength * sizeof(valType));
    cudaMalloc(&d_A_imag, A->totalLength * sizeof(valType));
    cudaMalloc(&d_B_real, B->totalLength * sizeof(valType));
    cudaMalloc(&d_B_imag, B->totalLength * sizeof(valType));
    cudaMalloc(&d_C_real, result->totalLength * sizeof(valType));
    cudaMalloc(&d_C_imag, result->totalLength * sizeof(valType));

    cudaMemcpy(d_A_real, A->realData, A->totalLength * sizeof(valType), cudaMemcpyHostToDevice);
    cudaMemcpy(d_A_imag, A->imagData, A->totalLength * sizeof(valType), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B_real, B->realData, B->totalLength * sizeof(valType), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B_imag, B->imagData, B->totalLength * sizeof(valType), cudaMemcpyHostToDevice);

    // Initialize C on device to zero (not strictly necessary due to "first" overwrite,
    // but keeps things robust if logic changes)
    cudaMemset(d_C_real, 0, result->totalLength * sizeof(valType));
    cudaMemset(d_C_imag, 0, result->totalLength * sizeof(valType));

    // Metadata arrays
    int *d_resDiagIndices = nullptr;
    unsigned int *d_resDiagOffsets = nullptr;
    unsigned int *d_resDiagLens    = nullptr;
    unsigned int *d_resPairOffset  = nullptr;

    int *d_pair_dA = nullptr;
    int *d_pair_dB = nullptr;
    unsigned int *d_pairSlotA = nullptr;
    unsigned int *d_pairSlotB = nullptr;

    unsigned int *d_A_diagOffsets = nullptr;
    unsigned int *d_A_diagLens    = nullptr;
    unsigned int *d_B_diagOffsets = nullptr;
    unsigned int *d_B_diagLens    = nullptr;

    cudaMalloc(&d_resDiagIndices, numRes * sizeof(int));
    cudaMalloc(&d_resDiagOffsets, numRes * sizeof(unsigned int));
    cudaMalloc(&d_resDiagLens,    numRes * sizeof(unsigned int));
    cudaMalloc(&d_resPairOffset, (numRes + 1) * sizeof(unsigned int));

    cudaMemcpy(d_resDiagIndices, h_resDiagIndices.data(),
               numRes * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_resDiagOffsets, h_resDiagOffsets.data(),
               numRes * sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_resDiagLens,    h_resDiagLens.data(),
               numRes * sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_resPairOffset,  h_resPairOffset.data(),
               (numRes + 1) * sizeof(unsigned int), cudaMemcpyHostToDevice);

    cudaMalloc(&d_pair_dA,     totalPairs * sizeof(int));
    cudaMalloc(&d_pair_dB,     totalPairs * sizeof(int));
    cudaMalloc(&d_pairSlotA,   totalPairs * sizeof(unsigned int));
    cudaMalloc(&d_pairSlotB,   totalPairs * sizeof(unsigned int));

    cudaMemcpy(d_pair_dA,   h_pair_dA.data(),
               totalPairs * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_pair_dB,   h_pair_dB.data(),
               totalPairs * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_pairSlotA, h_pairSlotA.data(),
               totalPairs * sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_pairSlotB, h_pairSlotB.data(),
               totalPairs * sizeof(unsigned int), cudaMemcpyHostToDevice);

    cudaMalloc(&d_A_diagOffsets, numA * sizeof(unsigned int));
    cudaMalloc(&d_A_diagLens,    numA * sizeof(unsigned int));
    cudaMalloc(&d_B_diagOffsets, numB * sizeof(unsigned int));
    cudaMalloc(&d_B_diagLens,    numB * sizeof(unsigned int));

    cudaMemcpy(d_A_diagOffsets, h_A_diagOffsets.data(),
               numA * sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_A_diagLens,    h_A_diagLens.data(),
               numA * sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B_diagOffsets, h_B_diagOffsets.data(),
               numB * sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B_diagLens,    h_B_diagLens.data(),
               numB * sizeof(unsigned int), cudaMemcpyHostToDevice);

    // -------------------------------------------------------------------------
    // Step 5: Launch kernel
    // -------------------------------------------------------------------------
    int threadsPerBlock = SPGEMM_TPB;
    int blocksPerGrid   = static_cast<int>(numRes);

    product_kernel<<<blocksPerGrid, threadsPerBlock>>>(
        static_cast<int>(numRes),
        d_resDiagIndices,
        d_resDiagOffsets,
        d_resDiagLens,
        d_resPairOffset,
        d_pair_dA,
        d_pair_dB,
        d_pairSlotA,
        d_pairSlotB,
        d_A_diagOffsets,
        d_A_diagLens,
        d_B_diagOffsets,
        d_B_diagLens,
        d_A_real,
        d_A_imag,
        d_B_real,
        d_B_imag,
        d_C_real,
        d_C_imag
    );

    cudaDeviceSynchronize();

    // -------------------------------------------------------------------------
    // Step 6: Copy result back to host and clean up
    // -------------------------------------------------------------------------
    cudaMemcpy(result->realData, d_C_real,
               result->totalLength * sizeof(valType), cudaMemcpyDeviceToHost);
    cudaMemcpy(result->imagData, d_C_imag,
               result->totalLength * sizeof(valType), cudaMemcpyDeviceToHost);

    cudaFree(d_A_real);
    cudaFree(d_A_imag);
    cudaFree(d_B_real);
    cudaFree(d_B_imag);
    cudaFree(d_C_real);
    cudaFree(d_C_imag);

    cudaFree(d_resDiagIndices);
    cudaFree(d_resDiagOffsets);
    cudaFree(d_resDiagLens);
    cudaFree(d_resPairOffset);

    cudaFree(d_pair_dA);
    cudaFree(d_pair_dB);
    cudaFree(d_pairSlotA);
    cudaFree(d_pairSlotB);

    cudaFree(d_A_diagOffsets);
    cudaFree(d_A_diagLens);
    cudaFree(d_B_diagOffsets);
    cudaFree(d_B_diagLens);

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
        printf("spGEMM:product_cuda took %.3f ms\n", duration / 1.0);
    #endif

    return result;
}

} // namespace diaq
