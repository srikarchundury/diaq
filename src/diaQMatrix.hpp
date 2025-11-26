#ifndef DIAQ_DIAQMATRIX_HPP
#define DIAQ_DIAQMATRIX_HPP

#include <array>
#include <vector>
#include <complex>
#include <cmath>
#include <limits>
#include <stdexcept>
#include <algorithm>
#include <numeric>
#include <iostream>

#ifdef DEBUG
    #include <chrono>
#endif

#include "config.hpp"
#include "vector.hpp"

namespace diaq {

// Helper: generate diagonal order [0, -1, +1, -2, +2, ...] for n diagonals
inline std::vector<int> generateSymmetricDiagonalOrder(unsigned int numDiags) {
	std::vector<int> order;
	order.reserve(numDiags);
	// int d = 0;
	for (unsigned int i = 0; i < numDiags; ++i) {
		if (i == 0) {
			order.push_back(0);
		} else if (i % 2 == 1) {
			order.push_back(-((i + 1) / 2));
		} else {
			order.push_back((i) / 2);
		}
	}
	return order;
}

class denseMatrix; // forward declaration

class diaQMatrix : public std::enable_shared_from_this<diaQMatrix> {
public:
	std::array<unsigned int, 2> matrix_shape;   // [rows, cols]
	std::vector<unsigned int>   shape;          // tensor shape

	// Logical diagonal indices (e.g., 0, 1, -1, 2, -2, ...), in fixed order.
	std::vector<int> dIndices;

	// diagOffsets[k] = SIMD-padded starting offset in realData/imagData for diagonal k.
	// This allows fast, aligned access for vectorized operations (SIMD).
	// If SIMD is enabled, each diagonal's start is padded to VEC_WIDTH alignment.
	std::vector<unsigned int> diagOffsets;

	// Total number of stored elements across all diagonals.
	// totalLength = total number of elements allocated for all diagonals (including SIMD padding).
	// Used for memory allocation and iteration over all stored values.
	unsigned int totalLength;

	// Contiguous, aligned storage for all diagonal values (SoA layout).
	valType *realData;
	valType *imagData;

	// -------------------- Constructors --------------------

	// Square matrix with default symmetric diagonal order
	diaQMatrix(unsigned int s, unsigned int numDiags = 0)
		: matrix_shape(), shape(), dIndices(), diagOffsets(),
		  totalLength(0), realData(NULL), imagData(NULL)
	{
		matrix_shape[0] = s;
		matrix_shape[1] = s;
		shape.resize(2);
		shape[0] = s;
		shape[1] = s;
		if (numDiags > 0) {
			dIndices = generateSymmetricDiagonalOrder(numDiags);
			initStorage();
		}
	}

	// Rectangular matrix with default symmetric diagonal order
	diaQMatrix(unsigned int x, unsigned int y, unsigned int numDiags)
		: matrix_shape(), shape(), dIndices(), diagOffsets(),
		totalLength(0), realData(NULL), imagData(NULL)
	{
		matrix_shape[0] = x;
		matrix_shape[1] = y;
		shape.resize(2);
		shape[0] = x;
		shape[1] = y;
		if (numDiags > 0) {
			dIndices = generateSymmetricDiagonalOrder(numDiags);
			initStorage();
		}
	}

	// From array dims.
	diaQMatrix(std::array<unsigned int, 2> dimens)
		: matrix_shape(dimens), shape(), dIndices(), diagOffsets(),
		  totalLength(0), realData(NULL), imagData(NULL)
	{
		shape.resize(2);
		shape[0] = dimens[0];
		shape[1] = dimens[1];
	}

	// From array dims and tensor shape.
	diaQMatrix(std::array<unsigned int, 2> dimens,
	           std::vector<unsigned int> ts)
		: matrix_shape(dimens), shape(ts), dIndices(), diagOffsets(),
		  totalLength(0), realData(NULL), imagData(NULL)
	{
	}

	// Main new constructor: dims + diagonal indices + optional tensor shape.
	diaQMatrix(std::array<unsigned int, 2> dimens,
	           const std::vector<int> &diag_indices,
	           std::vector<unsigned int> ts)
		: matrix_shape(dimens), shape(), dIndices(diag_indices),
		  diagOffsets(), totalLength(0), realData(NULL), imagData(NULL)
	{
		if (ts.size() > 0) {
			shape = ts;
		} else {
			shape.resize(2);
			shape[0] = dimens[0];
			shape[1] = dimens[1];
		}
		initStorage();
	}

	// Constructor: dims + diagonal indices only
	diaQMatrix(std::array<unsigned int, 2> dimens,
			   const std::vector<int> &diag_indices)
		: matrix_shape(dimens), shape(), dIndices(diag_indices),
		  diagOffsets(), totalLength(0), realData(NULL), imagData(NULL)
	{
		shape.resize(2);
		shape[0] = dimens[0];
		shape[1] = dimens[1];
		initStorage();
	}

	// Copy constructor (deep copy).
	diaQMatrix(const diaQMatrix &other)
			: std::enable_shared_from_this<diaQMatrix>(other),
				matrix_shape(other.matrix_shape),
				shape(other.shape),
				dIndices(other.dIndices),
				diagOffsets(other.diagOffsets),
				totalLength(other.totalLength),
				realData(NULL),
				imagData(NULL)
	{
		if (totalLength > 0) {
			#if NUM_BYTES_ALIGNED <= 0
				realData = (valType *)calloc(totalLength, sizeof(valType));
				imagData = (valType *)calloc(totalLength, sizeof(valType));
			#else
				realData = aligned_alloc_helper(totalLength * sizeof(valType));
				imagData = aligned_alloc_helper(totalLength * sizeof(valType));
				// #pragma omp parallel for
				// for (unsigned int i = 0; i < totalLength; i++) {
				// 	realData[i] = 0.0;
				// 	imagData[i] = 0.0;
				// }
			#endif

			#pragma omp parallel for
			for (unsigned int i = 0; i < totalLength; i++) {
				realData[i] = other.realData[i];
				imagData[i] = other.imagData[i];
			}
		}
	}

	// Move constructor.
	diaQMatrix(diaQMatrix &&other) noexcept
		: matrix_shape(other.matrix_shape),
		  shape(other.shape),
		  dIndices(other.dIndices),
		  diagOffsets(other.diagOffsets),
		  totalLength(other.totalLength),
		  realData(other.realData),
		  imagData(other.imagData)
	{
		other.shape.clear();
		other.dIndices.clear();
		other.diagOffsets.clear();
		other.realData    = NULL;
		other.imagData    = NULL;
		other.totalLength = 0;
	}

