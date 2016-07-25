############################################################################
# Initialize the build platform
############################################################################
# - copy&paste this to any new Makefile, !!! modify include !!!
# autodetect <srcdir> as the path to this Makefile
ifndef srcdir
 srcdir:=$(dir $(lastword $(MAKEFILE_LIST)))
endif
# include the platform header
# - it includes config.make and may overwrite anything set before
include $(srcdir)../../build.make
# - now we can use "include $(makedir)..."
# - platform initialized, end of copy&paste

#-------------------------
# -- FOO --
#-------------------------

# Take all source files
FOO_SRCS:=$(wildcard $(srcdir)foo/*.c)
# Compile them to object files
# - dependencies are tracked automatically
FOO_OBJS:=$(call em_compile,$(FOO_SRCS))
# Link executable "foo" (e.g. foo.exe)
FOO:=$(call em_link_bin,foo,$(FOO_OBJS))

all:$(FOO)

# Create all [un]install rules
# - install[dirs][-foo]
# - install[-foo]-stripped
# - uninstall[-foo]
$(call em_install_bin,foo,$(FOO))

#-------------------------
# -- BAR --
#
# Setting parameters
#-------------------------

# Parameter pack
BAR_FLG:=$(call em_flags,bar)
$(BAR_FLG):INCLUDE_DIRS:=$(srcdir)include
$(BAR_FLG):DEFINITIONS:=NUMBER=42

BAR_SRCS:=$(wildcard $(srcdir)bar/*.c)
# Compile with parameter pack
BAR_OBJS:=$(call em_compile,$(BAR_SRCS),$(BAR_FLG))
BAR:=$(call em_link_bin,bar,$(BAR_OBJS))

all:$(BAR)

$(call em_install_bin,bar,$(BAR))

#-------------------------
# -- BAZ --
#
# Using modules
#-------------------------

# We want modules :
# - libc (some info about C standard library)
# - sdl2
include $(makedir)libc.make
include $(makedir)sdl2.make

BAZ_FLG:=$(call em_flags,baz)

BAZ_SRCS:=$(wildcard $(srcdir)baz/*.c)
BAZ_OBJS:=$(call em_compile,$(BAZ_SRCS),$(BAZ_FLG))
BAZ:=$(call em_link_bin,baz,$(BAZ_OBJS),$(BAZ_LIBS))

# - rule specific variables propagate, so the compilation will use these modules too
$(BAZ):MODULES:=LIBC SDL2

all:$(BAZ)

$(call em_install_bin,baz,$(BAZ))

# Module MOD exports :
# MOD_MODULES - dependencies (other modules)
# MOD_PACKAGES - pkg-config packages
# MOD_INCLUDE_DIRS - -I
# MOD_LIBRARY_DIRS - -L
# MOD_DEFINITIONS - -D
# MOD_LIBRARIES - other linker params
#
