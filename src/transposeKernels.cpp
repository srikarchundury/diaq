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

    // tranpose of the diagonals
    if(A->shape.size() == 2) {
        // just change order of dIndices so that x points to -x. without touching realData and imagData, inplace!
        std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(*A);
        #pragma omp parallel for
        for(size_t d = 0; d < A->dIndices.size(); d++) {
            res->dIndices[d] = -A->dIndices[d];
        }
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
    std::vector<int> temp_dIndices;
    std::vector<unsigned int> temp_diagLens;
    std::vector<valType> temp_realData;
    std::vector<valType> temp_imagData;
    std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(new_shape);
    #pragma omp parallel for
    for (size_t d = 0; d < A->dIndices.size(); ++d) {
        int dIdx = A->dIndices[d];
        unsigned int len = A->getDiagonalLengthInternal(dIdx);
        valType* realA = A->realData + A->diagOffsets[d];
        valType* imagA = A->imagData + A->diagOffsets[d];
        for (unsigned int i = 0; i < len; i++) {
            std::vector<unsigned int> ten_pos = A->getTensorPosition(dIdx, i);
            std::vector<unsigned int> new_ten_pos(new_order.size(), 1);
            for(unsigned int j=0; j < new_order.size(); j++) {
                new_ten_pos[j] = ten_pos[new_order[j]];
            }
            std::array<int, 2> d_pos = res->getDiagonalPosition(new_ten_pos);
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
    res = std::make_shared<diaQMatrix>(new_shape, temp_dIndices);
    res->setContiguousData(temp_realData, temp_imagData);
    return res;
}

std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A) {
    return transpose(A, std::vector<unsigned int>());
}

} // namespace diaq
