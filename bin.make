# vim: set ft=make:
#config :
# VERBOSE
# SRCDIR, OBJDIR, BINDIR
# DEPEXT, OBJEXT, BINEXT
# CONFIG, SUFFIX
# WANT_MAP, WANT_TARGET
#input :
# NAME
# SRCS
# PKGS
# FLAGS
# ADD_OBJS
# LIBS
#output :
# OBJS
# BIN - executable name
# MAP - linker map

# Full name of the executable
BIN:=$(BINDIR)/$(NAME)$(SUFFIX)$(BINEXT)

# Linker MAP file can be created during linking
ifneq ($(WANT_MAP),)
 MAP:=$(BIN).map
 $(BIN):MAP:=$(MAP)
 $(MAP):$(BIN)
endif

##################################################
# Compilation
##################################################

# compile as nonpic
# - create <name>.{c,cpp,...}.cmd files

# internal enhanced name
EM_NAME:=$(NAME)

# compile (sets OBJS and EM_OBJPATH)
include $(MAKEDIR)/platform/compile.make

EM_NAME:=

# additional compiled files
OBJS+=$(ADD_OBJS)

##################################################
# Linking
##################################################

# get library names for DEPS
EM_LIB_DEPS:=$(foreach d,$(DEPS),$(EmLibraryPieces.$d))

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(BIN):EM_LINK:=$(OBJS) $(LIBS) $(EM_LIB_DEPS) $(if $(PKGS),$(shell $(PKG_CONFIG) --libs $(PKGS)))

# objects + libs from previous linking
# *.link will change only when different from before
EM_CMD:=$(EM_OBJPATH)/$(NAME)$(SUFFIX).bin.cmd 
$(EM_CMD):always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	$(call updateIfNotEqual,$(Link.bin) $(EM_LINK))

$(BIN):$(EM_LIB_DEPS) $(OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.bin) $(EM_LINK)
	@objcopy --only-keep-debug $@ $@.debug
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@.debug $@

##################################################
# Targets
##################################################

em-$(NAME):$(BIN)
.PHONY:em-$(NAME)

em-installdirs-$(NAME):em-installdirs-bindir
em-installdirs-$(NAME):$(foreach d,$(DEPS),em-installdirs-$(basename $d))
.PHONY:em-installdirs-$(NAME)

em-installdirs-$(NAME)-dev:em-installdirs-bindir
em-installdirs-$(NAME)-dev:$(foreach d,$(DEPS),em-installdirs-$(basename $d)-dev)
.PHONY:em-installdirs-$(NAME)-dev

# internal rule that does the instalation
em-do-install-$(NAME):$(BIN)
	$(INSTALL_PROGRAM) $< $(DESTDIR)$(bindir)
.PHONY:em-do-install-$(NAME)

em-install-$(NAME):em-do-install-$(NAME)
em-install-$(NAME):$(foreach d,$(DEPS),em-install-$(basename $d))
.PHONY:em-install-$(NAME)

em-install-$(NAME)-dev:em-do-install-$(NAME)
em-install-$(NAME)-dev:$(foreach d,$(DEPS),em-install-$(basename $d)-dev)
.PHONY:em-install-$(NAME)-dev

ifneq ($(WANT_TARGET),)
 $(NAME):em-$(NAME)
 .PHONY:$(NAME)

 installdirs-$(NAME):em-installdirs-$(NAME)
 .PHONY:installdirs-$(NAME)

 install-$(NAME):em-install-$(NAME)
 .PHONY:install-$(NAME)
endif
# end
