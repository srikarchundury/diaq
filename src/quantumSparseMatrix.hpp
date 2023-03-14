#ifndef SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP
#define SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP

#include "diagonal.hpp"
#include <map>


class quantumSparseMatrix {
    public:
        quantumSparseMatrix(int s) {
            std::map<int, diagonal> d;
            diagonalMap = d;
            size = s;
            dims.push_back(s);
            dims.push_back(s);
        }
        quantumSparseMatrix(std::vector<int> *dimens) {
            std::map<int, diagonal> d;
            diagonalMap = d;
            dims = *dimens;
            size = dims[0];
        }
        quantumSparseMatrix(std::map<int, diagonal> dm, int s) {
            std::map<int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            size = s;
            dims.push_back(s);
            dims.push_back(s);
        }
        quantumSparseMatrix(std::map<int, diagonal> dm, std::vector<int> d) {
            std::map<int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            size = d[0];
            dims = d;
        }
        int getSize() {
            return size;
        }
        int getDim(int i) {
            return dims[i];
        }
        std::vector<int> getDims() {
            return dims;
        }
        std::map<int, diagonal> getDiagonalMap() {
            return diagonalMap;
        }
        void print() {
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
            for(int i = 0; i < dims.size(); i++) {
                c = c * dims[i];
            }
            return c;
        }
        std::vector<std::complex<double>> convertToDenseMatrix() {
            std::vector<std::complex<double>> data(denseCapacity());
            std::map<int, diagonal>::iterator it;
            int x, y;
            for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                std::vector<std::complex<double> > vals = it->second.getValues();
                if (it->first == 0) {
                    x = 0;
                    y = 0;
                }
                else if (it->first > 0) {
                    x = 0;
                    y = it->first;
                }
                else {
                    x = -1 * it->first;
                    y = 0;
                }
                for (int i = 0; i < vals.size(); i++) {
                    data[ dims[1] * x + y ] = vals[i];
                    x++;
                    y++;
                }
            }
            return data;
        }
    private:
        int size;
        std::map<int, diagonal> diagonalMap; // map <dIndex, diagonal object>
        std::vector<int> dims; // as of now, this is always a 2 element array
};

#endif // SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP