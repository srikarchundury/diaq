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

#ifdef CUDA_ENABLED
    PYBIND11_MODULE(diaq_gpu, m)
#else
    PYBIND11_MODULE(diaq, m)
#endif
{
    m.doc() = "get C++ version"; // optional module docstring
    m.def("version", &version, "function returns the underneath C++ version");


    py::class_<diaq::diaQMatrix, std::shared_ptr<diaq::diaQMatrix>>(m, "diaQMatrix")
        .def(py::init<unsigned int>())
        .def(py::init<unsigned int, unsigned int>())
        .def(py::init<std::array<unsigned int, 2>>())
        .def(py::init<std::array<unsigned int, 2>, const std::vector<int>&>())
        .def(py::init<std::array<unsigned int, 2>, const std::vector<int>&, std::vector<unsigned int>>())
        // attributes
        .def_readonly("matrix_shape", &diaq::diaQMatrix::matrix_shape)
        .def_readonly("shape", &diaq::diaQMatrix::shape)
        .def_readonly("dIndices", &diaq::diaQMatrix::dIndices)
        .def_readonly("diagOffsets", &diaq::diaQMatrix::diagOffsets)
        .def_readonly("totalLength", &diaq::diaQMatrix::totalLength)
        // methods
        .def("num_diags", &diaq::diaQMatrix::num_diags, py::return_value_policy::automatic)
        .def("get_diagonals", &diaq::diaQMatrix::getDiagonals, py::return_value_policy::automatic)
        .def("convertToDenseMatrix", py::overload_cast<>(&diaq::diaQMatrix::convertToDenseMatrix), py::return_value_policy::automatic)
        .def("multiplyScalar", &diaq::diaQMatrix::multiplyScalar, py::arg("real_scale_factor"), py::arg("imag_scale_factor"), py::return_value_policy::automatic)
        .def("convertToDenseMatrix", py::overload_cast<std::array<unsigned int, 2>>(&diaq::diaQMatrix::convertToDenseMatrix), py::arg(), py::return_value_policy::automatic)
        .def("sparsity", &diaq::diaQMatrix::sparsity, py::return_value_policy::automatic)
        .def("pruneMatrix", &diaq::diaQMatrix::pruneMatrix, py::return_value_policy::automatic)
        .def("reshape", &diaq::diaQMatrix::reshape, py::return_value_policy::automatic)
        .def("print", &diaq::diaQMatrix::print, py::return_value_policy::automatic)
        .def("print_meta", &diaq::diaQMatrix::print_meta, py::return_value_policy::automatic)
        .def("copy", &diaq::diaQMatrix::copy, py::return_value_policy::automatic)
        .def("matrix_reshape", [](std::shared_ptr<diaq::diaQMatrix> self, py::array_t<unsigned int> shape) {
            py::buffer_info shape_info = shape.request();
            std::array<unsigned int, 2> shape_ptr;
            std::memcpy(shape_ptr.data(), shape_info.ptr, shape_info.size * sizeof(unsigned int));
            return self->matrix_reshape(shape_ptr);
        }, py::arg(), py::return_value_policy::automatic)
        .def("transpose", [](std::shared_ptr<diaq::diaQMatrix> self, std::vector<unsigned int> new_order) { return self->transpose(new_order); }, py::arg(), py::return_value_policy::automatic)
        .def("getItem", static_cast<std::complex<diaq::valType> (diaq::diaQMatrix::*)(unsigned int) const>(&diaq::diaQMatrix::getItem), py::return_value_policy::automatic)
        .def("getItem", static_cast<std::complex<diaq::valType> (diaq::diaQMatrix::*)(std::array<unsigned int, 2>) const>(&diaq::diaQMatrix::getItem), py::return_value_policy::automatic)
        .def("getItem", static_cast<std::complex<diaq::valType> (diaq::diaQMatrix::*)(const std::vector<unsigned int>&) const>(&diaq::diaQMatrix::getItem), py::return_value_policy::automatic)
        .def("getMatrixPosition", [](std::shared_ptr<diaq::diaQMatrix> self, int diagonal_idx, unsigned int diagonal_pos) {
            return self->getMatrixPosition(diagonal_idx, diagonal_pos);
        }, py::arg("diagonal_idx"), py::arg("diagonal_pos"), py::return_value_policy::automatic)
        // .def("addMatrixScaled", [](std::shared_ptr<diaq::diaQMatrix> self, std::shared_ptr<diaq::diaQMatrix> B, diaq::valType real_scale_factor, diaq::valType imag_scale_factor) {
        //     return self->addMatrixScaled(B, real_scale_factor, imag_scale_factor);
        // }, py::arg("B"), py::arg("real_scale_factor"), py::arg("imag_scale_factor"), py::return_value_policy::automatic)
        .def("addMatrixScaled", &diaq::diaQMatrix::addMatrixScaled, py::arg("B"), py::arg("real_scale_factor"), py::arg("imag_scale_factor"), py::return_value_policy::automatic)
    ;

    // // diaq::zeroMatrix class
    // py::class_<diaq::zeroMatrix, diaq::diaQMatrix, std::shared_ptr<diaq::zeroMatrix>>(m, "zeroMatrix")
    //     .def(py::init<unsigned int, unsigned int>());

    // diaq::identityMatrix class
    py::class_<diaq::identityMatrix, diaq::diaQMatrix, std::shared_ptr<diaq::identityMatrix>>(m, "identityMatrix")
        .def(py::init<unsigned int>());

    // diaq::permutationMatrix class
    py::class_<diaq::permutationMatrix, diaq::diaQMatrix, std::shared_ptr<diaq::permutationMatrix>>(m, "permutationMatrix")
        .def(py::init<unsigned int, const std::vector<unsigned int>&>());

    // diaq::vector class
    py::class_<diaq::vector, std::shared_ptr<diaq::vector>>(m, "vector")
        .def(py::init<unsigned int>())
        .def_readonly("numRows", &diaq::vector::numRows)
        .def("setValue", &diaq::vector::setValue, py::return_value_policy::automatic)
        .def("print", &diaq::vector::print, py::return_value_policy::automatic)
        .def("print_meta", &diaq::vector::print_meta, py::return_value_policy::automatic)
        .def("dagger", &diaq::vector::dagger, py::return_value_policy::automatic)
        .def("daggerMultiplyReal", &diaq::vector::daggerMultiplyReal, py::return_value_policy::automatic)
        .def("multiply", &diaq::vector::multiply, py::return_value_policy::automatic)
        .def("getArray", &diaq::vector::getArray, py::return_value_policy::automatic)
        .def("copy", &diaq::vector::copy, py::return_value_policy::automatic)
        .def("isEqualTo", &diaq::vector::isEqualTo, py::return_value_policy::automatic)
        ;

    // diaq::denseMatrix class
    py::class_<diaq::denseMatrix, std::shared_ptr<diaq::denseMatrix>>(m, "denseMatrix")
        .def(py::init<unsigned int, diaq::valType *>())
        .def(py::init<unsigned int, diaq::valType *, diaq::valType *>())
        .def_readwrite("matrix_shape", &diaq::denseMatrix::matrix_shape)
        .def_readwrite("shape", &diaq::denseMatrix::shape)
        .def("getItem", &diaq::denseMatrix::getItem, py::return_value_policy::automatic)
        .def("set", &diaq::denseMatrix::set, py::return_value_policy::automatic)
        .def("get", &diaq::denseMatrix::get, py::return_value_policy::automatic)
        .def("print", &diaq::denseMatrix::print, py::return_value_policy::automatic)
        .def("isPartOf", &diaq::denseMatrix::isPartOf, py::return_value_policy::automatic)
        .def("sparsity", &diaq::denseMatrix::sparsity, py::return_value_policy::automatic)
        
        .def(
            "convertToDiaQ",
            [](std::shared_ptr<diaq::denseMatrix> self, std::vector<unsigned int> shape) { return self->convertToDiaQ(shape); },
            py::arg(),
            py::return_value_policy::automatic
        )
        .def(
            "convertToDiaQ",
            [](std::shared_ptr<diaq::denseMatrix> self, std::array<unsigned int, 2> matrix_shape) { return self->convertToDiaQ(matrix_shape); },
            py::arg(),
            py::return_value_policy::automatic
        )
        .def( // overload
            "convertToDiaQ",
            [](std::shared_ptr<diaq::denseMatrix> self) { return self->convertToDiaQ(); },
            py::return_value_policy::automatic
        )
        ;
    
        // Functions
        // conversion from numpy
        // m.def("from_numpy", &diaq::from_numpy, py::return_value_policy::automatic);
        m.def(
        "from_numpy",
            [](py::array_t<std::complex<diaq::valType>> vals, std::vector<unsigned int> shape) {
            // Access the buffer_info of the NumPy arrays
            py::buffer_info vals_info = vals.request();
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
        py::return_value_policy::automatic
        );
    
        m.def(
        "from_numpy",
            [](py::array_t<std::complex<diaq::valType>> vals) {
            // Access the buffer_info of the NumPy arrays
            py::buffer_info vals_info = vals.request();
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
        py::return_value_policy::automatic
        );

        // m.def(
        //     "from_sparse_pauli_op",
        //     [](py::object sparse_pauli_op) {
        //         // Convert the sparse Pauli operator to a diaQMatrix
        //         return diaq::from_sparse_pauli_op(sparse_pauli_op);
        //     },
        //     py::arg(),
        //     py::return_value_policy::automatic
        // );

        m.def(
        "from_numpy_vector",
        [](py::array_t<std::complex<diaq::valType>> vals) {
            py::buffer_info vals_info = vals.request();
            // Get pointers to the data
            std::complex<diaq::valType> *vals_ptr = static_cast<std::complex<diaq::valType> *>(vals_info.ptr);
            std::shared_ptr<diaq::vector> res = diaq::from_numpy_vector(vals_ptr, (unsigned int) vals.size());
            return res;
        },
        py::arg(),
        py::return_value_policy::automatic
        );

        m.def(
            "to_numpy",
            [](std::shared_ptr<diaq::diaQMatrix> A) {
                std::vector<std::complex<diaq::valType>> res = diaq::to_numpy(A);
                return py::array_t<std::complex<diaq::valType>>(
                    {A->matrix_shape[0], A->matrix_shape[1]},
                    res.data()
                );
            },
            py::return_value_policy::automatic
        );

        m.def(
        "to_numpy_vector",
        [](std::shared_ptr<diaq::vector> v) {
            std::vector<std::complex<diaq::valType>> res = diaq::to_numpy_vector(v);
            return py::array_t<std::complex<diaq::valType>>(v->numRows, res.data());
        },
        py::arg(),
        py::return_value_policy::automatic
        );
    
        // kernel functions
        m.def("product", &diaq::product, py::return_value_policy::automatic);
        m.def("denseProduct", &diaq::denseProduct, py::return_value_policy::automatic);
        m.def("add", &diaq::add, py::return_value_policy::automatic);
        m.def("trace", &diaq::trace, py::return_value_policy::automatic);
        m.def("reshape", &diaq::reshape, py::return_value_policy::automatic);
        m.def(
        "matrix_reshape",
        [](std::shared_ptr<diaq::diaQMatrix> A, py::array_t<unsigned int> shape) {
            py::buffer_info shape_info = shape.request();
            std::array<unsigned int, 2> shape_ptr;
            std::memcpy(shape_ptr.data(), shape_info.ptr, shape_info.size * sizeof(unsigned int));
            return diaq::matrix_reshape(A, shape_ptr);
        },
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
        );
        m.def("array", &diaq::array, py::return_value_policy::automatic);
        m.def(
        "tensordot",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::diaQMatrix> B, std::vector<std::vector<unsigned int> > axes) { return diaq::tensordot(A, B, axes); },
        py::arg(),
        py::arg(),
        py::arg("axes") = std::vector<unsigned int>{},
        py::return_value_policy::automatic
        );

    // overloading tensordot for quimb to work with contegra (seems like opt_einsum is not called now, with latest quimb)
    m.def(
        "tensordot",
        [](py::array_t<std::complex<diaq::valType>> arr1, py::array_t<std::complex<diaq::valType>> arr2, std::vector<std::vector<unsigned int>> axes) {
            // Convert arr1 to diaq::diaQMatrix
            py::buffer_info arr1_info = arr1.request();
            std::vector<unsigned int> shape1(arr1_info.shape.begin(), arr1_info.shape.end());
            std::complex<diaq::valType>* arr1_ptr = static_cast<std::complex<diaq::valType>*>(arr1_info.ptr);
            std::shared_ptr<diaq::diaQMatrix> mat1 = diaq::from_numpy(arr1_ptr, shape1);

            // Convert arr2 to diaq::diaQMatrix
            py::buffer_info arr2_info = arr2.request();
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
        py::return_value_policy::automatic
    );

    // Overload for tensordot where first argument is diaQMatrix and second is NumPy array
    m.def(
        "tensordot",
        [](std::shared_ptr<diaq::diaQMatrix> mat, py::array_t<std::complex<diaq::valType>> arr, std::vector<std::vector<unsigned int>> axes) {
            // Convert the NumPy array to diaQMatrix
            py::buffer_info arr_info = arr.request();
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
        py::return_value_policy::automatic
    );

    // Overload for tensordot where first argument is NumPy array and second is diaQMatrix
    m.def(
        "tensordot",
        [](py::array_t<std::complex<diaq::valType>> arr, std::shared_ptr<diaq::diaQMatrix> mat, std::vector<std::vector<unsigned int>> axes) {
            // Convert the NumPy array to diaQMatrix
            py::buffer_info arr_info = arr.request();
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
        py::return_value_policy::automatic
    );

    m.def(
        "transpose",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::vector<unsigned int> new_order) { return diaq::transpose(A, new_order); },
        py::arg(),
        py::arg("axes") = std::vector<unsigned int>{},
        py::return_value_policy::automatic
    );

    // New overload for transpose with NumPy array as input
    m.def(
        "transpose",
        [](py::array_t<std::complex<diaq::valType>> arr, std::vector<unsigned int> new_order) {
            // Convert the NumPy array to diaQMatrix
            py::buffer_info arr_info = arr.request();
            std::vector<unsigned int> shape(arr_info.shape.begin(), arr_info.shape.end());
            std::complex<diaq::valType>* arr_ptr = static_cast<std::complex<diaq::valType>*>(arr_info.ptr);
            std::shared_ptr<diaq::diaQMatrix> mat = diaq::from_numpy(arr_ptr, shape);

            // Perform the transpose operation
            std::shared_ptr<diaq::diaQMatrix> result = diaq::transpose(mat, new_order);

            return result;
        },
        py::arg("arr"),
        py::arg("axes") = std::vector<unsigned int>{},
        py::return_value_policy::automatic
    );

    m.def(
        "kroneckerProduct",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::diaQMatrix> B) { return diaq::kron_product(A, B); },
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
    );

    m.def(
        "matrix_kron_identity",
        [](std::shared_ptr<diaq::diaQMatrix> A, unsigned int size) { return diaq::matrix_kron_identity(A, size); },
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
    );

    m.def(
        "identity_kron_matrix",
        [](unsigned int size, std::shared_ptr<diaq::diaQMatrix> A) { return diaq::identity_kron_matrix(size, A); },
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
    );

    m.def(
        "identity_kron_matrix_kron_identity",
        [](unsigned int size1, std::shared_ptr<diaq::diaQMatrix> A, unsigned int size2) { return diaq::identity_kron_matrix_kron_identity(size1, A, size2); },
        py::arg(),
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
    );

    // spMV_ntimes overloads
    m.def(
        "spMV_ntimes",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::vector> x, int n) {
            return diaq::spMV_ntimes(A, x, n);
        },
        py::arg(),
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
    );
    m.def(
        "spMV_ntimes",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::vector> x, std::shared_ptr<diaq::vector> y, int n) {
            diaq::spMV_ntimes(A, x, y, n);
            return y;
        },
        py::arg(),
        py::arg(),
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
    );

    // spMV overloads
    m.def(
        "spMV",
        [](std::shared_ptr<diaq::diaQMatrix> A, std::shared_ptr<diaq::vector> x) {
			return diaq::spMV(A, x);
        },
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
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
        py::return_value_policy::automatic
    );
    
    // m.def(
    //     "einsum",
    //     [](std::shared_ptr<diaq::diaQMatrix> A, std::vector<unsigned int> axes) { return diaq::einsum(A, axes); },
    //     py::arg(),
    //     py::arg("axes"),
    //     py::return_value_policy::automatic
    // );
    
    m.def(
        "multiply_by_scalar",
        [](std::shared_ptr<diaq::diaQMatrix> A, diaq::valType real, diaq::valType imag) { return diaq::multiply_by_scalar(A, real, imag); },
        py::arg(),
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
    );

    m.def(
        "expm_negative",
        [](std::shared_ptr<diaq::diaQMatrix> A, diaq::valType t,
            int max_iterations = 100, diaq::valType scale_cutoff = 1.0) {
            return diaq::expm_negative_taylor_scaled(A, t, max_iterations, scale_cutoff);
        },
        py::arg("A"), py::arg("t"),
        py::arg("max_iterations") = 100,
        py::arg("scale_cutoff")   = 1.0,
        py::return_value_policy::automatic
    );

    // mixed kernels! dense times sparse and sparse times dense
    m.def(
        "dq_times_np",
        [](std::shared_ptr<diaq::diaQMatrix> A, py::array_t<std::complex<diaq::valType>> arr) {
            py::buffer_info arr_info = arr.request();
            size_t rows_B = arr_info.shape[0], cols_B = arr_info.shape[1];
            std::complex<diaq::valType>* arr_ptr = static_cast<std::complex<diaq::valType>*>(arr_info.ptr);
    
            py::array_t<std::complex<diaq::valType>> result({rows_B, cols_B});
            std::complex<diaq::valType>* result_ptr = static_cast<std::complex<diaq::valType>*>(result.request().ptr);
            std::fill(result_ptr, result_ptr + (rows_B * cols_B), std::complex<diaq::valType>(0, 0));
    
            #pragma omp parallel for collapse(2)
            for (size_t row = 0; row < rows_B; row++) {
                for (size_t k = 0; k < cols_B; k++) {
                    std::complex<diaq::valType> sum(0, 0);

                    // // Prefetch the array row
                    // #pragma omp parallel for
                    // for (size_t j = 0; j < cols_B; j++) {
                    //     // _mm_prefetch(reinterpret_cast<const char*>(&arr_ptr[j * cols_B + k]), _MM_HINT_T0); // Prefetch arr[k][j], this is for x86 based systems.
                    //     DIAQ_PREFETCH_T0(&arr_ptr[j * cols_B + k]);
                    // }
    
                    // Prefetch diagonal values (we'll assume the diagonals are relatively small)
                    for (size_t a = 0; a < A->dIndices.size(); a++) {
                        int diag_index = A->dIndices[a];
                        unsigned int offset = A->diagOffsets[a];
                        unsigned int dLength = A->getDiagonalLengthInternal(diag_index);
                        #pragma omp simd
                        for (unsigned int j = 0; j < dLength; j++) {
                            std::array<unsigned int, 2> mat_coords = A->getMatrixPosition(diag_index, j);
                            unsigned int src_row = mat_coords[0], col = mat_coords[1];
                            if (row == src_row) {
                                std::complex<diaq::valType> arr_val = arr_ptr[col * cols_B + k];
                                sum += std::complex<diaq::valType>(
                                    arr_val.real() * A->realData[offset + j] - arr_val.imag() * A->imagData[offset + j],
                                    arr_val.real() * A->imagData[offset + j] + arr_val.imag() * A->realData[offset + j]
                                );
                            }
                        }
                    }
                    result_ptr[row * cols_B + k] = sum;
                }
            }
            return result;
        },
        py::arg(), py::arg(), py::return_value_policy::automatic
    );
    
    m.def(
        "np_times_dq",
        [](py::array_t<std::complex<diaq::valType>> A, std::shared_ptr<diaq::diaQMatrix> B) {
            py::buffer_info arr_info = A.request();
            size_t rows_A = arr_info.shape[0], cols_A = arr_info.shape[1];
            std::complex<diaq::valType>* arr_ptr = static_cast<std::complex<diaq::valType>*>(arr_info.ptr);
    
            py::array_t<std::complex<diaq::valType>> result({rows_A, (size_t) B->matrix_shape[1]});
            std::complex<diaq::valType>* result_ptr = static_cast<std::complex<diaq::valType>*>(result.request().ptr);
            std::fill(result_ptr, result_ptr + (rows_A * B->matrix_shape[1]), std::complex<diaq::valType>(0, 0));
    
            #pragma omp parallel for collapse(2)
            for (size_t i = 0; i < rows_A; i++) {
                for (size_t j = 0; j < cols_A; j++) {
                    std::complex<diaq::valType> A_val = arr_ptr[i * cols_A + j];
    
                    for (size_t b = 0; b < B->dIndices.size(); b++) {
                        int diag_index = B->dIndices[b];
                        unsigned int offset = B->diagOffsets[b];
                        unsigned int dLength = B->getDiagonalLengthInternal(diag_index);
                        #pragma omp simd
                        for (unsigned int m = 0; m < dLength; m++) {
                            std::array<unsigned int, 2> mat_coords = B->getMatrixPosition(diag_index, m);
                            unsigned int sparse_j = mat_coords[0], sparse_k = mat_coords[1];
                            if (j == sparse_j) {
                                // Atomic pragma removed: not valid inside lambda
                                result_ptr[i * B->matrix_shape[1] + sparse_k] += std::complex<diaq::valType>(
                                    A_val.real() * B->realData[offset + m] - A_val.imag() * B->imagData[offset + m],
                                    A_val.real() * B->imagData[offset + m] + A_val.imag() * B->realData[offset + m]
                                );
                            }
                        }
                    }
                }
            }
            return result;
        },
        py::arg(), py::arg(), py::return_value_policy::automatic
    );

    m.def(
        "compare",
        &diaq::compare,
        py::arg(),
        py::arg(),
        py::return_value_policy::automatic
    );

    // Expose preprocessor #define values (if available) as Python dict
    m.def("install_info", []() {
        py::dict info;
#ifdef VEC_TYPE
        info["VEC_TYPE"] = static_cast<int>(VEC_TYPE);
#endif
#ifdef NUM_BYTES_ALIGNED
        info["NUM_BYTES_ALIGNED"] = static_cast<int>(NUM_BYTES_ALIGNED);
#endif
#ifdef VEC_WIDTH
        info["VEC_WIDTH"] = static_cast<int>(VEC_WIDTH);
#endif
#ifdef PREFETCH_DIST
        info["PREFETCH_DIST"] = static_cast<int>(PREFETCH_DIST);
#endif
#ifdef L1_CACHE_SIZE_BYTES
        info["L1_CACHE_SIZE_BYTES"] = static_cast<int>(L1_CACHE_SIZE_BYTES);
#endif
#ifdef CACHE_UTILIZATION
        info["CACHE_UTILIZATION"] = static_cast<double>(CACHE_UTILIZATION);
#endif
#ifdef NUM_ARRAYS_ACCESSED
        info["NUM_ARRAYS_ACCESSED"] = static_cast<int>(NUM_ARRAYS_ACCESSED);
#endif
#ifdef BLOCK_SIZE_RAW
        info["BLOCK_SIZE_RAW"] = static_cast<int>(BLOCK_SIZE_RAW);
#endif
#ifdef BLOCK_SIZE
        info["BLOCK_SIZE"] = static_cast<int>(BLOCK_SIZE);
#endif
#ifdef NUMBER_OF_OMP_THREADS
        info["NUMBER_OF_OMP_THREADS"] = static_cast<int>(NUMBER_OF_OMP_THREADS);
#endif
#ifdef PAPI_ON
        info["PAPI_ON"] = true;
#else
        info["PAPI_ON"] = false;
#endif
#ifdef CUDA_ENABLED
        info["CUDA_ENABLED"] = true;
#else
        info["CUDA_ENABLED"] = false;
#endif
#ifdef MANUAL_SIMD
        info["MANUAL_SIMD"] = true;
#else
        info["MANUAL_SIMD"] = false;
#endif
#ifdef DEBUG
        info["DEBUG"] = true;
#else
        info["DEBUG"] = false;
#endif
#ifdef DEEP_DEBUG
        info["DEEP_DEBUG"] = true;
#else
        info["DEEP_DEBUG"] = false;
#endif
        // Data type info
        info["valType"] = py::str(typeid(diaq::valType).name());
        return info;
    }, "Returns SIMD and install configuration info as a dict");

} // end of PYBIND11_MODULE
