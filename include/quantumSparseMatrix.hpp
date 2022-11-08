#ifndef SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP
#define SPARSE_TNQS_QUANTUMSPARSEMATRIX_HPP

#include "diagonal.hpp"
#include <map>


class quantumSparseMatrix {
    public:
        quantumSparseMatrix(std::map<int, diagonal> dm, int s) {
            std::map<int, diagonal>::iterator it;
            for (it = dm.begin(); it != dm.end(); it++) {
                diagonalMap.insert({it->first, it->second});
            }
            size = s;
        }
        void print() {
            std::map<int, diagonal>::iterator it;
            for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                std::cout << "diagIndex=" << it->first << " ";
                it->second.print(this->size);
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
        void addToDiagonal(int dIndex, int val) {
            diagonal* d = this->getDiagonal(dIndex);
            d->addElement(val);
        }
        void pruneMatrix() {
            std::vector<int> toDelete;
            std::map<int, diagonal>::iterator it;
            for (it = diagonalMap.begin(); it != diagonalMap.end(); it++) {
                int counter = 0;
                for (int i = 0; i < it->second.values.size(); i++) {
                    if(it->second.values[i] != 0) break;
                    else counter++;
                }
                if(counter == it->second.values.size()) {
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