	// Copy assignment.
	diaQMatrix &operator=(const diaQMatrix &other) {
		if (this == &other) {
			return *this;
		}

		freeStorage();

		matrix_shape = other.matrix_shape;
		shape        = other.shape;
		dIndices     = other.dIndices;
		diagOffsets  = other.diagOffsets;
		totalLength  = other.totalLength;
		realData     = NULL;
		imagData     = NULL;

		if (totalLength > 0) {
			#if NUM_BYTES_ALIGNED <= 0
				realData = (valType *)calloc(totalLength, sizeof(valType));
				imagData = (valType *)calloc(totalLength, sizeof(valType));
			#else
				realData = aligned_alloc_helper(totalLength * sizeof(valType));
				imagData = aligned_alloc_helper(totalLength * sizeof(valType));
				// #pragma omp parallel for
				// for (unsigned int i = 0; i < totalLength; i++) {
				// 	realData[i] = 0.0;
				// 	imagData[i] = 0.0;
				// }
			#endif
			
			#pragma omp parallel for
			for (unsigned int i = 0; i < totalLength; i++) {
				realData[i] = other.realData[i];
				imagData[i] = other.imagData[i];
			}
		}
		return *this;
	}

	// Move assignment.
	diaQMatrix &operator=(diaQMatrix &&other) noexcept {
		if (this == &other) {
			return *this;
		}

		freeStorage();

		matrix_shape = other.matrix_shape;
		shape        = other.shape;
		dIndices     = other.dIndices;
		diagOffsets  = other.diagOffsets;
		totalLength  = other.totalLength;
		realData     = other.realData;
		imagData     = other.imagData;

		other.shape.clear();
		other.dIndices.clear();
		other.diagOffsets.clear();
		other.realData    = NULL;
		other.imagData    = NULL;
		other.totalLength = 0;

		return *this;
	}

	virtual ~diaQMatrix() {
		// #ifdef DEEP_DEBUG
		// 	std::cout << "diaQMatrix destructor called" << std::endl;
		// #endif
		freeStorage();
	}

	// Pointer accessors for SIMD kernels / spGEMM
    inline valType* getDiagonalRealPtr(std::size_t k) const {
        return realData + diagOffsets[k];
    }

    inline valType* getDiagonalImagPtr(std::size_t k) const {
        return imagData + diagOffsets[k];
    }

	// -------------------- Storage helpers --------------------

	void initStorage() {
		if (dIndices.empty()) {
			totalLength = 0;
			realData    = NULL;
			imagData    = NULL;
			diagOffsets.clear();
			return;
		}

		diagOffsets.resize(dIndices.size());

		// We distinguish between "logical" diagonal length (nnz along that diagonal)
		// and the padded storage length we actually allocate for SIMD alignment.
		unsigned int paddedTotal = 0;

		#if VEC_TYPE == -1
			// No SIMD: pack diagonals back-to-back
			for (size_t k = 0; k < dIndices.size(); k++) {
				diagOffsets[k] = paddedTotal;
				unsigned int len = getDiagonalLengthInternal(dIndices[k]);
				paddedTotal += len;
			}
		#else
			// SIMD enabled: pad each diagonal start to VEC_WIDTH alignment
			const unsigned int vecWidth = (VEC_WIDTH > 0) ? (unsigned int)VEC_WIDTH : 1U;
			for (size_t k = 0; k < dIndices.size(); k++) {
				// Align current paddedTotal to vecWidth elements
				if (vecWidth > 1U) {
					unsigned int mod = paddedTotal % vecWidth;
					if (mod != 0U) {
						unsigned int padding = vecWidth - mod;
						paddedTotal += padding;
					}
				}
				diagOffsets[k] = paddedTotal;
				unsigned int len = getDiagonalLengthInternal(dIndices[k]);
				paddedTotal += len;
			}
		#endif

		totalLength = paddedTotal;

		if (totalLength == 0) {
			realData = NULL;
			imagData = NULL;
			return;
		}

		#if NUM_BYTES_ALIGNED <= 0
			realData = (valType *)calloc(totalLength, sizeof(valType));
			imagData = (valType *)calloc(totalLength, sizeof(valType));
		#else
			realData = aligned_alloc_helper(totalLength * sizeof(valType));
			imagData = aligned_alloc_helper(totalLength * sizeof(valType));

			#pragma omp parallel for
			for (unsigned int i = 0; i < totalLength; i++) {
				realData[i] = 0.0;
				imagData[i] = 0.0;
			}
		#endif
	}

	void freeStorage() {
		if (!realData && !imagData) {
			totalLength = 0;
			return;
		}

		#if defined(_MSC_VER)
			if (realData) { _aligned_free(realData); realData = nullptr; }
			if (imagData) { _aligned_free(imagData); imagData = nullptr; }
		#else
			if (realData) { std::free(realData); realData = nullptr; }
			if (imagData) { std::free(imagData); imagData = nullptr; }
		#endif

		totalLength = 0;
	}

	unsigned int num_diags() const {
		return static_cast<unsigned int>(dIndices.size());
	}

	unsigned int getDiagonalLengthInternal(int dIndex) const {
		unsigned int lenRes;
		if (dIndex < 0) {
			lenRes = matrix_shape[0] + dIndex;
		} else if (dIndex > 0) {
			lenRes = matrix_shape[1] - dIndex;
		} else {
			if (matrix_shape[0] > matrix_shape[1]) {
				lenRes = matrix_shape[1];
			} else {
				lenRes = matrix_shape[0];
			}
		}
		if (lenRes > matrix_shape[0]) {
			lenRes = matrix_shape[0];
		} else if (lenRes > matrix_shape[1]) {
			lenRes = matrix_shape[1];
		}
		return lenRes;
	}

	unsigned int getDiagonalLength(int dIndex) const {
		return getDiagonalLengthInternal(dIndex);
	}

	int findDiagonalSlot(int dIndex) const {
		for (size_t k = 0; k < dIndices.size(); k++) {
			if (dIndices[k] == dIndex) {
				return static_cast<int>(k);
			}
		}
		return -1;
	}

	// -------------------- Geometry helpers --------------------

	std::array<unsigned int, 2> getMatrixPosition(unsigned int flat_index) const {
		std::array<unsigned int, 2> mat_pos;
		mat_pos[0] = flat_index / matrix_shape[1];
		mat_pos[1] = flat_index % matrix_shape[1];
		return mat_pos;
	}

	std::array<unsigned int, 2> getMatrixPosition(int diagonal_idx,
	                                              unsigned int diagonal_pos) const {
		std::array<unsigned int, 2> mat_pos;

		if (diagonal_idx >= 0) {
			mat_pos[0] = diagonal_pos;
			mat_pos[1] = static_cast<unsigned int>(diagonal_idx) + diagonal_pos;
		} else {
			mat_pos[0] = static_cast<unsigned int>(-diagonal_idx) + diagonal_pos;
			mat_pos[1] = diagonal_pos;
		}

		if (mat_pos[0] >= matrix_shape[0] || mat_pos[1] >= matrix_shape[1]) {
			std::cerr << "diagonal pos (" << diagonal_idx << "," << diagonal_pos
			          << ") in matrix of size (" << matrix_shape[0] << ","
			          << matrix_shape[1] << ")\n";
			std::cerr << "got pos (" << mat_pos[0] << "," << mat_pos[1] << ")\n";
			throw std::length_error("out of matrix bounds");
		}
		return mat_pos;
	}

