#define Py_LIMITED_API 0x030600F0
#include "Python.h"
#include "stdio_filebuf.h"

struct PyIStream : public std::istream {
    PyIStream(stdio_filebuf<char> *buffer) : std::istream(buffer), buffer(buffer) {}

    static PyIStream *make_from(PyObject *pyfile);

    ~PyIStream()
    {
        if (buffer) {
            delete buffer;
        }
    }

private:
    stdio_filebuf<char> *buffer = nullptr;
};