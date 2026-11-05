#ifndef __DIAQ_HPP__
#define __DIAQ_HPP__

#define DIAQ_VERSION "0.0.1"

// config
#include "../src/config.hpp"

// operations
#include "../src/conversions.hpp"
#include "../src/kernels.hpp" // this encapsulates matrixKernels and vectorKernels
#include "../src/norms.hpp"

// items
#include "../src/denseMatrix.hpp"
// #include "../src/diagonal.hpp" # not needed anymore! diagonals are now just vectors inside diaQMatrix
#include "../src/diaQMatrix.hpp"
#include "../src/specialMatrices.hpp"
#include "../src/vector.hpp"

// helpers
#include "../src/helpers.hpp"
#include "../src/dia_viability.hpp"
#ifdef CUDA_ENABLED
#include "../src/spMM_device_gpu.hpp"
#include "../src/deviceMatrix_gpu.hpp"
#endif

#endif