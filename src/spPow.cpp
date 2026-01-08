#include "matrixKernels.hpp"

namespace diaq {

static inline bool is_power_of_two_u64(uint64_t x) {
	return x && ((x & (x - 1)) == 0);
}

static inline int ctz_u64(uint64_t x) {
#if defined(__GNUC__) || defined(__clang__)
	return __builtin_ctzll(x);
#else
	int c = 0;
	while ((x & 1ULL) == 0ULL) { x >>= 1ULL; ++c; }
	return c;
#endif
}

std::shared_ptr<diaQMatrix> pow(std::shared_ptr<diaQMatrix> A, int n) {
	if (n < 0) {
		throw std::runtime_error("pow: negative exponent not supported");
	}

	uint64_t e = static_cast<uint64_t>(n);

	// Fast paths
	if (e == 0) return std::make_shared<identityMatrix>(A->matrix_shape[0]);
	if (e == 1) return A->copy(); // protect input: return a distinct object

	// IMPORTANT: protect input once
	std::shared_ptr<diaQMatrix> base = A->copy();

	// If exponent is exactly 2^s => s squarings only (best for scale-and-square)
	if (is_power_of_two_u64(e)) {
		int s = ctz_u64(e); // e = 2^s
		for (int i = 0; i < s; ++i) {
			base = product(base, base);
		}
		return base;
	}

	// General exponentiation by squaring
	std::shared_ptr<diaQMatrix> result = std::make_shared<identityMatrix>(A->matrix_shape[0]);

	while (e > 0) {
		if (e & 1ULL) {
			result = product(result, base);
		}
		e >>= 1ULL;
		if (e) {
			base = product(base, base);
		}
	}

	return result;
}

} // namespace diaq
