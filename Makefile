.PHONY:all
all:cmain cppmain

include make/platform.make

NAME:=foo
#TARGET:=libfoo
SRCS:=$(wildcard $(SRCDIR)/foo/*.c)
include make/lib.make

NAME:=cmain
TARGET:=cmain
SRCS:=$(SRCDIR)/main.c
include make/bin.make
$(BIN):CFLAGS:=-std=c99
$(BIN):LDLIBS+=$(LIB)
$(BIN):$(LIB)

NAME:=cppmain
TARGET:=cppmain
SRCS:=$(SRCDIR)/main.cpp
include make/bin.make
$(BIN):CXXFLAGS:=-std=c++11

