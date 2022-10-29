#ifndef SPARSE_TNQS_VECTOR_HPP
#define SPARSE_TNQS_VECTOR_HPP

#include <iostream>
#include <vector>
#include <complex>

class Vector {
    public:
        explicit Vector(size_t M) : num_rows_(M), storage_(num_rows_) {}
        explicit Vector(size_t M, std::complex<double> init) : num_rows_(M), storage_(num_rows_, init) {}

        std::complex<double> &operator[](size_t i) { return storage_[i]; }
        const std::complex<double> &operator[](size_t i) const { return storage_[i]; }

        size_t num_rows() const { return num_rows_; }

    private:
        size_t num_rows_;
        std::vector< std::complex< double > > storage_;
};

#endif // SPARSE_TNQS_VECTOR_HPP