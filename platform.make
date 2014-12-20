# vim: set ft=make:

# first rule is default
all:
.PHONY:all installdirs install

##################################################
# Behavior config
##################################################

#load config.make if present
-include config.make

#VERBOSE - if empty, commands are not printed
ifndef VERBOSE
 VERBOSE:=
endif

##################################################
# Source directories
##################################################

# Source tree is here
ifndef srcdir
 srcdir:=
endif

MAKEDIR:=$(if $(srcdir),$(srcdir)/)$(makedir)

# Load default values
include $(MAKEDIR)/platform/defaults.make

INCDIR:=$(if $(srcdir),$(srcdir)/)include
SRCDIR:=$(if $(srcdir),$(srcdir)/)src
ETCDIR:=$(if $(srcdir),$(srcdir)/)etc

##################################################
# Build directories
##################################################

# we are building here, working dir on default
# TODO Use this?
ifndef builddir
 builddir:=
endif

# precompiled headers
#TODO PCHDIR:=$(if $(builddir),$(builddir)/)pch
# generated source files
#TODO GENDIR:=$(if $(builddir),$(builddir)/)obj
# object files and other build stuff
OBJDIR:=$(if $(builddir),$(builddir)/)obj

LIBDIR:=$(if $(builddir),$(builddir)/)lib
#DLLDIR:={LIBDIR, BINDIR} (set by system)
BINDIR:=$(if $(builddir),$(builddir)/)bin
#DBGDIR:=$(if $(builddir),$(builddir)/)dbg

##################################################
# Installation directories
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

##################################################
# Rule parts
##################################################

# Rule runs every time, when depends on always
.PHONY:always
always:

##################################################
# Directory construction
##################################################

# Directories are marked by hidden .f file inside

# Do not delete directory marker files
.PRECIOUS:%/.f
# Enable secondary expansions (for $$(@D)/.f)
.SECONDEXPANSION:

#implicit rule to create directory and its marker file
# add $$(@D)/.f as rule dependency
# MKDIR and TOUCH will be set by system
%/.f:
	@echo "Creating $(@D)/"
	@$(MKDIR) $(@D)
	@$(TOUCH) $@

# Directory construction for installdirs
em-installdirs-bindir:
	$(MKDIR) $(DESTDIR)$(bindir)
.PHONY:em-installdirs-bindir
# System will hook proper dependency for dlldir
em-installdirs-dlldir:
.PHONY:em-installdirs-dlldir
em-installdirs-libdir:
	$(MKDIR) $(DESTDIR)$(libdir)
.PHONY:em-installdirs-libdir
em-installdirs-includedir:
	$(MKDIR) $(DESTDIR)$(includedir)
.PHONY:em-installdirs-includedir

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
include $(MAKEDIR)/system/$(SYSTEM).make

ifndef COMPILER
 COMPILER:=gcc
endif
include $(MAKEDIR)/compiler/$(COMPILER).make

ifndef ENVIRONMENT
 ENVIRONMENT:=default
endif
include $(MAKEDIR)/environment/$(ENVIRONMENT).make

ifndef HARDWARE
 HARDWARE:=generic
endif
include $(MAKEDIR)/hardware/$(HARDWARE).make

##################################################
# Command file parameters
##################################################

#initialize optional parameters to be empty
# to get rid of warnings
TARGET:=
ADD_OBJS:=

##################################################
# Support rules
##################################################

.PHONY:config init

# basic facets
EM_CFG_SED:=-e's/@SYSTEM@/$(SYSTEM)/g'
ifneq ($(COMPILER),gcc)
 EM_CFG_SED+=-e's/#COMPILER=@COMPILER@/COMPILER=$(COMPILER)/g'
endif
ifneq ($(ENVIRONMENT),default)
 EM_CFG_SED+=-e's/#ENVIRONMENT=@ENVIRONMENT@/ENVIRONMENT=$(ENVIRONMENT)/g'
endif
ifneq ($(HARDWARE),generic)
 EM_CFG_SED+=-e's/#HARDWARE=@HARDWARE@/HARDWARE=$(HARDWARE)/g'
endif

# create default config.make
config:
	@echo "Creating default config.make"
	@sed $(EM_CFG_SED) $(MAKEDIR)/config.make.in > config.make

# initialize directory for building out of source
init:
	@echo "Creating proxy Makefile"
	@echo "srcdir=$(srcdir)" > $(if $(builddir),$(builddir)/)Makefile
	@echo "include $(srcdir)/Makefile" >> $(if $(builddir),$(builddir)/)Makefile
#end