	unsigned int getFlatIndex(std::array<unsigned int, 2> matrix_pos) const {
		return matrix_pos[0] * matrix_shape[1] + matrix_pos[1];
	}

	unsigned int getFlatIndex(const std::vector<unsigned int> &ten_pos) const {
		unsigned int total_elements = 1;
		for (size_t i = 0; i < shape.size(); i++) {
			total_elements *= shape[i];
		}
		unsigned int flat_index = 0;
		unsigned int prod       = 1;
		for (size_t i = 0; i < shape.size(); i++) {
			prod       *= shape[i];
			flat_index += (total_elements / prod) * ten_pos[i];
		}
		return flat_index;
	}

	std::array<int, 2> getDiagonalPositionByFlatIndex(unsigned int flatIndex) const {
		unsigned int mat_x = flatIndex / matrix_shape[1];
		flatIndex          = flatIndex - matrix_shape[1] * mat_x;
		unsigned int mat_y = flatIndex % matrix_shape[1];

		std::array<int, 2> res;
		int d_idx = static_cast<int>(mat_y) - static_cast<int>(mat_x);
		res[0]    = d_idx;

		if (d_idx <= 0) {
			res[1] = static_cast<int>(mat_y);
		} else {
			res[1] = static_cast<int>(mat_y) - d_idx;
		}
		return res;
	}

	std::array<int, 2> getDiagonalPosition(std::array<unsigned int, 2> matrix_pos) const {
		unsigned int flatIndex = getFlatIndex(matrix_pos);
		return getDiagonalPosition(flatIndex);
	}

	std::array<int, 2> getDiagonalPosition(unsigned int flatIndex) const {
		int mat_x = static_cast<int>(flatIndex / matrix_shape[1]);
		flatIndex = flatIndex - matrix_shape[1] * static_cast<unsigned int>(mat_x);
		int mat_y = static_cast<int>(flatIndex % matrix_shape[1]);

		std::array<int, 2> res;
		int d_idx = mat_y - mat_x;
		res[0]    = d_idx;
		if (d_idx <= 0) {
			res[1] = mat_y;
		} else {
			res[1] = mat_y - d_idx;
		}
		return res;
	}

	std::array<int, 2> getDiagonalPosition(unsigned int x, unsigned int y) const {
		std::array<int, 2> res;
		int d_idx = static_cast<int>(y) - static_cast<int>(x);
		res[0]    = d_idx;
		if (d_idx <= 0) {
			res[1] = static_cast<int>(y);
		} else {
			res[1] = static_cast<int>(y) - d_idx;
		}
		return res;
	}

	std::array<int, 2> getDiagonalPosition(const std::vector<unsigned int> &ten_pos) const {
		unsigned int flatIndex = getFlatIndex(ten_pos);
		return getDiagonalPosition(flatIndex);
	}

	std::vector<unsigned int> getTensorPosition(int diagonal_idx,
	                                            unsigned int diagonal_pos) const {
		std::array<unsigned int, 2> mat_pos = getMatrixPosition(diagonal_idx, diagonal_pos);
		unsigned int total_elements         = matrix_shape[0] * matrix_shape[1];
		unsigned int ndim                   = static_cast<unsigned int>(shape.size());
		unsigned int flat_index             = mat_pos[0] * matrix_shape[1] + mat_pos[1];

		std::vector<unsigned int> ten_pos(ndim);
		unsigned int prod = 1;
		for (unsigned int i = 0; i < ndim; i++) {
			prod            *= shape[i];
			ten_pos[i]       = (flat_index / (total_elements / prod)) % shape[i];
			flat_index       = flat_index - (total_elements / prod) * ten_pos[i];
		}
		return ten_pos;
	}

	// -------------------- Element access --------------------

	valType getItem_real(unsigned int flat_index) const {
		std::array<unsigned int, 2> mat_pos = getMatrixPosition(flat_index);
		std::array<int, 2>          d_pos   = getDiagonalPosition(mat_pos);
		int dIndex                         = d_pos[0];
		unsigned int pos                   = static_cast<unsigned int>(d_pos[1]);

		int slot = findDiagonalSlot(dIndex);
		if (slot < 0) {
			return 0.0;
		}
		unsigned int offset = diagOffsets[static_cast<size_t>(slot)];
		return realData[offset + pos];
	}

	valType getItem_real(int d_idx, unsigned int d_pos) const {
		int slot = findDiagonalSlot(d_idx);
		if (slot < 0) {
			return 0.0;
		}
		unsigned int offset = diagOffsets[static_cast<size_t>(slot)];
		return realData[offset + d_pos];
	}

	valType getItem_imag(int d_idx, unsigned int d_pos) const {
		int slot = findDiagonalSlot(d_idx);
		if (slot < 0) {
			return 0.0;
		}
		unsigned int offset = diagOffsets[static_cast<size_t>(slot)];
		return imagData[offset + d_pos];
	}

	valType getItem_imag(unsigned int flat_index) const {
		std::array<unsigned int, 2> mat_pos = getMatrixPosition(flat_index);
		std::array<int, 2>          d_pos   = getDiagonalPosition(mat_pos);
		int dIndex                         = d_pos[0];
		unsigned int pos                   = static_cast<unsigned int>(d_pos[1]);

		int slot = findDiagonalSlot(dIndex);
		if (slot < 0) {
			return 0.0;
		}
		unsigned int offset = diagOffsets[static_cast<size_t>(slot)];
		return imagData[offset + pos];
	}

	std::complex<valType> getItem(unsigned int flat_index) const {
		std::array<unsigned int, 2> mat_pos = getMatrixPosition(flat_index);
		std::array<int, 2>          d_pos   = getDiagonalPosition(mat_pos);
		int dIndex                         = d_pos[0];
		unsigned int pos                   = static_cast<unsigned int>(d_pos[1]);

		int slot = findDiagonalSlot(dIndex);
		if (slot < 0) {
			return std::complex<valType>(0.0, 0.0);
		}
		unsigned int offset = diagOffsets[static_cast<size_t>(slot)];
		return std::complex<valType>(realData[offset + pos], imagData[offset + pos]);
	}

	std::complex<valType> getItem(std::array<unsigned int, 2> mat_pos) const {
		std::array<int, 2> d_pos  = getDiagonalPosition(mat_pos);
		int dIndex               = d_pos[0];
		unsigned int pos         = static_cast<unsigned int>(d_pos[1]);

		int slot = findDiagonalSlot(dIndex);
		if (slot < 0) {
			return std::complex<valType>(0.0, 0.0);
		}
		unsigned int offset = diagOffsets[static_cast<size_t>(slot)];
		return std::complex<valType>(realData[offset + pos], imagData[offset + pos]);
	}

