
SRC_DIR = libparse
SWIG_IN = $(SRC_DIR)/libparse.i
SWIG_OUT = $(SRC_DIR)/libparse_wrap.cpp $(SRC_DIR)/libparse.py 
SOURCES = $(SRC_DIR)/libparse_wrap.cpp $(SRC_DIR)/libparse.cpp
OBJECTS = $(patsubst %.cpp,%.o,$(SOURCES))
HEADERS = $(SRC_DIR)/libparse.h $(SRC_DIR)/py_iostream.h

CXXFLAGS += -g -std=c++11 -I$(shell python3 -c "import sysconfig; print(sysconfig.get_path('include'))")


all: _libparse.so
patch: $(SRC_DIR)/libparse.cpp $(SRC_DIR)/libparse.h
swig_out: $(SWIG_OUT)

_libparse.so: $(OBJECTS)
	$(CXX) -shared $^ -o $@

$(OBJECTS): %.o : %.cpp $(HEADERS)
	$(CXX) -fPIC -o $@ -c $(CXXFLAGS) -DFILTERLIB $<

$(SWIG_OUT): $(SWIG_IN) $(HEADERS)
	swig -c++ -o $(SRC_DIR)/libparse_wrap.cpp -oh $(SRC_DIR)/libparse.h -python $<

$(SRC_DIR)/libparse.h: yosys/passes/techmap/libparse.h $(SRC_DIR)/libparse.h.patch
	cp $< $@
	patch $@ $(SRC_DIR)/libparse.h.patch

$(SRC_DIR)/libparse.cpp: yosys/passes/techmap/libparse.cc $(SRC_DIR)/libparse.cpp.patch
	cp $< $@
	patch $@ $(SRC_DIR)/libparse.cpp.patch

.PHONY: regen-patches
regen-patches:
	diff yosys/passes/techmap/libparse.h $(SRC_DIR)/libparse.h > $(SRC_DIR)/libparse.h.patch || true
	diff yosys/passes/techmap/libparse.cc $(SRC_DIR)/libparse.cpp > $(SRC_DIR)/libparse.cpp.patch || true

.PHONY: clean
clean:
	rm -f $(SRC_DIR)/*.cpp $(SRC_DIR)/*.o $(SRC_DIR)/libparse.py $(SRC_DIR)/libparse.h  
	rm -f *.so *.o *.dylib *.dll
	rm -rf build/
	rm -rf libparse.egg-info/
	rm -rf dist/