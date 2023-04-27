#ifndef SPARSE_TNQS_DIAGONAL_HPP
#define SPARSE_TNQS_DIAGONAL_HPP

#include <iostream>
#include <string>
#include <vector>
#include <complex>


class diagonal {
    public:
        int dIndex; // -(n-1),..0,..n-1 and n,.., 2n-2
        int dLength;
        diagonal(int di) {
            dIndex = di;
        }
        diagonal(int di, int dl) {
            dIndex = di;
            dLength = dl;
            float *realVals = (float *)calloc(dl, sizeof(float));
            float *imagVals = (float *)calloc(dl, sizeof(float));
            realValues = realVals;
            imagValues = imagVals;
        }
        diagonal(int di, int dl, float *realVals, float *imagVals) {
            dIndex = di;
            realValues = realVals;
            imagValues = imagVals;
            dLength = dl;
        }
        int getIndex() {
            return dIndex;
        }
        void setIndex(int newIndex) {
            dIndex = newIndex;
        }
        void setElements(float *new_realVals, float *new_imagVals) {
            realValues = new_realVals;
            imagValues = new_imagVals;
        }
        void addElements(float *new_realVals, float *new_imagVals, int from_index, int to_index) {
            for(int i = from_index; i<=to_index; i++) {
                realValues[i] = new_realVals[i];
                imagValues[i] = new_imagVals[i];
            }
        }
        void setValue(int i, float real_val, float imag_val) {
            // std::cout << "there" << std::endl;
            realValues[i] = real_val;
            imagValues[i] = imag_val;
        }
        std::complex<float> getValue(int i) {
            std::complex<float> ans{realValues[i], imagValues[i]};
            return ans;
        }
        float getRealValue(int i) {
            return realValues[i];
        }
        float getImagValue(int i) {
            return imagValues[i];
        }
        bool isEmpty() {
            for(int i=0; i < dLength; i++) {
                if(realValues[i] != 0.0 or imagValues[i] != 0.0) return false;
            }
            return true;
        }
        void print() {
            std::string sep=",";
            // int *coords= this->getCoords(matrixSize, this->dIndex);
            std::cout << "(dIndex=" << dIndex << ") ";
            std::cout << "[" << "";
            int n = dLength;
            for (int i = 0; i < n-1; i++) {
                std::cout <<  "(" << realValues[i] << "," << imagValues[i] << ")" << sep;
            }
            std::cout <<  "(" << realValues[n-1] << "," << imagValues[n-1] << ")" << "";
            std::cout << "]" << "";
            std::cout << std::endl;
        }
        float *getRealValues() {
            return realValues;
        }
        float *getImagValues() {
            return imagValues;
        }
        int getSize() {
            return dLength;
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
            for(int i = 0; i < dLength; i++) {
                if(realValues[i] != 0 || imagValues[i] != 0) {
                    count++;
                }
            }
            return count;
        }
    private:
        float* realValues; // real number array
        float* imagValues; // real number array
};

#endif // SPARSE_TNQS_DIAGONAL_HPP