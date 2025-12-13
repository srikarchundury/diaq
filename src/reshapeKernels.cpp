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
    std::vector<int> temp_dIndices;
    std::vector<unsigned int> temp_diagLens;
    std::vector<valType> temp_realData;
    std::vector<valType> temp_imagData;
    std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(matrix_shape);
    #pragma omp parallel for
    for (size_t d = 0; d < A->dIndices.size(); ++d) {
        int dIdx = A->dIndices[d];
        unsigned int len = A->getDiagonalLengthInternal(dIdx);
        valType* realA = A->realData + A->diagOffsets[d];
        valType* imagA = A->imagData + A->diagOffsets[d];
        for(unsigned int i = 0; i < len; i++) {
            std::array<unsigned int, 2> pos = {static_cast<unsigned int>(dIdx), i};
            std::array<int, 2> d_pos = res->getDiagonalPositionByFlatIndex(A->getFlatIndex(pos));
            unsigned int d_len = res->getDiagonalLengthInternal(d_pos[0]);
            if(realA[i] != 0.0 || imagA[i] != 0.0) {
                temp_dIndices.push_back(d_pos[0]);
                temp_diagLens.push_back(d_len);
                temp_realData.push_back(realA[i]);
                temp_imagData.push_back(imagA[i]);
            }
        }
    }
    // After loop: construct result using available API
    res = std::make_shared<diaQMatrix>(matrix_shape, temp_dIndices);
    res->setContiguousData(temp_realData, temp_imagData);

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
