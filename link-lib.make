# vim: set ft=make:

LIB:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(LIBEXT)

ifneq ($(PKG_IN),)
 include $(MAKEDIR)/platform/pkg.make
 $(LIB):$(PKG)
endif

# -- Link library --

EM_CMD:=$(OBJDIR)/lib$(NAME)$(SUFFIX).lib.cmd
EM_LIB:=$(LIB)

include $(MAKEDIR)/platform/link-lib-pic.make

# -- Register library --

EmLibraryPieces.lib$(NAME).lib:=$(LIB)

##################################################
# Install
##################################################

em-installdirs-lib$(NAME)-dev:em-installdirs-libdir

# internal rule that does the instalation
em-install-lib$(NAME)-dev:$(LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)

# Hook DEPS to rules
EM_NAME:=lib$(NAME)
include $(MAKEDIR)/platform/install.make

ifneq ($(WANT_TARGET),)
 lib$(NAME):$(LIB)
 .PHONY:lib$(NAME)

 installdirs-lib$(NAME)-dev:em-installdirs-lib$(NAME)-dev
 .PHONY:installdirs-lib$(NAME)-dev

 install-lib$(NAME)-dev:em-install-lib$(NAME)-dev
 .PHONY:install-lib$(NAME)-dev
endif
# end
