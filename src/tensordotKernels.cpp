#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<diaQMatrix> tensordot(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned int> > axes) {
    // std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();

    // std::cout << "--" << std::endl;
    // std::cout << "tensordot called for A - " << std::endl;
    // A->print_meta();
    // std::cout << "and B - " << std::endl;
    // B->print_meta();
    // std::cout << "with axes - " << " (";
    // unsigned int i=0;
    // for(i=0; i<axes[0].size()-1; i++)
    //     std::cout << axes[0][i] << ",";
    // std::cout << axes[0][i] << ") and (";
    // for(i=0; i<axes[1].size()-1; i++)
    //     std::cout << axes[1][i] << ",";
    // std::cout << axes[1][i] << ")" << std::endl;
    // std::cout << "--" << std::endl;

    // let's try element by element like we do with tensor transpose!
    std::vector<unsigned int> new_tensor_shape = newTensorShape(A->shape, B->shape, axes[0], axes[1]);
    std::array<unsigned int, 2> new_matrix_shape = getMatrixShape(new_tensor_shape);
    std::array<unsigned int, 2> make_new_shape;
    make_new_shape[0] = new_matrix_shape[0];
    make_new_shape[1] = new_matrix_shape[1];

    // Temp buffers for two-pass construction
    std::vector<int> temp_dIndices;
    std::vector<unsigned int> temp_diagLens;
    std::vector<valType> temp_realData;
    std::vector<valType> temp_imagData;

    // Iterate over all diagonals in A and B using new contiguous API
    for (size_t a = 0; a < A->dIndices.size(); ++a) {
        int dIndexA = A->dIndices[a];
        unsigned int offsetA = A->diagOffsets[a];
        unsigned int dLengthA = A->getDiagonalLengthInternal(dIndexA);
        valType* real_vals_A = A->realData + offsetA;
        valType* imag_vals_A = A->imagData + offsetA;
        for (unsigned int diagA_pos = 0; diagA_pos < dLengthA; ++diagA_pos) {
            std::vector<unsigned int> ten_pos_A = A->getTensorPosition(dIndexA, diagA_pos);
            for (size_t b = 0; b < B->dIndices.size(); ++b) {
                int dIndexB = B->dIndices[b];
                unsigned int offsetB = B->diagOffsets[b];
                unsigned int dLengthB = B->getDiagonalLengthInternal(dIndexB);
                valType* real_vals_B = B->realData + offsetB;
                valType* imag_vals_B = B->imagData + offsetB;
                for (unsigned int diagB_pos = 0; diagB_pos < dLengthB; ++diagB_pos) {
                    std::vector<unsigned int> ten_pos_B = B->getTensorPosition(dIndexB, diagB_pos);
                    // if the common axes
                    if (ten_pos_A[axes[0][0]] == ten_pos_B[axes[1][0]]) {
                        std::vector<unsigned int> result_coords = getTenPos(ten_pos_A, ten_pos_B, axes[0], axes[1], A->shape, B->shape);
                        // get the diagonal position and length
                        // For two-pass, we need to compute diagonal index and length for result
                        int res_diag_idx = /* logic to compute diagonal index from result_coords */ 0;
                        unsigned int res_diag_len = 1; // or compute actual length if needed
                        valType real_val = real_vals_A[diagA_pos] * real_vals_B[diagB_pos] - imag_vals_A[diagA_pos] * imag_vals_B[diagB_pos];
                        valType imag_val = real_vals_A[diagA_pos] * imag_vals_B[diagB_pos] + imag_vals_A[diagA_pos] * real_vals_B[diagB_pos];
                        if(real_val != 0.0 || imag_val != 0.0) {
                            temp_dIndices.push_back(res_diag_idx);
                            temp_diagLens.push_back(res_diag_len);
                            temp_realData.push_back(real_val);
                            temp_imagData.push_back(imag_val);
                        }
                    }
                }
            }
        }
    }
    // Construct result using contiguous API
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(make_new_shape, temp_dIndices);
    result->shape = new_tensor_shape;
    result->setContiguousData(temp_realData, temp_imagData);
    return result;
}

