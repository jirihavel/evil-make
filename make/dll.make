# vim: set ft=make:
#input :
# MAJOR_VERSION (backward incompatible)
# MINOR_VERSION (forward incompatible)
# PATCH_VERSION (bugfixes)
# SRCDIR, OBJDIR, DLLDIR, LIBDIR
# NAME
# ?TARGET
# SRCS, RESOURCES
# ADD_OBJS
# PKGS, FLAGS, LIBS
#output :
# OBJS
# DLL - for runtime
# LIB - for linking, depends on $(DLL)
# PKG - pkg-config file (TODO)

include make/compiler/$(COMPILER_KIND)/dll.make

$(DLL):CompilerFlags+=DLL_FLAGS
# end
