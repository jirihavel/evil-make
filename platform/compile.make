# vim: set ft=make:
#input :
# EM_NAME
#output :
# EM_OBJPATH

# Compile PIC versions in <config>-pic
ifneq ($(HAVE_PIC),)
 # obj/[<config>-]pic
 EM_OBJPATH:=$(OBJDIR)/$(if $(CONFIG),$(CONFIG)-)pic
 include $(MAKEDIR)/platform/compile-impl.make
 $(OBJS):PIC:=1
 PIC_OBJS:=$(OBJS)
endif

# Compile default versions in <config>
# obj[/config]
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))
include $(MAKEDIR)/platform/compile-impl.make

# On platforms without PIC, use default versions for both
ifeq ($(HAVE_PIC),)
 PIC_OBJS:=$(OBJS)
endif
# end
