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
include make/compile.make

ifneq ($(HAVE_PIC),)
 # obj/[config-]pic
 EM_OBJPATH:=$(OBJDIR)/$(if $(CONFIG),$(CONFIG)-)pic
 EM_SUFFIX:=.pic
 EM_OBJS:=$(PIC_OBJS)
 include make/lib-common.make
 EM_SUFFIX:=
 PIC_LIB:=$(LIB)
endif

# obj[/config]
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))
EM_OBJS:=$(OBJS)
include make/lib-common.make

ifneq ($(TARGET),)
 .PHONY:$(TARGET) install-$(TARGET)-dev internal-install-$(TARGET)-dev

 $(TARGET):$(LIB)

 internal-install-$(TARGET)-dev:$(LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)

 install-$(TARGET)-dev:internal-install-$(TARGET)-dev

 TARGET:=
endif
# end
