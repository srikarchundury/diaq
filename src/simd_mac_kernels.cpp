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

template<>
void run_mac<double>(
    unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset,
    double *real_vals_a, double *imag_vals_a,
    double *real_vals_b, double *imag_vals_b,
    double *real_vals_final, double *imag_vals_final, bool overwrite
) {
    #ifdef DEEP_DEBUG
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    #endif

    // Find first aligned SIMD index
    unsigned int simd_start = start;
    for (; simd_start + VEC_WIDTH <= end; simd_start++) {
        if ((simd_start % VEC_WIDTH == 0) &&
            ((simd_start + a_offset) % VEC_WIDTH == 0) &&
            ((simd_start + b_offset) % VEC_WIDTH == 0)) {
            break;
        }
    }
    if (simd_start + VEC_WIDTH > end)
        simd_start = end; // no SIMD possible
    unsigned int simd_end = end - ((end - simd_start) % VEC_WIDTH);

    // --- Prologue (unaligned/scalar) ---
    #pragma omp parallel for
    for (unsigned int idx = start; idx < simd_start; ++idx) {
        unsigned int idx_a = idx + a_offset;
        unsigned int idx_b = idx + b_offset;

        double real_a = real_vals_a[idx_a];
        double imag_a = imag_vals_a[idx_a];
        double real_b = real_vals_b[idx_b];
        double imag_b = imag_vals_b[idx_b];

        if (overwrite) {
            real_vals_final[idx] = (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] = (real_a * imag_b) + (imag_a * real_b);
        } else {
            real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
        }
    }

    // --- SIMD Main Loop with BLOCKED vector chunks ---
    #pragma omp parallel for schedule(static)
    for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
        unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);

        for (unsigned int i = block_start; i + VEC_WIDTH <= block_end; i += VEC_WIDTH) {
            unsigned int idx_a = i + a_offset;
            unsigned int idx_b = i + b_offset;

            // // Prefetch data
            // DIAQ_PREFETCH_T0_AT(&real_vals_a[idx_a], PREFETCH_DIST);
            // DIAQ_PREFETCH_T0_AT(&imag_vals_a[idx_a], PREFETCH_DIST);
            // DIAQ_PREFETCH_T0_AT(&real_vals_b[idx_b], PREFETCH_DIST);
            // DIAQ_PREFETCH_T0_AT(&imag_vals_b[idx_b], PREFETCH_DIST);

            // Load vectors
            float64x2_t real_a = vld1q_f64(&real_vals_a[idx_a]);
            float64x2_t imag_a = vld1q_f64(&imag_vals_a[idx_a]);
            float64x2_t real_b = vld1q_f64(&real_vals_b[idx_b]);
            float64x2_t imag_b = vld1q_f64(&imag_vals_b[idx_b]);

            // Compute
            float64x2_t real_part = vsubq_f64(vmulq_f64(real_a, real_b), vmulq_f64(imag_a, imag_b));
            float64x2_t imag_part = vaddq_f64(vmulq_f64(real_a, imag_b), vmulq_f64(imag_a, real_b));

            // Store results
            if (overwrite) {
                vst1q_f64(&real_vals_final[i], real_part);
                vst1q_f64(&imag_vals_final[i], imag_part);
            } else {
                float64x2_t final_real = vld1q_f64(&real_vals_final[i]);
                float64x2_t final_imag = vld1q_f64(&imag_vals_final[i]);
                final_real = vaddq_f64(final_real, real_part);
                final_imag = vaddq_f64(final_imag, imag_part);
                vst1q_f64(&real_vals_final[i], final_real);
                vst1q_f64(&imag_vals_final[i], final_imag);
            }
        }

        // -- Epilogue ---
        #pragma omp parallel for
        for (unsigned int idx = simd_end; idx < end; ++idx) {
            unsigned int idx_a = idx + a_offset;
            unsigned int idx_b = idx + b_offset;

            double real_a = real_vals_a[idx_a];
            double imag_a = imag_vals_a[idx_a];
            double real_b = real_vals_b[idx_b];
            double imag_b = imag_vals_b[idx_b];

            if (overwrite) {
                real_vals_final[idx] = (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] = (real_a * imag_b) + (imag_a * real_b);
            } else {
                real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
                imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
            }

        }

        #ifdef DEEP_DEBUG
            std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
            long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count();
            std::cout << "DEBUG: SIMD MAC double kernel took " << duration << " microseconds." << std::endl;
        #endif
    }
}

