# -*- coding: utf-8 -*-

import setuptools

if __name__ == "__main__":
    setuptools.setup(
        name='qsparse',
        version='0.0.1',
        description='A numerical library for quantum contractions',
        author='Srikar Chundury',
        author_email='schundu3@ncsu.edu',
        url='https://github.ncsu.edu/tnqs/sparse-tnqs/tree/srikar-dev/src_python',
        license='BSD 2-clause',
        packages=setuptools.find_packages(),
        python_requires='>=3.8',
        install_requires=[
            'numpy>=1.7',
        ],
        extras_require={
            'tests': [
                'pytest',
                'pytest-cov',
            ],
        },

        tests_require=[
            'pytest',
            'pytest-cov',
        ],

        classifiers=[
            'Programming Language :: Python :: 3.8',
            'Programming Language :: Python :: 3.9',
        ],
        zip_safe=True,
    )
