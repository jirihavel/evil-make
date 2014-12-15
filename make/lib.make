# vim: set ft=make:
#input :
# SRCDIR, OBJDIR, LIBDIR
# DEPEXT, OBJEXT, LIBEXT
# CONFIG, SUFFIX
# NAME
# ?TARGET
# SRCS
# PKGS
# FLAGS
#outputs :
# OBJS
# LIB

# compile (sets OBJS, optionally PIC_OBJS)
include $(MAKEDIR)/compile.make

ifneq ($(HAVE_PIC),)
 # obj/[config-]pic
 EM_OBJPATH:=$(OBJDIR)/$(if $(CONFIG),$(CONFIG)-)pic
 EM_SUFFIX:=.pic
 EM_OBJS:=$(PIC_OBJS)
 include $(MAKEDIR)/common/lib.make
 EM_SUFFIX:=
 PIC_LIB:=$(LIB)
endif

# obj[/config]
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))
EM_OBJS:=$(OBJS)
include $(MAKEDIR)/common/lib.make

ifneq ($(TARGET),)
 .PHONY:$(TARGET) em-install-$(TARGET)-dev install-$(TARGET)-dev

 $(TARGET):$(LIB)
 em-install-$(TARGET)-dev:$(LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
 install-$(TARGET)-dev:em-install-$(TARGET)-dev

 ifneq ($(HAVE_PIC),)
  .PHONY:$(TARGET)-pic
  $(TARGET)-pic:$(PIC_LIB)
 endif

TARGET:=
endif
# end