float32x4_t mac_load_partial_float(int n, const float *p) {
    float temp[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    for (int i = 0; i < n; ++i) {
        temp[i] = p[i];
    }
    return vld1q_f32(temp);
}
void mac_store_partial_float(int n, float *loc, float32x4_t vec) {
    float temp[4];
    vst1q_f32(temp, vec);
    for (int i = 0; i < n; ++i) {
        loc[i] = temp[i];
    }
}
template<>
void run_mac<float>(
    unsigned int start, unsigned int end, unsigned int a_offset, unsigned int b_offset,
    float *real_vals_a, float *imag_vals_a,
    float *real_vals_b, float *imag_vals_b,
    float *real_vals_final, float *imag_vals_final, bool overwrite
) {
    #ifdef DEEP_DEBUG
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    #endif

    // Find first aligned SIMD index
    unsigned int simd_start = start;
    for (; simd_start + VEC_WIDTH <= end; simd_start++) {
        if ((simd_start % VEC_WIDTH == 0) && 
            ((simd_start + a_offset) % VEC_WIDTH == 0) &&
            ((simd_start + b_offset) % VEC_WIDTH == 0)) {
            break;
        }
    }
    if (simd_start + VEC_WIDTH > end)
        simd_start = end; // no SIMD possible

    unsigned int simd_end = end - ((end - simd_start) % VEC_WIDTH);

    // --- Prologue (unaligned/scalar) ---
    #pragma omp parallel for
    for (unsigned int idx = start; idx < simd_start; ++idx) {
        unsigned int idx_a = idx + a_offset;
        unsigned int idx_b = idx + b_offset;

        float real_a = real_vals_a[idx_a];
        float imag_a = imag_vals_a[idx_a];
        float real_b = real_vals_b[idx_b];
        float imag_b = imag_vals_b[idx_b];

        if (overwrite) {
            real_vals_final[idx] = (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] = (real_a * imag_b) + (imag_a * real_b);
        } else {
            real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
        }
    }

    // --- SIMD Main Loop with BLOCKED vector chunks ---
    #pragma omp parallel for schedule(static)
    for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
        unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);
        for (unsigned int i = block_start; i + VEC_WIDTH <= block_end; i += VEC_WIDTH) {
            unsigned int idx_a = i + a_offset;
            unsigned int idx_b = i + b_offset;

            // // Prefetch data
            // DIAQ_PREFETCH_T0_AT(&real_vals_a[idx_a], PREFETCH_DIST);
            // DIAQ_PREFETCH_T0_AT(&imag_vals_a[idx_a], PREFETCH_DIST);
            // DIAQ_PREFETCH_T0_AT(&real_vals_b[idx_b], PREFETCH_DIST);
            // DIAQ_PREFETCH_T0_AT(&imag_vals_b[idx_b], PREFETCH_DIST);

            // Load vectors
            float32x4_t real_a = vld1q_f32(&real_vals_a[idx_a]);
            float32x4_t imag_a = vld1q_f32(&imag_vals_a[idx_a]);
            float32x4_t real_b = vld1q_f32(&real_vals_b[idx_b]);
            float32x4_t imag_b = vld1q_f32(&imag_vals_b[idx_b]);

            // Compute
            float32x4_t real_part = vsubq_f32(vmulq_f32(real_a, real_b), vmulq_f32(imag_a, imag_b));
            float32x4_t imag_part = vaddq_f32(vmulq_f32(real_a, imag_b), vmulq_f32(imag_a, real_b));

            // Store results
            if (overwrite) {
                vst1q_f32(&real_vals_final[i], real_part);
                vst1q_f32(&imag_vals_final[i], imag_part);
            } else {
                float32x4_t final_real = vld1q_f32(&real_vals_final[i]);
                float32x4_t final_imag = vld1q_f32(&imag_vals_final[i]);
                final_real = vaddq_f32(final_real, real_part);
                final_imag = vaddq_f32(final_imag, imag_part);
                vst1q_f32(&real_vals_final[i], final_real);
                vst1q_f32(&imag_vals_final[i], final_imag);
            }
        }
    }

    // --- Epilogue (unaligned/scalar) ---
    #pragma omp parallel for
    for (unsigned int idx = simd_end; idx < end; ++idx) {
        unsigned int idx_a = idx + a_offset;
        unsigned int idx_b = idx + b_offset;

        float real_a = real_vals_a[idx_a];
        float imag_a = imag_vals_a[idx_a];
        float real_b = real_vals_b[idx_b];
        float imag_b = imag_vals_b[idx_b];

        if (overwrite) {
            real_vals_final[idx] = (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] = (real_a * imag_b) + (imag_a * real_b);
        } else {
            real_vals_final[idx] += (real_a * real_b) - (imag_a * imag_b);
            imag_vals_final[idx] += (real_a * imag_b) + (imag_a * real_b);
        }
    }
    #ifdef DEEP_DEBUG
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count();
        std::cout << "DEBUG: SIMD MAC float kernel took " << duration << " microseconds." << std::endl;
    #endif
}

