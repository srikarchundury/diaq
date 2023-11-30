#include "diaQMatrix.hpp"
#include "denseMatrix.hpp"
#include "vector.hpp"

#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

// ----------------------------------------------------------------
//
// SIMD
//
// ----------------------------------------------------------------
#ifdef __AVX__
	#include <immintrin.h>
    __m256 load_partial(long int n, const float* p) {
        // Initialize a mask with all bits set to 1
        __m256i mask = _mm256_set1_epi32(-1);

        // Create a mask based on the length 'n' of the array
        // Set the corresponding bits to 0 for elements beyond the array length
        int maskValue = (1 << n) - 1;
        mask = _mm256_cmpgt_epi32(_mm256_set1_epi32(n), _mm256_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7));

        // Load the array elements into the YMM register using the mask
        __m256 ymm = _mm256_maskload_ps(p, mask);

        return ymm;
    }
	void store_partial(long int n, float *loc, __m256 vec) {
		#pragma unroll
		for(long int i = 0; i < n; i++) {
			loc[i] = vec[i];
		}
	}
#endif

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
long int getDiagonalLength(long int dIndex, std::vector<long int> shape) {
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
diagonal multiplyDiagonals(std::vector<long int> shapeA, std::vector<long int> shapeB, long int indexA, long int indexB, diagonal diagA, diagonal diagB) {
    if(indexA + indexB >= shapeB[1]) {
        return diagonal(0, 0);
    }
    else if(indexA + indexB <= -1 * shapeA[0]) {
        return diagonal(0, 0);
    }
    long int lenDiagA = diagA.dLength;
    long int lenDiagB = diagB.dLength;
    // result matrix has dimensions {shapeA[0], shapeB[1]}
    std::vector<long int> res_dims{shapeA[0], shapeB[1]};
    long int lenRes = getDiagonalLength(indexA + indexB, res_dims);
    diagonal res(indexA + indexB, lenRes);
    // std::cout << "diagonal length = " << lenRes << std::endl;
    long int offsetA = abs(indexA);
    long int offsetB = abs(indexB);
    long int jump = 0;
    if(indexA > 0) {
        if(indexB > 0) {
            offsetB = offsetA;
            offsetA = 0;
        }
        else if(indexB < 0) {
            // std::cout << "jump,offsetA,offsetB " << jump << "," << offsetA << "," << offsetB << std::endl;
            if(offsetA > offsetB) {
                offsetB = abs(indexA + indexB);
                offsetA = 0;
            }
            else {
                offsetA = abs(indexA + indexB);
                offsetB = 0;
            }
        }
        else if(indexB == 0) {
            offsetB = offsetA;
            offsetA = 0;
        }
    }
    else if(indexA < 0) {
        if(indexB > 0) {
            // std::cout << "jump,offsetA,offsetB " << jump << "," << offsetA << "," << offsetB << std::endl;
            // std::cout << "lenDiagA,lenDiagB,lenRes " << lenDiagA << "," << lenDiagB << "," << lenRes << std::endl;
            // jump decides how many positions to skip for each diagonal, depends on the length of the shorter diagonal.
            if(lenDiagB < lenDiagA) {
                jump = lenRes - lenDiagB;
            }
            else if(lenDiagA < lenDiagB) {
                jump = lenRes - lenDiagA;
            }
            else {
                if(indexA + indexB < 0) {
                    // jump = abs(indexA) - abs(shapeA[0] - shapeB[1]);
                    jump = abs(indexB);
                } else {
                    jump = abs(indexA);
                }
            }
            offsetA = 0;
            offsetB = 0;
        }
        else if(indexB < 0) {
            offsetA = offsetB;
            offsetB = 0;
        }
        else if(indexB == 0) {
            offsetA = 0;
            offsetB = 0;
        }
    }
    else if(indexA == 0) {
        if(indexB > 0) {
            offsetA = 0;
            offsetB = 0;
        }
        else if(indexB < 0) {
            offsetA = offsetB;
            offsetB = 0;
        }
        else if(indexB == 0) {
            offsetA = 0;
            offsetB = 0;
        }
    }
    long int k = 0;
    if(jump != 0) {
        k += jump;
    }
	float *real_vals_a = diagA.getRealValues();
    float *imag_vals_a = diagA.getImagValues();
    float *real_vals_b = diagB.getRealValues();
    float *imag_vals_b = diagB.getImagValues();
	float *real_vals_final = res.getRealValues();
    float *imag_vals_final = res.getImagValues();
    // std::cout << "k=" << k << std::endl;
    // std::cout << "lenRes,jump,offsetA,offsetB " << lenRes << "," << jump << "," << offsetA << "," << offsetB << std::endl;
    #ifdef __AVX__
    // SIMD vectorization
    std::cout << "AVX vectorization" << std::endl;
    long int loop_count = 0;
    long int k_cpy = k;
    while (k_cpy < lenRes && k_cpy + offsetA - jump < lenDiagA && k_cpy + offsetB - jump < lenDiagB) {
        loop_count++;
        k_cpy++;
    }

    __m256 real_a, real_b; // a for valuesA and b for valuesB
    __m256 imag_a, imag_b; // a for valuesA and b for valuesB
    __m256 real_reala_realb, real_imaga_imagb, real_res, imag_reala_imagb, imag_imaga_realb, imag_res;

    long int left_overs = loop_count - ((loop_count / 8) * 8);
    long int vec_loop = (loop_count / 8);
    long int left_overs_start_at_A = k + offsetA - jump + 8 * (loop_count / 8);
    long int left_overs_start_at_B = k + offsetB - jump + 8 * (loop_count / 8);

    while (vec_loop--) {
        real_a = _mm256_loadu_ps(&real_vals_a[k + offsetA - jump]);
        imag_a = _mm256_loadu_ps(&imag_vals_a[k + offsetA - jump]);
        real_b = _mm256_loadu_ps(&real_vals_b[k + offsetB - jump]);
        imag_b = _mm256_loadu_ps(&imag_vals_b[k + offsetB - jump]);

        real_reala_realb = _mm256_mul_ps(real_a, real_b);
        real_imaga_imagb = _mm256_mul_ps(imag_a, imag_b);
        real_res = _mm256_sub_ps(real_reala_realb, real_imaga_imagb);

        imag_reala_imagb = _mm256_mul_ps(real_a, imag_b);
        imag_imaga_realb = _mm256_mul_ps(imag_a, real_b);
        imag_res = _mm256_add_ps(imag_reala_imagb, imag_imaga_realb);

        store_partial(8, &real_vals_final[k], real_res);
        store_partial(8, &imag_vals_final[k], imag_res);

        k += 8;
    }

    if (left_overs != 0) {
        real_a = load_partial(left_overs, &real_vals_a[left_overs_start_at_A]);
        imag_a = load_partial(left_overs, &imag_vals_a[left_overs_start_at_A]);
        real_b = load_partial(left_overs, &real_vals_b[left_overs_start_at_B]);
        imag_b = load_partial(left_overs, &imag_vals_b[left_overs_start_at_B]);

        real_reala_realb = _mm256_mul_ps(real_a, real_b);
        real_imaga_imagb = _mm256_mul_ps(imag_a, imag_b);
        real_res = _mm256_sub_ps(real_reala_realb, real_imaga_imagb);

        imag_reala_imagb = _mm256_mul_ps(real_a, imag_b);
        imag_imaga_realb = _mm256_mul_ps(imag_a, real_b);
        imag_res = _mm256_add_ps(imag_reala_imagb, imag_imaga_realb);

        store_partial(left_overs, &real_vals_final[k], real_res);
        store_partial(left_overs, &imag_vals_final[k], imag_res);

        k += left_overs;
    }
    #endif
	#ifndef __AVX__
	// no vectorization
    while(k < lenRes && k + offsetA - jump < lenDiagA && k + offsetB - jump < lenDiagB) {
        // std::cout << "loop k=" << k << std::endl;
		float real_a = real_vals_a[k + offsetA - jump];
        float imag_a = imag_vals_a[k + offsetA - jump];
        float real_b = real_vals_b[k + offsetB - jump];
        float imag_b = imag_vals_b[k + offsetB - jump];
		real_vals_final[k] = (float)((double)(real_a * real_b) - (double)(imag_a * imag_b));
		imag_vals_final[k] = (float)((double)(real_a * imag_b) + (double)(imag_a * real_b));
        k += 1;
    }
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
diaQMatrix product(diaQMatrix A, diaQMatrix B) {
    #ifdef CUDA_ENABLED
        return product_cuda(&A, &B);
    #else
    // A.print();
    // B.print();
    if(A.matrix_shape[1] != B.matrix_shape[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    std::vector<long int> d{A.matrix_shape[0], B.matrix_shape[1]};
    diaQMatrix* result = new diaQMatrix(&d);
    // diaQMatrix* resptr = &result;
    std::map<long int, diagonal> mapA = A.getDiagonalMap();
    std::map<long int, diagonal> mapB = B.getDiagonalMap();
    std::map<long int, diagonal>::iterator itA, itB;
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        for (itB = mapB.begin(); itB != mapB.end(); itB++) {
            // std::cout << " ------ diags ------ " << std::endl;
            // itA->second.print();
            // itB->second.print();
            // std::cout << " ------ diags ------ " << std::endl;
            // std::cout << " --- " << std::endl;
            diagonal diagNew = multiplyDiagonals(A.matrix_shape, B.matrix_shape, itA->first, itB->first, itA->second, itB->second);
            if(diagNew.dLength != 0 && !diagNew.isEmpty()) {
                // std::cout << " ------ new diag ------ " << std::endl;
                // diagNew.print();
                // std::cout << " ------ new diag ------ " << std::endl;
                result->addDiagonal(itA->first + itB->first, diagNew);
                // std::cout << " ------ result ------ " << std::endl;
                // result->print();
                // std::cout << " ------ result ------ " << std::endl;
            } else {
                // std::cout << "diagonal does not exist" << std::endl;
            }
        }
    }
    result->pruneMatrix();
    // std::cout << " ------ final result ------ " << std::endl;
    // result->print();
    // std::cout << " ------ final result ------ " << std::endl;
    // result->print();
    return *result;
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
denseMatrix denseProduct(denseMatrix A, denseMatrix B) {
    std::vector<long int> shape_a = A.matrix_shape;
    std::vector<long int> shape_b = B.matrix_shape;
    if(shape_a[1] != shape_b[0]) {
        throw std::invalid_argument("input matrices are not multiplyable");
    }
    float *real_res = (float *)calloc(shape_a[0] * shape_b[1], sizeof(float));
    float *imag_res = (float *)calloc(shape_a[0] * shape_b[1], sizeof(float));
    std::vector<long int> d{A.matrix_shape[0], B.matrix_shape[1]};
    denseMatrix result(&d, real_res, imag_res);
    for(long int i = 0; i < shape_a[0]; i++) {
        for(long int k = 0; k < shape_b[1]; k++) {
            std::complex<float> res = 0.0;
            for(long int j = 0; j < shape_b[0]; j++) {
                res += A.get(i, j) * B.get(j, k);
            }
            result.set(i, k, res);
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
diagonal addElements(diagonal A, diagonal B) {
    float *real_valsA = A.getRealValues();
    float *imag_valsA = A.getImagValues();
    float *real_valsB = B.getRealValues();
    float *imag_valsB = B.getImagValues();
    if(A.dLength != B.dLength ) {
        throw std::invalid_argument("diagonals are of different lengths!");
    }
    float *real_valsC = (float *)calloc(A.dLength, sizeof(float));
    float *imag_valsC = (float *)calloc(A.dLength, sizeof(float));
    #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
    for(long int i=0; i < A.dLength; i++) {
        real_valsC[i] = real_valsA[i] + real_valsB[i];
        imag_valsC[i] = imag_valsA[i] + imag_valsB[i];
    }
    return diagonal(A.dIndex, A.dLength, real_valsC, imag_valsC);
}

diaQMatrix add(diaQMatrix A, diaQMatrix B) {
    if(A.getSize() != B.getSize()) {
        throw std::invalid_argument("input matrices are of different dimensions, not compatible");
    }
    diaQMatrix* result = new diaQMatrix(A.getSize());
    std::map<long int, diagonal> mapA = A.getDiagonalMap();
    std::map<long int, diagonal> mapB = B.getDiagonalMap();
    std::map<long int, diagonal>::iterator itA, itB;
    for (itA = mapA.begin(); itA != mapA.end(); itA++) {
        itB = mapB.find(itA->first);
        if (itB == mapB.end()) {
            result->addDiagonal(itA->first, itA->second);
        } else {
            result->addDiagonal(itA->first, addElements(itA->second, itB->second));
        }
    }
    // result->pruneMatrix();
    return *result;
}


std::complex<float> trace(diaQMatrix A) {
    std::complex<float> t;
    std::map<long int, diagonal>::iterator itA;
    std::map<long int, diagonal> mapA = A.getDiagonalMap();
    itA = mapA.find(0);
    if(itA == mapA.end()) {
        return t;
    }
    for(long int i=0; i < itA->second.dLength; i++) {
        t += itA->second.getValue(i);
    }
    return t;
}

diaQMatrix reshape(diaQMatrix A, std::vector<long int> new_tensor_shape) {
    // std::cout << "diaq/reshape called with newshape (";
    // for(long int i = 0; i < new_tensor_shape.size()-1; i++) {
    //     std::cout << new_tensor_shape[i] << ",";
    // }
    // std::cout << new_tensor_shape[new_tensor_shape.size()-1] << ")" << std::endl;

    long int old_product = 1;
    #pragma unroll
    for(long int i=0; i < A.shape.size(); i++) old_product *= A.shape[i];
    long int new_product = 1;
    #pragma unroll
    for(long int i=0; i < new_tensor_shape.size(); i++) new_product *= new_tensor_shape[i];
    if(old_product != new_product) {
        std::cout << old_product << "!=" << new_product << std::endl;
        throw std::invalid_argument("cannot reshape long into given shape");
    }
    long int l = new_tensor_shape.size();
    // this shape is important! decides the length of diagonals! Hence, we have to re-write it to maximize length of diagonals, so that number of diagonls are minimized.
    std::vector<long int> new_shape;
    if(l > 2) {
        std::vector<long int> temp{1,1};
        new_shape = temp;
        long int i = l / 2;
        #pragma unroll
        for(long int r = 0; r<i ; r++) {
            new_shape[0] = new_shape[0] * new_tensor_shape[r];
        }
        #pragma unroll
        for(long int r = i; r<l ; r++) {
            new_shape[1] = new_shape[1] * new_tensor_shape[r];
        }
    } else {
        new_shape = new_tensor_shape;
    }
    std::map<long int, diagonal> newDiagMap;
    // TODO: allocate for all possible diaognal indices and it's lengths. To paralleize later.
    diaQMatrix res{newDiagMap, &new_shape, &new_tensor_shape};
    std::map<long int, diagonal> diagonalMap = A.getDiagonalMap();
    std::map<long int, diagonal>::iterator it;

    // Can't parallize this currently, .insert is thread-unsafe.
    for(long int i = -1 * res.matrix_shape[0]; i < res.matrix_shape[1]; i++) {
        res.createDiagonal(i);
    }

    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
        float *real_vals = it->second.getRealValues();
        float *imag_vals = it->second.getImagValues();
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < it->second.dLength; i++) {
            // std::cout << "(diagonal_idx, diagonal_pos) = (" << it->first << ", " << i << ")" << std::endl;
            // std::cout << "element = " << vals[i] << std::endl;
            std::vector<long int> ten_pos = A.getTensorPosition(it->first, i);
            // std::cout << "tensor index = (";
            // for(long int i = 0; i < ten_pos.size()-1; i++) {
            //     std::cout << ten_pos[i] << ",";
            // }
            // std::cout << ten_pos[ten_pos.size()-1] << ")" << std::endl;

            std::vector<long int> d_pos = res.getDiagonalPositionByFlatIndex(A.getFlatIndex(ten_pos));
            // std::cout << "(new_diagonal_idx, new_diagonal_pos) = (" << d_pos[0] << ", " << d_pos[1] << ")" << std::endl;
            long int d_len = getDiagonalLength(d_pos[0], res.matrix_shape);
            res.setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
            // std::cout << " -- " << std::endl;
        }
    }
    res.pruneMatrix();
    return res;
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

std::vector<long int> modifyTensorShape(std::vector<long int> tShape, std::vector<long int> axes) {
    std::vector<long int> nShape;
    int tShapeSize = tShape.size();
    if(axes.size() == 0) {
        nShape.resize(tShape.size(), 1);
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < tShape.size(); i++) {
            nShape[i] = tShape[tShapeSize - i - 1];
        }
    }
    else {
        nShape.resize(axes.size(), 1);
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < axes.size(); i++) {
            nShape[i] = tShape[axes[i]];
        }
    }
    return nShape;
}

diaQMatrix transpose(diaQMatrix A, std::vector<long int> new_order) {
    if(new_order.size() == 0) {
        new_order.resize(A.shape.size(), 1);
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < A.shape.size(); i++) {
            new_order[i] = A.shape.size() - i - 1;
        }
    }
    // std::cout << "diaq/transpose called with axes (";
    // for(long int i = 0; i < new_order.size()-1; i++) {
    //     std::cout << new_order[i] << ",";
    // }
    // std::cout << new_order[new_order.size()-1] << ")" << std::endl;

    // tranpose of the diagonals
    if(A.shape.size() == 2) {
        std::vector<long int> newShape{A.matrix_shape[1], A.matrix_shape[0]};
        std::map<long int, diagonal> diagMap = A.getDiagonalMap();
        std::map<long int, diagonal>::iterator it;
        std::map<long int, diagonal> newDiagMap;
        for (it = diagMap.begin(); it != diagMap.end(); it++) {
            newDiagMap.insert(std::pair<long int, diagonal>(-1 * it->first, it->second));
        }
        A.setDiagonalMap(newDiagMap);
        // swap A.shape[0] and A.shape[1] and similarly for matrix_shape.
        long int temp = A.shape[0];
        A.shape[0] = A.shape[1];
        A.shape[1] = temp;
        temp = A.matrix_shape[0];
        A.matrix_shape[0] = A.matrix_shape[1];
        A.matrix_shape[1] = temp;
        return A;
    }
    // otherwise, we have to do a lot of work
    // shape of result
    std::vector<long int> new_tensor_shape = modifyTensorShape(A.shape, new_order);
    // std::cout << "gives new_tensor_shape (";
    // for(long int i = 0; i < new_tensor_shape.size()-1; i++) {
    //     std::cout << new_tensor_shape[i] << ",";
    // }
    // std::cout << new_tensor_shape[new_tensor_shape.size()-1] << ")" << std::endl;
    // now, let's perform the transpose element by element
    long int l = new_tensor_shape.size();
    // this shape is important! decides the length of diagonals! Hence, we have to re-write it to maximize length of diagonals, so that number of diagonls are minimized.
    std::vector<long int> new_shape{1,1};
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
    std::map<long int, diagonal> newDiagMap;
    // TODO: allocate for all possible diaognal indices and it's lengths. To paralleize later.
    diaQMatrix res{newDiagMap, &new_shape, &new_tensor_shape};
    // iterate over all diagonals
    std::map<long int, diagonal>::iterator it;
    std::map<long int, diagonal> diagonalMap = A.getDiagonalMap();

    // #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
    for(long int i = -1 * res.matrix_shape[0]; i < res.matrix_shape[1]; i++) {
        res.createDiagonal(i);
    }

    for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {

        float *real_vals = it->second.getRealValues();
        float *imag_vals = it->second.getImagValues();

        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for(long int i = 0; i < it->second.dLength; i++) {
            // std::cout << "(diagonal_idx, diagonal_pos) = (" << it->first << ", " << i << ")" << std::endl;
            // std::cout << "element = " << vals[i] << std::endl;
            std::vector<long int> ten_pos = A.getTensorPosition(it->first, i);
            // std::cout << "tensor index = (";
            // for(long int i = 0; i < ten_pos.size()-1; i++) {
            //     std::cout << ten_pos[i] << ",";
            // }
            // std::cout << ten_pos[ten_pos.size()-1] << ")" << std::endl;

            // modify ten_pos to perform the transposition using the new_order
            std::vector<long int> new_ten_pos(new_order.size(), 1);
            // #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
            for(long int i=0; i < new_order.size(); i++) {
                new_ten_pos[i] = ten_pos[new_order[i]];
            }

            std::vector<long int> d_pos = res.getDiagonalPosition(new_ten_pos);
            // std::cout << "(new_diagonal_idx, new_diagonal_pos) = (" << d_pos[0] << ", " << d_pos[1] << ")" << std::endl;
            long int d_len = getDiagonalLength(d_pos[0], new_shape);
            res.setDiagonalElement(d_pos[0], d_pos[1], d_len, real_vals[i], imag_vals[i]);
            // std::cout << " -- " << std::endl;
        }
    }
    res.pruneMatrix();
    return res;
}

diaQMatrix tensordot(diaQMatrix A, diaQMatrix B, std::vector<std::vector<long int> > axes) {
    // std::cout << "--" << std::endl;
    // std::cout << "tensordot called for A - " << std::endl;
    // A.print();
    // std::cout << "and B - " << std::endl;
    // B.print();
    // std::cout << "with axes - " << " (";
    // long int i=0;
    // for(i=0; i<axes[0].size()-1; i++)
    //     std::cout << axes[0][i] << ",";
    // std::cout << axes[0][i] << ") and (";
    // for(i=0; i<axes[1].size()-1; i++)
    //     std::cout << axes[1][i] << ",";
    // std::cout << axes[1][i] << ")" << std::endl;
    // std::cout << "--" << std::endl;

    diaQMatrix res = diaQMatrix((long int)(0));
    // move axes
    std::vector<long int> order_A;
    std::vector<long int> order_B;
    #pragma unroll
    for(long int i = 0; i < axes[1].size(); i++)
        order_B.push_back(axes[1][i]);
    for(long int i = 0; i < A.shape.size(); i++) {
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
    for(long int i = 0; i < B.shape.size(); i++) {
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
    for(long int i=0;i<axes[0].size();i++) axes_0_product *= A.shape[axes[0][i]];
    long int axes_1_product = 1;
    #pragma unroll
    for(long int i=0;i<axes[1].size();i++) axes_1_product *= B.shape[axes[1][i]];

    A = transpose(A, order_A);
    // A.print();
    B = transpose(B, order_B);
    // B.print();

    long int totalA = A.matrix_shape[0] * A.matrix_shape[1];
    long int totalB = B.matrix_shape[0] * B.matrix_shape[1];

    // std::cout << "axes_0_product = " << axes_0_product << " axes_1_product = " << axes_1_product << std::endl;
    // These have to be equal right? Let's add a check
    if(axes_1_product != axes_0_product) {
        std::cout << "axes_1_product != axes_0_product i.e. " << axes_1_product << " != " << axes_0_product << std::endl;
        throw std::invalid_argument("invalid axes, can't perform tensordot");
    }

    std::vector<long int> new_shape_a{totalA / axes_0_product, axes_0_product};
    std::vector<long int> new_shape_b{axes_1_product, totalB / axes_1_product};

    diaQMatrix reshaped_A = reshape(A, new_shape_a);
    diaQMatrix reshaped_B = reshape(B, new_shape_b);

    // std::cout << "after reshape A - " << std::endl;
    // reshaped_A.convertToDenseMatrix(reshaped_A.shape).print();
    // std::cout << "and B - " << std::endl;
    // reshaped_B.convertToDenseMatrix(reshaped_B.shape).print();

    res = product(reshaped_A, reshaped_B);

    // calculating result's tensor_shape
    res.shape = newTensorShape(A.shape, B.shape, axes[0], axes[1]);
    res.pruneMatrix();
    return res;
}

diaQMatrix array(diaQMatrix A) {
    // std::cout << "array called for A - " << std::endl;
    // A.print();
    // TODO: unclear as of now what this mehthod should be doing
    return A;
}

diaQMatrix einsum(diaQMatrix A, std::vector<long int> axes) {
    std::cout << axes[0] << std::endl;
    return A;
}

// overloading operators
diaQMatrix operator*(const diaQMatrix &A, const diaQMatrix &B) {
    return product(A, B);
}
diaQMatrix operator+(const diaQMatrix &A, const diaQMatrix &B) {
    return add(A, B);
}

diaQMatrix diaQMatrix::reshape(std::vector<long int> new_tensor_shape) {
    return ::reshape(*this, new_tensor_shape);
}

diaQMatrix diaQMatrix::transpose(std::vector<long int> new_order) {
    return ::transpose(*this, new_order);
}


vector spMV(diaQMatrix A, vector x) {
    #ifdef CUDA_ENABLED
        return spmv_cuda(&A, &x);
    #else
    if(A.matrix_shape[1] != x.num_rows()) {
        throw std::invalid_argument("Not multiplyable");
    }
    vector y(A.matrix_shape[0], 0.0, 0.0);
    float *y_real_values = y.getRealValues();
    float *y_imag_values = y.getImagValues();

    float *x_real_values = x.getRealValues();
    float *x_imag_values = x.getImagValues();
    std::map<long int, diagonal> diagMap = A.getDiagonalMap();
    std::map<long int, diagonal>::iterator it;
    for (it = diagMap.begin(); it != diagMap.end(); it++) {
        long int dIndex = it->first;
        long int dLength = it->second.dLength;
        float *real_vals = it->second.getRealValues();
        float *imag_vals = it->second.getImagValues();
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS)
        for (long int i = 0; i < it->second.dLength; i++) {
            // std::cout << "dIndex=" << dIndex << "; dLength=" << dLength << "; i=" << i << std::endl;
            long int x_idx = (dIndex < 0)? i : dIndex + i;
            long int y_idx = (dIndex < 0)? i - dIndex : i;
            y_real_values[y_idx] += real_vals[i] * x_real_values[x_idx] - imag_vals[i] * x_imag_values[x_idx];
            y_imag_values[y_idx] += real_vals[i] * x_imag_values[x_idx] + imag_vals[i] * x_real_values[x_idx];
            // std::cout << "y[" << y_idx << "] = " << c << " * x[" << x_idx << "]" << std::endl;
            // std::cout << " -- " << std::endl;
        }
    }
    return y;
    #endif
}

vector MV(denseMatrix A, vector x) {
    if(A.matrix_shape[1] != x.num_rows()) {
        throw std::invalid_argument("Not multiplyable");
    }
    float *x_real_values = x.getRealValues();
    float *x_imag_values = x.getImagValues();
    vector y(A.matrix_shape[0], 0.0, 0.0);
    float *y_real_values = y.getRealValues();
    float *y_imag_values = y.getImagValues();
    for(long int i = 0; i < A.matrix_shape[0]; i++) {
        float res_real = 0.0;
        float res_imag = 0.0;
        #pragma omp parallel for num_threads(NUMBER_OF_OMP_THREADS) reduction(+:res_real,res_imag)
        for(long int j = 0; j < A.matrix_shape[1]; j++) {
            std::complex<float> elem = A.get(i, j);
            res_real += elem.real() * x_real_values[j] - elem.imag() * x_imag_values[j];
            res_imag += elem.real() * x_imag_values[j] + elem.imag() * x_real_values[j];
        }
        y_real_values[i] = res_real;
        y_imag_values[i] = res_imag;
    }
    return y;
}