#include "../include/diaq.hpp"
#include <iostream>
#include <memory>
#include <chrono>

void kron_test(std::shared_ptr<diaq::denseMatrix> A24, std::shared_ptr<diaq::denseMatrix> B24) {
    A24->print();
    std::cout << " -- " << std::endl;
    std::shared_ptr<diaq::diaQMatrix> q_A24 = A24->convertToDiaQ();
    q_A24->print();
    std::cout << " -- " << std::endl;
    B24->print();
    std::cout << " -- " << std::endl;
    std::shared_ptr<diaq::diaQMatrix> q_B24 = B24->convertToDiaQ();
    q_B24->print();
    std::cout << " -- " << std::endl;
    std::cout << " -- dense kron product -- " << std::endl;
    std::shared_ptr<diaq::denseMatrix> p = diaq::dense_kron_product(A24, B24);
    p->print();
    std::cout << " -- " << std::endl;
    std::cout << " -- correct answer -- " << std::endl;
    std::shared_ptr<diaq::diaQMatrix> dp = p->convertToDiaQ();
    dp->print();
    std::cout << " -- " << std::endl;
    std::cout << " -- sparse kron product -- " << std::endl;
    auto start = std::chrono::high_resolution_clock::now();
    std::shared_ptr<diaq::diaQMatrix> res = kron_product(q_A24, q_B24);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed_seconds = end - start;
    std::cout << " -- " << std::endl;
    std::cout << "elapsed time: " << elapsed_seconds.count() << "s\n";
    std::cout << " -- " << std::endl;
    res->print();
    std::cout << " -- " << std::endl;
    std::cout << " -- Kron Product check -- " << std::endl;
    std::cout << " -- " << std::endl;
    // You may want to call checkResult(dp, res) here if needed
}
