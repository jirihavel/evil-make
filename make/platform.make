# vim: set ft=make:
##################################################
# Behavior config
##################################################

-include config.make

#VERBOSE - if empty, commands are not printed
ifndef VERBOSE
 VERBOSE:=
endif

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

ifndef sharedstatedir
 sharedstatedir:=$(prefix)/com
endif

ifndef localstatedir
 localstatedir:=$(prefix)/var
endif

ifndef runstatedir
 runstatedir:=$(prefix)/run
endif

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
# TODO Use this?
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
# generated source files
GENDIR:=$(if $(builddir),$(builddir)/)obj
# object files and other build stuff
OBJDIR:=$(if $(builddir),$(builddir)/)obj

LIBDIR:=$(if $(builddir),$(builddir)/)lib
#DLLDIR:={LIBDIR, BINDIR} (system)
BINDIR:=$(if $(builddir),$(builddir)/)bin
#DBGDIR:=$(if $(builddir),$(builddir)/)dbg

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

##################################################
# Create default config file
##################################################

CFG_SED:=-e's/@SYSTEM@/$(SYSTEM)/g'
CFG_SED+=-e's/@COMPILER@/$(COMPILER)/g'
CFG_SED+=-e's/@ENVIRONMENT@/$(ENVIRONMENT)/g'
CFG_SED+=-e's/@HARDWARE@/$(HARDWARE)/g'

.PHONY:config
config:
	@sed $(CFG_SED) make/config.make.in > config.make
#end