	std::complex<valType> getItem(const std::vector<unsigned int> &ten_pos) const {
		std::array<int, 2> d_pos  = getDiagonalPosition(ten_pos);
		int dIndex               = d_pos[0];
		unsigned int pos         = static_cast<unsigned int>(d_pos[1]);

		int slot = findDiagonalSlot(dIndex);
		if (slot < 0) {
			return std::complex<valType>(0.0, 0.0);
		}
		unsigned int offset = diagOffsets[static_cast<size_t>(slot)];
		return std::complex<valType>(realData[offset + pos], imagData[offset + pos]);
	}

	void getTensorItem(const std::vector<unsigned int> &ten_pos,
	                   valType *real_val,
	                   valType *imag_val) const
	{
		std::array<int, 2> d_pos  = getDiagonalPosition(ten_pos);
		int dIndex               = d_pos[0];
		unsigned int pos         = static_cast<unsigned int>(d_pos[1]);

		int slot = findDiagonalSlot(dIndex);
		if (slot < 0) {
			*real_val = 0.0;
			*imag_val = 0.0;
			return;
		}
		unsigned int offset = diagOffsets[static_cast<size_t>(slot)];
		*real_val           = realData[offset + pos];
		*imag_val           = imagData[offset + pos];
	}

	void set(unsigned int flatindex, valType real_val, valType imag_val) {
		std::array<int, 2> d_pos  = getDiagonalPositionByFlatIndex(flatindex);
		int dIndex               = d_pos[0];
		unsigned int pos         = static_cast<unsigned int>(d_pos[1]);

		int slot = findDiagonalSlot(dIndex);
		if (slot < 0) {
			throw std::runtime_error("set: diagonal index not present in dIndices.");
		}
		unsigned int offset      = diagOffsets[static_cast<size_t>(slot)];
		realData[offset + pos]   = real_val;
		imagData[offset + pos]   = imag_val;
	}

	void set(unsigned int x, unsigned int y, valType real_val, valType imag_val) {
		std::array<int, 2> d_pos  = getDiagonalPosition(x, y);
		int dIndex               = d_pos[0];
		unsigned int pos         = static_cast<unsigned int>(d_pos[1]);

		int slot = findDiagonalSlot(dIndex);
		if (slot < 0) {
			throw std::runtime_error("set: diagonal index not present in dIndices.");
		}
		unsigned int offset      = diagOffsets[static_cast<size_t>(slot)];
		realData[offset + pos]   = real_val;
		imagData[offset + pos]   = imag_val;
	}

	void setItem(const std::vector<unsigned int> &ten_pos,
	             valType real_val,
	             valType imag_val)
	{
		std::array<int, 2> d_pos  = getDiagonalPosition(ten_pos);
		int dIndex               = d_pos[0];
		unsigned int pos         = static_cast<unsigned int>(d_pos[1]);

		int slot = findDiagonalSlot(dIndex);
		if (slot < 0) {
			throw std::runtime_error("setItem: diagonal index not present in dIndices.");
		}
		unsigned int offset      = diagOffsets[static_cast<size_t>(slot)];
		realData[offset + pos]   = real_val;
		imagData[offset + pos]   = imag_val;
	}

	// Set real and imaginary data from contiguous std::vector buffers
	void setContiguousData(const std::vector<valType>& real, const std::vector<valType>& imag) {
		// if (real.size() != imag.size()) {
		// 	throw std::invalid_argument("setContiguousData: real/imag size mismatch");
		// }
		// // Compute expected logical length (unpadded)
		// size_t logicalLen = 0;
		// for (size_t k = 0; k < dIndices.size(); ++k) {
		// 	logicalLen += getDiagonalLengthInternal(dIndices[k]);
		// }
		// if (real.size() != logicalLen) {
		// 	throw std::invalid_argument("setContiguousData: input buffer size does not match logical diagonal length");
		// }
		// Copy into padded SIMD layout
		size_t srcOffset = 0;
		const unsigned int vecWidth = (VEC_WIDTH > 0) ? (unsigned int)VEC_WIDTH : 1U;
		for (size_t k = 0; k < dIndices.size(); ++k) {
			unsigned int len = getDiagonalLengthInternal(dIndices[k]);
			unsigned int dstOffset = diagOffsets[k];
			// Copy values
			for (unsigned int i = 0; i < len; ++i) {
				realData[dstOffset + i] = real[srcOffset + i];
				imagData[dstOffset + i] = imag[srcOffset + i];
			}
			// Zero any SIMD padding
			if (vecWidth > 1U) {
				unsigned int mod = len % vecWidth;
				if (mod != 0U) {
					unsigned int padStart = dstOffset + len;
					unsigned int padEnd = dstOffset + len + (vecWidth - mod);
					for (unsigned int p = padStart; p < padEnd && p < totalLength; ++p) {
						realData[p] = 0.0;
						imagData[p] = 0.0;
					}
				}
			}
			srcOffset += len;
		}
	}

	// -------------------- Printing / meta --------------------

	void print() const {
		std::cout << "matrix_shape (" << matrix_shape[0] << "," << matrix_shape[1] << ")" << std::endl;
		std::cout << "tensor_shape (";
		for (size_t i = 0; i < shape.size(); i++) {
			std::cout << shape[i];
			if (i + 1 < shape.size()) {
				std::cout << ",";
			}
		}
		std::cout << ")" << std::endl;

		std::cout << "#Diagonals = " << dIndices.size() << std::endl;
		std::cout << "dIndices: [";
		for (size_t k = 0; k < dIndices.size(); ++k) {
			std::cout << dIndices[k];
			if (k + 1 < dIndices.size()) std::cout << ", ";
		}
		std::cout << "]\n";
		std::cout << "diagOffsets: [";
		for (size_t k = 0; k < diagOffsets.size(); ++k) {
			std::cout << diagOffsets[k];
			if (k + 1 < diagOffsets.size()) std::cout << ", ";
		}
		std::cout << "]\n";
		std::cout << "Total stored elements = " << totalLength << std::endl;

		for (size_t k = 0; k < dIndices.size(); k++) {
			int dIndex       = dIndices[k];
			unsigned int len = getDiagonalLengthInternal(dIndex);
			unsigned int off = diagOffsets[k];
			std::cout << "Diagonal " << dIndex << " (len=" << len << "): ";
			if (len > 0) {
				for (unsigned int j = 0; j < len; ++j) {
					std::cout << "(" << realData[off + j] << "," << imagData[off + j] << ") ";
				}
			}
			std::cout << std::endl;
		}
	}

