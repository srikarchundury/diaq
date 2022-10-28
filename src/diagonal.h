#include <iostream>
#include <string>
#include <vector>

using namespace std;

class diagonal {
    public:
        // diagonal start position
        vector<int> start; // (x, y) in matrices
        // diagonal end position 
        vector<int> end; // (x, y) in matrices
        // values in this diagonal
        vector<int> values; // integers only? maybe not, but for now (1, 0, -1)

        // pass by value? or reference?
        diagonal(const vector<int> &st, const vector<int> &en){
            start = st;
            end = en;
        }

        bool addElement(int value){
                values.push_back(value);
                return true;
        }

        void print(string sep=",") {
        // print start and end co-ords
        cout << "(" << "";
        for (int i = 0; i<start.size()-1; i++) {
            cout << start[i] << sep;
        }
        cout << start[start.size()-1] << "";
        cout << ")" << "";
        cout << "-" << "";
        cout << "(" << "";
        for (int i = 0; i<end.size()-1; i++) {
            cout << end[i] << sep;
        }
        cout << end[end.size()-1] << "";
        cout << ")" << "";
        // Iterating over all elements of vector
        cout << "[" << "";
        int n = values.size();
        for (int i = 0; i < n-1; i++) {
            cout << values[i] << sep;
        }
        cout << values[n-1] << "";
        cout << "]" << "";
        cout << endl;
    }
};