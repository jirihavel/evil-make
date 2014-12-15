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
# OBJS
# DEPS

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

# end
