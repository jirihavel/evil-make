# vim: set ft=make:

DLL:=$(DLLDIR)/$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT)

# Generate IMP and DEF on windows or SONAME on unix
# - system dependent (on unix, IMP=DLL)
# - all rules depend on DLL
include $(MAKEDIR)/system/$(SYSTEM_KIND)/dll-names.make

ifneq ($(PKG_IN),)
 include $(MAKEDIR)/platform/pkg.make
 $(LIB):$(PKG)
endif

# Linker MAP file can be created during linking
# - set MAP variable, so the compiler can detect it
ifneq ($(WANT_MAP),)
 MAP:=$(DLL)$(MAPEXT)
 $(DLL):MAP:=$(MAP)
 $(MAP):$(DLL)
endif

# Enforce PIC in object files
# - not set for DLL so it does not propagate to other dependencies
$(OBJS):WANT_PIC:=$(HAVE_PIC)

# -- Link --

# Library names for DEPS
EM_LIB_DEPS:=$(foreach d,$(DEPS),$(EmLibraryPieces.$d))

EM_CMD:=$(OBJDIR)/lib$(NAME)$(SUFFIX).dll.cmd

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(DLL):EM_LINK:=$(OBJS) $(LIBS) $(EM_LIB_DEPS) $(if $(PKGS),$(shell $(PKG_CONFIG) --libs $(PKGS)))

# *.cmd will change only when different from before
$(EM_CMD):always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call UpdateIfNotEqual,$@,$(Link.dll) $(EM_LINK))

# Link
$(DLL):$(EM_LIB_DEPS) $(OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.dll) $(EM_LINK)
	@objcopy --only-keep-debug $@ $@.debug
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@.debug $@

EM_LIB_DEPS:=
EM_CMD:=

##################################################
# Install
##################################################

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
 lib$(NAME):$(DLL)
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
