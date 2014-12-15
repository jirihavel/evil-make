# vim: set ft=make:
#input :
# VERBOSE
# SRCDIR, OBJDIR
# DEPEXT, OBJEXT
# CONFIG
# NAME
# SRCS
# PKGS
# FLAGS
#output:
# OBJS + PIC_OBJS
# DEPS + PIC_DEPS

ifneq ($(HAVE_PIC),)
 # obj/[config-]pic
 EM_OBJPATH:=$(OBJDIR)/$(if $(CONFIG),$(CONFIG)-)pic
 include $(MAKEDIR)/common/compile.make
 $(OBJS):PIC:=1
 PIC_OBJS:=$(OBJS)
 PIC_DEPS:=$(DEPS)
endif

# obj[/config]
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))
include $(MAKEDIR)/common/compile.make

# On platforms without PIC, use nonpic for both
ifeq ($(HAVE_PIC),)
 PIC_OBJS:=$(OBJS)
 PIC_DEPS:=$(DEPS)
endif
# end
