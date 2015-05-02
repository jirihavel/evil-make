# vim: set ft=make: 
#NAME,MAJOR_VERSION,MINOR_VERSION,PATCH_VERSION
#PKG_IN
#->PKG

PKG:=$(LIBDIR)/pkgconfig/lib$(NAME)$(SUFFIX).pc

EM_PKG_SED:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))/.em/lib$(NAME)$(SUFFIX).pc.sed

# <major>[.<minor>][.<patch>]
$(PKG) em-install-pkg$(NAME):EM_VERSION:=$(MAJOR_VERSION)$(if $(MINOR_VERSION),.$(MINOR_VERSION))$(if $(PATCH_VERSION),.$(PATCH_VERSION))
$(PKG) em-install-pkg$(NAME):EM_PKG_SED:=$(EM_PKG_SED)

# -- build --

$(EM_PKG_SED):always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call em_write_ne,$@,s|@VERSION@|$(EM_VERSION)|g)
#	@echo 's|@VERSION@|$(EM_VERSION)|g

$(PKG):$(PKG_IN) $(EM_PKG_SED) $(EM_PKG_BUILDDIRS_SED) $$(@D)/.f
	$(if $(VERBOSE),,@)sed -f $(EM_PKG_SED) -f $(EM_PKG_BUILDDIRS_SED) $< > $@

# -- install --

em-install-pkg$(NAME):EM_PKG:=$(DESTDIR)$(libdir)/pkgconfig/lib$(NAME)$(SUFFIX).pc
em-install-pkg$(NAME):$(PKG_IN) $(EM_PKG_SED) $(EM_PKG_INSTALLDIRS_SED)
	sed -f $(EM_PKG_SED) -f $(EM_PKG_INSTALLDIRS_SED) $< > $(EM_PKG)
.PHONY:em-install-pkg$(NAME)

em-installdirs-lib$(NAME)-dev:em-installdirs-pkgdir
em-install-lib$(NAME)-dev:em-install-pkg$(NAME)

EM_PKG_SED:=
# end
