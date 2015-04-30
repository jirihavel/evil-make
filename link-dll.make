# vim: set ft=make:

##################################################
# Names
##################################################

DLL:=$(DLLDIR)/$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT)

# Generate IMP and DEF on windows or SONAME on unix
# - system dependent (on unix, IMP=DLL)
# - all rules depend on DLL
include $(MAKEDIR)/system/$(SYSTEM_KIND)/dll-names.make

ifneq ($(PKG_IN),)
 include $(MAKEDIR)/platform/pkg.make
else
 PKG:=
endif

# Enforce PIC in object files (if necessary)
# - not set for DLL so it does not propagate to other dependencies
$(OBJS):WANT_PIC:=$(HAVE_PIC)

EM_BIN:=$(DLL)
EM_CMD:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))/.em/lib$(NAME)$(SUFFIX).dll.cmd	

##################################################
# Link
##################################################

# Linker MAP file can be created during linking
# - set MAP variable, so the compiler can detect it
ifneq ($(WANT_MAP),)
 MAP:=$(EM_BIN)$(MAPEXT)
 $(EM_BIN):MAP:=$(MAP)
 $(MAP):$(EM_BIN)
endif

$(EM_BIN):EM_PKGS:=$(strip $(PKGS) $(foreach d,$(DEPS),$(EmLibraryPkgs.$d))) 
$(EM_BIN):EM_LINK:=$(OBJS) $(LIBS)

# *.cmd will change only when different from before
$(EM_CMD):always $(foreach d,$(DEPS),$(EmLibraryPkgDeps.$d)) $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call UpdateIfNotEqual,$@,$(Link.dll) $(EM_LINK) $(if $(EM_PKGS),$(shell $(PKG_CONFIG) --libs $(EM_PKGS))))

# Link
$(EM_BIN):$(foreach d,$(DEPS),$(EmLibraryDeps.$d)) $(OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.dll) $(EM_LINK) $(if $(EM_PKGS),$(shell $(PKG_CONFIG) --libs $(EM_PKGS)))
	@objcopy --only-keep-debug $@ $@.debug
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@.debug $@

EM_BIN:=
EM_CMD:=

# -- Register library --

EmLibraryDeps.lib$(NAME).dll:=$(DLL) $(LIB)
EmLibraryPkgs.lib$(NAME).dll:=$(PKG)
EmLibraryPkgDeps.lib$(NAME).dll:=$(PKG) $(foreach d,%(DEPS),$(EmLibraryPkgDeps.$d))

EmLibraryDeps.lib$(NAME):=$(EmLibraryDeps.lib$(NAME).dll)
EmLibraryPkgs.lib$(NAME):=$(EmLibraryPkgs.lib$(NAME).dll)
EmLibraryPkgDeps.lib$(NAME):=$(EmLibraryPkgDeps.lib$(NAME).dll)

##################################################
# Install
##################################################

em-lib$(NAME):$(DLL) $(LIB)

# DLL installation rules from dll-names
.PHONY:em-install-dll$(NAME) em-install-dll$(NAME)-dev

em-installdirs-lib$(NAME):    em-installdirs-dlldir
em-installdirs-lib$(NAME)-dev:em-installdirs-dlldir em-installdirs-libdir

em-install-lib$(NAME):    em-install-dll$(NAME)
em-install-lib$(NAME)-dev:em-install-dll$(NAME) em-install-dll$(NAME)-dev

# Hook DEPS to rules
EM_NAME:=lib$(NAME)
include $(MAKEDIR)/platform/install.make

# install
ifneq ($(WANT_TARGET),)
 lib$(NAME):em-lib$(NAME)
 .PHONY:lib$(NAME)

 installdirs-lib$(NAME):em-installdirs-lib$(NAME)
 .PHONY:installdirs-lib$(NAME)

 installdirs-lib$(NAME)-dev:em-installdirs-lib$(NAME)-dev
 .PHONY:installdirs-lib$(NAME)-dev

 install-lib$(NAME):em-install-lib$(NAME)
 .PHONY:install-lib$(NAME)

 install-lib$(NAME)-dev:em-install-lib$(NAME)-dev
 .PHONY:install-lib$(NAME)-dev
endif
# end
