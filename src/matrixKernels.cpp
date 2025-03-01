#include "matrixKernels.hpp"

#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

// ----------------------------------------------------------------
//
// Matrix arithmetic
//
// ----------------------------------------------------------------

/**
 * @brief diagonal matrix multiplication
 * 
 * @param A diagonal A index
 * @param B diagonal B index
 * @param A diagonal A
 * @param B diagonal B
 * 
 * @return NULL if zero, else diagonal C
 */
long int getDiagonalLength(long int dIndex, long int *shape) {
    // std::cout << "diag_Index = " << dIndex << " ";
    long int lenRes;
    if(dIndex < 0) {
        lenRes = shape[0] + dIndex;
    } else if(dIndex > 0) {
        lenRes = shape[1] - dIndex;
    }  else {
        lenRes = (shape[0] > shape[1])?shape[1]:shape[0];
    }
    if (lenRes > shape[0]) {
        lenRes = shape[0];
    }
    else if(lenRes > shape[1]) {
        lenRes = shape[1];
    }
    // std::cout << "lenRes = " << lenRes << std::endl;
    return lenRes;
}
diagonal *multiplyDiagonals(long int *shapeA, long int *shapeB, long int indexA, long int indexB, diagonal *diagA, diagonal *diagB) {
    long int res_index = indexA + indexB;
    if (res_index <= 0 && shapeA[0] <= abs(res_index)) {
        return NULL;
    } else if (res_index > 0 && shapeB[1] <= res_index) {
        return NULL;
    }
    long int lenDiagA = diagA->dLength;
    long int lenDiagB = diagB->dLength;
    // result matrix has dimensions {shapeA[0], shapeB[1]}
    long int *res_dims = new long int[2]{shapeA[0], shapeB[1]};
    long int lenRes = getDiagonalLength(res_index, res_dims);
    delete[] res_dims;
    diagonal *res = new diagonal(res_index, lenRes);

    // std::cout << "diagonal length = " << lenRes << std::endl;
    long int offsetA = abs(indexA);  // Absolute value of indexA
    long int offsetB = abs(indexB);  // Absolute value of indexB
    long int jump = 0;  // Initialize jump

    // Case 1: indexA is above the main diagonal (indexA > 0)
    if (indexA > 0) { 
        if (indexB > 0) { 
            // Align both diagonals by setting offsetB = offsetA
            offsetB = offsetA;
            offsetA = 0;
        } 
        else if (indexB < 0) { 
            // Align diagonals based on their relative distance from the main diagonal
            if (offsetA > offsetB) {
                offsetB = abs(res_index);  // Align indexB to the result index
                offsetA = 0;
            } else {
                offsetA = abs(res_index);  // Align indexA to the result index
                offsetB = 0;
            }
        } 
        else { 
            // indexA is above the main diagonal, indexB is on it
            offsetB = offsetA;
            offsetA = 0;
        }
    } 

    // Case 2: indexA is below the main diagonal (indexA < 0)
    else if (indexA < 0) { 
        if (indexB > 0) { 
            // Case where indexA is below and indexB is above the main diagonal
            // Calculate the "jump" based on the shortest diagonal
            if (lenDiagB < lenDiagA) {
                jump = lenRes - lenDiagB;  // Jump past extra elements in diagonal A
            } else if (lenDiagA < lenDiagB) {
                jump = lenRes - lenDiagA;  // Jump past extra elements in diagonal B
            } else {
                // If both diagonals are the same length, jump based on res_index
                jump = (res_index < 0) ? abs(indexB) : abs(indexA);
            }
            // After calculating the jump, reset both offsets
            offsetA = 0;
            offsetB = 0;
        } 
        else if (indexB < 0) { 
            // Both diagonals are below the main diagonal, swap the offsets
            std::swap(offsetA, offsetB); 
            offsetB = 0;
        } 
        else { 
            // indexA is below the main diagonal, indexB is on it
            offsetA = 0;
            offsetB = 0;
        }
    } 

    // Case 3: indexA is exactly on the main diagonal (indexA == 0)
    else { 
        if (indexB < 0) { 
            // Align indexA with indexB, reset indexB
            offsetA = offsetB;
            offsetB = 0;
        } else {
            // Both diagonals are on the main diagonal
            offsetA = 0;
            offsetB = 0;
        }
    }

    // Apply the jump if necessary
    long int k = (jump != 0) ? jump : 0;  // Set k to jump if jump > 0

	valType *real_vals_a = diagA->realValues;
    valType *imag_vals_a = diagA->imagValues;
    valType *real_vals_b = diagB->realValues;
    valType *imag_vals_b = diagB->imagValues;
	valType *real_vals_final = res->realValues;
    valType *imag_vals_final = res->imagValues;

    #ifdef DEEP_DEBUG
        std::cout << "k=" << k << std::endl;
        std::cout << "lenRes,jump,offsetA,offsetB " << lenRes << "," << jump << "," << offsetA << "," << offsetB << std::endl;
    #endif

    #if VECTORIZATION_TYPE == 0
        run_sse(k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
    #elif VECTORIZATION_TYPE == 1
        #ifdef __AVX512F__
            run_avx512(k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
        #elif defined(__AVX__)
            run_avx(k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
        #endif
    #elif VECTORIZATION_TYPE == -1
        run_without_vectorization(k, lenRes, offsetA, offsetB, jump, lenDiagA, lenDiagB, real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
    #endif

    return res;
}

/**
 * @brief quantum sparse matrix multiplication (C = A.B)
 * 
 * @param A diaQMatrix
 * @param B diaQMatrix
 * 
 * @return diaQMatrix  C
 */
diaQMatrix *product(diaQMatrix *A, diaQMatrix *B) {

    // printf("here hey hey\n");
    
    // A->print_meta();
    // B->print_meta();

    #ifdef DEBUG
        // start timer
        std::cout << "starting product -- " << std::endl;
        auto start = std::chrono::high_resolution_clock::now();
    #endif


    #ifdef CUDA_ENABLED
        return product_cuda(A, B);
    #else

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- product --- " << std::endl;
        std::cout << " --- " << std::endl;
        A->print();
        std::cout << " --- times --- " << std::endl;
        B->print();
        std::cout << " --- " << std::endl;
    #endif

    // if(A->matrix_shape[1] != B->matrix_shape[0]) {
    //     throw std::invalid_argument("input matrices are not multiplyable");
    // }
    // #pragma omp parallel
    // {
    //     #pragma omp single
    //     {
    //         for (itA = mapA.begin(); itA != mapA.end(); itA++) {
    //             for (itB = mapB.begin(); itB != mapB.end(); itB++) {
    //                 #pragma omp taskgroup
    //                 {
    //                     #pragma omp task
    //                     {
    //                         #ifdef DEEP_DEBUG
    //                             std::cout << " ------ diags ------ " << std::endl;
    //                             itA->second->print();
    //                             itB->second->print();
    //                             std::cout << " ------ diags ------ " << std::endl;
    //                             std::cout << " --- " << std::endl;
    //                         #endif
    //                         #ifdef DEEP_DEBUG
    //                             std::cout << "Thread ID " << omp_get_thread_num() << " is working on diagonal " << itA->first << " and " << itB->first << std::endl;
    //                         #endif

    //                         diagonal *diagNew = multiplyDiagonals(A->matrix_shape, B->matrix_shape, itA->first, itB->first, itA->second, itB->second);

    //                         if(diagNew != NULL && diagNew->dLength != 0 && !diagNew->isEmpty()) {

    //                             #ifdef DEEP_DEBUG
    //                                 std::cout << " ------ new diag ------ " << std::endl;
    //                                 diagNew->print();
    //                                 std::cout << " ------ new diag ------ " << std::endl;
    //                             #endif

    //                             #pragma omp critical
    //                             {
    //                                 result->addDiagonal(diagNew->dIndex, diagNew);
    //                             }

    //                             #ifdef DEEP_DEBUG
    //                                 std::cout << " ------ result ------ " << std::endl;
    //                                 result->print();
    //                                 std::cout << " ------ result ------ " << std::endl;
    //                             #endif

    //                         } else if (diagNew != NULL) {

    //                             #ifdef DEEP_DEBUG
    //                                 printf(" --- printing empty diagonal --- \n");
    //                                 diagNew->print();
    //                                 printf(" --- --- --- \n");
    //                             #endif

    //                             diagNew->free();
    //                         }
    //                     } // ends omp task
    //                 } // ends omp taskgroup
    //             } // ends for-inner
    //         } // ends for-outer
    //     } // ends omp single
    // } // ends omp parallel

    long int *d = new long int[2];
    d[0] = A->matrix_shape[0];
    d[1] = B->matrix_shape[1];
    diaQMatrix* result = new diaQMatrix(&d);
    std::unordered_map<long int, diagonal*> mapA = A->diagonalMap;
    std::unordered_map<long int, diagonal*> mapB = B->diagonalMap;
    std::vector<std::unordered_map<long int, diagonal*>> thread_local_maps(omp_get_max_threads());
    std::vector<std::pair<long int, diagonal*>> vecA(mapA.begin(), mapA.end());
    std::vector<std::pair<long int, diagonal*>> vecB(mapB.begin(), mapB.end());
    #pragma omp parallel
    {
        int thread_id = omp_get_thread_num();
        auto &local_map = thread_local_maps[thread_id];

        #pragma omp for
        for (size_t a = 0; a < vecA.size(); ++a) {
            for (size_t b = 0; b < vecB.size(); ++b) {
                diagonal *diagNew = multiplyDiagonals(A->matrix_shape, B->matrix_shape, 
                                                    vecA[a].first, vecB[b].first, 
                                                    vecA[a].second, vecB[b].second);
                if (diagNew != NULL && diagNew->dLength != 0 && !diagNew->isEmpty()) {
                    local_map[diagNew->dIndex] = diagNew;
                } else if (diagNew != NULL) {
                    diagNew->free();
                }
            }
        }
    }
    #pragma omp parallel for
    for (size_t t = 0; t < thread_local_maps.size(); ++t) {
        for (auto &entry : thread_local_maps[t]) {
            #pragma omp critical
            result->addDiagonal(entry.first, entry.second);
        }
    }

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
		// --- First matrix ---
		std::unordered_map<long int, diagonal*> A_diagonalMap = A->getDiagonalMap();
        // get keys of A_diagonalMap
        std::vector<long int> A_keys;
        std::unordered_map<long int, diagonal*>::iterator A_it;
        for (A_it = A_diagonalMap.begin(); A_it != A_diagonalMap.end(); A_it++) {
            A_keys.push_back(A_it->first);
        }
        // print keys
        std::cout << "keys of A_diagonalMap: ";
        for(long int i = 0; i < A_keys.size(); i++) {
            std::cout << A_keys[i] << " ";
        }
        std::cout << std::endl;
		// --- Second matrix ---
        std::unordered_map<long int, diagonal*> B_diagonalMap = B->getDiagonalMap();
        // get keys of B_diagonalMap
        std::vector<long int> B_keys;
        std::unordered_map<long int, diagonal*>::iterator B_it;
        for (B_it = B_diagonalMap.begin(); B_it != B_diagonalMap.end(); B_it++) {
            B_keys.push_back(B_it->first);
        }
        // print keys
        std::cout << "keys of B_diagonalMap: ";
        for(long int i = 0; i < B_keys.size(); i++) {
            std::cout << B_keys[i] << " ";
        }
        std::cout << std::endl;
		// --- Result matrix ---
        std::unordered_map<long int, diagonal*> result_diagonalMap = result->getDiagonalMap();
        // get keys of result_diagonalMap
        std::vector<long int> result_keys;
        std::unordered_map<long int, diagonal*>::iterator result_it;
        for (result_it = result_diagonalMap.begin(); result_it != result_diagonalMap.end(); result_it++) {
            result_keys.push_back(result_it->first);
        }
        // print keys
        std::cout << "keys of result_diagonalMap: ";
        for(long int i = 0; i < result_keys.size(); i++) {
            std::cout << result_keys[i] << " ";
        }
        std::cout << std::endl;
        std::cout << " --- " << std::endl;
        std::cout << " --- product result --- " << std::endl;
        std::cout << " --- " << std::endl;
        result->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\tUnitary multiplication took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return result;

    #endif
}

/**
 * @brief dense matrix multiplication (C = A.B)
 * 
 * @param A denseMatrix
 * @param B denseMatrix
 * 
 * @return denseMatrix  C
 */
denseMatrix *denseProduct(denseMatrix *A, denseMatrix *B) {
    long int *shape_a = A->matrix_shape;
    long int *shape_b = B->matrix_shape;
    if(shape_a[1] != shape_b[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    #if NUM_BYTES_ALIGNED == -1
        valType *real_res = (valType *)calloc(shape_a[0] * shape_b[1], sizeof(valType));
        valType *imag_res = (valType *)calloc(shape_a[0] * shape_b[1], sizeof(valType));
    #else
        valType *real_res = aligned_alloc_helper(shape_a[0] * shape_b[1] * sizeof(valType));
        valType *imag_res = aligned_alloc_helper(shape_a[0] * shape_b[1] * sizeof(valType));
        #pragma omp parallel for
        for(long int i = 0; i < shape_a[0] * shape_b[1]; i++) {
            real_res[i] = 0.0;
            imag_res[i] = 0.0;
        }
    #endif
    long int *d = new long int[2];
    d[0] = A->matrix_shape[0];
    d[1] = B->matrix_shape[1];
    denseMatrix *result = new denseMatrix(&d, real_res, imag_res);
    for(long int i = 0; i < shape_a[0]; i++) {
        for(long int k = 0; k < shape_b[1]; k++) {
            std::complex<valType> res = 0.0;
            for(long int j = 0; j < shape_b[0]; j++) {
                res += A->get(i, j) * B->get(j, k);
            }
            result->set(i, k, res);
        }
    }
    return result;
}

/**
* @brief adds two diaQMatrix matrices (C = A + B)
* @param A diaQMatrix
* @param B diaQMatrix
* @return diaQMatrix C
*/
diagonal *addElements(diagonal *A, diagonal *B) {
    valType *real_valsA = A->realValues;
    valType *imag_valsA = A->imagValues;
    valType *real_valsB = B->realValues;
    valType *imag_valsB = B->imagValues;
    if(A->dLength != B->dLength ) {
        throw std::invalid_argument("diagonals are of different lengths!");
    }
    diagonal *res = new diagonal(A->dIndex, A->dLength);
    valType *real_valsC = res->realValues;
    valType *imag_valsC = res->imagValues;
    #pragma omp parallel for
    for(long int i=0; i < A->dLength; i++) {
        real_valsC[i] = real_valsA[i] + real_valsB[i];
        imag_valsC[i] = imag_valsA[i] + imag_valsB[i];
    }
    return res;
}

diaQMatrix *add(diaQMatrix *A, diaQMatrix *B) {
    if(A->getSize() != B->getSize()) {
        throw std::invalid_argument("input matrices are of different dimensions, not compatible");
    }
    diaQMatrix* result = new diaQMatrix(A->getSize());
    std::unordered_map<long int, diagonal*> mapA = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*> mapB = B->getDiagonalMap();
    #pragma omp paralle for
    for(long int a = 0; a < mapA.size(); a++) {
        auto itA = std::next(mapA.begin(), a);
        auto itB = mapB.find(itA->first);
        if (itB == mapB.end()) {
            result->addDiagonal(itA->first, itA->second);
        } else {
            result->addDiagonal(itA->first, addElements(itA->second, itB->second));
        }
    }
    // result->pruneMatrix();
    return result;
}

std::complex<valType> trace(diaQMatrix *A) {
    std::complex<valType> t = 0;
    std::unordered_map<long int, diagonal*>::iterator itA;
    std::unordered_map<long int, diagonal*> mapA = A->getDiagonalMap();
    itA = mapA.find(0);
    if(itA == mapA.end()) {
        return t;
    }
    for(long int i=0; i < itA->second->dLength; i++) {
        t += itA->second->getValue(i);
    }
    return t;
}

diaQMatrix *matrix_reshape(diaQMatrix *A, long int *matrix_shape) {
    // start time
    auto start = std::chrono::high_resolution_clock::now();

    // this is matrix_reshape.
    // printf("diaq/matrix_reshape called with newshape (%ld, %ld)\n", matrix_shape[0], matrix_shape[1]);
    diaQMatrix *res = new diaQMatrix(&matrix_shape, A->shape);
    std::unordered_map<long int, diagonal*> diagonalMap = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator it;
    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        valType *real_vals = it->second->realValues;
        valType *imag_vals = it->second->imagValues;
        #pragma omp parallel for
        for(long int i = 0; i < it->second->dLength; i++) {
            // old_d_pos has (it->first, i) for A->matrix_shape
            long int *d_pos = res->getDiagonalPositionByFlatIndex(A->getFlatIndex(it->first, i));
            long int d_len = getDiagonalLength(d_pos[0], res->matrix_shape);
            if(real_vals[i] != 0 || imag_vals[i] != 0) { // doing this here to avoid pruning later below.
                res->setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
            }
        }
    }
    return res;
}

diaQMatrix *reshape(diaQMatrix *A, std::vector<long int> new_tensor_shape) {
    long int old_product = 1;
    #pragma unroll
    for(long int i=0; i < A->shape.size(); i++) old_product *= A->shape[i];
    long int new_product = 1;
    #pragma unroll
    for(long int i=0; i < new_tensor_shape.size(); i++) new_product *= new_tensor_shape[i];
    if(old_product != new_product) {
        std::cout << old_product << "!=" << new_product << std::endl;
        throw std::invalid_argument("cannot reshape long into given shape");
    }
    // this is tensor reshape, we can just replace shape and we're good.
    A->shape = new_tensor_shape;
    return A;
}

std::vector<long int> newTensorShape(std::vector<long int> tensor_shape_A, std::vector<long int> tensor_shape_B, std::vector<long int> axis_A, std::vector<long int> axis_B) {
    std::vector<long int> res;
    for(long int i = 0; i < tensor_shape_A.size(); i++) {
        long int notin = 1;
        for(long int p = 0; p < axis_A.size(); p++) {
            if(i == axis_A[p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            res.push_back(tensor_shape_A[i]);
        }
    }
    // std::cout << "axis_B " << axis_B << std::endl;
    for(long int i = 0; i < tensor_shape_B.size(); i++) {
        long int notin = 1;
        for(long int p = 0; p < axis_B.size(); p++) {
            if(i == axis_B[p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            res.push_back(tensor_shape_B[i]);
        }
    }
    return res;
}

long int *newMatrixShape(std::vector<long int> tensorShape) {
    long int product = 1;
    for (long int i = 0; i < tensorShape.size(); i++) {
        product *= tensorShape[i];
    }
    long int sqrtProduct = static_cast<long int>(std::sqrt(product));
    // Find the closest factors of the product
    long int x = 1;
    long int y = product;
    for (long int i = sqrtProduct; i > 0; --i) {
        if (product % i == 0) {
            x = i;
            y = product / i;
            break;
        }
    }
    long int *new_shape = new long int[2];
    new_shape[0] = x;
    new_shape[1] = y;
    return new_shape;
}

std::vector<long int> modifyTensorShape(std::vector<long int> tShape, std::vector<long int> axes) {
    std::vector<long int> nShape;
    int tShapeSize = tShape.size();
    if(axes.size() == 0) {
        nShape.resize(tShape.size(), 1);
        #pragma omp parallel for
        for(long int i = 0; i < tShape.size(); i++) {
            nShape[i] = tShape[tShapeSize - i - 1];
        }
    }
    else {
        nShape.resize(axes.size(), 1);
        #pragma omp parallel for
        for(long int i = 0; i < axes.size(); i++) {
            nShape[i] = tShape[axes[i]];
        }
    }
    return nShape;
}

diaQMatrix *transpose(diaQMatrix *A, std::vector<long int> new_order) {
    // // start timer
    // auto start = std::chrono::high_resolution_clock::now();

    if(new_order.size() == 0) {
        new_order.resize(A->shape.size(), 1);
        #pragma omp parallel for
        for(long int i = 0; i < A->shape.size(); i++) {
            new_order[i] = A->shape.size() - i - 1;
        }
    }
    // std::cout << "diaq/transpose called with axes (";
    // for(long int i = 0; i < new_order.size()-1; i++) {
    //     std::cout << new_order[i] << ",";
    // }
    // std::cout << new_order[new_order.size()-1] << ")" << std::endl;

    // tranpose of the diagonals
    if(A->shape.size() == 2) {
        std::unordered_map<long int, diagonal *> diagMap = A->getDiagonalMap();
        std::unordered_map<long int, diagonal *>::iterator it;
        std::unordered_map<long int, diagonal *> newDiagMap;
        #pragma omp parallel
        {
            #pragma omp single
            for (it = diagMap.begin(); it != diagMap.end(); it++) {
                #pragma omp task
                {
                    it->second->setIndex(-1 * it->first);
                    newDiagMap.insert(std::pair<long int, diagonal *>(-1 * it->first, it->second));
                }
            }
        }
        A->setDiagonalMap(newDiagMap);
        // swap A->shape[0] and A->shape[1] and similarly for matrix_shape.
        long int temp = A->shape[0];
        A->shape[0] = A->shape[1];
        A->shape[1] = temp;
        temp = A->matrix_shape[0];
        A->matrix_shape[0] = A->matrix_shape[1];
        A->matrix_shape[1] = temp;
        return A;
    }
    // otherwise, we have to do a lot of work
    // shape of result
    std::vector<long int> new_tensor_shape = modifyTensorShape(A->shape, new_order);
    // std::cout << "gives new_tensor_shape (";
    // for(long int i = 0; i < new_tensor_shape.size()-1; i++) {
    //     std::cout << new_tensor_shape[i] << ",";
    // }
    // std::cout << new_tensor_shape[new_tensor_shape.size()-1] << ")" << std::endl;
    // now, let's perform the transpose element by element
    long int l = new_tensor_shape.size();
    // this shape is important! decides the length of diagonals! Hence, we have to re-write it to maximize length of diagonals, so that number of diagonls are minimized.
    long int *new_shape = new long int[2];
    new_shape[0] = 1;
    new_shape[1] = 1;
    long int i = l / 2;
    #pragma unroll
    for(long int r = 0; r<i ; r++) {
        new_shape[0] = new_shape[0] * new_tensor_shape[r];
    }
    #pragma unroll
    for(long int r = i; r<l ; r++) {
        new_shape[1] = new_shape[1] * new_tensor_shape[r];
    }
    // std::cout << "new_shape = " << new_shape[0] << "," << new_shape[1] << std::endl;
    // res matrix/tensor
    std::unordered_map<long int, diagonal*> newDiagMap;
    // TODO: allocate for all possible diaognal indices and it's lengths. To paralleize later.
    diaQMatrix *res = new diaQMatrix(newDiagMap, &new_shape, new_tensor_shape);
    // iterate over all diagonals
    std::unordered_map<long int, diagonal*>::iterator it;
    std::unordered_map<long int, diagonal*> diagonalMap = A->getDiagonalMap();

    // #pragma omp parallel for
    // for(long int i = -1 * res->matrix_shape[0]; i < res->matrix_shape[1]; i++) {
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
                for(long int i = 0; i < it->second->dLength; i++) {
                    // std::cout << "(diagonal_idx, diagonal_pos) = (" << it->first << ", " << i << ")" << std::endl;
                    // std::cout << "element = " << vals[i] << std::endl;
                    std::vector<long int> ten_pos = A->getTensorPosition(it->first, i);
                    // std::cout << "tensor index = (";
                    // for(long int i = 0; i < ten_pos.size()-1; i++) {
                    //     std::cout << ten_pos[i] << ",";
                    // }
                    // std::cout << ten_pos[ten_pos.size()-1] << ")" << std::endl;

                    // modify ten_pos to perform the transposition using the new_order
                    std::vector<long int> new_ten_pos(new_order.size(), 1);
                    #pragma omp parallel for
                    for(long int i=0; i < new_order.size(); i++) {
                        new_ten_pos[i] = ten_pos[new_order[i]];
                    }

                    long int *d_pos = res->getDiagonalPosition(new_ten_pos);
                    // std::cout << "(new_diagonal_idx, new_diagonal_pos) = (" << d_pos[0] << ", " << d_pos[1] << ")" << std::endl;
                    long int d_len = getDiagonalLength(d_pos[0], new_shape);
                    if(real_vals[i] != 0.0 || imag_vals[i] != 0.0) { // to avoid pruning later.
                        res->setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
                    }
                    // std::cout << " -- " << std::endl;
                }
            }
        }
    }
    return res;
}

diaQMatrix *transpose(diaQMatrix *A) {
    return transpose(A, std::vector<long int>());
}

diaQMatrix *tensordot1(diaQMatrix *A, diaQMatrix *B, std::vector<std::vector<long int> > axes) {
    // // start timer
    // auto start = std::chrono::high_resolution_clock::now();

    A->balance(); // to make sure x and y dims are balanced in the underlying matrix format
    B->balance(); // to make sure x and y dims are balanced in the underlying matrix format

    std::cout << "--" << std::endl;
    std::cout << "tensordot called for A - " << std::endl;
    A->print_meta();
    std::cout << "and B - " << std::endl;
    B->print_meta();
    std::cout << "with axes - " << " (";
    long int i=0;
    for(i=0; i<axes[0].size()-1; i++)
        std::cout << axes[0][i] << ",";
    std::cout << axes[0][i] << ") and (";
    for(i=0; i<axes[1].size()-1; i++)
        std::cout << axes[1][i] << ",";
    std::cout << axes[1][i] << ")" << std::endl;
    std::cout << "--" << std::endl;

    diaQMatrix *res;
    // move axes
    std::vector<long int> order_A;
    std::vector<long int> order_B;
    #pragma unroll
    for(long int i = 0; i < axes[1].size(); i++)
        order_B.push_back(axes[1][i]);
    for(long int i = 0; i < A->shape.size(); i++) {
        long int notin = 1;
        for(long int p = 0; p < axes[0].size(); p++) {
            if(i == axes[0][p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            order_A.push_back(i);
        }
    }
    for(long int i = 0; i < B->shape.size(); i++) {
        long int notin = 1;
        for(long int p = 0; p < axes[1].size(); p++) {
            if(i == axes[1][p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            order_B.push_back(i);
        }
    }
    #pragma unroll
    for(long int i = 0; i < axes[0].size(); i++)
        order_A.push_back(axes[0][i]);
    // std::cout << "with order_A (";
    // for(long int i = 0; i < order_A.size()-1; i++)
    //     std::cout << order_A[i] << ",";
    // std::cout << order_A[order_A.size()-1] << ")" << std::endl;
    // std::cout << "with order_B (";
    // for(long int i = 0; i < order_B.size()-1; i++)
    //     std::cout << order_B[i] << ",";
    // std::cout << order_B[order_B.size()-1] << ")" << std::endl;

    long int axes_0_product = 1;
    #pragma unroll
    for(long int i=0;i<axes[0].size();i++) axes_0_product *= A->shape[axes[0][i]];
    long int axes_1_product = 1;
    #pragma unroll
    for(long int i=0;i<axes[1].size();i++) axes_1_product *= B->shape[axes[1][i]];

    A = transpose(A, order_A);
    // printf("A after transpose\n");
    // A->print();
    B = transpose(B, order_B);
    // printf("B after transpose\n");
    // B->print();

    long int totalA = A->matrix_shape[0] * A->matrix_shape[1];
    long int totalB = B->matrix_shape[0] * B->matrix_shape[1];

    // std::cout << "axes_0_product = " << axes_0_product << " axes_1_product = " << axes_1_product << std::endl;
    // These have to be equal right? Let's add a check
    if(axes_1_product != axes_0_product) {
        std::cout << "axes_1_product != axes_0_product i.e. " << axes_1_product << " != " << axes_0_product << std::endl;
        throw std::invalid_argument("invalid axes, can't perform tensordot");
    }

    long int *new_shape_a = new long int[2] {totalA / axes_0_product, axes_0_product};
    long int *new_shape_b = new long int[2] {axes_1_product, totalB / axes_1_product};

    // std::vector<long int> new_shape_a{totalA / axes_0_product, axes_0_product};
    // std::vector<long int> new_shape_b{axes_1_product, totalB / axes_1_product};

    diaQMatrix *reshaped_A = matrix_reshape(A, new_shape_a);
    diaQMatrix *reshaped_B = matrix_reshape(B, new_shape_b);

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

long int *getMatrixShape(std::vector<long int> tensor_shape) {
    // print tensor_shape
    // printf("tensor_shape = (");
    // for (long int i = 0; i < tensor_shape.size() - 1; i++) {
    //     printf("%ld, ", tensor_shape[i]);
    // }
    // printf("%ld)\n", tensor_shape[tensor_shape.size() - 1]);
    // Calculate the product of the tensor shape
    long int product = 1;
    for (long int i = 0; i < tensor_shape.size(); i++) {
        product *= tensor_shape[i];
    }
    long int sqrtProduct = static_cast<long int>(std::sqrt(product));
    // Find the closest factors of the product
    long int x = 1;
    long int y = product;
    for (long int i = sqrtProduct; i > 0; --i) {
        if (product % i == 0) {
            x = i;
            y = product / i;
            break;
        }
    }
    long int *new_shape = new long int[2];
    new_shape[0] = y;
    new_shape[1] = x;
    // printf("new_shape = (%ld, %ld)\n", new_shape[0], new_shape[1]);
    return new_shape;
}

std::vector<long int> getTenPos(const std::vector<long int>& ten_pos_A,
                                     const std::vector<long int>& ten_pos_B,
                                     const std::vector<long int>& axes_A,
                                     const std::vector<long int>& axes_B,
                                     const std::vector<long int>& shape_A,
                                     const std::vector<long int>& shape_B) {
    std::vector<long int> res;
    for (long int i = 0; i < ten_pos_A.size(); i++) {
        long int notin = 1;
        for (long int p = 0; p < axes_A.size(); p++) {
            if (i == axes_A[p]) {
                notin = 0;
                break;
            }
        }
        if (notin) {
            res.push_back(ten_pos_A[i]);
        }
    }
    for (long int i = 0; i < ten_pos_B.size(); i++) {
        long int notin = 1;
        for (long int p = 0; p < axes_B.size(); p++) {
            if (i == axes_B[p]) {
                notin = 0;
                break;
            }
        }
        if (notin) {
            res.push_back(ten_pos_B[i]);
        }
    }
    return res;
}

diaQMatrix *tensordot(diaQMatrix *A, diaQMatrix *B, std::vector<std::vector<long int> > axes) {
    // start timer
    // auto start = std::chrono::high_resolution_clock::now();

    // std::cout << "--" << std::endl;
    // std::cout << "tensordot called for A - " << std::endl;
    // A->print_meta();
    // std::cout << "and B - " << std::endl;
    // B->print_meta();
    // std::cout << "with axes - " << " (";
    // long int i=0;
    // for(i=0; i<axes[0].size()-1; i++)
    //     std::cout << axes[0][i] << ",";
    // std::cout << axes[0][i] << ") and (";
    // for(i=0; i<axes[1].size()-1; i++)
    //     std::cout << axes[1][i] << ",";
    // std::cout << axes[1][i] << ")" << std::endl;
    // std::cout << "--" << std::endl;

    // let's try element by element like we do with tensor transpose!
    std::vector<long int> new_tensor_shape = newTensorShape(A->shape, B->shape, axes[0], axes[1]);
    long int *new_matrix_shape = getMatrixShape(new_tensor_shape);
    diaQMatrix *res = new diaQMatrix(&new_matrix_shape, new_tensor_shape);
    // printf("res matrix shape\n");
    // res->print_shape();

    // element by element tensordot multiplication, inspired from COO format
    std::unordered_map<long int, diagonal*> mapA = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*> mapB = B->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator itA, itB;
    #pragma omp parallel
    {
        #pragma omp single
        {
            for (itA = mapA.begin(); itA != mapA.end(); itA++) {
                #pragma omp task
                {
                    diagonal *diagA = itA->second;
                    valType *real_vals_A = diagA->realValues;
                    valType *imag_vals_A = diagA->imagValues;
                    // #pragma omp parallel for
                    for(long int diagA_pos = 0; diagA_pos < diagA->dLength; diagA_pos++) {
                        std::vector<long int> ten_pos_A = A->getTensorPosition(itA->first, diagA_pos);
                        // #pragma omp single
                        // {
                            for (itB = mapB.begin(); itB != mapB.end(); itB++) {
                                #pragma omp task
                                {
                                    diagonal *diagB = itB->second;
                                    valType *real_vals_B = diagB->realValues;
                                    valType *imag_vals_B = diagB->imagValues;
                                    #pragma omp parallel for
                                    for(long int diagB_pos = 0; diagB_pos < diagB->dLength; diagB_pos++) {
                                        std::vector<long int> ten_pos_B = B->getTensorPosition(itB->first, diagB_pos);
                                        // if the common axes
                                        if (ten_pos_A[axes[0][0]] == ten_pos_B[axes[1][0]]) {
                                            // print ten_pos_A and ten_pos_B
                                            // printf("ten_pos_A = (");
                                            // for (long int i = 0; i < ten_pos_A.size() - 1; i++) {
                                            //     printf("%ld, ", ten_pos_A[i]);
                                            // }
                                            // printf("%ld)\n", ten_pos_A[ten_pos_A.size() - 1]);
                                            // printf("ten_pos_B = (");
                                            // for (long int i = 0; i < ten_pos_B.size() - 1; i++) {
                                            //     printf("%ld, ", ten_pos_B[i]);
                                            // }
                                            // printf("%ld)\n", ten_pos_B[ten_pos_B.size() - 1]);
                                            // Calculate resulting coordinates after contraction
                                            std::vector<long int> result_coords = getTenPos(ten_pos_A, ten_pos_B, axes[0], axes[1], A->shape, B->shape);
                                            // printing result_coords
                                            // printf("result_coords = (");
                                            // for (long int i = 0; i < result_coords.size() - 1; i++) {
                                            //     printf("%ld, ", result_coords[i]);
                                            // }
                                            // printf("%ld)\n", result_coords[result_coords.size() - 1]);

                                            // get the diagonal position and length
                                            long int *res_diag_pos = res->getDiagonalPosition(result_coords);
                                            long int res_diag_len = res->getDiagonalLength(res_diag_pos[0]);
                                            valType real_val = real_vals_A[diagA_pos] * real_vals_B[diagB_pos] - imag_vals_A[diagA_pos] * imag_vals_B[diagB_pos];
                                            valType imag_val = real_vals_A[diagA_pos] * imag_vals_B[diagB_pos] + imag_vals_A[diagA_pos] * real_vals_B[diagB_pos];
                                            if(real_val != 0.0 || imag_val != 0.0) { // to avoid pruning later.
                                                valType new_real_val = res->getItem_real(res_diag_pos[0], res_diag_pos[1]) + real_val;
                                                valType new_imag_val = res->getItem_imag(res_diag_pos[0], res_diag_pos[1]) + imag_val;
                                                res->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], res_diag_len, new_real_val, new_imag_val);
                                            }
                                            std::free(res_diag_pos);
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

    return res;
}

diaQMatrix *array(diaQMatrix *A) {
    // std::cout << "array called for A - " << std::endl;
    // A.print();
    // TODO: unclear as of now what this mehthod should be doing
    return A;
}

diaQMatrix *einsum(diaQMatrix *A, std::vector<long int> axes) {
    std::cout << axes[0] << std::endl;
    return A;
}

// overloading operators
diaQMatrix *operator*(diaQMatrix &A, diaQMatrix &B) {
    return product(&A, &B);
}
diaQMatrix *operator+(diaQMatrix &A, diaQMatrix &B) {
    return add(&A, &B);
}

void diaQMatrix::matrix_reshape(long int *matrix_shape) {
    // printf("self reshape called with newshape (%ld, %ld)\n", matrix_shape[0], matrix_shape[1]);
    diaQMatrix *temp = diaq::matrix_reshape(this, matrix_shape);
    *this = *temp;
    delete temp;
}

diaQMatrix *diaQMatrix::reshape(std::vector<long int> new_tensor_shape) {
    return diaq::reshape(this, new_tensor_shape);
}

void diaQMatrix::transpose(std::vector<long int> new_order) {
    diaQMatrix *temp = diaq::transpose(this, new_order);
    *this = *temp;
    delete temp;
}

void diaQMatrix::transpose() {
    diaQMatrix *temp = diaq::transpose(this);
    *this = *temp;
    delete temp;
}

vector *spMV(diaQMatrix *A, vector *x, vector *y) {
    #ifdef CUDA_ENABLED
        return spmv_cuda(A, x);
    #else
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- spMV --- " << std::endl;
        std::cout << " --- " << std::endl;
        A->print();
        std::cout << " --- times --- " << std::endl;
        x->print();
        std::cout << " --- " << std::endl;
        printf("Analyzing SpM\n");
        A->print_meta();
        printf("Analyzing V\n");
        x->print_meta();
        printf("Analyzing Y\n");
        y->print_meta();
    #endif

    #ifdef DEBUG
        // measure start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    // if(A->matrix_shape[1] != x->num_rows()) {
    //     throw std::invalid_argument("Not multiplyable");
    // }

    // vector *y = new vector(A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;
    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for
    for (size_t a = 0; a < diagMap.size(); ++a) {
        auto it = std::next(diagMap.begin(), a);
        long int dIndex = it->first;
        long int dLength = it->second->dLength;
        valType *real_vals = it->second->realValues;
        valType *imag_vals = it->second->imagValues;

        if(dIndex < 0) { // negative diagonals
            #pragma omp critical
            {
                // printf("Negative diagonal!!\n");
                #if VECTORIZATION_TYPE == 1
                    #ifdef __AVX512F__
                        run_spmv_avx512_1(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                    #elif defined(__AVX__)
                        run_spmv_avx_1(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                    #endif
                #elif VECTORIZATION_TYPE == 0
                    run_spmv_sse_1(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #else // run without vectorization
                    #pragma omp simd
                    for (long int i = 0; i < dLength; i++) {
                        long int x_idx = i;
                        long int y_idx = i - dIndex;
                        y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                    }
                #endif
            }
        }

        else if(dIndex > 0) { // positive diagonals
            #pragma omp critical
            {
                // printf("Positive diagonal!!\n");
                #if VECTORIZATION_TYPE == 1
                    #ifdef __AVX512F__
                        run_spmv_avx512_2(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                    #elif defined(__AVX__)
                        run_spmv_avx_2(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                    #endif
                #elif VECTORIZATION_TYPE == 0
                    run_spmv_sse_2(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #else // run without vectorization
                    #pragma omp simd
                    for (long int i = 0; i < dLength; i++) {
                        long int x_idx = dIndex + i;
                        long int y_idx = i;
                        y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                    }
                #endif
            }
        }

        else {
            // 0th diagonal
            #pragma omp critical
            {
                // printf("Zero diagonal!!\n");
                #if VECTORIZATION_TYPE == 1
                    #ifdef __AVX512F__
                        run_spmv_avx512_0(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                    #elif defined(__AVX__)
                        run_spmv_avx_0(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                    #endif
                #elif VECTORIZATION_TYPE == 0
                    run_spmv_sse_0(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #else // run without vectorization
                    #pragma omp simd
                    for (long int i = 0; i < dLength; i++) {
                        y_real_values[i] += real_vals[i] * x_real_values[i] - imag_vals[i] * x_imag_values[i];
                        y_imag_values[i] += real_vals[i] * x_imag_values[i] + imag_vals[i] * x_real_values[i];
                    }
                #endif
            }
        }
    }

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- spMV result --- " << std::endl;
        std::cout << " --- " << std::endl;
        y->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t spMV took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return y;

    #endif
}

vector *spMV(diaQMatrix *A, vector *x, vector *y, long int qubit_smaller, long int qubit_larger) {

    // DID NOT IMPLEMENT YET!
    // TODO: PLS IMPLEMENT!!

    #ifdef DEBUG
        // measure start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    long int *new_gate_shape = new long int[2] {q_diff_exp, q_diff_exp};

    if(A->matrix_shape[1] != x->numRows) {
        throw std::invalid_argument("Not multiplyable");
    }
    // vector *y = new vector(A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;
    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel
    {
        #pragma omp single
        {
            for (it = diagMap.begin(); it != diagMap.end(); it++) {
                #pragma omp task
                {
                    diagonal *diag = it->second;
                    valType *real_vals = diag->realValues;
                    valType *imag_vals = diag->imagValues;
                    switch(diag->dIndex) {
                        case -3: {
                            long int dIndex = -1 * q_diff_exp - 1;
                            long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case -2: {
                            long int dIndex = -1 * q_diff_exp;
                            long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case -1: {
                            long int dIndex = -1;
                            long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            // something
                            dIndex = -1 * q_diff_exp + 1;
                            dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 0: {
                            long int dIndex = 0;
                            long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 1: {
                            long int dIndex = 1;
                            long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            // do something
                            dIndex = q_diff_exp - 1;
                            dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 2: {
                            long int dIndex = q_diff_exp;
                            long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 3: {
                            long int dIndex = q_diff_exp + 1;
                            long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                    }
                }
            }
        }
    }

    free(new_gate_shape);

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t (non-adjacent) spMV took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return y;
}

vector *MV(denseMatrix *A, vector *x, vector *y) {
    if(A->matrix_shape[1] != x->numRows) {
        throw std::invalid_argument("Not multiplyable");
    }
    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;
    // vector *y = new vector(A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;
    for(long int i = 0; i < A->matrix_shape[0]; i++) {
        valType res_real = 0.0;
        valType res_imag = 0.0;
        for(long int j = 0; j < A->matrix_shape[1]; j++) {
            std::complex<valType> elem = A->get(i, j);
            res_real += elem.real() * x_real_values[j] - elem.imag() * x_imag_values[j];
            res_imag += elem.real() * x_imag_values[j] + elem.imag() * x_real_values[j];
        }
        y_real_values[i] = res_real;
        y_imag_values[i] = res_imag;
    }
    return y;
}

denseMatrix *dense_kron_product(denseMatrix *A, denseMatrix *B) {
    // A: m x n
    // B: p x q
    // C: mp x nq

    long int *shape_a = A->matrix_shape;
    long int *shape_b = B->matrix_shape;

    // Calculate dimensions for the resulting matrix
    long int *d = (long int *)calloc(2, sizeof(long int));
    d[0] = shape_a[0] * shape_b[0];
    d[1] = shape_a[1] * shape_b[1];
    #if NUM_BYTES_ALIGNED == -1
        valType *real_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
        valType *imag_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
    #else
        valType *real_res = aligned_alloc_helper(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1] * sizeof(valType));
        valType *imag_res = aligned_alloc_helper(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1] * sizeof(valType));
        #pragma omp parallel for
        for(long int i = 0; i < shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1]; i++) {
            real_res[i] = 0.0;
            imag_res[i] = 0.0;
        }
    #endif
    denseMatrix *result = new denseMatrix(&d, real_res, imag_res);

    // Iterate through the rows of matrix A
    for (long int i = 0; i < A->matrix_shape[0]; i++) {

        // Iterate through the columns of matrix A
        for (long int j = 0; j < A->matrix_shape[1]; j++) {

            // Iterate through the rows of matrix B
            for (long int k = 0; k < B->matrix_shape[0]; k++) {

                // Iterate through the columns of matrix B
                for (long int l = 0; l < B->matrix_shape[1]; l++) {

                    // Calculate the resulting indices in the new matrix
                    long int newIndexI = i * B->matrix_shape[0] + k;
                    long int newIndexJ = j * B->matrix_shape[1] + l;

                    // Multiply the element of A by the element of B
                    std::complex<valType> newElement = A->get(i, j) * B->get(k, l);

                    // Add the resulting element to the appropriate position in the result denseMatrix
                    result->set(newIndexI, newIndexJ, newElement);
                }
            }
        }
    }
    return result;
}

diaQMatrix *multiply_by_scalar(diaQMatrix *A, valType scalar_real, valType scalar_imag) {
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- multiply_by_scalar --- " << std::endl;
        std::cout << " --- " << std::endl;
        std::cout << "scalar_real = " << scalar_real << "; scalar_imag = " << scalar_imag << std::endl;
        std::cout << " --- times --- " << std::endl;
        A->print();
        std::cout << " --- " << std::endl;
    #endif

    if (scalar_real == 1.0 && scalar_imag == 0.0) {
        return A; // since we are not changing A, we should be ok returning it for now :( To-Do: think of a cleaner way to do this.
    }

    diaQMatrix *result = new diaQMatrix((long int)0);

    if (scalar_real == 0.0 && scalar_imag == 0.0) {
        return result;
    }

    result->matrix_shape = A->matrix_shape;
    result->shape = A->shape;

    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for
    for (size_t a = 0; a < A->diagonalMap.size(); ++a) {
        auto it = std::next(A->diagonalMap.begin(), a);
        long int dIndex = it->first;
        long int dLength = it->second->dLength;
        valType *real_vals = it->second->realValues;
        valType *imag_vals = it->second->imagValues;
        diagonal *newDiag = new diagonal(dIndex, dLength);
        valType *real_valsC = newDiag->realValues;
        valType *imag_valsC = newDiag->imagValues;

        #pragma omp simd
        for (long int i = 0; i < dLength; i++) {
            real_valsC[i] = real_vals[i] * scalar_real - imag_vals[i] * scalar_imag;
            imag_valsC[i] = real_vals[i] * scalar_imag + imag_vals[i] * scalar_real;
        }
        
        result->setDiagonal(dIndex, newDiag);
    }

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- multiply_by_scalar result --- " << std::endl;
        std::cout << " --- " << std::endl;
        result->print();
        std::cout << " --- " << std::endl;
    #endif

    return result;
}

diaQMatrix *kron_product(diaQMatrix *A, diaQMatrix *B) {

    #ifdef DEEP_DEBUG
        printf("\tdiaq::kron_product\n");
        printf("\tA Meta:\n");
        A->print_meta();
        printf("\tB Matrix:\n");
        B->print_meta();
    #endif

    #ifdef DEBUG
        // measure start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int *shape_a = A->matrix_shape;
    long int *shape_b = B->matrix_shape;

    // map of unique A elements and their corresponding kron blocks
    std::map<std::pair<valType, valType>, diaQMatrix *> unique_kron_blocks;

    // Calculate dimensions for the resulting matrix
    long int *result_shape = new long int[2];
    result_shape[0] = shape_a[0] * shape_b[0];
    result_shape[1] = shape_a[1] * shape_b[1];
    diaQMatrix *result = new diaQMatrix(&result_shape);

    std::unordered_map<long int, diagonal*>::iterator itA;

    #pragma omp parallel for
    for (long int a = 0; a < A->diagonalMap.size(); a++) {
        auto itA = std::next(A->diagonalMap.begin(), a);
        long int diagonal_index = itA->first;
        diagonal *diag = itA->second;
        long int diagonal_length = diag->dLength;

        #pragma omp parallel for
        for(long int diagonal_position = 0; diagonal_position < diagonal_length; diagonal_position++) {
            // skippihg zero elements
            if(diag->realValues[diagonal_position] == 0.0 && diag->imagValues[diagonal_position] == 0.0) {
                continue;
            }
            diaQMatrix *kron_block;
            // dynamic programming for unique kron blocks
            #pragma omp critical
            {
                if(unique_kron_blocks.find(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position])) == unique_kron_blocks.end()) {
                    kron_block = multiply_by_scalar(B, diag->realValues[diagonal_position], diag->imagValues[diagonal_position]);
                    unique_kron_blocks.insert(std::pair<std::pair<valType, valType>, diaQMatrix *>(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]), kron_block));
                } else {
                    kron_block = unique_kron_blocks.find(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]))->second;
                }
            }

            long int *A_pos = A->getMatrixPosition(diagonal_index, diagonal_position);
            std::unordered_map<long int, diagonal*>::iterator itK;

            #pragma omp parallel for
            for (long int b = 0; b < kron_block->diagonalMap.size(); b++) {
                auto itK = std::next(kron_block->diagonalMap.begin(), b);
                long int kron_block_diag_index = itK->first;
                diagonal *kron_block_diag = itK->second;
                long int kron_block_diag_length = kron_block_diag->dLength;

                #pragma omp parallel for
                for(long int kron_block_diag_position = 0; kron_block_diag_position < kron_block_diag_length; kron_block_diag_position++) {

                    long int *B_mat_pos = kron_block->getMatrixPosition(kron_block_diag_index, kron_block_diag_position);
                    long int res_mat_pos[2] = {A_pos[0] * shape_b[0] + B_mat_pos[0], A_pos[1] * shape_b[1] + B_mat_pos[1]};
                    long int *res_diag_pos = result->getDiagonalPosition(res_mat_pos);

                    #pragma omp critical
                    {
                        result->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], result->getDiagonalLength(res_diag_pos[0]), kron_block_diag->realValues[kron_block_diag_position], kron_block_diag->imagValues[kron_block_diag_position]);
                    }

                    delete[] B_mat_pos;
                    delete[] res_diag_pos;
                }
            }
            delete[] A_pos;
        }
    }

    // free unique_kron_blocks
    #pragma omp parallel for
    for (long int a = 0; a < unique_kron_blocks.size(); a++) {
        auto it = std::next(unique_kron_blocks.begin(), a);
        it->second->free();
    }

    #ifdef DEEP_DEBUG
        printf("\tkron_product Result Meta:\n");
        result->print_meta();
    #endif


    #ifdef DEBUG
        // measure end timer
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t kron_product took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return result;
}

diaQMatrix *identity_kron_matrix(long int n, diaQMatrix *A) {

    #ifdef DEEP_DEBUG
        printf("\tdiaq::identity_kron_matrix\n");
        printf("\tA Meta:\n");
        A->print_meta();
    #endif

    #ifdef DEBUG
        // measure start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int N = 1L << n;

    // assume a nxn identity matrix, which has one diagonal of length N, in index 0.
    // we just repeat A, N times in the result matrix
    long int *result_shape = new long int[2] {N * A->matrix_shape[0], N * A->matrix_shape[1]};
    diaQMatrix *result = new diaQMatrix(&result_shape);
    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for
    for (long int i = 0; i < diagMap.size(); i++) {
        auto it = std::next(diagMap.begin(), i);
        long int dIndex = it->first;
        diagonal *diag = it->second;
        // printf("A's diagonal\n");
        // diag->print();
        long int dLength = diag->dLength;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        // result diag
        long int new_dLength = result->getDiagonalLength(dIndex); // TODO: there should be a better way to get this using n and dLength.
        diagonal *newDiag = new diagonal(dIndex, new_dLength);
        valType *newDiag_real_vals = newDiag->realValues;
        valType *newDiag_imag_vals = newDiag->imagValues;

        #pragma omp parallel for
        for(long int rep = 0; rep < N; rep++) {
            long int skip_places = (rep) * (dLength + abs(dIndex));
            #pragma omp parallel for
            for(long int i = 0; i < dLength; i++) {
                newDiag_real_vals[i + skip_places] = real_vals[i];
                newDiag_imag_vals[i + skip_places] = imag_vals[i];
            }
        }
        #pragma omp critical
        result->setDiagonal(dIndex, newDiag);
    }

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix took %f milliseconds\n", duration.count()/1000.0);
    #endif

    A->free();

    return result;
}

void identity_kron_matrix_times_vector(long int n, diaQMatrix *A, vector *x, vector *y) {

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int N = 1L << n;

    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    long long int y_len = y->numRows; // same as x->numRows;
    long int A_size = A->matrix_shape[0];

    // I kron A has the same number of diagonals as A, but each diagonal has N times more G elements and more 0s that we don't need to care about.
    // So, we can just iterate through the diagonals of A and repeat each diagonal N times in the result vector. But offsets are important and different for each iteration, since each is essentially a block!
    // now for each diagonal in A
    // index in y and x goes from (0, block_idx * diag_length)

    long int last_y_offset = (N-1) * A_size;

    #pragma omp parallel for
    for(long int y_offset = 0; y_offset <= last_y_offset; y_offset += A_size) { // this is like traversing blocks in I kron A

        for (long int di = 0; di < diagMap.size(); di++) {
            auto it = std::next(diagMap.begin(), di);
            // now we can do element wise!
            long int dIndex = it->first;
            diagonal *diag = it->second;
            long int dLength = diag->dLength;
            valType *real_vals = diag->realValues;
            valType *imag_vals = diag->imagValues;

            long int x_inner_offset = (dIndex > 0) ? dIndex : 0;
            long int y_inner_offset = (dIndex < 0) ? -dIndex : 0;

            long int x_offset = y_offset + x_inner_offset;
            long int new_y_offset = y_offset + y_inner_offset;

            #pragma omp parallel for
            for (long int y_idx = new_y_offset; y_idx < dLength + new_y_offset; y_idx++) {
                long int x_idx = x_offset + (y_idx - new_y_offset); // adjust x_idx for each iteration
                long int i = y_idx - new_y_offset; // if you want to match your original i loop
                #pragma omp atomic
                y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                #pragma omp atomic
                y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif
}


void identity_kron_matrix_times_vector(long int n, diaQMatrix *A, vector *x, vector *y, long int qubit_smaller, long int qubit_larger) {

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    n = 1L << n;

    long int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    long int *new_gate_shape = new long int[2] {q_diff_exp, q_diff_exp};

    // vector *y = new vector(n * A->matrix_shape[0]);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        diagonal *diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        switch(diag->dIndex) {
            case -3: {
                long int dIndex = -1 * q_diff_exp - 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < n; rep++) {
                    long int skip_places = rep * (dLength - dIndex);
                    #pragma omp simd
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            long int x_idx = i + skip_places;
                            long int y_idx = i + skip_places - dIndex;
                            y_real_values[y_idx] += real_vals[0] * x_real_values[x_idx] - imag_vals[0] * x_imag_values[x_idx];
                            y_imag_values[y_idx] += real_vals[0] * x_imag_values[x_idx] + imag_vals[0] * x_real_values[x_idx];
                        }
                    }
                }
                break;
            }
            case -2: {
                long int dIndex = -1 * q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < n; rep++) {
                    long int skip_places = rep * (dLength - dIndex);
                    #pragma omp simd
                    for(long int i = 0; i < dLength/2; i++) {
                        long int x_idx = i + skip_places;
                        long int y_idx = i + skip_places - dIndex;
                        y_real_values[y_idx] += real_vals[0] * x_real_values[x_idx] - imag_vals[0] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[0] * x_imag_values[x_idx] + imag_vals[0] * x_real_values[x_idx];

                        x_idx = i + skip_places + 1;
                        y_idx = i + skip_places - dIndex + 1;
                        y_real_values[y_idx] += real_vals[1] * x_real_values[x_idx] - imag_vals[1] * x_imag_values[x_idx];
                        y_imag_values[y_idx] += real_vals[1] * x_imag_values[x_idx] + imag_vals[1] * x_real_values[x_idx];

                    }
                }
                break;
            }
            case -1: {
                long int dIndex = -1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // something
                dIndex = -1 * q_diff_exp + 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 0: {
                long int dIndex = 0;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 1: {
                long int dIndex = 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                dIndex = q_diff_exp - 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 2: {
                long int dIndex = q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 3: {
                long int dIndex = q_diff_exp + 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
        }
    }

    free(new_gate_shape);

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t (non-adjacent) identity_kron_matrix_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void identity_kron_matrix_kron_identity_times_vector(long int before, diaQMatrix *gate, long int after, vector *x, vector *y) {
    // logically combine matrix_kron_identity and identity_kron_matrix_times_vector

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        std::cout << "identity_kron_matrix_kron_identity_times_vector called" << std::endl;
        printf("gate matrix below\n");
        gate->print();
        printf("\t\tbefore = %ld; after = %ld\n", before, after);
    #endif

    long int before_N = 1L << before;
    long int after_N = 1L << after;

    long int x_length = x->numRows;

    // if(after * before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // vector *y = new vector(after * before * gate->matrix_shape[0]);
    // y->print();
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;
    // PRINT_WITH_LINE("here\n");

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    std::unordered_map<long int, diagonal*> diagMap = gate->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for collapse(2)
    for (long int rep = 0; rep < before_N; rep++) {
        for (long int j = 0; j < after_N; j++) {
            for (long int a = 0; a < diagMap.size(); a++) {
                auto it = std::next(diagMap.begin(), a);
                long int dIndex = it->first;
                diagonal *diag = it->second;
                long int dLength = diag->dLength;
                valType *real_vals = diag->realValues;
                valType *imag_vals = diag->imagValues;

                long int skip_places = rep * (after_N * (dLength + (dIndex < 0 ? -dIndex : dIndex)));
                long int x_offset = (dIndex < 0 ? skip_places : after_N * dIndex + skip_places);
                long int y_offset = (dIndex < 0 ? skip_places - after_N * dIndex : skip_places);

                #pragma omp simd
                for (long int i = 0; i < dLength; i++) {
                    long int x_idx = x_offset + i * after_N + j;
                    long int y_idx = y_offset + i * after_N + j;
                    y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
                    y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
                }
            }
        }
    }

    #ifdef DEBUG
        // // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t identity_kron_matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void identity_kron_matrix_kron_identity_times_vector(long int before, diaQMatrix *gate, long int after, vector *x, vector *y, long int qubit_smaller, long int qubit_larger) {

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    after = 1L << after;
    before = 1L << before;

    long int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    long int *new_gate_shape = new long int[2] {q_diff_exp, q_diff_exp};

    long int x_length = x->numRows;

    // if(after * before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // vector *y = new vector(after * before * gate->matrix_shape[0]);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    std::unordered_map<long int, diagonal*> diagMap = gate->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for
    for (long int a = 0; a < diagMap.size(); a++) {
        auto it = std::next(diagMap.begin(), a);
        diagonal *diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        switch(diag->dIndex) {
            case -3: {
                long int dIndex = -1 * q_diff_exp - 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            case -2: {
                long int dIndex = -1 * q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i += 2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[1];
                        imag_val = imag_vals[1];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case -1: {
                long int dIndex = -1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength/2; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                    for(long int i = dLength/2; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[2];
                            valType imag_val = imag_vals[2];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                dIndex = -1 * q_diff_exp + 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 != 0) {
                            valType real_val = real_vals[1];
                            valType imag_val = imag_vals[1];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            case 0: {
                long int dIndex = 0;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength/2; i+=2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[1];
                        imag_val = imag_vals[1];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                    for(long int i = dLength/2; i < dLength; i+=2) {
                        valType real_val = real_vals[2];
                        valType imag_val = imag_vals[2];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[3];
                        imag_val = imag_vals[3];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 1: {
                long int dIndex = 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength/2; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        // printf("y_real_values[%ld] = %f\n", y_idx, y_real_values[y_idx]);
                                        // printf("y_imag_values[%ld] = %f\n", y_idx, y_imag_values[y_idx]);
                                        // printf("x_real_values[%ld] = %f\n", x_idx, x_real_values[x_idx]);
                                        // printf("x_imag_values[%ld] = %f\n", x_idx, x_imag_values[x_idx]);
                                        // printf("real_val = %f\n", real_val);
                                        // printf("imag_val = %f\n", imag_val);
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                    for(long int i = dLength/2; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[2];
                            valType imag_val = imag_vals[2];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                dIndex = q_diff_exp - 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 != 0) {
                            valType real_val = real_vals[1];
                            valType imag_val = imag_vals[1];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            case 2: {
                long int dIndex = q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i += 2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                        real_val = real_vals[1];
                        imag_val = imag_vals[1];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < before; j++) {
                                long int x_idx = j + i * after + skip_places;
                                long int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 3: {
                long int dIndex = q_diff_exp + 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(long int rep = 0; rep < before; rep++) {
                    long int skip_places = rep * (after * (dLength - dIndex));
                    for(long int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(long int j = 0; j < before; j++) {
                                    long int x_idx = j + i * after + skip_places;
                                    long int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                }
                break;
            }
            default: {
                break;
            }
        }

    }
    
    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t (non-adjacent) identity_kron_matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void matrix_kron_identity_times_vector(diaQMatrix *A, long n, vector *x, vector *y) {
    // logically combine matrix_kron_identity and spMV

    #ifdef DEBUG
        //start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        printf("matrix_kron_identity_times_vector called\n");
        printf("A matrix below\n");
        A->print();
        printf("\t\n = %ld\n", n);
    #endif

    long int N = 1L << n;

    long int x_length = x->numRows;

    // if(before * A->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // vector *y = new vector(before * A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    // (A kron I) times x = y
    #pragma omp parallel for collapse(2)
    for (long int j = 0; j < N; j++) {
        for (long int a = 0; a < diagMap.size(); a++) {
            auto it = std::next(diagMap.begin(), a);
            diagonal *diag = it->second;
            valType *real_vals = diag->realValues;
            valType *imag_vals = diag->imagValues;
            long int dIndex = it->first;
            long int dLength = diag->dLength;
            for (long int i = 0; i < dLength; i++) {
                valType real_i = real_vals[i];
                valType imag_i = imag_vals[i];
                // we can skip 0s
                if(real_i == 0 && imag_i == 0) {
                    continue;
                }
                // each element kinda becomes an I block (scalar val at i times I block), we don't need a multiplication op here at all, instead we can cover over values of A, N times as 1 times something is just something.
                long int y_offset = i * N;
                long int x_offset = i * N;
                long int new_dIndex = dIndex * N;
                if(dIndex > 0) {
                    x_offset += new_dIndex;
                }
                else if(dIndex < 0) {
                    y_offset -= new_dIndex;
                }
                #pragma omp atomic
                y_real_values[j + y_offset] += real_i * x_real_values[j + x_offset] - imag_i * x_imag_values[j + x_offset];
                #pragma omp atomic
                y_imag_values[j + y_offset] += real_i * x_imag_values[j + x_offset] + imag_i * x_real_values[j + x_offset];
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

    #ifdef DEEP_DEBUG
        printf("matrix_kron_identity_times_vector done\n");
        printf("y vector below\n");
        y->print();
    #endif

}

void matrix_kron_identity_times_vector(diaQMatrix *gate, long after, vector *x, vector *y, long int qubit_smaller, long int qubit_larger) {
    // logically combine matrix_kron_identity and spMV

    #ifdef DEBUG
        //start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    after = 1L << after;

    long int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    long int *new_gate_shape = new long int[2] {q_diff_exp, q_diff_exp};

    long int x_length = x->numRows;

    // if(before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // vector *y = new vector(before * gate->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    std::unordered_map<long int, diagonal*> diagMap = gate->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for
    for (long int a = 0; a < diagMap.size(); a++) {
        auto it = std::next(diagMap.begin(), a);
        diagonal *diag = it->second;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        switch(diag->dIndex) {
            case -3: {
                long int dIndex = -1 * q_diff_exp - 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case -2: {
                long int dIndex = -1 * q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] += %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[1];
                    each_imag = imag_vals[1];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                break;
            }
            case -1: {
                long int dIndex = -1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength/2; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                for(long int i = dLength/2; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[2];
                        valType each_imag = imag_vals[2];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                dIndex = -1 * q_diff_exp + 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i++) {
                    if( i% 2 != 0) {
                        valType each_real = real_vals[1];
                        valType each_imag = imag_vals[1];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 0: {
                long int dIndex = 0;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength/2; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[1];
                    each_imag = imag_vals[1];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                for(long int i = dLength/2; i < dLength; i+=2) {
                    valType each_real = real_vals[2];
                    valType each_imag = imag_vals[2];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[3];
                    each_imag = imag_vals[3];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                break;
            }
            case 1: {
                long int dIndex = 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength/2; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                for(long int i = dLength/2; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[2];
                        valType each_imag = imag_vals[2];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                dIndex = q_diff_exp - 1;
                dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i++) {
                    if( i% 2 != 0) {
                        valType each_real = real_vals[1];
                        valType each_imag = imag_vals[1];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
            case 2: {
                long int dIndex = q_diff_exp;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                    each_real = real_vals[1];
                    each_imag = imag_vals[1];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(long int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            long int x_idx, y_idx;
                            if(dIndex < 0) { // negative diagonals
                                x_idx = j + i * after;
                                y_idx = j + i * after - after * dIndex;
                            }
                            else if (dIndex > 0) { // positive diagonals
                                x_idx = after * dIndex + j + i * after;
                                y_idx = j + i * after;
                            }
                            else { // principal diagonal
                                x_idx = j + i * after;
                                y_idx = j + i * after;
                            }
                            // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                            // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                            // }
                        }
                    }
                }
                break;
            }
            case 3: {
                long int dIndex = q_diff_exp + 1;
                long int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(long int i = 0; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(long int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                long int x_idx, y_idx;
                                if(dIndex < 0) { // negative diagonals
                                    x_idx = j + i * after;
                                    y_idx = j + i * after - after * dIndex;
                                }
                                else if (dIndex > 0) { // positive diagonals
                                    x_idx = after * dIndex + j + i * after;
                                    y_idx = j + i * after;
                                }
                                else { // principal diagonal
                                    x_idx = j + i * after;
                                    y_idx = j + i * after;
                                }
                                // printf("x_idx = %ld; y_idx = %ld, each_real = %f, each_imag = %f, y_real_values[y_idx] = %f, y_imag_values[y_idx] = %f, x_real_values[x_idx] = %f, x_imag_values[x_idx] = %f\n", x_idx, y_idx, each_real, each_imag, y_real_values[y_idx], y_imag_values[y_idx], x_real_values[x_idx], x_imag_values[x_idx]);
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = each_real * x_real_values[x_idx] - each_imag * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = each_real * x_imag_values[x_idx] + each_imag * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                }
                break;
            }
        }
    }

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t (non-adjacent) matrix_kron_identity_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

diaQMatrix *matrix_kron_identity(diaQMatrix *A, long int n) { // we can combine this with operations that happen later.

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    n = 1L << n;

    // assume a nxn identity matrix, which has one diagonal of length n, in index 0.
    // we just repeat A, n times in the result matrix
    long int *result_shape = new long int[2] {n * A->matrix_shape[0], n * A->matrix_shape[1]};
    diaQMatrix *result = new diaQMatrix(&result_shape);
    std::unordered_map<long int, diagonal*> diagMap = A->diagonalMap;
    std::unordered_map<long int, diagonal*>::iterator it;

    #pragma omp parallel for
    for(long int di = 0; di < diagMap.size(); di++) {
        auto it = std::next(diagMap.begin(), di);
        long int dIndex = it->first;
        diagonal *diag = it->second;
        long int dLength = diag->dLength;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        // result diag
        diagonal *newDiag = new diagonal(dIndex * n, result->getDiagonalLength(dIndex * n));

        valType *newDiag_real_vals = newDiag->realValues;
        valType *newDiag_imag_vals = newDiag->imagValues;

        #pragma omp parallel for collapse(2)
        for(long int j = 0; j < n; j++) {
            for(long int i = 0; i < dLength; i++) {
                newDiag_real_vals[j + i * n] = real_vals[i];
                newDiag_imag_vals[j + i * n] = imag_vals[i];
            }
        }
        #pragma omp critical
        result->setDiagonal(dIndex * n, newDiag);
    }
    // result->pruneMatrix();

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t matrix_kron_identity took %f milliseconds\n", duration.count()/1000.0);
    #endif

    A->free();

    return result;
}

diaQMatrix *identity_kron_matrix_kron_identity(long int before, diaQMatrix *A, long int after) {
    #ifdef DEBUG
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- identity_kron_matrix_kron_identity --- " << std::endl;
        std::cout << " --- " << std::endl;
        A->print();
        std::cout << " --- " << std::endl;
        std::cout << "before = " << before << std::endl;
        std::cout << "after = " << after << std::endl;
        std::cout << " --- " << std::endl;
    #endif

    long int before_N = 1L << before;
    long int after_N = 1L << after;

    long int *result_shape = new long int[2] {before_N * A->matrix_shape[0] * after_N, before_N * A->matrix_shape[1] * after_N};
    diaQMatrix *result = new diaQMatrix(&result_shape);
    std::unordered_map<long int, diagonal*>::iterator it;

    // // #pragma omp parallel for
    // for(long int di = 0; di < diagMap.size(); di++) {
    //     auto it = std::next(diagMap.begin(), di);
    //     long int dIndex = it->first;
    //     diagonal *diag = it->second;
    //     long int dLength = diag->dLength;
    //     valType *real_vals = diag->realValues;
    //     valType *imag_vals = diag->imagValues;

    //     long int new_diag_index = dIndex * after_N;
    //     long int new_diag_length = result->getDiagonalLength(new_diag_index);
    //     diagonal *newDiag = new diagonal(new_diag_index, new_diag_length);
    //     valType *newDiag_real_vals = newDiag->realValues;
    //     valType *newDiag_imag_vals = newDiag->imagValues;

    //     // #pragma omp parallel for
    //     for(long int rep = 0; rep < before_N; rep++) {
    //         long int skip_places = (rep) * (dLength + abs(new_diag_index));
    //         // #pragma omp parallel for
    //         for(long int i = 0; i < dLength; i++) {
    //             newDiag_real_vals[i + skip_places] = real_vals[i];
    //             newDiag_imag_vals[i + skip_places] = imag_vals[i];
    //         }
    //     }
    
    //     #pragma omp critical
    //     result->setDiagonal(dIndex * after_N, newDiag);
    // }

    #pragma omp parallel for
    for(long int di = 0; di < A->diagonalMap.size(); di++) {
        auto it = std::next(A->diagonalMap.begin(), di);
        long int dIndex = it->first;
        diagonal *diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        long int dLength = diag->dLength;

        long int new_diag_index = dIndex * after_N;
        long int new_diag_length = result->getDiagonalLength(new_diag_index);
        diagonal *newDiag = new diagonal(new_diag_index, new_diag_length);
        valType *newDiag_real_vals = newDiag->realValues;
        valType *newDiag_imag_vals = newDiag->imagValues;

        #pragma omp parallel for
        for(long int rep = 0; rep < before_N; rep++) {
            long int skip_places = rep * (after_N * (dLength + abs(dIndex)));
            #pragma omp parallel for
            for(long int i = 0; i < dLength; i++) {
                valType each_real = real_vals[i];
                valType each_imag = imag_vals[i];
                if(each_real != 0 || each_imag != 0) {
                    #pragma omp parallel for
                    for(long int j = 0; j < after_N; j++) {
                        long int new_idx = skip_places + i * after_N + j;
                        newDiag_real_vals[new_idx] = each_real;
                        newDiag_imag_vals[new_idx] = each_imag;
                    }
                }
            }
        }
        #pragma omp critical
        result->setDiagonal(new_diag_index, newDiag);
    }

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\tidentity_kron_matrix_kron_identity took %.3f milliseconds\n", duration.count() / 1000.0);
    #endif

    A->free();

    return result;
}

diaQMatrix *kron_product_old(diaQMatrix *A, diaQMatrix *B) {
    // A: m x n
    // B: p x q
    // C: mp x nq
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- kron product --- " << std::endl;
        std::cout << " --- " << std::endl;
        A->print();
        std::cout << " --- times --- " << std::endl;
        B->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        // start timer
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    long int *shape_a = A->matrix_shape;
    long int *shape_b = B->matrix_shape;

    // map of combination of A diagonal index, A diagonal position to multiply_by_scalar matrix. The individual blocks of matrices: A11 * B, A12 * B, A21 * B, A22 * B, ...
    std::map<std::pair<long int, long int>, std::pair<valType, valType>> kron_map;

    // map of unique A elements and their corresponding kron blocks
    std::map<std::pair<valType, valType>, diaQMatrix *> unique_kron_blocks;

    // Calculate dimensions for the resulting matrix
    long int *result_shape = new long int[2];
    result_shape[0] = shape_a[0] * shape_b[0];
    result_shape[1] = shape_a[1] * shape_b[1];
    diaQMatrix *result = new diaQMatrix(&result_shape);

    std::unordered_map<long int, diagonal*> A_diagonalMap = A->getDiagonalMap();
    std::unordered_map<long int, diagonal*>::iterator itA;

    // printf("kron here 0\n");

    // for each element in A, do multiply_by_scalar with B and add to kron_list.
    // paralleize this later. TODO
    for (itA = A_diagonalMap.begin(); itA != A_diagonalMap.end(); itA++) {
        long int diagonal_index = itA->first;
        diagonal *diag = itA->second;
        long int diagonal_length = diag->dLength;

        #pragma omp parallel for
        for(long int diagonal_position = 0; diagonal_position < diagonal_length; diagonal_position++) {
            // skippihg zero elements
            if(diag->realValues[diagonal_position] == 0.0 && diag->imagValues[diagonal_position] == 0.0) {
                continue;
            }

            // printf("kron here 1\n");

            diaQMatrix *kron_block;
            // dynamic programming for unique kron blocks
            if(unique_kron_blocks.find(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position])) == unique_kron_blocks.end()) {
                kron_block = multiply_by_scalar(B, diag->realValues[diagonal_position], diag->imagValues[diagonal_position]);
                // printf("printing kron_block\n");
                // kron_block->print();
                // store in unique_kron_blocks
                unique_kron_blocks.insert(std::pair<std::pair<valType, valType>, diaQMatrix *>(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]), kron_block));
            }

            // printf("kron here 2\n");

            long int *A_pos = A->getMatrixPosition(diagonal_index, diagonal_position);
            std::pair<long int, long int> key = std::make_pair(A_pos[0], A_pos[1]);
            std::pair<valType, valType> val = std::make_pair(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]);
            kron_map.insert(std::pair<std::pair<long int, long int>, std::pair<valType, valType>>(key, val));
        }
    }
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << "kron_map.size() = " << kron_map.size() << std::endl;
        std::cout << " --- " << std::endl;
    #endif

    // pre-allocate resutl's diagonals and paralleize this below later,! TODO

    // traverse kron_map and add to result.
    std::map<std::pair<long int, long int>, std::pair<valType, valType>>::iterator it;
    #pragma omp parallel
    {
        #pragma omp single
        for (it = kron_map.begin(); it != kron_map.end(); it++) {
            #pragma omp task
            {
                // for each element in A
                long int A_mat_pos[2];
                A_mat_pos[0] = it->first.first;
                A_mat_pos[1] = it->first.second;
                // get kron_block from unique_kron_blocks
                diaQMatrix *kron_block = unique_kron_blocks.find(it->second)->second;

                // we now have to add to result's res_diag_index at res_diag_pos
                std::unordered_map<long int, diagonal*> kron_block_diagMap = kron_block->getDiagonalMap();
                std::unordered_map<long int, diagonal*>::iterator itK;

                #pragma omp parallel
                {
                    #pragma omp single
                    for (itK = kron_block_diagMap.begin(); itK != kron_block_diagMap.end(); itK++) {
                        #pragma omp task
                        {
                            long int kron_block_diag_index = itK->first;
                            diagonal *kron_block_diag = itK->second;
                            long int kron_block_diag_length = kron_block_diag->dLength;

                            #pragma omp parallel for
                            for(long int kron_block_diag_position = 0; kron_block_diag_position < kron_block_diag_length; kron_block_diag_position++) {

                                long int *B_mat_pos = kron_block->getMatrixPosition(kron_block_diag_index, kron_block_diag_position);
                                long int res_mat_pos[2] = {A_mat_pos[0] * shape_b[0] + B_mat_pos[0], A_mat_pos[1] * shape_b[1] + B_mat_pos[1]};
                                long int *res_diag_pos = result->getDiagonalPosition(res_mat_pos);

                                #ifdef DEEP_DEBUG
                                    std::cout << "A_mat_pos = (" << A_mat_pos[0] << ", " << A_mat_pos[1] << ")" << std::endl;
                                    std::cout << "B_mat_pos = (" << B_mat_pos[0] << ", " << B_mat_pos[1] << ")" << std::endl;
                                    std::cout << "res_mat_pos = (" << res_mat_pos[0] << ", " << res_mat_pos[1] << ")" << std::endl;
                                    std::cout << "res_diag_pos = (" << res_diag_pos[0] << ", " << res_diag_pos[1] << ")" << std::endl;
                                #endif

                                result->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], result->getDiagonalLength(res_diag_pos[0]), kron_block_diag->realValues[kron_block_diag_position], kron_block_diag->imagValues[kron_block_diag_position]);
                            }
                        }
                    }
                }
            }
        }
    }

    // result->pruneMatrix(); // Prune the resulting matrix if necessary; we don't actually need this :thinking

    // // for now let's just convert to dense, do the kron product and convert back to diaq
    // denseMatrix denseA = A.convertToDenseMatrix(A->shape);
    // denseMatrix denseB = B.convertToDenseMatrix(B->shape);
    // denseMatrix denseC = dense_kron_product(denseA, denseB);
    // diaQMatrix result = denseC.convertToQuantumSparse(denseC->shape);

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- kron result --- " << std::endl;
        std::cout << " --- " << std::endl;
        result->print();
        std::cout << " --- " << std::endl;
    #endif

    #ifdef DEBUG
        // measure end time
        auto end = std::chrono::high_resolution_clock::now();
        // calculate duration
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        // log duration
        printf("\t\t Kron product took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return result;
}

diaQMatrix *kron_product(diaQMatrix *A, diaQMatrix *B, valType c) {
    return multiply_by_scalar(kron_product(A, B), c, 1.0);
}

diaQMatrix* dagger(diaq::diaQMatrix *A) {
    // dagger is conjugate transpose
    // conjugate first
    diaQMatrix *res = multiply_by_scalar(A, 1.0, -1.0);
    // then transpose
    return transpose(res);
}

diaQMatrix *conjbar(diaQMatrix *A) {
    return multiply_by_scalar(A, 1.0, -1.0);
}

diaQMatrix* expm_negative(diaQMatrix *A, valType t) {
    // Computes e^(-i * A * t) using the Taylor series expansion
    // e^(-i * A * t) ≈ I - i * A * t + (-i * A * t)^2 / 2! + (-i * A * t)^3 / 3! + ...
    // Stops when terms become negligibly small or reach a max iteration count.

    #ifdef DEBUG
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    // Initialize result as the identity matrix
    diaQMatrix *result = new identityMatrix(A->matrix_shape[0]);

    if(A->num_diags() == 1 && A->getDiagonal(0) != nullptr) {
        diagonal *d = A->getDiagonal(0);
        long int dLength = d->dLength;
        valType *real_vals = d->realValues;
        valType *imag_vals = d->imagValues;

        diagonal *res_diag = result->getDiagonal(0);
        valType *res_real_vals = res_diag->realValues;
        valType *res_imag_vals = res_diag->imagValues;

        #ifdef DEBUG
            auto before = std::chrono::high_resolution_clock::now();
        #endif

        // Compute exact exp(-i A t) for diagonal elements
        #pragma omp parallel for
        for (long int i = 0; i < dLength; i++) {
            valType a_i = real_vals[i];
            valType b_i = imag_vals[i];

            valType t_a = t * a_i;
            valType t_b = t * b_i;

            valType exp_b = std::exp(t_b);
            valType cos_ta = std::cos(t_a);
            valType sin_ta = std::sin(t_a);

            res_real_vals[i] = exp_b * cos_ta;
            res_imag_vals[i] = -exp_b * sin_ta;
        }

        #ifdef DEBUG
            auto end = std::chrono::high_resolution_clock::now();

            auto just_loop_duration = std::chrono::duration_cast<std::chrono::microseconds>(end - before);
            printf("\t\t expm_negative FOR LOOP took %f milliseconds\n", just_loop_duration.count() / 1000.0);

            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\t expm_negative took %f milliseconds\n", duration.count() / 1000.0);
        #endif

        return result;
    }

    // Parameters
    int max_iterations = 100; // Limit to avoid infinite loops
    valType tolerance = 1e-14; // Tolerance for convergence, I tweaked this myself, is there a better way?

    diaQMatrix *X = A->copy_and_scale_by_imag(-1.0 * t);
    // printf("X\n");
    // X->print_meta();

    diaQMatrix *X_power_i_whole_divided_by_i = new identityMatrix(A->matrix_shape[0]); // X pwoer 0 / 0! // result is already identity matrix currently
    // printf("X_power_i_whole_divided_by_i\n");
    // X_power_i_whole_divided_by_i->print_meta();

    for(int i = 1; i <= max_iterations; i++) {
        X_power_i_whole_divided_by_i = product(X_power_i_whole_divided_by_i, X);
        // printf("X_power_i_whole_divided_by_i 0 \n");
        // X_power_i_whole_divided_by_i->print_meta();
        X_power_i_whole_divided_by_i->divide_by_int(i);
        // printf("X_power_i_whole_divided_by_i 1\n");
        // X_power_i_whole_divided_by_i->print_meta();
        result->addMatrix(X_power_i_whole_divided_by_i);
        // printf("result\n");
        // result->print_meta();
        if(X_power_i_whole_divided_by_i->norm() < tolerance) {
            break;
        }
    }
    X->free();
    X_power_i_whole_divided_by_i->free();
    #ifdef DEBUG
            auto end = std::chrono::high_resolution_clock::now();

            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\t expm_negative took %f milliseconds\n", duration.count() / 1000.0);
    #endif
    return result;
}

diaQMatrix *diaQMatrix::multiplyMatrix(diaQMatrix *B) {
    std::unordered_map<long int, diagonal*> BDiagMap = B->diagonalMap;
    std::unordered_map<long int, diagonal*> newDiagMap;
    #pragma omp parallel for
    for (long int i = 0; i < diagonalMap.size(); i++) {
        auto itA = std::next(diagonalMap.begin(), i);
        long int dIndexA = itA->first;
        diagonal *dA = itA->second;
        #pragma omp parallel for
        for (long int j = 0; j < BDiagMap.size(); j++) {
            auto itB = std::next(BDiagMap.begin(), j);
            long int dIndexB = itB->first;
            diagonal *dB = itB->second;
            diagonal *dNew = multiplyDiagonals(matrix_shape, matrix_shape, dIndexA, dIndexB, dA, dB);
            if (dNew != nullptr) {
                newDiagMap.insert({dNew->dIndex, dNew});
            }
        }
    }
    this->diagonalMap = newDiagMap;
    return this;
}

} // namespace diaq