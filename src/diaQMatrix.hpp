#ifndef DIAQ_DIAQMATRIX_HPP
#define DIAQ_DIAQMATRIX_HPP

#include "diagonal.hpp"
#include <map>
#include <numeric>
#include <omp.h>
#include <cstddef>
#include <unordered_map>

#include "config.hpp"

namespace diaq {

class denseMatrix; // telling this class exists w/o defining it here

class diaQMatrix {
    public:
        long int size;
        long int *matrix_shape; // as of now, this is always a 2 element array
        std::vector<long int> shape;
        std::unordered_map<long int, diagonal*> diagonalMap; // map <dIndex, diagonal object>

        diaQMatrix(long int s) {
            std::unordered_map<long int, diagonal*> d;
            diagonalMap = d;
            size = s * s;
            matrix_shape = new long int[2];
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        diaQMatrix(long int **dimens) {
            std::unordered_map<long int, diagonal*> d;
            diagonalMap = d;
            matrix_shape = *dimens;
            size = matrix_shape[0] * matrix_shape[1];
            shape.push_back(matrix_shape[0]);
            shape.push_back(matrix_shape[1]);
        }
        diaQMatrix(long int **dimens, std::vector<long int> ts) {
            std::unordered_map<long int, diagonal*> d;
            diagonalMap = d;
            matrix_shape = *dimens;
            shape = ts;
            size = matrix_shape[0] * matrix_shape[1];
        }
        diaQMatrix(std::unordered_map<long int, diagonal*> dm, long int s) {
            diagonalMap = dm;
            size = s * s;
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        diaQMatrix(std::unordered_map<long int, diagonal*> dm, long int **d) {
            diagonalMap = dm;
            matrix_shape = *d;
            size = matrix_shape[0] * matrix_shape[1];
            shape.push_back(matrix_shape[0]);
            shape.push_back(matrix_shape[1]);
        }
        diaQMatrix(std::unordered_map<long int, diagonal*> dm, long int **d, std::vector<long int> ts) {
            diagonalMap = dm;
            matrix_shape = *d;
            shape = ts;
            size = matrix_shape[0] * matrix_shape[1];
        }

        ~diaQMatrix() {
            this->free();
        }

        long int getSize() {
            return size;
        }
        valType getItem_real(long int flat_index) {
            long int *mat_pos = getMatrixPosition(flat_index);
            auto it = diagonalMap.find(mat_pos[1] - mat_pos[0]);
            if(it == diagonalMap.end()) {
                return 0.0;
            }
            else {
                return it->second->getRealValue(mat_pos[1]);
            }
        }
        valType getItem_real(long int d_idx, long int d_pos) {
            auto it = diagonalMap.find(d_idx);
            if(it == diagonalMap.end()) {
                return 0.0;
            }
            else {
                return it->second->getRealValue(d_pos);
            }
        }
        valType getItem_imag(long int d_idx, long int d_pos) {
            auto it = diagonalMap.find(d_idx);
            if(it == diagonalMap.end()) {
                return 0.0;
            }
            else {
                return it->second->getImagValue(d_pos);
            }
        }
        void getTensorItem(std::vector<long int> ten_pos, valType *real_val, valType *imag_val) {
            long int *d_pos = getDiagonalPosition(ten_pos);
            auto it = diagonalMap.find(d_pos[0]);
            if(it == diagonalMap.end()) {
                *real_val = 0.0;
                *imag_val = 0.0;
            }
            else {
                *real_val = it->second->getRealValue(d_pos[1]);
                *imag_val = it->second->getImagValue(d_pos[1]);
            }
        }
        valType getItem_imag(long int flat_index) {
            long int *mat_pos = getMatrixPosition(flat_index);
            auto it = diagonalMap.find(mat_pos[1] - mat_pos[0]);
            if(it == diagonalMap.end()) {
                return 0.0;
            }
            else {
                return it->second->getImagValue(mat_pos[1]);
            }
        }
        std::complex<valType> getItem(long int flat_index) {
            long int *mat_pos = getMatrixPosition(flat_index);
            auto it = diagonalMap.find(mat_pos[1] - mat_pos[0]);
            if(it == diagonalMap.end()) {
                return std::complex<valType>(0.0, 0.0);
            }
            else {
                return it->second->getValue(mat_pos[1]);
            }
        }
        std::complex<valType> getItem(long int *mat_pos) {
            auto it = diagonalMap.find(mat_pos[1] - mat_pos[0]);
            if(it == diagonalMap.end()) {
                return std::complex<valType>(0.0, 0.0);
            }
            else {
                return it->second->getValue(mat_pos[1]);
            }
        }
        std::complex<valType> getItem(std::vector<long int> ten_pos) {
            long int *d_pos = getDiagonalPosition(ten_pos);
            auto it = diagonalMap.find(d_pos[0]);
            if(it == diagonalMap.end()) {
                throw std::length_error("out of bounds");
            }
            else {
                return it->second->getValue(d_pos[1]);
            }
        }
        void setItem(std::vector<long int> ten_pos, valType real_val, valType imag_val) {
            // printf("setItem called\n");
            long int *d_pos = getDiagonalPosition(ten_pos);
            // printf("got d_pos = (%ld,%ld)\n", d_pos[0], d_pos[1]);
            auto it = diagonalMap.find(d_pos[0]);
            if(it == diagonalMap.end()) {
                createDiagonal(d_pos[0]);
                it = diagonalMap.find(d_pos[0]);
            }
            it->second->setValue(d_pos[1], real_val, imag_val);
            // printf("setItem done\n");
        }
        std::unordered_map<long int, diagonal*> getDiagonalMap() {
            return diagonalMap;
        }
        void print() {
            std::cout << "matrix_shape (";
            std::cout << matrix_shape[0] << ",";
            std::cout << matrix_shape[1] << ")" << std::endl;
            std::cout << "tensor_shape (";
            for(size_t i = 0; i < shape.size()-1; i++) {
                std::cout << shape[i] << ",";
            }
            std::cout << shape[shape.size()-1] << ")" << std::endl;
            std::map<long int, diagonal *> sortedDiagonalMap(diagonalMap.begin(), diagonalMap.end());
            for (auto it = sortedDiagonalMap.begin(); it != sortedDiagonalMap.end(); it++) {
                it->second->print();
            }
        }
        void print_meta() {
            std::cout << "matrix_shape (";
            std::cout << matrix_shape[0] << ",";
            std::cout << matrix_shape[1] << ")" << std::endl;
            std::cout << "tensor_shape (";
            for(size_t i = 0; i < shape.size()-1; i++) {
                std::cout << shape[i] << ",";
            }
            std::cout << shape[shape.size()-1] << ")" << std::endl;
            std::cout << "#Diagonals = " << diagonalMap.size() << std::endl;
            std::cout << "Sparsity = " << sparsity() << std::endl;
        }
        void createDiagonal(long int dIndex) {
            diagonal *newDiag = new diagonal(dIndex, getDiagonalLength(dIndex));
            this->diagonalMap.insert({dIndex, newDiag});
        }
        diagonal *getDiagonal_orCreateIt(long int dIndex) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                createDiagonal(dIndex);
                return getDiagonal(dIndex);
            }
            else {
                // it->second.prlong int(size);
                return it->second;
            }
        }
        diagonal *getDiagonal(long int dIndex) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                return nullptr;
            }
            else {
                return it->second;
            }
        }
        void setDiagonalMap(std::unordered_map<long int, diagonal*> dm) {
            diagonalMap = dm;
        }
        void setDiagonalElement(long int dIndex, long int dPos, long int dLen, valType real_val, valType imag_val) {
            // std::cout << "setDiagonalElement called " << dIndex << " " << dPos << std::endl;
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                // #ifndef CUDA_ENABLED
                    #if NUM_BYTES_ALIGNED == -1
                        valType *real_vals = (valType *)calloc(dLen, sizeof(valType));
                        valType *imag_vals = (valType *)calloc(dLen, sizeof(valType));
                    #else
                        valType *real_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, dLen * sizeof(valType));
                        valType *imag_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, dLen * sizeof(valType));
                        #pragma omp parallel for
                        for(long int i = 0; i<dLen; i++) {
                            real_vals[i] = 0.0;
                            imag_vals[i] = 0.0;
                        }
                    #endif
                // #else
                //     #if NUM_BYTES_ALIGNED == -1
                //         valType *real_vals = (valType *)calloc(dLen, sizeof(valType));
                //         valType *imag_vals = (valType *)calloc(dLen, sizeof(valType));
                //     #else
                //         valType *real_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, dLen * sizeof(valType));
                //         valType *imag_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, dLen * sizeof(valType));
                //         #pragma omp parallel for
                //         for(long int i = 0; i<dLen; i++) {
                //             real_vals[i] = 0.0;
                //             imag_vals[i] = 0.0;
                //         }
                //     #endif
                // #endif
                real_vals[dPos] = real_val;
                imag_vals[dPos] = imag_val;
                diagonal *newDiag = new diagonal(dIndex, dLen, real_vals, imag_vals);
                this->diagonalMap.insert({dIndex, newDiag});
            }
            else {
                it->second->realValues[dPos] = real_val;
                it->second->imagValues[dPos] = imag_val;
            }
        }
        void setDiagonal(long int dIndex, diagonal *diagNew) {
            // this->diagonalMap.erase(dIndex);
            this->diagonalMap.insert({dIndex, diagNew});
        }
        void addDiagonal(long int dIndex, diagonal *diagNew) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                // std::cout << "new index" << std::endl;
                this->diagonalMap.insert({dIndex, diagNew});
            }
            else {
                #pragma omp simd
                for(long int i = 0; i < it->second->dLength; i++) {
                    it->second->realValues[i] += diagNew->realValues[i];
                    it->second->imagValues[i] += diagNew->imagValues[i];
                }
                diagNew->free();
            }
        }
        diaQMatrix *addMatrix(diaQMatrix *B) {
            std::unordered_map<long int, diagonal*> BDiagMap = B->diagonalMap;

            #pragma omp parallel for
            for (size_t i = 0; i < BDiagMap.size(); i++) {
                auto it = std::next(BDiagMap.begin(), i);
                long int dIndex = it->first;
                diagonal *dB = it->second;
                auto itA = diagonalMap.find(dIndex);

                if(itA == diagonalMap.end()) {
                    // If the diagonal does not exist in the current matrix, add it
                    diagonalMap.insert({dIndex, dB});
                } else {
                    // If the diagonal exists, add the elements
                    diagonal *dA = itA->second;
                    valType *dA_real_vals = dA->realValues;
                    valType *dA_imag_vals = dA->imagValues;
                    valType *dB_real_vals = dB->realValues;
                    valType *dB_imag_vals = dB->imagValues;
                    #pragma omp parallel for
                    for (long int i = 0; i < dA->dLength; i++) {
                        dA_real_vals[i] += dB_real_vals[i];
                        dA_imag_vals[i] += dB_imag_vals[i];
                    }
                }
                #ifdef DEEP_DEBUG
                    std::cout << "Added diagonal " << dIndex << std::endl;
                    std::cout << "Matrix A:" << std::endl;
                    this->print();
                #endif
            }
            return this;
        }

        diaQMatrix *scale_by_imag(valType imag);
        diaQMatrix *scale_by_real(valType real);
        diaQMatrix *multiplyMatrix(diaQMatrix *B);

        diaQMatrix *subtractMatrix(diaQMatrix *B) {
            std::unordered_map<long int, diagonal*> BDiagMap = B->diagonalMap;

            #pragma omp parallel for
            for (size_t i = 0; i < BDiagMap.size(); i++) {
                auto it = std::next(BDiagMap.begin(), i);
                long int dIndex = it->first;
                diagonal *dB = it->second;
                auto itA = diagonalMap.find(dIndex);

                if(itA == diagonalMap.end()) {
                    // If the diagonal does not exist in the current matrix, add it
                    diagonalMap.insert({dIndex, dB->scale_by_real(-1.0)});
                } else {
                    // If the diagonal exists, add the elements
                    diagonal *dA = itA->second;
                    valType *dA_real_vals = dA->realValues;
                    valType *dA_imag_vals = dA->imagValues;
                    valType *dB_real_vals = dB->realValues;
                    valType *dB_imag_vals = dB->imagValues;
                    #pragma omp parallel for
                    for (long int i = 0; i < dA->dLength; i++) {
                        dA_real_vals[i] -= dB_real_vals[i];
                        dA_imag_vals[i] -= dB_imag_vals[i];
                    }
                }
                #ifdef DEEP_DEBUG
                    std::cout << "Subtracted diagonal " << dIndex << std::endl;
                    std::cout << "Matrix A:" << std::endl;
                    this->print();
                #endif
            }
            return this;
        }

        diaQMatrix *inverse();
        diaQMatrix *divide_by_int(int real);
        diaQMatrix *copy_and_scale_by_imag(valType imag);

        diaQMatrix *copy() {
            std::unordered_map<long int, diagonal*> newDiagonalMap;

            #pragma omp parallel for
            for (size_t i = 0; i < diagonalMap.size(); i++) {
                auto it = std::next(diagonalMap.begin(), i);
                diagonal *d = it->second;

                #ifdef NUM_BYTES_ALIGNED
                    valType *real_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, d->dLength * sizeof(valType));
                    valType *imag_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, d->dLength * sizeof(valType));
                #else
                    valType *real_vals = (valType *)calloc(d->dLength, sizeof(valType));
                    valType *imag_vals = (valType *)calloc(d->dLength, sizeof(valType));
                #endif

                #pragma omp parallel for
                for (long int i = 0; i < d->dLength; i++) {
                    real_vals[i] = d->realValues[i];
                    imag_vals[i] = d->imagValues[i];
                }
                diagonal *newDiag = new diagonal(d->dIndex, d->dLength, real_vals, imag_vals);
                newDiagonalMap.insert({d->dIndex, newDiag});
            }
            long int *newMatrixShape = new long int[2]{matrix_shape[0], matrix_shape[1]};
            diaQMatrix *newMatrix = new diaQMatrix(newDiagonalMap, &newMatrixShape);
            return newMatrix;
        }

        valType norm() {
            valType norm = 0.0;
            #pragma omp parallel for reduction(+:norm)
            for (size_t i = 0; i < diagonalMap.size(); i++) {
                auto it = std::next(diagonalMap.begin(), i);
                diagonal *d = it->second;
                valType *real_vals = d->realValues;
                valType *imag_vals = d->imagValues;
                valType local_norm = 0.0; // Use a local variable to accumulate within the SIMD loop
                #pragma omp simd reduction(+:local_norm)
                for (long int i = 0; i < d->dLength; i++) {
                    local_norm += real_vals[i] * real_vals[i] + imag_vals[i] * imag_vals[i];
                }
                norm += local_norm; // Accumulate local_norm to norm in the parallel region
            }
            return std::sqrt(norm);
        }

        void balance() {
            // printf("balance called\n");
            // this->print_shape();
            if(matrix_shape[0] != matrix_shape[1]) {
                long int overall_dim = matrix_shape[0] * matrix_shape[1]; // this is same as size, but I have to double check if I modify size everytime I modify matrix_shape.... TODO
                long int sqrtProduct = static_cast<long int>(std::sqrt(overall_dim));
                // Find the closest factors of the product
                long int x = 1;
                long int y = overall_dim;
                for (long int i = sqrtProduct; i > 0; --i) {
                    if (overall_dim % i == 0) {
                        x = i;
                        y = overall_dim / i;
                        break;
                    }
                }
                // printf("new x = %ld, y = %ld\n", x, y);
                long int *new_shape = new long int[2]{x, y};
                this->matrix_reshape(new_shape);
            }
        }
        long int *getMatrixPosition(long int flat_index) {
            long int* mat_pos = new long int[2];
            mat_pos[0] = flat_index / matrix_shape[1];
            mat_pos[1] = flat_index % matrix_shape[1];
            return mat_pos;
        }
        long int *getMatrixPosition(long int diagonal_idx, long int diagonal_pos) {
            long int* mat_pos = new long int[2];
            if(diagonal_idx == 0) {
                mat_pos[0] = diagonal_pos;
                mat_pos[1] = diagonal_pos;
            }
            else {
                if(diagonal_idx < 0) {
                    mat_pos[0] = abs(diagonal_idx);
                    mat_pos[1] = 0;
                }
                else {
                    mat_pos[0] = 0;
                    mat_pos[1] = abs(diagonal_idx);
                }
                mat_pos[0] += (diagonal_pos);
                mat_pos[1] += (diagonal_pos);
            }
            if(mat_pos[0] >= matrix_shape[0] || mat_pos[1] >= matrix_shape[1]) {
                std::cout << "diagonal pos (" << diagonal_idx << "," << diagonal_pos << ") in matrix of size (" << matrix_shape[0] << "," << matrix_shape[1] << ")" << std::endl;
                std::cout << "got pos (" << mat_pos[0] << "," << mat_pos[1] << ") in matrix of size (" << matrix_shape[0] << "," << matrix_shape[1] << ")" << std::endl;
                throw std::length_error("out of matrix");
            }
            return mat_pos;
        }
        std::vector<long int> getTensorPosition(long int diagonal_idx, long int diagonal_pos) {
            long int *mat_pos = getMatrixPosition(diagonal_idx, diagonal_pos);
            long int total_elements = matrix_shape[0] * matrix_shape[1];
            long int ndim = shape.size();
            long int flat_index = mat_pos[0] * matrix_shape[1] + mat_pos[1];
            std::vector<long int> ten_pos(ndim);
            long long int prod = 1;
            // std::cout << "flat_index = " << flat_index << " prod = " << prod << std::endl;
            #pragma unroll
            for (long int i = 0; i < ndim; i++) {
                prod *= shape[i];
                // std::cout << "flat_index = " << flat_index << " prod = " << prod << std::endl;
                ten_pos[i] = (flat_index / (total_elements / prod)) % shape[i];
                flat_index = flat_index - (total_elements / prod) * ten_pos[i];
            }
            std::free(mat_pos);
            return ten_pos;
        }
        void setDiagFlatData(long int n_diags, long int *diagonal_indices, long int *cum_diagonal_lengths, valType *real_data, valType *imag_data) {
            // ------------------ DEBUG ------------------
            // std::cout << "n_diags = " << n_diags << std::endl;
            // std::cout << "num_elements = " << num_elements << std::endl;
            // std::cout << "diagonal_indices = [";
            // for (long int i = 0; i < n_diags - 1; i++) {
            //     std::cout << diagonal_indices[i] << ",";
            // }
            // std::cout << diagonal_indices[n_diags - 1] << "]" << std::endl;
            // std::cout << "cum_diagonal_lengths = [";
            // for (long int i = 0; i < n_diags - 1; i++) {
            //     std::cout << cum_diagonal_lengths[i] << ",";
            // }
            // std::cout << cum_diagonal_lengths[n_diags - 1] << "]" << std::endl;
            // std::cout << "real_data = [";
            // for (long int i = 0; i < num_elements - 1; i++) {
            //     std::cout << real_data[i] << ",";
            // }
            // std::cout << real_data[num_elements - 1] << "]" << std::endl;
            // std::cout << "imag_data = [";
            // for (long int i = 0; i < num_elements - 1; i++) {
            //     std::cout << imag_data[i] << ",";
            // }
            // std::cout << imag_data[num_elements - 1] << "]" << std::endl;
            // ------------------ DEBUG ------------------
            for (long int i = 0; i < n_diags; i++) {
                long int dIndex = diagonal_indices[i];
                long int dLength = cum_diagonal_lengths[i];
                // std::cout << "dIndex = " << dIndex << " dLength = " << dLength << std::endl;
                #ifndef CUDA_ENABLED
                    #if NUM_BYTES_ALIGNED == -1
                        valType *real_vals = (valType *)calloc(dLength, sizeof(valType));
                        valType *imag_vals = (valType *)calloc(dLength, sizeof(valType));
                    #else
                        valType *real_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, dLength * sizeof(valType));
                        valType *imag_vals = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, dLength * sizeof(valType));
                        #pragma omp parallel for
                        for(long int i = 0; i < dLength; i++) {
                            real_vals[i] = 0.0;
                            imag_vals[i] = 0.0;
                        }
                    #endif
                #else
                    valType *real_vals = (valType *)calloc(dLength, sizeof(valType));
                    valType *imag_vals = (valType *)calloc(dLength, sizeof(valType));
                #endif
                #pragma omp parallel for
                for (long int j = 0; j < dLength; j++) {
                    real_vals[j] = real_data[j];
                    imag_vals[j] = imag_data[j];
                }
                diagonal *newDiag = new diagonal(dIndex, dLength, real_vals, imag_vals);
                this->diagonalMap.insert({dIndex, newDiag});
            }
        }
        void getDiagFlatData(long int *n_diags, long int **diagonal_indices, long int **cum_diagonal_lengths, long int *num_elements, valType **real_data, valType **imag_data) {
            *n_diags = diagonalMap.size();
            // ------------------ DEBUG ------------------
            // std::cout << "n_diags = " << *n_diags << std::endl;
            // ------------------ DEBUG ------------------
            (*diagonal_indices) = (long int *)calloc(*n_diags, sizeof(long int));
            (*cum_diagonal_lengths) = (long int *)calloc(*n_diags, sizeof(long int));
            *num_elements = 0;
            long int k = 0;
            for (auto x : diagonalMap) {
                // std::cout << "for k = " << k << " x.first = " << x.first << std::endl;
                (*diagonal_indices)[k] = x.first;
                // std::cout << "set! (*cum_diagonal_lengths)[" << k << "] = " << (*cum_diagonal_lengths)[k] << std::endl;
                if (k == 0) {
                    (*cum_diagonal_lengths)[k] = x.second->dLength;
                } else {
                    // std::cout << "k = " << k << std::endl;
                    // std::cout << "~ (*cum_diagonal_lengths)[" << k - 1 << "] = " << (*cum_diagonal_lengths)[k - 1] << std::endl;
                    // std::cout << "~ x.second->dLength = " << x.second->dLength << std::endl;
                    (*cum_diagonal_lengths)[k] = (*cum_diagonal_lengths)[k - 1] + x.second->dLength;
                }
                // std::cout << "set! (*cum_diagonal_lengths)[" << k << "] = " << (*cum_diagonal_lengths)[k] << std::endl;
                k++;
                *num_elements += x.second->dLength;
                // std::cout << "set! *num_elements = " << *num_elements << std::endl;
            }
            // ------------------ DEBUG ------------------
            // std::cout << "num_elements = " << *num_elements << std::endl;
            // std::cout << "diagonal_indices = ";
            // for (long int i = 0; i < *n_diags; i++) {
            //     std::cout << (*cum_diagonal_lengths)[i] << ",";
            // }
            // std::cout << std::endl;
            // ------------------ DEBUG ------------------
            long int p = 0;
            #ifndef CUDA_ENABLED
                #if NUM_BYTES_ALIGNED == -1
                    (*real_data) = (valType *)calloc(*num_elements, sizeof(valType));
                    (*imag_data) = (valType *)calloc(*num_elements, sizeof(valType));
                #else
                    (*real_data) = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, *num_elements * sizeof(valType));
                    (*imag_data) = (valType *)aligned_alloc(NUM_BYTES_ALIGNED, *num_elements * sizeof(valType));
                    #pragma omp parallel for
                    for(long int i = 0; i < *num_elements; i++) {
                        (*real_data)[i] = 0.0;
                        (*real_data)[i] = 0.0;
                    }
                #endif
            #else
                (*real_data) = (valType *)calloc(*num_elements, sizeof(valType));
                (*imag_data) = (valType *)calloc(*num_elements, sizeof(valType));
            #endif
            for (auto x : diagonalMap) {
                valType *real_vals = x.second->getRealValues();
                valType *imag_vals = x.second->getImagValues();
                #pragma omp parallel for
                for (int i = 0; i < x.second->dLength; i++) {
                    (*real_data)[p] = real_vals[i];
                    (*imag_data)[p++] = imag_vals[i];
                }
            }
            // ------------------ DEBUG ------------------
            // std::cout << "real_data = ";
            // for (long int i = 0; i < *num_elements; i++) {
            //     std::cout << (*real_data)[i] << ",";
            // }
            // std::cout << std::endl;
            // std::cout << "imag_data = ";
            // for (long int i = 0; i < *num_elements; i++) {
            //     std::cout << (*imag_data)[i] << ",";
            // }
            // std::cout << std::endl;
            // ------------------ DEBUG ------------------
        }
        long int *getDiagonalPositionByFlatIndex(long int flatIndex) {
            long int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            long int mat_y = flatIndex % matrix_shape[1];
            // std::cout << "(x,y) = (" << mat_x << "," << mat_y << ")" << std::endl;
            long int* res = new long int[2];
            // diagonal index is just j - i
            long int d_idx = mat_y - mat_x;
            res[0] = d_idx;
            // getting the position in that diagonal
            if(d_idx <= 0) {
                res[1] = mat_y;
            } else {
                res[1] = (mat_y - d_idx);
            }
            return res;
        }
        long int *getDiagonalPosition(long int flatIndex) {
            long int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            long int mat_y = flatIndex % matrix_shape[1];
            // std::cout << "(x,y) = (" << mat_x << "," << mat_y << ")" << std::endl;
            long int *res = new long int[2];
            // diagonal index is just j - i
            long int d_idx = mat_y - mat_x;
            res[0] = (d_idx);
            // getting the position in that diagonal
            if(d_idx <= 0) {
                res[1] = (mat_y);
            } else {
                res[1] = (mat_y - d_idx);
            }
            return res;
        }
        long int getFlatIndex(long int d_idx, long int d_pos) {
            long int mat_x, mat_y;
            if(d_idx == 0) {
                mat_x = d_pos;
                mat_y = d_pos;
            }
            else {
                if(d_idx < 0) {
                    mat_x = abs(d_idx);
                    mat_y = 0;
                }
                else {
                    mat_x = 0;
                    mat_y = abs(d_idx);
                }
                mat_x += (d_pos);
                mat_y += (d_pos);
            }
            return mat_x * matrix_shape[1] + mat_y;
        }
        long int getFlatIndex(long int *matrix_pos) {
            return matrix_pos[0] * matrix_shape[1] + matrix_pos[1];
        }
        long int getFlatIndex(std::vector<long int> ten_pos) {
            long int total_elements = 1;
            for(size_t i = 0;i < shape.size(); i++)
                total_elements = total_elements * shape[i];
            long int flat_index = 0;
            long long int prod = 1;
            #pragma unroll
            for(size_t i = 0; i < shape.size() ; i++) {
                prod *= shape[i];
                flat_index = flat_index + (total_elements / prod) * ten_pos[i];
            }
            return flat_index;
        }
        long int *getDiagonalPosition(long int *matrix_pos) {
            long int flatIndex = getFlatIndex(matrix_pos);
            long int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            long int mat_y = flatIndex % matrix_shape[1];
            long int* res = new long int[2];
            long int d_idx = mat_y - mat_x;
            res[0] = (d_idx);
            if(d_idx <= 0) {
                res[1] = (mat_y);
            } else {
                res[1] = (mat_y - d_idx);
            }
            return res;
        }
        long int *getDiagonalPosition(std::vector<long int> ten_pos) {
            // returns {diagonal_idx, position_in_this_idx}
            long int flatIndex = getFlatIndex(ten_pos);
            // std::cout << "shape = " << shape[0] << "," << shape[1] << std::endl;
            long int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            long int mat_y = flatIndex % matrix_shape[1];
            // std::cout << "(x,y) = (" << mat_x << "," << mat_y << ")" << std::endl;
            long int* res = new long int[2];
            // diagonal index is just j - i
            long int d_idx = mat_y - mat_x;
            res[0] = (d_idx);
            // getting the position in that diagonal
            if(d_idx <= 0) {
                res[1] = (mat_y);
            } else {
                res[1] = (mat_y - d_idx);
            }
            return res;
        }
        long int getDiagonalLength(long int dIndex) {
            // std::cout << "diag_Index = " << dIndex << " ";
            long int lenRes;
            if(dIndex < 0) {
                lenRes = matrix_shape[0] + dIndex;
            } else if(dIndex > 0) {
                lenRes = matrix_shape[1] - dIndex;
            }  else {
                lenRes = (matrix_shape[0] > matrix_shape[1])?matrix_shape[1]:matrix_shape[0];
            }
            if (lenRes > matrix_shape[0]) {
                lenRes = matrix_shape[0];
            }
            else if(lenRes > matrix_shape[1]) {
                lenRes = matrix_shape[1];
            }
            // std::cout << "lenRes = " << lenRes << std::endl;
            return lenRes;
        }
        long int num_diags() {
            return diagonalMap.size();
        }
        std::vector<long int> get_diagonals() {
            std::vector<long int> res;
            for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                res.push_back(it->first);
            }
            return res;
        }
        std::complex<valType> *flatten() {
            std::complex<valType> *res = new std::complex<valType>[matrix_shape[0] * matrix_shape[1]];
            std::fill(res, res + matrix_shape[0] * matrix_shape[1], std::complex<valType>(1));
            for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                long int dIndex = it->first;
                long int dLength = it->second->dLength;
                valType *real_vals = it->second->getRealValues();
                valType *imag_vals = it->second->getImagValues();
                #pragma omp parallel for
                for (long int i = 0; i < dLength; i++) {
                    long int *mat_pos = getMatrixPosition(dIndex, i);
                    long int flat_index = mat_pos[0] * matrix_shape[1] + mat_pos[1];
                    res[flat_index] = std::complex<valType>(real_vals[i], imag_vals[i]);
                }
            }
            return res;
        }
        void free() {
            // #pragma omp parallel for
            for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                it->second->free();
            }
            // diagonalMap is taken care of by C++, but can we make it happen right now?
            diagonalMap.clear();
        }
        valType sparsity() {
            long int z = 0;
            for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                z += it->second->numNonZeros();
            }
            return (valType)1.0 - ((valType)z / (valType)size);
        }
        void deleteDiagonal(long int dIndex) {
            auto it = diagonalMap.find(dIndex);
            if(it != diagonalMap.end()) {
                it->second->free();
                diagonalMap.erase(dIndex);
            }
        }
        void pruneMatrix() {
            std::vector<long int> toDelete;
            for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                valType *real_vals = it->second->getRealValues();
                valType *imag_vals = it->second->getImagValues();
                long int i;
                for (i = 0; i < it->second->dLength; i++) {
                    if(real_vals[i] != 0.0 || imag_vals[i] != 0.0) {
                        break;
                    }
                }
                if(i == it->second->dLength) {
                    toDelete.push_back(it->first);
                }
            }
            #pragma omp parallel for
            for(size_t i = 0; i < toDelete.size(); i++) {
                this->diagonalMap.erase(toDelete[i]);
            }
        }
        diaQMatrix *reshape(std::vector<long int> new_tensor_shape);
        void matrix_reshape(long int *new_matrix_shape);
        void transpose(std::vector<long int> new_order);
        void transpose();
        denseMatrix *convertToDenseMatrix(long int *new_shape);
        denseMatrix *convertToDenseMatrix();
        valType *getRealValues();
        valType *getImagValues();
};

} // namespace diaq

#endif // DIAQ_DIAQMATRIX_HPP