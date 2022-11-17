#ifndef SPARSE_TNQS_SPDIAGS_HPP
#define SPARSE_TNQS_SPDIAGS_HPP

#include <iostream>
#include <string>
#include <vector>
#include <complex>
#include <algorithm>
#include <functional>
#include <cassert>
#include "Spvec.hpp"

class spdiags{
    public:
        spdiags(size_t size) : size_(size) {}
        spdiags(size_t size, std::vector<int> *dinds, std::vector<Spvec> *vals) : diags_(*vals), d_indices_(*dinds) {}

        size_t num_diags() const {return d_indices_.size();}
        size_t size() const {return size_;}

        const std::vector<int> get_dinds() const {return d_indices_;}
        const std::vector<Spvec> get_diags() const {return diags_;}

        void set_diag(int d, Spvec diag) {
            assert (abs(d)< size_);
            size_t max = *std::max_element(diag.get_indices().begin(), diag.get_indices().end());
            assert(max <= (size_ - std::abs(d))); // confirm this diag will approapriately fit
            std::vector<int>::iterator res = std::find(d_indices_.begin(), d_indices_.end(), d);
            if (res == d_indices_.end())
            {
                d_indices_.push_back(d);
                diags_.push_back(prune(diag,size_-std::abs(d)-1));
            }
            else
            {
                size_t i = res-d_indices_.begin();
                d_indices_[i] = d;
                diags_[i] = diag;
            }
        }

        void print()
        {
            for (size_t i = 0; i < d_indices_.end() - d_indices_.begin(); i++)
            {
                std::cout<< '[' << d_indices_[i] << ']:\t';
                diags_[i].print();
                std::cout << std::endl;
            }
        }

        const Spvec get_daig(int i)
        {
            std::vector<int>::iterator res = std::find(d_indices_.begin(), d_indices_.end(), i);
            assert(res != d_indices_.end()); // assert has data
            size_t i = res - d_indices_.begin();
            return diags_[i];
        }

        const Spvec get_didx(int i)
        {
            std::vector<int>::iterator res = std::find(d_indices_.begin(), d_indices_.end(), i);
            assert(res != d_indices_.end()); // assert has data
            size_t i = res - d_indices_.begin();
            return diags_[i];
        }

    private:
        size_t size_; // We will assume all matrices are square.
        std::vector<int> d_indices_;
        std::vector<Spvec> diags_;

};


#endif // SPARSE_TNQS_SPDIAGS_HPP

// ----------------------------------------------------------------
//
//  FULLY SPARSE FUNCTIONS
//
// ----------------------------------------------------------------
spdiags operator+(const spdiags &x, const spdiags &y)
{
    assert(x.size()==y.size());

    std::vector<int> new_idx, x_idx = x.get_dinds(), y_idx = y.get_dinds();
    std::vector<Spvec> new_data, x_data = x.get_diags(), y_data = y.get_diags();

    for (int i = -x.size()+1; i < x.size(); i++)
    {
        std::vector<int>::iterator resx = std::find(x_idx.begin(), x_idx.end(), i);
        std::vector<int>::iterator resy = std::find(y_idx.begin(), y_idx.end(), i);
        size_t x_ = resx - x_idx.begin(), y_ = resy - y_idx.begin();
        if (resx != x_idx.end() && resy != y_idx.end())
        {
            new_idx.push_back(i);
            new_data.push_back(x_data[x_]+y_data[y_]);
        }
        else if (resx != x_idx.end())
        {
            new_idx.push_back(i);
            new_data.push_back(x_data[x_]);
        }
        else if (resy != y_idx.end())
        {
            new_idx.push_back(i);
            new_data.push_back(y_data[y_]);
        }
        else // neither has data on this diag.
            continue;
    }
    spdiags z = spdiags(x.size(), &new_idx, &new_data);
};

spdiags operator*(const spdiags &x, const spdiags &y)
{
    assert(x.size() == y.size()); // for quantum applications, we can assume square matrices.

    std::vector<int> new_idx, x_idx = x.get_dinds(), y_idx = y.get_dinds();
    std::vector<Spvec> new_data, x_data = x.get_diags(), y_data = y.get_diags();
    spdiags res = spdiags(x.size());
    for (size_t i = 0; i < x_idx.size(); i++)
    {
        std::vector<int> temp_idx;
        std::vector<Spvec> temp_diags;
        for (size_t j = 0; j < y_idx.size(); j++)
        {
            int x_d = x_idx[i], y_d = y_idx[j];
            int new_diag = x_d + y_d;
            if (std::abs(new_diag) >= x.size())
                continue;
            Spvec tempx = x_data[i], tempy = y_data[i];
            // WIP
            int xslide, yslide;

            if (x_d <= 0)
            {
                if (y_d > 0)
                {
                    xslide = std::min(-x_d, y_d);
                    yslide = std::max(x_d, -y_d);
                }
                else if (y_d < 0)
                {
                    xslide = y_d;
                    yslide = 0;
                }
            }
            else
            {
                if (y_d < 0)
                {
                    xslide = std::min(y_d+x_d, 0);
                    yslide = std::min(0, x_d-y_d);
                }
                else (y_d >0);
                {
                    yslide = x_d;
                }
            }

            Spvec temp_diag = shift(tempx,xslide)*shift(tempy, yslide);
            temp_diag = prune(temp_diag,x.size()-std::abs(new_diag)-1);
            temp_idx.push_back(new_diag);
            temp_diags.push_back(temp_diag);
        }
        spdiags temp_matrix = spdiags(x.size(),&temp_idx,&temp_diags);
        res = res + temp_matrix;
    }
    return res;
};