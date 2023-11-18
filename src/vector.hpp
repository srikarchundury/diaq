#ifndef DIAQ_VECTOR_HPP
#define DIAQ_VECTOR_HPP

#include <iostream>
#include <vector>
#include <complex>

class vector {
    public:
        explicit vector(size_t M) : num_rows_(M), storage_(num_rows_) {}
        explicit vector(size_t M, std::complex<float> init) : num_rows_(M), storage_(num_rows_, init) {}

        std::complex<float> &operator[](size_t i) { return storage_[i]; }
        const std::complex<float> &operator[](size_t i) const { return storage_[i]; }

        size_t num_rows() const { return num_rows_; }

        void print() {
            std::cout << "length (" << num_rows_ << ") [";
            for (size_t i = 0; i < num_rows_ - 1; ++i) {
                std::cout << storage_[i] << ",";
            }
            std::cout << storage_[num_rows_-1] << "]" << std::endl;
        }

    private:
        size_t num_rows_;
        std::vector< std::complex< float > > storage_;
};

#endif // DIAQ_VECTOR_HPP