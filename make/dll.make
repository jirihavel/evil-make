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
# DEPS = PIC_DEPS
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

# compile (sets OBJS + PIC_OBJ)
include $(MAKEDIR)/compile.make

# use PIC objects if system has them
OBJS:=$(PIC_OBJS)

# objects + libs from previous linking
#  EM_OBJPATH is set by compile.make
EM_CMD:=$(EM_OBJPATH)/$(NAME)$(SUFFIX).dll.cmd

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(DLL):EM_LINK:=$(OBJS) $(LIBS) $(if $(PKGS),$(shell pkg-config $(PKGS) --libs))

# *.cmd will change only when different from before
$(EM_CMD):always $$(@D)/.f
	$(call updateIfNotEqual,$(Link.dll) $(EM_PAR) $(EM_LINK))

#$(PKG):TGT_FLAGS:=-DPREFIX=. -DVERSION=$(MAJOR_VERSION).$(MINOR_VERSION).$(PATCH_VERSION)
#$(PKG):$(SRCDIR)/pkgconfig/lib$(NAME).pc.in $(LIB) $$(@D)/.f
#	$(CPP) -P -o $@ -x c $< $(TGT_FLAGS)

# link
ifeq ($(VERBOSE),)
$(DLL):$(OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	@$(Link.dll) $(EM_PAR) $(EM_LINK)
	@objcopy --only-keep-debug $@ $@.debug
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@.debug $@
else
$(DLL):$(OBJS) $(EM_CMD) $$(@D)/.f
	$(Link.dll) $(EM_PAR) $(EM_LINK)
	objcopy --only-keep-debug $@ $@.debug
	strip -g $@
	objcopy --add-gnu-debuglink=$@.debug $@
endif 
# end
