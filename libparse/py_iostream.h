#define Py_LIMITED_API 0x030600F0
#include "Python.h"
#include "stdio_filebuf.h"

typedef std::pair<stdio_filebuf<char> *, FILE *> buffer_pair;
// buffer_pair from_pyobject(PyObject *pyfile);

// struct PyIStream : public std::istream {
//     PyIStream(PyObject *pyfile) : buffers(from_pyobject(pyfile)), std::istream(std::get<0>(buffers)) {}

//     ~PyIStream()
//     {
//         FILE *f;
//         stdio_filebuf<char> *buf;

//         if ((f = std::get<1>(buffers))) {
//             fclose(f);
//         }
//         if ((buf = std::get<0>(buffers))) {
//             delete buf;
//         }
//     }

// private:
//     buffer_pair buffers;
// };

struct PyIStream : public std::istream {
    PyIStream(PyObject *pyfile)
    {
        if (pyfile == Py_None) {
            throw std::runtime_error("None is not a valid input stream");
        }
        auto fileno = PyObject_GetAttrString(pyfile, "fileno");
        if (!fileno) {
            throw std::runtime_error("Passed object has no fileno() method");
        }
        fd = PyObject_AsFileDescriptor(pyfile);
        if (fd == -1) {
            throw std::runtime_error("Failed to get file descriptor");
        }

        f = fdopen(fd, "r");
        if (!f) {
            throw std::runtime_error("Failed to open input stream");
        }

        buf = new stdio_filebuf<char>(f);

        init(buf);
    }

    ~PyIStream()
    {
        if (f) {
            fclose(f);
        }
        if (buf) {
            free(buf);
        }
    }

private:
    int fd = -1;
    FILE *f = nullptr;
    stdio_filebuf<char> *buf = nullptr;
};