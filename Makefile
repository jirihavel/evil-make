.PHONY:all
all:cmain cppmain

include $(if $(srcdir),$(srcdir)/)make/platform.make

NAME:=foo
SRCS:=$(wildcard $(SRCDIR)/foo/*.c)
include $(MAKEDIR)/lib.make
LIBFOO:=$(LIB)

NAME:=bar
TARGET:=libbar
SRCS:=$(wildcard $(SRCDIR)/bar/*.c)
include $(MAKEDIR)/dll.make

NAME:=cmain
TARGET:=cmain
SRCS:=$(SRCDIR)/main.c
include $(MAKEDIR)/bin.make
$(BIN):CFLAGS:=-std=c99
$(BIN):LDLIBS+=-lfoo$(SUFFIX)
$(BIN):$(LIBFOO)

NAME:=cppmain
TARGET:=cppmain
SRCS:=$(SRCDIR)/main.cpp
include $(MAKEDIR)/bin.make
$(BIN):CXXFLAGS:=-std=c++11
