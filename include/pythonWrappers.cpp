#include <pybind11/pybind11.h>
#include <pybind11/complex.h>
#include <pybind11/stl.h>
#include <pybind11/functional.h>
#include <pybind11/chrono.h>
#include <pybind11/numpy.h>
#include <pybind11/operators.h>
#include <unordered_map>
#include <memory>

#include "diaq.hpp"

namespace py = pybind11;

std::string version() {
    return DIAQ_VERSION;
}

PYBIND11_MODULE(diaq, m) {
    m.doc() = "get C++ version"; // optional module docstring
    m.def("version", &version, "function returns the underneath C++ version");

    // diaq::diagonal class and its routines
    py::class_<diaq::diagonal, std::shared_ptr<diaq::diagonal>>(m, "diagonal")
        .def(py::init<unsigned int>())
        .def_readwrite("dIndex", &diaq::diagonal::dIndex)
        .def_readwrite("dLength", &diaq::diagonal::dLength)
        .def("setValue", &diaq::diagonal::setValue, py::return_value_policy::reference)
        .def("getValue", &diaq::diagonal::getValue, py::return_value_policy::reference)
        .def("print", &diaq::diagonal::print, py::return_value_policy::reference)
        .def("getCoords", &diaq::diagonal::getCoords, py::return_value_policy::reference)
        .def("getDIndex", &diaq::diagonal::getDIndex, py::return_value_policy::reference)
        .def("numNonZeros", &diaq::diagonal::numNonZeros, py::return_value_policy::reference)
		.def("__getitem__", [](std::shared_ptr<diaq::diagonal> self, unsigned int d_pos) -> std::complex<diaq::valType> & {
			return (*self)[d_pos];
		}, py::return_value_policy::reference)
		.def("scale_by_imag", &diaq::diagonal::scale_by_imag, py::return_value_policy::reference)
		.def("scale_by_real", &diaq::diagonal::scale_by_real, py::return_value_policy::reference)
	;

    // diaq::diaQMatrix class
    py::class_<diaq::diaQMatrix, std::shared_ptr<diaq::diaQMatrix>>(m, "diaQMatrix")
        .def(py::init<std::unordered_map<int, std::shared_ptr<diaq::diagonal>>, unsigned int>())
        .def_readwrite("matrix_shape", &diaq::diaQMatrix::matrix_shape)
        .def_readwrite("shape", &diaq::diaQMatrix::shape)
        // -- //
        // .def("getItem", static_cast<std::complex<diaq::valType> (diaq::diaQMatrix::*)(unsigned int)>(&diaq::diaQMatrix::getItem))
        // .def("getItem", static_cast<std::complex<diaq::valType> (diaq::diaQMatrix::*)(std::vector<unsigned int>)>(&diaq::diaQMatrix::getItem))
        // .def("getItem", static_cast<std::complex<diaq::valType> (diaq::diaQMatrix::*)(std::shared_ptr<unsigned int[]>)>(&diaq::diaQMatrix::getItem))
        // -- //
		// .def("getMatrixPosition", static_cast<std::shared_ptr<unsigned int[]> (diaq::diaQMatrix::*)(unsigned int)>(&diaq::diaQMatrix::getMatrixPosition))
		// .def("getMatrixPosition", static_cast<std::shared_ptr<unsigned int[]> (diaq::diaQMatrix::*)(int, unsigned int)>(&diaq::diaQMatrix::getMatrixPosition))
		// -- //
		// .def("getDiagonalPosition", static_cast<std::shared_ptr<int[]> (diaq::diaQMatrix::*)(unsigned int)>(&diaq::diaQMatrix::getDiagonalPosition))
		// .def("getDiagonalPosition", static_cast<std::shared_ptr<int[]> (diaq::diaQMatrix::*)(std::vector<unsigned int>)>(&diaq::diaQMatrix::getDiagonalPosition))
		// .def("getDiagonalPosition", static_cast<std::shared_ptr<int[]> (diaq::diaQMatrix::*)(std::shared_ptr<unsigned int[]>)>(&diaq::diaQMatrix::getDiagonalPosition))
        // --- //
        .def("getDiagonalMap", &diaq::diaQMatrix::getDiagonalMap, py::return_value_policy::reference)
        .def("createDiagonal", &diaq::diaQMatrix::createDiagonal, py::return_value_policy::reference)
        .def("print", &diaq::diaQMatrix::print, py::return_value_policy::reference)
        .def("print_meta", &diaq::diaQMatrix::print_meta, py::return_value_policy::reference)
        .def("getDiagonal", &diaq::diaQMatrix::getDiagonal, py::return_value_policy::reference)
        .def("setDiagonal", &diaq::diaQMatrix::setDiagonal, py::return_value_policy::reference)
        .def("setDiagonalElement", &diaq::diaQMatrix::setDiagonalElement, py::return_value_policy::reference) 
        .def("addDiagonal", &diaq::diaQMatrix::addDiagonal, py::return_value_policy::reference)
        .def("pruneMatrix", &diaq::diaQMatrix::pruneMatrix, py::return_value_policy::reference)
        .def("sparsity", &diaq::diaQMatrix::sparsity, py::return_value_policy::reference)
        .def("flatten", &diaq::diaQMatrix::flatten, py::return_value_policy::reference)
        .def("num_diags", &diaq::diaQMatrix::num_diags, py::return_value_policy::reference)
        .def("multiplyMatrix", &diaq::diaQMatrix::multiplyMatrix, py::return_value_policy::reference)
        .def("multiplyVector", &diaq::diaQMatrix::multiplyVector, py::return_value_policy::reference)
        // operator bindings
        .def("__mul__", [](std::shared_ptr<diaq::diaQMatrix> a, std::shared_ptr<diaq::diaQMatrix> b){
            return diaq::product(a, b);
        }, py::is_operator())
        .def("__add__", [](std::shared_ptr<diaq::diaQMatrix> a, std::shared_ptr<diaq::diaQMatrix> b){
            return diaq::add(a, b);
		}, py::is_operator())
		.def("__getitem__", [](std::shared_ptr<diaq::diaQMatrix> self, int dIndex) -> std::shared_ptr<diaq::diagonal> {
			return (*self)[dIndex];
		}, py::return_value_policy::reference)

        .def(
            "get_diagonals",
            [](std::shared_ptr<diaq::diaQMatrix> self) { return self->getDiagonals(); },
            py::return_value_policy::reference
        )
		// .def("convertToDenseMatrix", &diaq::diaQMatrix::convertToDenseMatrix, py::return_value_policy::reference)
        .def(
            "convertToDenseMatrix",
            [](std::shared_ptr<diaq::diaQMatrix> self) { return self->convertToDenseMatrix(); },
            py::return_value_policy::reference
        )
        .def( // overload
            "convertToDenseMatrix",
            [](std::shared_ptr<diaq::diaQMatrix> self, unsigned int *matrix_shape) { return self->convertToDenseMatrix(matrix_shape); },
            py::arg(),
            py::return_value_policy::reference
        )
        .def("reshape", &diaq::diaQMatrix::reshape, py::return_value_policy::reference)
        .def(
            "matrix_reshape",
            [](std::shared_ptr<diaq::diaQMatrix> self, py::array_t<unsigned int> shape) {
                auto shape_info = shape.request();
                unsigned int *shape_ptr = static_cast<unsigned int *>(shape_info.ptr);
                return self->matrix_reshape(shape_ptr);
            },
            py::arg(),
            py::return_value_policy::reference
        )
        .def(
            "transpose",
            [](std::shared_ptr<diaq::diaQMatrix> self, std::vector<unsigned int> new_order) { return self->transpose(new_order); },
            py::arg(),
            py::return_value_policy::reference
        )
        ;

    // diaq::identityMatrix class
	py::class_<diaq::identityMatrix, diaq::diaQMatrix, std::shared_ptr<diaq::identityMatrix>>(m, "identityMatrix")
		.def(py::init<unsigned int>());

	// diaq::permutationMatrix class
	py::class_<diaq::permutationMatrix, diaq::diaQMatrix, std::shared_ptr<diaq::permutationMatrix>>(m, "permutationMatrix")
		.def(py::init<unsigned int, std::vector<unsigned int>>());

    // diaq::vector class
    py::class_<diaq::vector, std::shared_ptr<diaq::vector>>(m, "vector")
        .def(py::init<unsigned int>())
        .def("setValue", &diaq::vector::setValue, py::return_value_policy::reference)
        .def("print", &diaq::vector::print, py::return_value_policy::reference)
        .def("print_meta", &diaq::vector::print_meta, py::return_value_policy::reference)
        .def("dagger", &diaq::vector::dagger, py::return_value_policy::reference)
        .def("daggerMultiplyReal", &diaq::vector::daggerMultiplyReal, py::return_value_policy::reference)
        .def("multiply", &diaq::vector::multiply, py::return_value_policy::reference)
        .def("getArray", &diaq::vector::getArray, py::return_value_policy::reference)
        ;

    // diaq::denseMatrix class
    py::class_<diaq::denseMatrix, std::shared_ptr<diaq::denseMatrix>>(m, "denseMatrix")
        .def(py::init<unsigned int, diaq::valType *>())
        .def(py::init<unsigned int, diaq::valType *, diaq::valType *>())
        // .def(py::init<unsigned int **, diaq::valType *>())
        // .def(py::init<unsigned int **, diaq::valType *, diaq::valType *>())
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
        .def(
            "convertToDiaQ",
            [](std::shared_ptr<diaq::denseMatrix> self, std::vector<unsigned int> shape) { return self->convertToDiaQ(shape); },
            py::arg(),
            py::return_value_policy::reference
        )
        .def(
            "convertToDiaQ",
            [](std::shared_ptr<diaq::denseMatrix> self, unsigned int *matrix_shape) { return self->convertToDiaQ(matrix_shape); },
            py::arg(),
            py::return_value_policy::reference
        )
        .def( // overload
            "convertToDiaQ",
            [](std::shared_ptr<diaq::denseMatrix> self) { return self->convertToDiaQ(); },
            py::return_value_policy::reference
        )
        ;
    
        // Functions
        // conversion from numpy
        // m.def("from_numpy", &diaq::from_numpy, py::return_value_policy::reference);
        m.def(
        "from_numpy",
        [](py::array_t<std::complex<diaq::valType>> vals, std::vector<unsigned int> shape) {
            // Access the buffer_info of the NumPy arrays
            auto vals_info = vals.request();
            // Check if the input arrays have the correct dimensions
            if (vals_info.ndim != 1) {
            throw std::runtime_error("Input arrays must be 1-dimensional.");
            }
            // Get pointers to the data
            std::complex<diaq::valType> *vals_ptr = static_cast<std::complex<diaq::valType> *>(vals_info.ptr);
            // Construct the diaQMatrix object
            return diaq::from_numpy(vals_ptr, shape);
        },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
        );
    
        m.def(
        "from_numpy",
        [](py::array_t<std::complex<diaq::valType>> vals) {
            // Access the buffer_info of the NumPy arrays
            auto vals_info = vals.request();
            // make shape
            std::vector<unsigned int> shape;
            for (int i = 0; i < vals_info.ndim; i++) {
            shape.push_back(vals_info.shape[i]);
            }
            // Get pointers to the data
            std::complex<diaq::valType> *vals_ptr = static_cast<std::complex<diaq::valType> *>(vals_info.ptr);
            // Construct the diaQMatrix object
            std::shared_ptr<diaq::diaQMatrix> res = diaq::from_numpy(vals_ptr, shape);
            return res;
        },
        py::arg(),
        py::return_value_policy::reference
        );
    
        m.def(
        "from_numpy_vector",
        [](py::array_t<std::complex<diaq::valType>> vals) {
            auto vals_info = vals.request();
            // Get pointers to the data
            std::complex<diaq::valType> *vals_ptr = static_cast<std::complex<diaq::valType> *>(vals_info.ptr);
            std::shared_ptr<diaq::vector> res = diaq::from_numpy_vector(vals_ptr, (unsigned int) vals.size());
            return res;
        },
        py::arg(),
        py::return_value_policy::reference
        );
    
        // m.def("to_numpy", &diaq::to_numpy, py::return_value_policy::reference);
        m.def(
        "to_numpy",
        [](std::shared_ptr<diaq::diaQMatrix> A) {
            std::complex<diaq::valType> *res = diaq::to_numpy(A);
            return py::array_t<std::complex<diaq::valType>>(A->matrix_shape[0] * A->matrix_shape[1], res);
        },
        py::return_value_policy::reference
        );
    
        m.def(
        "to_numpy_vector",
        [](std::shared_ptr<diaq::vector> v) {
            std::complex<diaq::valType> *res = diaq::to_numpy_vector(v);
            return py::array_t<std::complex<diaq::valType>>(v->numRows, res);
        },
        py::arg(),
        py::return_value_policy::reference
        );
    
        // kernel functions
        m.def("product", &diaq::product, py::return_value_policy::reference);
        m.def("denseProduct", &diaq::denseProduct, py::return_value_policy::reference);
        m.def("add", &diaq::add, py::return_value_policy::reference);
        m.def("trace", &diaq::trace, py::return_value_policy::reference);
        m.def("reshape", &diaq::reshape, py::return_value_policy::reference);
        m.def(
        "matrix_reshape",
        [](std::shared_ptr<diaq::diaQMatrix> A, py::array_t<unsigned int> shape) {
            auto shape_info = shape.request();
            unsigned int *shape_ptr = static_cast<unsigned int *>(shape_info.ptr);
            return diaq::matrix_reshape(A, shape_ptr);
        },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
        );
        m.def("array", &diaq::array, py::return_value_policy::reference);
        m.def(
        "tensordot",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::diaQMatrix> B, std::vector<std::vector<unsigned int> > axes) { return diaq::tensordot(A, B, axes); },
        py::arg(),
        py::arg(),
        py::arg("axes") = std::vector<unsigned int>{},
        py::return_value_policy::reference
        );

    // overloading tensordot for quimb to work with contegra (seems like opt_einsum is not called now, with latest quimb)
    m.def(
        "tensordot",
        [](py::array_t<std::complex<diaq::valType>> arr1, py::array_t<std::complex<diaq::valType>> arr2, std::vector<std::vector<unsigned int>> axes) {
            // Convert arr1 to diaq::diaQMatrix
            auto arr1_info = arr1.request();
            std::vector<unsigned int> shape1(arr1_info.shape.begin(), arr1_info.shape.end());
            std::complex<diaq::valType>* arr1_ptr = static_cast<std::complex<diaq::valType>*>(arr1_info.ptr);
            std::shared_ptr<diaq::diaQMatrix> mat1 = diaq::from_numpy(arr1_ptr, shape1);

            // Convert arr2 to diaq::diaQMatrix
            auto arr2_info = arr2.request();
            std::vector<unsigned int> shape2(arr2_info.shape.begin(), arr2_info.shape.end());
            std::complex<diaq::valType>* arr2_ptr = static_cast<std::complex<diaq::valType>*>(arr2_info.ptr);
            std::shared_ptr<diaq::diaQMatrix> mat2 = diaq::from_numpy(arr2_ptr, shape2);

            // Perform tensordot on diaQMatrix objects
            std::shared_ptr<diaq::diaQMatrix> result = diaq::tensordot(mat1, mat2, axes);

            return result;
        },
        py::arg("arr1"),
        py::arg("arr2"),
        py::arg("axes") = std::vector<std::vector<unsigned int>>{},
        py::return_value_policy::reference
    );

    // Overload for tensordot where first argument is diaQMatrix and second is NumPy array
    m.def(
        "tensordot",
        [](std::shared_ptr<diaq::diaQMatrix> mat, py::array_t<std::complex<diaq::valType>> arr, std::vector<std::vector<unsigned int>> axes) {
            // Convert the NumPy array to diaQMatrix
            auto arr_info = arr.request();
            std::vector<unsigned int> shape(arr_info.shape.begin(), arr_info.shape.end());
            std::complex<diaq::valType>* arr_ptr = static_cast<std::complex<diaq::valType>*>(arr_info.ptr);
            std::shared_ptr<diaq::diaQMatrix> mat_arr = diaq::from_numpy(arr_ptr, shape);

            // Perform tensordot on diaQMatrix and converted NumPy array (now diaQMatrix)
            std::shared_ptr<diaq::diaQMatrix> result = diaq::tensordot(mat, mat_arr, axes);

            return result;
        },
        py::arg("mat"),
        py::arg("arr"),
        py::arg("axes") = std::vector<std::vector<unsigned int>>{},
        py::return_value_policy::reference
    );

    // Overload for tensordot where first argument is NumPy array and second is diaQMatrix
    m.def(
        "tensordot",
        [](py::array_t<std::complex<diaq::valType>> arr, std::shared_ptr<diaq::diaQMatrix> mat, std::vector<std::vector<unsigned int>> axes) {
            // Convert the NumPy array to diaQMatrix
            auto arr_info = arr.request();
            std::vector<unsigned int> shape(arr_info.shape.begin(), arr_info.shape.end());
            std::complex<diaq::valType>* arr_ptr = static_cast<std::complex<diaq::valType>*>(arr_info.ptr);
            std::shared_ptr<diaq::diaQMatrix> mat_arr = diaq::from_numpy(arr_ptr, shape);

            // Perform tensordot on converted NumPy array (now diaQMatrix) and diaQMatrix
            std::shared_ptr<diaq::diaQMatrix> result = diaq::tensordot(mat_arr, mat, axes);

            return result;
        },
        py::arg("arr"),
        py::arg("mat"),
        py::arg("axes") = std::vector<std::vector<unsigned int>>{},
        py::return_value_policy::reference
    );

    m.def(
        "transpose",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::vector<unsigned int> new_order) { return diaq::transpose(A, new_order); },
        py::arg(),
        py::arg("axes") = std::vector<unsigned int>{},
        py::return_value_policy::reference
    );

    // New overload for transpose with NumPy array as input
    m.def(
        "transpose",
        [](py::array_t<std::complex<diaq::valType>> arr, std::vector<unsigned int> new_order) {
            // Convert the NumPy array to diaQMatrix
            auto arr_info = arr.request();
            std::vector<unsigned int> shape(arr_info.shape.begin(), arr_info.shape.end());
            std::complex<diaq::valType>* arr_ptr = static_cast<std::complex<diaq::valType>*>(arr_info.ptr);
            std::shared_ptr<diaq::diaQMatrix> mat = diaq::from_numpy(arr_ptr, shape);

            // Perform the transpose operation
            std::shared_ptr<diaq::diaQMatrix> result = diaq::transpose(mat, new_order);

            return result;
        },
        py::arg("arr"),
        py::arg("axes") = std::vector<unsigned int>{},
        py::return_value_policy::reference
    );

    m.def(
        "kroneckerProduct",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::diaQMatrix> B) { return diaq::kron_product(A, B); },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );

    m.def(
        "matrix_kron_identity",
        [](std::shared_ptr<diaq::diaQMatrix> A, unsigned int size) { return diaq::matrix_kron_identity(A, size); },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );

    m.def(
        "identity_kron_matrix",
        [](unsigned int size, std::shared_ptr<diaq::diaQMatrix> A) { return diaq::identity_kron_matrix(size, A); },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );

    m.def(
        "identity_kron_matrix_kron_identity",
        [](unsigned int size1, std::shared_ptr<diaq::diaQMatrix> A, unsigned int size2) { return diaq::identity_kron_matrix_kron_identity(size1, A, size2); },
        py::arg(),
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );

    m.def(
        "spMV",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::vector> x) {
			return diaq::spMV(A, x);
        },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );
    
    m.def(
        "spMV",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::vector> x, std::shared_ptr<diaq::vector> y) {
            diaq::spMV(A, x, y);
			return y;
        },
        py::arg(),
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );
    
    // m.def(
    //     "einsum",
    //     [](std::shared_ptr<diaq::diaQMatrix> A, std::vector<unsigned int> axes) { return diaq::einsum(A, axes); },
    //     py::arg(),
    //     py::arg("axes"),
    //     py::return_value_policy::reference
    // );
    
    m.def(
        "multiply_by_scalar",
        [](std::shared_ptr<diaq::diaQMatrix> A, diaq::valType real, diaq::valType imag) { return diaq::multiply_by_scalar(A, real, imag); },
        py::arg(),
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );
    
    m.def(
        "expm_negative",
        [](std::shared_ptr<diaq::diaQMatrix> A, diaq::valType t) { return diaq::expm_negative(A, t); },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );

    m.def(
        "dq_times_np",
        [](std::shared_ptr<diaq::diaQMatrix> A, py::array_t<std::complex<diaq::valType>> arr) {

            #ifdef DEBUG
                auto start = std::chrono::high_resolution_clock::now();
            #endif
            // Get NumPy array buffer info
            auto arr_info = arr.request();
            // if (arr_info.ndim != 2) {
            //     throw std::runtime_error("Input array must be two-dimensional.");
            // }    
            size_t rows_B = arr_info.shape[0]; // Number of rows in B
            size_t cols_B = arr_info.shape[1]; // Number of columns in B (K)
            auto arr_ptr = static_cast<std::complex<diaq::valType>*>(arr_info.ptr);

            // Output matrix C(i, k) -> same shape as input
            py::array_t<std::complex<diaq::valType>> result({rows_B, cols_B});
            auto result_ptr = static_cast<std::complex<diaq::valType>*>(result.request().ptr);

            // Initialize result with zeros
            #pragma omp parallel for collapse(2)
            for (size_t i = 0; i < rows_B; i++) {
                for (size_t k = 0; k < cols_B; k++) {
                    result_ptr[i * cols_B + k] = {0, 0};
                }
            }

            // Perform sparse diagonal matrix-matrix multiplication
            // #pragma omp parallel for
            // for (size_t i = 0; i < A->diagonalMap.size(); i++) {
            //     auto it = std::next(A->diagonalMap.begin(), i);
            //     int diag_index = it->first; // Diagonal shift
            //     auto diag = it->second;     // Diagonal object

            //     diaq::valType *diag_real_vals = diag->realValues;
            //     diaq::valType *diag_imag_vals = diag->imagValues;

            //     for (unsigned int j = 0; j < diag->dLength; j++) {
            //         std::shared_ptr<unsigned int[]> mat_coords = A->getMatrixPosition(diag_index, j);
            //         unsigned int row = mat_coords[0];
            //         unsigned int col = mat_coords[1];
            //         // Multiply each column in B
            //         #pragma omp simd
            //         for (size_t k = 0; k < cols_B; k++) {
            //             result_ptr[row * cols_B + k].real(
            //                 result_ptr[row * cols_B + k].real() + diag_real_vals[j] * arr_ptr[col * cols_B + k].real() - diag_imag_vals[j] * arr_ptr[col * cols_B + k].imag()
            //             );
            //             result_ptr[row * cols_B + k].imag(
            //                 result_ptr[row * cols_B + k].imag() + diag_real_vals[j] * arr_ptr[col * cols_B + k].imag() + diag_imag_vals[j] * arr_ptr[col * cols_B + k].real()
            //             );
            //         }
            //     }
            // }

            #pragma omp parallel
            {
                std::vector<std::complex<diaq::valType>> local_result(rows_B * cols_B, {0, 0});

                #pragma omp for
                for (size_t i = 0; i < A->diagonalMap.size(); i++) {
                    auto it = std::next(A->diagonalMap.begin(), i);
                    int diag_index = it->first; // Diagonal shift
                    auto diag = it->second;     // Diagonal object

                    diaq::valType *diag_real_vals = diag->realValues;
                    diaq::valType *diag_imag_vals = diag->imagValues;

                    for (unsigned int j = 0; j < diag->dLength; j++) {
                        std::shared_ptr<unsigned int[]> mat_coords = A->getMatrixPosition(diag_index, j);
                        unsigned int row = mat_coords[0];
                        unsigned int col = mat_coords[1];

                        #pragma omp simd
                        for (size_t k = 0; k < cols_B; k++) {
                            local_result[row * cols_B + k].real(
                                local_result[row * cols_B + k].real() + diag_real_vals[j] * arr_ptr[col * cols_B + k].real() - diag_imag_vals[j] * arr_ptr[col * cols_B + k].imag()
                            );
                            local_result[row * cols_B + k].imag(
                                local_result[row * cols_B + k].imag() + diag_real_vals[j] * arr_ptr[col * cols_B + k].imag() + diag_imag_vals[j] * arr_ptr[col * cols_B + k].real()
                            );
                        }
                    }
                }

                // Reduce local results to the global result array
                #pragma omp critical
                {
                    for (size_t i = 0; i < rows_B * cols_B; i++) {
                        result_ptr[i] += local_result[i];
                    }
                }
            }

            #ifdef DEBUG
                auto end = std::chrono::high_resolution_clock::now();
                auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
                printf("\t\t dq_times_np took %f milliseconds\n", duration.count()/1000.0);
            #endif

            return result;
        },
        py::arg(),
        py::arg(),
        py::return_value_policy::reference
    );

} // end of PYBIND11_MODULE