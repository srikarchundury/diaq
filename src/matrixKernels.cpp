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
unsigned int getDiagonalLength(int dIndex, std::array<unsigned int, 2> shape) {
    // std::cout << "diag_Index = " << dIndex << " ";
    unsigned int lenRes;
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

std::shared_ptr<diagonal> multiplyDiagonals(std::array<unsigned int, 2> shapeA, std::array<unsigned int, 2> shapeB, int indexA, int indexB, std::shared_ptr<diagonal> diagA, std::shared_ptr<diagonal> diagB, int res_index, std::shared_ptr<diagonal> res) {
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- multiplyDiagonals --- " << std::endl;
        std::cout << " --- " << std::endl;
        std::cout << " --- indexA = " << indexA << std::endl;
        std::cout << " --- indexB = " << indexB << std::endl;
        std::cout << " --- " << std::endl;
        diagA->print_meta();
        diagB->print_meta();
        std::cout << " --- " << std::endl;
    #endif
    unsigned int lenRes = res->dLength;
    if (res_index <= 0 && static_cast<int>(shapeA[0]) <= abs(res_index)) {
        #ifdef DEEP_DEBUG
            std::cout << " --- returning NULL --- " << std::endl;
        #endif
        return NULL;
    } else if (res_index > 0 && static_cast<int>(shapeB[1]) <= res_index) {
        #ifdef DEEP_DEBUG
            std::cout << " --- returning NULL --- " << std::endl;
        #endif
        return NULL;
    }
    unsigned int lenDiagA = diagA->dLength;
    unsigned int lenDiagB = diagB->dLength;

    // std::cout << "diagonal length = " << lenRes << std::endl;
    int offsetA = abs(indexA);  // Absolute value of indexA
    int offsetB = abs(indexB);  // Absolute value of indexB
    int jump = 0;  // Initialize jump

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
    int k = (jump != 0) ? jump : 0;  // Set k to jump if jump > 0

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


    // we compute this just once instead of doing it inside blocks!
    unsigned int max_lenRes   = lenRes - k;
    unsigned int max_lenDiagA = lenDiagA - (k + offsetA - jump);
    unsigned int max_lenDiagB = lenDiagB - (k + offsetB - jump);
    unsigned int loop_count   = std::min({max_lenRes, max_lenDiagA, max_lenDiagB});
    unsigned int loop_start   = k;
    unsigned int loop_end     = k + loop_count;
    unsigned int a_offset     = offsetA - jump;
    unsigned int b_offset     = offsetB - jump;

    // BLOCKED over result diagonal using BLOCK_SIZE
	#pragma omp parallel for schedule(static)
	for (unsigned int block_start = loop_start; block_start < loop_end; block_start += BLOCK_SIZE) {
        unsigned int block_end = std::min(block_start + BLOCK_SIZE, loop_end);

        #if VECTORIZATION_TYPE == 0
            // TODO, change to match avx512 later
            run_sse(block_start, block_end, offsetA, offsetB, jump, lenDiagA, lenDiagB,
                    real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
        #elif VECTORIZATION_TYPE == 1
                // TODO, change to match avx512 later
            run_avx(block_start, block_end, offsetA, offsetB, jump, lenDiagA, lenDiagB,
                    real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
        #elif VECTORIZATION_TYPE == 2
            run_avx512(block_start, block_end, a_offset, b_offset,
                       real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
        #elif VECTORIZATION_TYPE == -1
            run_without_vectorization(block_start, block_end, a_offset, b_offset,
                                      real_vals_a, imag_vals_a, real_vals_b, imag_vals_b, real_vals_final, imag_vals_final);
        #endif
    }

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- result --- " << std::endl;
        res->print_meta();
        std::cout << " --- " << std::endl;
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
std::shared_ptr<diaQMatrix> product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
	#ifdef DEBUG
        std::cout << "starting product -- ";
        auto start = std::chrono::high_resolution_clock::now();
	#endif

	#ifdef CUDA_ENABLED
	    return product_cuda(A, B);
	#else

	std::array<unsigned int, 2> res_dims = {A->matrix_shape[0], B->matrix_shape[1]};
	std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(res_dims);

	// Step 1: Precompute which diag pairs contribute to which result diag
	phmap::parallel_flat_hash_map<int, std::vector<std::pair<int, int>>> res_index_sources;
	phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal>> res_diags;

	res_index_sources.reserve(A->diagonalMap.size() * B->diagonalMap.size() + 10);
	res_diags.reserve(A->diagonalMap.size() * B->diagonalMap.size() + 10);

	for (const auto& [dA, _] : A->diagonalMap) {
		for (const auto& [dB, _] : B->diagonalMap) {
			int res_idx = dA + dB;

			if ((res_idx < -(int)res_dims[0] + 1) || (res_idx > (int)res_dims[1] - 1)) continue;

			unsigned int lenRes = getDiagonalLength(res_idx, res_dims);
			if (lenRes <= 0) continue;

			res_index_sources[res_idx].emplace_back(dA, dB);
			res_diags.try_emplace(res_idx, std::make_shared<diagonal>(res_idx, lenRes));
		}
	}

	// Step 2: Main blocked compute loop (per result diagonal)
	// #pragma omp parallel for
	for (size_t i = 0; i < res_index_sources.size(); ++i) {
		auto it = std::next(res_index_sources.begin(), i);
		int res_idx = it->first;
		auto& sources = it->second;

		std::shared_ptr<diagonal> res_diag = res_diags[res_idx];
		int lenRes = res_diag->dLength;

		for (const auto& [dA, dB] : sources) {
			auto itA = A->diagonalMap.find(dA);
			auto itB = B->diagonalMap.find(dB);
			if (itA == A->diagonalMap.end() || itB == B->diagonalMap.end()) continue;

			std::shared_ptr<diagonal> diagA = itA->second;
			std::shared_ptr<diagonal> diagB = itB->second;

            multiplyDiagonals(
                A->matrix_shape,
                B->matrix_shape,
                dA,
                dB,
                diagA,
                diagB,
                res_idx,
                res_diag
            );
		}

		// Final insertion into result if not empty
		if (res_diag && res_diag->dLength > 0 && !res_diag->isEmpty()) {
			result->diagonalMap.insert({res_idx, res_diag});
            // result->diagonalMap.insert_or_assign(res_idx, res_diag);
		}
	}

	#ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t product took %f milliseconds\n", duration.count()/1000.0);
	#endif

	return result;

	#endif // !CUDA_ENABLED
}

/**
 * @brief dense matrix multiplication (C = A.B)
 * 
 * @param A denseMatrix
 * @param B denseMatrix
 * 
 * @return denseMatrix  C
 */
std::shared_ptr<denseMatrix> denseProduct(std::shared_ptr<denseMatrix> A, std::shared_ptr<denseMatrix> B) {
    std::array<unsigned int, 2> shape_a = A->matrix_shape;
    std::array<unsigned int, 2> shape_b = B->matrix_shape;
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
        for(unsigned int i = 0; i < shape_a[0] * shape_b[1]; i++) {
            real_res[i] = 0.0;
            imag_res[i] = 0.0;
        }
    #endif
    std::array<unsigned int, 2> d;
    d[0] = A->matrix_shape[0];
    d[1] = B->matrix_shape[1];
    // std::shared_ptr<denseMatrix> result = new denseMatrix(&d, real_res, imag_res);
    std::shared_ptr<denseMatrix> result = std::make_shared<denseMatrix>(d, real_res, imag_res);
    for(unsigned int i = 0; i < shape_a[0]; i++) {
        for(unsigned int k = 0; k < shape_b[1]; k++) {
            std::complex<valType> res = 0.0;
            for(unsigned int j = 0; j < shape_b[0]; j++) {
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
std::shared_ptr<diagonal> addElements(std::shared_ptr<diagonal> A, std::shared_ptr<diagonal> B) {
    valType *real_valsA = A->realValues;
    valType *imag_valsA = A->imagValues;
    valType *real_valsB = B->realValues;
    valType *imag_valsB = B->imagValues;
    if(A->dLength != B->dLength ) {
        throw std::invalid_argument("diagonals are of different lengths!");
    }
    // std::shared_ptr<diagonal> res = new diagonal(A->dIndex, A->dLength);
    std::shared_ptr<diagonal> res = std::make_shared<diagonal>(A->dIndex, A->dLength);
    valType *real_valsC = res->realValues;
    valType *imag_valsC = res->imagValues;
    #pragma omp parallel for
    for(unsigned int i=0; i < A->dLength; i++) {
        real_valsC[i] = real_valsA[i] + real_valsB[i];
        imag_valsC[i] = imag_valsA[i] + imag_valsB[i];
    }
    return res;
}

std::shared_ptr<diaQMatrix> add(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
    // check for out of bounds
    if(A->matrix_shape[0] != B->matrix_shape[0] || A->matrix_shape[1] != B->matrix_shape[1]) {
        throw std::invalid_argument("input matrices are not addable");
    }
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(A->matrix_shape[0] * A->matrix_shape[1]);
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > mapA = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > mapB = B->diagonalMap;
    #pragma omp parallel for
    for(unsigned int a = 0; a < mapA.size(); a++) {
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

std::complex<valType> trace(std::shared_ptr<diaQMatrix> A) {
    std::complex<valType> t = 0;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itA;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > mapA = A->diagonalMap;
    itA = mapA.find(0);
    if(itA == mapA.end()) {
        return t;
    }
    for(unsigned int i=0; i < itA->second->dLength; i++) {
        t += itA->second->getValue(i);
    }
    return t;
}

std::shared_ptr<diaQMatrix> matrix_reshape(std::shared_ptr<diaQMatrix> A, std::array<unsigned int, 2> matrix_shape) {
    // start time
    #ifdef DEBUG
        printf("starting matrix_reshape -- ");
        auto start = std::chrono::high_resolution_clock::now();
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

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t matrix_reshape took %f milliseconds\n", duration.count()/1000.0);
    #endif

    return res;
}

std::shared_ptr<diaQMatrix> reshape(std::shared_ptr<diaQMatrix> A, std::vector<unsigned int> new_tensor_shape) {
    unsigned int old_product = 1;
    #pragma unroll
    for(unsigned int i=0; i < A->shape.size(); i++) old_product *= A->shape[i];
    unsigned int new_product = 1;
    #pragma unroll
    for(unsigned int i=0; i < new_tensor_shape.size(); i++) new_product *= new_tensor_shape[i];
    if(old_product != new_product) {
        std::cout << old_product << "!=" << new_product << std::endl;
        throw std::invalid_argument("cannot reshape into given shape");
    }
    // this is tensor reshape, we can just replace shape and we're good.
    A->shape = new_tensor_shape;
    return A;
}

std::vector<unsigned int> newTensorShape(std::vector<unsigned int> tensor_shape_A, std::vector<unsigned int> tensor_shape_B, std::vector<unsigned int> axis_A, std::vector<unsigned int> axis_B) {
    std::vector<unsigned int> res;
    for(unsigned int i = 0; i < tensor_shape_A.size(); i++) {
        unsigned int notin = 1;
        for(unsigned int p = 0; p < axis_A.size(); p++) {
            if(i == axis_A[p]) {
                notin = 0; break;
            }
        }
        if(notin) {
            res.push_back(tensor_shape_A[i]);
        }
    }
    // std::cout << "axis_B " << axis_B << std::endl;
    for(unsigned int i = 0; i < tensor_shape_B.size(); i++) {
        unsigned int notin = 1;
        for(unsigned int p = 0; p < axis_B.size(); p++) {
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

std::array<unsigned int, 2> newMatrixShape(std::vector<unsigned int> tensorShape) {
    unsigned int product = 1;
    for (unsigned int i = 0; i < tensorShape.size(); i++) {
        product *= tensorShape[i];
    }
    unsigned int sqrtProduct = static_cast<unsigned int>(std::sqrt(product));
    // Find the closest factors of the product
    unsigned int x = 1;
    unsigned int y = product;
    for (unsigned int i = sqrtProduct; i > 0; --i) {
        if (product % i == 0) {
            x = i;
            y = product / i;
            break;
        }
    }
    std::array<unsigned int, 2> new_shape;
    new_shape[0] = x;
    new_shape[1] = y;
    return new_shape;
}

std::vector<unsigned int> modifyTensorShape(std::vector<unsigned int> tShape, std::vector<unsigned int> axes) {
    std::vector<unsigned int> nShape;
    int tShapeSize = tShape.size();
    if(axes.size() == 0) {
        nShape.resize(tShape.size(), 1);
        #pragma omp parallel for
        for(unsigned int i = 0; i < tShape.size(); i++) {
            nShape[i] = tShape[tShapeSize - i - 1];
        }
    }
    else {
        nShape.resize(axes.size(), 1);
        #pragma omp parallel for
        for(unsigned int i = 0; i < axes.size(); i++) {
            nShape[i] = tShape[axes[i]];
        }
    }
    return nShape;
}

std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A, std::vector<unsigned int> new_order) {
    // // start timer
    // auto start = std::chrono::high_resolution_clock::now();

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
    #pragma unroll
    for(unsigned int r = 0; r<i ; r++) {
        new_shape[0] = new_shape[0] * new_tensor_shape[r];
    }
    #pragma unroll
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
    return res;
}

std::shared_ptr<diaQMatrix> transpose(std::shared_ptr<diaQMatrix> A) {
    return transpose(A, std::vector<unsigned int>());
}

std::shared_ptr<diaQMatrix> tensordot1(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned int> > axes) {
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
    #pragma unroll
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
    #pragma unroll
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
    #pragma unroll
    for(unsigned int i=0;i<axes[0].size();i++) axes_0_product *= A->shape[axes[0][i]];
    unsigned int axes_1_product = 1;
    #pragma unroll
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

// int *getMatrixShape(std::vector<int> tensor_shape) {
std::array<unsigned int, 2> getMatrixShape(std::vector<unsigned int> tensor_shape) {
    // print tensor_shape
    // printf("tensor_shape = (");
    // for (unsigned int i = 0; i < tensor_shape.size() - 1; i++) {
    //     printf("%ld, ", tensor_shape[i]);
    // }
    // printf("%ld)\n", tensor_shape[tensor_shape.size() - 1]);
    // Calculate the product of the tensor shape
    unsigned int product = 1;
    for (unsigned int i = 0; i < tensor_shape.size(); i++) {
        product *= tensor_shape[i];
    }
    unsigned int sqrtProduct = static_cast<unsigned int>(std::sqrt(product));
    // Find the closest factors of the product
    unsigned int x = 1;
    unsigned int y = product;
    for (unsigned int i = sqrtProduct; i > 0; --i) {
        if (product % i == 0) {
            x = i;
            y = product / i;
            break;
        }
    }
    std::array<unsigned int, 2> new_shape;
    new_shape[0] = x;
    new_shape[1] = y;
    // printf("new_shape = (%ld, %ld)\n", new_shape[0], new_shape[1]);
    return new_shape;
}

std::vector<unsigned int> getTenPos(const std::vector<unsigned int>& ten_pos_A,
                                     const std::vector<unsigned int>& ten_pos_B,
                                     const std::vector<unsigned int>& axes_A,
                                     const std::vector<unsigned int>& axes_B,
                                     const std::vector<unsigned int>& shape_A,
                                     const std::vector<unsigned int>& shape_B) {
    std::vector<unsigned int> res;
    for (unsigned int i = 0; i < ten_pos_A.size(); i++) {
        unsigned int notin = 1;
        for (unsigned int p = 0; p < axes_A.size(); p++) {
            if (i == axes_A[p]) {
                notin = 0;
                break;
            }
        }
        if (notin) {
            res.push_back(ten_pos_A[i]);
        }
    }
    for (unsigned int i = 0; i < ten_pos_B.size(); i++) {
        unsigned int notin = 1;
        for (unsigned int p = 0; p < axes_B.size(); p++) {
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

std::shared_ptr<diaQMatrix> tensordot(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, std::vector<std::vector<unsigned int> > axes) {
    // start timer
    // auto start = std::chrono::high_resolution_clock::now();

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

    return res;
}

std::shared_ptr<diaQMatrix> array(std::shared_ptr<diaQMatrix> A) {
    // std::cout << "array called for A - " << std::endl;
    // A.print();
    // TODO: unclear as of now what this mehthod should be doing
    return A;
}

std::shared_ptr<diaQMatrix> einsum(std::shared_ptr<diaQMatrix> A, std::vector<unsigned int> axes) {
    std::cout << axes[0] << std::endl;
    return A;
}

// overloading operators
std::shared_ptr<diaQMatrix> operator*(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B) {
    return product(A, B);
}
std::shared_ptr<diaQMatrix> operator+(std::shared_ptr<diaQMatrix> &A, std::shared_ptr<diaQMatrix> &B) {
    return add(A, B);
}
void diaQMatrix::matrix_reshape(std::array<unsigned int, 2> matrix_shape) {
    // printf("self reshape called with newshape (%ld, %ld)\n", matrix_shape[0], matrix_shape[1]);
    std::shared_ptr<diaQMatrix> temp = diaq::matrix_reshape(shared_from_this(), matrix_shape);
    *this = *temp;
}
std::shared_ptr<diaQMatrix> diaQMatrix::reshape(std::vector<unsigned int> new_tensor_shape) {
    return diaq::reshape(shared_from_this(), new_tensor_shape);
}
std::shared_ptr<diaQMatrix> diaQMatrix::transpose(std::vector<unsigned int> new_order) {
    std::shared_ptr<diaQMatrix> temp = diaq::transpose(shared_from_this(), new_order);
    return temp;
}
std::shared_ptr<diaQMatrix> diaQMatrix::transpose() {
    std::shared_ptr<diaQMatrix> temp = diaq::transpose(shared_from_this());
    return temp;
}

std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x) {
    std::shared_ptr<vector> y = std::make_shared<vector>(A->matrix_shape[0], 0.0, 0.0);
    spMV(A, x, y);
    // x goes out of scope here and would be deleted by shared_ptr!
    return y;
}

void spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
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
        printf("starting spMV --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    // if(A->matrix_shape[1] != x->num_rows()) {
    //     throw std::invalid_argument("Not multiplyable");
    // }

    // std::shared_ptr<vector> y = new vector(A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for (size_t a = 0; a < A->diagonalMap.size(); ++a) {
        auto it = std::next(A->diagonalMap.begin(), a);
        int dIndex = it->first;
        unsigned int dLength = it->second->dLength;
        valType *real_vals = it->second->realValues;
        valType *imag_vals = it->second->imagValues;

        if(dIndex < 0) { // negative diagonals
            #pragma omp critical
            {
                // printf("Negative diagonal!!\n");
                #if VECTORIZATION_TYPE == 1
                        run_spmv_avx_1(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #elif VECTORIZATION_TYPE == 2
                    run_spmv_avx512_1(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #elif VECTORIZATION_TYPE == 0
                    run_spmv_sse_1(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #else // run without vectorization
                    #pragma omp simd
                    for (unsigned int i = 0; i < dLength; i++) {
                        unsigned int x_idx = i;
                        unsigned int y_idx = i - dIndex;
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
                #if VECTORIZATION_TYPE == 2
                        run_spmv_avx512_2(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #elif VECTORIZATION_TYPE == 1
                        run_spmv_avx_2(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #elif VECTORIZATION_TYPE == 0
                    run_spmv_sse_2(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #else // run without vectorization
                    #pragma omp simd
                    for (unsigned int i = 0; i < dLength; i++) {
                        unsigned int x_idx = dIndex + i;
                        unsigned int y_idx = i;
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
                #if VECTORIZATION_TYPE == 2
                        run_spmv_avx512_0(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #elif VECTORIZATION_TYPE == 1
                        run_spmv_avx_0(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #elif VECTORIZATION_TYPE == 0
                    run_spmv_sse_0(x_real_values, x_imag_values, real_vals, imag_vals, y_real_values, y_imag_values, dIndex, dLength);
                #else // run without vectorization
                    #pragma omp simd
                    for (unsigned int i = 0; i < dLength; i++) {
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

    #endif
}

std::shared_ptr<vector> spMV(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger) {

    // DID NOT IMPLEMENT YET!
    // TODO: PLS IMPLEMENT!!

    #ifdef DEBUG
        // measure start timer
        printf("starting spMV --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    unsigned int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    std::array<unsigned int, 2> new_gate_shape = {q_diff_exp, q_diff_exp};

    // if(A->matrix_shape[1] != x->numRows) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(A->matrix_shape[0], 0.0, 0.0);
    // valType *y_real_values = y->realValues;
    // valType *y_imag_values = y->imagValues;
    // valType *x_real_values = x->realValues;
    // valType *x_imag_values = x->imagValues;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel
    {
        #pragma omp single
        {
            for (it = diagMap.begin(); it != diagMap.end(); it++) {
                #pragma omp task
                {
                    std::shared_ptr<diagonal> diag = it->second;
                    // valType *real_vals = diag->realValues;
                    // valType *imag_vals = diag->imagValues;
                    switch(diag->dIndex) {
                        case -3: {
                            // int dIndex = -1 * q_diff_exp - 1;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case -2: {
                            // int dIndex = -1 * q_diff_exp;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case -1: {
                            // int dIndex = -1;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            // // something
                            // dIndex = -1 * q_diff_exp + 1;
                            // dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 0: {
                            // int dIndex = 0;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 1: {
                            // int dIndex = 1;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            // // do something
                            // dIndex = q_diff_exp - 1;
                            // dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 2: {
                            // int dIndex = q_diff_exp;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                        case 3: {
                            // int dIndex = q_diff_exp + 1;
                            // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                            break;
                        }
                    }
                }
            }
        }
    }

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

std::shared_ptr<vector> MV(std::shared_ptr<denseMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
    if(A->matrix_shape[1] != x->numRows) {
        throw std::invalid_argument("Not multiplyable");
    }
    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;
    // std::shared_ptr<vector> y = new vector(A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;
    for(unsigned int i = 0; i < A->matrix_shape[0]; i++) {
        valType res_real = 0.0;
        valType res_imag = 0.0;
        for(unsigned int j = 0; j < A->matrix_shape[1]; j++) {
            std::complex<valType> elem = A->get(i, j);
            res_real += elem.real() * x_real_values[j] - elem.imag() * x_imag_values[j];
            res_imag += elem.real() * x_imag_values[j] + elem.imag() * x_real_values[j];
        }
        y_real_values[i] = res_real;
        y_imag_values[i] = res_imag;
    }
    return y;
}

std::shared_ptr<denseMatrix> dense_kron_product(std::shared_ptr<denseMatrix> A, std::shared_ptr<denseMatrix> B) {
    // A: m x n
    // B: p x q
    // C: mp x nq

    std::array<unsigned int, 2> shape_a = A->matrix_shape;
    std::array<unsigned int, 2> shape_b = B->matrix_shape;

    // Calculate dimensions for the resulting matrix
    std::array<unsigned int, 2> d;
    d[0] = shape_a[0] * shape_b[0];
    d[1] = shape_a[1] * shape_b[1];
    #if NUM_BYTES_ALIGNED == -1
        valType *real_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
        valType *imag_res = (valType *)calloc(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1], sizeof(valType));
    #else
        valType *real_res = aligned_alloc_helper(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1] * sizeof(valType));
        valType *imag_res = aligned_alloc_helper(shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1] * sizeof(valType));
        #pragma omp parallel for
        for(unsigned int i = 0; i < shape_a[0] * shape_a[1] * shape_b[0] * shape_b[1]; i++) {
            real_res[i] = 0.0;
            imag_res[i] = 0.0;
        }
    #endif
    // std::shared_ptr<denseMatrix> result = new denseMatrix(&d, real_res, imag_res);
    std::shared_ptr<denseMatrix> result = std::make_shared<denseMatrix>(d, real_res, imag_res);

    // Iterate through the rows of matrix A
    for (unsigned int i = 0; i < A->matrix_shape[0]; i++) {

        // Iterate through the columns of matrix A
        for (unsigned int j = 0; j < A->matrix_shape[1]; j++) {

            // Iterate through the rows of matrix B
            for (unsigned int k = 0; k < B->matrix_shape[0]; k++) {

                // Iterate through the columns of matrix B
                for (unsigned int l = 0; l < B->matrix_shape[1]; l++) {

                    // Calculate the resulting indices in the new matrix
                    unsigned int newIndexI = i * B->matrix_shape[0] + k;
                    unsigned int newIndexJ = j * B->matrix_shape[1] + l;

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

std::shared_ptr<diaQMatrix> multiply_by_scalar(std::shared_ptr<diaQMatrix> A, valType scalar_real, valType scalar_imag) {
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

    // std::shared_ptr<diaQMatrix> result = new diaQMatrix((unsigned int)0);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>((unsigned int)0);

    if (scalar_real == 0.0 && scalar_imag == 0.0) {
        return result;
    }

    result->matrix_shape = A->matrix_shape;
    result->shape = A->shape;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for (size_t a = 0; a < A->diagonalMap.size(); ++a) {
        auto it = std::next(A->diagonalMap.begin(), a);
        int dIndex = it->first;
        unsigned int dLength = it->second->dLength;
        valType *real_vals = it->second->realValues;
        valType *imag_vals = it->second->imagValues;
        // std::shared_ptr<diagonal> newDiag = new diagonal(dIndex, dLength);
        std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(dIndex, dLength);
        valType *real_valsC = newDiag->realValues;
        valType *imag_valsC = newDiag->imagValues;

        #pragma omp simd
        for (unsigned int i = 0; i < dLength; i++) {
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

std::shared_ptr<diaQMatrix> kron_product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {

    #ifdef DEEP_DEBUG
        printf("\tdiaq::kron_product\n");
        printf("\tA Meta:\n");
        A->print_meta();
        printf("\tB Matrix:\n");
        B->print_meta();
    #endif

    #ifdef DEBUG
        // measure start timer
        printf("starting kron_product --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    std::array<unsigned int, 2> shape_a = A->matrix_shape;
    std::array<unsigned int, 2> shape_b = B->matrix_shape;

    // map of unique A elements and their corresponding kron blocks
    std::map<std::pair<valType, valType>, std::shared_ptr<diaQMatrix> > unique_kron_blocks;

    // Calculate dimensions for the resulting matrix
    std::array<unsigned int, 2> result_shape;
    result_shape[0] = shape_a[0] * shape_b[0];
    result_shape[1] = shape_a[1] * shape_b[1];
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itA;

    #pragma omp parallel for
    for (unsigned int a = 0; a < A->diagonalMap.size(); a++) {
        auto itA = std::next(A->diagonalMap.begin(), a);
        int diagonal_index = itA->first;
        std::shared_ptr<diagonal> diag = itA->second;
        unsigned int diagonal_length = diag->dLength;

        #pragma omp parallel for
        for(unsigned int diagonal_position = 0; diagonal_position < diagonal_length; diagonal_position++) {
            // skippihg zero elements
            if(diag->realValues[diagonal_position] == 0.0 && diag->imagValues[diagonal_position] == 0.0) {
                continue;
            }
            std::shared_ptr<diaQMatrix> kron_block;
            // dynamic programming for unique kron blocks
            #pragma omp critical
            {
                if(unique_kron_blocks.find(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position])) == unique_kron_blocks.end()) {
                    kron_block = multiply_by_scalar(B, diag->realValues[diagonal_position], diag->imagValues[diagonal_position]);
                    unique_kron_blocks.insert(std::pair<std::pair<valType, valType>, std::shared_ptr<diaQMatrix> >(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]), kron_block));
                } else {
                    kron_block = unique_kron_blocks.find(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]))->second;
                }
            }

            std::array<unsigned int, 2> A_pos = A->getMatrixPosition(diagonal_index, diagonal_position);
            phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itK;

            #pragma omp parallel for
            for (unsigned int b = 0; b < kron_block->diagonalMap.size(); b++) {
                auto itK = std::next(kron_block->diagonalMap.begin(), b);
                int kron_block_diag_index = itK->first;
                std::shared_ptr<diagonal> kron_block_diag = itK->second;
                unsigned int kron_block_diag_length = kron_block_diag->dLength;

                #pragma omp parallel for
                for(unsigned int kron_block_diag_position = 0; kron_block_diag_position < kron_block_diag_length; kron_block_diag_position++) {

                    std::array<unsigned int, 2> B_mat_pos = kron_block->getMatrixPosition(kron_block_diag_index, kron_block_diag_position);
                    // int res_mat_pos[2] = {A_pos[0] * shape_b[0] + B_mat_pos[0], A_pos[1] * shape_b[1] + B_mat_pos[1]};
                    // std::array<unsigned int, 2> res_mat_pos = std::make_shared<int[]>(2){A_pos[0] * shape_b[0] + B_mat_pos[0], A_pos[1] * shape_b[1] + B_mat_pos[1]};
                    std::array<unsigned int, 2> res_mat_pos;
                    res_mat_pos[0] = A_pos[0] * shape_b[0] + B_mat_pos[0];
                    res_mat_pos[1] = A_pos[1] * shape_b[1] + B_mat_pos[1];
                    std::array<int, 2> res_diag_pos = result->getDiagonalPosition(res_mat_pos);

                    #pragma omp critical
                    {
                        result->setDiagonalElement(res_diag_pos[0], res_diag_pos[1], result->getDiagonalLength(res_diag_pos[0]), kron_block_diag->realValues[kron_block_diag_position], kron_block_diag->imagValues[kron_block_diag_position]);
                    }
                }
            }
        }
    }

    // // free unique_kron_blocks
    // #pragma omp parallel for
    // for (int a = 0; a < unique_kron_blocks.size(); a++) {
    //     auto it = std::next(unique_kron_blocks.begin(), a);
    //     it->second->free();
    // }
    // we don't need to free unique_kron_blocks, since we are using shared_ptr

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

std::shared_ptr<diaQMatrix> identity_kron_matrix(unsigned int n, std::shared_ptr<diaQMatrix> A) {

    #ifdef DEEP_DEBUG
        printf("\tdiaq::identity_kron_matrix\n");
        printf("\tA Meta:\n");
        A->print_meta();
    #endif

    #ifdef DEBUG
        // measure start timer
        printf("starting identity_kron_matrix --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    unsigned int N = 1L << n;

    // assume a nxn identity matrix, which has one diagonal of length N, in index 0.
    // we just repeat A, N times in the result matrix
    std::array<unsigned int, 2> result_shape = {N * A->matrix_shape[0], N * A->matrix_shape[1]};
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for (unsigned int i = 0; i < diagMap.size(); i++) {
        auto it = std::next(diagMap.begin(), i);
        int dIndex = it->first;
        std::shared_ptr<diagonal> diag = it->second;
        // printf("A's diagonal\n");
        // diag->print();
        unsigned int dLength = diag->dLength;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        // result diag
        unsigned int new_dLength = result->getDiagonalLength(dIndex); // TODO: there should be a better way to get this using n and dLength.
        // std::shared_ptr<diagonal> newDiag = new diagonal(dIndex, new_dLength);
        std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(dIndex, new_dLength);
        valType *newDiag_real_vals = newDiag->realValues;
        valType *newDiag_imag_vals = newDiag->imagValues;

        #pragma omp parallel for
        for(unsigned int rep = 0; rep < N; rep++) {
            unsigned int skip_places = (rep) * (dLength + abs(dIndex));
            #pragma omp parallel for
            for(unsigned int i = 0; i < dLength; i++) {
                newDiag_real_vals[i + skip_places] = real_vals[i];
                newDiag_imag_vals[i + skip_places] = imag_vals[i];
            }
        }
        // #pragma omp critical
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

    // A->free();

    return result;
}

void identity_kron_matrix_times_vector(unsigned int n, std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {

    #ifdef DEBUG
        // start timer
        printf("starting identity_kron_matrix_times_vector --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    unsigned int N = 1L << n;

    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    // unsigned int y_len = y->numRows; // same as x->numRows;
    unsigned int A_size = A->matrix_shape[0];
    // I kron A has the same number of diagonals as A, but each diagonal has N times more G elements and more 0s that we don't need to care about.
    // So, we can just iterate through the diagonals of A and repeat each diagonal N times in the result vector. But offsets are important and different for each iteration, since each is essentially a block!
    // now for each diagonal in A
    // index in y and x goes from (0, block_idx * diag_length)

    unsigned int last_y_offset = (N-1) * A_size;

    #pragma omp parallel for
    for(unsigned int y_offset = 0; y_offset <= last_y_offset; y_offset += A_size) { // this is like traversing blocks in I kron A

        for (unsigned int di = 0; di < diagMap.size(); di++) {
            auto it = std::next(diagMap.begin(), di);
            // now we can do element wise!
            int dIndex = it->first;
            std::shared_ptr<diagonal> diag = it->second;
            unsigned int dLength = diag->dLength;
            valType *real_vals = diag->realValues;
            valType *imag_vals = diag->imagValues;

            unsigned int x_inner_offset = (dIndex > 0) ? dIndex : 0;
            unsigned int y_inner_offset = (dIndex < 0) ? -dIndex : 0;

            unsigned int x_offset = y_offset + x_inner_offset;
            unsigned int new_y_offset = y_offset + y_inner_offset;

            #pragma omp parallel for
            for (unsigned int y_idx = new_y_offset; y_idx < dLength + new_y_offset; y_idx++) {
                unsigned int x_idx = x_offset + (y_idx - new_y_offset); // adjust x_idx for each iteration
                unsigned int i = y_idx - new_y_offset; // if you want to match your original i loop
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


void identity_kron_matrix_times_vector(unsigned int n, std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger) {

    #ifdef DEBUG
        // start timer
        printf("starting identity_kron_matrix_times_vector --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    n = 1L << n;

    unsigned int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    std::array<unsigned int, 2> new_gate_shape = {q_diff_exp, q_diff_exp};

    // std::shared_ptr<vector> y = new vector(n * A->matrix_shape[0]);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        std::shared_ptr<diagonal> diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        switch(diag->dIndex) {
            case -3: {
                int dIndex = -1 * q_diff_exp - 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < n; rep++) {
                    unsigned int skip_places = rep * (dLength - dIndex);
                    #pragma omp simd
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            unsigned int x_idx = i + skip_places;
                            unsigned int y_idx = i + skip_places - dIndex;
                            y_real_values[y_idx] += real_vals[0] * x_real_values[x_idx] - imag_vals[0] * x_imag_values[x_idx];
                            y_imag_values[y_idx] += real_vals[0] * x_imag_values[x_idx] + imag_vals[0] * x_real_values[x_idx];
                        }
                    }
                }
                break;
            }
            case -2: {
                int dIndex = -1 * q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < n; rep++) {
                    unsigned int skip_places = rep * (dLength - dIndex);
                    #pragma omp simd
                    for(unsigned int i = 0; i < dLength/2; i++) {
                        unsigned int x_idx = i + skip_places;
                        unsigned int y_idx = i + skip_places - dIndex;
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
                // int dIndex = -1;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // // something
                // dIndex = -1 * q_diff_exp + 1;
                // dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 0: {
                // int dIndex = 0;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 1: {
                // int dIndex = 1;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // // do something
                // dIndex = q_diff_exp - 1;
                // dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 2: {
                // int dIndex = q_diff_exp;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                break;
            }
            case 3: {
                // int dIndex = q_diff_exp + 1;
                // unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
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
        printf("\t\t (non-adjacent) identity_kron_matrix_times_vector took %f milliseconds\n", duration.count()/1000.0);
    #endif

}

void identity_kron_matrix_kron_identity_times_vector(unsigned int before, std::shared_ptr<diaQMatrix> gate, unsigned int after, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
    // logically combine matrix_kron_identity and identity_kron_matrix_times_vector

    #ifdef DEBUG
        // start timer
        printf("starting identity_kron_matrix_kron_identity_times_vector --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        std::cout << "identity_kron_matrix_kron_identity_times_vector called" << std::endl;
        printf("gate matrix below\n");
        gate->print();
        printf("\t\tbefore = %ld; after = %ld\n", before, after);
    #endif

    unsigned int before_N = 1L << before;
    unsigned int after_N = 1L << after;

    // unsigned int x_length = x->numRows;
    // if(after * before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(after * before * gate->matrix_shape[0]);
    // y->print();
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;
    // PRINT_WITH_LINE("here\n");

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = gate->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for collapse(2)
    for (unsigned int rep = 0; rep < before_N; rep++) {
        for (unsigned int j = 0; j < after_N; j++) {
            for (unsigned int a = 0; a < diagMap.size(); a++) {
                auto it = std::next(diagMap.begin(), a);
                int dIndex = it->first;
                std::shared_ptr<diagonal> diag = it->second;
                unsigned int dLength = diag->dLength;
                valType *real_vals = diag->realValues;
                valType *imag_vals = diag->imagValues;

                unsigned int skip_places = rep * (after_N * (dLength + (dIndex < 0 ? -dIndex : dIndex)));
                unsigned int x_offset = (dIndex < 0 ? skip_places : after_N * dIndex + skip_places);
                unsigned int y_offset = (dIndex < 0 ? skip_places - after_N * dIndex : skip_places);

                #pragma omp simd
                for (unsigned int i = 0; i < dLength; i++) {
                    unsigned int x_idx = x_offset + i * after_N + j;
                    unsigned int y_idx = y_offset + i * after_N + j;
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

void identity_kron_matrix_kron_identity_times_vector(unsigned int before, std::shared_ptr<diaQMatrix> gate, unsigned int after, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger) {

    #ifdef DEBUG
        // start timer
        printf("starting identity_kron_matrix_kron_identity_times_vector --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    after = 1L << after;
    before = 1L << before;

    unsigned int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    // int *new_gate_shape = new int[2] {q_diff_exp, q_diff_exp};
    // std::shared_ptr<int> new_gate_shape = std::make_shared<int>(2) {q_diff_exp, q_diff_exp};
    std::array<unsigned int, 2> new_gate_shape = {q_diff_exp, q_diff_exp};

    // unsigned int x_length = x->numRows;
    // if(after * before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(after * before * gate->matrix_shape[0]);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = gate->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for (unsigned int a = 0; a < diagMap.size(); a++) {
        auto it = std::next(diagMap.begin(), a);
        std::shared_ptr<diagonal> diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        switch(diag->dIndex) {
            case -3: {
                int dIndex = -1 * q_diff_exp - 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                int dIndex = -1 * q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i += 2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                int dIndex = -1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength/2; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                    // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                        y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                        y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                    // }
                                }
                            }
                        }
                    }
                    for(unsigned int i = dLength/2; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[2];
                            valType imag_val = imag_vals[2];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 != 0) {
                            valType real_val = real_vals[1];
                            valType imag_val = imag_vals[1];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                int dIndex = 0;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength/2; i+=2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
                                // if(x_idx >= 0 && x_idx < x_length && y_idx < x_length && y_idx >=0) {
                                    y_real_values[y_idx] = real_val * x_real_values[x_idx] - imag_val * x_imag_values[x_idx];
                                    y_imag_values[y_idx] = real_val * x_imag_values[x_idx] + imag_val * x_real_values[x_idx];
                                // }
                            }
                        }
                    }
                    for(unsigned int i = dLength/2; i < dLength; i+=2) {
                        valType real_val = real_vals[2];
                        valType imag_val = imag_vals[2];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                int dIndex = 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength/2; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                    for(unsigned int i = dLength/2; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[2];
                            valType imag_val = imag_vals[2];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 != 0) {
                            valType real_val = real_vals[1];
                            valType imag_val = imag_vals[1];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                int dIndex = q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i += 2) {
                        valType real_val = real_vals[0];
                        valType imag_val = imag_vals[0];
                        if(real_val != 0 || imag_val != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                            for(unsigned int j = 0; j < before; j++) {
                                unsigned int x_idx = j + i * after + skip_places;
                                unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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
                int dIndex = q_diff_exp + 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                #pragma omp parallel for
                for(unsigned int rep = 0; rep < before; rep++) {
                    unsigned int skip_places = rep * (after * (dLength - dIndex));
                    for(unsigned int i = 0; i < dLength; i++) {
                        if(i % 2 == 0) {
                            valType real_val = real_vals[0];
                            valType imag_val = imag_vals[0];
                            if(real_val != 0 || imag_val != 0) {
                                #pragma omp parallel for
                                for(unsigned int j = 0; j < before; j++) {
                                    unsigned int x_idx = j + i * after + skip_places;
                                    unsigned int y_idx = j + i * after + skip_places - after * dIndex;
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

void matrix_kron_identity_times_vector(std::shared_ptr<diaQMatrix> A, unsigned int n, std::shared_ptr<vector> x, std::shared_ptr<vector> y) {
    // logically combine matrix_kron_identity and spMV

    #ifdef DEBUG
        //start timer
        printf("starting matrix_kron_identity_times_vector --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    #ifdef DEEP_DEBUG
        printf("matrix_kron_identity_times_vector called\n");
        printf("A matrix below\n");
        A->print();
        printf("\t\n = %u\n", n);
    #endif

    unsigned int N = 1L << n;

    // unsigned int x_length = x->numRows;
    // if(before * A->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(before * A->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    // (A kron I) times x = y
    #pragma omp parallel for collapse(2)
    for (unsigned int j = 0; j < N; j++) {
        for (unsigned int a = 0; a < diagMap.size(); a++) {
            auto it = std::next(diagMap.begin(), a);
            std::shared_ptr<diagonal> diag = it->second;
            valType *real_vals = diag->realValues;
            valType *imag_vals = diag->imagValues;
            int dIndex = it->first;
            unsigned int dLength = diag->dLength;
            for (unsigned int i = 0; i < dLength; i++) {
                valType real_i = real_vals[i];
                valType imag_i = imag_vals[i];
                // we can skip 0s
                if(real_i == 0 && imag_i == 0) {
                    continue;
                }
                // each element kinda becomes an I block (scalar val at i times I block), we don't need a multiplication op here at all, instead we can cover over values of A, N times as 1 times something is just something.
                unsigned int y_offset = i * N;
                unsigned int x_offset = i * N;
                int new_dIndex = dIndex * N;
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

void matrix_kron_identity_times_vector(std::shared_ptr<diaQMatrix> gate, unsigned int after, std::shared_ptr<vector> x, std::shared_ptr<vector> y, unsigned int qubit_smaller, unsigned int qubit_larger) {
    // logically combine matrix_kron_identity and spMV

    #ifdef DEBUG
        //start timer
        printf("starting matrix_kron_identity_times_vector --");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    after = 1L << after;

    unsigned int q_diff_exp = 1L << (qubit_larger - qubit_smaller);
    std::array<unsigned int, 2> new_gate_shape = {q_diff_exp, q_diff_exp};

    // unsigned int x_length = x->numRows;
    // if(before * gate->matrix_shape[1] != x_length) {
    //     throw std::invalid_argument("Not multiplyable");
    // }
    // std::shared_ptr<vector> y = new vector(before * gate->matrix_shape[0], 0.0, 0.0);
    valType *y_real_values = y->realValues;
    valType *y_imag_values = y->imagValues;

    valType *x_real_values = x->realValues;
    valType *x_imag_values = x->imagValues;

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = gate->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for (unsigned int a = 0; a < diagMap.size(); a++) {
        auto it = std::next(diagMap.begin(), a);
        std::shared_ptr<diagonal> diag = it->second;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        switch(diag->dIndex) {
            case -3: {
                int dIndex = -1 * q_diff_exp - 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
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
                int dIndex = -1 * q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
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
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
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
                int dIndex = -1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength/2; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
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
                for(unsigned int i = dLength/2; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[2];
                        valType each_imag = imag_vals[2];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
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
                for(unsigned int i = 0; i < dLength; i++) {
                    if( i% 2 != 0) {
                        valType each_real = real_vals[1];
                        valType each_imag = imag_vals[1];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
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
                int dIndex = 0;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength/2; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
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
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
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
                for(unsigned int i = dLength/2; i < dLength; i+=2) {
                    valType each_real = real_vals[2];
                    valType each_imag = imag_vals[2];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
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
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
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
                int dIndex = 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength/2; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
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
                for(unsigned int i = dLength/2; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[2];
                        valType each_imag = imag_vals[2];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
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
                for(unsigned int i = 0; i < dLength; i++) {
                    if( i% 2 != 0) {
                        valType each_real = real_vals[1];
                        valType each_imag = imag_vals[1];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
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
                int dIndex = q_diff_exp;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i+=2) {
                    valType each_real = real_vals[0];
                    valType each_imag = imag_vals[0];
                    if(each_real != 0 || each_imag != 0) {
                        #pragma omp parallel for
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
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
                        for(unsigned int j = 0; j < after; j++) {
                            // newDiag_real_vals[j + i * n] = each_real;
                            // newDiag_imag_vals[j + i * n] = each_imag;
                            // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                            unsigned int x_idx, y_idx;
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
                int dIndex = q_diff_exp + 1;
                unsigned int dLength = getDiagonalLength(dIndex, new_gate_shape);
                // do something
                for(unsigned int i = 0; i < dLength; i++) {
                    if(i % 2 == 0) {
                        valType each_real = real_vals[0];
                        valType each_imag = imag_vals[0];
                        if(each_real != 0 || each_imag != 0) {
                            #pragma omp parallel for
                            for(unsigned int j = 0; j < after; j++) {
                                // newDiag_real_vals[j + i * n] = each_real;
                                // newDiag_imag_vals[j + i * n] = each_imag;
                                // do SPMV for these newDiag_real_vals and newDiag_imag_vals
                                unsigned int x_idx, y_idx;
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

std::shared_ptr<diaQMatrix> matrix_kron_identity(std::shared_ptr<diaQMatrix> A, unsigned int n) { // we can combine this with operations that happen later.

    #ifdef DEBUG
        // start timer
        printf("starting matrix_kron_identity -- ");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    n = 1L << n;

    // assume a nxn identity matrix, which has one diagonal of length n, in index 0.
    // we just repeat A, n times in the result matrix
    std::array<unsigned int, 2> result_shape = {n * A->matrix_shape[0], n * A->matrix_shape[1]};
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > diagMap = A->diagonalMap;
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    #pragma omp parallel for
    for(unsigned int di = 0; di < diagMap.size(); di++) {
        auto it = std::next(diagMap.begin(), di);
        int dIndex = it->first;
        std::shared_ptr<diagonal> diag = it->second;
        unsigned int dLength = diag->dLength;
        // printf("dIndex = %ld; dLength = %ld\n", dIndex, dLength);
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        // result diag
        // std::shared_ptr<diagonal> newDiag = new diagonal(dIndex * n, result->getDiagonalLength(dIndex * n));
        std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(dIndex * n, result->getDiagonalLength(dIndex * n));

        valType *newDiag_real_vals = newDiag->realValues;
        valType *newDiag_imag_vals = newDiag->imagValues;

        #pragma omp parallel for collapse(2)
        for(unsigned int j = 0; j < n; j++) {
            for(unsigned int i = 0; i < dLength; i++) {
                newDiag_real_vals[j + i * n] = real_vals[i];
                newDiag_imag_vals[j + i * n] = imag_vals[i];
            }
        }
        // #pragma omp critical
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

    // A->free();

    return result;
}

std::shared_ptr<diaQMatrix> identity_kron_matrix_kron_identity(unsigned int before, std::shared_ptr<diaQMatrix> A, unsigned int after) {
    #ifdef DEBUG
        printf("starting identity_kron_matrix_kron_identity -- ");
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

    unsigned int before_N = 1L << before;
    unsigned int after_N = 1L << after;

    std::array<unsigned int, 2> result_shape = {before_N * A->matrix_shape[0] * after_N, before_N * A->matrix_shape[1] * after_N};
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);
    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator it;

    // // #pragma omp parallel for
    // for(int di = 0; di < diagMap.size(); di++) {
    //     auto it = std::next(diagMap.begin(), di);
    //     int dIndex = it->first;
    //     std::shared_ptr<diagonal> diag = it->second;
    //     int dLength = diag->dLength;
    //     valType *real_vals = diag->realValues;
    //     valType *imag_vals = diag->imagValues;

    //     int new_diag_index = dIndex * after_N;
    //     int new_diag_length = result->getDiagonalLength(new_diag_index);
    //     std::shared_ptr<diagonal> newDiag = new diagonal(new_diag_index, new_diag_length);
    //     valType *newDiag_real_vals = newDiag->realValues;
    //     valType *newDiag_imag_vals = newDiag->imagValues;

    //     // #pragma omp parallel for
    //     for(int rep = 0; rep < before_N; rep++) {
    //         int skip_places = (rep) * (dLength + abs(new_diag_index));
    //         // #pragma omp parallel for
    //         for(unsigned int i = 0; i < dLength; i++) {
    //             newDiag_real_vals[i + skip_places] = real_vals[i];
    //             newDiag_imag_vals[i + skip_places] = imag_vals[i];
    //         }
    //     }
    
    //     #pragma omp critical
    //     result->setDiagonal(dIndex * after_N, newDiag);
    // }

    #pragma omp parallel for
    for(unsigned int di = 0; di < A->diagonalMap.size(); di++) {
        auto it = std::next(A->diagonalMap.begin(), di);
        int dIndex = it->first;
        std::shared_ptr<diagonal> diag = it->second;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;
        unsigned int dLength = diag->dLength;

        int new_diag_index = dIndex * after_N;
        unsigned int new_diag_length = result->getDiagonalLength(new_diag_index);
        // std::shared_ptr<diagonal> newDiag = new diagonal(new_diag_index, new_diag_length);
        std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(new_diag_index, new_diag_length);
        valType *newDiag_real_vals = newDiag->realValues;
        valType *newDiag_imag_vals = newDiag->imagValues;

        #pragma omp parallel for
        for(unsigned int rep = 0; rep < before_N; rep++) {
            unsigned int skip_places = rep * (after_N * (dLength + abs(dIndex)));
            #pragma omp parallel for
            for(unsigned int i = 0; i < dLength; i++) {
                valType each_real = real_vals[i];
                valType each_imag = imag_vals[i];
                if(each_real != 0 || each_imag != 0) {
                    #pragma omp parallel for
                    for(unsigned int j = 0; j < after_N; j++) {
                        unsigned int new_idx = skip_places + i * after_N + j;
                        newDiag_real_vals[new_idx] = each_real;
                        newDiag_imag_vals[new_idx] = each_imag;
                    }
                }
            }
        }
        // #pragma omp critical
        result->setDiagonal(new_diag_index, newDiag);
    }

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        printf("\t\t identity_kron_matrix_kron_identity took %.3f milliseconds\n", duration.count() / 1000.0);
    #endif

    // A->free();

    return result;
}

std::shared_ptr<diaQMatrix> kron_product_old(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B) {
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

    std::array<unsigned int, 2> shape_a = A->matrix_shape;
    std::array<unsigned int, 2> shape_b = B->matrix_shape;

    // map of combination of A diagonal index, A diagonal position to multiply_by_scalar matrix. The individual blocks of matrices: A11 * B, A12 * B, A21 * B, A22 * B, ...
    std::map<std::pair<int, int>, std::pair<valType, valType>> kron_map;

    // map of unique A elements and their corresponding kron blocks
    std::map<std::pair<valType, valType>, std::shared_ptr<diaQMatrix> > unique_kron_blocks;

    // Calculate dimensions for the resulting matrix
    std::array<unsigned int, 2> result_shape;
    result_shape[0] = shape_a[0] * shape_b[0];
    result_shape[1] = shape_a[1] * shape_b[1];
    // std::shared_ptr<diaQMatrix> result = new diaQMatrix(&result_shape);
    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(result_shape);

    phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itA;

    // printf("kron here 0\n");

    // for each element in A, do multiply_by_scalar with B and add to kron_list.
    // paralleize this later. TODO
    for (itA = A->diagonalMap.begin(); itA != A->diagonalMap.end(); itA++) {
        int diagonal_index = itA->first;
        std::shared_ptr<diagonal> diag = itA->second;
        unsigned int diagonal_length = diag->dLength;

        #pragma omp parallel for
        for(unsigned int diagonal_position = 0; diagonal_position < diagonal_length; diagonal_position++) {
            // skippihg zero elements
            if(diag->realValues[diagonal_position] == 0.0 && diag->imagValues[diagonal_position] == 0.0) {
                continue;
            }

            // printf("kron here 1\n");

            std::shared_ptr<diaQMatrix> kron_block;
            // dynamic programming for unique kron blocks
            if(unique_kron_blocks.find(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position])) == unique_kron_blocks.end()) {
                kron_block = multiply_by_scalar(B, diag->realValues[diagonal_position], diag->imagValues[diagonal_position]);
                // printf("printing kron_block\n");
                // kron_block->print();
                // store in unique_kron_blocks
                unique_kron_blocks.insert(std::pair<std::pair<valType, valType>, std::shared_ptr<diaQMatrix> >(std::pair<valType, valType>(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]), kron_block));
            }

            // printf("kron here 2\n");

            std::array<unsigned int, 2> A_pos = A->getMatrixPosition(diagonal_index, diagonal_position);
            std::pair<int, int> key = std::make_pair(A_pos[0], A_pos[1]);
            std::pair<valType, valType> val = std::make_pair(diag->realValues[diagonal_position], diag->imagValues[diagonal_position]);
            kron_map.insert(std::pair<std::pair<int, int>, std::pair<valType, valType>>(key, val));
        }
    }
    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << "kron_map.size() = " << kron_map.size() << std::endl;
        std::cout << " --- " << std::endl;
    #endif

    // pre-allocate resutl's diagonals and paralleize this below later,! TODO

    // traverse kron_map and add to result.
    std::map<std::pair<int, int>, std::pair<valType, valType>>::iterator it;
    #pragma omp parallel
    {
        #pragma omp single
        for (it = kron_map.begin(); it != kron_map.end(); it++) {
            #pragma omp task
            {
                // for each element in A
                int A_mat_pos[2];
                A_mat_pos[0] = it->first.first;
                A_mat_pos[1] = it->first.second;
                // get kron_block from unique_kron_blocks
                std::shared_ptr<diaQMatrix> kron_block = unique_kron_blocks.find(it->second)->second;

                // we now have to add to result's res_diag_index at res_diag_pos
                phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> > kron_block_diagMap = kron_block->diagonalMap;
                phmap::parallel_flat_hash_map<int, std::shared_ptr<diagonal> >::iterator itK;

                #pragma omp parallel
                {
                    #pragma omp single
                    for (itK = kron_block_diagMap.begin(); itK != kron_block_diagMap.end(); itK++) {
                        #pragma omp task
                        {
                            int kron_block_diag_index = itK->first;
                            std::shared_ptr<diagonal> kron_block_diag = itK->second;
                            unsigned int kron_block_diag_length = kron_block_diag->dLength;

                            #pragma omp parallel for
                            for(unsigned int kron_block_diag_position = 0; kron_block_diag_position < kron_block_diag_length; kron_block_diag_position++) {

                                std::array<unsigned int, 2> B_mat_pos = kron_block->getMatrixPosition(kron_block_diag_index, kron_block_diag_position);
                                std::array<unsigned int, 2> res_mat_pos = result->getMatrixPosition(A_mat_pos[0] * shape_b[0] + B_mat_pos[0], A_mat_pos[1] * shape_b[1] + B_mat_pos[1]);
                                std::array<int, 2> res_diag_pos = result->getDiagonalPosition(res_mat_pos);

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
    // diaQMatrix result = denseC.convertToDiaQ(denseC->shape);

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

std::shared_ptr<diaQMatrix> kron_product(std::shared_ptr<diaQMatrix> A, std::shared_ptr<diaQMatrix> B, valType c) {
    return multiply_by_scalar(kron_product(A, B), c, 1.0);
}

std::shared_ptr<diaQMatrix> dagger(std::shared_ptr<diaQMatrix> A) {
    // dagger is conjugate transpose
    // conjugate first
    std::shared_ptr<diaQMatrix> res = multiply_by_scalar(A, 1.0, -1.0);
    // then transpose
    return transpose(res);
}

std::shared_ptr<diaQMatrix> conjbar(std::shared_ptr<diaQMatrix> A) {
    return multiply_by_scalar(A, 1.0, -1.0);
}

std::shared_ptr<vector> diaQMatrix::multiplyVector(std::shared_ptr<vector> V) {
    return spMV(shared_from_this(), V);
}

std::shared_ptr<diaQMatrix> expm_negative_taylor(std::shared_ptr<diaQMatrix> A, valType t) {
    // Computes e^(-i * A * t) using the Taylor series expansion
    // e^(-i * A * t) ≈ I - i * A * t + (-i * A * t)^2 / 2! + (-i * A * t)^3 / 3! + ...
    // Stops when terms become negligibly small or reach a max iteration count.

    #ifdef DEBUG
        printf("starting expm_negative_taylor -- ");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    // Initialize result and create 0th diagonal
    std::shared_ptr<identityMatrix> result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

    if(A->num_diags() == 1 && A->getDiagonal(0) != nullptr) {

        std::shared_ptr<diagonal> d = A->getDiagonal(0);
        unsigned int dLength = d->dLength;
        valType *real_vals = d->realValues;
        valType *imag_vals = d->imagValues;

        std::shared_ptr<diagonal> res_diag = result->getDiagonal(0);
        valType *res_real_vals = res_diag->realValues;
        valType *res_imag_vals = res_diag->imagValues;

        // Compute exact exp(-i A t) for diagonal elements
        #pragma omp parallel for
        for (unsigned int i = 0; i < dLength; i++) {
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
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\t expm_negative_taylors took %f milliseconds\n", duration.count() / 1000.0);
        #endif

        return result;
    }

    // Parameters
    int max_iterations = 100; // Limit to avoid infinite loops
    valType tolerance = 1e-8; // Tolerance for convergence

    std::shared_ptr<diaQMatrix> X = A->copy_and_scale_by_imag(-1.0 * t);
    // printf("X\n");
    // X->print();

    // std::shared_ptr<diaQMatrix> X_power_i_whole_divided_by_i = new identityMatrix(A->matrix_shape[0]); // X pwoer 0 / 0! // result is already identity matrix currently
    std::shared_ptr<diaQMatrix> X_power_i_whole_divided_by_i = std::make_shared<identityMatrix>(A->matrix_shape[0]);
    // printf("X_power_i_whole_divided_by_i\n");
    // X_power_i_whole_divided_by_i->print_meta();

    for(int i = 1; i <= max_iterations; i++) {
        X_power_i_whole_divided_by_i = product(X_power_i_whole_divided_by_i, X);
        // printf("X_power_i_whole_divided_by_i 0 \n");
        // X_power_i_whole_divided_by_i->print();
        X_power_i_whole_divided_by_i->divide_by_int(i);
        // printf("X_power_i_whole_divided_by_i 1\n");
        // X_power_i_whole_divided_by_i->print();
        result->add(X_power_i_whole_divided_by_i);
        // printf("result\n");
        // result->print();
        if(X_power_i_whole_divided_by_i->norm() < tolerance) {
            break;
        }
    }
    #ifdef DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            printf("\t\t expm_negative took %f milliseconds\n", duration.count() / 1000.0);
    #endif

    return result;
}

std::shared_ptr<diaQMatrix> expm_negative_pade(std::shared_ptr<diaQMatrix> A, valType t) {
    #ifdef DEBUG
        printf("starting expm_negative_pade -- ");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    std::shared_ptr<diaQMatrix> result = std::make_shared<diaQMatrix>(A->matrix_shape[0]);

    // Efficient case: If A is purely diagonal, compute exact exponential
    if (A->num_diags() == 1 && A->getDiagonal(0) != nullptr) {
        result->createDiagonal(0);

        std::shared_ptr<diagonal> d = A->getDiagonal(0);
        unsigned int dLength = d->dLength;
        valType *real_vals = d->realValues;
        valType *imag_vals = d->imagValues;

        std::shared_ptr<diagonal> res_diag = result->getDiagonal(0);
        valType *res_real_vals = res_diag->realValues;
        valType *res_imag_vals = res_diag->imagValues;

        #pragma omp parallel for
        for (unsigned int i = 0; i < dLength; i++) {
            valType t_a = t * real_vals[i];
            valType t_b = t * imag_vals[i];

            valType exp_b = std::exp(t_b);
            valType cos_ta = std::cos(t_a);
            valType sin_ta = std::sin(t_a);

            res_real_vals[i] = exp_b * cos_ta;
            res_imag_vals[i] = -exp_b * sin_ta;
        }

        #ifdef DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            printf("\t\t expm_negative_pade took %f milliseconds\n", std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0);
        #endif

        return result;
    }

    constexpr valType pade_numer[7] = {1.0, 1.0, 0.5, 0.16666666666667, 0.04166666666667, 0.00833333333333, 0.00138888888889};
    constexpr valType pade_denom[7] = {1.0, 0.5, 0.16666666666667, 0.04166666666667, 0.00833333333333, 0.00138888888889, 0.00019841269841};

    // Compute norm of A
    valType norm_A = A->norm() * std::abs(t);
    int s = std::max(0, static_cast<int>(std::ceil(std::log2(norm_A / 5.4)))); // Scaling heuristic

    // Scale down A: A_s = (-i * t * A) / 2^s
    std::shared_ptr<diaQMatrix> A_s = A->copy_and_scale_by_imag(-1.0 * t / std::pow(2, s));

    #ifdef DEEP_DEBUG
        printf("A_s\n");
        A_s->print();
    #endif

    // Compute Padé approximation of e^X
    std::shared_ptr<diaQMatrix> U = std::make_shared<identityMatrix>(A->matrix_shape[0]);
    std::shared_ptr<diaQMatrix> V = std::make_shared<identityMatrix>(A->matrix_shape[0]);
    std::shared_ptr<diaQMatrix> X_power = A_s->copy(); // X^1

    for (int k = 1; k <= 6; k++) { // Degree-13 approximation (only need terms up to 6)
        X_power = product(X_power, A_s); // Compute X^(2k+1)
        U->addMatrixScaled(X_power, pade_numer[k]); // Add to U numerator
        V->addMatrixScaled(X_power, pade_denom[k]); // Add to V denominator
    }

    #ifdef DEEP_DEBUG
        printf("U: \n");
        U->print();
        printf("V: \n");
        V->print();
    #endif

    // Solve (V - U)X = V + U
    std::shared_ptr<diaQMatrix> V_minus_U = V->subtractMatrix(U);

    #ifdef DEEP_DEBUG
        printf("V_minus_U\n");
        V_minus_U->print();
    #endif

    std::shared_ptr<diaQMatrix> V_plus_U = V->addMatrix(U);

    #ifdef DEEP_DEBUG
        printf("V_plus_U\n");
        V_plus_U->print();
    #endif

    std::shared_ptr<diaQMatrix> inv_VmU = V_minus_U->inverse();

    #ifdef DEEP_DEBUG
        printf("inv_VmU\n");
        inv_VmU->print();
    #endif

    result = product(inv_VmU, V_plus_U);

    #ifdef DEEP_DEBUG
        printf("expA_s\n");
        result->print();
    #endif

    // Scale back using squaring
    for (int i = 0; i < s; i++) {
        result = product(result, result);
    }

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        printf("\t\t expm_negative_pade took %f milliseconds\n", std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0);
    #endif

    return result;
}

std::shared_ptr<vector> bicgstab_solve(std::shared_ptr<diaQMatrix> A, std::shared_ptr<vector> b, valType tol, int max_iter) {
    unsigned int n = b->numRows;

    std::shared_ptr<vector> x = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> p = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> v = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> s = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> t = std::make_shared<vector>(n, 0.0);
    std::shared_ptr<vector> p_old = std::make_shared<vector>(n, 0.0);

    std::shared_ptr<vector> r = b->subtract(A->multiplyVector(x));  // Initial residual
    std::shared_ptr<vector> r_tilde = r->copy();

    valType rho = 1.0, alpha = 1.0, omega = 1.0;

    for (int iter = 0; iter < max_iter; iter++) {
        valType rho_new = r_tilde->dot(r);
        if (std::abs(rho_new) < 1e-14) break;

        valType beta = (rho_new / rho) * (alpha / omega);
        rho = rho_new;

        #pragma omp parallel for
        for (unsigned int i = 0; i < n; i++) {
            // p[i] = r[i] + beta * (p_old[i] - omega * v[i]);
            p->realValues[i] = r->realValues[i] + beta * (p_old->realValues[i] - omega * v->realValues[i]);
            p->imagValues[i] = r->imagValues[i] + beta * (p_old->imagValues[i] - omega * v->imagValues[i]);
        }

        v = A->multiplyVector(p);
        alpha = rho / r_tilde->dot(v);

        #pragma omp parallel for
        for (unsigned int i = 0; i < n; i++) {
            s->realValues[i] = r->realValues[i] - alpha * v->realValues[i];
            s->imagValues[i] = r->imagValues[i] - alpha * v->imagValues[i];
        }

        if (s->norm() < tol) {

            #pragma omp parallel for
            for (unsigned int i = 0; i < n; i++) {
                // x[i] += alpha * p[i];
                x->realValues[i] += alpha * p->realValues[i];
                x->imagValues[i] += alpha * p->imagValues[i];
            }
            break;
        }

        t = A->multiplyVector(s);
        omega = t->dot(s) / t->dot(t);
        
        #pragma omp parallel for
        for (unsigned int i = 0; i < n; i++) {
            // x[i] += alpha * p[i] + omega * s[i];
            // r[i] = s[i] - omega * t[i];
            x->realValues[i] += alpha * p->realValues[i] + omega * s->realValues[i];
            x->imagValues[i] += alpha * p->imagValues[i] + omega * s->imagValues[i];

            r->realValues[i] = s->realValues[i] - omega * t->realValues[i];
            r->imagValues[i] = s->imagValues[i] - omega * t->imagValues[i];
        }

        if (r->norm() < tol) break;
    }

    return x;
}

std::shared_ptr<diaQMatrix> diaQMatrix::inverse() {
    // matrix inverse!
    // has to be square!!

    #ifdef DEBUG
        printf("starting inverse -- ");
        auto start = std::chrono::high_resolution_clock::now();
    #endif

    std::shared_ptr<diaQMatrix> inv_matrix = std::make_shared<diaQMatrix>(this->matrix_shape[0], this->matrix_shape[1]);

    // Efficient case: If A is purely diagonal, principal
    if (num_diags() == 1 && getDiagonal(0) != nullptr) {
        std::shared_ptr<diagonal> diag = this->getDiagonal(0);
        unsigned int dLength = diag->dLength;
        valType *real_vals = diag->realValues;
        valType *imag_vals = diag->imagValues;

        // Create the inverse matrix
        inv_matrix->createDiagonal(0);
        std::shared_ptr<diagonal> inv_diag = inv_matrix->getDiagonal(0);

        valType *inv_real_vals = inv_diag->realValues;
        valType *inv_imag_vals = inv_diag->imagValues;

        #pragma omp parallel for
        for (unsigned int i = 0; i < dLength; i++) {
            valType a_i = real_vals[i];
            valType b_i = imag_vals[i];

            // Compute the complex reciprocal (1 / (a + ib))
            valType denom = a_i * a_i + b_i * b_i;
            if (denom == 0.0) {
                throw std::runtime_error("Matrix is singular, cannot compute inverse.");
            }

            inv_real_vals[i] = a_i / denom;
            inv_imag_vals[i] = -b_i / denom;
        }

        #ifdef DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            std::cout << "\t\t inverse took " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0 << " milliseconds" << std::endl;
        #endif

        return inv_matrix;
    }

    // Solve for each column of the identity matrix
    for (unsigned int col = 0; col < matrix_shape[1]; col++) {
        std::shared_ptr<vector> b = std::make_shared<vector>(matrix_shape[1], 0.0);
        b->realValues[col] = 1.0;

        std::shared_ptr<vector> x = bicgstab_solve(shared_from_this(), b, 1e-10, 1000);

        // Store the solution x as the corresponding column in inv_matrix
        for (unsigned int row = 0; row < matrix_shape[0]; row++) {
            inv_matrix->set(row, col, x->realValues[row], x->imagValues[row]);
        }
    }

    #ifdef DEEP_DEBUG
        printf("inverse done: ");
        inv_matrix->print();
    #endif

    #ifdef DEBUG
        auto end = std::chrono::high_resolution_clock::now();
        std::cout << "\t\t inverse took " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0 << " milliseconds" << std::endl;
    #endif

    return inv_matrix;

}

} // namespace diaq