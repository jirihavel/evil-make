# vim: set ft=make:

# Source directories
DEFAULT_INCDIR?=$(if $(srcdir),$(srcdir)/)include
DEFAULT_SRCDIR?=$(if $(srcdir),$(srcdir)/)src
DEFAULT_ETCDIR?=$(if $(srcdir),$(srcdir)/)etc

# Build directories
DEFAULT_OBJDIR?=$(if $(builddir),$(builddir)/)obj
DEFAULT_LIBDIR?=$(if $(builddir),$(builddir)/)lib
DEFAULT_DLLDIR?=$(SYSTEM_DEFAULT_DLLDIR)
DEFAULT_BINDIR?=$(if $(builddir),$(builddir)/)bin

# Installation directories
default_prefix        ?=/usr/local
default_exec_prefix   ?=$(prefix)
default_bindir        ?=$(exec_prefix)/bin
default_libexecdir    ?=$(exec_prefix)/libexec
default_datarootdir   ?=$(prefix)/share
default_datadir       ?=$(datarootdir)
default_sysconfdir    ?=$(prefix)/etc
default_sharedstatedir?=$(prefix)/com
default_localstatedir ?=$(prefix)/var
default_runstatedir   ?=$(prefix)/run
default_includedir    ?=$(prefix)/include
default_libdir        ?=$(exec_prefix)/lib
default_dlldir        ?=$(system_defalt_dlldir)

# System facets
DEFAULT_SYSTEM     ?=detect
DEFAULT_COMPILER   ?=$(SYSTEM_DEFAULT_COMPILER)
DEFAULT_ENVIRONMENT?=default
DEFAULT_HARDWARE   ?=generic
