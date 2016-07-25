# vim: set ft=make:
ifndef GLM_MAKE_INCLUDED
GLM_MAKE_INCLUDED:=1

srcdir?=
include $(srcdir)make/build.make

GLM_PKGS?=$(shell pkg-config --exists glm && echo glm)
GLM_INCLUDE_DIRS?=

CONFIG_VARS+=GLM_PKGS GLM_INCLUDE_DIRS

GLM_MAKE_DEPS:=$(srcdir)make/build.make $(srcdir)make/glm.make

obj/make/glm.make:$(GLM_MAKE_DEPS) $(srcdir)make/glm/glm.cpp | $$(@D)/.f
	@echo Checking glm :
	$(file >$@) $(file >$@.err)
	-@$(CXX) -o obj/make/glm$(BINEXT) $(srcdir)make/glm/glm.cpp\
		$(if $(GLM_PKGS),$(shell pkg-config --cflags --libs $(GLM_PKGS))) \
		$(call em_compiler_inc_dirs,$(GLM_INCLUDE_DIRS))\
		2>>$@.err && echo GLM_FOUND:=$(true) >> $@
	@cat $@

include obj/make/glm.make

GLM_FOUND?=$(false)
GLM_DEFINITIONS:=$(if $(GLM_FOUND),HAVE_GLM=1)

.PHONY:glm-module-info
glm-module-info:
	@$(call em_print_variables,GLM_FOUND GLM_PKGS GLM_INCLUDE_DIRS GLM_DEFINITIONS GLM_REQUIRED)

module-info:glm-module-info

endif # GLM_MAKE_INCLUDED

ifneq ($(GLM_REQUIRED),)
ifeq ($(GLM_FOUND),)
$(error GLM not found)
endif
endif
