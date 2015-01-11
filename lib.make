# vim: set ft=make:
# Creates rules for static library.
# - WANT_TARGET : lib<name>, installdirs-lib<name>-dev, install-lib<name>
# On platforms with PIC also creates rules for PIC version.
# On platforms without PIC, PIC_LIB equals LIB
#config :
# VERBOSE
# SRCDIR, OBJDIR, LIBDIR
# DEPEXT, OBJEXT, LIBEXT
# CONFIG, SUFFIX
# WANT_TARGET
#input :
# NAME
# SRCS
# TODO : DEPS
# PKGS
# FLAGS
#outputs :
# OBJS + PIC_OBJS
# LIB  + PIC_LIB  (These are important)
# * <libdir>/lib<name>[-<suffix>].a
# * <libdir>/lib<name>[-<suffix>].pic.a (optional pic version)

##################################################
# Compilation
##################################################

# compile sources, optionally pic
# - create [...pic/]lib<name>.{c,cpp,...}.cmd files

# internal enhanced name
EM_NAME:=lib$(NAME)

# compile (sets OBJS, PIC_OBJS)
include $(MAKEDIR)/platform/compile.make

EM_NAME:=

##################################################
# Linking
##################################################

# link PIC version <libdir>/lib<name>[-<suffix>].pic.a
ifneq ($(HAVE_PIC),)
 # obj/[config-]pic
 EM_OBJPATH:=$(OBJDIR)/$(if $(CONFIG),$(CONFIG)-)pic
 EM_OBJS:=$(PIC_OBJS)
 LIB:=$(LIBDIR)/lib$(NAME)$(SUFFIX).pic$(LIBEXT)
 include $(MAKEDIR)/platform/lib.make
 PIC_LIB:=$(LIB)
endif

# link default version <libdir>/lib<name>[-<suffix>].pic.a
# obj[/config]
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))
EM_OBJS:=$(OBJS)
LIB:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(LIBEXT)
include $(MAKEDIR)/platform/lib.make

# on platforms without PIC, use nonpic version
ifeq ($(HAVE_PIC),)
 PIC_LIB:=$(LIB)
endif

##################################################
# Register library
##################################################

EmLibraryPieces.lib$(NAME):=$(LIB)
EmLibraryPieces.lib$(NAME).pic:=$(PIC_LIB)

##################################################
# Targets
##################################################

em-installdirs-lib$(NAME):$(foreach d,$(DEPS),em-installdirs-$(basename $d))
.PHONY:em-installdirs-lib$(NAME)

em-installdirs-lib$(NAME)-dev:em-installdirs-libdir
em-installdirs-lib$(NAME)-dev:$(foreach d,$(DEPS),em-installdirs-$(basename $d)-dev)
.PHONY:em-installdirs-lib$(NAME)-dev

em-install-lib$(NAME):$(foreach d,$(DEPS),em-install-$(basename $d))
.PHONY:em-install-lib$(NAME)

# internal rule to optionally install PIC version
em-install-pic$(NAME):$(PIC_LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
.PHONY:em-install-pic$(NAME)

# internal rule that does the instalation
em-install-lib$(NAME)-dev:$(LIB) $(if $(HAVE_PIC), em-install-pic$(NAME))
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
em-install-lib$(NAME)-dev:$(foreach d,$(DEPS),em-install-$(basename $d)-dev)
.PHONY:em-install-lib$(NAME)-dev

ifneq ($(WANT_TARGET),)
 lib$(NAME):$(LIB) $(PIC_LIB)
 .PHONY:lib$(NAME)

 installdirs-lib$(NAME)-dev:em-installdirs-lib$(NAME)-dev
 .PHONY:installdirs-lib$(NAME)-dev

 install-lib$(NAME)-dev:em-install-lib$(NAME)-dev
 .PHONY:install-lib$(NAME)-dev
endif
# end
