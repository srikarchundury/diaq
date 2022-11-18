#include "cnpy.h"

#include "../include/denseMatrix.hpp"
#include "../include/matrixKernels.cpp"


#include <string>
#include <iostream>
#include <cmath>

denseMatrix getDenseMatrix(std::string npz_path) {
    cnpy::NpyArray arr = cnpy::npz_load(npz_path, "arr_0");

    std::complex<double>* mat = arr.data<std::complex<double>>();
    std::vector<std::complex<double>> array;
    
    // std::cout << arr.shape[0] << "," << arr.shape[1] << std::endl;

    for(int i=0; i < arr.shape[0]*arr.shape[1]; i++) {
            array.push_back(mat[i]);
    }

    return denseMatrix(arr.shape[0], array);
}

std::vector<quantumSparseMatrix> prepare(std::string circuit, std::string qubits, int num_gates) {
    std::vector<quantumSparseMatrix> matrices;
    std::string dir = "../analysis/benchmarks/" + circuit + "/" + qubits + "/";
    for(int i = 1; i <= num_gates; i++) {
        denseMatrix d = getDenseMatrix(dir + "gate_" + std::to_string(i) + ".npz");

        quantumSparseMatrix m = d.convertToQuantumSparse(pow(2, stoi(qubits)));
        m.print();
        std::cout << " --- " << std::endl;
        matrices.push_back(m);
    }
    return matrices;
}

quantumSparseMatrix performMultiplications(std::vector<quantumSparseMatrix> matrices) {
    quantumSparseMatrix result = product(matrices[1], matrices[0]);
    for(int i = 2; i < matrices.size(); i++) {
        result = product(matrices[i], result);
    }
    return result;
}

int main() {
    // measure #flops, #memory
    performMultiplications(prepare("ghz", "3", 2)).print();
    // measure #flops, #memory 
}