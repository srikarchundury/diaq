from pybind11.setup_helpers import Pybind11Extension, build_ext
from setuptools import setup
from glob import glob
import os

__version__ = "0.0.1"
cuda_enabled = os.getenv("CUDA_ENABLED") == "1"  # Check if the CUDA_ENABLED environment variable is set to '1'

sources = ["include/pythonWrappers.cpp"]
d_macros = [('VERSION_INFO', __version__)]
compile_args = [
    # "-std=c++17", # C++17 standard, change to C++11 if needed, the code is compatible with C++11
    "-std=c++11",
    "-Wall",
    "-Wextra",
    "-funroll-loops",
    "-O3",
    "-lstdc++",
    "-fopenmp",
    "-mavx2",
    "-msse2",
    "-mavx512f", 
    "-fPIC"
]
link_args = ['-lgomp', '-lpthread']
cpu_lib_dirs = [os.path.abspath("./cpu_build/lib")]
libs = ["diaq"]

if cuda_enabled:
    print("Building with GPU support")
    cuda_path = "/usr/local/cuda"
    cuda_include = os.path.join(cuda_path, "include")
    cuda_lib = os.path.join(cuda_path, "lib64")
    cuda_compile_args = ["-std=c++11", "-O3", "-I" + cuda_include]
    cuda_link_args = ["-L" + cuda_lib, "-lcudart"]
    nvcc_args = ['--gpu-architecture=sm_75', '-O3']  # Adjust the architecture based on your GPU
    compile_args.extend(cuda_compile_args)
    link_args.extend(cuda_link_args)
    d_macros.append(('CUDA_ENABLED', 1))
    gpu_lib_dirs = [os.path.abspath("./gpu_build/lib")]

print("library_dirs = ", gpu_lib_dirs if cuda_enabled else cpu_lib_dirs)

ext_modules = [
    Pybind11Extension(
        "diaq",
        sources=sources,
        define_macros=d_macros,
        extra_compile_args=compile_args,
        extra_link_args=link_args,
        language='c++',
        # nvcc_args=nvcc_args if cuda_enabled else None,
        library_dirs=gpu_lib_dirs if cuda_enabled else cpu_lib_dirs,
        runtime_library_dirs=gpu_lib_dirs if cuda_enabled else cpu_lib_dirs,
        libraries=libs,
    ),
]

setup(
    name="diaq",
    version=__version__,
    description="A WIP numerical library tailored for tensor contractions in quantum simulations",
    author="Srikar Chundury",
    author_email="schundu3@ncsu.edu",
    url="https://github.ncsu.edu/qsparse/diaq/",
    long_description="",
    ext_modules=ext_modules,
    cmdclass={"build_ext": build_ext},
    extras_require={"test": "pytest"},
    zip_safe=False,
    python_requires=">=3.8",
)
