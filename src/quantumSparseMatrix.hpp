#ifndef SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP
#define SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP

#include "diagonal.hpp"
#include <map>
#include <numeric>
#include <omp.h>
#include "config.hpp"


class denseMatrix; // telling this class exists w/o defining it here


class quantumSparseMatrix {
    public:
        std::vector<long int> matrix_shape; // as of now, this is always a 2 element array
        std::vector<long int> tensor_shape;

        quantumSparseMatrix(long int s) {
            std::map<long int, diagonal> d;
            diagonalMap = d;
            size = s;
            matrix_shape.push_back(s);
            matrix_shape.push_back(s);
            tensor_shape.push_back(s);
            tensor_shape.push_back(s);
        }
        quantumSparseMatrix(std::vector<long int> *dimens) {
            std::map<long int, diagonal> d;
            diagonalMap = d;
            matrix_shape = *dimens;
            size = matrix_shape[0];
            tensor_shape = *dimens;
        }
        quantumSparseMatrix(std::map<long int, diagonal> dm, long int s) {
            std::map<long int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            size = s;
            matrix_shape.push_back(s);
            matrix_shape.push_back(s);
            tensor_shape.push_back(s);
            tensor_shape.push_back(s);
        }
        quantumSparseMatrix(std::map<long int, diagonal> dm, std::vector<long int> *d) {
            std::map<long int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            matrix_shape = *d;
            size = matrix_shape[0];
            tensor_shape = *d;
        }
        quantumSparseMatrix(std::map<long int, diagonal> dm, std::vector<long int> *d, std::vector<long int> *ts) {
            std::map<long int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            matrix_shape = *d;
            tensor_shape = *ts;
            size = matrix_shape[0];
        }
        long int getSize() {
            return size;
        }
        std::complex<float> getItem(std::vector<long int> ten_pos) {
            std::vector<long int> d_pos = getDiagonalPosition(ten_pos);
            auto it = diagonalMap.find(d_pos[0]);
            if(it == diagonalMap.end()) {
                throw std::length_error("out of bounds");
            }
            else {
                return it->second.getValue(d_pos[1]);
            }
        }
        std::map<long int, diagonal> getDiagonalMap() {
            return diagonalMap;
        }
        void print() {
            std::cout << "matrix_shape (";
            for(long int i = 0; i < matrix_shape.size()-1; i++) {
                std::cout << matrix_shape[i] << ",";
            }
            std::cout << matrix_shape[matrix_shape.size()-1] << ")" << std::endl;
            std::cout << "tensor_shape (";
            for(long int i = 0; i < tensor_shape.size()-1; i++) {
                std::cout << tensor_shape[i] << ",";
            }
            std::cout << tensor_shape[tensor_shape.size()-1] << ")" << std::endl;
            std::map<long int, diagonal>::iterator it;
            for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                it->second.print();
            }
        }
        void createDiagonal(long int dIndex) {
            diagonal newDiag(dIndex, getDiagonalLength(dIndex));
            this->diagonalMap.insert({dIndex, newDiag});
        }
        diagonal *getDiagonal(long int dIndex) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                createDiagonal(dIndex);
                return getDiagonal(dIndex);
            }
            else {
                // it->second.prlong int(size);
                return &it->second;
            }
        }
        void setDiagonalElement(long int dIndex, long int dPos, long int dLen, float real_val, float imag_val) {
            // std::cout << "setDiagonalElement called " << dIndex << " " << dPos << std::endl;
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                float *real_vals = (float *)calloc(dLen, sizeof(float));
                float *imag_vals = (float *)calloc(dLen, sizeof(float));
                real_vals[dPos] = real_val;
                imag_vals[dPos] = imag_val;
                diagonal newDiag(dIndex, dLen, real_vals, imag_vals);
                this->diagonalMap.insert({dIndex, newDiag});
            }
            else {
                it->second.setValue(dPos, real_val, imag_val);
            }
        }
        void setDiagonal(long int dIndex, diagonal diagNew) {
            this->diagonalMap.erase(dIndex);
            this->diagonalMap.insert({dIndex, diagNew});
        }
        void addDiagonal(long int dIndex, diagonal diagNew) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                // std::cout << "new index" << std::endl;
                this->diagonalMap.insert({dIndex, diagNew});
            }
            else {
                // std::cout << "already exists, overwrite" << std::endl;
                for(long int i = 0; i < it->second.dLength; i++) {
                    it->second.setValue(
                        i,
                        it->second.getRealValue(i) + diagNew.getRealValue(i),
                        it->second.getImagValue(i) + diagNew.getImagValue(i)
                    );
                }
            }
        }
        std::vector<long int> getMatrixPosition(long int diagonal_idx, long int diagonal_pos) {
            std::vector<long int> mat_pos;
            if(diagonal_idx == 0) {
                mat_pos.push_back(diagonal_pos);
                mat_pos.push_back(diagonal_pos);
            }
            else {
                if(diagonal_idx < 0) {
                    mat_pos.push_back(abs(diagonal_idx));
                    mat_pos.push_back(0);
                }
                else {
                    mat_pos.push_back(0);
                    mat_pos.push_back(abs(diagonal_idx));
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
            std::vector<long int> mat_pos = getMatrixPosition(diagonal_idx, diagonal_pos);
            long int total_elements = matrix_shape[0] * matrix_shape[1];
            long int ndim = tensor_shape.size();
            long int flat_index = mat_pos[0] * matrix_shape[1] + mat_pos[1];
            std::vector<long int> ten_pos(ndim);
            long long int prod = 1;
            // std::cout << "flat_index = " << flat_index << " prod = " << prod << std::endl;
            #pragma unroll
            for (long int i = 0; i < ndim; i++) {
                prod *= tensor_shape[i];
                // std::cout << "flat_index = " << flat_index << " prod = " << prod << std::endl;
                ten_pos[i] = (flat_index / (total_elements / prod)) % tensor_shape[i];
                flat_index = flat_index - (total_elements / prod) * ten_pos[i];
            }
            return ten_pos;
        }
        std::vector<long int> getDiagonalPositionByFlatIndex(long int flatIndex) {
            long int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            long int mat_y = flatIndex % matrix_shape[1];
            // std::cout << "(x,y) = (" << mat_x << "," << mat_y << ")" << std::endl;
            std::vector<long int> res;
            // diagonal index is just j - i
            long int d_idx = mat_y - mat_x;
            res.push_back(d_idx);
            // getting the position in that diagonal
            if(d_idx <= 0) {
                res.push_back(mat_y);
            } else {
                res.push_back(mat_y - d_idx);
            }
            return res;
        } 
        long int getFlatIndex(std::vector<long int> ten_pos) {
            long int total_elements = 1;
            for(long int i = 0;i < tensor_shape.size(); i++)
                total_elements = total_elements * tensor_shape[i];
            long int flat_index = 0;
            long long int prod = 1;
            #pragma unroll
            for(long int i = 0; i < tensor_shape.size() ; i++) {
                prod *= tensor_shape[i];
                flat_index = flat_index + (total_elements / prod) * ten_pos[i];
            }
            return flat_index;
        }
        std::vector<long int> getDiagonalPosition(std::vector<long int> ten_pos) {
            // returns {diagonal_idx, position_in_this_idx}
            long int flatIndex = getFlatIndex(ten_pos);
            // std::cout << "flatIndex = " << flatIndex << std::endl;
            // std::cout << "shape = " << shape[0] << "," << shape[1] << std::endl;
            long int mat_x = flatIndex / matrix_shape[1];
            flatIndex = flatIndex - matrix_shape[1] * mat_x;
            long int mat_y = flatIndex % matrix_shape[1];
            // std::cout << "(x,y) = (" << mat_x << "," << mat_y << ")" << std::endl;
            std::vector<long int> res;
            // diagonal index is just j - i
            long int d_idx = mat_y - mat_x;
            res.push_back(d_idx);
            // getting the position in that diagonal
            if(d_idx <= 0) {
                res.push_back(mat_y);
            } else {
                res.push_back(mat_y - d_idx);
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
        void pruneMatrix() {
            std::vector<long int> toDelete;
            std::map<long int, diagonal>::iterator it;
            // don't yet to parallelize loops like this.
            for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                long int counter = 0;
                float *real_vals = it->second.getRealValues();
                float *imag_vals = it->second.getImagValues();
                for (long int i = 0; i < it->second.dLength; i++) {
                    if(real_vals[i] == 0.0 && imag_vals[i] == 0.0) { counter++; }
                    else {break;}
                }
                if(counter == it->second.dLength) {
                    toDelete.push_back(it->first);
                }
            }
            for(long int i = 0; i < toDelete.size(); i++) {
                // TODO: again, same case as createDiagonal; .erase is thread-unsafe; makes it tough to use omp
                this->diagonalMap.erase(toDelete[i]);
            }
        }
        denseMatrix convertToDenseMatrix(std::vector<long int> new_shape);
    private:
        long int size;
        std::map<long int, diagonal> diagonalMap; // map <dIndex, diagonal object>
};

#endif // SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP