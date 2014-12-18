# vim: set ft=make:
#input :
# SRCDIR, OBJDIR, BINDIR
# DEPEXT, OBJEXT, BINEXT
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

# compile (sets OBJS and EM_OBJPATH)
include $(MAKEDIR)/compile.make

OBJS+=$(ADD_OBJS)

EM_DEPS:=$(foreach d,$(DEPS),$(Libraries.$d))

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(BIN):EM_LINK:=$(OBJS) $(LIBS) $(EM_DEPS) $(if $(PKGS),$(shell pkg-config $(PKGS) --libs))

# objects + libs from previous linking
# *.link will change only when different from before
EM_CMD:=$(EM_OBJPATH)/$(NAME)$(SUFFIX).bin.cmd 
$(EM_CMD):always $$(@D)/.f
	$(call updateIfNotEqual,$(Link.bin) $(EM_LINK))

$(BIN):$(OBJS) $(EM_CMD) $(EM_DEPS) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.bin) $(EM_LINK)
	@objcopy --only-keep-debug $@ $@.debug
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@.debug $@

# hook all dependencies to the executable
$(BIN):$(foreach d,$(DEPS),$(Dependencies.$d))

# register the executable name
Dependencies.$(NAME):=$(BIN)

##################################################
# Installation
##################################################

em-installdirs-$(NAME):em-installdirs-bindir
em-installdirs-$(NAME):$(foreach d,$(DEPS),$(Dependencies.installdirs.$d))
.PHONY:em-installdirs-$(NAME)

# internal rule that does the instalation
em-install-$(NAME):$(BIN) $(foreach d,$(DEPS),$(Dependencies.install.$d))
	$(INSTALL_PROGRAM) $< $(DESTDIR)$(bindir)
.PHONY:em-install-$(NAME)

# register install rule for DEPS
Dependencies.installdirs.$(NAME):=em-installdirs-$(NAME)
Dependencies.install.$(NAME):=em-install-$(NAME)

ifneq ($(WANT_TARGET),)
 $(NAME):$(BIN)
 .PHONY:$(NAME)

 installdirs-$(NAME):em-installdirs-$(NAME)
 .PHONY:installdirs-$(NAME)

 install-$(NAME):em-install-$(NAME)
 .PHONY:install-$(NAME)
endif
# end
