.PHONY:all
all:cmain cppmain

include $(if $(srcdir),$(srcdir)/)make/platform.make

# build all src/foo/*.c as a static library
NAME:=foo
SRCS:=$(wildcard $(SRCDIR)/foo/*.c)
include $(MAKEDIR)/lib.make
# TODO : figure something better
LIBFOO:=$(LIB)
PIC_LIBFOO:=$(PIC_LIB)

# build all src/bar/*.c as a dynamic library
NAME:=bar
TARGET:=libbar
SRCS:=$(wildcard $(SRCDIR)/bar/*.c)
include $(MAKEDIR)/dll.make
# libbar depends on libfoo (PIC version)
$(DLL):LDLIBS:=$(PIC_LIBFOO)
$(DLL):$(PIC_LIBFOO)
LIBBAR:=$(LIB)

# C executable with target cmain
NAME:=cmain
TARGET:=cmain
SRCS:=$(SRCDIR)/main.c
include $(MAKEDIR)/bin.make
# CFLAGS propagate to libfoo
$(BIN):CFLAGS:=-std=c99
# cmain depends on libfoo (no PIC)
$(BIN):LDLIBS+=$(LIBFOO)
$(BIN):$(LIBFOO)

# C++ executable with target cppmain
NAME:=cppmain
TARGET:=cppmain
SRCS:=$(SRCDIR)/main.cpp
include $(MAKEDIR)/bin.make
# CXXFLAGS propagate to libbar but have no effect
$(BIN):CXXFLAGS:=-std=c++11
# cppmain depends on libbar
$(BIN):LDLIBS:=$(LIBBAR)
$(BIN):$(LIBBAR)

# install rules

install:install-cmain install-cppmain

install-cppmain:install-libbar
