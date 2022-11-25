#include "cnpy.h"

#include "../include/denseMatrix.hpp"
#include "../include/matrixKernels.cpp"


#include <string>
#include <iostream>
#include <cmath>
#include <fstream>

std::string DATA_DIR = "../../data/";

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
    std::string dir;
    if(circuit == "vqeprep") {
        dir = DATA_DIR + "benchmarks/" + circuit + "/";
    }
    else {
        dir = DATA_DIR + "benchmarks/" + circuit + "/" + qubits + "/";
    }
    std::vector<quantumSparseMatrix> matrices;
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
    std::string dir;
    if(circuit == "vqeprep") {
        dir = DATA_DIR + "benchmarks/" + circuit + "/";
    }
    else {
        dir = DATA_DIR + "benchmarks/" + circuit + "/" + qubits + "/";
    }
    std::vector<denseMatrix> matrices;
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
    if(cir == "vqeprep") return 41;
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

denseMatrix readAsDense(std::string filepath) {
    std::ifstream inFile(DATA_DIR + "suitesparse/" + filepath + ".mtx");

    double num_row, num_col, num_lines;

    while (inFile.peek() == '%') inFile.ignore(2048, '\n');

    inFile >> num_row >> num_col >> num_lines;
    // std::cout << num_row << "x" << num_col << std::endl;

    std::vector<std::complex<double> > array(num_row * num_col, 0);
    // std::cout << "array length before - " << array.size() << std::endl;
    for (int l = 0; l < num_lines; l++) {
        std::complex<double> data;
        int row, col;
        inFile >> row >> col >> data;
        // std::cout << row << "," << col << "=" << data << std::endl;
        // std::cout << (row - 1) + (col - 1) * num_row << std::endl;
        array[(row - 1) + (col - 1) * num_row] = data;
    }
    inFile.close();
    // std::cout << "array length after - " << array.size() << std::endl;
    return denseMatrix(num_row, array);
}

quantumSparseMatrix readAsSparse(std::string filepath) {
    denseMatrix d = readAsDense(filepath);
    // d.print();
    quantumSparseMatrix q = d.convertToQuantumSparse(d.getSize());
    q.print();
    return q;
}

int main(int argc, char** argv) {
    // usage:
    // ./bench supermarq ghz 3 dense
    // ./bench suitesparse apache1 denormal sparse
    std::string circuit, qubits, version, uf_file1, uf_file2, type;
    if(argc != 5 && argc != 4) {
        std::cout << "error in number of arguments" << std::endl;
        return 1;
    }
    type = argv[1];
    if(type == "supermarq") {
        circuit = argv[2];
        qubits = argv[3];
        version = argv[4];
        
        int num_gates = get_num_gates(circuit, qubits);

        std::cout << circuit << " " << qubits << " " << version << " num_gates=" << num_gates << std::endl;

        if(version == "dense") {
            std::vector<denseMatrix> denseMatrices = prepareDense(circuit, qubits, num_gates);
            denseMatrix d = performDenseMultiplications(denseMatrices);
            // d.print();
        }
        else if(version == "sparse") {
            std::vector<quantumSparseMatrix> sparseMatrices = prepare(circuit, qubits, num_gates);
            quantumSparseMatrix q = performMultiplications(sparseMatrices);
            // q.print();
        }
        else if(version == "compare") {
            std::cout << "running dense version..." << std::endl;
            std::vector<denseMatrix> denseMatrices = prepareDense(circuit, qubits, num_gates);

            denseMatrix d = performDenseMultiplications(denseMatrices);            
            d.print();

            std::cout << "running sparse version..." << std::endl;
            std::vector<quantumSparseMatrix> sparseMatrices = prepare(circuit, qubits, num_gates);

            quantumSparseMatrix q = performMultiplications(sparseMatrices);
            q.print();

            std::cout << "comparing results..." << std::endl;
            std::vector<int> res = checkResult(q, d.convertToQuantumSparse(pow(2, stoi(qubits))));
            for(int i = 0; i < res.size(); i ++ ) std::cout << "error " << res[i] << std::endl;
            std::cout << "--" << std::endl;
        }
        return 0;
    }
    else if(type == "suitesparse") {
        uf_file1 = argv[2];
        uf_file2 = argv[3];
        version = argv[4];
        if(version == "dense") {
            denseMatrix denseA = readAsDense(uf_file1);
            denseMatrix denseB = readAsDense(uf_file2);
            denseMatrix d = denseProduct(denseA, denseB);
        }
        else if(version == "sparse") {
            quantumSparseMatrix qA = readAsSparse(uf_file1);
            quantumSparseMatrix qB = readAsSparse(uf_file2);
            quantumSparseMatrix q = product(qA, qB);
        }
        else if(version == "compare") {
            std::cout << "running dense version..." << std::endl;
            denseMatrix denseA = readAsDense(uf_file1);
            denseMatrix denseB = readAsDense(uf_file2);

            denseMatrix d = denseProduct(denseA, denseB);
            // d.print();

            std::cout << "running sparse version..." << std::endl;
            quantumSparseMatrix qA = readAsSparse(uf_file1);
            quantumSparseMatrix qB = readAsSparse(uf_file2);

            quantumSparseMatrix q = product(qA, qB);
            // q.print();

            std::cout << "comparing results..." << std::endl;
            std::vector<int> res = checkResult(q, d.convertToQuantumSparse(d.getSize()));
            for(int i = 0; i < res.size(); i ++ ) std::cout << "error " << res[i] << std::endl;
            std::cout << "--" << std::endl;
        }
    }
    else {
        std::cout << "something wrong..." << std::endl;
        return 0;
    }
}