	void print_meta() const {
		std::cout << "matrix_shape (" << matrix_shape[0] << "," << matrix_shape[1] << ")" << std::endl;
		std::cout << "tensor_shape (";
		for (size_t i = 0; i < shape.size(); i++) {
			std::cout << shape[i];
			if (i + 1 < shape.size()) {
				std::cout << ",";
			}
		}
		std::cout << ")" << std::endl;

		std::cout << "#Diagonals = " << dIndices.size();
		if (dIndices.size() == 1) {
			std::cout << " (index = " << dIndices[0] << ")";
		}
		std::cout << std::endl;
		std::cout << "dIndices: [";
		for (size_t k = 0; k < dIndices.size(); ++k) {
			std::cout << dIndices[k];
			if (k + 1 < dIndices.size()) std::cout << ", ";
		}
		std::cout << "]\n";
		std::cout << "diagOffsets: [";
		for (size_t k = 0; k < diagOffsets.size(); ++k) {
			std::cout << diagOffsets[k];
			if (k + 1 < diagOffsets.size()) std::cout << ", ";
		}
		std::cout << "]\n";
		std::cout << "Total stored elements = " << totalLength << std::endl;

		std::cout << "Sparsity = " << sparsity() << std::endl;
	}

	// -------------------- Basic operations --------------------

	// A + B -> new matrix (same diag layout).
	std::shared_ptr<diaQMatrix> addMatrix(const std::shared_ptr<diaQMatrix> &B) const {
		#ifdef DEBUG
			std::printf("starting addMatrix -- ");
			std::chrono::high_resolution_clock::time_point start =
			std::chrono::high_resolution_clock::now();
		#endif
		if (matrix_shape != B->matrix_shape) {
			throw std::runtime_error("addMatrix: matrix shapes do not match");
		}
		if (dIndices != B->dIndices) {
			throw std::runtime_error("addMatrix: diagonal index sets do not match");
		}

		std::shared_ptr<diaQMatrix> C = std::make_shared<diaQMatrix>(matrix_shape, dIndices, shape);

		#pragma omp parallel for
		for (size_t k = 0; k < dIndices.size(); k++) {
			unsigned int len  = getDiagonalLengthInternal(dIndices[k]);
			unsigned int offA = diagOffsets[k];
			unsigned int offB = B->diagOffsets[k];
			unsigned int offC = C->diagOffsets[k];

			#pragma omp simd
			for (unsigned int j = 0; j < len; j++) {
				C->realData[offC + j] = realData[offA + j] + B->realData[offB + j];
				C->imagData[offC + j] = imagData[offA + j] + B->imagData[offB + j];
			}
		}

		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
			std::cout << "\t\t addMatrix took "
		          << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
		          << " ms" << std::endl;
		#endif
		
		return C;
	}

	// A += B
	void add(const std::shared_ptr<diaQMatrix> &B) {
		// 1. Sanity check: shapes must match
		if (matrix_shape[0] != B->matrix_shape[0] ||
			matrix_shape[1] != B->matrix_shape[1]) {
			throw std::runtime_error("diaQMatrix::add: shape mismatch");
		}

		#ifdef DEBUG
			std::printf("starting add -- ");
			auto start = std::chrono::high_resolution_clock::now();
		#endif

		// 2. Build the union of diagonal indices from A and B
		std::vector<int> union_indices;
		union_indices.reserve(dIndices.size() + B->dIndices.size());

		for (int d : dIndices) {
			union_indices.push_back(d);
		}
		for (int d : B->dIndices) {
			union_indices.push_back(d);
		}

		std::sort(union_indices.begin(), union_indices.end());
		union_indices.erase(std::unique(union_indices.begin(), union_indices.end()),
							union_indices.end());

		// 3. Create a new matrix C that will hold A + B with all diagonals
		diaQMatrix C(matrix_shape, union_indices);  // calls initStorage()

		// 4. For each diagonal d in the union, add A(d) + B(d) into C(d)
		//    (blocked over elements for cache friendliness)
		std::size_t num_diags = union_indices.size();

		#pragma omp parallel for
		for (std::size_t k = 0; k < num_diags; ++k) {
			int d = union_indices[k];

			unsigned int len = C.getDiagonalLengthInternal(d);
			unsigned int offC = C.diagOffsets[k];

			// Find slots in A and B (may be -1 if diagonal is absent)
			int slotA = this->findDiagonalSlot(d);
			int slotB = B->findDiagonalSlot(d);

			valType *aReal = nullptr;
			valType *aImag = nullptr;
			valType *bReal = nullptr;
			valType *bImag = nullptr;

			if (slotA >= 0) {
				unsigned int offA = this->diagOffsets[slotA];
				aReal = this->realData + offA;
				aImag = this->imagData + offA;
			}
			if (slotB >= 0) {
				unsigned int offB = B->diagOffsets[slotB];
				bReal = B->realData + offB;
				bImag = B->imagData + offB;
			}

			// Block over diagonal elements
			for (unsigned int j = 0; j < len; j += BLOCK_SIZE) {
				unsigned int end_j = j + BLOCK_SIZE;
				if (end_j > len) end_j = len;

				for (unsigned int t = j; t < end_j; ++t) {
					valType ar = 0.0, ai = 0.0;
					valType br = 0.0, bi = 0.0;

					if (aReal) { ar = aReal[t]; ai = aImag[t]; }
					if (bReal) { br = bReal[t]; bi = bImag[t]; }

					C.realData[offC + t] = ar + br;
					C.imagData[offC + t] = ai + bi;
				}
			}
		}

		// 5. Move result C back into *this (in-place A = A + B)
		*this = std::move(C);

		#ifdef DEBUG
			auto end = std::chrono::high_resolution_clock::now();
			std::cout << "\t\t add took "
					<< std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
					<< " ms" << std::endl;
		#endif
	}

	// this *= i * imag
	std::shared_ptr<diaQMatrix> scale_by_imag(valType imag) {
		#pragma omp parallel for
		for (size_t k = 0; k < dIndices.size(); k++) {
			unsigned int len = getDiagonalLengthInternal(dIndices[k]);
			unsigned int off = diagOffsets[k];

			// #pragma omp parallel for
			for (unsigned int j = 0; j < len; j++) {
				valType r       = realData[off + j];
				valType im      = imagData[off + j];
				realData[off + j] = -1.0 * im * imag;
				imagData[off + j] = r * imag;
			}
		}
		return shared_from_this();
	}

	// this *= real
	std::shared_ptr<diaQMatrix> scale_by_real(valType real) {
		#pragma omp parallel for
		for (size_t k = 0; k < dIndices.size(); k++) {
			unsigned int len = getDiagonalLengthInternal(dIndices[k]);
			unsigned int off = diagOffsets[k];

			// #pragma omp parallel for
			for (unsigned int j = 0; j < len; j++) {
				realData[off + j] *= real;
				imagData[off + j] *= real;
			}
		}
		return shared_from_this();
	}

