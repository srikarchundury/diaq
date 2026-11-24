#include "matrixKernels_gpu.hpp"
#include "cuda_check.hpp"
#include "deviceMatrix_gpu.hpp"
#include <map>
#include <unordered_map>
#include <vector>
#include <utility>
#include <stdexcept>
#include <cstdio>

#ifndef SPGEMM_TPB
#define SPGEMM_TPB 256
#endif


namespace diaq {


// -----------------------------------------------------------------------------
// GPU kernel: block per result diagonal, threads over positions t; each thread
// sums all contributing (dA, dB) pairs for its positions in registers and writes
// C once (the positions of a thread are the same for every pair, so no tiles or
// block barriers are needed, and C is not read back once per pair).
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

    const int dC = resDiagIndices[resSlot];
    const unsigned int offC = resDiagOffsets[resSlot];
    const unsigned int lenC = resDiagLens[resSlot];
    const unsigned int pairStart = resPairOffset[resSlot];
    const unsigned int pairEnd   = resPairOffset[resSlot + 1];

    for (unsigned int t = threadIdx.x; t < lenC; t += blockDim.x) {
        const int i = (dC >= 0) ? static_cast<int>(t) : static_cast<int>(t) - dC;
        const int j = (dC >= 0) ? static_cast<int>(t) + dC : static_cast<int>(t);
        valType cr = 0.0, ci = 0.0;
        for (unsigned int p = pairStart; p < pairEnd; ++p) {   // same order as before: identical sums
            const int dA = pair_dA[p];
            const int dB = pair_dB[p];
            const int pA = (dA >= 0) ? i : (i + dA);
            const int pB = (dB >= 0) ? (i + dA) : j;
            const unsigned int slotA = pairSlotA[p];
            const unsigned int slotB = pairSlotB[p];
            if (pA < 0 || pB < 0) continue;
            if ((unsigned int)pA >= A_diagLens[slotA] || (unsigned int)pB >= B_diagLens[slotB]) continue;
            const unsigned int idxA = A_diagOffsets[slotA] + (unsigned int)pA;
            const unsigned int idxB = B_diagOffsets[slotB] + (unsigned int)pB;
            const valType ar = A_real[idxA], ai = A_imag[idxA];
            const valType br = B_real[idxB], bi = B_imag[idxB];
            cr += ar * br - ai * bi;
            ci += ar * bi + ai * br;
        }
        C_real[offC + t] = cr;
        C_imag[offC + t] = ci;
    }
}

// -----------------------------------------------------------------------------
// C = A B on the device: pair the diagonals on the host (from the host copies of the
// metadata), then one block per result diagonal.
// -----------------------------------------------------------------------------
std::shared_ptr<deviceDiaQMatrix> product_device(const deviceDiaQMatrix &A, const deviceDiaQMatrix &B) {
    if (A.matrix_shape[1] != B.matrix_shape[0]) {
        throw std::runtime_error("diaQMatrix product_cuda: dimension mismatch.");
    }
    const std::array<unsigned int, 2> res_dims = {A.matrix_shape[0], B.matrix_shape[1]};

    // Every pair (dA, dB) contributes to dC = dA + dB: enumerate the pairs (O(numA * numB)); within one dC the pairs
    // stay in the order of A's diagonals.
    const int minResIdx = -static_cast<int>(res_dims[0]) + 1;
    const int maxResIdx =  static_cast<int>(res_dims[1]) - 1;
    std::map<int, std::vector<std::pair<unsigned int, unsigned int> > > byResult;  // dC -> (slot in A, slot in B)
    for (std::size_t sA = 0; sA < A.dIndices.size(); ++sA) {
        for (std::size_t sB = 0; sB < B.dIndices.size(); ++sB) {
            const int dC = A.dIndices[sA] + B.dIndices[sB];
            if (dC < minResIdx || dC > maxResIdx) continue;
            byResult[dC].emplace_back(static_cast<unsigned int>(sA), static_cast<unsigned int>(sB));
        }
    }
    std::vector<int> resDiagIndices;
    for (const auto &entry : byResult) resDiagIndices.push_back(entry.first);
    auto C = std::make_shared<deviceDiaQMatrix>(res_dims, resDiagIndices);  // zeroed values
    const unsigned int numRes = static_cast<unsigned int>(resDiagIndices.size());
    if (numRes == 0) return C;

    std::vector<unsigned int> h_resPairOffset(numRes + 1);
    std::vector<int> h_pair_dA, h_pair_dB;
    std::vector<unsigned int> h_pairSlotA, h_pairSlotB;
    {
        unsigned int r = 0, p = 0;
        for (const auto &entry : byResult) {
            h_resPairOffset[r++] = p;
            for (const auto &slots : entry.second) {
                h_pair_dA.push_back(A.dIndices[slots.first]);
                h_pair_dB.push_back(B.dIndices[slots.second]);
                h_pairSlotA.push_back(slots.first);
                h_pairSlotB.push_back(slots.second);
                ++p;
            }
        }
        h_resPairOffset[numRes] = p;
    }
    const std::size_t totalPairs = h_pair_dA.size();

    // pair metadata on the device (freed on every exit path)
    struct Ints {
        void *p = nullptr;
        Ints(const void *src, std::size_t bytes) {
            DIAQ_CUDA_CHECK(cudaMalloc(&p, bytes));
            DIAQ_CUDA_CHECK(cudaMemcpy(p, src, bytes, cudaMemcpyHostToDevice));
        }
        ~Ints() { cudaFree(p); }
    };
    Ints d_resPairOffset(h_resPairOffset.data(), (numRes + 1) * sizeof(unsigned int));
    Ints d_pair_dA(h_pair_dA.data(), totalPairs * sizeof(int));
    Ints d_pair_dB(h_pair_dB.data(), totalPairs * sizeof(int));
    Ints d_pairSlotA(h_pairSlotA.data(), totalPairs * sizeof(unsigned int));
    Ints d_pairSlotB(h_pairSlotB.data(), totalPairs * sizeof(unsigned int));

    product_kernel<<<numRes, SPGEMM_TPB>>>(
        static_cast<int>(numRes), C->d_dIndices, C->d_diagOffsets, C->d_diagLens,
        static_cast<const unsigned int *>(d_resPairOffset.p), static_cast<const int *>(d_pair_dA.p),
        static_cast<const int *>(d_pair_dB.p), static_cast<const unsigned int *>(d_pairSlotA.p),
        static_cast<const unsigned int *>(d_pairSlotB.p), A.d_diagOffsets, A.d_diagLens, B.d_diagOffsets,
        B.d_diagLens, A.d_real, A.d_imag, B.d_real, B.d_imag, C->d_real, C->d_imag);
    DIAQ_CUDA_CHECK(cudaGetLastError());
    DIAQ_CUDA_CHECK(cudaDeviceSynchronize());  // before the pair metadata is freed
    return C;
}

// C = A B for host matrices (both uploaded for this call; chains of products, as in pow, stay on the device with
// product_device).
std::shared_ptr<diaQMatrix> product_cuda(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
    if (A->matrix_shape[1] != B->matrix_shape[0]) {
        throw std::runtime_error("diaQMatrix product_cuda: dimension mismatch.");
    }
    deviceDiaQMatrix dA(A), dB(B);
    return product_device(dA, dB)->to_host();
}

} // namespace diaq
