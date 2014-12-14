##################################################
# Behavior config
##################################################

#VERBOSE - if empty, commands are not printed
ifndef VERBOSE
 VERBOSE:=
endif

##################################################
# Platform facets
##################################################

#SYSTEM - { windows, linux, osx }
#
# Filesystem commands, binary names, ...
#
# sets SYSTEM_KIND - { windows, unix }

#COMPILER - { gcc }
#
# Object and library names, compilation commands, ...

#ENVIRONMENT - { default, mingw32 }
#
# implies certain SYSTEM+COMPILER, but modifies some aspects
# TODO : setting ENVIRONMENT overrides SYSTEM detection

#HARDWARE - { generic, native }
#
# Adds hardware specific parameters to CompileFlags and LinkFlags
#
# sets HAVE_SSE3
# TODO : other hardware capabilities

##################################################
# Standard directories
##################################################

# these may be overridden from the command line

ifndef prefix
 prefix:=/usr/local
endif

ifndef exec_prefix
 exec_prefix:=$(prefix)
endif

# executable files go here
ifndef bindir
 bindir:=$(exec_prefix)/bin
endif

ifndef libexecdir
 libexecdir:=$(exec_prefix)/libexec
endif

ifndef datarootdir
 datarootdir:=$(prefix)/share
endif

ifndef datadir
 datadir:=$(datarootdir)
endif

ifndef sysconfdir
 sysconfdir:=$(prefix)/etc
endif

#sharedstatedir:=$(prefix)/com
#localstatedir:=$(prefix)/var
#runstatedir:=$(prefix)/run

ifndef includedir
 includedir:=$(prefix)/include
endif

# linkable libraries (.lib, .a, .so) go here
ifndef libdir
 libdir:=$(exec_prefix)/lib
endif

# dynamic libraries (.dll, .so) go here
#dlldir:={bindir,libdir} (system)

# source tree is here
ifndef srcdir
 srcdir:=
endif

# we are building here, working dir on default
ifndef builddir
 builddir:=
endif

##################################################
# Source directories
##################################################

INCDIR:=$(if $(srcdir),$(srcdir)/)include
SRCDIR:=$(if $(srcdir),$(srcdir)/)src
ETCDIR:=$(if $(srcdir),$(srcdir)/)etc

##################################################
# Build directories
##################################################

# precompiled headers
#PCHDIR:=$(if $(builddir),$(builddir)/)pch
# object files and other build stuff
OBJDIR:=$(if $(builddir),$(builddir)/)obj

LIBDIR:=$(if $(builddir),$(builddir)/)lib
#DLLDIR:={LIBDIR, BINDIR} (system)
BINDIR:=$(if $(builddir),$(builddir)/)bin
#DBGDIR:=$(if $(builddir),$(builddir)/)dbg

##################################################
# Basic commands
##################################################

#MKDIR path - create all nonexisting directories in path
#RMDIR path

# file copying
#COPY
#INSTALL
#INSTALL_PROGRAM
#INSTALL_DATA

##################################################
# Rule parts
##################################################

#rule runs every time, when depends on always
.PHONY:always

always:

##################################################
# Directory construction
##################################################

#Directories are marked by hidden .f file inside

#do not delete directory marker files
.PRECIOUS:%/.f
#enable secondary expansions
.SECONDEXPANSION:

#implicit rule to create directory and marker file
#%/.f: (system)

# add $$(@D)/.f as rule dependency

##################################################
# File names
##################################################

#DLLPREFIX={lib,cyg,...} (system)

#DEPEXT (compiler)
#PCHEXT (compiler)
#OBJEXT (compiler)
#LIBEXT (compiler)
#DBGEXT (compiler)
#DLLEXT (system)
#BINEXT (system)

##################################################
# Dynamic link libraries
##################################################

#DLL_FLAGS - some platforms ned PICode etc...
#DLL_LIBS

##################################################
# Commands
##################################################

CompileCommandCheck=$(OBJDIR)/compile$$(suffix $$*).cmd

LinkCommandCheck=$(OBJDIR)/link$$(suffix $$@).cmd

#Compile{.c,.cpp,.cc} - gcc -c -o $@ $^
# switch according to $^ extension
# (compiler)

#Link{.lib,.dll,.bin} - ar -rcs $@
# switch according to $@ extension
# (compiler)

# all commands are recursively expanded

##################################################
# Common flags
##################################################

#in addition to CPPFLAGS, CFLAGS, CXXFLAGS, LDFLAGS, LDLIBS, ...

# incrementally composed - nonrecursive
# these variables are meant to be same for all targets

CompileFlags:=
CompileFlags.c:=
CompileFlags.cpp:=

LinkFlags:=
LinkFlags.lib:=
LinkFlags.dll:=
LinkFlags.bin:=

# redefine undefined variables as empty
ifndef CPPFLAGS
 CPPFLAGS:=
endif
ifndef CFLAGS
 CFLAGS:=
endif
ifndef CXXFLAGS
 CXXFLAGS:=
endif
ifndef LDFLAGS
 LDFLAGS:=
endif
ifndef LDLIBS
 LDLIBS:=
endif

##################################################
# Facet detection
##################################################

ifndef SYSTEM
 SYSTEM:=detect
endif
include make/system/$(SYSTEM).make

ifndef COMPILER
 COMPILER:=gcc
endif
include make/compiler/$(COMPILER).make

ifndef ENVIRONMENT
 ENVIRONMENT:=default
endif
include make/environment/$(ENVIRONMENT).make

ifndef HARDWARE
 HARDWARE:=generic
endif
include make/hardware/$(HARDWARE).make

##################################################
# Command file parameters
##################################################

#initialize optional parameters to be empty
# to get rid of warnings
TARGET:=
ADD_OBJS:=
