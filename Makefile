.PHONY:all
all:cmain cppmain

include $(if $(srcdir),$(srcdir)/)make/platform.make

NAME:=foo
#TARGET:=libfoo
SRCS:=$(wildcard $(SRCDIR)/foo/*.c)
include $(MAKEDIR)/lib.make

NAME:=cmain
TARGET:=cmain
SRCS:=$(SRCDIR)/main.c
include $(MAKEDIR)/bin.make
$(BIN):CFLAGS:=-std=c99
$(BIN):LDLIBS+=$(LIB)
$(BIN):$(LIB)

NAME:=cppmain
TARGET:=cppmain
SRCS:=$(SRCDIR)/main.cpp
include $(MAKEDIR)/bin.make
$(BIN):CXXFLAGS:=-std=c++11

