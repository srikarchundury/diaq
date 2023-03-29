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
        int getDim(int i) {
            return shape[i];
        }
        std::vector<int> getShape() {
            return shape;
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
                mat_pos[0] += (diagonal_pos-1);
                mat_pos[1] += (diagonal_pos-1);
            }
            if(mat_pos[0] >= shape[0] || mat_pos[1] >= shape[1]) {
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
            int remaining;
            for (int i = ndim-1; i > 0; i--) {
                prod *= tensor_shape[i];
                remaining = total_elements / prod;
                std::cout << "flat_index = " << flat_index << " prod = " << prod << " rem = " << remaining << " " << std::endl;
                ten_pos[i] = flat_index % remaining;
                flat_index = flat_index / tensor_shape[i];
            }
            ten_pos[0] = flat_index;
            return ten_pos;
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