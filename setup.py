from pybind11.setup_helpers import Pybind11Extension, build_ext
from setuptools import setup

__version__ = "0.0.1"

# The main interface is through Pybind11Extension.
# * You can add cxx_std=11/14/17, and then build_ext can be removed.
# * You can set include_pybind11=false to add the include directory yourself,
#   say from a submodule.
#
# Note:
#   Sort input source files if you glob sources to ensure bit-for-bit
#   reproducible builds (https://github.com/pybind/python_example/pull/53)

import os
compile_args = []
link_args = []
if os.name == 'posix':  # Check if the OS is Linux or macOS
    linux = True if os.uname().sysname == 'Linux' else False
    mac = not linux
    if linux:
        compile_args = ["-std=c++11", "-Wall", "-Wextra", "-O3", "-lstdc++", "-fopenmp", "-mavx2"]
        link_args = ['-lgomp', '-lpthread']
    elif mac:
        compile_args = ["-std=c++11", "-Wall", "-Wextra", "-O3", "-lstdc++"]
        link_args = ['-lpthread']
else:
    # Handle other operating systems if needed
    print("Not Linux or MAC, what are you doing dude?")
    pass

ext_modules = [
    Pybind11Extension(
        "diaq",
        ["include/pythonWrappers.cpp"],
        define_macros = [('VERSION_INFO', __version__)],
        extra_compile_args = compile_args,
        extra_link_args = link_args,
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
    # Currently, build_ext only provides an optional "highest supported C++
    # level" feature, but in the future it may provide more features.
    cmdclass={"build_ext": build_ext},
    zip_safe=False,
    python_requires=">=3.8",
)
