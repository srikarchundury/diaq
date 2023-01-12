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
    std::cout << "Preparation phase ... " << std::endl;
    for(int i = 1; i <= num_gates; i++) {
        denseMatrix d = getDenseMatrix(dir + "gate_" + std::to_string(i) + ".npz");

        quantumSparseMatrix m = d.convertToQuantumSparse(pow(2, stoi(qubits)));
        std::cout << "#diagonals = " << m.getDiagonalMap().size() << std::endl;
        std::cout << "sparsity = " << d.sparsity() << std::endl;
        // m.print();
        // std::cout << " --- " << std::endl;
        matrices.push_back(m);
    }
    return matrices;
}

quantumSparseMatrix performMultiplications(std::vector<quantumSparseMatrix> matrices) {
    std::cout << "Chain Multiplication ... " << std::endl;
    quantumSparseMatrix result = product(matrices[1], matrices[0]);
    std::cout << "#diagonals = " << result.getDiagonalMap().size() << std::endl;
    std::vector<std::complex<double>> data = result.convertToDenseMatrix(result.getSize());
    denseMatrix d = denseMatrix(result.getSize(), data);
    std::cout << "sparsity = " << d.sparsity() << std::endl;
    for(int i = 2; i < matrices.size(); i++) {
        result = product(matrices[i], result);
        std::cout << "#diagonals = " << result.getDiagonalMap().size() << std::endl;
        std::vector<std::complex<double>> data = result.convertToDenseMatrix(result.getSize());
        denseMatrix d = denseMatrix(result.getSize(), data);
        std::cout << "sparsity = " << d.sparsity() << std::endl;
    }
    return result;
}

denseMatrix performDenseMultiplications(std::vector<denseMatrix> matrices) {
    denseMatrix result = denseProduct(matrices[1], matrices[0]);
    for(int i = 2; i < matrices.size(); i++) {
        // if(i==matrices.size()-1) {
        //     matrices[i].print();
        //     std::cout << " --- " << std::endl;
        //     result.print();
        // }
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
                    std::cout << "error with diag idx - " << itA->second.getIndex() << std::endl;
                    errors.push_back(4);
                }
            }
        }
    }
    return errors;
}

int get_num_gates(std::string cir, std::string qubits) {
    int i;
    if(cir == "ghz") i = 0;
    if(cir == "ham") i = 1;
    if(cir == "mermin_bell") i = 2;
    int j = std::stoi(qubits) - 3;

    std::vector<int> gates = {
        2,3,4,5,6,7,8,9,
        9,13,17,21,25,29,33,37,
        11,18,25,34,43,54,65,78,
    };

    return gates[i * 8 + j];
}

int main(int argc, char** argv) {

    // ./bench ghz 3 dense
    // ./bench ghz 3 sparse

    std::string circuit = argv[1];
    std::string qubits = argv[2];
    std::string version = argv[3];

    int num_gates = get_num_gates(circuit, qubits);

    std::cout << circuit << " " << qubits << " " << version << " num_gates=" << num_gates << std::endl;

    if(version == "dense") {
        std::vector<denseMatrix> denseMatrices = prepareDense(circuit, qubits, num_gates);

        // measure #flops, #memory
        denseMatrix d = performDenseMultiplications(denseMatrices);
        // measure #flops, #memory
        
        d.print();
    }

    else if(version == "sparse") {
        std::vector<quantumSparseMatrix> sparseMatrices = prepare(circuit, qubits, num_gates);

        // measure #flops, #memory
        quantumSparseMatrix q = performMultiplications(sparseMatrices);
        // measure #flops, #memory

        q.print();
    }
    // std::cout << " --- " << std::endl;
    // std::vector<int> res = checkResult(q, d.convertToQuantumSparse(128));
    // for(int i = 0; i < res.size(); i ++ ) std::cout << "error " << res[i] << std::endl;
    // std::cout << "--" << std::endl;
    return 0;
}