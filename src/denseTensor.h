#include <iostream>
#include <string>
#include <vector>
#include <cmath>

#include"quantumSparseTensor.h"
using namespace std;

class denseTensor {
    public:
        // for example- 3x5x8 is a 3-dimensional tensor
        vector<int> dimensions;
        vector<int> data;
        denseTensor(const vector<int> &d) {
            dimensions = d;
            int numElements = this->getNumberOfElements();
            // cout << "Num Elements - " << numElements << endl;
            vector<int> array(numElements);
            data = array;
        }
        int getNumberOfElements() {
            int res = 1;
            for(int i = 0; i < dimensions.size(); i++) {
                res = res * dimensions[i];
            }
            return res;
        }
        void print(string sep="x") {
            // print dimensions
            cout << "(" << "";
            for(int i = 0; i < dimensions.size()-1; i++) {
                cout << dimensions[i] << sep;
            }
            cout << dimensions[dimensions.size()-1] << ")" << endl;
            cout << "[" << "";
            for (int i = 0; i < data.size()-1; i++) {
                cout << data[i] << ",";
            }
            cout << data[data.size()-1] << "";
            cout << "]" << endl;
        }
        int getLoc(const vector<int> pos) {
            int loc = 0;
            for(int i=0; i<pos.size()-1; i++) {
                loc = loc + pos[i] * dimensions[i];
            }
            loc = loc + pos[pos.size()-1]; 
            // cout << "location - " << loc << endl;
            return loc;
        }
        int get(const vector<int> pos) {
            return data[this->getLoc(pos)];
        }
        void set(const vector<int> pos, int value) {
            data[this->getLoc(pos)] = value;
        }
        quantumSparseTensor convertToQuantumSparse() {
            // for each element in the dense representation, get nearest diagonal and add to it.
            // in case of clashes, go for the diagonal with more number of elements.
            // re-arrange to diagnalize better? - maybe later in upper layers, not here
            
        }

    private:
        // euclidean distance between 2 points in n-dimensional space
        int getDistance(const vector<int> &a, const vector<int> &b) {
            float res = 0;
            for(int i = 0; i < a.size(); i++) {
                int d = a[i] - b[i];
                res = res + d * d;
            }
            return (float)sqrt(res);
        }
};