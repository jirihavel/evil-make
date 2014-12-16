##################################################
# Initialize the build platform
##################################################
# makedir is path from Makefile to platform.make
makedir:=../..
# - config.make may overwrite anything set before
include $(if $(srcdir),$(srcdir)/)$(makedir)/platform.make
# now we can use "include $(MAKEDIR)/..."

# We want default targets for all libraries and executables
# executables : installdirs-name, install-name
# TODO : implement for libraries
WANT_TARGET:=1

# We want linker MAP files
WANT_MAP:=1

# We want DEF files for DLLs on Windows
WANT_DEF:=1
#TODO

# Set some global flags
# - can be overwritten per target, but the propagation depends on the initial rule so it is not reliable
CFLAGS:=-std=c99
CXXFLAGS:=-std=c++11

# Project configurations can be differenciated using
# CONFIG - long configuration name
# - /obj/<config>/foo.c.o
# SUFFIX - short configuration suffix
# - foo<suffix>.exe, libfoo<suffix>.a, ...
# This allows to switch between configuration without complete recompilation

##################################################
# Project pieces
##################################################
# All configuration variables here are expected to
#  be nonrecursive and can be safely overwritten further in the makefile
# NAME uniquely identifies a piece of the project
# - will be used to construct filenames and makefile rules
# SRCS is the list of source files
# - will be compiled into object files according to their extensions
# FLAGS, LIBS are parameters for compiler and linker
# - flags are currently common for all source types
# DEPS are names of previous pieces that are dependencies of this one
# - circular dependencies are not allowed

# build all src/foo/*.c as a static library
# libfoo.a
NAME:=foo
SRCS:=$(wildcard $(SRCDIR)/foo/*.c)
include $(MAKEDIR)/lib.make

# build all src/bar/*.c as a dynamic library
# lib/libbar.so, bin/[cyg]bar.dll + lib/libbar.a
NAME:=bar
# libbar needs target for install rule
TARGET:=libbar
# libbar depends on libfoo (PIC version)
DEPS:=foo.pic
SRCS:=$(wildcard $(SRCDIR)/bar/*.c)
include $(MAKEDIR)/dll.make

# C executable with target main
# bin/main, bin/main.exe
NAME:=main
# main depends on libfoo (normal lib)
DEPS:=foo.lib
SRCS:=$(SRCDIR)/main.c
include $(MAKEDIR)/bin.make

# C++ executable with target mainpp
NAME:=mainpp
# cppmain depends on libbar
DEPS:=bar.dll
SRCS:=$(SRCDIR)/main.cpp
include $(MAKEDIR)/bin.make

##################################################
# Basic rules
##################################################
# - all, installdirs, install

DEPS:=main mainpp
# all, installdirs and install for DEPS
include $(MAKEDIR)/rules.make
