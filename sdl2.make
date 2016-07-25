# vim: set ft=make:
#
# Parameters :
# - SDL2_REQUIRED
#
# Config :
# - SDL2_PKGS
#
# Output :
# - SDL2_FOUND
#
ifndef SDL2_MAKE_INCLUDED
SDL2_MAKE_INCLUDED:=1

include $(dir $(lastword $(MAKEFILE_LIST)))build.make

SDL2_PACKAGES?=$(shell pkg-config --exists sdl2 && echo sdl2)
SDL2_INCLUDE_DIRS?=
SDL2_LIBRARY_DIRS?=

SDL2_DYNAMIC_LINK?=$(false)

SDL2_WANT_MAIN?=$(true)
SDL2_WANT_IMAGE?=$(true)

CONFIG_VARS+=SDL2_PACKAGES SDL2_DYNAMIC_LINK SDL2_INCLUDE_DIRS SDL2_LIBRARY_DIRS SDL2_WANT_MAIN SDL2_WANT_IMAGE

SDL2_LIB_SUFFIX?=$(if $(call and,$(HAVE_OS_WINDOWS),$(SDL2_DYNAMIC_LINK)),.dll)

SDL2_LIBS?=$(if $(SDL2_PACKAGES),,-lSDL2$(SDL_LIB_SUFFIX))
SDL2_MAIN_LIBS?=$(if $(SDL2_PACKAGES),,-lmingw32 -lSDL2main)
SDL2_IMAGE_LIBS?=-lSDL2_image$(SDL_LIB_SUFFIX)

SDL2_MAKE_FLGS:=$(if $(SDL2_PACKAGES),$(shell pkg-config --cflags --libs $(SDL2_PACKAGES)))
SDL2_MAKE_FLGS+=$(call em_compiler_inc_dirs,$(SDL2_INCLUDE_DIRS))
SDL2_MAKE_FLGS+=$(call em_compiler_lib_dirs,$(SDL2_LIBRARY_DIRS))

$(OBJDIR)make/sdl2.make:$(makedir)sdl2.make $(wildcard $(makedir)sdl2/*.c) | $$(@D)/.f
	@echo Checking sdl2 :
	$(file >$@) $(file >$@.err)
	-@$(CC) -o $(OBJDIR)make/sdl2$(BINEXT) $(makedir)sdl2/sdl2.c $(SDL2_MAKE_FLGS) $(SDL2_LIBS) 2>>$@.err \
		&& $(call em_conv_path,$(OBJDIR)make/sdl2$(BINEXT)) >>$@
	-@$(CC) -o $(OBJDIR)make/sdl2_main$(BINEXT) $(makedir)sdl2/sdl2_main.c -Dmain=SDL_main $(SDL2_MAKE_FLGS) $(SDL2_MAIN_LIBS) $(SDL2_LIBS) 2>>$@.err \
		$(if $(SDL2_WANT_MAIN),&& $(call em_conv_path,$(OBJDIR)make/sdl2_main$(BINEXT)) >>$@)
	-@$(CC) -o $(OBJDIR)make/sdl2_image$(BINEXT) $(makedir)sdl2/sdl2_image.c $(SDL2_MAKE_FLGS) $(SDL2_IMAGE_LIBS) $(SDL2_LIBS) 2>>$@.err \
		$(if $(SDL2_WANT_IMAGE),&& $(call em_conv_path,$(OBJDIR)make/sdl2_image$(BINEXT)) >>$@)
	@cat $@

include $(OBJDIR)make/sdl2.make

# Generate config
SDL2_FOUND?=$(false)
SDL2_MAIN_FOUND?=$(false)
SDL2_IMAGE_FOUND?=$(false)

# PACKAGES, INCLUDE_DIRS, LIBRARY_DIRS already set

# TODO : -DSDL_MAIN_HANDLED

SDL2_DEFINITIONS+=$(if $(SDL2_FOUND),HAVE_SDL2=1) $(if $(SDL2_MAIN_FOUND),HAVE_SDL2_MAIN=1) $(if $(SDL2_IMAGE_FOUND),HAVE_SDL2_IMAGE=1)
SDL2_DEFINITIONS+=$(if $(SDL2_MAIN_FOUND),$(if $(SDL2_PACKAGES),,main=SDL_main),SDL_MAIN_HANDLED)

SDL2_LIBRARIES:=$(if $(SDL2_IMAGE_FOUND),$(SDL2_IMAGE_LIBS)) $(if $(SDL2_MAIN_FOUND),$(SDL2_MAIN_LIBS)) $(SDL2_LIBS)

endif # SDL2_MAKE_INCLUDED
