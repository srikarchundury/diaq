#include <algorithm>
#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<diaQMatrix> diaQMatrix::transpose(std::vector<unsigned int> new_order) {
    std::shared_ptr<diaQMatrix> temp = diaq::transpose(shared_from_this(), new_order);
    return temp;
}
std::shared_ptr<diaQMatrix> diaQMatrix::transpose() {
    std::shared_ptr<diaQMatrix> temp = diaq::transpose(shared_from_this());
    return temp;
}

std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A, std::vector<unsigned int> new_order) {
    // // start timer
    // std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();

    if(new_order.size() == 0) {
        new_order.resize(A->shape.size(), 1);
        #pragma omp parallel for
        for(unsigned int i = 0; i < A->shape.size(); i++) {
            new_order[i] = A->shape.size() - i - 1;
        }
    }
    // std::cout << "diaq/transpose called with axes (";
    // for(unsigned int i = 0; i < new_order.size()-1; i++) {
    //     std::cout << new_order[i] << ",";
    // }
    // std::cout << new_order[new_order.size()-1] << ")" << std::endl;

    // matrix transpose: diagonal d of an R x C matrix is diagonal -d of the C x R transpose, element by element
    // (this case built the result and then fell through to the general path below)
    if (A->shape.size() == 2 && (new_order.empty() || (new_order.size() == 2 && new_order[0] == 1 && new_order[1] == 0))) {
        std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(*A);
        for (size_t d = 0; d < A->dIndices.size(); d++) {
            res->dIndices[d] = -A->dIndices[d];
        }
        std::swap(res->matrix_shape[0], res->matrix_shape[1]);
        res->shape = {A->shape[1], A->shape[0]};
        return res;
    }
    // otherwise, we have to do a lot of work
    // shape of result
    std::vector<unsigned int> new_tensor_shape = modifyTensorShape(A->shape, new_order);
    // std::cout << "gives new_tensor_shape (";
    // for(unsigned int i = 0; i < new_tensor_shape.size()-1; i++) {
    //     std::cout << new_tensor_shape[i] << ",";
    // }
    // std::cout << new_tensor_shape[new_tensor_shape.size()-1] << ")" << std::endl;
    // now, let's perform the transpose element by element
    unsigned int l = new_tensor_shape.size();
    // this shape is important! decides the length of diagonals! Hence, we have to re-write it to maximize length of diagonals, so that number of diagonls are minimized.
    std::array<unsigned int, 2> new_shape;
    new_shape[0] = 1;
    new_shape[1] = 1;
    unsigned int i = l / 2;
    // #pragma GCC unroll 8
    for(unsigned int r = 0; r<i ; r++) {
        new_shape[0] = new_shape[0] * new_tensor_shape[r];
    }
    // #pragma GCC unroll 8
    for(unsigned int r = i; r<l ; r++) {
        new_shape[1] = new_shape[1] * new_tensor_shape[r];
    }
    // std::cout << "new_shape = " << new_shape[0] << "," << new_shape[1] << std::endl;
    // res matrix/tensor
    // Every stored nonzero moves to its permuted tensor position, i.e. to the row-major flat index of that position
    // in the new tensor shape, laid out as a new_shape matrix. Previously the nonzeros were collected with push_back
    // from an OpenMP parallel loop (a data race), the new position was taken from a 2-D shape for a tensor of any
    // rank, and each nonzero was kept as one "diagonal" entry without its position along the diagonal.
    struct Entry { int diag; unsigned int pos; valType re, im; };
    std::vector<Entry> entries;
    const unsigned long long cols = new_shape[1];
    for (size_t d = 0; d < A->dIndices.size(); ++d) {
        const int dIdx = A->dIndices[d];
        const unsigned int len = A->getDiagonalLengthInternal(dIdx);
        const valType* realA = A->realData + A->diagOffsets[d];
        const valType* imagA = A->imagData + A->diagOffsets[d];
        for (unsigned int i = 0; i < len; i++) {
            if (realA[i] == 0.0 && imagA[i] == 0.0) continue;
            const std::vector<unsigned int> ten_pos = A->getTensorPosition(dIdx, i);
            unsigned long long flat = 0;
            for (unsigned int j = 0; j < l; j++) {
                flat = flat * new_tensor_shape[j] + ten_pos[new_order[j]];
            }
            const unsigned long long r = flat / cols, c = flat % cols;
            const int diag = static_cast<int>(static_cast<long long>(c) - static_cast<long long>(r));
            entries.push_back({diag, static_cast<unsigned int>(diag >= 0 ? r : c), realA[i], imagA[i]});
        }
    }
    std::vector<int> diags;
    diags.reserve(entries.size());
    for (const Entry& e : entries) diags.push_back(e.diag);
    std::sort(diags.begin(), diags.end());
    diags.erase(std::unique(diags.begin(), diags.end()), diags.end());
    std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(new_shape, diags, new_tensor_shape);
    for (const Entry& e : entries) {
        const size_t slot = static_cast<size_t>(std::lower_bound(diags.begin(), diags.end(), e.diag) - diags.begin());
        res->realData[res->diagOffsets[slot] + e.pos] = e.re;
        res->imagData[res->diagOffsets[slot] + e.pos] = e.im;
    }
    return res;
}

std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A) {
    return transpose(A, std::vector<unsigned int>());
}

} // namespace diaq
