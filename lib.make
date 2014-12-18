# vim: set ft=make:
# Creates rules for static library.
# On platforms with PIC also creates rules for PIC version.
# On platforms without PIC, PIC_LIB equals LIB
#input :
# VERBOSE
# SRCDIR, OBJDIR, LIBDIR
# DEPEXT, OBJEXT, LIBEXT
# CONFIG, SUFFIX
# NAME
# ?TARGET
# SRCS
# TODO : DEPS
# PKGS
# FLAGS
#outputs :
# OBJS + PIC_OBJS
# LIB  + PIC_LIB
# * <libdir>/lib<name>[-<suffix>].a
# * <libdir>/lib<name>[-<suffix>].pic.a (optional pic version)

# compile (sets OBJS, PIC_OBJS)
include $(MAKEDIR)/compile.make

# link PIC version <libdir>/lib<name>[-<suffix>].pic.a
ifneq ($(HAVE_PIC),)
 # obj/[config-]pic
 EM_OBJPATH:=$(OBJDIR)/$(if $(CONFIG),$(CONFIG)-)pic
 LIB:=$(LIBDIR)/lib$(NAME)$(SUFFIX).pic$(LIBEXT)
 $(LIB):EM_OBJS:=$(PIC_OBJS)
 include $(MAKEDIR)/common/lib.make
 PIC_LIB:=$(LIB)
endif

# link default version <libdir>/lib<name>[-<suffix>].pic.a
# obj[/config]
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))
LIB:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(LIBEXT)
$(LIB):EM_OBJS:=$(OBJS)
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

 installdirs-$(TARGET)-dev:em-installdirs-libdir

 # hook internal install to install rule
 .PHONY:install-$(TARGET)-dev
 install-$(TARGET)-dev:em-install-$(TARGET)-dev

 TARGET:=
endif
# end
