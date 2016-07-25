# vim: set ft=make:
ifndef SDL_MAKE_INCLUDED
SDL_MAKE_INCLUDED:=1

srcdir?=
include $(srcdir)make/build.make

# SDL 1

SDL_DYN_LINK?=$(false)
SDL_INC_DIRS?=
SDL_LIB_DIRS?=

WANT_SDL_MAIN?=$(false)
WANT_SDL_IMAGE?=$(true)

CONFIG_VARS+=SDL_DYN_LINK SDL_INC_DIRS SDL_LIB_DIRS WANT_SDL_MAIN WANT_SDL_IMAGE

SDL_LIB_SUFFIX:=$(if $(call and,$(HAVE_OS_WINDOWS),$(SDL_DYN_LINK)),.dll)

SDL_CPPFLAGS:=$(call em_compiler_inc_dirs,$(SDL_INC_DIRS))
SDL_LDLIBS:=$(call em_compiler_lib_dirs,$(SDL_LIB_DIRS))

SDL2_CPPFLAGS:=$(call em_compiler_inc_dirs,$(SDL_INC_DIRS))
SDL2_LDLIBS:=$(call em_compiler_lib_dirs,$(SDL_LIB_DIRS))

SDL_LIB:=SDL$(SDL_LIB_SUFFIX)
SDL2_LIB:=SDL2$(SDL_LIB_SUFFIX)

SDL_IMG_LIB:=SDL_image$(SDL_LIB_SUFFIX)
SDL2_IMG_LIB:=SDL2_image$(SDL_LIB_SUFFIX)

SDL_CONFIG_FLAGS:=$(SDL_CPPFLAGS) $(SDL_LDLIBS)
SDL2_CONFIG_FLAGS:=$(SDL2_CPPFLAGS) $(SDL2_LDLIBS)

obj/make/sdl.make:| $$(@D)/.f
	@echo Checking sdl
	$(file >$@) $(file >$@.err)
	-@$(CC) -o obj/make/sdl1$(BINEXT) $(srcdir)make/sdl/sdl1.c $(SDL_CONFIG_FLAGS) -l$(SDL_LIB) 2>>$@.err \
		&& echo HAVE_SDL1:=$(true) >>$@
	-@$(CC) -o obj/make/sdl1_image$(BINEXT) $(srcdir)make/sdl/sdl1_image.c $(SDL_CONFIG_FLAGS) -l$(SDL_IMG_LIB) -l$(SDL_LIB) 2>>$@.err \
		&& echo HAVE_SDL1_IMAGE:=$(WANT_SDL_IMAGE) >>$@
	-@$(CC) -o obj/make/sdl2$(BINEXT) $(srcdir)make/sdl/sdl2.c $(SDL2_CONFIG_FLAGS) -l$(SDL2_LIB) 2>>$@.err \
		&& echo HAVE_SDL2:=$(true) >>$@
	-@$(CC) -o obj/make/sdl2_image$(BINEXT) $(srcdir)make/sdl/sdl2_image.c $(SDL2_CONFIG_FLAGS) -l$(SDL2_IMG_LIB) -l$(SDL2_LIB) 2>>$@.err \
		&& echo HAVE_SDL2_IMAGE:=$(WANT_SDL_IMAGE) >>$@
	@cat $@

include obj/make/sdl.make

# SDL 1

HAVE_SDL1?=$(false)
HAVE_SDL1_IMAGE?=$(false)

SDL_CPPFLAGS+=$(if $(HAVE_SDL),-DHAVE_SDL=1) $(if $(HAVE_SDL_IMAGE),-DHAVE_SDL_IMAGE=1)
SDL_LDLIBS+=$(if $(HAVE_SDL_IMAGE),-l$(SDL_IMG_LIB)) -l$(SDL_LIB)

# SDL 2

HAVE_SDL2?=$(false)
HAVE_SDL2_IMAGE?=$(false)

SDL2_CPPFLAGS+=$(if $(HAVE_SDL2),-DHAVE_SDL=1) $(if $(HAVE_SDL2_IMAGE),-DHAVE_SDL_IMAGE=1)
SDL2_LDLIBS+=$(if $(HAVE_SDL2_IMAGE),-l$(SDL2_IMG_LIB)) -l$(SDL2_LIB)

endif # SDL_MAKE_INCLUDED
