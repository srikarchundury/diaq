#ifndef SPARSE_TNQS_DIAGONAL_HPP
#define SPARSE_TNQS_DIAGONAL_HPP

#include <iostream>
#include <string>
#include <vector>
#include <complex>


class diagonal {
    public:
        diagonal(int di) {
            dIndex = di;
        }
        diagonal(int di, std::vector<std::complex<double> >* vals) {
            dIndex = di;
            values = *vals;
        }
        int getIndex() {
            return dIndex;
        }
        bool addElement(std::complex<double> value) {
            values.push_back(value);
            return true;
        }
        void setValue(int i, std::complex<double> val) {
            // std::cout << "there" << std::endl;
            values[i] = val;
        }
        std::complex<double> getValue(int i) {
            // std::cout << "here" << std::endl;
            return values[i];
        }
        void print() {
            std::string sep=",";
            // int *coords= this->getCoords(matrixSize, this->dIndex);
            std::cout << "(dIndex=" << dIndex << ") ";
            std::cout << "[" << "";
            int n = values.size();
            for (int i = 0; i < n-1; i++) {
                std::cout << values[i] << sep;
            }
            std::cout << values[n-1] << "";
            std::cout << "]" << "";
            std::cout << std::endl;
        }
        std::vector<std::complex<double> > getValues() {
            return values;
        }
        int getSize() {
            return values.size();
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
                if(std::real(values[i]) != 0 || std::imag(values[i]) != 0) {
                    count++;
                }
            }
            return count;
        }
    private:
        int dIndex; // -(n-1),..0,..n-1 and n,.., 2n-2
        std::vector<std::complex<double> > values; // most things are -1, 0, 1.
};

#endif // SPARSE_TNQS_DIAGONAL_HPP