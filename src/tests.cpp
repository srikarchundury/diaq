#include"quantumSparseTensor.h"
#include"denseTensor.h"

vector<diagonal> testdiagonal() {
    cout << "Testing diagonal class" << endl;
    vector<int> aStart;
    vector<int> aEnd;
    aStart.push_back(0);
    aStart.push_back(1);
    aEnd.push_back(3);
    aEnd.push_back(3);
    diagonal aDiag(aStart, aEnd);
    aDiag.addElement(1);
    aDiag.addElement(1);
    aDiag.addElement(1);
    aDiag.addElement(1);
    aDiag.print();

    // anti-diagonal
    vector<int> bStart;
    vector<int> bEnd;
    bStart.push_back(4);
    bStart.push_back(5);
    bEnd.push_back(5);
    bEnd.push_back(4);
    diagonal bDiag(bStart, bEnd);
    bDiag.addElement(1);
    bDiag.addElement(-1);
    bDiag.print();
    
    // vector of diagonals
    vector<diagonal> diags;
    diags.push_back(aDiag);
    diags.push_back(bDiag);
    return diags;
}

quantumSparseTensor testQuantumSparseTensor() {
    vector<diagonal> diagonals = testdiagonal();
    quantumSparseTensor qt(diagonals);
    qt.print();
    return qt;
}

denseTensor testDense() {
    denseTensor dt(vector<int> {6, 6});
    for (int i = 0;i < 4;i++) {
        dt.set(vector<int> {i, i}, 1);
    }
    dt.set(vector<int> {4, 5}, 1);
    dt.set(vector<int> {5, 4}, -1);
    dt.print();
    return dt;
}

void testConvert() {

    return;
}

int main() {
    // testdiagonal();
    quantumSparseTensor qt = testQuantumSparseTensor();
    denseTensor dt = testDense();
    testConvert();
    return 0;
}