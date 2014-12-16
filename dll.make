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

# generate DLL, MAP, LIB, PKG, DEF, SONAME
# + rules to make them from $(DLL)
include $(MAKEDIR)/system/$(SYSTEM_KIND)/dll-names.make

# MAP is created with DLL
MAP:=$(DLL).map
$(DLL):MAP:=$(MAP)
$(MAP):$(DLL)

PKG:=$(LIBDIR)/pkgconfig/$(NAME)$(SUFFIX).pc

##################################################
# Compilation
##################################################

# compile (sets OBJS + PIC_OBJ)
include $(MAKEDIR)/compile.make

# use PIC objects if system has them
OBJS:=$(PIC_OBJS)

# objects + libs from previous linking
#  EM_OBJPATH is set by compile.make
EM_CMD:=$(EM_OBJPATH)/$(NAME)$(SUFFIX).dll.cmd

EM_DEPS:=$(foreach d,$(DEPS),$(Libraries.$d))

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(DLL):EM_LINK:=$(OBJS) $(LIBS) $(EM_DEPS) $(if $(PKGS),$(shell pkg-config $(PKGS) --libs))

# *.cmd will change only when different from before
$(EM_CMD):always $$(@D)/.f
	$(call updateIfNotEqual,$(Link.dll) $(EM_LINK))

# link
ifeq ($(VERBOSE),)
$(DLL):$(OBJS) $(EM_CMD) $(EM_DEPS) $$(@D)/.f
	@echo "Linking $@"
	@$(Link.dll) $(EM_LINK)
	@objcopy --only-keep-debug $@ $@.debug
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@.debug $@
else
$(DLL):$(OBJS) $(EM_CMD) $(EM_DEPS) $$(@D)/.f
	$(Link.dll) $(EM_LINK)
	objcopy --only-keep-debug $@ $@.debug
	strip -g $@
	objcopy --add-gnu-debuglink=$@.debug $@
endif 

# register library for DEPS
Libraries.$(NAME).dll:=$(LIB)

# register the library name
#Dependencies.$(NAME):=$(DLL)

##################################################
# Installation
##################################################

em-installdirs-$(NAME):em-installdirs-dlldir
em-installdirs-$(NAME):$(foreach d,$(DEPS),$(Dependencies.installdirs.$d))
.PHONY:em-installdirs-$(NAME)

# create internal rule that does the instalation
include $(MAKEDIR)/system/$(SYSTEM_KIND)/dll-install.make

# hook dependencies
em-install-$(NAME):$(foreach d,$(DEPS),$(Dependencies.install.$d))

# register install rule for DEPS
Dependencies.installdirs.$(NAME).dll:=em-installdirs-$(NAME)
Dependencies.install.$(NAME).dll:=em-install-$(NAME)

# install
ifneq ($(TARGET),)
 $(TARGET):$(DLL)
 .PHONY:$(TARGET)

 installdirs-$(TARGET):em-installdirs-dlldir
 .PHONY:installdirs-$(TARGET)

 install-$(TARGET):em-install-$(NAME)
 .PHONY:install-$(TARGET)

# install-$(TARGET)-dev:install-$(TARGET) em-install-$(TARGET)-dev
# install-$(TARGET)-pkg:TGT:=$(TARGET)
# install-$(TARGET)-pkg:TGT_FLAGS:=-DPREFIX=$(prefix) -DVERSION=$(MAJOR_VERSION).$(MINOR_VERSION).0
# install-$(TARGET)-pkg:
#	$(CPP) -P -o $(DESTDIR)$(libdir)/pkgconfig/$(TGT).pc -x c $(SRCDIR)/pkgconfig/$(TGT).pc.in $(TGT_FLAGS)

 TARGET:=
endif
# end
