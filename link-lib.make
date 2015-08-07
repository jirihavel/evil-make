# vim: set ft=make:

LIB:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(LIBEXT)

ifneq ($(PKG_IN),)
 include $(MAKEDIR)/platform/pkg.make
else
 PKG:=
endif

# -- Link library --

EM_CMD:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))/.em/lib$(NAME)$(SUFFIX).lib.cmd
EM_LIB:=$(LIB)

include $(MAKEDIR)/platform/link-archive.make

# -- Register library --

# Propagate library dependencies further
EmLibraryDeps.lib$(NAME).lib:=$(LIB) $(foreach d,$(DEPS),$(EmLibraryDeps.$d))
# .pc contains dependencies inside
EmLibraryPkgs.lib$(NAME).lib:=$(PKG)
# But pkg dependencies need transitive closure
EmLibraryPkgDeps.lib$(NAME).lib:=$(PKG) $(foreach d,$(DEPS),$(EmLibraryPkgDeps.$d))
EmLibrarySrcDeps.lib$(NAME).lib:=

EmLibraryDeps.lib$(NAME):=$(EmLibraryDeps.lib$(NAME).lib)
EmLibraryPkgs.lib$(NAME):=$(EmLibraryPkgs.lib$(NAME).lib)
EmLibraryPkgDeps.lib$(NAME):=$(EmLibraryPkgDeps.lib$(NAME).lib)
EmLibrarySrcDeps.lib$(NAME):=$(EmLibrarySrcDeps.lib$(NAME).lib)

##################################################
# Install
##################################################

em-lib$(NAME):$(LIB)

em-installdirs-lib$(NAME)-dev:em-installdirs-libdir

# Internal rule that does the instalation
em-do-install-lib$(NAME)-dev:$(LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
.PHONY:em-do-install-lib$(NAME)-dev

em-install-lib$(NAME)-dev:em-do-install-lib$(NAME)-dev

# Hook DEPS to rules
EM_NAME:=lib$(NAME)
include $(MAKEDIR)/platform/install.make

ifneq ($(WANT_TARGET),)
 lib$(NAME):em-lib$(NAME)
 .PHONY:lib$(NAME)

 installdirs-lib$(NAME)-dev:em-installdirs-lib$(NAME)-dev
 .PHONY:installdirs-lib$(NAME)-dev

 install-lib$(NAME)-dev:em-install-lib$(NAME)-dev
 .PHONY:install-lib$(NAME)-dev
endif
# end
