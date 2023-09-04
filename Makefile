
CXXFLAGS += -g -std=c++17 -I$(shell python3 -c "import sysconfig; print(sysconfig.get_path('include'))")


all: _libparse.so

_libparse.so: libparse.cc libparse_wrap.cxx libparse.h py_iostream.h
	$(CXX) -fPIC -c $(CXXFLAGS) -DFILTERLIB libparse.cc 
	$(CXX) -fPIC -c $(CXXFLAGS) -DFILTERLIB libparse_wrap.cxx 
	$(CXX) -shared libparse.o libparse_wrap.o -o $@

libparse.py libparse_wrap.cxx: libparse.i libparse.h
	swig -c++ -python $<

libparse.h: yosys/passes/techmap/libparse.h libparse.h.patch
	cp $< $@
	patch libparse.h libparse.h.patch

libparse.cc: yosys/passes/techmap/libparse.cc
	cp $< $@
	patch libparse.cc libparse.cc.patch

.PHONY: regen-patches
regen-patches:
	diff yosys/passes/techmap/libparse.h libparse.h > libparse.h.patch || true
	diff yosys/passes/techmap/libparse.cc libparse.cc > libparse.cc.patch || true

.PHONY: clean
clean:
	rm -f libparse*.cc libparse*.cxx libparse.h libparse.py
	rm -f *.so *.o *.dylib *.dll