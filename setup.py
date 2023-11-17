from pybind11.setup_helpers import Pybind11Extension, build_ext
from setuptools import setup
from glob import glob

__version__ = "0.0.1"

# Determine CUDA paths (adjust these based on your CUDA installation)
cuda_path = "/usr/local/cuda"
cuda_include = os.path.join(cuda_path, "include")
cuda_lib = os.path.join(cuda_path, "lib64")

# CUDA-specific compile and link arguments
cuda_compile_args = ["-std=c++11", "-O3", "-I" + cuda_include]
cuda_link_args = ["-L" + cuda_lib, "-lcudart"]  # Adjust libraries as needed

# Your existing compile and link arguments
compile_args = ["-std=c++11", "-Wall", "-Wextra", "-O3", "-lstdc++", "-fopenmp", "-mavx2"]
link_args = ['-lgomp', '-lpthread']

# Merge CUDA and existing compile/link arguments
compile_args += cuda_compile_args
link_args += cuda_link_args

# Gather CUDA files
cuda_sources = glob("cuda/*.cu")  # Update the path as per your CUDA file location

if len(cuda_sources) > 0:
    # This syntax is specific to this build system
    print("CUDA files found, building with GPU support")
    sources = cuda_sources + ["include/pythonWrappers.cpp"]
else:
    sources = ["include/pythonWrappers.cpp"]

ext_modules = [
    Pybind11Extension(
        "diaq",
        sources=sources,
        define_macros=[('VERSION_INFO', __version__)],
        extra_compile_args=compile_args,
        extra_link_args=link_args,
    ),
]

setup(
    name='diaq',
    version='0.0.1',
    description='A WIP numerical library tailored for quantum contractions',
    author='Srikar Chundury',
    author_email='schundu3@ncsu.edu',
    url='https://github.ncsu.edu/tnqs/diaq/',
    long_description="",
    ext_modules=ext_modules,
    extras_require={"test": "pytest"},
    cmdclass={"build_ext": build_ext},
    zip_safe=False,
    python_requires=">=3.8",
)
