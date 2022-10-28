#include"diagonal.h"

using namespace std;

class quantumSparseTensor{
    public:
        vector<diagonal> diagonals;
        quantumSparseTensor(vector<diagonal> &diags) {
            diagonals = diags;
        }
        void print() {
            for(int i = 0; i < diagonals.size(); i++){
                diagonals[i].print();
            }
        }
        denseTensor convertToDenseTensor(quantumSparseTensor qt) {
            // TODO
            return denseTensor(vector<int> {5,5});
        }
};

