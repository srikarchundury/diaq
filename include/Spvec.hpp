#ifndef SPARSE_TNQS_SPVEC_HPP
#define SPARSE_TNQS_SPVEC_HPP

#include <iostream>
#include <string>
#include <vector>
#include <complex>
#include <algorithm>
#include <functional>
#include <cassert>

class Spvec {
    public:
        Spvec(){storage_ = std::vector<std::complex<double>>(0); indices_ = std::vector<int>(0);}
        Spvec(std::vector<int> *inds, std::vector<std::complex<double>> *vals) : indices_(*inds), storage_(*vals) {}

        size_t num_nonzero() const { return storage_.size(); }

        //int get_dIndex() const { return dIndex; };

        const std::vector<int> get_indices() const { return indices_;}
        const std::vector<std::complex<double>> get_values()  const {return storage_;}

        void addElement(std::complex<double> val , size_t idx) { storage_.push_back(val), indices_.push_back(idx);}

        void setValue(std::complex<double> val , size_t idx) { 
            std::vector<int>::iterator it = find(indices_.begin(),indices_.end(),idx);
            if (it==indices_.end()) // if index not already assigned
                addElement(val,idx);
            else // update if already assigned
                storage_.at(it - indices_.begin()) = val;
        }

        void print(std::string sep = ",")
        {
            assert(indices_.size() == storage_.size());

            size_t n = indices_.end() - indices_.begin();
            std::cout << "[";
            
            for (int i = 0; i < n; i++)
            {
                std::cout << indices_[i] <<":" << storage_[i] << sep;
            }
            std::cout << "]" << std::endl;
        }

        Spvec operator+(const Spvec &y)
        {
            Spvec x = *this;
            std::vector<int> new_idx, x_idx = x.get_indices(), y_idx = y.get_indices();
            std::vector<std::complex<double>> new_data, x_data = x.get_values(), y_data = y.get_values();

            while (!x_idx.empty() || !y_idx.empty())
            {
                if (x_idx.front() == y_idx.front())
                {
                    new_idx.push_back(x_idx.front());
                    new_data.push_back(x_data.front() + y_data.front());
                    x_idx.erase(x_idx.begin());
                    x_data.erase(x_data.begin());
                    y_idx.erase(y_idx.begin());
                    y_data.erase(y_data.begin());
                }
                else if (x_idx.front() < y_idx.front() || y_idx.empty())
                {
                    new_idx.push_back(x_idx.front());
                    new_data.push_back(x_data.front());
                    x_idx.erase(x_idx.begin());
                    x_data.erase(x_data.begin());
                }
                else if (x_idx.front() > y_idx.front() || x_idx.empty())
                {
                    new_idx.push_back(y_idx.front());
                    new_data.push_back(y_data.front());
                    y_idx.erase(y_idx.begin());
                    y_data.erase(y_data.begin());
                }
                else
                    std::cout << "ADDITION ERROR" << std::endl;
            }

            Spvec z = Spvec(&new_idx, &new_data);
            return z;
        };

        Spvec operator-(const Spvec &y)
        {
            Spvec x = *this;
            std::vector<int> new_idx, x_idx = x.get_indices(), y_idx = y.get_indices();
            std::vector<std::complex<double>> new_data, x_data = x.get_values(), y_data = y.get_values();

            while (!x_idx.empty() || !y_idx.empty())
            {
                if (x_idx.front() == y_idx.front())
                {
                    new_idx.push_back(x_idx.front());
                    new_data.push_back(x_data.front() - y_data.front());
                    x_idx.erase(x_idx.begin());
                    x_data.erase(x_data.begin());
                    y_idx.erase(y_idx.begin());
                    y_data.erase(y_data.begin());
                }
                else if (x_idx.front() < y_idx.front() || y_idx.empty())
                {
                    new_idx.push_back(x_idx.front());
                    new_data.push_back(x_data.front());
                    x_idx.erase(x_idx.begin());
                    x_data.erase(x_data.begin());
                }
                else if (x_idx.front() > y_idx.front() || x_idx.empty())
                {
                    new_idx.push_back(y_idx.front());
                    new_data.push_back(-y_data.front());
                    y_idx.erase(y_idx.begin());
                    y_data.erase(y_data.begin());
                }
                else
                    std::cout << "SUBTRACTION ERROR" << std::endl;
            }

            Spvec z = Spvec(&new_idx, &new_data);
            return z;
        };

