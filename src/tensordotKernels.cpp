#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::shared_ptr<diaQMatrix> tensordot(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned int> > axes) {
    // start timer
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
    // std::shared_ptr<diaQMatrix> res = new diaQMatrix(&new_matrix_shape, new_tensor_shape);
    std::array<unsigned int, 2> make_new_shape;
    make_new_shape[0] = new_matrix_shape[0];
    make_new_shape[1] = new_matrix_shape[1];
    std::shared_ptr<diaQMatrix> res = std::make_shared<diaQMatrix>(make_new_shape, new_tensor_shape);
    // printf("res matrix shape\n");
    // res->print_shape();

    // element by element tensordot multiplication, inspired from COO format
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > mapA = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > mapB = B->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itA, itB;
    #pragma omp parallel
    {
        #pragma omp single
        {
            for (itA = mapA.begin(); itA != mapA.end(); itA++) {
                #pragma omp task
                {
                    std::shared_ptr<diagonal> diagA = itA->second;
                    valType *real_vals_A = diagA->realValues;
                    valType *imag_vals_A = diagA->imagValues;
                    // #pragma omp parallel for
                    for(unsigned int diagA_pos = 0; diagA_pos < diagA->dLength; diagA_pos++) {
                        std::vector<unsigned int> ten_pos_A = A->getTensorPosition(itA->first, diagA_pos);
                        // #pragma omp single
                        // {
                            for (itB = mapB.begin(); itB != mapB.end(); itB++) {
                                #pragma omp task
                                {
                                    std::shared_ptr<diagonal> diagB = itB->second;
                                    valType *real_vals_B = diagB->realValues;
                                    valType *imag_vals_B = diagB->imagValues;
                                    #pragma omp parallel for
                                    for(unsigned int diagB_pos = 0; diagB_pos < diagB->dLength; diagB_pos++) {
                                        std::vector<unsigned int> ten_pos_B = B->getTensorPosition(itB->first, diagB_pos);
                                        // if the common axes
                                        if (ten_pos_A[axes[0][0]] == ten_pos_B[axes[1][0]]) {
                                            // print ten_pos_A and ten_pos_B
                                            // printf("ten_pos_A = (");
                                            // for (int i = 0; i < ten_pos_A.size() - 1; i++) {
                                            //     printf("%ld, ", ten_pos_A[i]);
                                            // }
                                            // printf("%ld)\n", ten_pos_A[ten_pos_A.size() - 1]);
                                            // printf("ten_pos_B = (");
                                            // for (int i = 0; i < ten_pos_B.size() - 1; i++) {
                                            //     printf("%ld, ", ten_pos_B[i]);
                                            // }
                                            // printf("%ld)\n", ten_pos_B[ten_pos_B.size() - 1]);
                                            // Calculate resulting coordinates after contraction
                                            std::vector<unsigned int> result_coords = getTenPos(ten_pos_A, ten_pos_B, axes[0], axes[1], A->shape, B->shape);
                                            // printing result_coords
                                            // printf("result_coords = (");
                                            // for (unsigned int i = 0; i < result_coords.size() - 1; i++) {
                                            //     printf("%ld, ", result_coords[i]);
                                            // }
                                            // printf("%ld)\n", result_coords[result_coords.size() - 1]);

                                            // get the diagonal position and length
                                            std::array<int, 2> res_diag_pos = res->getDiagonalPosition(result_coords);
                                            unsigned int res_diag_len = res->getDiagonalLength(res_diag_pos[0]);
                                            valType real_val = real_vals_A[diagA_pos] * real_vals_B[diagB_pos] - imag_vals_A[diagA_pos] * imag_vals_B[diagB_pos];
                                            valType imag_val = real_vals_A[diagA_pos] * imag_vals_B[diagB_pos] + imag_vals_A[diagA_pos] * real_vals_B[diagB_pos];
                                            if(real_val != 0.0 || imag_val != 0.0) { // to avoid pruning later.
                                                valType new_real_val = res->getItem_real(res_diag_pos[0], res_diag_pos[1]) + real_val;
                                                valType new_imag_val = res->getItem_imag(res_diag_pos[0], res_diag_pos[1]) + imag_val;
                                                res->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], res_diag_len, new_real_val, new_imag_val);
                                            }
                                        }
                                    }
                                }
                            }
                        // }
                    }
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

std::shared_ptr<diaQMatrix> tensordot1(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned int> > axes) {
    // // start timer
    // std::chrono::high_resolution_clock::time_point start = std::chrono::high_resolution_clock::now();

    A->balance(); // to make sure x and y dims are balanced in the underlying matrix format
    B->balance(); // to make sure x and y dims are balanced in the underlying matrix format

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
    res->shape = newTensorShape(A->shape, B->shape, axes[0], axes[1]);
    // res->pruneMatrix(); // do we really need this?

    // res->transpose(); // to make sure x and y dims are balanced in the underlying matrix format

    return res;
}

} // namespace diaq
