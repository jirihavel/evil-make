# vim: set ft=make:

##################################################
# Names
##################################################

# Full name of the executable
BIN:=$(BINDIR)/$(NAME)$(SUFFIX)$(BINEXT)

# Linker MAP file can be created during linking
ifneq ($(WANT_MAP),)
 MAP:=$(BIN)$(MAPEXT)
 $(BIN):MAP:=$(MAP)
 $(MAP):$(BIN)
endif

##################################################
# Link
##################################################

EM_CMD:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))/.em/$(NAME)$(SUFFIX).bin.cmd 

# rule specific variables beause of late expansion in commands
$(BIN):EM_PKGS:=$(strip $(PKGS) $(foreach d,$(DEPS),$(EmLibraryPkgs.$d)))
$(BIN):EM_LINK:=$(OBJS) $(LIBS)

# objects + libs from previous linking
# *.link will change only when different from before
$(EM_CMD):always $(foreach d,$(DEPS),$(EmLibraryPkgDeps.$d)) $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call UpdateIfNotEqual,$@,$(Link.bin) $(EM_LINK) $(if $(EM_PKGS),$(shell $(PKG_CONFIG) --libs $(EM_PKGS))))

$(BIN):$(foreach d,$(DEPS),$(EmLibraryDeps.$d)) $(OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.bin) $(EM_LINK) $(if $(EM_PKGS),$(shell $(PKG_CONFIG) --libs $(EM_PKGS)))
	@objcopy --only-keep-debug $@ $@$(DBGEXT)
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@$(DBGEXT) $@

EM_OBJPATH:=
EM_CMD:=
EM_LIB_DEPS:=

##################################################
# Targets
##################################################

em-$(NAME):$(BIN)

em-installdirs-$(NAME):    em-installdirs-bindir
em-installdirs-$(NAME)-dev:em-installdirs-$(NAME)

# Internal rule that does the instalation
em-do-install-$(NAME):$(BIN)
	$(INSTALL_PROGRAM) $< $(DESTDIR)$(bindir)
.PHONY:em-do-install-$(NAME)

em-install-$(NAME):    em-do-install-$(NAME)
em-install-$(NAME)-dev:em-install-$(NAME)

# Hook DEPS to rules
EM_NAME:=$(NAME)
include $(MAKEDIR)/platform/install.make

ifneq ($(WANT_TARGET),)
 $(NAME):em-$(NAME)
 .PHONY:$(NAME)

 installdirs-$(NAME):em-installdirs-$(NAME)
 .PHONY:installdirs-$(NAME)

 install-$(NAME):em-install-$(NAME)
 .PHONY:install-$(NAME)
endif
# end
