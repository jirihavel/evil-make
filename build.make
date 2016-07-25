# vim: set ft=make:
ifndef BUILD_MAKE_INCLUDED
BUILD_MAKE_INCLUDED:=1

# Put "all" here so it is first rule
# - it does nothing by default
# - hook dependencies to it
.PHONY:all
all:

# Stores important config to config.make
# - Add variable names to CONFIG_VARS
.PHONY:config

# Initialize build out of source tree
# - requires srcdir
# - creates proxy makefile in build dir
# - 1) make -f /src/dir/ init
#   2) make ...
.PHONY:init

# Print variables from VARS
# e.g. make print "VARS=FOO BAR BAZ"
.PHONY:print

# Print information about modules
.PHONY:module-info

# -- Source tree prefix --
# 
# Use $(srcdir)path/to/file
srcdir?=

# builddir is assumed to be the working directory

# -- Make tree prefix --
#
# All makefile components start with $(makedir)
# - it is the path to this file
ifndef makedir
 makedir:=$(dir $(lastword $(MAKEFILE_LIST)))
endif

# Load gnu make standard library
include $(makedir)gmsl/gmsl

# -- Global config --

# Load config if present in builddir
-include config.make

# If "VERBOSE" is true, rules print commands
VERBOSE?=$(false)

# Contains variable names to store in config.make
CONFIG_VARS:=VERBOSE

# -- Configure make --

# Disable all default rules
.SUFFIXES:
# Enable secondary expansions
.SECONDEXPANSION:

##################################################
# == Build system ==
#
# Operating system for building.
#
# Config :
# - BUILD
#
# Variables :
# - EM_DEV_NULL
#   - Special file with the meaning of /dev/null
#
# Commands :
# - em_conv_path <path>
#   - Convert path to be executable
# - em_mkdir <path>
#   - Create directory (including subdirectories) if not exists
##################################################

BUILD?=detect
include $(makedir)build/$(BUILD).make
CONFIG_VARS+=BUILD

#-------------------------------------------------
# -- File manipulation --
#
# TODO : multiplatform
#-------------------------------------------------

# $(call em_move_to,src_file,dst_file)
# - move source file _to_ destination file
em_move_to=mv -f -T $1 $2
# Move file(s) _in_ directory
# - $(call em_move_in,src1 src2 ...,dst_dir)
em_move_in=mv -f -t $2 $1

# $(call em_move_ne,src_file,dst_file)
# - move source to destination if the contents are different
em_move_ne=cmp -s $1 $2 || $(em_move_to)

# $(call em_write_ne,contents,file)
# - write contents (+ change time) to file, if the file contents are different
em_write_ne=echo '$2' | cmp -s $1 || echo '$2' > $1 

##################################################
# == Special rules ==
##################################################

# Stuff that depends on "always" is rebuilt every time
.PHONY:always
always:

#-------------------------------------------------
# -- Automatic directory construction --
#
# - add $$(@D)/.f as rule dependency
# - can be order only dependency 
# - on windows, mark .f as hidden (+ its directory if starts with .)
#-------------------------------------------------

%/.f:
	@echo Creating $*/
	$(if $(VERBOSE),,@)$(call em_mkdir,$*)
	$(if $(VERBOSE),,@)touch $@
	$(if $(VERBOSE),,@)$(if $(HAVE_OS_WINDOWS),attrib +H $@)
	$(if $(VERBOSE),,@)$(if $(call and,$(HAVE_OS_WINDOWS),$(filter .%,$(notdir $*))),attrib +H $*)

.PRECIOUS:%/.f

#-------------------------------------------------
# -- Stored configuration --
#
# Rule "config" stores all variables from CONFIG_VARS
#  to config.make
#-------------------------------------------------

config:
	@echo Creating config.make
	$(file >config.make)
	$(foreach v,$(sort $(CONFIG_VARS)),$(file >>config.make,$v:=$($v)))

