# vim: set ft=make:

include $(MAKEDIR)/compile.make

EM_SRCDIR:=$(SRCDIR)$(if $(SRCPATH),/$(SRCPATH))
EM_OBJDIR:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))$(if $(SRCPATH),/$(SRCPATH))
EM_BINDIR:=$(BINDIR)$(if $(BINPATH),/$(BINPATH))

EM_C_SRC:=$(filter %.c,$(SRCS))
EM_CPP_SRC:=$(filter %.cpp,$(SRCS))

EM_C_BIN:=$(patsubst $(EM_SRCDIR)/%.c,$(EM_BINDIR)/%$(BINEXT),$(EM_C_SRC))
EM_CPP_BIN:=$(patsubst $(EM_SRCDIR)/%.cpp,$(EM_BINDIR)/%$(BINEXT),$(EM_CPP_SRC))

BIN:=$(EM_C_BIN) $(EM_CPP_BIN)

EM_CMD:=$(EM_OBJDIR)/.em/$(NAME)$(SUFFIX).bin.cmd 

$(BIN):MAP:=

# rule specific variables beause of late expansion in commands
$(BIN):EM_PKGS:=$(strip $(PKGS) $(foreach d,$(DEPS),$(EmLibraryPkgs.$d)))
$(BIN):EM_LIBS:=$(LIBS)

# check link command
$(EM_CMD):always $(foreach d,$(DEPS),$(EmLibraryPkgDeps.$d)) $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call UpdateIfNotEqual,$@,$(Link.bin) $(EM_LIBS) $(if $(EM_PKGS),$(shell $(PKG_CONFIG) --libs $(EM_PKGS))))

$(EM_C_BIN):$(EM_BINDIR)/%$(BINEXT):$(EM_OBJDIR)/%.c$(OBJEXT) $(foreach d,$(DEPS),$(EmLibraryDeps.$d)) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.bin) $< $(EM_LIBS) $(if $(EM_PKGS),$(shell $(PKG_CONFIG) --libs $(EM_PKGS)))
	@objcopy --only-keep-debug $@ $@$(DBGEXT)
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@$(DBGEXT) $@

# add other c++ extensions
$(EM_CPP_BIN):$(EM_BINDIR)/%$(BINEXT):$(EM_OBJDIR)/%.cpp$(OBJEXT) $(foreach d,$(DEPS),$(EmLibraryDeps.$d)) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.bin) $< $(EM_LIBS) $(if $(EM_PKGS),$(shell $(PKG_CONFIG) --libs $(EM_PKGS)))
	@objcopy --only-keep-debug $@ $@$(DBGEXT)
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@$(DBGEXT) $@

EM_CMD:=
EM_SRCDIR:=
EM_OBJDIR:=
EM_BINDIR:=

EM_C_SRC:=
EM_CPP_SRC:=
EM_C_BIN:=
EM_CPP_BIN:=

include $(MAKEDIR)/platform/install-bin.make
# end
