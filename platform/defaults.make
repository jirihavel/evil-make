# vim: set ft=make:

# Facets will set/override <FACET>_DEFAULT_WHATEVER
# - this propagates into correct defaults
# Makefile can override DEFAULT_WHATEVER before including platform.make
# - TODO : this will not affect config.make
# Overriding WHATEVER will be stored in config.make
# - or platform.make will init that as nonrecursive variable from DEFAULT_WHATEVER

# System facets
DEFAULT_SYSTEM     ?=detect
DEFAULT_COMPILER   ?=gcc
DEFAULT_ENVIRONMENT?=default
DEFAULT_HARDWARE   ?=generic

# Source directories
DEFAULT_INCDIR?=$(srcdir)/include
DEFAULT_SRCDIR?=$(srcdir)/src
DEFAULT_ETCDIR?=$(srcdir)/etc

# Build directories
DEFAULT_OBJDIR?=$(builddir)/obj
DEFAULT_LIBDIR?=$(builddir)/lib
DEFAULT_DLLDIR?=$(SYSTEM_DEFAULT_DLLDIR)
DEFAULT_BINDIR?=$(builddir)/bin

# Installation directories
DEFAULT_DESTDIR       ?=
default_prefix        ?=/usr/local
default_exec_prefix   ?=$(prefix)
default_bindir        ?=$(exec_prefix)/bin
default_dlldir        ?=$(system_default_dlldir)
default_libexecdir    ?=$(exec_prefix)/libexec
default_datarootdir   ?=$(prefix)/share
default_datadir       ?=$(datarootdir)
default_sysconfdir    ?=$(prefix)/etc
default_sharedstatedir?=$(prefix)/com
default_localstatedir ?=$(prefix)/var
default_runstatedir   ?=$(prefix)/run
default_includedir    ?=$(prefix)/include
default_libdir        ?=$(exec_prefix)/lib

# System tools
DEFAULT_MKDIR?=mkdir -p
DEFAULT_RMDIR?=rm -rf
DEFAULT_TOUCH?=touch
DEFAULT_COPY ?=cp
DEFAULT_MOVE ?=mv
DEFAULT_INSTALL        ?=$(SYSTEM_DEFAULT_INSTALL)
DEFAULT_INSTALL_PROGRAM?=$(SYSTEM_DEFAULT_INSTALL_PROGRAM)
DEFAULT_INSTALL_DATA   ?=$(SYSTEM_DEFAULT_INSTALL_DATA)
DEFAULT_PKG_CONFIG     ?=PKG_CONFIG_PATH=$(LIBDIR)/pkgconfig pkg-config

SYSTEM_DEFAULT_INSTALL=install
SYSTEM_DEFAULT_INSTALL_PROGRAM=$(INSTALL)
SYSTEM_DEFAULT_INSTALL_DATA=$(INSTALL) -m644

# Compiler tools
DEFAULT_AR?=ar

# Flags
DEFAULT_ARFLAGS?=-rcs
