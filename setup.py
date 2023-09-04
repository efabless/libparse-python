#!/usr/bin/env python3
import os
import subprocess
from setuptools import setup, find_packages, Extension
from setuptools.command.build_py import build_py

module_name = "libparse"
__dir__ = os.path.dirname(__file__)

ext = Extension(
    name='_libparse',
    swig_opts=['-c++'],
    sources=[
        'libparse/libparse.cpp',
        'libparse/libparse.i',
    ],
    include_dirs=[
        'libparse',
    ],
    extra_compile_args=[
        '-std=c++17',
        "-DFILTERLIB"
    ]
)

class BuildPy(build_py):
    def run(self):
        subprocess.check_call([
            "make",
            "swig_out"
        ])
        self.run_command('build_ext')
        super(build_py, self).run()

setup(
    name=module_name,
    packages=find_packages(),
    version="0.1.0",
    description="Python wrapper around Yosys' libparse module",
    long_description=open("Readme.md").read(),
    long_description_content_type="text/markdown",
    author="Efabless Corporation and Contributors",
    author_email="donn@efabless.com",
    install_requires=[],
    classifiers=[
        "License :: OSI Approved :: Apache Software License",
        "Programming Language :: Python :: 3",
        "Intended Audience :: Developers",
        "Operating System :: POSIX :: Linux",
        "Operating System :: MacOS :: MacOS X",
    ],
    python_requires=">3.6",
    ext_modules=[ext],
    cmdclass={
        'build_py': BuildPy,
    },
)