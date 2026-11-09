#ifdef CUDA_ENABLED
// from_numpy and denseMatrix::convertToDiaQ in the GPU build. Both used to launch a kernel that computed, for every
// element, its diagonal index and position, copy those two arrays (8 bytes per element) back to the host without
// using them, and then rebuild the diagonals serially on the host. They now call the same parallel host routine as
// the CPU build (dense_to_diagonals.hpp): no device memory, no copies.
#include "conversions_gpu.hpp"
#include "dense_to_diagonals.hpp"

#include <cmath>

namespace diaq {

std::shared_ptr<diaQMatrix> from_numpy_cuda(std::complex<valType>* values, std::vector<unsigned int> shape) {
    unsigned long long product = 1;
    for (unsigned int s : shape) product *= s;
    unsigned int x, y;
    if (shape.size() > 2) {  // a tensor: laid out as the most square matrix of its size
        const unsigned int root = static_cast<unsigned int>(std::sqrt(static_cast<double>(product)));
        x = 1;
        y = static_cast<unsigned int>(product);
        for (unsigned int i = root; i > 0; --i) {
            if (product % i == 0U) {
                x = i;
                y = static_cast<unsigned int>(product / i);
                break;
            }
        }
    } else {
        x = shape[0];
        y = shape[1];
    }
    return diagonals_from_dense({x, y}, shape, [values](long long i) { return values[i]; });
}

std::shared_ptr<diaQMatrix> convertToDiaQ_cuda(std::shared_ptr<denseMatrix> d, std::array<unsigned int, 2> new_shape) {
    const valType *re = d->getRealData(), *im = d->getImagData();
    return diagonals_from_dense(new_shape, d->shape, [re, im](long long i) {
        return std::complex<valType>(re[i], im[i]);
    });
}

}  // namespace diaq

#endif  // CUDA_ENABLED
