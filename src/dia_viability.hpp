#ifndef DIAQ_DIA_VIABILITY_HPP
#define DIAQ_DIA_VIABILITY_HPP

// Is the diagonal (DIA) format worth it for a matrix about to be multiplied by a dense matrix with n_right columns
// (spmm_dia_device)? Two budgets, both must hold:
//
// 1. Storage: the stored diagonals (n_diags x n_rows values, zeros included) take at most 90% of the bytes CSR would
//    (nnz values and column indices plus row pointers). For complex double with many diagonals that means about 3/4
//    of the stored diagonal entries nonzero; for double, about 0.55. (At exactly CSR's bytes, DIA was as slow as CSR.)
// 2. Diagonals: the DIA x dense kernel loops over every diagonal for every row, so the number of diagonals is
//    capped at max(16, n_rows / 32); with 32 or more right-hand columns, where cuSPARSE's CSR x dense is strong, at 8.
//
// The budgets come from a sweep on an A100 40 GB (complex double; 4096 and 65536 rows; 1-1024 diagonals as a band or
// scattered; 10-100% filled; 1, 16, 128 right-hand columns; scope_analysis/scripts/dia_budget_sweep.py): of the 360
// cases, every one passing both budgets ran faster in DIA than in CSR (51 cases, 0.26-0.93x the CSR time); cases
// failing them ran up to 10x slower in DIA (many diagonals at low fill, or many diagonals against a wide dense operand) or would store more
// than CSR.

#include <algorithm>
#include <cstdint>
#include <string>

namespace diaq {

struct DiaViability {
    bool viable = false;
    bool storage_ok = false;
    bool diagonals_ok = false;
    double dia_bytes = 0.0;
    double csr_bytes = 0.0;
    double density = 0.0;            // nnz / stored entries
    std::int64_t diagonal_budget = 0;
    std::string reason;
};

constexpr double DIA_MAX_BYTES_OVER_CSR = 0.9;          // DIA at most 90% of CSR's bytes
constexpr std::int64_t DIA_MIN_DIAGONAL_BUDGET = 16;   // always allowed, whatever the size
constexpr std::int64_t DIA_ROWS_PER_DIAGONAL = 32;     // budget max(16, n_rows / 32)
constexpr std::int64_t DIA_WIDE_RIGHT = 32;            // n_right at or above this: wide dense operand
constexpr std::int64_t DIA_WIDE_DIAGONAL_BUDGET = 8;   // budget against a wide dense operand

inline DiaViability dia_viability(std::int64_t n_rows, std::int64_t n_cols, std::int64_t n_diags, std::int64_t nnz,
                                  std::int64_t n_right, int itemsize = 16, int index_bytes = 8) {
    (void)n_cols;
    DiaViability v;
    const double stored = static_cast<double>(n_diags) * static_cast<double>(n_rows);
    v.dia_bytes = stored * itemsize + static_cast<double>(n_diags) * 8.0;
    v.csr_bytes = static_cast<double>(nnz) * (itemsize + index_bytes) + static_cast<double>(n_rows + 1) * index_bytes;
    v.density = stored > 0 ? static_cast<double>(nnz) / stored : 0.0;
    v.storage_ok = n_diags > 0 && v.dia_bytes <= DIA_MAX_BYTES_OVER_CSR * v.csr_bytes;
    v.diagonal_budget = std::max(DIA_MIN_DIAGONAL_BUDGET, n_rows / DIA_ROWS_PER_DIAGONAL);
    if (n_right >= DIA_WIDE_RIGHT) v.diagonal_budget = std::min(v.diagonal_budget, DIA_WIDE_DIAGONAL_BUDGET);
    v.diagonals_ok = n_diags <= v.diagonal_budget;
    v.viable = v.storage_ok && v.diagonals_ok;
    if (!v.storage_ok) {
        v.reason = "storage: DIA would take more than 90% of CSR's bytes (diagonals too sparsely filled)";
    } else if (!v.diagonals_ok) {
        v.reason = "diagonals: " + std::to_string(n_diags) + " over the budget of " + std::to_string(v.diagonal_budget);
    } else {
        v.reason = "viable";
    }
    return v;
}

}  // namespace diaq

#endif
