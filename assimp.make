# vim: set ft=make:
#
# Parameters :
# - ASSIMP_REQUIRED
#
# Config :
# - ASSIMP_PKGS
# - ASSIMP_INCLUDE_DIRS
# - ASSIMP_LIBRARY_DIRS
#
# Output :
# - ASSIMP_FOUND
# - ASSIMP_DEFINITIONS
#
ifndef ASSIMP_MAKE_INCLUDED
ASSIMP_MAKE_INCLUDED:=1

include $(dir $(lastword $(MAKEFILE_LIST)))build.make

ASSIMP_REQUIRED?=$(false)

ASSIMP_PKGS?=$(shell pkg-config --exists assimp && echo assimp)
ASSIMP_INCLUDE_DIRS?=
ASSIMP_LIBRARY_DIRS?=

CONFIG_VARS+=ASSIMP_PKGS ASSIMP_INCLUDE_DIRS ASSIMP_LIBRARY_DIRS

ASSIMP_FOUND:=$(shell pkg-config --exists $(ASSIMP_PKGS) && echo $(true))
ASSIMP_DEFINITIONS:=$(if $(ASSIMP_FOUND),HAVE_ASSIMP=1)
ASSIMP_LIBRARIES:=$(if $(ASSIMP_PKGS),,assimp)

.PHONY:assimp-module-info
assimp-module-info:
	@echo Assimp $(if $(ASSIMP_FOUND),,NOT )found :
	@echo   PKGS = $(ASSIMP_PKGS)
	@echo     CFLAGS = $(shell pkg-config --cflags $(ASSIMP_PKGS))
	@echo     LIBS = $(shell pkg-config --libs $(ASSIMP_PKGS))
	@echo   DEFS = $(ASSIMP_DEFINITIONS)

module-info:assimp-module-info

endif # ASSIMP_MAKE_INCLUDED

ifneq ($(ASSIMP_REQUIRED),)
ifeq ($(ASSIMP_FOUND),)
$(error Assimp not found)
endif
endif
