#include "matrixKernels.hpp"

namespace diaq {
    std::shared_ptr<diaQMatrix> adjoint(std::shared_ptr<diaQMatrix> A, bool swap_tensor_shape) {
        #ifdef DEBUG
            std::printf("starting adjoint -- ");
            auto start = std::chrono::high_resolution_clock::now();
        #endif

        // Adjoint: (m x n) -> (n x m)
        std::array<unsigned int, 2> new_mat_shape = { A->matrix_shape[1], A->matrix_shape[0] };

        // Diagonals transpose: d -> -d
        std::vector<int> new_dIndices;
        new_dIndices.reserve(A->dIndices.size());
        for (int d : A->dIndices) {
            new_dIndices.push_back(-d);
        }

        // Tensor shape policy:
        // - If swap_tensor_shape == false: keep as-is (safe default)
        // - If true: swap the last two dims when shape.size()==2 (common for matrix-as-tensor use)
        std::vector<unsigned int> new_tensor_shape = A->shape;
        if (swap_tensor_shape && new_tensor_shape.size() == 2) {
            std::swap(new_tensor_shape[0], new_tensor_shape[1]);
        }

        std::shared_ptr<diaQMatrix> B =
            std::make_shared<diaQMatrix>(new_mat_shape, new_dIndices, new_tensor_shape);

        #pragma omp parallel for
        for (size_t k = 0; k < A->dIndices.size(); ++k) {
            int d = A->dIndices[k];
            unsigned int lenA = A->getDiagonalLengthInternal(d);
            unsigned int offA = A->diagOffsets[k];

            // Slot in B for diagonal -d (should exist)
            int bslot = B->findDiagonalSlot(-d);
            if (bslot < 0) continue;
            unsigned int offB = B->diagOffsets[(size_t)bslot];

            for (unsigned int pos = 0; pos < lenA; ++pos) {
                // A position (r,c)
                std::array<unsigned int, 2> rc = A->getMatrixPosition(d, pos);
                unsigned int r = rc[0];
                unsigned int c = rc[1];

                // In B, position becomes (c,r). Find its diagonal position (d',pos')
                std::array<int, 2> dposB = B->getDiagonalPosition(c, r);
                // dposB[0] should be -d
                unsigned int posB = (unsigned int)dposB[1];

                valType ar = A->realData[offA + pos];
                valType ai = A->imagData[offA + pos];

                // Conjugate: (ar + i ai)^* = ar - i ai
                B->realData[offB + posB] = ar;
                B->imagData[offB + posB] = -ai;
            }
        }

        #ifdef DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            std::cout << "\t\t adjoint took "
                    << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
                    << " ms" << std::endl;
        #endif

        return B;
    }
    
    void adjoint_inplace(std::shared_ptr<diaQMatrix> A, bool swap_tensor_shape) {
        #ifdef DEBUG
            std::printf("starting adjoint_inplace -- ");
            auto start = std::chrono::high_resolution_clock::now();
        #endif

        // Quick exit: empty
        if (A->dIndices.empty() || A->totalLength == 0) {
            // Still need to swap matrix_shape for adjoint
            std::swap(A->matrix_shape[0], A->matrix_shape[1]);
            if (swap_tensor_shape && A->shape.size() == 2) {
                std::swap(A->shape[0], A->shape[1]);
            }
            #ifdef DEBUG
                auto end = std::chrono::high_resolution_clock::now();
                std::cout << "\t\t adjoint_inplace took "
                        << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
                        << " ms" << std::endl;
            #endif
            return;
        }

        // If rectangular, diagonal lengths for d and -d differ -> true in-place becomes painful/unsafe.
        // We simply fall back.
        bool is_square = (A->matrix_shape[0] == A->matrix_shape[1]);
        if (!is_square) {
            std::shared_ptr<diaQMatrix> tmp = adjoint(A, swap_tensor_shape);
            *A = std::move(*tmp);
            #ifdef DEBUG
                auto end = std::chrono::high_resolution_clock::now();
                std::cout << "\t\t adjoint_inplace (fallback) took "
                        << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
                        << " ms" << std::endl;
            #endif
            return;
        }

        // Check closure under negation: for every d, -d must exist
        bool closed = true;
        for (int d : A->dIndices) {
            if (A->findDiagonalSlot(-d) < 0) {
                closed = false;
                break;
            }
        }

        if (!closed) {
            // fallback to out-of-place then move-assign
            std::shared_ptr<diaQMatrix> tmp = adjoint(A, swap_tensor_shape);
            *A = std::move(*tmp);
            #ifdef DEBUG
                auto end = std::chrono::high_resolution_clock::now();
                std::cout << "\t\t adjoint_inplace (fallback) took "
                        << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
                        << " ms" << std::endl;
            #endif
            return;
        }

        // True in-place:
        // - For d=0: conjugate imag entries
        // - For d>0: swap diagonal buffers between d and -d, conjugating both sides
        //
        // Note: For square matrices, len(d) == len(-d), so safe to swap elementwise.

        // Track which diagonals have been processed to avoid double-swap.
        std::vector<char> done(A->dIndices.size(), 0);

        for (size_t k = 0; k < A->dIndices.size(); ++k) {
            if (done[k]) continue;

            int d = A->dIndices[k];
            int k2 = A->findDiagonalSlot(-d);
            if (k2 < 0) continue; // should not happen due to closed check

            done[k] = 1;
            done[(size_t)k2] = 1;

            unsigned int len = A->getDiagonalLengthInternal(d);

            unsigned int off1 = A->diagOffsets[k];
            unsigned int off2 = A->diagOffsets[(size_t)k2];

            if (d == 0) {
                // conjugate in place: imag *= -1 for logical length
                #pragma omp parallel for
                for (unsigned int j = 0; j < len; ++j) {
                    A->imagData[off1 + j] = -1 * A->imagData[off1 + j];
                }
                continue;
            }

            // Swap values between diagonal d and -d, with conjugation.
            // After adjoint, diag d's data should become conjugate of old diag -d, and vice versa.
            #pragma omp parallel for
            for (unsigned int j = 0; j < len; ++j) {
                valType r1 = A->realData[off1 + j];
                valType i1 = A->imagData[off1 + j];
                valType r2 = A->realData[off2 + j];
                valType i2 = A->imagData[off2 + j];

                // new diag d  = conj(old diag -d) => (r2, -i2)
                A->realData[off1 + j] = r2;
                A->imagData[off1 + j] = -i2;

                // new diag -d = conj(old diag d)  => (r1, -i1)
                A->realData[off2 + j] = r1;
                A->imagData[off2 + j] = -i1;
            }
        }

        // Finally, transpose metadata:
        // - matrix shape swaps
        // - diagonal indices flip sign
        std::swap(A->matrix_shape[0], A->matrix_shape[1]);
        for (int &d : A->dIndices) {
            d = -d;
        }
        if (swap_tensor_shape && A->shape.size() == 2) {
            std::swap(A->shape[0], A->shape[1]);
        }

        #ifdef DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            std::cout << "\t\t adjoint_inplace took "
                    << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
                    << " ms" << std::endl;
        #endif
    }

} // namespace diaq
