# vim: set ft=make:

# First rule is the default one
all:
.PHONY:all

# init creates proxy makefile for building out of source
.PHONY:init

# config creates config.make with stored config
.PHONY:config

.PHONY:check

# Common phony rules
.PHONY:installdirs installdirs-dev install install-dev
	
# clean removes all output directories
.PHONY:clean

##################################################
# Basic config
##################################################

# init MAKEDIR by path to this file
ifndef MAKEDIR
 MAKEDIR:=$(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
endif

# Load config.make if present
-include config.make

# VERBOSE - if empty, commands are not printed
ifndef VERBOSE
 VERBOSE:=
endif

# Load defaults
include $(MAKEDIR)/platform/defaults.make

include $(MAKEDIR)/gmsl/gmsl

##################################################
# System detection
##################################################

#ifndef SYSTEM
# SYSTEM:=$(DEFAULT_SYSTEM)
#endif
#include $(MAKEDIR)/system/$(SYSTEM).make

# EM_CFG_SED contains sed rule for overridded config stuff
#EM_CFG_SED:=-e's/@SYSTEM@/$(SYSTEM)/g'

##################################################
# Source directories
##################################################

# Source location
# - now it is safe to use $(srcdir)/...
ifeq ($(srcdir),)
 srcdir:=.
endif

ifndef INCDIR
 INCDIR:=$(DEFAULT_INCDIR)
endif
ifndef SRCDIR
 SRCDIR:=$(DEFAULT_SRCDIR)
endif
ifndef ETCDIR
 ETCDIR:=$(DEFAULT_ETCDIR)
endif

##################################################
# Build directories
##################################################

# Default builddir is working directory
# - TODO does anything else make sense?
ifndef builddir
 builddir:=
endif

# generated sources and headers
#TODO GENDIR:=$(if $(builddir),$(builddir)/)obj
# precompiled headers
#TODO PCHDIR:=$(if $(builddir),$(builddir)/)pch
# object files and other build stuff
ifndef OBJDIR
 OBJDIR:=$(DEFAULT_OBJDIR)
endif

ifndef LIBDIR
 LIBDIR:=$(DEFAULT_LIBDIR)
endif
#DLLDIR:={LIBDIR, BINDIR}
# - SYSTEM sets SYSTEM_DEFAULT_DLLDIR, then DLLDIR will be set
ifndef BINDIR
 BINDIR:=$(DEFAULT_BINDIR)
endif
#TODO DBGDIR:=$(if $(builddir),$(builddir)/)dbg

##################################################
# Installation directories
##################################################

ifndef DESTDIR
 DESTDIR:=
endif

ifndef prefix
 prefix:=$(default_prefix)
endif

ifndef exec_prefix
 exec_prefix:=$(default_exec_prefix)
endif

ifndef bindir
 bindir:=$(default_bindir)
endif

ifndef libexecdir
 libexecdir:=$(default_libexecdir)
endif

ifndef datarootdir
 datarootdir:=$(default_datarootdir)
endif

ifndef datadir
 datadir:=$(default_datadir)
endif

ifndef sysconfdir
 sysconfdir:=$(default_sysconfdir)
endif

ifndef sharedstatedir
 sharedstatedir:=$(default_sharedstatedir)
endif

ifndef localstatedir
 localstatedir:=$(default_localstatedir)
endif

ifndef runstatedir
 runstatedir:=$(default_runstatedir)
endif

ifndef includedir
 includedir:=$(default_includedir)
endif

ifndef libdir
 libdir:=$(default_libdir)
endif

# dynamic libraries (.dll, .so) go here
#dlldir:={bindir,libdir} (system)

##################################################
# Rule parts
##################################################

# Rule runs every time, when depends on always
always:
.PHONY:always

##################################################
# Directory construction
##################################################

# Directories are marked by hidden .f file inside
# - add $$(@D)/.f as a dependency

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

# bindir for executables
em-installdirs-bindir:
	$(MKDIR) $(DESTDIR)$(bindir)
.PHONY:em-installdirs-bindir

# dlldir for dynamic libraries
# - system will hook proper dependency for dlldir
em-installdirs-dlldir:
.PHONY:em-installdirs-dlldir

# libdir for static and import libraries
em-installdirs-libdir:
	$(MKDIR) $(DESTDIR)$(libdir)
.PHONY:em-installdirs-libdir

# pkgdir for pkg-config .pc files
em-installdirs-pkgdir:em-installdirs-libdir
	$(MKDIR) $(DESTDIR)$(libdir)/pkgconfig
.PHONY:em-installdirs-pkgdir

# includedir for includes
em-installdirs-includedir:
	$(MKDIR) $(DESTDIR)$(includedir)
.PHONY:em-installdirs-includedir

##################################################
# Common flags
##################################################

# CPPFLAGS, CFLAGS, CXXFLAGS, LDFLAGS, LDLIBS, ...
# -
# - init undefined as empty
ifndef CPPFLAGS
 CPPFLAGS:=
endif
ifndef CFLAGS
 CFLAGS:=
endif
ifndef CXXFLAGS
 CXXFLAGS:=
endif
ifndef ARFLAGS
 ARFLAGS:=
endif
ifndef LDFLAGS
 LDFLAGS:=
endif
ifndef LDLIBS
 LDLIBS:=
endif

# Internal flags
# - incrementally composed - nonrecursive
# - these variables are meant to be same for all targets

EmCompileFlags:=
EmCompileFlags.c:=
EmCompileFlags.cxx:=

EmLinkFlags:=
EmLinkFlags.dll:=
EmLinkFlags.bin:=

# -- Recursive internal flags --

#EM_CPPFLAGS:=
#EM_CFLAGS:=
#EM_CXXFLAGS:=

##################################################
# Facet detection
##################################################

ifndef SYSTEM
 SYSTEM:=$(DEFAULT_SYSTEM)
endif
include $(MAKEDIR)/system/$(SYSTEM).make
EM_CFG_SED:=-e's/@SYSTEM@/$(SYSTEM)/g'

# -- Compiler facet --

SYSTEM_DEFAULT_COMPILER?=gcc

ifndef COMPILER
 COMPILER:=$(DEFAULT_COMPILER)
else
 EM_CFG_SED+=-e's/#COMPILER=@COMPILER@/COMPILER=$(COMPILER)/g'
endif
include $(MAKEDIR)/compiler/$(COMPILER).make

ifndef ENVIRONMENT
 ENVIRONMENT:=$(DEFAULT_ENVIRONMENT)
else
 EM_CFG_SED+=-e's/#ENVIRONMENT=@ENVIRONMENT@/ENVIRONMENT=$(ENVIRONMENT)/g'
endif
include $(MAKEDIR)/environment/$(ENVIRONMENT).make

ifndef HARDWARE
 HARDWARE:=$(DEFAULT_HARDWARE)
else
 EM_CFG_SED+=-e's/#HARDWARE=@HARDWARE@/HARDWARE=$(HARDWARE)/g'
endif
include $(MAKEDIR)/hardware/$(HARDWARE).make

# -- Finish facet dependent init --

ifndef DLLDIR
 DLLDIR:=$(DEFAULT_DLLDIR)
endif
ifndef dlldir
 dlldir:=$(default_dlldir)
endif

ifndef INSTALL_PROGRAM
 INSTALL_PROGRAM:=$(DEFAULT_INSTALL_PROGRAM)
endif
ifndef INSTALL_DATA
 INSTALL_DATA:=$(DEFAULT_INSTALL_DATA)
endif
ifndef PKG_CONFIG
 PKG_CONFIG:=$(DEFAULT_PKG_CONFIG)
endif

MoveIfNotEqual?=cmp -s $1 $2 || $(MOVE) -fT $1 $2

UpdateIfNotEqual?=echo "$2" | cmp -s - $1 || echo "$2" > $1
updateIfNotEqual?=echo '$1' | cmp -s - $@ || echo '$1' > $@

##################################################
# Command file parameters
##################################################

#initialize optional parameters to be empty
# to get rid of warnings
ADD_OBJS:=

##################################################
# Support rules
##################################################

# initialize directory for building out of source
# - do not use when building in source
# - TODO : check in source build
init:
	@echo "Creating proxy Makefile"
	@echo "srcdir=$(srcdir)" > $(if $(builddir),$(builddir)/)Makefile
	@echo "include $(srcdir)/Makefile" >> $(if $(builddir),$(builddir)/)Makefile

# create default config.make
config:
	@echo "Creating default config.make"
	@sed $(EM_CFG_SED) $(MAKEDIR)/config.make.in > config.make

clean:
	$(RMDIR) $(BINDIR)
	$(RMDIR) $(DLLDIR)
	$(RMDIR) $(LIBDIR)
	$(RMDIR) $(OBJDIR)

##################################################
# Common sed files
##################################################

# sed files for creating pkg-config .pc files

EM_PKG_BUILDDIRS_SED:=$(OBJDIR)/.em/em-pkg-builddirs.sed
EM_PKG_INSTALLDIRS_SED:=$(OBJDIR)/.em/em-pkg-installdirs.sed

$(EM_PKG_BUILDDIRS_SED):always $$(@D)/.f
	@echo 's|@PREFIX@|.|g'                > $@.new
	@echo 's|@EXEC_PREFIX@|$${prefix}|g' >> $@.new
	@echo 's|@INCLUDEDIR@|$(if $(call seq,$(INCDIR),$(DEFAULT_INCDIR)),$${prefix}/include,$(INCDIR))|g' >> $@.new
	@echo 's|@LIBDIR@|$(if $(call seq,$(LIBDIR),$(DEFAULT_LIBDIR)),$${exec_prefix}/lib,$(LIBDIR))|g'    >> $@.new
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call MoveIfNotEqual,$@.new,$@)

$(EM_PKG_INSTALLDIRS_SED):always $$(@D)/.f
	@echo 's|@PREFIX@|$(prefix)|g' > $@.new
	@echo 's|@EXEC_PREFIX@|$(if $(call seq,$(exec_prefix),$(default_exec_prefix)),$${prefix},$(exec_prefix))|g'     >> $@.new
	@echo 's|@INCLUDEDIR@|$(if $(call seq,$(includedir),$(default_includedir)),$${prefix}/include,$(includedir))|g' >> $@.new
	@echo 's|@LIBDIR@|$(if $(call seq,$(libdir),$(default_libdir)),$${exec_prefix}/lib,$(libdir))|g'                >> $@.new
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call MoveIfNotEqual,$@.new,$@)
# end
