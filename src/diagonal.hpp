#ifndef DIAQ_DIAGONAL_HPP
#define DIAQ_DIAGONAL_HPP

#include "config.hpp"

namespace diaq {

class diagonal : public std::enable_shared_from_this<diagonal> {
    public:
        valType* realValues; // real number array
        valType* imagValues; // imaginary number array

        int dIndex; // -(n-1),..0,..n-1 and n,.., 2n-2
        unsigned int dLength;

        diagonal(int di) {
            dIndex = di;
        }
        diagonal(int di, unsigned int dl) {
            dIndex = di;
            dLength = dl;
            #if NUM_BYTES_ALIGNED == -1
                realValues = (valType *)calloc(dl, sizeof(valType));
                imagValues = (valType *)calloc(dl, sizeof(valType));
            #else
                realValues = aligned_alloc_helper(dl * sizeof(valType));
                imagValues = aligned_alloc_helper(dl * sizeof(valType));
                #pragma omp parallel for
                for(unsigned int i = 0; i < dl; i++) {
                    realValues[i] = 0.0;
                    imagValues[i] = 0.0;
                }
            #endif
        }
        diagonal(int di, unsigned int dl, valType *realVals, valType *imagVals) {
            dIndex = di;
            realValues = realVals;
            imagValues = imagVals;
            dLength = dl;
        }
        ~diagonal() {
            #ifdef DEEP_DEBUG
                std::cout << "diagonal destructor called" << std::endl;
            #endif
            // needed because we allocate memory ourserlves unlike shared_ptr! This place and under vector.hpp & denseMatrix.cpp are the only places where we need to free memory manually!!!
            if(realValues != nullptr) std::free(realValues);
            if(imagValues != nullptr) std::free(imagValues);
        }
        void setIndex(int newIndex) {
            dIndex = newIndex;
        }
        std::shared_ptr<diagonal> copy() {
            valType *real_vals = (valType *)calloc(dLength, sizeof(valType));
            valType *imag_vals = (valType *)calloc(dLength, sizeof(valType));
            #pragma omp parallel for
            for(unsigned int i = 0; i < dLength; i++) {
                real_vals[i] = realValues[i];
                imag_vals[i] = imagValues[i];
            }
            return std::make_shared<diagonal>(dIndex, dLength, real_vals, imag_vals);
        }
        void setElements(valType *new_realVals, valType *new_imagVals) {
            realValues = new_realVals;
            imagValues = new_imagVals;
        }
        void addElements(valType *new_realVals, valType *new_imagVals, int from_index, int to_index) {
            #pragma omp parallel for
            for(int i = from_index; i<=to_index; i++) {
                realValues[i] = new_realVals[i];
                imagValues[i] = new_imagVals[i];
            }
        }
        void setValue(unsigned int i, valType real_val, valType imag_val) {
            // std::cout << "there" << std::endl;
            realValues[i] = real_val;
            imagValues[i] = imag_val;
        }
        std::complex<valType> getValue(unsigned int i) {
            std::complex<valType> ans{realValues[i], imagValues[i]};
            return ans;
        }
        valType getRealValue(unsigned int i) {
            // printf("getRealVal i=%ld, dLength=%ld\n", i, dLength);
            return realValues[i];
        }
        valType getImagValue(unsigned int i) {
            // printf("getImagVal i=%ld, dLength=%ld\n", i, dLength);
            return imagValues[i];
        }

        bool isEmpty(); // implemented in simd_kernels.cpp

        void print() {
            std::string sep=",";
            // unsigned int *coords= this->getCoords(matrixSize, this->dIndex);
            std::cout << "(dIndex=" << dIndex << ") (dLength=" << dLength << ") ";
            std::cout << "[" << "";
            unsigned int n = dLength;
            for (unsigned int i = 0; i < n-1; i++) {
                std::cout <<  "(" << realValues[i] << "," << imagValues[i] << ")" << sep;
            }
            std::cout <<  "(" << realValues[n-1] << "," << imagValues[n-1] << ")" << "";
            std::cout << "]" << "";
            std::cout << std::endl;
        }
        void print_meta() {
            std::cout << "dIndex=" << dIndex << ", dLength=" << dLength << std::endl;
        }
        // returns the start (x, y) of diagonal of the matrix
        std::array<unsigned int, 2> getCoords(unsigned int matrixSize, int dIndex) {
            std::array<unsigned int, 2> c;
            if(dIndex >= (int) matrixSize) {
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
        int getDIndex(unsigned int *coords) {
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
        unsigned int numNonZeros() {
            unsigned int count = 0;
            for(unsigned int i = 0; i < dLength; i++) {
                if(realValues[i] != 0.0 || imagValues[i] != 0.0) {
                    count++;
                }
            }
            return count;
        }
        std::shared_ptr<diagonal> scale_by_imag(valType imag) {
            #pragma omp parallel for
            for(unsigned int i = 0; i < dLength; i++) {
                valType r = -1.0 * imag * imagValues[i];
                imagValues[i] = imag * realValues[i];
                realValues[i] = r;
            }
            return shared_from_this();
        }
        std::shared_ptr<diagonal> scale_by_real(valType real) {
            std::shared_ptr<diagonal> newDiag = std::make_shared<diagonal>(dIndex, dLength);
            #pragma omp parallel for
            for(unsigned int i = 0; i < dLength; i++) {
                newDiag->realValues[i] = real * realValues[i];
                newDiag->imagValues[i] = real * imagValues[i];
            }
            return newDiag;
        }
        std::complex<valType>& operator[](unsigned int i) {
            if (i >= dLength) {
                throw std::out_of_range("Index out of range");
            }
            // Return a reference to a std::complex, constructed on the fly
            // This does not create a temporary because we return a reference to the real and imag parts
            return *(reinterpret_cast<std::complex<valType>*>(&realValues[i]));
        }
};

} // namespace diaq

#endif // DIAQ_DIAGONAL_HPP