#-------------------------------------------------
# -- Building out of source --
#
# Rule 'init' sets build outside of source tree
# - It creates proxy makefile in current directory
# - $(lastword $(MAKEFILE_LIST)) is the path to this makefile
# - proxy makefile sets source tree location and includes original makefile
#-------------------------------------------------

ifeq ($(realpath $(lastword $(MAKEFILE_LIST))),$(realpath Makefile))
init:
	@echo Building in source, command ignored
else
init:
	@echo Creating proxy Makefile
	@$(file >Makefile,srcdir:=$(srcdir))
	@$(file >>Makefile,include $(srcdir)Makefile)
endif

#-------------------------------------------------
# -- Variable printing --
#-------------------------------------------------

# The empty line is intentional to insert EOL
define em_print_variable
echo $(1)=$($(1))

endef

em_print_variables=$(foreach v,$1,$(call em_print_variable,$v))

print:
	@$(call em_print_variables,$(VARS))

##################################################
# == Host system ==
#
# Config :
# - HOST (empty means native build)
#
# Variables :
# - BINEXT
# - DLLPREFIX, DLLEXT
##################################################

HOST?=
include $(makedir)host/$(if $(HOST),$(call lc,$(lastword $(subst -, ,$(HOST)))),$(BUILD)).make
CONFIG_VARS+=HOST

##################################################
# Installation directories
##################################################

DEFAULT_DESTDIR?=
default_prefix=/usr/local
default_exec_prefix=$(prefix)
default_bindir=$(exec_prefix)/bin

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

# bindir for executables
.PHONY:em-installdirs-bindir
em-installdirs-bindir:
	$(call em_mkdir,$(DESTDIR)$(bindir))

# dlldir for dynamic libraries (system)
.PHONY:em-installdirs-dlldir

# includedir for includes
.PHONY:em-installdirs-includedir
#em-installdirs-includedir:
#	$(MKDIR) $(DESTDIR)$(includedir)

# libdir for static and import libraries
.PHONY:em-installdirs-libdir
#em-installdirs-libdir:
#	$(MKDIR) $(DESTDIR)$(libdir)

# pkgdir for pkg-config .pc files
.PHONY:em-installdirs-pkgdir 
#em-installdirs-pkgdir:em-installdirs-libdir
#	$(MKDIR) $(DESTDIR)$(libdir)/pkgconfig

# 1 - short name
# 2 - binaries to install
define em_install_bin_rules =
install:install-$1
.PHONY:install-$1
install-$1:$2 installdirs-$1
	$(call em_install_program,$2,$$(DESTDIR)$$(bindir)/)
installdirs:installdirs-$1
.PHONY:installdirs-$1
installdirs-$1:em-installdirs-bindir
endef

em_install_bin=$(eval $(call em_install_bin_rules,$1,$2))

##################################################
# == Compiler ==
#
# Config :
# - COMPILER
#
# Variables :
# - EM_C_COMPILER, EM_CXX_COMPILER
# - LIBEXT, OBJEXT, DEPEXT
##################################################

COMPILER?=gcc
include $(makedir)compiler/$(COMPILER).make
CONFIG_VARS+=COMPILER

##################################################
# == Compilation & Linking ==
##################################################

# -- builddir subdirectories --

# binaries and .dll
BINDIR:=bin/
# libraries, .so and so on
LIBDIR:=lib/

# object files, and all intermediate junk
OBJDIR:=obj/
# precompiled and generated headers go here
PCHDIR:=$(OBJDIR)include

# foo.c -> obj/foo.c.o
em_src_to_obj=$(patsubst $(srcdir)%,$(OBJDIR)%$(OBJEXT),$1)
# foo.c -> obj/foo.c.d
em_src_to_dep=$(patsubst $(srcdir)%,$(OBJDIR)%$(DEPEXT),$1)

# obj/foo.c.o -> obj/foo.c.d
em_obj_to_dep=$(patsubst %$(OBJEXT),%$(DEPEXT),$1)

# .flg contains part of command line
FLGEXT:=.flg
# .cfg contains configuration variables
CFGEXT:=.cfg

