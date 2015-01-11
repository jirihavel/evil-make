# vim: set ft=make:
#input :
# MAJOR_VERSION (backward incompatible)
# MINOR_VERSION (forward incompatible)
# PATCH_VERSION (bugfixes)
# SRCDIR, OBJDIR, DLLDIR, LIBDIR
# NAME
# ?TARGET
# SRCS, RESOURCES
# ADD_OBJS
# PKGS, FLAGS, LIBS
#output :
# OBJS = PIC_OBJS
# DLL - for runtime
# MAP
# LIB - for linking, depends on $(DLL)
# PKG - pkg-config file (TODO)
# DEF - on windows platform
# SONAME - on unix platform

# generate DLL, LIB, DEF, SONAME
# + rules to make them from $(DLL)
# - all depend on DLL
include $(MAKEDIR)/system/$(SYSTEM_KIND)/dll-names.make

# Linker MAP file can be created during linking
ifneq ($(WANT_MAP),)
 MAP:=$(DLL).map
 $(DLL):MAP:=$(MAP)
 $(MAP):$(DLL)
endif

PKG:=$(LIBDIR)/pkgconfig/$(NAME)$(SUFFIX).pc
# generate PKG
include $(MAKEDIR)/pkg.make
$(PKG):$(LIB)

##################################################
# Compilation
##################################################

# internal enhanced name
EM_NAME:=lib$(NAME)

# compile (sets PIC_OBJS + EM_OBJPATH)
include $(MAKEDIR)/platform/compile.make

EM_NAME:=

# use PIC objects if system has them
OBJS:=$(PIC_OBJS)

##################################################
# Linking
##################################################

# objects + libs from previous linking
#  EM_OBJPATH is set by compile.make
EM_CMD:=$(EM_OBJPATH)/lib$(NAME).dll.cmd

# get library names for DEPS
EM_LIB_DEPS:=$(foreach d,$(DEPS),$(EmLibraryPieces.$d))

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(DLL):EM_LINK:=$(OBJS) $(LIBS) $(EM_LIB_DEPS) $(if $(PKGS),$(shell $(PKG_CONFIG) $(PKGS) --libs))

# *.cmd will change only when different from before
$(EM_CMD):always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	$(call updateIfNotEqual,$(Link.dll) $(EM_LINK))

# link
$(DLL):$(EM_LIB_DEPS) $(OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.dll) $(EM_LINK)
	@objcopy --only-keep-debug $@ $@.debug
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@.debug $@

##################################################
# Register library
##################################################

EmLibraryPieces.lib$(NAME):=$(LIB)
EmLibraryPieces.lib$(NAME).dll:=$(LIB)

##################################################
# Installation
##################################################

em-installdirs-lib$(NAME):em-installdirs-dlldir
em-installdirs-lib$(NAME):$(foreach d,$(DEPS),em-installdirs-$(basename $d))
.PHONY:em-installdirs-$(NAME)

em-installdirs-lib$(NAME)-dev:em-installdirs-dlldir
em-installdirs-lib$(NAME)-dev:em-installdirs-libdir
em-installdirs-lib$(NAME)-dev:$(foreach d,$(DEPS),em-installdirs-$(basename $d)-dev)
.PHONY:em-installdirs-$(NAME)-dev

# create internal rule that does the instalation
include $(MAKEDIR)/system/$(SYSTEM_KIND)/dll-install.make
.PHONY:em-install-dll$(NAME) em-install-dll$(NAME)-dev

em-install-lib$(NAME):em-install-dll$(NAME)
em-install-lib$(NAME):$(foreach d,$(DEPS),em-install-$(basename $d))
.PHONY:em-installdirs-$(NAME)

em-install-lib$(NAME)-dev:em-install-dll$(NAME)
em-install-lib$(NAME)-dev:em-install-dll$(NAME)-dev
em-install-lib$(NAME)-dev:$(foreach d,$(DEPS),em-install-$(basename $d)-dev)
.PHONY:em-installdirs-$(NAME)-dev

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


# install-$(TARGET)-pkg:TGT:=$(TARGET)
# install-$(TARGET)-pkg:TGT_FLAGS:=-DPREFIX=$(prefix) -DVERSION=$(MAJOR_VERSION).$(MINOR_VERSION).0
# install-$(TARGET)-pkg:
#	$(CPP) -P -o $(DESTDIR)$(libdir)/pkgconfig/$(TGT).pc -x c $(SRCDIR)/pkgconfig/$(TGT).pc.in $(TGT_FLAGS)
endif
# end
