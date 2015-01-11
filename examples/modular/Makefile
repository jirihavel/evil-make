################################################################################
# Initialize the build platform
################################################################################
# - copy&paste this to any new Makefile, modify <makedir>
# - <makedir> is path from Makefile to platform.make
makedir:=../..
# autodetect <srcdir> as the path to this Makefile
ifndef srcdir
 srcdir:=$(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
endif
# include the platform header
# - it includes config.make and may overwrite anything set before
include $(if $(srcdir),$(srcdir)/)$(if $(makedir),$(makedir)/)platform.make
# - now we can use "include $(MAKEDIR)/..."
# - platform initialized, end of copy&paste

################################################################################
# Project configuration
################################################################################

# We want default targets for all libraries and executables
# - executables : install[dirs]-<name>
# - libraries   : install[dirs]-lib<name>[-dev]
WANT_TARGET:=1

# We want linker MAP files
# - bin/<name>[{.exe,.dll}].map, lib/lib<name>.so.<major>.<minor>.map
WANT_MAP:=1

# We want DEF files for DLLs on Windows
WANT_DEF:=1
#TODO

# Set some global flags
# - can be overwritten per target, but the propagation depends on the initial rule so it is not reliable
CFLAGS:=-std=c99
CXXFLAGS:=-std=c++11

# Project configurations can be differenciated using :
# CONFIG - long configuration name
# - obj/<config>/foo.c.o
# SUFFIX - short configuration suffix
# - bin/foo<suffix>.exe, lib/libfoo<suffix>.a, ...
# This allows to switch between multiple configurations without complete recompilation

################################################################################
# Project pieces
################################################################################
# All configuration variables here are expected to
#  be nonrecursive and can be safely overwritten further in the makefile
# NAME uniquely identifies a piece of the project
# - will be used to construct filenames and makefile rules
# - dll and lib pieces prepend it with lib, so they do not conflict with bin
# DEPS are names of previous pieces that are dependencies of this one
# - circular dependencies are not allowed
# SRCS is the list of source files
# - will be compiled into object files according to their extensions
# FLAGS, LIBS are parameters for compiler and linker
# - currently common for all source types

# build all src/foo/*.c as a static library lib/libfoo.a
# - targets libfoo, installdirs-libfoo-dev, install-libfoo-dev
NAME:=foo
SRCS:=$(wildcard $(SRCDIR)/foo/*.c)
include $(MAKEDIR)/lib.make

# build src/foo.c as executable that uses libfoo
# - targets foo, installdirs-foo, install-foo
DEPS:=libfoo
SRCS:=$(SRCDIR)/foo.c
include $(MAKEDIR)/bin.make

# build all src/bar/*.c as a dynamic library
# - lib/libbar.so, bin/[cyg]bar.dll + lib/libbar.a
# - targets libbar, install[dirs]-libbar[-dev]
# - dev versions install libbar.a on windows
# - depends on PIC version of libfoo
NAME:=bar
DEPS:=libfoo.pic
SRCS:=$(wildcard $(SRCDIR)/bar/*.c)
include $(MAKEDIR)/dll.make

# build src/bar.c as executable that uses libbar
# - depends on libbar and nonPIC libfoo
DEPS:=libbar libfoo
SRCS:=$(SRCDIR)/bar.c
include $(MAKEDIR)/bin.make

# C executable with target main
# - bin/main[.exe]
# - depends on libfoo (normal lib)
NAME:=main
DEPS:=libfoo
SRCS:=$(SRCDIR)/main.c
include $(MAKEDIR)/bin.make

# C++ executable with target mainpp
# - depends on libbar
NAME:=mainpp
DEPS:=libbar
SRCS:=$(SRCDIR)/main.cpp
include $(MAKEDIR)/bin.make

##################################################
# Basic rules
##################################################
# - all, install[dirs][-dev]
# - works even if WANT_TARGET=
# - can be used multiple times
DEPS:=foo bar
include $(MAKEDIR)/rules.make
DEPS:=main mainpp
include $(MAKEDIR)/rules.make
