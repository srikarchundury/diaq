#include <pybind11/pybind11.h>
#include <pybind11/complex.h>
#include <pybind11/stl.h>
#include <pybind11/functional.h>
#include <pybind11/chrono.h>
#include <pybind11/numpy.h>
#include <pybind11/operators.h>

#include <unordered_map>

#include "diaq.hpp"

namespace py = pybind11;

std::string version() {
    return DIAQ_VERSION;
}

PYBIND11_MODULE(diaq, m) {
    m.doc() = "get C++ version"; // optional module docstring
    m.def("version", &version, "function returns the underneath C++ version");

    // diaq::diagonal class and it's routines
    py::class_<diaq::diagonal>(m, "diagonal")
        .def(py::init<long int>())
        .def_readwrite("dIndex", &diaq::diagonal::dIndex)
        .def_readwrite("dLength", &diaq::diagonal::dLength)
        .def("setValue", &diaq::diagonal::setValue, py::return_value_policy::reference)
        .def("getValue", &diaq::diagonal::getValue, py::return_value_policy::reference)
        .def("print", &diaq::diagonal::print, py::return_value_policy::reference)
        .def("getRealValues", &diaq::diagonal::getRealValues, py::return_value_policy::reference)
        .def("getImagValues", &diaq::diagonal::getImagValues, py::return_value_policy::reference)
        .def("getCoords", &diaq::diagonal::getCoords, py::return_value_policy::reference)
        .def("getDIndex", &diaq::diagonal::getDIndex, py::return_value_policy::reference)
        .def("numNonZeros", &diaq::diagonal::numNonZeros, py::return_value_policy::reference);
    
    // diaq::diaQMatrix class
    py::class_<diaq::diaQMatrix>(m, "diaQMatrix")
        .def(py::init<std::unordered_map<long int, diaq::diagonal *>, long int>())
        .def_readwrite("matrix_shape", &diaq::diaQMatrix::matrix_shape)
        .def_readwrite("shape", &diaq::diaQMatrix::shape)
        // -- //
        // .def("getItem", &diaq::diaQMatrix::getItem, py::return_value_policy::reference)
        .def("getItem", static_cast<std::complex<diaq::valType> (diaq::diaQMatrix::*)(long int)>(&diaq::diaQMatrix::getItem))
        .def("getItem", static_cast<std::complex<diaq::valType> (diaq::diaQMatrix::*)(std::vector<long int>)>(&diaq::diaQMatrix::getItem))
        // -- //
        // .def("getMatrixPosition", &diaq::diaQMatrix::getMatrixPosition, py::return_value_policy::reference)
        .def("getMatrixPosition", static_cast<std::vector<long int> (diaq::diaQMatrix::*)(long int)>(&diaq::diaQMatrix::getMatrixPosition))
        .def("getMatrixPosition", static_cast<std::vector<long int> (diaq::diaQMatrix::*)(long int, long int)>(&diaq::diaQMatrix::getMatrixPosition))
        // -- //
        // .def("getDiagonalPosition", &diaq::diaQMatrix::getDiagonalPosition, py::return_value_policy::reference)
        .def("getDiagonalPosition", static_cast<std::vector<long int> (diaq::diaQMatrix::*)(long int)>(&diaq::diaQMatrix::getDiagonalPosition))
        .def("getDiagonalPosition", static_cast<std::vector<long int> (diaq::diaQMatrix::*)(std::vector<long int>)>(&diaq::diaQMatrix::getDiagonalPosition))
        // --- //
        .def("getSize", &diaq::diaQMatrix::getSize, py::return_value_policy::reference)
        .def("getDiagonalMap", &diaq::diaQMatrix::getDiagonalMap, py::return_value_policy::reference)
        .def("createDiagonal", &diaq::diaQMatrix::createDiagonal, py::return_value_policy::reference)
        .def("print", &diaq::diaQMatrix::print, py::return_value_policy::reference)
        .def("getDiagonal", &diaq::diaQMatrix::getDiagonal, py::return_value_policy::reference)
        .def("setDiagonal", &diaq::diaQMatrix::setDiagonal, py::return_value_policy::reference)
        .def("addDiagonal", &diaq::diaQMatrix::addDiagonal, py::return_value_policy::reference)
        .def("pruneMatrix", &diaq::diaQMatrix::pruneMatrix, py::return_value_policy::reference)
        .def("convertToDenseMatrix", &diaq::diaQMatrix::convertToDenseMatrix, py::return_value_policy::reference)
        .def("flatten", &diaq::diaQMatrix::flatten, py::return_value_policy::reference)
        .def("reshape", &diaq::diaQMatrix::reshape, py::return_value_policy::reference)
        .def("transpose", &diaq::diaQMatrix::transpose, py::return_value_policy::reference)
        // operator bindings
        .def("__mul__", [](diaq::diaQMatrix *a, diaq::diaQMatrix *b){
            return diaq::product(a, b);
        }, py::is_operator())
        .def("__add__", [](diaq::diaQMatrix *a, diaq::diaQMatrix *b){
            return diaq::add(a, b);
        }, py::is_operator());

    // diaq::denseMatrix class
    py::class_<diaq::denseMatrix>(m, "denseMatrix")
        .def(py::init<long int, diaq::valType *>())
        .def(py::init<long int, diaq::valType *, diaq::valType *>())
        .def(py::init<std::vector<long int> *, diaq::valType *>())
        .def(py::init<std::vector<long int> *, diaq::valType *, diaq::valType *>())
        .def_readwrite("size", &diaq::denseMatrix::size)
        .def_readwrite("matrix_shape", &diaq::denseMatrix::matrix_shape)
        .def_readwrite("shape", &diaq::denseMatrix::shape)
        .def("getItem", &diaq::denseMatrix::getItem, py::return_value_policy::reference)
        .def("getData", &diaq::denseMatrix::getData, py::return_value_policy::reference)
        .def("set", &diaq::denseMatrix::set, py::return_value_policy::reference)
        .def("get", &diaq::denseMatrix::get, py::return_value_policy::reference)
        .def("print", &diaq::denseMatrix::print, py::return_value_policy::reference)
        .def("isPartOf", &diaq::denseMatrix::isPartOf, py::return_value_policy::reference)
        .def("sparsity", &diaq::denseMatrix::sparsity, py::return_value_policy::reference)
        .def("getTargetDiagIndex", &diaq::denseMatrix::getTargetDiagIndex, py::return_value_policy::reference)
        .def("getTargetDiagIndex_onlydiags", &diaq::denseMatrix::getTargetDiagIndex_onlydiags, py::return_value_policy::reference)
        .def("convertToQuantumSparse", &diaq::denseMatrix::convertToQuantumSparse, py::return_value_policy::reference);

    // conversion from numpy
    m.def("from_numpy", &diaq::from_numpy, py::return_value_policy::reference);
    m.def("to_numpy", &diaq::to_numpy, py::return_value_policy::reference);

    // kernel functions
    m.def("product", &diaq::product, py::return_value_policy::reference);
    m.def("denseProduct", &diaq::denseProduct, py::return_value_policy::reference);
    m.def("add", &diaq::add, py::return_value_policy::reference);
    m.def("trace", &diaq::trace, py::return_value_policy::reference);
    m.def("reshape", &diaq::reshape, py::return_value_policy::reference);
    m.def("array", &diaq::array, py::return_value_policy::reference);
    m.def(
        "tensordot",
        [](diaq::diaQMatrix *A, diaq::diaQMatrix *B, std::vector<std::vector<long int> > axes) { return diaq::tensordot(A, B, axes); },
        py::arg(),
        py::arg(),
        py::arg("axes") = std::vector<long int>{},
        py::return_value_policy::reference
    );
    m.def(
        "transpose",
        [](diaq::diaQMatrix *A, std::vector<long int> new_order) { return diaq::transpose(A, new_order); },
        py::arg(),
        py::arg("axes") = std::vector<long int>{},
        py::return_value_policy::reference
    );
    m.def(
        "kroneckerProduct",
        [](diaq::diaQMatrix *A, diaq::diaQMatrix *B) { return diaq::kron_product(A, B); },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );
    m.def(
        "spMV",
        [](diaq::diaQMatrix *A, diaq::vector *x) { return diaq::spMV(A, x); },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );
    m.def(
        "einsum",
        [](diaq::diaQMatrix *A, std::vector<long int> axes) { return diaq::einsum(A, axes); },
        py::arg(),
        py::arg("axes"),
        py::return_value_policy::reference
    );
}