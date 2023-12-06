#ifndef DIAQ_DIAGONAL_HPP
#define DIAQ_DIAGONAL_HPP

#include <iostream>
#include <string>
#include <vector>
#include <complex>


class diagonal {
    public:
        long int dIndex; // -(n-1),..0,..n-1 and n,.., 2n-2
        long int dLength;
        diagonal(long int di) {
            dIndex = di;
        }
        diagonal(long int di, long int dl) {
            dIndex = di;
            dLength = dl;
            double *realVals = (double *)calloc(dl, sizeof(double));
            double *imagVals = (double *)calloc(dl, sizeof(double));
            realValues = realVals;
            imagValues = imagVals;
        }
        diagonal(long int di, long int dl, double *realVals, double *imagVals) {
            dIndex = di;
            realValues = realVals;
            imagValues = imagVals;
            dLength = dl;
        }
        void setIndex(long int newIndex) {
            dIndex = newIndex;
        }
        void setElements(double *new_realVals, double *new_imagVals) {
            realValues = new_realVals;
            imagValues = new_imagVals;
        }
        void addElements(double *new_realVals, double *new_imagVals, long int from_index, long int to_index) {
            for(long int i = from_index; i<=to_index; i++) {
                realValues[i] = new_realVals[i];
                imagValues[i] = new_imagVals[i];
            }
        }
        void setValue(long int i, double real_val, double imag_val) {
            // std::cout << "there" << std::endl;
            realValues[i] = real_val;
            imagValues[i] = imag_val;
        }
        std::complex<double> getValue(long int i) {
            std::complex<double> ans{realValues[i], imagValues[i]};
            return ans;
        }
        double getRealValue(long int i) {
            return realValues[i];
        }
        double getImagValue(long int i) {
            return imagValues[i];
        }
        bool isEmpty() {
            for(long int i=0; i < dLength; i++) {
                if(realValues[i] != 0.0 or imagValues[i] != 0.0) return false;
            }
            return true;
        }
        void print() {
            std::string sep=",";
            // long int *coords= this->getCoords(matrixSize, this->dIndex);
            std::cout << "(dIndex=" << dIndex << ") ";
            std::cout << "[" << "";
            long int n = dLength;
            for (long int i = 0; i < n-1; i++) {
                std::cout <<  "(" << realValues[i] << "," << imagValues[i] << ")" << sep;
            }
            std::cout <<  "(" << realValues[n-1] << "," << imagValues[n-1] << ")" << "";
            std::cout << "]" << "";
            std::cout << std::endl;
        }
        double *getRealValues() {
            return realValues;
        }
        double *getImagValues() {
            return imagValues;
        }
        // returns the start (x, y) of diagonal of the matrix
        long int* getCoords(long int matrixSize, long int dIndex) {
            static long int c[2];
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
        long int getDIndex(long int *coords, long int matrixSize) {
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
        long int numNonZeros() {
            long int count = 0;
            for(long int i = 0; i < dLength; i++) {
                if(realValues[i] != 0 || imagValues[i] != 0) {
                    count++;
                }
            }
            return count;
        }
    private:
        double* realValues; // real number array
        double* imagValues; // imag number array
};

#endif // DIAQ_DIAGONAL_HPP