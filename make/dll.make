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

# compile (sets OBJS + PIC_OBJ)
include $(MAKEDIR)/compile.make

# use PIC objects if system has them
ifneq ($(HAVE_PIC),)
 OBJS:=$(PIC_OBJS)
endif
OBJS+=$(ADD_OBJS)

include $(MAKEDIR)/compiler/$(COMPILER_KIND)/dll.make
# end
