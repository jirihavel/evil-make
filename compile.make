# vim: set ft=make:
#input :
# VERBOSE
# SRCDIR, OBJDIR
# DEPEXT, OBJEXT
# CONFIG
# NAME
# SRCS
# TODO : DEPS
# PKGS
# FLAGS
#output:
# OBJS + PIC_OBJS

# Compile PIC versions in <config>-pic
ifneq ($(HAVE_PIC),)
 # obj/[<config>-]pic
 EM_OBJPATH:=$(OBJDIR)/$(if $(CONFIG),$(CONFIG)-)pic
 include $(MAKEDIR)/common/compile.make
 $(OBJS):PIC:=1
 PIC_OBJS:=$(OBJS)
endif

# Compile default versions in <config>
# obj[/config]
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))
include $(MAKEDIR)/common/compile.make

# On platforms without PIC, use default versions for both
ifeq ($(HAVE_PIC),)
 PIC_OBJS:=$(OBJS)
endif
# end
