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
# Linking
##################################################

EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))

EM_CMD:=$(EM_OBJPATH)/$(NAME)$(SUFFIX).bin.cmd 

# Get library names for DEPS
# - these are dependencies of BIN
EM_LIB_DEPS:=$(foreach d,$(DEPS),$(EmLibraryPieces.$d))

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(BIN):EM_LINK:=$(OBJS) $(LIBS) $(if $(PKGS),$(shell $(PKG_CONFIG) --libs $(PKGS)))

# objects + libs from previous linking
# *.link will change only when different from before
$(EM_CMD):always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call UpdateIfNotEqual,$@,$(Link.bin) $(EM_LINK))

$(BIN):$(EM_LIB_DEPS) $(OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.bin) $(EM_LINK)
	@objcopy --only-keep-debug $@ $@$(DBGEXT)
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@$(DBGEXT) $@

EM_OBJPATH:=
EM_CMD:=
EM_LIB_DEPS:=

##################################################
# Targets
##################################################

em-installdirs-$(NAME):    em-installdirs-bindir
em-installdirs-$(NAME)-dev:em-installdirs-bindir

# Internal rule that does the instalation
em-do-install-$(NAME):$(BIN)
	$(INSTALL_PROGRAM) $< $(DESTDIR)$(bindir)
.PHONY:em-do-install-$(NAME)

em-install-$(NAME):    em-do-install-$(NAME)
em-install-$(NAME)-dev:em-do-install-$(NAME)

# Hook DEPS to rules
EM_NAME:=$(NAME)
include $(MAKEDIR)/platform/install.make

ifneq ($(WANT_TARGET),)
 $(NAME):$(BIN)
 .PHONY:$(NAME)

 installdirs-$(NAME):em-installdirs-$(NAME)
 .PHONY:installdirs-$(NAME)

 install-$(NAME):em-install-$(NAME)
 .PHONY:install-$(NAME)
endif
# end