	// Divide by integer (blocked).
	void divide_by_int(int x) {
		#pragma omp parallel for
		for (size_t k = 0; k < dIndices.size(); k++) {
			unsigned int len = getDiagonalLengthInternal(dIndices[k]);
			unsigned int off = diagOffsets[k];

			for (unsigned int j = 0; j < len; j += BLOCK_SIZE) {
				unsigned int end_j = j + BLOCK_SIZE;
				if (end_j > len) {
					end_j = len;
				}
				for (unsigned int t = j; t < end_j; t++) {
					realData[off + t] /= x;
					imagData[off + t] /= x;
				}
			}
		}
	}

	// Divide by scalar with underflow guard.
	void divide_by_scalar(valType val) {
		#ifdef DEBUG
			std::printf("starting divide_by_scalar -- val = %f\n", val);
			std::chrono::high_resolution_clock::time_point start =
			std::chrono::high_resolution_clock::now();
		#endif
		if (val == 0.0) {
			throw std::runtime_error("Division by zero error.");
		}
		if (val == 1.0) {
			return;
		}

		valType reciprocal    = 1.0 / val;
		valType min_threshold = std::numeric_limits<valType>::min();

		#pragma omp parallel for
		for (unsigned int idx = 0; idx < totalLength; idx++) {
			valType r  = realData[idx];
			valType im = imagData[idx];
			if (std::abs(r) > min_threshold * val) {
				realData[idx] = r * reciprocal;
			} else {
				realData[idx] = 0.0;
			}
			if (std::abs(im) > min_threshold * val) {
				imagData[idx] = im * reciprocal;
			} else {
				imagData[idx] = 0.0;
			}
		}

		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end = std::chrono::high_resolution_clock::now();
			std::cout << "\t\t divide_by_scalar took "
		          << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
		          << " ms" << std::endl;
		#endif
	}

	std::vector<int> getDiagonals() const {
		return dIndices;
	}

	// this *= (real_scale_factor + i * imag_scale_factor)
	void multiplyScalar(valType real_scale_factor, valType imag_scale_factor) {
		#ifdef DEBUG
			std::printf("starting multiplyScalar -- ");
			std::chrono::high_resolution_clock::time_point start =
					std::chrono::high_resolution_clock::now();
		#endif

		#pragma omp parallel for
		for (unsigned int idx = 0; idx < totalLength; idx++) {
			valType a = realData[idx];
			valType b = imagData[idx];
			realData[idx] = a * real_scale_factor - b * imag_scale_factor;
			imagData[idx] = a * imag_scale_factor + b * real_scale_factor;
		}
		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end =
				std::chrono::high_resolution_clock::now();
			std::cout << "\t\t multiplyScalar took "
						<< std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
						<< " ms" << std::endl;
		#endif
	}

    // this = this + (real_scale_factor + i * imag_scale_factor) * B
    void addMatrixScaled(const std::shared_ptr<diaQMatrix> &B,
                        valType real_scale_factor,
                        valType imag_scale_factor)
    {
        #ifdef DEBUG
            std::printf("starting addMatrixScaled -- ");
            auto start = std::chrono::high_resolution_clock::now();
        #endif

        if (matrix_shape != B->matrix_shape) {
            throw std::runtime_error("addMatrixScaled: matrix shapes do not match");
        }

        // 1. Build union of diagonal indices (old behavior)
        std::vector<int> union_indices;
        union_indices.reserve(dIndices.size() + B->dIndices.size());

        for (int d : dIndices) {
            union_indices.push_back(d);
        }
        for (int d : B->dIndices) {
            union_indices.push_back(d);
        }
        std::sort(union_indices.begin(), union_indices.end());
        union_indices.erase(std::unique(union_indices.begin(), union_indices.end()),
                            union_indices.end());

        // 2. Create a new matrix C with the union of diagonals
        diaQMatrix C(matrix_shape, union_indices); // initStorage()

        std::size_t num_diags = union_indices.size();

        #pragma omp parallel for
        for (std::size_t k = 0; k < num_diags; ++k) {
            int d = union_indices[k];

            unsigned int len  = C.getDiagonalLengthInternal(d);
            unsigned int offC = C.diagOffsets[k];

            // Pointers for A (this)
            int slotA = this->findDiagonalSlot(d);
            valType *aReal = nullptr;
            valType *aImag = nullptr;
            if (slotA >= 0) {
                unsigned int offA = this->diagOffsets[slotA];
                aReal = this->realData + offA;
                aImag = this->imagData + offA;
            }

            // Pointers for B
            int slotB = B->findDiagonalSlot(d);
            valType *bReal = nullptr;
            valType *bImag = nullptr;
            if (slotB >= 0) {
                unsigned int offB = B->diagOffsets[slotB];
                bReal = B->realData + offB;
                bImag = B->imagData + offB;
            }

            // Fill C(d) = A(d) + scale * B(d)
            for (unsigned int j = 0; j < len; ++j) {
                valType ar = 0.0, ai = 0.0;
                valType br = 0.0, bi = 0.0;

                if (aReal) { ar = aReal[j]; ai = aImag[j]; }
                if (bReal) { br = bReal[j]; bi = bImag[j]; }

                C.realData[offC + j] = ar + (real_scale_factor * br - imag_scale_factor * bi);
                C.imagData[offC + j] = ai + (real_scale_factor * bi + imag_scale_factor * br);
            }
        }

        // 3. Move back into *this
        *this = std::move(C);

        #ifdef DEBUG
            auto end = std::chrono::high_resolution_clock::now();
            std::cout << "\t\t addMatrixScaled took "
                    << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
                    << " ms" << std::endl;
        #endif
    }

	// Deep copy as shared_ptr.
	std::shared_ptr<diaQMatrix> copy() const {
		return std::make_shared<diaQMatrix>(*this);
	}

	// C = (i * imag) * this (copy + scale).
	std::shared_ptr<diaQMatrix> copy_and_scale_by_imag(valType imag) const {
		#ifdef DEBUG
			std::printf("starting copy_and_scale_by_imag -- imag = %f\n", imag);
			std::chrono::high_resolution_clock::time_point start =
			std::chrono::high_resolution_clock::now();
		#endif
		if (imag == 0.0) {
			return std::make_shared<diaQMatrix>(matrix_shape, dIndices, shape);
		}

		std::shared_ptr<diaQMatrix> C =
			std::make_shared<diaQMatrix>(matrix_shape, dIndices, shape);

		#pragma omp parallel for
		for (unsigned int idx = 0; idx < totalLength; idx++) {
			valType r   = realData[idx];
			valType im  = imagData[idx];
			C->realData[idx] = -1.0 * im * imag;
			C->imagData[idx] = r * imag;
		}

		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end =
				std::chrono::high_resolution_clock::now();
			std::cout << "copy_and_scale_by_imag took "
		          << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
		          << " ms" << std::endl;
		#endif
		
		return C;
	}

