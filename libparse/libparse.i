/* File: libparse.i */
%module libparse
%include <std_string.i>
%include <std_vectora.i>
%include <std_shared_ptr.i>

%{
#define SWIG_FILE_WITH_INIT
#define Py_LIMITED_API 0x030600F0
#include <iostream>
#include <memory>
#include "libparse.h"
#include "py_iostream.h"
%}


%shared_ptr(Yosys::LibertyAst)
%immutable Yosys::LibertyParser::f;
%template(VectorLibertyAstSP) std::vector< std::shared_ptr<Yosys::LibertyAst> >;
%template(VectorStr) std::vector< std::string >;

%typemap(in) std::istream& {
    try {
        $1 = new PyIStream($input);
    } catch (std::runtime_error &e) {
        PyErr_SetString(PyExc_TypeError, e.what());
    }
}

%typemap(freearg) std::istream& {
   delete $1;
}

%include "libparse.h"
