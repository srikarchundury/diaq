#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

#include <stdexcept>

namespace diaq {

// np.tensordot(A, B, axes): sum over A's axes[0] paired with B's axes[1]; the result's axes are A's other axes, then
// B's other axes, each in their original order.
//
// Done as a matrix product: A is permuted to (free axes, contracted axes) and laid out as a
// (free size) x (contracted size) matrix, B to (contracted axes, free axes) as (contracted size) x (free size); then
// product() (CPU or GPU) and the result gets the tensor shape. Contracted axes are paired in the order given.
//
// (The previous tensordot paired only the first contracted axis, put every product on diagonal 0, never summed
// products landing on the same entry, and copied a buffer of the wrong length into the result: garbage values.
// tensordot1, the permute-reshape-product version, computed the result shape from the already permuted A and B.)
std::shared_ptr<diaQMatrix> tensordot(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B,
                                      std::vector<std::vector<unsigned int> > axes) {
    if (axes.size() != 2 || axes[0].size() != axes[1].size()) {
        throw std::invalid_argument("tensordot: axes must be two lists of the same length");
    }
    const std::vector<unsigned int> &axA = axes[0], &axB = axes[1];
    auto contracted = [](const std::vector<unsigned int> &ax, unsigned int i) {
        for (unsigned int a : ax) if (a == i) return true;
        return false;
    };
    std::vector<unsigned int> order_A, order_B, result_shape;
    unsigned long long free_A = 1, free_B = 1, sum_A = 1, sum_B = 1;
    for (unsigned int i = 0; i < A->shape.size(); i++) {
        if (!contracted(axA, i)) {
            order_A.push_back(i);
            result_shape.push_back(A->shape[i]);
            free_A *= A->shape[i];
        }
    }
    for (unsigned int a : axA) {
        if (a >= A->shape.size()) throw std::invalid_argument("tensordot: axis out of range for A");
        order_A.push_back(a);
        sum_A *= A->shape[a];
    }
    for (unsigned int b : axB) {
        if (b >= B->shape.size()) throw std::invalid_argument("tensordot: axis out of range for B");
        order_B.push_back(b);
        sum_B *= B->shape[b];
    }
    for (unsigned int i = 0; i < B->shape.size(); i++) {
        if (!contracted(axB, i)) {
            order_B.push_back(i);
            result_shape.push_back(B->shape[i]);
            free_B *= B->shape[i];
        }
    }
    for (size_t k = 0; k < axA.size(); k++) {
        if (A->shape[axA[k]] != B->shape[axB[k]]) {
            throw std::invalid_argument("tensordot: contracted axes have different sizes");
        }
    }
    if (sum_A != sum_B) throw std::invalid_argument("tensordot: contracted sizes differ");

    std::shared_ptr<diaQMatrix> At = transpose(A, order_A);
    std::shared_ptr<diaQMatrix> Bt = transpose(B, order_B);
    std::shared_ptr<diaQMatrix> Am = matrix_reshape(At, {static_cast<unsigned int>(free_A), static_cast<unsigned int>(sum_A)});
    std::shared_ptr<diaQMatrix> Bm = matrix_reshape(Bt, {static_cast<unsigned int>(sum_B), static_cast<unsigned int>(free_B)});
    std::shared_ptr<diaQMatrix> res = product(Am, Bm);
    if (result_shape.empty()) result_shape = {1, 1};
    res->shape = result_shape;
    return res;
}

} // namespace diaq