        /**
         * @brief component-wise multiplication of two sparse diag objects
         *
         */
        Spvec operator*(const Spvec &y)
        {
            Spvec x = *this;
            std::vector<int> new_idx, x_idx = x.get_indices(), y_idx = y.get_indices();
            std::vector<std::complex<double>> new_data, x_data = x.get_values(), y_data = y.get_values();

            while (!x_idx.empty() || !y_idx.empty())
            {
                if (y_idx.empty() || x_idx.empty())
                    break;

                if (x_idx.front() == y_idx.front())
                {
                    new_idx.push_back(x_idx.front());
                    new_data.push_back(x_data.front() * y_data.front());
                    x_idx.erase(x_idx.begin());
                    x_data.erase(x_data.begin());
                    y_idx.erase(y_idx.begin());
                    y_data.erase(y_data.begin());
                }
                else if (x_idx.front() < y_idx.front())
                {
                    x_idx.erase(x_idx.begin());
                    x_data.erase(x_data.begin());
                }
                else if (x_idx.front() > y_idx.front())
                {
                    y_idx.erase(y_idx.begin());
                    y_data.erase(y_data.begin());
                }
                else
                    std::cout << "Component Wise mult ERROR" << std::endl;
            }

            Spvec z = Spvec(&new_idx, &new_data);
            return z;
        };
        // bool const operator==(const Spvec &y)
        // {
        //     Spvec x = *this;
        //     std::cout << '////' << std::endl;
        //     std::cout << '////' << std::endl;
        //     if (x.get_indices() != y.get_indices()) 
        //         return 0;
        //     if (x.get_values() != y.get_values())
        //         return 0;
        //     return 1;
        // }

    private:
        // int dIndex; // -(n-1),..0,..n-1 (principal diagonal numbering)
        std::vector<int> indices_; // normal vector indexing
        std::vector<std::complex<double>> storage_;
};

// ----------------------------------------------------------------
//
// SPARSE DIAGONAL HELPER FUNCTIONS
//
// ----------------------------------------------------------------

/*
Spvec operator+(const Spvec &x, const Spvec &y)
{
        std::vector<int> new_idx, x_idx = x.get_indices(), y_idx = y.get_indices();
        std::vector<std::complex<double>> new_data, x_data = x.get_values(), y_data = y.get_values();

        while (!x_idx.empty() || !y_idx.empty())
        {
            if (x_idx.front() == y_idx.front())
            {
                new_idx.push_back(x_idx.front());
                new_data.push_back(x_data.front() + y_data.front());
                x_idx.erase(x_idx.begin());
                x_data.erase(x_data.begin());
                y_idx.erase(y_idx.begin());
                y_data.erase(y_data.begin());
            }
            else if (x_idx.front() < y_idx.front() || y_idx.empty())
            {
                new_idx.push_back(x_idx.front());
                new_data.push_back(x_data.front());
                x_idx.erase(x_idx.begin());
                x_data.erase(x_data.begin());
            }
            else if (x_idx.front() > y_idx.front() || x_idx.empty())
            {
                new_idx.push_back(y_idx.front());
                new_data.push_back(y_data.front());
                y_idx.erase(y_idx.begin());
                y_data.erase(y_data.begin());
            }
            else
                std::cout << "ADDITION ERROR" << std::endl;
        }

        Spvec z = Spvec(&new_idx, &new_data);
        return z;
};

Spvec operator-(const Spvec &x, const Spvec &y)
{
        std::vector<int> new_idx, x_idx = x.get_indices(), y_idx = y.get_indices();
        std::vector<std::complex<double>> new_data, x_data = x.get_values(), y_data = y.get_values();

        while (!x_idx.empty() || !y_idx.empty())
        {
            if (x_idx.front() == y_idx.front())
            {
                new_idx.push_back(x_idx.front());
                new_data.push_back(x_data.front() - y_data.front());
                x_idx.erase(x_idx.begin());
                x_data.erase(x_data.begin());
                y_idx.erase(y_idx.begin());
                y_data.erase(y_data.begin());
            }
            else if (x_idx.front() < y_idx.front() || y_idx.empty())
            {
                new_idx.push_back(x_idx.front());
                new_data.push_back(x_data.front());
                x_idx.erase(x_idx.begin());
                x_data.erase(x_data.begin());
            }
            else if (x_idx.front() > y_idx.front() || x_idx.empty())
            {
                new_idx.push_back(y_idx.front());
                new_data.push_back(-y_data.front());
                y_idx.erase(y_idx.begin());
                y_data.erase(y_data.begin());
            }
            else
                std::cout << "SUBTRACTION ERROR" << std::endl;
        }

        Spvec z = Spvec(&new_idx, &new_data);
        return z;
};

Spvec operator*(const Spvec &x, const Spvec &y) // Componentwise
{
        std::vector<int> new_idx, x_idx = x.get_indices(), y_idx = y.get_indices();
        std::vector<std::complex<double>> new_data, x_data = x.get_values(), y_data = y.get_values();

        while (!x_idx.empty() || !y_idx.empty())
        {
            if (y_idx.empty() || x_idx.empty())
                break;

            if (x_idx.front() == y_idx.front())
            {
                new_idx.push_back(x_idx.front());
                new_data.push_back(x_data.front() * y_data.front());
                x_idx.erase(x_idx.begin());
                x_data.erase(x_data.begin());
                y_idx.erase(y_idx.begin());
                y_data.erase(y_data.begin());
            }
            else if (x_idx.front() < y_idx.front())
            {
                x_idx.erase(x_idx.begin());
                x_data.erase(x_data.begin());
            }
            else if (x_idx.front() > y_idx.front())
            {
                y_idx.erase(y_idx.begin());
                y_data.erase(y_data.begin());
            }
            else
                std::cout << "Component Wise mult ERROR" << std::endl;
        }

        Spvec z = Spvec(&new_idx, &new_data);
        return z;
};
*/

