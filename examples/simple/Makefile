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

# We want default targets for all libraries and executables
# executables : installdirs-name, install-name
WANT_TARGET:=1

# We want linker MAP files
WANT_MAP:=1

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
# SRCS is the list of source files
# - will be compiled into object files according to their extensions
# FLAGS, LIBS are parameters for compiler and linker
# - flags are currently common for all source types

# Create implicit rules for everything in $(SRCDIR)
include $(MAKEDIR)/simple.make

all:$(BINDIR)/a.exe $(BINDIR)/b.exe $(BINDIR)/c.exe $(BINDIR)/d.exe

##################################################
# Basic rules
##################################################
# - all, installdirs, install

#DEPS:=main mainpp
# all, installdirs and install for DEPS
#include $(MAKEDIR)/rules.make
