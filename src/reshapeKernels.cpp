#include <algorithm>
#include <stdexcept>
#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

void diaQMatrix::matrix_reshape(std::array<unsigned int, 2> matrix_shape) {
    // printf("self reshape called with newshape (%ld, %ld)\n", matrix_shape[0], matrix_shape[1]);
    std::shared_ptr<diaQMatrix> temp = diaq::matrix_reshape(shared_from_this(), matrix_shape);
    *this = *temp;
}

std::shared_ptr<diaQMatrix> diaQMatrix::reshape(std::vector<unsigned int> new_tensor_shape) {
    return diaq::reshape(shared_from_this(), new_tensor_shape);
}

std::shared_ptr<diaQMatrix> matrix_reshape(std::shared_ptr<diaQMatrix> A, std::array<unsigned int, 2> matrix_shape) {
    // start time
    #ifdef DEBUG
        printf("starting matrix_reshape -- ");
        std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();
    #endif

    // Every stored nonzero of A goes to the same row-major flat position in the new matrix shape, i.e. to new
    // diagonal (col - row) and position along it. Previously the nonzeros were collected with push_back from an
    // OpenMP parallel loop (a data race: corrupted the heap, "double free" at random), the flat index was computed
    // from (diagonal, position) as if it were (row, column), and the result kept one "diagonal" entry per nonzero
    // without its position along the diagonal.
    const unsigned long long rowsA = A->matrix_shape[0], colsA = A->matrix_shape[1];
    const unsigned long long rows = matrix_shape[0], cols = matrix_shape[1];
    if (rowsA * colsA != rows * cols) {
        throw std::invalid_argument("matrix_reshape: the new shape has a different number of entries");
    }
    struct Entry { int diag; unsigned int pos; valType re, im; };
    std::vector<Entry> entries;
    for (size_t d = 0; d < A->dIndices.size(); ++d) {
        const int dIdx = A->dIndices[d];
        const unsigned int len = A->getDiagonalLengthInternal(dIdx);
        const valType* realA = A->realData + A->diagOffsets[d];
        const valType* imagA = A->imagData + A->diagOffsets[d];
        for (unsigned int i = 0; i < len; i++) {
            if (realA[i] == 0.0 && imagA[i] == 0.0) continue;
            const unsigned long long row = (dIdx >= 0) ? i : i - static_cast<long long>(dIdx);
            const unsigned long long col = (dIdx >= 0) ? i + static_cast<unsigned long long>(dIdx) : i;
            const unsigned long long flat = row * colsA + col;
            const unsigned long long r = flat / cols, c = flat % cols;
            const int diag = static_cast<int>(static_cast<long long>(c) - static_cast<long long>(r));
            const unsigned int pos = static_cast<unsigned int>(diag >= 0 ? r : c);  // position along the diagonal
            entries.push_back({diag, pos, realA[i], imagA[i]});
        }
    }
    std::vector<int> diags;
    diags.reserve(entries.size());
    for (const Entry& e : entries) diags.push_back(e.diag);
    std::sort(diags.begin(), diags.end());
    diags.erase(std::unique(diags.begin(), diags.end()), diags.end());
    std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(matrix_shape, diags);  // zeroed storage
    for (const Entry& e : entries) {
        const size_t slot = static_cast<size_t>(std::lower_bound(diags.begin(), diags.end(), e.diag) - diags.begin());
        res->realData[res->diagOffsets[slot] + e.pos] = e.re;
        res->imagData[res->diagOffsets[slot] + e.pos] = e.im;
    }

    #ifdef DEBUG
        std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t matrix_reshape took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return res;
}

std::shared_ptr<diaQMatrix> reshape(std::shared_ptr<diaQMatrix> A, std::vector<unsigned int> new_tensor_shape) {
    unsigned int old_product = 1;
    // #pragma GCC unroll 8
    for(unsigned int i=0; i < A->shape.size(); i++) old_product *= A->shape[i];
    unsigned int new_product = 1;
    // #pragma GCC unroll 8
    for(unsigned int i=0; i < new_tensor_shape.size(); i++) new_product *= new_tensor_shape[i];
    if(old_product != new_product) {
        std::cout << old_product << "!=" << new_product << std::endl;
        throw std::invalid_argument("cannot reshape into given shape");
    }
    // this is tensor reshape, we can just replace shape and we're good.
    A->shape = new_tensor_shape;
    return A;
}

} // namespace diaq
