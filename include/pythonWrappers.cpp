#include <pybind11/pybind11.h>
#include <pybind11/complex.h>
#include <pybind11/stl.h>
#include <pybind11/functional.h>
#include <pybind11/chrono.h>
#include <pybind11/numpy.h>
#include <pybind11/operators.h>

#include "dia_lite.hpp"


namespace py = pybind11;

std::string version() {
    return DIA_LITE_VERSION;
}

PYBIND11_MODULE(dia_lite, m) {
    m.doc() = "get C++ version"; // optional module docstring
    m.def("version", &version, "function returns the underneath C++ version");

    // diagonal class and it's routines
    py::class_<diagonal>(m, "diagonal")
        .def(py::init<long int>())
        .def_readwrite("dIndex", &diagonal::dIndex)
        .def_readwrite("dLength", &diagonal::dLength)
        .def("setValue", &diagonal::setValue, py::return_value_policy::reference)
        .def("getValue", &diagonal::getValue, py::return_value_policy::reference)
        .def("print", &diagonal::print, py::return_value_policy::reference)
        .def("getRealValues", &diagonal::getRealValues, py::return_value_policy::reference)
        .def("getImagValues", &diagonal::getImagValues, py::return_value_policy::reference)
        .def("getCoords", &diagonal::getCoords, py::return_value_policy::reference)
        .def("getDIndex", &diagonal::getDIndex, py::return_value_policy::reference)
        .def("numNonZeros", &diagonal::numNonZeros, py::return_value_policy::reference);
    
    // diaLiteMatrix class
    py::class_<diaLiteMatrix>(m, "diaLiteMatrix")
        .def(py::init<std::map<long int, diagonal>, long int>())
        .def_readwrite("matrix_shape", &diaLiteMatrix::matrix_shape)
        .def_readwrite("shape", &diaLiteMatrix::shape)
        .def("getItem", &diaLiteMatrix::getItem, py::return_value_policy::reference)
        .def("getMatrixPosition", &diaLiteMatrix::getMatrixPosition, py::return_value_policy::reference)
        .def("getDiagonalPosition", &diaLiteMatrix::getDiagonalPosition, py::return_value_policy::reference)
        .def("getSize", &diaLiteMatrix::getSize, py::return_value_policy::reference)
        .def("getDiagonalMap", &diaLiteMatrix::getDiagonalMap, py::return_value_policy::reference)
        .def("createDiagonal", &diaLiteMatrix::createDiagonal, py::return_value_policy::reference)
        .def("print", &diaLiteMatrix::print, py::return_value_policy::reference)
        .def("getDiagonal", &diaLiteMatrix::getDiagonal, py::return_value_policy::reference)
        .def("setDiagonal", &diaLiteMatrix::setDiagonal, py::return_value_policy::reference)
        .def("addDiagonal", &diaLiteMatrix::addDiagonal, py::return_value_policy::reference)
        .def("pruneMatrix", &diaLiteMatrix::pruneMatrix, py::return_value_policy::reference)
        .def("convertToDenseMatrix", &diaLiteMatrix::convertToDenseMatrix, py::return_value_policy::reference)
        // operator bindings
        .def("__mul__", [](const diaLiteMatrix &a, const diaLiteMatrix &b){
            return a * b;
        }, py::is_operator())
        .def("__add__", [](const diaLiteMatrix &a, const diaLiteMatrix &b){
            return a + b;
        }, py::is_operator());

    // denseMatrix class
    py::class_<denseMatrix>(m, "denseMatrix")
        .def(py::init<long int, float *>())
        .def(py::init<long int, float *, float *>())
        .def(py::init<std::vector<long int> *, float *>())
        .def(py::init<std::vector<long int> *, float *, float *>())
        .def_readwrite("size", &denseMatrix::size)
        .def_readwrite("matrix_shape", &denseMatrix::matrix_shape)
        .def_readwrite("shape", &denseMatrix::shape)
        .def("getItem", &denseMatrix::getItem, py::return_value_policy::reference)
        .def("getData", &denseMatrix::getData, py::return_value_policy::reference)
        .def("set", &denseMatrix::set, py::return_value_policy::reference)
        .def("get", &denseMatrix::get, py::return_value_policy::reference)
        .def("print", &denseMatrix::print, py::return_value_policy::reference)
        .def("isPartOf", &denseMatrix::isPartOf, py::return_value_policy::reference)
        .def("sparsity", &denseMatrix::sparsity, py::return_value_policy::reference)
        .def("getTargetDiagIndex", &denseMatrix::getTargetDiagIndex, py::return_value_policy::reference)
        .def("getTargetDiagIndex_onlydiags", &denseMatrix::getTargetDiagIndex_onlydiags, py::return_value_policy::reference)
        .def("convertToQuantumSparse", &denseMatrix::convertToQuantumSparse, py::return_value_policy::reference);

    // conversion from numpy
    m.def("from_numpy", &from_numpy, py::return_value_policy::reference);
    m.def("to_numpy", &to_numpy, py::return_value_policy::reference);

    // kernel functions
    m.def("product", &product, py::return_value_policy::reference);
    m.def("denseProduct", &denseProduct, py::return_value_policy::reference);
    m.def("add", &add, py::return_value_policy::reference);
    m.def("trace", &trace, py::return_value_policy::reference);
    m.def("reshape", &reshape, py::return_value_policy::reference);
    m.def("array", &array, py::return_value_policy::reference);
    m.def(
        "tensordot",
        [](diaLiteMatrix A, diaLiteMatrix B, std::vector<std::vector<long int> > axes) { return tensordot(A, B, axes); },
        py::arg(),
        py::arg(),
        py::arg("axes") = std::vector<long int>{},
        py::return_value_policy::reference
    );
    m.def(
        "transpose",
        [](diaLiteMatrix A, std::vector<long int> new_order) { return transpose(A, new_order); },
        py::arg(),
        py::arg("axes") = std::vector<long int>{},
        py::return_value_policy::reference
    );
    m.def(
        "einsum",
        [](diaLiteMatrix A, std::vector<long int> axes) { return einsum(A, axes); },
        py::arg(),
        py::arg("axes"),
        py::return_value_policy::reference
    );
}