/**
 * @brief prunes sparse diagonal to eliminate potentially extranious values.
 * 
 * @param x     spvec to be pruned
 * @param high  highest allowed index (inclusive), ie the capacity required
 * @param low   the lowest allowed index (inclusive)
 * @return pruned spvec
 */
Spvec prune(const Spvec &x, size_t high, size_t low = 0)
{
    std::vector<int> new_idx, x_idx = x.get_indices();
    std::vector<std::complex<double>> new_data, data = x.get_values();

    for (size_t i = 0; i < x_idx.size(); i++)
    {
        if (x_idx[i] >= low && x_idx[i] <= high)
        {
            new_idx.push_back(x_idx[i]);
            new_data.push_back(data[i]);
        }
    }
    Spvec z = Spvec(&new_idx, &new_data);
    return z;
};

Spvec shift(const Spvec &x, int s)
{
    std::vector<int> new_idx, x_idx = x.get_indices();
    std::vector<std::complex<double>> new_data, data = x.get_values();
    while (!x_idx.empty())
    {
        new_idx.push_back(x_idx.front() + s);
        new_data.push_back(data.front());
        x_idx.erase(x_idx.begin());
        data.erase(data.begin());
    }
    Spvec z = Spvec(&new_idx, &new_data);
    //size_t max = *std::max_element(x_idx.begin(), x_idx.end());
    return z; //prune(z,max);
};

bool const operator==(const Spvec &x, const Spvec &y)
{
    //std::cout << "////" << std::endl;
    //std::cout << "////" << std::endl;
    if (x.get_indices() != y.get_indices())
        return 0;
    if (x.get_values() != y.get_values())
        return 0;
    return 1;
}

Spvec ones(int sz)
{
    std::vector<int> new_idx(sz);
    std::vector< std::complex< double > > new_data(sz);
    for (size_t i = 0; i < sz; i++)
    {
        new_idx[i] = i;
        new_data[i] = 1;
    }

    return Spvec(&new_idx, &new_data);
}

Spvec range(size_t sz, int start = 0, int step = 1);
Spvec range(size_t sz, int start, int step)
{
    std::vector<int> new_idx(sz);
    std::vector<std::complex<double>> new_data(sz);
    for (size_t i = 0; i < sz; i++)
    {
        new_idx[i] = i;
        new_data[i] = start + (step * i);
    }

    return Spvec(&new_idx, &new_data);
}



#endif // SPARSE_TNQS_SPVEC_HPP