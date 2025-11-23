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
        phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
        phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

        std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(A->matrix_shape[1], A->matrix_shape[0]);

        #pragma omp parallel for
        for(unsigned int i = 0; i < diagMap.size(); i++) {
            auto it = std::next(diagMap.begin(), i);
            std::shared_ptr<diagonal> newDiag = it->second->copy();
            res->addDiagonal(-1 * it->second->dIndex, newDiag);
        }

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
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > newDiagMap;
    // TODO: allocate for all possible diaognal indices and it's lengths. To paralleize later.
    // std::shared_ptr<diaQMatrix> res = new diaQMatrix(newDiagMap, &new_shape, new_tensor_shape);
    std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(newDiagMap, new_shape, new_tensor_shape);
    // iterate over all diagonals
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagonalMap = A->diagonalMap;

    // #pragma omp parallel for
    // for(int i = -1 * res->matrix_shape[0]; i < res->matrix_shape[1]; i++) {
    //     res->createDiagonal(i);
    // }

    #pragma omp parallel
    {
        #pragma omp single
        for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {

            #pragma omp task
            {
                valType *real_vals = it->second->realValues;
                valType *imag_vals = it->second->imagValues;

                #pragma omp parallel for
                for(unsigned int i = 0; i < it->second->dLength; i++) {
                    // std::cout << "(diagonal_idx, diagonal_pos) = (" << it->first << ", " << i << ")" << std::endl;
                    // std::cout << "element = " << vals[i] << std::endl;
                    std::vector<unsigned int> ten_pos = A->getTensorPosition(it->first, i);
                    // std::cout << "tensor index = (";
                    // for(unsigned int i = 0; i < ten_pos.size()-1; i++) {
                    //     std::cout << ten_pos[i] << ",";
                    // }
                    // std::cout << ten_pos[ten_pos.size()-1] << ")" << std::endl;

                    // modify ten_pos to perform the transposition using the new_order
                    std::vector<unsigned int> new_ten_pos(new_order.size(), 1);
                    #pragma omp parallel for
                    for(unsigned int i=0; i < new_order.size(); i++) {
                        new_ten_pos[i] = ten_pos[new_order[i]];
                    }

                    std::array<int, 2> d_pos = res->getDiagonalPosition(new_ten_pos);
                    // std::cout << "(new_diagonal_idx, new_diagonal_pos) = (" << d_pos[0] << ", " << d_pos[1] << ")" << std::endl;
                    unsigned int d_len = getDiagonalLength(d_pos[0], new_shape);
                    if(real_vals[i] != 0.0 || imag_vals[i] != 0.0) { // to avoid pruning later.
                        res->setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
                    }
                    // std::cout << " -- " << std::endl;
                }
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

    return res;
}

std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A) {
    return transpose(A, std::vector<unsigned int>());
}

} // namespace diaq
