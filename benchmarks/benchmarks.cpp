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
        // m.print();
        // std::cout << " --- " << std::endl;
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

denseMatrix performDenseMultiplications(std::vector<denseMatrix> matrices) {
    denseMatrix result = denseProduct(matrices[1], matrices[0]);
    for(int i = 2; i < matrices.size(); i++) {
        result = denseProduct(matrices[i], result);
    }
    return result;
}

std::vector<denseMatrix> prepareDense(std::string circuit, std::string qubits, int num_gates) {
    std::vector<denseMatrix> matrices;
    std::string dir = "../analysis/benchmarks/" + circuit + "/" + qubits + "/";
    for(int i = 1; i <= num_gates; i++) {
        denseMatrix d = getDenseMatrix(dir + "gate_" + std::to_string(i) + ".npz");
        matrices.push_back(d);
    }
    return matrices;
}

std::vector<int> checkResult(quantumSparseMatrix A, quantumSparseMatrix B) {
    std::vector<int> errors;
    if(A.getSize() != B.getSize()) {
        errors.push_back(1);
    }
    std::map<int, diagonal> dmA = A.getDiagonalMap();
    std::map<int, diagonal> dmB = B.getDiagonalMap();
    std::map<int, diagonal>::iterator itA, itB;
    for(itA = dmA.begin(); itA != dmA.end(); itA++) {
        auto itB = dmB.find(itA->first);
        if(itB == dmB.end()) {
            errors.push_back(2);
        }
        if(itB->second.getValues().size() != itA->second.getValues().size()) { 
            errors.push_back(3);
        }
        else {
            for(int i = 0; i < itA->second.getValues().size(); i++) {
                if(itB->second.getValue(i) != itA->second.getValue(i)) {
                    errors.push_back(4);
                }
            }
        }
    }
    return errors;
}

int main() {
    // measure #flops, #memory
    quantumSparseMatrix q = performMultiplications(prepare("ham", "3", 9));
    // measure #flops, #memory
    q.print();

    // measure #flops, #memory
    denseMatrix d = performDenseMultiplications(prepareDense("ham", "3", 9));
    // measure #flops, #memory
    d.print();

    std::vector<int> res = checkResult(q, d.convertToQuantumSparse(8));
    for(int i = 0; i < res.size(); i ++ ) std::cout << "error " << res[i] << " ";
    std::cout << "--" << std::endl;
}