#ifndef DIAQ_DENSE_TO_DIAGONALS_HPP
#define DIAQ_DENSE_TO_DIAGONALS_HPP

#include <algorithm>
#include <array>
#include <complex>
#include <memory>
#include <vector>

#include "config.hpp"
#include "diaQMatrix.hpp"

namespace diaq {

// Dense values (row-major rows x cols, read through get(flat index)) to a diaQMatrix holding the nonzero diagonals,
// in ascending order. Two passes, both parallel over diagonals: find which diagonals have a nonzero (stopping at the
// first one), then copy those diagonals into the result's storage. (The previous code built a whole diaQMatrix, with
// its own zero-filled storage, for every element just to compute the element's position; collected each diagonal in
// a temporary vector; and appended them in a critical section, so the diagonal order changed from run to run.)
template <typename Get>
inline std::shared_ptr<diaQMatrix> diagonals_from_dense(std::array<unsigned int, 2> ms,
                                                        const std::vector<unsigned int> &tensor_shape, Get get) {
    const long long rows = ms[0], cols = ms[1];
    const long long nd = rows + cols - 1;
    std::vector<char> nonzero(nd > 0 ? nd : 0, 0);
    #pragma omp parallel for schedule(dynamic, 64)
    for (long long idx = 0; idx < nd; ++idx) {
        const long long d = idx - (rows - 1);
        const long long r0 = d >= 0 ? 0 : -d, c0 = d >= 0 ? d : 0;
        const long long len = std::min(rows - r0, cols - c0);
        for (long long j = 0; j < len; ++j) {
            const std::complex<valType> v = get((r0 + j) * cols + c0 + j);
            if (v.real() != 0.0 || v.imag() != 0.0) {
                nonzero[idx] = 1;
                break;
            }
        }
    }
    std::vector<int> diags;
    for (long long idx = 0; idx < nd; ++idx) {
        if (nonzero[idx]) diags.push_back(static_cast<int>(idx - (rows - 1)));
    }
    std::shared_ptr<diaQMatrix> qm = std::make_shared<diaQMatrix>(ms, diags, tensor_shape);
    #pragma omp parallel for schedule(dynamic, 16)
    for (long long k = 0; k < static_cast<long long>(diags.size()); ++k) {
        const long long d = diags[k];
        const long long r0 = d >= 0 ? 0 : -d, c0 = d >= 0 ? d : 0;
        const long long len = std::min(rows - r0, cols - c0);
        valType *re = qm->realData + qm->diagOffsets[k];
        valType *im = qm->imagData + qm->diagOffsets[k];
        for (long long j = 0; j < len; ++j) {
            const std::complex<valType> v = get((r0 + j) * cols + c0 + j);
            re[j] = v.real();
            im[j] = v.imag();
        }
    }
    return qm;
}

}  // namespace diaq

#endif
