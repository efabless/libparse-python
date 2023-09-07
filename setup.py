#!/usr/bin/env python3
import os
import sys
import platform
import subprocess
from setuptools import setup, Extension
from setuptools.command.build_py import build_py as _build_py

module_name = "libparse"
__dir__ = os.path.dirname(os.path.abspath(__file__))

version = subprocess.check_output(
    [
        sys.executable,
        os.path.join(
            os.path.abspath(__dir__),
            module_name,
            "__version__.py",
        ),
    ],
    encoding="utf8",
)

compiler_opts = ["-std=c++11", "-DFILTERLIB"]
if platform.system() == "Windows":
    compiler_opts = ["/DFILTERLIB"]

ext = Extension(
    name="_libparse",
    swig_opts=["-c++"],
    sources=[
        "libparse/libparse.cpp",
        "libparse/py_iostream.cpp",
        "libparse/libparse.i",
    ],
    include_dirs=[
        "libparse",
    ],
    extra_compile_args=compiler_opts,
)


class build_py(_build_py):
    def run(self) -> None:
        subprocess.check_call(["make", "patch"], cwd=__dir__)
        self.run_command("build_ext")
        return super().run()


setup(
    name=module_name,
    packages=["libparse"],
    version=version,
    description="Python wrapper around Yosys' libparse module",
    long_description=open(os.path.join(__dir__, "Readme.md")).read(),
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
    cmdclass={
        "build_py": build_py,
    },
)
