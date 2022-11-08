#ifndef SPARSE_TNQS_DIAGONAL_HPP
#define SPARSE_TNQS_DIAGONAL_HPP

#include <iostream>
#include <string>
#include <vector>


class diagonal {
    public:
        diagonal(const int di) {
            dIndex = di;
        }
        bool addElement(std::complex<double> value) {
            values.push_back(value);
            return true;
        }
        void print(int matrixSize, std::string sep=",") {
            int *coords= this->getCoords(matrixSize, this->dIndex);
            std::cout << "(" << coords[0] << "," << coords[1] << ")";
            std::cout << "[" << "";
            int n = values.size();
            for (int i = 0; i < n-1; i++) {
                std::cout << values[i] << sep;
            }
            std::cout << values[n-1] << "";
            std::cout << "]" << "";
            std::cout << std::endl;
        }
        // returns the start (x, y) of diagonal of the matrix
        int* getCoords(int matrixSize, int dIndex) {
            static int c[2];
            if(dIndex >= matrixSize) {
                c[0] = dIndex - matrixSize + 1; c[1] = matrixSize - 1;
            }
            else if(dIndex == 0){
                c[0] = 0; c[1] = 0;
            }
            else if(dIndex < 0) {
                c[0] = -1 * dIndex; c[1] = 0;
            }
            else {
               c[0] = 0; c[1] = dIndex;
            }
            return c;
        }
        // returns the dIndex based on start coords
        int getDIndex(int *coords, int matrixSize) {
            if(coords[0] == 0){
                return coords[1];
            }
            else {
                if(coords[1] == 0) {
                    return coords[0];
                }
            }
            return coords[1];
        }
        int numNonZeros() {
            int count = 0;
            for(int i = 0; i < values.size(); i++) {
                if(real(values[i]) != 0 || imag(values[i]) != 0) {
                    count++;
                }
            }
            return count;
        }
    private:
        int dIndex; // -(n-1),..0,..n-1 and n,.., 2n-2
        std::vector<int> values; // most things are -1, 0, 1.
};

#endif // SPARSE_TNQS_DIAGONAL_HPP