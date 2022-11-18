#include "../include/spdiags.hpp"
#include <iomanip>
#include "../src/colormod.h"

Color::Modifier red(Color::FG_RED);
Color::Modifier green(Color::FG_GREEN);
Color::Modifier def(Color::FG_DEFAULT);

void test_ones_wrapper(int size);
bool test_ones(size_t sz, int d1, int d2, bool fail_only);
bool test_ones(size_t sz, int d1, int d2, bool fail_only=1);
bool test_case_0();
bool test_case_1();
bool test_case_2();
bool test_case_3();
bool test_case_4();

int main()
{
    //std::cout << "START TESTS" <<std::endl;
    //test_ones_wrapper(16);
    //test_case_0();


    std::vector<int> a_inds(1,-2), b_inds(1,0), c_inds(1,-2);
    std::vector<Spvec> a_vals(1, ones(3)), b_vals(1, range(5, 2)), c_vals(1, range(3, 2));
    spdiags A = spdiags(5, &a_inds, &a_vals);
    spdiags B = spdiags(5, &a_inds, &a_vals);
    A.print();
    B.print();
    assert(A==B);
    (A*A*A).print();

    return 0;
}


void test_ones_wrapper(int size)
{
    std::cout << "All Ones: ";
    bool pass_q = 1;
    for (int i = -size + 1; i < size; i++)
        for (int j = -size + 1; j < size; j++)
            if (!test_ones(size, i, j))
                pass_q = 0;
    if (pass_q)
        std::cout << green << "PASS" << def << std::endl;
}

bool test_ones(size_t sz, int d1, int d2, bool fail_only)
{
    
    if (!fail_only)
        std::cout << std::setw(5) << d1 << "," << std::setw(5) << d2 <<":  ";
    int a_sz = sz - d1, b_sz = sz - d2, c_sz = sz - (d1+d2);
    Spvec A_vec = ones(std::abs(a_sz)), B_vec = ones(std::abs(b_sz)), C_vec = ones(std::abs(c_sz));
    
    std::vector<int> a_inds(1,d1), b_inds(1,d2), c_inds(1,d1+d2);
    std::vector<Spvec> a(1, A_vec), b(1, B_vec), c(1, C_vec);

    spdiags A = spdiags(sz, &a_inds, &a), B = spdiags(sz, &b_inds, &b), C = spdiags(sz);
    if (std::abs(d1+d2) < sz)
        C = spdiags(sz, &c_inds, &c);
    spdiags prod = A * (B);
    

    if (!((A*B) ==C))
    {
        std::cout << "A=" << std::endl;
        A.print();
        std::cout << "B=" << std::endl;
        B.print();
        std::cout << "AB=" << std::endl;
        prod.print();
        std::cout << "C=" << std::endl;
        C.print();
        std::cout << red  << "FAIL" << def <<  std::endl;
        return 0;
    }
    if (!fail_only)
        std::cout<< green << "PASS" << def << std::endl;
    return 1;
}

bool test_case_0()
{
    std::cout << "Start case 0: ";
    std::vector<int> a_inds(1,-2), b_inds(1,0), c_inds(1,-2);
    std::vector<Spvec> a_vals(1, ones(3)), b_vals(1, range(5, 2)), c_vals(1, range(3, 2));
    spdiags A = spdiags(5, &a_inds, &a_vals);
    spdiags B = spdiags(5, &b_inds, &b_vals);
    spdiags C = spdiags(5, &c_inds, &c_vals);
    std::cout << "A=" << std::endl;
    A.print();
    std::cout << "B=" << std::endl;
    B.print();
    std::cout << "AB=" << std::endl;
    spdiags prod = A*B;
    prod.print();
    std::cout << "C=" << std::endl;
    C.print();

    if (!(prod == C))
    {
        std::cout << red << "FAIL" << def << std::endl;
        return 0;
    }
    std::cout << green << "PASS" << def << std::endl;
    return 1;
}

bool test_case_1()
{
    std::cout << "Start case 1: ";
    std::vector<int> a_inds(1, -2), b_inds(1, 2), c_inds(1, 0);
    std::vector<Spvec> a_vals(1, ones(3)), b_vals(1, range(3, 2)), c_vals(1, shift(range(3, 2),2));
    spdiags A = spdiags(5, &a_inds, &a_vals);
    spdiags B = spdiags(5, &b_inds, &b_vals);
    spdiags C = spdiags(5, &c_inds, &c_vals);
    std::cout << "A=" << std::endl;
    A.print();
    std::cout << "B=" << std::endl;
    B.print();
    std::cout << "AB=" << std::endl;
    spdiags prod = A * B;
    prod.print();
    std::cout << "C=" << std::endl;
    C.print();

    if (!(prod == C))
    {
        std::cout << red << "FAIL" << def << std::endl;
        return 0;
    }
    std::cout << green << "PASS" << def << std::endl;
    return 1;
}