# vim: set ft=make: 
#PKG_NAME
#PKG_IN
#->PKG

PKG:=$(LIBDIR)/pkgconfig/lib$(NAME)$(SUFFIX).pc

# <major>[.<minor>][.<patch>]
$(PKG) em-install-pkg$(NAME):EM_VERSION:=$(MAJOR_VERSION)$(if $(MINOR_VERSION),.$(MINOR_VERSION))$(if $(PATCH_VERSION),.$(PATCH_VERSION))

EM_PKG_SED:=$(OBJDIR)/lib$(NAME)$(SUFFIX).pc.sed

$(EM_PKG_SED):always $$(@D)/.f
	@echo 's|@VERSION@|$(EM_VERSION)|g' > $@.new
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call MoveIfNotEqual,$@.new,$@)

$(PKG) em-install-pkg$(NAME):EM_PKG_SED:=$(EM_PKG_SED)

$(PKG):$(PKG_IN) $(EM_PKG_SED) $(EM_PKG_BUILDDIRS_SED) $$(@D)/.f
	$(if $(VERBOSE),,@)sed -f $(EM_PKG_SED) -f $(EM_PKG_BUILDDIRS_SED) $< > $@

em-install-pkg$(NAME):EM_PKG:=$(DESTDIR)$(libdir)/pkgconfig/lib$(NAME)$(SUFFIX).pc

em-install-pkg$(NAME):$(PKG_IN) $(EM_PKG_SED) $(EM_PKG_INSTALLDIRS_SED)
	sed -f $(EM_PKG_SED) -f $(EM_PKG_INSTALLDIRS_SED) $< > $(EM_PKG)
.PHONY:em-install-pkg$(NAME)

em-installdirs-lib$(NAME)-dev:em-installdirs-pkgdir
em-install-lib$(NAME)-dev:em-install-pkg$(NAME)

EM_PKG_SED:=
# end
