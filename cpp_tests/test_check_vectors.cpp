#include "../include/diaq.hpp"
#include <string>
#include <cmath>

std::string check_vectors(std::shared_ptr<diaq::vector> a, std::shared_ptr<diaq::vector> b) {
    if(a->numRows != b->numRows) {
        return "false - length mis-match";
    }
    diaq::valType *a_real_values = a->realValues;
    diaq::valType *a_imag_values = a->imagValues;
    diaq::valType *b_real_values = b->realValues;
    diaq::valType *b_imag_values = b->imagValues;
    const diaq::valType epsilon = 0.00002;
    for(size_t i = 0; i < a->num_rows(); i++) {
        if(std::abs(a_real_values[i] - b_real_values[i]) > epsilon) {
            return "false - Real mis-match";
        }
        if(std::abs(a_imag_values[i] - b_imag_values[i]) > epsilon) {
            return "false - Imag mis-match";
        }
    }
    return "true";
}