	// A - B (same diag layout).
	std::shared_ptr<diaQMatrix> subtractMatrix(const std::shared_ptr<diaQMatrix> &B) const {
		#ifdef DEBUG
			std::printf("starting subtractMatrix -- ");
			std::chrono::high_resolution_clock::time_point start =
			std::chrono::high_resolution_clock::now();
		#endif
		if (matrix_shape != B->matrix_shape) {
			throw std::runtime_error("subtractMatrix: matrix shapes do not match");
		}
		if (dIndices != B->dIndices) {
			throw std::runtime_error("subtractMatrix: diagonal index sets do not match");
		}

		std::shared_ptr<diaQMatrix> C = std::make_shared<diaQMatrix>(matrix_shape, dIndices, shape);

		#pragma omp parallel for
		for (size_t k = 0; k < dIndices.size(); k++) {
			unsigned int len  = getDiagonalLengthInternal(dIndices[k]);
			unsigned int offA = diagOffsets[k];
			unsigned int offB = B->diagOffsets[k];
			unsigned int offC = C->diagOffsets[k];

			#pragma omp simd
			for (unsigned int j = 0; j < len; j++) {
				C->realData[offC + j] = realData[offA + j] - B->realData[offB + j];
				C->imagData[offC + j] = imagData[offA + j] - B->imagData[offB + j];
			}
		}

		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end =
				std::chrono::high_resolution_clock::now();
			std::cout << "\t\t subtractMatrix took "
		          << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
		          << " ms" << std::endl;
		#endif
		
		return C;
	}

	// Frobenius norm.
	valType norm() const {
		#ifdef DEBUG
			std::printf("starting norm -- ");
			std::chrono::high_resolution_clock::time_point start =
					std::chrono::high_resolution_clock::now();
		#endif
		valType res = 0.0;

		#pragma omp parallel
		{
			valType local = 0.0;
			#pragma omp for
			for (unsigned int idx = 0; idx < totalLength; idx++) {
				valType r  = realData[idx];
				valType im = imagData[idx];
				local += r * r + im * im;
			}
			#pragma omp atomic
			res += local;
		}

		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end =
				std::chrono::high_resolution_clock::now();
			std::cout << "\t\t norm took "
					<< std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
						<< " ms" << std::endl;
		#endif
		return std::sqrt(res);
	}

	// 1-norm estimate (max column sum of absolute values).
	valType estimate_1norm() const {
		#ifdef DEBUG
			std::printf("starting 1-norm -- ");
			std::chrono::high_resolution_clock::time_point start =
					std::chrono::high_resolution_clock::now();
		#endif
		unsigned int nCols      = matrix_shape[1];
		int          max_threads = omp_get_max_threads();

		std::vector<std::vector<valType> > threadLocalSums;
		threadLocalSums.resize(static_cast<size_t>(max_threads));
		for (int t = 0; t < max_threads; t++) {
			threadLocalSums[static_cast<size_t>(t)].resize(nCols, 0.0);
		}

		#pragma omp parallel
		{
			int tid = omp_get_thread_num();
			std::vector<valType> &localSums = threadLocalSums[static_cast<size_t>(tid)];

			#pragma omp for
			for (size_t k = 0; k < dIndices.size(); k++) {
				int          offsetDiag = dIndices[k];
				unsigned int len        = getDiagonalLengthInternal(offsetDiag);
				unsigned int base       = diagOffsets[k];

				for (unsigned int i = 0; i < len; i += BLOCK_SIZE) {
					unsigned int block_end = i + BLOCK_SIZE;
					if (block_end > len) {
						block_end = len;
					}
					for (unsigned int j = i; j < block_end; j++) {
						int col;
						if (offsetDiag >= 0) {
							col = offsetDiag + static_cast<int>(j);
						} else {
							col = static_cast<int>(j);
						}
						if (col >= 0 && col < static_cast<int>(nCols)) {
							valType absval =
								std::abs(realData[base + j]) + std::abs(imagData[base + j]);
							localSums[static_cast<size_t>(col)] += absval;
						}
					}
				}
			}
		}

		std::vector<valType> colSums(nCols, 0.0);
		for (int tid = 0; tid < max_threads; tid++) {
			for (unsigned int j = 0; j < nCols; j++) {
				colSums[j] += threadLocalSums[static_cast<size_t>(tid)][j];
			}
		}

		valType maxColSum = 0.0;
		#pragma omp parallel for reduction(max : maxColSum)
		for (unsigned int j = 0; j < nCols; j++) {
			if (colSums[j] > maxColSum) {
				maxColSum = colSums[j];
			}
		}

		#ifdef DEBUG
			std::chrono::high_resolution_clock::time_point end =
				std::chrono::high_resolution_clock::now();
			std::cout << "\t\t 1-norm took "
					<< std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
					<< " ms" << std::endl;
		#endif
		return maxColSum;
	}

	// Sparsity: 1 - (nnz / (rows*cols)).
	valType sparsity() const {
		unsigned int nnz = 0;

		#pragma omp parallel for reduction(+ : nnz)
		for (unsigned int idx = 0; idx < totalLength; idx++) {
			if (realData[idx] != 0.0 || imagData[idx] != 0.0) {
				nnz++;
			}
		}

		valType z_val    = static_cast<valType>(nnz);
		valType size_val = static_cast<valType>(matrix_shape[0]) *
		                   static_cast<valType>(matrix_shape[1]);
		return 1.0 - z_val / size_val;
	}

	bool isEqualTo(const std::shared_ptr<diaQMatrix> &B, valType tol = 1e-6) const {
		if (matrix_shape != B->matrix_shape) {
			return false;
		}
		if (dIndices != B->dIndices) {
			return false;
		}
		if (totalLength != B->totalLength) {
			return false;
		}
		for (unsigned int i = 0; i < totalLength; i++) {
			if (std::abs(realData[i] - B->realData[i]) > tol ||
			    std::abs(imagData[i] - B->imagData[i]) > tol) {
				return false;
			}
		}
		return true;
	}

	// Flatten to dense row-major matrix (complex).
	std::complex<valType> *flatten() const {
		unsigned int nRows = matrix_shape[0];
		unsigned int nCols = matrix_shape[1];
		std::complex<valType> *res =
			new std::complex<valType>[static_cast<size_t>(nRows) * nCols];

		#pragma omp parallel for
		for (unsigned int idx = 0; idx < nRows * nCols; idx++) {
			res[idx] = std::complex<valType>(0.0, 0.0);
		}

		for (size_t k = 0; k < dIndices.size(); k++) {
			int          dIndex = dIndices[k];
			unsigned int len    = getDiagonalLengthInternal(dIndex);
			unsigned int off    = diagOffsets[k];

			#pragma omp parallel for
			for (unsigned int j = 0; j < len; j++) {
				std::array<unsigned int, 2> mat_pos = getMatrixPosition(dIndex, j);
				unsigned int fi = mat_pos[0] * matrix_shape[1] + mat_pos[1];
				res[fi] = std::complex<valType>(realData[off + j], imagData[off + j]);
			}
		}
		return res;
	}

