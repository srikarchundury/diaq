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
        }
        quantumSparseMatrix(std::map<int, diagonal> dm, int s) {
            std::map<int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            size = s;
        }
        int getSize() {
            return size;
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
        // denseTensor convertToDenseTensor(quantumSparseTensor qt) {
        //     // TODO
        //     return denseTensor(std::vector<int> {5,5});
        // }
    private:
        int size;
        std::map<int, diagonal> diagonalMap; // map <dIndex, diagonal object>
};

#endif // SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP