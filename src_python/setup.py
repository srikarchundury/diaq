from setuptools import setup

setup(
    name='qSparse',
    version='0.0.1',    
    description='A numerical library for quantum contractions',
    url='https://github.ncsu.edu/tnqs/sparse-tnqs/tree/srikar-dev/src_python',
    author='Srikar Chundury',
    author_email='schundu3@ncsu.edu',
    license='BSD 2-clause',
    packages=['qSparse'],
    install_requires=['numpy',],

    classifiers=[
        'Programming Language :: Python :: 3.8',
    ],
)