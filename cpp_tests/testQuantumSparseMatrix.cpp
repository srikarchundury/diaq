#include "../include/diaq.hpp"
#include <memory>
#include <vector>
#include <array>

std::shared_ptr<diaq::diaQMatrix> testQuantumSparseMatrix() {
    // Example: 6x6 matrix with diagonals at 0, 1, -1
    std::array<unsigned int, 2> dims = {6, 6};
    std::vector<int> diag_indices = {0, 1, -1};
    auto m = std::make_shared<diaq::diaQMatrix>(dims, diag_indices);
    m->print();
    return m;
}