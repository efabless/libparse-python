#include "py_iostream.h"

buffer_pair from_pyobject(PyObject *pyfile)
{
    if (pyfile == Py_None) {
        throw std::runtime_error("None is not a valid input stream");
    }
    auto fileno = PyObject_GetAttrString(pyfile, "fileno");
    if (fileno == Py_None) {
        throw std::runtime_error("Passed object has no fileno() method");
    }

    auto fd = PyObject_AsFileDescriptor(pyfile);
    if (fd == -1) {
        throw std::runtime_error("Failed to get file descriptor");
    }

    auto f = fdopen(fd, "r");
    if (!f) {
        throw std::runtime_error("Failed to open input stream");
    }

    return buffer_pair(new stdio_filebuf<char>(f), f);
}