// SPMV for MAC using doubles
template<>
void run_spmv_mac_1<double>(
    unsigned int simd_start, unsigned int simd_end,
    double *x_real_values, double *x_imag_values,
    double *real_vals, double *imag_vals,
    double *y_real_values, double *y_imag_values,
    int dIndex, unsigned int dLength) {
    #ifdef DEEP_DEBUG
        std::cout << "Starting run_spmv_mac_1 - Aligned SIMD (w/ Prologue/Epilogue) --" << std::endl;
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    #endif

    // --- Prologue ---
    #pragma omp parallel for
    for (unsigned int i = 0; i < simd_start; ++i) {
        unsigned int y_index = i - dIndex;

        double a_r = real_vals[i];
        double a_i = imag_vals[i];
        double x_r = x_real_values[i];
        double x_i = x_imag_values[i];

        y_real_values[y_index] += (a_r * x_r) - (a_i * x_i);
        y_imag_values[y_index] += (a_r * x_i) + (a_i * x_r);
    }

    // --- SIMD Main Loop with Blocking ---
    #pragma omp parallel for schedule(static)
    for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
        unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);

        for( unsigned int i = block_start; i + VEC_WIDTH <= block_end; i += VEC_WIDTH) {
            unsigned int y_index = i - dIndex;

            // Load vectors
            float64x2_t a_r = vld1q_f64(&real_vals[i]);
            float64x2_t a_i = vld1q_f64(&imag_vals[i]);
            float64x2_t x_r = vld1q_f64(&x_real_values[i]);
            float64x2_t x_i = vld1q_f64(&x_imag_values[i]);
            float64x2_t y_r = vld1q_f64(&y_real_values[y_index]);
            float64x2_t y_i = vld1q_f64(&y_imag_values[y_index]);

            // Perform MAC operations
            y_r = vmlaq_f64(y_r, a_r, x_r);
            y_r = vmlsq_f64(y_r, a_i, x_i);
            y_i = vmlaq_f64(y_i, a_r, x_i);
            y_i = vmlaq_f64(y_i, a_i, x_r);

            // Store results
            vst1q_f64(&y_real_values[y_index], y_r);
            vst1q_f64(&y_imag_values[y_index], y_i);
        }
    }

    // --- Epilogue ---
    #pragma omp parallel for
    for (unsigned int i = simd_end; i < dLength; ++i) {
        unsigned int y_index = i - dIndex;

        double a_r = real_vals[i];
        double a_i = imag_vals[i];
        double x_r = x_real_values[i];
        double x_i = x_imag_values[i];

        y_real_values[y_index] += (a_r * x_r) - (a_i * x_i);
        y_imag_values[y_index] += (a_r * x_i) + (a_i * x_r);
    }

    #ifdef DEEP_DEBUG
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count();
        std::cout << "DEBUG: SIMD SPMV MAC double kernel took " << duration << " microseconds." << std::endl;
    #endif
}

