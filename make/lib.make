# vim: set ft=make:
# Creates rules for static library.
# On platforms with PIC also creates rules for PIC version.
# On platforms without PIC, PIC_LIB equals LIB
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
# OBJS + PIC_OBJS
# LIB  + PIC_LIB

# compile (sets OBJS, PIC_OBJS)
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

# on platforms without PIC, use nonpic version
ifeq ($(HAVE_PIC),)
 PIC_LIB:=$(LIB)
endif

# register libraries for DEPS
Libraries.$(NAME).lib:=$(LIB)
Libraries.$(NAME).pic:=$(PIC_LIB)

ifneq ($(TARGET),)
 # build rules
 .PHONY:$(TARGET)
 $(TARGET):$(LIB) $(PIC_LIB)

 # internal install-dev implementation
 .PHONY:em-install-$(TARGET)-dev
 em-install-$(TARGET)-dev:$(LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)

 # hook internal install to install rule
 .PHONY:install-$(TARGET)-dev
 install-$(TARGET)-dev:em-install-$(TARGET)-dev

 TARGET:=
endif
# end