std::shared_ptr<diaQMatrix> tensordot1(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned int> > axes) {
    // // start timer
    // std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();


    std::cout << "--" << std::endl;
    std::cout << "tensordot called for A - " << std::endl;
    A->print_meta();
    std::cout << "and B - " << std::endl;
    B->print_meta();
    std::cout << "with axes - " << " (";
    unsigned int i=0;
    for(i=0; i<axes[0].size()-1; i++)
        std::cout << axes[0][i] << ",";
    std::cout << axes[0][i] << ") and (";
    for(i=0; i<axes[1].size()-1; i++)
        std::cout << axes[1][i] << ",";
    std::cout << axes[1][i] << ")" << std::endl;
    std::cout << "--" << std::endl;

    std::shared_ptr<diaQMatrix> res;
    // move axes
    std::vector<unsigned int> order_A;
    std::vector<unsigned int> order_B;
    // #pragma GCC unroll 8
    for(unsigned int i = 0; i < axes[1].size(); i++)
        order_B.push_back(axes[1][i]);
    for(unsigned int i = 0; i < A->shape.size(); i++) {
        unsigned int notin = 1;
        for(unsigned int p = 0; p < axes[0].size(); p++) {
            if(i == axes[0][p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            order_A.push_back(i);
        }
    }
    for(unsigned int i = 0; i < B->shape.size(); i++) {
        unsigned int notin = 1;
        for(unsigned int p = 0; p < axes[1].size(); p++) {
            if(i == axes[1][p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            order_B.push_back(i);
        }
    }
    // #pragma GCC unroll 8
    for(unsigned int i = 0; i < axes[0].size(); i++)
        order_A.push_back(axes[0][i]);
    // std::cout << "with order_A (";
    // for(unsigned int i = 0; i < order_A.size()-1; i++)
    //     std::cout << order_A[i] << ",";
    // std::cout << order_A[order_A.size()-1] << ")" << std::endl;
    // std::cout << "with order_B (";
    // for(unsigned int i = 0; i < order_B.size()-1; i++)
    //     std::cout << order_B[i] << ",";
    // std::cout << order_B[order_B.size()-1] << ")" << std::endl;

    unsigned int axes_0_product = 1;
    // #pragma GCC unroll 8
    for(unsigned int i=0;i<axes[0].size();i++) axes_0_product *= A->shape[axes[0][i]];
    unsigned int axes_1_product = 1;
    // #pragma GCC unroll 8
    for(unsigned int i=0;i<axes[1].size();i++) axes_1_product *= B->shape[axes[1][i]];

    A = transpose(A, order_A);
    // printf("A after transpose\n");
    // A->print();
    B = transpose(B, order_B);
    // printf("B after transpose\n");
    // B->print();

    unsigned int totalA = A->matrix_shape[0] * A->matrix_shape[1];
    unsigned int totalB = B->matrix_shape[0] * B->matrix_shape[1];

    // std::cout << "axes_0_product = " << axes_0_product << " axes_1_product = " << axes_1_product << std::endl;
    // These have to be equal right? Let's add a check
    if(axes_1_product != axes_0_product) {
        std::cout << "axes_1_product != axes_0_product i.e. " << axes_1_product << " != " << axes_0_product << std::endl;
        throw std::invalid_argument("invalid axes, can't perform tensordot");
    }

    std::array<unsigned int, 2> new_shape_a = {totalA / axes_0_product, axes_0_product};
    std::array<unsigned int, 2> new_shape_b = {axes_1_product, totalB / axes_1_product};

    // std::vector<unsigned int> new_shape_a{totalA / axes_0_product, axes_0_product};
    // std::vector<unsigned int> new_shape_b{axes_1_product, totalB / axes_1_product};

    std::shared_ptr<diaQMatrix> reshaped_A = matrix_reshape(A, new_shape_a);
    std::shared_ptr<diaQMatrix> reshaped_B = matrix_reshape(B, new_shape_b);

    // std::cout << "after reshape A - " << std::endl;
    // reshaped_A->convertToDenseMatrix()->print();
    // std::cout << "and B - " << std::endl;
    // reshaped_B->convertToDenseMatrix()->print();

    res = product(reshaped_A, reshaped_B);

    // calculating result's tensor_shape
    std::vector<unsigned int> result_tensor_shape = newTensorShape(A->shape, B->shape, axes[0], axes[1]);
    res->shape = result_tensor_shape;

    // Two-pass: collect all diagonals and values from res
    std::vector<int> temp_dIndices(res->dIndices);
    std::vector<unsigned int> temp_diagLens;
    std::vector<valType> temp_realData;
    std::vector<valType> temp_imagData;
    for (size_t k = 0; k < res->dIndices.size(); ++k) {
        int dIdx = res->dIndices[k];
        unsigned int len = res->getDiagonalLengthInternal(dIdx);
        temp_diagLens.push_back(len);
        unsigned int offset = res->diagOffsets[k];
        for (unsigned int i = 0; i < len; ++i) {
            temp_realData.push_back(res->realData[offset + i]);
            temp_imagData.push_back(res->imagData[offset + i]);
        }
    }
    std::shared_ptr<diaQMatrix> final_result = std::make_shared<diaQMatrix>(res->matrix_shape, temp_dIndices);
    final_result->shape = result_tensor_shape;
    final_result->setContiguousData(temp_realData, temp_imagData);
    return final_result;
}

} // namespace diaq
