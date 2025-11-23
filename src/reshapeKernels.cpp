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

    // this is matrix_reshape.
    // printf("diaq/matrix_reshape called with newshape (%ld, %ld)\n", matrix_shape[0], matrix_shape[1]);
    // std::shared_ptr<diaQMatrix> res = new diaQMatrix(&matrix_shape, A->shape);
    std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(matrix_shape, A->shape);
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;
    for (it = A->diagonalMap.begin(); it != A->diagonalMap.end(); it++) {
        valType *real_vals = it->second->realValues;
        valType *imag_vals = it->second->imagValues;
        #pragma omp parallel for
        for(unsigned int i = 0; i < it->second->dLength; i++) {
            // old_d_pos has (it->first, i) for A->matrix_shape
            std::array<int, 2> d_pos = res->getDiagonalPositionByFlatIndex(A->getFlatIndex(it->first, i));
            int d_len = getDiagonalLength(d_pos[0], matrix_shape);
            if(real_vals[i] != 0 || imag_vals[i] != 0) { // doing this here to avoid pruning later below.
                res->setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
            }
        }
    }

    // setting dIndices and dPointers
    res->dIndices.resize(res->diagonalMap.size());
    res->dPointers.resize(res->diagonalMap.size());
    #pragma omp parallel for
    for(unsigned int i = 0; i < res->diagonalMap.size(); i++) {
        auto it = std::next(res->diagonalMap.begin(), i);
        res->dIndices[i] = it->first;
        res->dPointers[i] = it->second;
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
