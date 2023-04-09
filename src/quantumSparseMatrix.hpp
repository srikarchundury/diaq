#ifndef SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP
#define SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP

#include "diagonal.hpp"
#include <map>
#include <numeric>

class denseMatrix; // telling this class exists w/o defining it here


class quantumSparseMatrix {
    public:
        std::vector<int> shape; // as of now, this is always a 2 element array
        std::vector<int> tensor_shape;

        quantumSparseMatrix(int s) {
            std::map<int, diagonal> d;
            diagonalMap = d;
            size = s;
            shape.push_back(s);
            shape.push_back(s);
            tensor_shape.push_back(s);
            tensor_shape.push_back(s);
        }
        quantumSparseMatrix(std::vector<int> *dimens) {
            std::map<int, diagonal> d;
            diagonalMap = d;
            shape = *dimens;
            size = shape[0];
            tensor_shape = *dimens;
        }
        quantumSparseMatrix(std::map<int, diagonal> dm, int s) {
            std::map<int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            size = s;
            shape.push_back(s);
            shape.push_back(s);
            tensor_shape.push_back(s);
            tensor_shape.push_back(s);
        }
        quantumSparseMatrix(std::map<int, diagonal> dm, std::vector<int> *d) {
            std::map<int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            shape = *d;
            size = shape[0];
            tensor_shape = *d;
        }
        quantumSparseMatrix(std::map<int, diagonal> dm, std::vector<int> *d, std::vector<int> *ts) {
            std::map<int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            shape = *d;
            tensor_shape = *ts;
            size = shape[0];
        }
        int getSize() {
            return size;
        }
        std::complex<double> getItem(std::vector<int> ten_pos) {
            std::vector<int> d_pos = getDiagonalPosition(ten_pos);
            auto it = diagonalMap.find(d_pos[0]);
            if(it == diagonalMap.end()) {
                throw std::length_error("out of bounds");
            }
            else {
                return it->second.getValue(d_pos[1]);
            }
        }
        std::map<int, diagonal> getDiagonalMap() {
            return diagonalMap;
        }
        void print() {
            std::cout << "matrix_shape (";
            for(int i = 0; i < shape.size()-1; i++) {
                std::cout << shape[i] << ",";
            }
            std::cout << shape[shape.size()-1] << ")" << std::endl;
            std::cout << "tensor_shape (";
            for(int i = 0; i < tensor_shape.size()-1; i++) {
                std::cout << tensor_shape[i] << ",";
            }
            std::cout << tensor_shape[tensor_shape.size()-1] << ")" << std::endl;
            std::map<int, diagonal>::iterator it;
            for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                it->second.print();
            }
        }
        void createDiagonal(int dIndex) {
            diagonal newDiag(dIndex);
            this->diagonalMap.insert({dIndex, newDiag});
        }
        diagonal* getDiagonal(int dIndex) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                createDiagonal(dIndex);
                return getDiagonal(dIndex);
            }
            else {
                // it->second.print(size);
                return &it->second;
            }
        }
        void setDiagonalElement(int dIndex, int dPos, int dLen, std::complex<double> val) {
            // std::cout << "setDiagonalElement called " << dIndex << " " << dPos << std::endl;
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                std::vector<std::complex<double> > vals(dLen, 0);
                vals[dPos] = val;
                diagonal newDiag(dIndex, &vals);
                this->diagonalMap.insert({dIndex, newDiag});
            }
            else {
                it->second.setValue(dPos, val);
            }
        }
        void addToDiagonal(int dIndex, std::complex<double> val) {
            diagonal* d = this->getDiagonal(dIndex);
            d->addElement(val);
        }
        void setDiagonal(int dIndex, diagonal diagNew) {
            this->diagonalMap.erase(dIndex);
            this->diagonalMap.insert({dIndex, diagNew});
        }
        void addDiagonal(int dIndex, diagonal diagNew) {
            auto it = diagonalMap.find(dIndex);
            if(it == diagonalMap.end()) {
                // std::cout << "new index" << std::endl;
                this->diagonalMap.insert({dIndex, diagNew});
            }
            else {
                // std::cout << "already exists, overwrite" << std::endl;
                for(int i = 0; i < it->second.getValues().size(); i++) {
                    it->second.setValue(i, it->second.getValue(i) + diagNew.getValue(i));
                }
            }
        }
        std::vector<int> getMatrixPosition(int diagonal_idx, int diagonal_pos) {
            std::vector<int> mat_pos;
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
            if(mat_pos[0] >= shape[0] || mat_pos[1] >= shape[1]) {
                std::cout << "diagonal pos (" << diagonal_idx << "," << diagonal_pos << ") in matrix of size (" << shape[0] << "," << shape[1] << ")" << std::endl;
                std::cout << "got pos (" << mat_pos[0] << "," << mat_pos[1] << ") in matrix of size (" << shape[0] << "," << shape[1] << ")" << std::endl;
                throw std::length_error("out of matrix");
            }
            return mat_pos;
        }
        std::vector<int> getTensorPosition(int diagonal_idx, int diagonal_pos) {
            std::vector<int> mat_pos = getMatrixPosition(diagonal_idx, diagonal_pos);
            int total_elements = shape[0] * shape[1];
            int ndim = tensor_shape.size();
            int flat_index = mat_pos[0] * shape[1] + mat_pos[1];
            std::vector<int> ten_pos(ndim);
            int prod = 1;
            // std::cout << "flat_index = " << flat_index << " prod = " << prod << std::endl;
            for (int i = 0; i < ndim; i++) {
                prod *= tensor_shape[i];
                // std::cout << "flat_index = " << flat_index << " prod = " << prod << std::endl;
                ten_pos[i] = (flat_index / (total_elements / prod)) % tensor_shape[i];
                flat_index = flat_index - (total_elements / prod) * ten_pos[i];
            }
            return ten_pos;
        }
        int getFlatIndex(std::vector<int> ten_pos) {
            int total_elements = 1;
            for(int i = 0;i<tensor_shape.size();i++)
                total_elements = total_elements * tensor_shape[i];
            int flat_index = 0;
            int prod = 1;
            int remaining;
            for(int i = 0; i < tensor_shape.size() ; i++) {
                prod *= tensor_shape[i];
                flat_index = flat_index + (total_elements / prod) * ten_pos[i];
            }
            return flat_index;
        }
        std::vector<int> getDiagonalPosition(std::vector<int> ten_pos) {
            // returns {diagonal_idx, position_in_this_idx}
            int flatIndex = getFlatIndex(ten_pos);
            // std::cout << "flatIndex = " << flatIndex << std::endl;
            // std::cout << "shape = " << shape[0] << "," << shape[1] << std::endl;
            int mat_x = flatIndex / shape[1];
            flatIndex = flatIndex - shape[1] * mat_x;
            int mat_y = flatIndex % shape[1];
            // std::cout << "(x,y) = (" << mat_x << "," << mat_y << ")" << std::endl; 
            std::vector<int> res;
            // diagonal index is just j - i
            int d_idx = mat_y - mat_x;
            res.push_back(d_idx);
            // getting the position in that diagonal
            if(d_idx <= 0){
                res.push_back(mat_y);
            } else{
                res.push_back(mat_y - d_idx);
            }
            return res;
        }
        void pruneMatrix() {
            std::vector<int> toDelete;
            std::map<int, diagonal>::iterator it;
            for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                int counter = 0;
                std::vector<std::complex<double> > vals = it->second.getValues();
                for (int i = 0; i < vals.size(); i++) {
                    if(vals[i] == 0.0) { counter++; }
                    else {break;}
                }
                if(counter == vals.size()) {
                   toDelete.push_back(it->first);
                }
            }
            for(int i=0;i < toDelete.size(); i++) {
                this->diagonalMap.erase(toDelete[i]);
            }
        }
        int denseCapacity() {
            int c = 1;
            for(int i = 0; i < shape.size(); i++) {
                c = c * shape[i];
            }
            return c;
        }
        denseMatrix convertToDenseMatrix(std::vector<int> new_shape);
    private:
        int size;
        std::map<int, diagonal> diagonalMap; // map <dIndex, diagonal object>
};

#endif // SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP