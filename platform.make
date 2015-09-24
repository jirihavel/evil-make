# vim: set ft=make:

# First rule is the default one
all:

# Common phony rules
.PHONY:all check clean
.PHONY:installdirs installdirs-dev install install-dev
	
##################################################
# Storing config
##################################################

# config rule creates config.make with stored config
.PHONY:config

# EM_CONFIG_SED contains sed rules for changing config template
EM_CONFIG_SED:=

##################################################
# Basic config
##################################################

# Source tree location
# - guess from <makefile> if not set
ifndef srcdir
 srcdir:=$(patsubst %/,%,$(dir $(makefile)))
else ifeq ($(srcdir),)
 srcdir:=.
endif
# now it is ok to use $(srcdir)/...

# Default builddir is working directory
# - TODO does anything else make sense?
ifndef builddir
 builddir:=.
else ifeq ($(builddir),)
 builddir:=.
endif
# now it is ok to use $(builddir)/...

# Rule 'init' to set build outside of source tree
# - proxy makefile sets source tree location and includes original makefile
.PHONY:init
ifeq ($(realpath $(makefile)),$(realpath $(builddir)/Makefile))
 init:
	@echo "Building in source, command ignored"
else
 init:
	@echo "Creating proxy Makefile"
	@echo "srcdir=$(srcdir)"     > $(builddir)/Makefile
	@echo "include $(makefile)" >> $(builddir)/Makefile
endif

