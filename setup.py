#!/usr/bin/env python3
import os
import subprocess
from setuptools import setup, find_packages, Extension

module_name = "libparse"
__dir__ = os.path.dirname(os.path.abspath(__file__))

subprocess.check_call(["make", "patch"], cwd=__dir__)

ext = Extension(
    name="_libparse",
    swig_opts=["-c++"],
    sources=[
        "libparse/libparse.cpp",
        "libparse/libparse.i",
    ],
    include_dirs=[
        "libparse",
    ],
    extra_compile_args=["-std=c++17", "-DFILTERLIB"],
)

setup(
    name=module_name,
    packages=find_packages(),
    version="0.1.0",
    description="Python wrapper around Yosys' libparse module",
    long_description=open("Readme.md").read(),
    long_description_content_type="text/markdown",
    author="Efabless Corporation and Contributors",
    author_email="donn@efabless.com",
    install_requires=["wheel"],
    classifiers=[
        "License :: OSI Approved :: Apache Software License",
        "Programming Language :: Python :: 3",
        "Intended Audience :: Developers",
        "Operating System :: POSIX :: Linux",
        "Operating System :: MacOS :: MacOS X",
    ],
    python_requires=">3.6",
    ext_modules=[ext],
)
