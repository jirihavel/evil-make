# vim: set ft=make:
#
# Parameters :
# - EIGEN3_REQUIRED
#
# Config :
# - EIGEN3_PKGS
#
# Output :
# - EIGEN3_FOUND
# - EIGEN3_DEFINITIONS
#
ifndef EIGEN3_MAKE_INCLUDED
EIGEN3_MAKE_INCLUDED:=1

srcdir?=
include $(srcdir)make/build.make

EIGEN3_REQUIRED?=$(false)

EIGEN3_PKGS?=$(shell pkg-config --exists eigen3 && echo eigen3)
#EIGEN3_INC_DIRS?=

CONFIG_VARS+=EIGEN3_PKGS
#EIGEN3_INC_DIRS

EIGEN3_FOUND:=$(shell pkg-config --exists eigen3 && echo $(true))
EIGEN3_DEFINITIONS:=$(if $(EIGEN3_FOUND),HAVE_EIGEN3=1)

.PHONY:eigen3-module-info
eigen3-module-info:
	@$(call em_print_variables,EIGEN3_FOUND EIGEN3_PKGS EIGEN3_DEFINITIONS EIGEN3_REQUIRED)

module-info:eigen3-module-info

EIGEN3_MAKE_DEPS:=$(srcdir)make/build.make $(BUILD_MAKE_DEPS)

endif # EIGEN3_MAKE_INCLUDED

ifneq ($(EIGEN3_REQUIRED),)
ifeq ($(EIGEN3_FOUND),)
$(error Eigen 3 not found (EIGEN3_PKGS=$(EIGEN3_PKGS)))
endif
endif