template<>
void run_spmv_mac_2<double>(
    unsigned int simd_start, unsigned int simd_end,
    double *x_real_values, double *x_imag_values,
    double *real_vals, double *imag_vals,
    double *y_real_values, double *y_imag_values,
    int dIndex, unsigned int dLength) {

    #ifdef DEEP_DEBUG
        std::cout << "Starting run_spmv_mac_2 - Aligned SIMD (w/ Prologue/Epilogue) --" << std::endl;
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    #endif

    // --- Prologue ---
    #pragma omp parallel for
    for (unsigned int i = 0; i < simd_start; ++i) {
        unsigned int x_index = i + dIndex;

        double a_r = real_vals[i];
        double a_i = imag_vals[i];
        double x_r = x_real_values[x_index];
        double x_i = x_imag_values[x_index];

        y_real_values[i] += (a_r * x_r) - (a_i * x_i);
        y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
    }

    // --- SIMD Main Loop with Blocking ---
    #pragma omp parallel for schedule(static)
    for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
        unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);

        for( unsigned int i = block_start; i + VEC_WIDTH <= block_end; i += VEC_WIDTH) {
            unsigned int x_index = i + dIndex;

            // Load vectors
            float64x2_t a_r = vld1q_f64(&real_vals[i]);
            float64x2_t a_i = vld1q_f64(&imag_vals[i]);
            float64x2_t x_r = vld1q_f64(&x_real_values[x_index]);
            float64x2_t x_i = vld1q_f64(&x_imag_values[x_index]);
            float64x2_t y_r = vld1q_f64(&y_real_values[i]);
            float64x2_t y_i = vld1q_f64(&y_imag_values[i]);

            // Perform MAC operations
            y_r = vmlaq_f64(y_r, a_r, x_r);
            y_r = vmlsq_f64(y_r, a_i, x_i);
            y_i = vmlaq_f64(y_i, a_r, x_i);
            y_i = vmlaq_f64(y_i, a_i, x_r);

            // Store results
            vst1q_f64(&y_real_values[i], y_r);
            vst1q_f64(&y_imag_values[i], y_i);
        }
    }

    // --- Epilogue ---
    #pragma omp parallel for
    for (unsigned int i = simd_end; i < dLength; ++i) {
        unsigned int x_index = i + dIndex;
        double a_r = real_vals[i];
        double a_i = imag_vals[i];
        double x_r = x_real_values[x_index];
        double x_i = x_imag_values[x_index];

        y_real_values[i] += (a_r * x_r) - (a_i * x_i);
        y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
    }

    #ifdef DEEP_DEBUG
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count();
        std::cout << "DEBUG: SIMD SPMV MAC double kernel took " << duration << " microseconds." << std::endl;
    #endif
}

template<>
void run_spmv_mac_0<double>(
    unsigned int simd_start, unsigned int simd_end,
    double *x_real_values, double *x_imag_values,
    double *real_vals, double *imag_vals,
    double *y_real_values, double *y_imag_values,
    int dIndex, unsigned int dLength) {

    #ifdef DEEP_DEBUG
        std::cout << "Starting run_spmv_mac_0 - SIMD aligned version --" << std::endl;
        std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
    #endif

    // --- Prologue ---
    #pragma omp parallel for
    for (unsigned int i = 0; i < simd_start; ++i) {
        double a_r = real_vals[i];
        double a_i = imag_vals[i];
        double x_r = x_real_values[i];
        double x_i = x_imag_values[i];

        y_real_values[i] += (a_r * x_r) - (a_i * x_i);
        y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
    }

    // --- SIMD aligned loop with blocking ---
    #pragma omp parallel for schedule(static)
    for (unsigned int block_start = simd_start; block_start < simd_end; block_start += BLOCK_SIZE) {
        unsigned int block_end = std::min(block_start + BLOCK_SIZE, simd_end);

        for (unsigned int i = block_start; i + VEC_WIDTH <= block_end; i += VEC_WIDTH) {
            // Load vectors
            float64x2_t a_r = vld1q_f64(&real_vals[i]);
            float64x2_t a_i = vld1q_f64(&imag_vals[i]);
            float64x2_t x_r = vld1q_f64(&x_real_values[i]);
            float64x2_t x_i = vld1q_f64(&x_imag_values[i]);
            float64x2_t y_r = vld1q_f64(&y_real_values[i]);
            float64x2_t y_i = vld1q_f64(&y_imag_values[i]);

            // Perform MAC operations
            y_r = vmlaq_f64(y_r, a_r, x_r);
            y_r = vmlsq_f64(y_r, a_i, x_i);
            y_i = vmlaq_f64(y_i, a_r, x_i);
            y_i = vmlaq_f64(y_i, a_i, x_r);

            // Store results
            vst1q_f64(&y_real_values[i], y_r);
            vst1q_f64(&y_imag_values[i], y_i);
        }
    }

    // --- Epilogue ---
    #pragma omp parallel for
    for (unsigned int i = simd_end; i < dLength; ++i) {
        double a_r = real_vals[i];
        double a_i = imag_vals[i];
        double x_r = x_real_values[i];
        double x_i = x_imag_values[i];
        y_real_values[i] += (a_r * x_r) - (a_i * x_i);
        y_imag_values[i] += (a_r * x_i) + (a_i * x_r);
    }

    #ifdef DEEP_DEBUG
        std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();
        long long duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count();
        std::cout << "DEBUG: SIMD SPMV MAC double kernel took " << duration << " microseconds." << std::endl;
    #endif
}

} // namespace diaq