em_flags=$(OBJDIR)$1$(FLGEXT)

# -- Module system --

# Remove duplicate entities, keep rightmost ones
em_uniq_right=$(call reverse,$(call uniq,$(call reverse,$1)))

# Get all modules including dependencies
em_expand_modules_impl=$(foreach m,$1,$m $(call em_expand_modules,$($m_MODULES)))
em_expand_modules=$(call em_uniq_right,$(call em_expand_modules_impl,$1))

# -- pkg-config wrapper --

em_pkg_config_impl=$(if $2,$(shell pkg-config $1 $2))
em_pkg_config=$(call em_pkg_config_impl,$1,$(sort $2))

#-------------------------------------------------
# -- Compilation --
#
# em_compile {<source>} [<flag_file>]
# - returns {<object>}
#-------------------------------------------------

WANT_CPU?=
WANT_THREADS?=$(true)
WANT_DEPS_FAST?=$(false)

CONFIG_VARS+=WANT_CPU WANT_THREADS WANT_DEPS_FAST

WANT_STD_C?=c11
WANT_STD_CXX?=c++14

CONFIG_VARS+=WANT_STD_C WANT_STD_CXX

# -- Language based on file suffix --

EM_LANGUAGE.c:=C
EM_LANGUAGE.C:=CXX
EM_LANGUAGE.cpp:=CXX
EM_LANGUAGE.cxx:=CXX

# Setting LANG variable overrides the automatic selection
# - shouldn't be set globally but per rule
LANG:=

# <filename> -> C/CXX/...
em_file_lang=$(if $(LANG),$(LANG),$(EM_LANGUAGE$(suffix $1)))

# -- Compiler flags --

# generate dependencies during compilation
em_common_flags =-MMD $(if $(WANT_DEPS_FAST),,-MP)
# set target architecture
em_common_flags+=$(if $(WANT_CPU),-march=$(WANT_CPU))
# allow multithreading
em_common_flags+=$(if $(WANT_THREADS),-mthreads)

# -- Module system --

# $1 - expanded modules
em_expand_flags=$(call em_pkg_config,--cflags,$(foreach m,$1,$($m_PACKAGES)) $(PACKAGES))
em_expand_flags+=$(call em_compiler_defines,$(foreach m,$1,$($m_DEFINITIONS)) $(DEFINITIONS))
em_expand_flags+=$(call em_compiler_inc_dirs,$(foreach m,$1,$($m_INCLUDE_DIRS)) $(INCLUDE_DIRS))

# -- Flag files --

$(OBJDIR)%$(FLGEXT):always | $$(@D)/.f
	$(file >$@.new,$(em_common_flags) \
		$(call em_expand_flags,$(call em_expand_modules,$(MODULES))) \
	    $(FLAGS))
	@$(call em_move_ne,$@.new,$@)

.PRECIOUS:$(OBJDIR)%$(FLGEXT)

# -- Compilation --

#<output> <input> <flag_file>
define em_file_compilation =
$1:$2 $3 | $$$$(@D)/.f
	@echo Compiling $$<
	$(if $(VERBOSE),,@)$$(EM_COMPILER_$$(call em_file_lang,$$<)) -c -o $$@ $$< @$3
-include $(call em_obj_to_dep,$1)
endef

# <output> <input> [<flag_file>]
em_compile_to=$1$(eval $(call em_file_compilation,$1,$2,$(if $3,$3,$1$(FLGEXT))))

# {<source>} [<flag_file>]
em_compile=$(foreach s,$1,$(call em_compile_to,$(call em_src_to_obj,$s),$s,$2))

#-------------------------------------------------
# -- Executable binaries --
#
# - BINDIR
#
# System :
# - BINEXT
#
# Config :
# - WANT_DBG_SEPARATE
#   - strip executable and place debug symbols into a separate .dbg file
#-------------------------------------------------

WANT_DBG_SEPARATE?=$(false)
CONFIG_VARS+=WANT_DBG_SEPARATE