# MAKEDIR is path to this file
ifndef MAKEDIR
 MAKEDIR:=$(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
endif

# Load config.make if present
-include config.make

# Load defaults
include $(MAKEDIR)/platform/defaults.make

# VERBOSE - if empty, commands are not printed
ifndef VERBOSE
 VERBOSE:=$(DEFAULT_VERBOSE)
else ifneq ($(VERBOSE),)
 EM_CONFIG_SED+=-e's|#VERBOSE:=1|VERBOSE:=1|'
endif

##################################################
# Basic commands
##################################################

include $(MAKEDIR)/gmsl/gmsl

# Set variable and then restore its original value
# Works only for nonrecursive variables
#
# var:=foo
# $(call push_var,var,bar)
# ... $(var) equals 'bar' here
# $(call pop_var,var)
# ... $(var) equals 'foo' here
#
push_var=$(call push,EmVariableStack.$1,$($1))$(eval $1:=$2)
pop_var=$(eval $1:=$(call pop,EmVariableStack.$1))

##################################################
# Source directories
##################################################

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
#DLLDIR:={LIBDIR, BINDIR, ...} (system)
ifndef BINDIR
 BINDIR:=$(DEFAULT_BINDIR)
endif
#TODO DBGDIR:=$(if $(builddir),$(builddir)/)dbg

##################################################
# Installation directories
##################################################

ifndef DESTDIR
 DESTDIR:=$(DEFAULT_DESTDIR)
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
#dlldir:={bindir,libdir} (system)
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

# Implicit rule to create directory and its marker file
# - MKDIR and TOUCH will be set by system
%/.f:
	@echo "Creating $(@D)/"
	@$(MKDIR) $(@D)
	@$(TOUCH) $@

# -- Installation directories --

# bindir for executables
em-installdirs-bindir:
	$(MKDIR) $(DESTDIR)$(bindir)
.PHONY:em-installdirs-bindir

# dlldir for dynamic libraries (system)
.PHONY:em-installdirs-dlldir

# includedir for includes
em-installdirs-includedir:
	$(MKDIR) $(DESTDIR)$(includedir)
.PHONY:em-installdirs-includedir

# libdir for static and import libraries
em-installdirs-libdir:
	$(MKDIR) $(DESTDIR)$(libdir)
.PHONY:em-installdirs-libdir

# pkgdir for pkg-config .pc files
em-installdirs-pkgdir:em-installdirs-libdir
	$(MKDIR) $(DESTDIR)$(libdir)/pkgconfig
.PHONY:em-installdirs-pkgdir

##################################################
# System detection
##################################################

ifndef SYSTEM
 SYSTEM:=$(DEFAULT_SYSTEM)
endif
include $(MAKEDIR)/system/$(SYSTEM).make

# Always store detected system
EM_CONFIG_SED+=-e's/@SYSTEM@/$(SYSTEM)/'

# -- Finish system dependent init --

ifndef DLLDIR
 DLLDIR:=$(DEFAULT_DLLDIR)
endif
ifndef dlldir
 dlldir:=$(default_dlldir)
endif

ifeq ($(dlldir),$(libdir))
 em-installdirs-dlldir:em-installdirs-libdir
else ifeq ($(dlldir),$(bindir))
 em-installdirs-dlldir:em-installdirs-bindir
else
 em-installdirs-dlldir:
	$(MKDIR) $(DESTDIR)$(dlldir)
endif

##################################################
# System tools
##################################################

ifndef MKDIR
 MKDIR:=$(DEFAULT_MKDIR)
endif
ifndef RMDIR
 RMDIR:=$(DEFAULT_RMDIR)
endif

ifndef TOUCH
 TOUCH:=$(DEFAULT_TOUCH)
endif
ifndef COPY
 COPY:=$(DEFAULT_COPY)
endif
ifndef MOVE
 MOVE:=$(DEFAULT_MOVE)
endif

ifndef INSTALL
 INSTALL:=$(DEFAULT_INSTALL)
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

# Move file _to_ file or _in_ directory
em_move_to?=mv -f -T $1 $2
em_move_in?=mv -f -t $2 $1

# Rename file $1 to $2 if the files are different (or $2 does not exist)
em_move_ne?=cmp -s $1 $2 || $(em_move_to)

em_write_ne?=echo '$2' | cmp -s $1 || echo '$2' > $1

UpdateIfNotEqual?=echo "$2" | cmp -s - $1 || echo "$2" > $1
updateIfNotEqual?=echo '$1' | cmp -s - $@ || echo '$1' > $@

##################################################
# Compiler & Hardware
##################################################

# Internal flags
# - incrementally composed - nonrecursive
# - these variables are meant to be same for all targets
EmCompileFlags:=
EmCompileFlags.c:=
EmCompileFlags.cxx:=

EmLinkFlags:=
EmLinkFlags.dll:=
EmLinkFlags.bin:=

# -- Init compiler --

ifndef COMPILER
 COMPILER:=$(DEFAULT_COMPILER)
else
 EM_CONFIG_SED+=-e's/#COMPILER=@COMPILER@/COMPILER=$(COMPILER)'
endif
include $(MAKEDIR)/compiler/$(COMPILER).make

# -- Init hardware --

ifndef HARDWARE
 HARDWARE:=$(DEFAULT_HARDWARE)
else
 EM_CONFIG_SED+=-e's/#HARDWARE=@HARDWARE@/HARDWARE=$(HARDWARE)'
endif
include $(MAKEDIR)/hardware/$(HARDWARE).make

# -- Compiler tools --

ifeq ($(origin ARFLAGS),default)
 AR:=$(DEFAULT_AR)
endif

##################################################
# Common flags
##################################################

# CPPFLAGS, CFLAGS, CXXFLAGS, LDFLAGS, LDLIBS, ...
ifndef CPPFLAGS
 CPPFLAGS:=
endif
ifndef CFLAGS
 CFLAGS:=
endif
ifndef CXXFLAGS
 CXXFLAGS:=
endif
ifeq ($(origin ARFLAGS),default)
 ARFLAGS:=$(DEFAULT_ARFLAGS)
endif
ifndef LDFLAGS
 LDFLAGS:=
endif
ifndef LDLIBS
 LDLIBS:=
endif

# -- General parameters --

LANG:=
LANG.c:=
LANG.cxx:=

# -- Compilation parameters --

WANT_PCH:=
WANT_PIE:=
WANT_PIC:=

# -- Linking parameters --

WANT_MAP:=
DEF:=
IMP:=
MAP:=
SONAME:=

##################################################
# Support rules
##################################################

# create default config.make
config:
	@echo "Creating default config.make"
	@sed $(EM_CONFIG_SED) $(MAKEDIR)/platform/config.make.in > config.make

clean:
	$(RMDIR) $(sort $(BINDIR) $(DLLDIR) $(LIBDIR) $(OBJDIR))

##################################################
# Common sed files
##################################################

# sed files for creating pkg-config .pc files

EM_PKG_BUILDDIRS_SED:=$(OBJDIR)/.em/em-pkg-builddirs.sed
EM_PKG_INSTALLDIRS_SED:=$(OBJDIR)/.em/em-pkg-installdirs.sed

$(EM_PKG_BUILDDIRS_SED):always $$(@D)/.f
	@echo 's|@PREFIX@|.|g'                > $@.new
	@echo 's|@EXEC_PREFIX@|$${prefix}|g' >> $@.new
	@echo 's|@INCLUDEDIR@|$(if $(call seq,$(INCDIR),./include),$${prefix}/include,$(INCDIR))|g' >> $@.new
	@echo 's|@LIBDIR@|$(if $(call seq,$(LIBDIR),./lib),$${exec_prefix}/lib,$(LIBDIR))|g'        >> $@.new
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call em_move_ne,$@.new,$@)

$(EM_PKG_INSTALLDIRS_SED):always $$(@D)/.f
	@echo 's|@PREFIX@|$(prefix)|g' > $@.new
	@echo 's|@EXEC_PREFIX@|$(if $(call seq,$(exec_prefix),$(default_exec_prefix)),$${prefix},$(exec_prefix))|g'     >> $@.new
	@echo 's|@INCLUDEDIR@|$(if $(call seq,$(includedir),$(default_includedir)),$${prefix}/include,$(includedir))|g' >> $@.new
	@echo 's|@LIBDIR@|$(if $(call seq,$(libdir),$(default_libdir)),$${exec_prefix}/lib,$(libdir))|g'                >> $@.new
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call em_move_ne,$@.new,$@)

##################################################
# Command file parameters
##################################################

CONFIG:=
SUFFIX:=

DEPS:=
PKGS:=
FLAGS:=
LIBS:=
SRCS:=

MAJOR_VERSION:=
MINOR_VERSION:=
PATCH_VERSION:=

#initialize optional parameters to be empty
# to get rid of warnings
ADD_OBJS:=
#end