	// -------------------- Flat diag API (for GPU / Python bindings) --------------------

	// Set from flat diag representation (n_diags, indices, cum_lengths, real/imag).
	void setDiagFlatData(unsigned int n_diags,
						const int *diagonal_indices,
						const unsigned int *cum_diagonal_lengths,
						const valType *real_data,
						const valType *imag_data)
	{
		dIndices.clear();
		diagOffsets.clear();
		freeStorage();

		if (n_diags == 0) {
			totalLength = 0;
			return;
		}

		// 1. Copy diagonal indices
		dIndices.assign(diagonal_indices, diagonal_indices + n_diags);

		// 2. Build padded storage using initStorage()
		initStorage();  // uses current matrix_shape and dIndices, sets diagOffsets + totalLength + realData/imagData

		// 3. Copy from the flat input into padded layout
		unsigned int src_prev = 0;
		for (unsigned int k = 0; k < n_diags; ++k) {
			unsigned int src_len = cum_diagonal_lengths[k] - src_prev;
			unsigned int dst_off = diagOffsets[k];

			// Sanity: src_len must equal logical length
			unsigned int logical_len = getDiagonalLengthInternal(dIndices[k]);
			// You can assert or clamp here if needed

			#pragma omp parallel for
			for (unsigned int j = 0; j < src_len; ++j) {
				realData[dst_off + j] = real_data[src_prev + j];
				imagData[dst_off + j] = imag_data[src_prev + j];
			}

			src_prev = cum_diagonal_lengths[k];
		}
	}

	// Export to flat diag representation.
	void getDiagFlatData(unsigned int *n_diags,
	                     int **diagonal_indices,
	                     unsigned int **cum_diagonal_lengths,
	                     unsigned int *num_elements,
	                     valType **real_data,
	                     valType **imag_data) const
	{
		*n_diags      = static_cast<unsigned int>(dIndices.size());
		*num_elements = totalLength;

		if (*n_diags == 0 || totalLength == 0) {
			*diagonal_indices     = NULL;
			*cum_diagonal_lengths = NULL;
			*real_data            = NULL;
			*imag_data            = NULL;
			return;
		}

		#if NUM_BYTES_ALIGNED <= 0
			*diagonal_indices     = (int *)calloc(*n_diags, sizeof(int));
			*cum_diagonal_lengths = (unsigned int *)calloc(*n_diags, sizeof(unsigned int));
		#else
			*diagonal_indices     = (int *)aligned_alloc_helper((*n_diags) * sizeof(int));
			*cum_diagonal_lengths = (unsigned int *)aligned_alloc_helper((*n_diags) * sizeof(unsigned int));
		#endif

		unsigned int running = 0;
		for (unsigned int k = 0; k < *n_diags; k++) {
			(*diagonal_indices)[k] = dIndices[k];
			running               += getDiagonalLengthInternal(dIndices[k]);
			(*cum_diagonal_lengths)[k] = running;
		}

		#if NUM_BYTES_ALIGNED <= 0
			*real_data = (valType *)calloc(totalLength, sizeof(valType));
			*imag_data = (valType *)calloc(totalLength, sizeof(valType));
		#else
			*real_data = aligned_alloc_helper(totalLength * sizeof(valType));
			*imag_data = aligned_alloc_helper(totalLength * sizeof(valType));
			#pragma omp parallel for
			for (unsigned int i = 0; i < totalLength; i++) {
				(*real_data)[i] = 0.0;
				(*imag_data)[i] = 0.0;
			}
		#endif

		#pragma omp parallel for
		for (unsigned int i = 0; i < totalLength; i++) {
			(*real_data)[i] = realData[i];
			(*imag_data)[i] = imagData[i];
		}
	}

	// -- prune all zero diags -- //
	// Remove all-zero diagonals and compact storage
	void pruneMatrix() {

		#ifdef DEEP_DEBUG
			std::printf("starting pruneMatrix -- ");
			std::chrono::high_resolution_clock::time_point start =
			std::chrono::high_resolution_clock::now();
		#endif

		// 1. Figure out which diagonals survive
		std::vector<int> new_dIndices;
		new_dIndices.reserve(dIndices.size());

		for (size_t k = 0; k < dIndices.size(); ++k) {
			int dIndex = dIndices[k];
			unsigned int len = getDiagonalLengthInternal(dIndex);
			unsigned int off = diagOffsets[k];

			bool all_zero = true;
			for (unsigned int j = 0; j < len; ++j) {
				if (realData[off + j] != 0.0 || imagData[off + j] != 0.0) {
					all_zero = false;
					break;
				}
			}
			if (!all_zero) {
				new_dIndices.push_back(dIndex);
			}
		}

		// 2. Build a new diaQMatrix with *padded* aligned layout
		diaQMatrix pruned(matrix_shape, new_dIndices, shape); // calls initStorage()

		// 3. Copy the surviving diagonals into the new storage
		for (size_t k_new = 0; k_new < new_dIndices.size(); ++k_new) {
			int dIndex = new_dIndices[k_new];

			// old slot
			int old_slot = findDiagonalSlot(dIndex);
			if (old_slot < 0) continue; // shouldn't happen

			unsigned int len = getDiagonalLengthInternal(dIndex);
			unsigned int old_off = diagOffsets[old_slot];
			unsigned int new_off = pruned.diagOffsets[k_new];

			#pragma omp parallel for
			for (unsigned int j = 0; j < len; ++j) {
				pruned.realData[new_off + j] = realData[old_off + j];
				pruned.imagData[new_off + j] = imagData[old_off + j];
			}
		}

		// 4. Move pruned back into *this
		*this = std::move(pruned);

		#ifdef DEEP_DEBUG
			std::chrono::high_resolution_clock::time_point end =
				std::chrono::high_resolution_clock::now();
			std::cout << "\t\t pruneMatrix took "
		          << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000.0
		          << " ms" << std::endl;
		#endif
	}

	// -------------------- Other API (implemented in .cpp) --------------------

	std::shared_ptr<vector> multiplyVector(std::shared_ptr<vector> v); // spMV in matrixKernels.cpp

	std::shared_ptr<diaQMatrix> reshape(std::vector<unsigned int> new_tensor_shape);
	void matrix_reshape(std::array<unsigned int, 2> new_matrix_shape);
	std::shared_ptr<diaQMatrix> transpose(std::vector<unsigned int> new_order);
	std::shared_ptr<diaQMatrix> transpose();
	std::shared_ptr<diaQMatrix> inverse();

	std::shared_ptr<denseMatrix> convertToDenseMatrix(std::array<unsigned int, 2> new_shape);
	std::shared_ptr<denseMatrix> convertToDenseMatrix();
};

} // namespace diaq

#endif // DIAQ_DIAQMATRIX_HPP