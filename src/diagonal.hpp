#ifndef DIAQ_DIAGONAL_HPP
#define DIAQ_DIAGONAL_HPP

#include <iostream>
#include <string>
#include <vector>
#include <complex>
#include <cstddef>

#include "config.hpp"

namespace diaq {

class diagonal {
    public:
        valType* realValues; // real number array
        valType* imagValues; // imaginary number array

        long int dIndex; // -(n-1),..0,..n-1 and n,.., 2n-2
        long int dLength;

        diagonal(long int di) {
            dIndex = di;
        }
        diagonal(long int di, long int dl) {
            dIndex = di;
            dLength = dl;
            #if NUM_BYTES_ALIGNED == -1
                realValues = (valType *)calloc(dl, sizeof(valType));
                imagValues = (valType *)calloc(dl, sizeof(valType));
            #else
                realValues = aligned_alloc_helper(dl * sizeof(valType));
                imagValues = aligned_alloc_helper(dl * sizeof(valType));
                #pragma omp parallel for
                for(long int i = 0; i < dl; i++) {
                    realValues[i] = 0.0;
                    imagValues[i] = 0.0;
                }
            #endif
        }
        diagonal(long int di, long int dl, valType *realVals, valType *imagVals) {
            dIndex = di;
            realValues = realVals;
            imagValues = imagVals;
            dLength = dl;
        }
        ~diagonal() {
            this->free();
        }
        void setIndex(long int newIndex) {
            dIndex = newIndex;
        }
        void setElements(valType *new_realVals, valType *new_imagVals) {
            realValues = new_realVals;
            imagValues = new_imagVals;
        }
        void addElements(valType *new_realVals, valType *new_imagVals, long int from_index, long int to_index) {
            #pragma omp parallel for
            for(long int i = from_index; i<=to_index; i++) {
                realValues[i] = new_realVals[i];
                imagValues[i] = new_imagVals[i];
            }
        }
        void setValue(long int i, valType real_val, valType imag_val) {
            // std::cout << "there" << std::endl;
            realValues[i] = real_val;
            imagValues[i] = imag_val;
        }
        std::complex<valType> getValue(long int i) {
            std::complex<valType> ans{realValues[i], imagValues[i]};
            return ans;
        }
        valType getRealValue(long int i) {
            // printf("getRealVal i=%ld, dLength=%ld\n", i, dLength);
            return realValues[i];
        }
        valType getImagValue(long int i) {
            // printf("getImagVal i=%ld, dLength=%ld\n", i, dLength);
            return imagValues[i];
        }
        bool isEmpty();
        void print() {
            std::string sep=",";
            // long int *coords= this->getCoords(matrixSize, this->dIndex);
            std::cout << "(dIndex=" << dIndex << ") (dLength=" << dLength << ") ";
            std::cout << "[" << "";
            long int n = dLength;
            for (long int i = 0; i < n-1; i++) {
                std::cout <<  "(" << realValues[i] << "," << imagValues[i] << ")" << sep;
            }
            std::cout <<  "(" << realValues[n-1] << "," << imagValues[n-1] << ")" << "";
            std::cout << "]" << "";
            std::cout << std::endl;
        }
        void print_meta() {
            std::cout << "dIndex=" << dIndex << ", dLength=" << dLength << std::endl;
        }
        valType *getRealValues() {
            return realValues;
        }
        valType *getImagValues() {
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
        long int getDIndex(long int *coords) {
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
                if(realValues[i] != 0.0 || imagValues[i] != 0.0) {
                    count++;
                }
            }
            return count;
        }
        diagonal *scale_by_imag(valType imag) {
            #pragma omp parallel for
            for(long int i = 0; i < dLength; i++) {
                valType r = -1.0 * imag * imagValues[i];
                imagValues[i] = imag * realValues[i];
                realValues[i] = r;
            }
            return this;
        }
        diagonal *scale_by_real(valType real) {
            #pragma omp parallel for
            for(long int i = 0; i < dLength; i++) {
                realValues[i] *= real;
                imagValues[i] *= real;
            }
            return this;
        }
        void free() {
            std::free(realValues);
            std::free(imagValues);
        }
};

} // namespace diaq

#endif // DIAQ_DIAGONAL_HPP
