#ifndef DIAQ_DIAQMATRIX_HPP
#define DIAQ_DIAQMATRIX_HPP

#include "diagonal.hpp"
#include "config.hpp"
#include "vector.hpp"

namespace diaq {

class denseMatrix; // telling this class exists w/o defining it here

class diaQMatrix : public std::enable_shared_from_this<diaQMatrix> {
    public:
        unsigned int *matrix_shape; // as of now, this is always a 2 element array
        std::vector<unsigned int> shape;
        std::unordered_map<int, std::shared_ptr<diagonal>> diagonalMap; // map <dIndex, diagonal object>

        diaQMatrix(unsigned int s) {
            std::unordered_map<int, std::shared_ptr<diagonal>> d;
            diagonalMap = d;
            matrix_shape = new unsigned int[2];
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        diaQMatrix(unsigned int **dimens) {
            std::unordered_map<int, std::shared_ptr<diagonal>> d;
            diagonalMap = d;
            matrix_shape = *dimens;
            shape.push_back(matrix_shape[0]);
            shape.push_back(matrix_shape[1]);
        }
        diaQMatrix(unsigned int **dimens, std::vector<unsigned int> ts) {
            std::unordered_map<int, std::shared_ptr<diagonal>> d;
            diagonalMap = d;
            matrix_shape = *dimens;
            shape = ts;
        }
        diaQMatrix(std::unordered_map<int, std::shared_ptr<diagonal>> dm, unsigned int s) {
            diagonalMap = dm;
            matrix_shape[0] = s;
            matrix_shape[1] = s;
            shape.push_back(s);
            shape.push_back(s);
        }
        diaQMatrix(std::unordered_map<int, std::shared_ptr<diagonal>> dm, unsigned int **d) {
            diagonalMap = dm;
            matrix_shape = *d;
            shape.push_back(matrix_shape[0]);
            shape.push_back(matrix_shape[1]);
        }
        diaQMatrix(std::unordered_map<int, std::shared_ptr<diagonal>> dm, unsigned int **d, std::vector<unsigned int> ts) {
            diagonalMap = dm;
            matrix_shape = *d;
            shape = ts;
        }

        ~diaQMatrix() {
            #ifdef DEEP_DEBUG
                std::cout << "diaQMatrix destructor called" << std::endl;
            #endif
        }
        valType getItem_real(unsigned int flat_index) {
            std::shared_ptr<unsigned int[]> mat_pos = getMatrixPosition(flat_index);
            auto it = diagonalMap.find(mat_pos[1] - mat_pos[0]);
            if(it == diagonalMap.end()) {
                return 0.0;
            }
            else {
                return it->second->getRealValue(mat_pos[1]);
            }
        }
        valType getItem_real(int d_idx, unsigned int d_pos) {
            auto it = diagonalMap.find(d_idx);
            if(it == diagonalMap.end()) {
                return 0.0;
            }
            else {
                return it->second->getRealValue(d_pos);
            }
        }
        valType getItem_imag(int d_idx, unsigned int d_pos) {
            auto it = diagonalMap.find(d_idx);
            if(it == diagonalMap.end()) {
                return 0.0;
            }
            else {
                return it->second->getImagValue(d_pos);
            }
        }
        void getTensorItem(std::vector<unsigned int> ten_pos, valType *real_val, valType *imag_val) {
            std::shared_ptr<int[]> d_pos = getDiagonalPosition(ten_pos);
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
        valType getItem_imag(unsigned int flat_index) {
            std::shared_ptr<unsigned int[]> mat_pos = getMatrixPosition(flat_index);
            auto it = diagonalMap.find(mat_pos[1] - mat_pos[0]);
            if(it == diagonalMap.end()) {
                return 0.0;
            }
            else {
                return it->second->getImagValue(mat_pos[1]);
            }
        }
        std::complex<valType> getItem(unsigned int flat_index) {
            std::shared_ptr<unsigned int[]> mat_pos = getMatrixPosition(flat_index);
            auto it = diagonalMap.find(mat_pos[1] - mat_pos[0]);
            if(it == diagonalMap.end()) {
                return std::complex<valType>(0.0, 0.0);
            }
            else {
                return it->second->getValue(mat_pos[1]);
            }
        }
        std::complex<valType> getItem(std::shared_ptr<unsigned int[]> mat_pos) {
            auto it = diagonalMap.find(mat_pos[1] - mat_pos[0]);
            if(it == diagonalMap.end()) {
                return std::complex<valType>(0.0, 0.0);
            }
            else {
                return it->second->getValue(mat_pos[1]);
            }
        }
        std::complex<valType> getItem(std::vector<unsigned int> ten_pos) {
            std::shared_ptr<int[]> d_pos = getDiagonalPosition(ten_pos);
            auto it = diagonalMap.find(d_pos[0]);
            if(it == diagonalMap.end()) {
                throw std::length_error("out of bounds");
            }
            else {
                return it->second->getValue(d_pos[1]);
            }
        }
        void setItem(std::vector<unsigned int> ten_pos, valType real_val, valType imag_val) {
            // printf("setItem called\n");
            std::shared_ptr<int[]> d_pos = getDiagonalPosition(ten_pos);
            // printf("got d_pos = (%ld,%ld)\n", d_pos[0], d_pos[1]);
            auto it = diagonalMap.find(d_pos[0]);
            if(it == diagonalMap.end()) {
                createDiagonal(d_pos[0]);
                it = diagonalMap.find(d_pos[0]);
            }
            it->second->setValue(d_pos[1], real_val, imag_val);
            // printf("setItem done\n");
        }
        std::unordered_map<int, std::shared_ptr<diagonal>> getDiagonalMap() {
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
            std::map<int, std::shared_ptr<diagonal>> sortedDiagonalMap(diagonalMap.begin(), diagonalMap.end());
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
        void createDiagonal(int dIndex) {
            std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(dIndex, getDiagonalLength(dIndex));
            this->diagonalMap.insert({dIndex, newDiag});
        }
        std::shared_ptr<diagonal> getDiagonal_orCreateIt(int dIndex) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                createDiagonal(dIndex);
                return getDiagonal(dIndex);
            }
            else {
                // it->second.print(size);
                return it->second;
            }
        }
        std::shared_ptr<diagonal> getDiagonal(int dIndex) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                return nullptr;
            }
            else {
                return it->second;
            }
        }
        void setDiagonalMap(std::unordered_map<int, std::shared_ptr<diagonal>> dm) {
            diagonalMap = dm;
        }
        void setDiagonalElement(int dIndex, unsigned int dPos, unsigned int dLen, valType real_val, valType imag_val) {
            // std::cout << "setDiagonalElement called " << dIndex << " " << dPos << std::endl;
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                // #ifndef CUDA_ENABLED
                    #if NUM_BYTES_ALIGNED == -1
                        valType *real_vals = (valType *)calloc(dLen, sizeof(valType));
                        valType *imag_vals = (valType *)calloc(dLen, sizeof(valType));
                    #else
                        valType *real_vals = aligned_alloc_helper(dLen * sizeof(valType));
                        valType *imag_vals = aligned_alloc_helper(dLen * sizeof(valType));
                        #pragma omp parallel for
                        for(unsigned int i = 0; i<dLen; i++) {
                            real_vals[i] = 0.0;
                            imag_vals[i] = 0.0;
                        }
                    #endif
                // #else
                //     #if NUM_BYTES_ALIGNED == -1
                //         valType *real_vals = (valType *)calloc(dLen, sizeof(valType));
                //         valType *imag_vals = (valType *)calloc(dLen, sizeof(valType));
                //     #else
                //         valType *real_vals = aligned_alloc_helper(dLen * sizeof(valType));
                //         valType *imag_vals = aligned_alloc_helper(dLen * sizeof(valType));
                //         #pragma omp parallel for
                //         for(unsigned int i = 0; i<dLen; i++) {
                //             real_vals[i] = 0.0;
                //             imag_vals[i] = 0.0;
                //         }
                //     #endif
                // #endif
                real_vals[dPos] = real_val;
                imag_vals[dPos] = imag_val;
                std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(dIndex, dLen, real_vals, imag_vals);
                this->diagonalMap.insert({dIndex, newDiag});
            }
            else {
                it->second->realValues[dPos] = real_val;
                it->second->imagValues[dPos] = imag_val;
            }
        }
        
        void setDiagonal(int dIndex, std::shared_ptr<diagonal> diagNew) {
            // this->diagonalMap.erase(dIndex);
            this->diagonalMap.insert({dIndex, diagNew});
        }
        
        void addDiagonal(int dIndex, std::shared_ptr<diagonal> diagNew) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                // std::cout << "new index" << std::endl;
                this->diagonalMap.insert({dIndex, diagNew});
            }
            else {
                #pragma omp parallel for simd
                for(unsigned int i = 0; i < it->second->dLength; i++) {
                    #pragma omp atomic
                    it->second->realValues[i] += diagNew->realValues[i];
                    #pragma omp atomic
                    it->second->imagValues[i] += diagNew->imagValues[i];
                }
                // diagNew->free();
            }
        }
        
        std::shared_ptr<diaQMatrix> addMatrix(std::shared_ptr<diaQMatrix> B) {
            std::vector<std::pair<int, std::shared_ptr<diagonal>>> BDiagVec(B->diagonalMap.begin(), B->diagonalMap.end());
        
            #pragma omp parallel
            {
                std::unordered_map<int, std::shared_ptr<diagonal>> localUpdates;
        
                #pragma omp for nowait
                for (size_t i = 0; i < BDiagVec.size(); i++) {
                    int dIndex = BDiagVec[i].first;
                    std::shared_ptr<diagonal> dB = BDiagVec[i].second;
        
                    auto itA = diagonalMap.find(dIndex);
                    if (itA == diagonalMap.end()) {
                        // If the diagonal does not exist in A, store it for later insertion
                        localUpdates[dIndex] = dB;
                    } else {
                        // If the diagonal exists, add the elements
                        std::shared_ptr<diagonal> dA = itA->second;
                        valType *dA_real_vals = dA->realValues;
                        valType *dA_imag_vals = dA->imagValues;
                        valType *dB_real_vals = dB->realValues;
                        valType *dB_imag_vals = dB->imagValues;
        
                        #pragma omp simd
                        for (unsigned int j = 0; j < dA->dLength; j++) {
                            dA_real_vals[j] += dB_real_vals[j];
                            dA_imag_vals[j] += dB_imag_vals[j];
                        }
                    }
                }
        
                // Merge local updates into the global diagonalMap
                #pragma omp critical
                diagonalMap.insert(localUpdates.begin(), localUpdates.end());
            }
        
            return shared_from_this();
        }

        std::shared_ptr<diaQMatrix> scale_by_imag(valType imag) {
            #pragma omp parallel for
            for (size_t i = 0; i < diagonalMap.size(); i++) {
                auto it = std::next(diagonalMap.begin(), i);
                std::shared_ptr<diagonal> d = it->second;
                valType *real_vals = d->realValues;
                valType *imag_vals = d->imagValues;
                #pragma omp parallel for
                for(size_t j = 0; j < d->dLength; j++) {
                    valType r = real_vals[j];
                    real_vals[j] = -1.0 * imag_vals[j] * imag;
                    imag_vals[j] = r * imag;
                }
            }
            return shared_from_this();
        }
        
        std::shared_ptr<diaQMatrix> scale_by_real(valType real) {
            #pragma omp parallel for
            for (size_t i = 0; i < diagonalMap.size(); i++) {
                auto it = std::next(diagonalMap.begin(), i);
                std::shared_ptr<diagonal> d = it->second;
                valType *real_vals = d->realValues;
                valType *imag_vals = d->imagValues;
                #pragma omp parallel for
                for(size_t j = 0; j < d->dLength; j++) {
                    real_vals[j] = real_vals[j] * real;
                    imag_vals[j] = imag_vals[j] * real;
                }
            }
            return shared_from_this();
        }
        
        std::shared_ptr<diaQMatrix> multiplyMatrix(std::shared_ptr<diaQMatrix> B); // this requires multiplyDiagonals kernel and hence in matrixKernels.cpp
        std::shared_ptr<vector> multiplyVector(std::shared_ptr<vector> v); // this requires spMV kernel and hence in matrixKernels.cpp
        
        std::shared_ptr<diaQMatrix> inverse() {
            throw std::logic_error("Function not yet implemented.");
        }
        
        std::shared_ptr<diaQMatrix> divide_by_int(int int_value) {
            if (int_value == 0) {
                throw std::runtime_error("Division by zero error.");
            }
            
            if (int_value == 1) {
                return shared_from_this();
            }
        
            valType reciprocal = 1.0 / valType(int_value);
            valType min_threshold = std::numeric_limits<valType>::min();
        
            #pragma omp parallel for
            for (size_t i = 0; i < diagonalMap.size(); i++) {
                auto it = std::next(diagonalMap.begin(), i);
                std::shared_ptr<diagonal> d = it->second;
                valType *real_vals = d->realValues;
                valType *imag_vals = d->imagValues;
                #pragma omp simd
                for (unsigned int j = 0; j < d->dLength; j++) {
                    real_vals[j] = (std::abs(real_vals[j]) > min_threshold * int_value) ? real_vals[j] * reciprocal : 0.0;
                    imag_vals[j] = (std::abs(imag_vals[j]) > min_threshold * int_value) ? imag_vals[j] * reciprocal : 0.0;
                }
            }
            return shared_from_this();
        }
        
        std::shared_ptr<diaQMatrix> copy_and_scale_by_imag(valType imag) {
            std::vector<std::pair<int, std::shared_ptr<diagonal>>> diagVector(diagonalMap.begin(), diagonalMap.end());
            std::unordered_map<int, std::shared_ptr<diagonal>> newDiagonalMap;
        
            #pragma omp parallel
            {
                std::unordered_map<int, std::shared_ptr<diagonal>> localMap;
        
                #pragma omp for nowait
                for (size_t i = 0; i < diagVector.size(); i++) {
                    std::shared_ptr<diagonal> d = diagVector[i].second;
                    #if NUM_BYTES_ALIGNED == -1
                        valType *real_vals = (valType *)calloc(d->dLength, sizeof(valType));
                        valType *imag_vals = (valType *)calloc(d->dLength, sizeof(valType));
                    #else
                        valType *real_vals = aligned_alloc_helper(d->dLength * sizeof(valType));
                        valType *imag_vals = aligned_alloc_helper(d->dLength * sizeof(valType));
                        #pragma omp parallel for
                        for (unsigned int j = 0; j < d->dLength; j++) {
                            real_vals[j] = 0.0;
                            imag_vals[j] = 0.0;
                        }
                    #endif
        
                    #pragma omp simd
                    for (unsigned int j = 0; j < d->dLength; j++) {
                        real_vals[j] = -1.0 * d->imagValues[j] * imag;
                        imag_vals[j] = d->realValues[j] * imag;
                    }
                    std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(d->dIndex, d->dLength, real_vals, imag_vals);
                    localMap[d->dIndex] = newDiag;
                }
        
                // Merge local maps into the global map
                #pragma omp critical
                newDiagonalMap.insert(localMap.begin(), localMap.end());
            }
        
            unsigned int *newMatrixShape = new unsigned int[2]{matrix_shape[0], matrix_shape[1]};
            std::shared_ptr<diaQMatrix> newMatrix =std::make_shared<diaQMatrix>(newDiagonalMap, &newMatrixShape);
            return newMatrix;
        }        
        
        std::shared_ptr<diaQMatrix> subtractMatrix(std::shared_ptr<diaQMatrix> B) {
        
            #pragma omp parallel for
            for (size_t i = 0; i < B->diagonalMap.size(); i++) {
                auto it = std::next(B->diagonalMap.begin(), i);
                int dIndex = it->first;
                std::shared_ptr<diagonal> dB = it->second;
                auto itA = B->diagonalMap.find(dIndex);

                if(itA == B->diagonalMap.end()) {
                    // If the diagonal does not exist in the current matrix, add it
                    B->diagonalMap.insert({dIndex, dB->scale_by_real(-1.0)});
                } else {
                    // If the diagonal exists, add the elements
                    std::shared_ptr<diagonal> dA = itA->second;
                    valType *dA_real_vals = dA->realValues;
                    valType *dA_imag_vals = dA->imagValues;
                    valType *dB_real_vals = dB->realValues;
                    valType *dB_imag_vals = dB->imagValues;
                    #pragma omp simd
                    for (unsigned int i = 0; i < dA->dLength; i++) {
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
            return shared_from_this();
        }

        std::shared_ptr<diaQMatrix> copy() {
            std::unordered_map<int, std::shared_ptr<diagonal>> newDiagonalMap;
        
            #pragma omp parallel for
            for (size_t i = 0; i < diagonalMap.size(); i++) {
                auto it = std::next(diagonalMap.begin(), i);
                std::shared_ptr<diagonal> d = it->second;
        
                #if NUM_BYTES_ALIGNED == -1
                    valType *real_vals = (valType *)calloc(d->dLength, sizeof(valType));
                    valType *imag_vals = (valType *)calloc(d->dLength, sizeof(valType));
                #else
                    valType *real_vals = aligned_alloc_helper(d->dLength * sizeof(valType));
                    valType *imag_vals = aligned_alloc_helper(d->dLength * sizeof(valType));
                    #pragma omp parallel for
                    for (unsigned int i = 0; i < d->dLength; i++) {
                        real_vals[i] = d->realValues[i];
                        imag_vals[i] = d->imagValues[i];
                    }
                #endif
        
                #pragma omp parallel for
                for (unsigned int i = 0; i < d->dLength; i++) {
                    real_vals[i] = d->realValues[i];
                    imag_vals[i] = d->imagValues[i];
                }
                std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(d->dIndex, d->dLength, real_vals, imag_vals);
                newDiagonalMap.insert({d->dIndex, newDiag});
            }
            unsigned int *newMatrixShape = new unsigned int[2]{matrix_shape[0], matrix_shape[1]};
            std::shared_ptr<diaQMatrix> newMatrix =std::make_shared<diaQMatrix>(newDiagonalMap, &newMatrixShape);
            return newMatrix;
        }

        valType norm() {
            valType norm = 0.0;
            #pragma omp parallel for reduction(+:norm)
            for (size_t i = 0; i < diagonalMap.size(); i++) {
                auto it = std::next(diagonalMap.begin(), i);
                std::shared_ptr<diagonal> d = it->second;
                valType *real_vals = d->realValues;
                valType *imag_vals = d->imagValues;
                valType local_norm = 0.0; // Use a local variable to accumulate within the SIMD loop
                #pragma omp simd reduction(+:local_norm)
                for (unsigned int i = 0; i < d->dLength; i++) {
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
                unsigned int overall_dim = matrix_shape[0] * matrix_shape[1]; // this is same as size, but I have to double check if I modify size everytime I modify matrix_shape.... TODO
                unsigned int sqrtProduct = static_cast<unsigned int>(std::sqrt(overall_dim));
                // Find the closest factors of the product
                unsigned int x = 1;
                unsigned int y = overall_dim;
                for (unsigned int i = sqrtProduct; i > 0; --i) {
                    if (overall_dim % i == 0) {
                        x = i;
                        y = overall_dim / i;
                        break;
                    }
                }
                // printf("new x = %ld, y = %ld\n", x, y);
                unsigned int *new_shape = new unsigned int[2]{x, y};
                this->matrix_reshape(new_shape);
            }
        }

        std::shared_ptr<unsigned int[]> getMatrixPosition(unsigned int flat_index) {
            std::shared_ptr<unsigned int[]> mat_pos(new unsigned int[2]);  //Works in C++11 & C++17
            mat_pos[0] = flat_index / matrix_shape[1];
            mat_pos[1] = flat_index % matrix_shape[1];
            return mat_pos;
        }

        std::shared_ptr<unsigned int[]> getMatrixPosition(int diagonal_idx, unsigned int diagonal_pos) {
            std::shared_ptr<unsigned int[]> mat_pos(new unsigned int[2]);
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

        std::vector<unsigned int> getTensorPosition(int diagonal_idx, unsigned int diagonal_pos) {
            std::shared_ptr<unsigned int[]> mat_pos = getMatrixPosition(diagonal_idx, diagonal_pos);
            unsigned int total_elements = matrix_shape[0] * matrix_shape[1];
            unsigned int ndim = shape.size();
            unsigned int flat_index = mat_pos[0] * matrix_shape[1] + mat_pos[1];
            std::vector<unsigned int> ten_pos(ndim);
            unsigned int prod = 1;
            // std::cout << "flat_index = " << flat_index << " prod = " << prod << std::endl;
            #pragma unroll
            for (unsigned int i = 0; i < ndim; i++) {
                prod *= shape[i];
                // std::cout << "flat_index = " << flat_index << " prod = " << prod << std::endl;
                ten_pos[i] = (flat_index / (total_elements / prod)) % shape[i];
                flat_index = flat_index - (total_elements / prod) * ten_pos[i];
            }
            return ten_pos;
        }
        void setDiagFlatData(unsigned int n_diags, int *diagonal_indices, unsigned int *cum_diagonal_lengths, valType *real_data, valType *imag_data) {
            // ------------------ DEBUG ------------------
            // std::cout << "n_diags = " << n_diags << std::endl;
            // std::cout << "num_elements = " << num_elements << std::endl;
            // std::cout << "diagonal_indices = [";
            // for (unsigned int i = 0; i < n_diags - 1; i++) {
            //     std::cout << diagonal_indices[i] << ",";
            // }
            // std::cout << diagonal_indices[n_diags - 1] << "]" << std::endl;
            // std::cout << "cum_diagonal_lengths = [";
            // for (unsigned int i = 0; i < n_diags - 1; i++) {
            //     std::cout << cum_diagonal_lengths[i] << ",";
            // }
            // std::cout << cum_diagonal_lengths[n_diags - 1] << "]" << std::endl;
            // std::cout << "real_data = [";
            // for (unsigned int i = 0; i < num_elements - 1; i++) {
            //     std::cout << real_data[i] << ",";
            // }
            // std::cout << real_data[num_elements - 1] << "]" << std::endl;
            // std::cout << "imag_data = [";
            // for (unsigned int i = 0; i < num_elements - 1; i++) {
            //     std::cout << imag_data[i] << ",";
            // }
            // std::cout << imag_data[num_elements - 1] << "]" << std::endl;
            // ------------------ DEBUG ------------------
            for (unsigned int i = 0; i < n_diags; i++) {
                int dIndex = diagonal_indices[i];
                unsigned int dLength = cum_diagonal_lengths[i];
                // std::cout << "dIndex = " << dIndex << " dLength = " << dLength << std::endl;
                #ifndef CUDA_ENABLED
                    #if NUM_BYTES_ALIGNED == -1
                        valType *real_vals = (valType *)calloc(dLength, sizeof(valType));
                        valType *imag_vals = (valType *)calloc(dLength, sizeof(valType));
                    #else
                        valType *real_vals = aligned_alloc_helper(dLength * sizeof(valType));
                        valType *imag_vals = aligned_alloc_helper(dLength * sizeof(valType));
                        #pragma omp parallel for
                        for(unsigned int i = 0; i < dLength; i++) {
                            real_vals[i] = 0.0;
                            imag_vals[i] = 0.0;
                        }
                    #endif
                #else
                    valType *real_vals = (valType *)calloc(dLength, sizeof(valType));
                    valType *imag_vals = (valType *)calloc(dLength, sizeof(valType));
                #endif
                #pragma omp parallel for
                for (unsigned int j = 0; j < dLength; j++) {
                    real_vals[j] = real_data[j];
                    imag_vals[j] = imag_data[j];
                }
                std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(dIndex, dLength, real_vals, imag_vals);
                (this->diagonalMap).insert({dIndex, newDiag});
            }
        }
        void getDiagFlatData(unsigned int *n_diags, int **diagonal_indices, unsigned int **cum_diagonal_lengths, unsigned int *num_elements, valType **real_data, valType **imag_data) {
            *n_diags = diagonalMap.size();
            // ------------------ DEBUG ------------------
            // std::cout << "n_diags = " << *n_diags << std::endl;
            // ------------------ DEBUG ------------------
            (*diagonal_indices) = (int *)calloc(*n_diags, sizeof(int));
            (*cum_diagonal_lengths) = (unsigned int *)calloc(*n_diags, sizeof(unsigned int));
            *num_elements = 0;
            unsigned int k = 0;
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
            // for (unsigned int i = 0; i < *n_diags; i++) {
            //     std::cout << (*cum_diagonal_lengths)[i] << ",";
            // }
            // std::cout << std::endl;
            // ------------------ DEBUG ------------------
            unsigned int p = 0;
            #ifndef CUDA_ENABLED
                #if NUM_BYTES_ALIGNED == -1
                    (*real_data) = (valType *)calloc(*num_elements, sizeof(valType));
                    (*imag_data) = (valType *)calloc(*num_elements, sizeof(valType));
                #else
                    (*real_data) = aligned_alloc_helper(*num_elements * sizeof(valType));
                    (*imag_data) = aligned_alloc_helper(*num_elements * sizeof(valType));
                    #pragma omp parallel for
                    for(unsigned int i = 0; i < *num_elements; i++) {
                        (*real_data)[i] = 0.0;
                        (*real_data)[i] = 0.0;
                    }
                #endif
            #else
                (*real_data) = (valType *)calloc(*num_elements, sizeof(valType));
                (*imag_data) = (valType *)calloc(*num_elements, sizeof(valType));
            #endif
            for (auto x : diagonalMap) {
                valType *real_vals = x.second->realValues;
                valType *imag_vals = x.second->imagValues;
                #pragma omp parallel for
                for (unsigned int i = 0; i < x.second->dLength; i++) {
                    (*real_data)[p] = real_vals[i];
                    (*imag_data)[p++] = imag_vals[i];
                }
            }
            // ------------------ DEBUG ------------------
            // std::cout << "real_data = ";
            // for (unsigned int i = 0; i < *num_elements; i++) {
            //     std::cout << (*real_data)[i] << ",";
            // }
            // std::cout << std::endl;
            // std::cout << "imag_data = ";
            // for (unsigned int i = 0; i < *num_elements; i++) {
            //     std::cout << (*imag_data)[i] << ",";
            // }
            // std::cout << std::endl;
            // ------------------ DEBUG ------------------
        }
        std::shared_ptr<int[]> getDiagonalPositionByFlatIndex(unsigned int flatIndex) {
            unsigned int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            unsigned int mat_y = flatIndex % matrix_shape[1];
            // std::cout << "(x,y) = (" << mat_x << "," << mat_y << ")" << std::endl;
            std::shared_ptr<int[]> res = std::shared_ptr<int[]>(new int[2]);
            // diagonal index is just j - i
            int d_idx = mat_y - mat_x;
            res[0] = d_idx;
            // getting the position in that diagonal
            if(d_idx <= 0) {
                res[1] = mat_y;
            } else {
                res[1] = (mat_y - d_idx);
            }
            return res;
        }

        unsigned int getFlatIndex(int d_idx, unsigned int d_pos) {
            unsigned int mat_x, mat_y;
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
        
        unsigned int getFlatIndex(std::shared_ptr<unsigned int[]> matrix_pos) {
            return matrix_pos[0] * matrix_shape[1] + matrix_pos[1];
        }
        
        unsigned int getFlatIndex(std::vector<unsigned int> ten_pos) {
            unsigned int total_elements = 1;
            for(size_t i = 0;i < shape.size(); i++)
                total_elements = total_elements * shape[i];
            unsigned int flat_index = 0;
            unsigned int prod = 1;
            #pragma unroll
            for(size_t i = 0; i < shape.size() ; i++) {
                prod *= shape[i];
                flat_index = flat_index + (total_elements / prod) * ten_pos[i];
            }
            return flat_index;
        }
        
        std::shared_ptr<int[]> getDiagonalPosition(std::shared_ptr<unsigned int[]> matrix_pos) {
            unsigned int flatIndex = getFlatIndex(matrix_pos);
            unsigned int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            unsigned int mat_y = flatIndex % matrix_shape[1];
            std::shared_ptr<int[]> res(new int[2]);
            int d_idx = mat_y - mat_x;
            res[0] = (d_idx);
            if(d_idx <= 0) {
                res[1] = (mat_y);
            } else {
                res[1] = (mat_y - d_idx);
            }
            return res;
        }

        std::shared_ptr<int[]> getDiagonalPosition(unsigned int flatIndex) {
            int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            int mat_y = flatIndex % matrix_shape[1];
            // std::cout << "(x,y) = (" << mat_x << "," << mat_y << ")" << std::endl;
            std::shared_ptr<int[]> res = std::shared_ptr<int[]>(new int[2]);
            // diagonal index is just j - i
            int d_idx = mat_y - mat_x;
            res[0] = (d_idx);
            // getting the position in that diagonal
            if(d_idx <= 0) {
                res[1] = (mat_y);
            } else {
                res[1] = (mat_y - d_idx);
            }
            return res;
        }

        std::shared_ptr<int[]> getDiagonalPosition(std::vector<unsigned int> ten_pos) {
            // returns {diagonal_idx, position_in_this_idx}
            unsigned int flatIndex = getFlatIndex(ten_pos);
            // std::cout << "shape = " << shape[0] << "," << shape[1] << std::endl;
            unsigned int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            unsigned int mat_y = flatIndex % matrix_shape[1];
            // std::cout << "(x,y) = (" << mat_x << "," << mat_y << ")" << std::endl;
            std::shared_ptr<int[]> res(new int[2]);
            // diagonal index is just j - i
            int d_idx = mat_y - mat_x;
            res[0] = (d_idx);
            // getting the position in that diagonal
            if(d_idx <= 0) {
                res[1] = (mat_y);
            } else {
                res[1] = (mat_y - d_idx);
            }
            return res;
        }

        unsigned int getDiagonalLength(int dIndex) {
            // std::cout << "diag_Index = " << dIndex << " ";
            unsigned int lenRes;
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
        
        unsigned int num_diags() {
            return diagonalMap.size();
        }
        std::vector<std::shared_ptr<diagonal>> getDiagonals() {
            std::vector<std::shared_ptr<diagonal>> res;
            for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                res.push_back(it->second);
            }
            return res;
        }
        std::complex<valType> *flatten() {
            std::complex<valType> *res = new std::complex<valType>[matrix_shape[0] * matrix_shape[1]];
            std::fill(res, res + matrix_shape[0] * matrix_shape[1], std::complex<valType>(1));
            for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                int dIndex = it->first;
                unsigned int dLength = it->second->dLength;
                valType *real_vals = it->second->realValues;
                valType *imag_vals = it->second->imagValues;
                #pragma omp parallel for
                for (unsigned int i = 0; i < dLength; i++) {
                    std::shared_ptr<unsigned int[]> mat_pos = getMatrixPosition(dIndex, i);
                    unsigned int flat_index = mat_pos[0] * matrix_shape[1] + mat_pos[1];
                    res[flat_index] = std::complex<valType>(real_vals[i], imag_vals[i]);
                }
            }
            return res;
        }
        valType sparsity() {
            unsigned int z = 0;
            for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                z += it->second->numNonZeros();
            }
            valType z_val = (valType) z;
            valType size_val = (valType) matrix_shape[0] * matrix_shape[1];
            printf("z_val = %f, size_val = %f\n", z_val, size_val);
            return 1.0 - z_val / size_val;
        }
        void pruneMatrix() {
            std::vector<unsigned int> toDelete;
            for (auto it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                valType *real_vals = it->second->realValues;
                valType *imag_vals = it->second->imagValues;
                unsigned int i;
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
        std::shared_ptr<diagonal> operator[](int dIndex) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                throw std::out_of_range("diagonal index not found");
            }
            return it->second;
        }
        std::shared_ptr<diaQMatrix> reshape(std::vector<unsigned int> new_tensor_shape);
        void matrix_reshape(unsigned int *new_matrix_shape);
        void transpose(std::vector<unsigned int> new_order);
        void transpose();
        std::shared_ptr<denseMatrix> convertToDenseMatrix(unsigned int *new_shape);
        std::shared_ptr<denseMatrix> convertToDenseMatrix();
};

} // namespace diaq

#endif // DIAQ_DIAQMATRIX_HPP