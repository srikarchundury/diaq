#include <pybind11/pybind11.h>
#include <pybind11/complex.h>
#include <pybind11/stl.h>
#include <pybind11/functional.h>
#include <pybind11/chrono.h>

#include "qSparse.hpp"


namespace py = pybind11;

std::string version() {
    return QSPARSE_VERSION;
}

PYBIND11_MODULE(qsparse, m) {
    m.doc() = "get C++ version"; // optional module docstring
    m.def("version", &version, "function returns the underneath C++ version");

    // diagonal class and it's routines
    py::class_<diagonal>(m, "diagonal")
        .def(py::init<int>())
        .def("getIndex", &diagonal::getIndex, py::return_value_policy::reference)
        .def("addElement", &diagonal::addElement, py::return_value_policy::reference)
        .def("setValue", &diagonal::setValue, py::return_value_policy::reference)
        .def("getValue", &diagonal::getValue, py::return_value_policy::reference)
        .def("print", &diagonal::print, py::return_value_policy::reference)
        .def("getValues", &diagonal::getValues, py::return_value_policy::reference)
        .def("getCoords", &diagonal::getCoords, py::return_value_policy::reference)
        .def("getDIndex", &diagonal::getDIndex, py::return_value_policy::reference)
        .def("numNonZeros", &diagonal::numNonZeros, py::return_value_policy::reference);
    
    // quantumSparseMatrix class
    py::class_<quantumSparseMatrix>(m, "quantumSparseMatrix")
        .def(py::init<std::map<int, diagonal>, int>())
        .def("getSize", &quantumSparseMatrix::getSize, py::return_value_policy::reference)
        .def("getDiagonalMap", &quantumSparseMatrix::getDiagonalMap, py::return_value_policy::reference)
        .def("createDiagonal", &quantumSparseMatrix::createDiagonal, py::return_value_policy::reference)
        .def("print", &quantumSparseMatrix::print, py::return_value_policy::reference)
        .def("getDiagonal", &quantumSparseMatrix::getDiagonal, py::return_value_policy::reference)
        .def("addToDiagonal", &quantumSparseMatrix::addToDiagonal, py::return_value_policy::reference)
        .def("setDiagonal", &quantumSparseMatrix::setDiagonal, py::return_value_policy::reference)
        .def("addDiagonal", &quantumSparseMatrix::addDiagonal, py::return_value_policy::reference)
        .def("pruneMatrix", &quantumSparseMatrix::pruneMatrix, py::return_value_policy::reference)
        .def("convertToDenseMatrix", &quantumSparseMatrix::convertToDenseMatrix, py::return_value_policy::reference);

    // denseMatrix class
    py::class_<denseMatrix>(m, "denseMatrix")
        .def(py::init<int, std::vector<std::complex<double> > >())
        .def("getSize", &denseMatrix::getSize, py::return_value_policy::reference)
        .def("set", &denseMatrix::set, py::return_value_policy::reference)
        .def("get", &denseMatrix::get, py::return_value_policy::reference)
        .def("print", &denseMatrix::print, py::return_value_policy::reference)
        .def("isPartOf", &denseMatrix::isPartOf, py::return_value_policy::reference)
        .def("sparsity", &denseMatrix::sparsity, py::return_value_policy::reference)
        .def("getTargetDiagIndex", &denseMatrix::getTargetDiagIndex, py::return_value_policy::reference)
        .def("getTargetDiagIndex_onlydiags", &denseMatrix::getTargetDiagIndex_onlydiags, py::return_value_policy::reference)
        .def("convertToQuantumSparse", &denseMatrix::convertToQuantumSparse, py::return_value_policy::reference);

    // kernel functions
    m.def("product", &product);
    m.def("denseProduct", &denseProduct);

    // TODO: einsum, tensordot routines
}