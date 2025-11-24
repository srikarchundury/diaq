#include "matrixKernels.hpp"
#ifdef CUDA_ENABLED
    #include "conversions_gpu.hpp"
    #include "matrixKernels_gpu.hpp"
#endif

namespace diaq {

std::complex<valType> trace(std::shared_ptr<diaQMatrix> A) {
    std::complex<valType> t = 0;
    // iterate over diagonal Index 0 only
    for (size_t d = 0; d < A->dIndices.size(); ++d) {
        if (A->dIndices[d] == 0) {
            unsigned int len = A->getDiagonalLengthInternal(0);
            valType* realA = A->realData + A->diagOffsets[d];
            valType* imagA = A->imagData + A->diagOffsets[d];
            #pragma omp parallel for shared(t)
            for (unsigned int i = 0; i < len; i++) {
                t += std::complex<valType>(realA[i], imagA[i]);
            }
            break;
        }
    }
    return t;
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
        return A;
    }

    // Handle zero scalar: return empty matrix
    if (scalar_real == 0.0 && scalar_imag == 0.0) {
        return std::make_shared<diaQMatrix>((unsigned int)0);
    }

    // Prepare temp buffers for result
    size_t numDiags = A->dIndices.size();
    std::vector<int> dIndices(A->dIndices);
    std::vector<unsigned int> diagLens(numDiags);
    std::vector<unsigned int> diagOffsets(numDiags);
    unsigned int totalLen = 0;
    for (size_t k = 0; k < numDiags; ++k) {
        diagLens[k] = A->getDiagonalLengthInternal(A->dIndices[k]);
        diagOffsets[k] = totalLen;
        totalLen += diagLens[k];
    }
    std::vector<valType> realData(totalLen);
    std::vector<valType> imagData(totalLen);

    // Fill temp buffers
    #pragma omp parallel for
    for (size_t k = 0; k < numDiags; ++k) {
        unsigned int dLength = diagLens[k];
        unsigned int offset = diagOffsets[k];
        unsigned int srcOffset = A->diagOffsets[k];
        for (unsigned int i = 0; i < dLength; ++i) {
            valType real_val = A->realData[srcOffset + i];
            valType imag_val = A->imagData[srcOffset + i];
            realData[offset + i] = real_val * scalar_real - imag_val * scalar_imag;
            imagData[offset + i] = real_val * scalar_imag + imag_val * scalar_real;
        }
    }

    // Construct result using contiguous API
    auto result = std::make_shared<diaQMatrix>(A->matrix_shape, dIndices);
    result->setContiguousData(realData, imagData);

    #ifdef DEEP_DEBUG
        std::cout << " --- " << std::endl;
        std::cout << " --- multiply_by_scalar result --- " << std::endl;
        std::cout << " --- " << std::endl;
        result->print();
        std::cout << " --- " << std::endl;
    #endif

    return result;
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

} // namespace diaq