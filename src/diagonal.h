#include <iostream>
#include <string>
#include <vector>

using namespace std;

class diagonal {
    public:
        int dIndex; // -(n-1),..0,..n-1 and n,.., 2n-2
        vector<int> values; // most things are -1, 0, 1.

        diagonal(const int di) {
            dIndex = di;
        }
        bool addElement(int value) {
            values.push_back(value);
            return true;
        }
        void print(int matrixSize, string sep=",") {
            int *coords= this->getCoords(matrixSize, this->dIndex);
            cout << "(" << coords[0] << "," << coords[1] << ")";
            cout << "[" << "";
            int n = values.size();
            for (int i = 0; i < n-1; i++) {
                cout << values[i] << sep;
            }
            cout << values[n-1] << "";
            cout << "]" << "";
            cout << endl;
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
                if(values[i] != 0) {
                    count++;
                }
            }
            return count;
        }
};