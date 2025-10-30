#include "simd_mac_kernels.hpp"

namespace diaq {
	float64x2_t mac_load_partial_double(int n, const double *p) {
        double temp[2] = {0.0, 0.0};
        for (int i = 0; i < n; ++i) {
            temp[i] = p[i];
        }
        return vld1q_f64(temp);
    }
    void mac_store_partial_double(int n, double *loc, float64x2_t vec) {
        double temp[2];
        vst1q_f64(temp, vec);
        for (int i = 0; i < n; ++i) {
            loc[i] = temp[i];
        }
    }
} // namespace diaq