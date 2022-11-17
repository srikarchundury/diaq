#include "../include/spdiags.hpp"


bool test_ones(size_t sz, int d1, int d2);


int main()
{
    std::cout << "START TESTS" <<std::endl;
    int size = 16;
    for (int i = -size+1; i < size; i++)
        for (int j = -size + 1; j < size; j++)
            assert(test_ones(size, i, j));
    return 0;
}


bool test_ones(size_t sz, int d1, int d2)
{
    std::cout << "\t" << d1 << "," << d2 <<":\t";
    int a_sz = sz - d1, b_sz = sz - d2, c_sz = sz - (d1+d2);
    Spvec A_vec = ones(std::abs(a_sz)), B_vec = ones(std::abs(b_sz)), C_vec = ones(std::abs(c_sz));
    
    std::vector<int> a_inds(1), b_inds(1), c_inds(1);
    a_inds[0] = d1;
    b_inds[0] = d2;
    c_inds[0] = d1 + d2;

    std::vector<Spvec> a(1, A_vec), b(1, B_vec), c(1, C_vec);

    spdiags A = spdiags(sz, &a_inds, &a ), B = spdiags(sz,&b_inds,&b), C = spdiags(sz, &c_inds, &c);


    if (!((A*B) ==C))
    {
        std::cout << "A=" << std::endl;
        A.print();
        std::cout << "B=" << std::endl;
        B.print();
        std::cout << "C=" << std::endl;
        C.print();
        std::cout << "FAIL" << std::endl;
        return 0;
    }
    std::cout << "PASS" << std::endl;
    return 1;
}