define EM_SEPARATE_DEBUG_SYMBOLS =
objcopy --only-keep-debug $@ $@.dbg
strip -g $@
objcopy --add-gnu-debuglink=$@.dbg $@
endef

# -- Module system --

# $1 - expanded modules
em_linker_flags_impl=$(call em_compiler_lib_dirs,$(foreach m,$1,$($m_LIBRARY_DIRS)) $(LIBRARY_DIRS))
em_linker_flags_impl+=$(call em_pkg_config,--libs,$(foreach m,$1,$($m_PACKAGES)) $(PACKAGES))

EM_EXPANDED_LINKER_FLAGS=$(call em_linker_flags_impl,$(call em_expand_modules,$(MODULES)))

#<output> <input> [<libs>]
define em_bin_linking =
$1$(FLGEXT):always | $$$$(@D)/.f
	$$(file >$$@.new,$2 $3 $$(EM_EXPANDED_LINKER_FLAGS))
	@$(call em_move_ne,$$@.new,$$@)
$1$(CFGEXT):always | $$$$(@D)/.f
	$$(file >$$@.new,WANT_DBG_SEPARATE=$$(WANT_DBG_SEPARATE))
	@$(call em_move_ne,$$@.new,$$@)
$1:$1$(FLGEXT) $1$(CFGEXT) $2 | $$$$(@D)/.f
	@echo Linking $$@
	$(if $(VERBOSE),,@)$(CXX) -o $$@ @$$<
	$(if $(VERBOSE),,@)$(if $(WANT_DBG_SEPARATE),$(EM_SEPARATE_DEBUG_SYMBOLS))
endef

# <output> <input> [<libs>]
em_link_bin_to=$1$(eval $(call em_bin_linking,$1,$2,$3))

# <name> <input> [<libs>]
em_link_bin=$(call em_link_bin_to,$(BINDIR)$1$(BINEXT),$2,$3)

#-------------------------------------------------
# -- Static libraries --
#
# - LIBDIR
#
# - LIBEXT (.a)
# 
# lib/libFOO.a:
#
# Config :
# - AR, [ARFLAGS]
# - WANT_LIB_INDEX
# - WANT_LIB_THIN
#-------------------------------------------------

WANT_LIB_INDEX?=$(true)
WANT_LIB_THIN?=$(false)
CONFIG_VARS+=WANT_LIB_INDEX WANT_LIB_THIN

# Default ARFLAGS
# replace, silently create, ranlib
# + thin archive (do not store file contents)
ARFLAGS=rc$(if $(WANT_LIB_INDEX),s)$(if $(WANT_LIB_THIN),T)

#<output> <input>
#
# <output>.flg for list of files
# <output>.cfg for other parameters
define em_lib_linking =
$1$(FLGEXT):always | $$$$(@D)/.f
	$$(file >$$@.new,$2)
	@$(call em_move_ne,$$@.new,$$@)
$1$(CFGEXT):always | $$$$(@D)/.f
	$$(file >$$@.new,AR=$$(AR))
	$$(file >>$$@.new,ARFLAGS=$$(ARFLAGS))
	$$(file >>$$@.new,WANT_LIB_INDEX=$$(WANT_LIB_INDEX))
	$$(file >>$$@.new,WANT_LIB_THIN=$$(WANT_LIB_THIN))
	@$(call em_move_ne,$$@.new,$$@)
$1:$1$(FLGEXT) $1$(CFGEXT) $2 | $$$$(@D)/.f
	@echo Linking $$@
	$(if $(VERBOSE),,@)$$(AR) $$(ARFLAGS) $$@ @$$<
endef

#<output> <input>
em_link_lib_to = $1$(eval $(call em_lib_linking,$1,$2))

#<name> <input>
em_link_lib = $(call em_link_lib_to,$(LIBDIR)$(LIBPREFIX)$1$(LIBEXT),$2)

endif # BUILD_MAKE_INCLUDED
