# vim: set ft=make:
#input :
# MAJOR_VERSION, MINOR_VERSION, PATCH_VERSION
# SRCDIR, OBJDIR, DLLDIR, LIBDIR
# NAME
# ?TARGET
# SRCS, RESOURCES (windows)
# ADD_OBJS
# PKGS, FLAGS, LIBS
#output :
# OBJS
# DLL - for runtime
# LIB - for linking, depends on $(DLL)
# DEF - .def file (windows)
# SONAME (unix)
# PKG - pkg-config file (TODO)

ifeq ($(SYSTEM_KIND),windows)
 LIB:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(LIBEXT)
 DEF:=$(LIBDIR)/lib$(NAME)$(SUFFIX).def
 DLL:=$(DLLDIR)/$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT)
else
 LIB:=$(DLLDIR)/$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT)
 DLL:=$(LIB).$(MAJOR_VERSION).$(MINOR_VERSION)
 SONAME:=$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT).$(MAJOR_VERSION)
endif
PKG:=$(LIBDIR)/pkgconfig/$(NAME)$(SUFFIX).pc

# compile (sets OBJS)
INT_FLAGS_DLL_BACKUP:=$(FLAGS)
FLAGS+=$(DLL_FLAGS)
include make/compile.make
FLAGS:=$(INT_FLAGS_DLL_BACKUP)
INT_FLAGS_DLL_BACKUP:=

OBJS+=$(ADD_OBJS)

INT_SED_FILE:=$(OBJDIR)/$(NAME)$(SUFFIX).sed
$(INT_SED_FILE):always $$(@D)/.f
	echo "s/PREFIX/$(PREFIX)" > $@
	echo "s/VERSION/$(MAJOR_VERSION).$(MINOR_VERSION).$(PATCH_VERSION)" >> $@
	echo "s/MAJOR_VERSION/$(MAJOR_VERSION)" >> $@
	echo "s/MINOR_VERSION/$(MINOR_VERSION)" >> $@
	echo "s/PATCH_VERSION/$(PATCH_VERSION)" >> $@
#$(INT_SED_FILE):$(INT_SED_FILE).new

# resource files on windows
ifeq ($(SYSTEM_KIND), windows)
 RESOURCE_OBJS:=$(patsubst $(SRCDIR)/%,$(OBJDIR)/$(CONFIG)/%$(OBJEXT),$(RESOURCES)) 
 $(RESOURCE_OBJS):TGT_DEF:=-DMAJOR=$(MAJOR_VERSION) -DMINOR=$(MINOR_VERSION) -DPATCH=$(PATCH_VERSION)
 $(RESOURCE_OBJS):$(OBJDIR)/$(CONFIG)/%$(OBJEXT):$(SRCDIR)/% $$(@D)/.f 
	windres -i $< -o $@ $(TGT_DEF)
 OBJS+=$(RESOURCE_OBJS)
endif

# objects + libs from previous linking
INT_CMD_FILE:=$(OBJDIR)/$(NAME)$(SUFFIX).link

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(DLL) $(INT_CMD_FILE):TGT_LINK:=$(OBJS) $(LIBS) $(if $(PKGS),$(shell pkg-config $(PKGS) --libs))

# *.link will change only when different from before
$(INT_CMD_FILE):always $$(@D)/.f
	$(call updateIfNotEqual,$(TGT_LINK))

$(PKG):TGT_FLAGS:=-DPREFIX=. -DVERSION=$(MAJOR_VERSION).$(MINOR_VERSION).$(PATCH_VERSION)
$(PKG):$(SRCDIR)/pkgconfig/lib$(NAME).pc.in $(LIB) $$(@D)/.f
	$(CPP) -P -o $@ -x c $< $(TGT_FLAGS)

ifeq ($(SYSTEM_KIND),windows)
$(DLL):TGT_PAR:=-Wl,-Map=$(DLL).map -Wl,--out-implib,$(LIB) -Wl,--output-def,$(DEF)
else
$(DLL):TGT_PAR:=-Wl,-Map=$(DLL).map -Wl,-soname,$(SONAME)
endif

# link
ifeq ($(VERBOSE),)
$(DLL):$(OBJS) $(OBJDIR)/link.dll.cmd $(INT_CMD_FILE) $$(@D)/.f
	@echo "Linking $@"
	@$(Link.dll) $(TGT_PAR) $(TGT_LINK)
	@objcopy --only-keep-debug $@ $@.debug
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@.debug $@
else
$(DLL):$(OBJS) $(OBJDIR)/link.dll.cmd $(INT_CMD_FILE) $$(@D)/.f
	$(Link.dll) $(TGT_PAR) $(TGT_LINK)
	objcopy --only-keep-debug $@ $@.debug
	strip -g $@
	objcopy --add-gnu-debuglink=$@.debug $@
endif

# additional files
ifeq ($(SYSTEM_KIND),windows)
$(LIB):$(DLL)
	@touch $(LIB)
$(DEF):$(DLL)
else
# add proper symlinks
$(LIB) $(LIB).$(MAJOR_VERSION):TGT_FULLNAME:=$(SONAME).$(MINOR_VERSION)
$(LIB).$(MAJOR_VERSION):$(DLL)
	ln -sf $(TGT_FULLNAME) $@
$(LIB):$(LIB).$(MAJOR_VERSION)
	ln -sf $(TGT_FULLNAME) $@
endif

ifneq ($(TARGET),)
 $(TARGET):$(DLL)
 $(TARGET)-dev:$(LIB)
 $(TARGET)-pkg:$(PKG)

 install-$(TARGET):internal-install-$(TARGET)
 install-$(TARGET)-dev:install-$(TARGET) internal-install-$(TARGET)-dev

 ifeq ($(SYSTEM_KIND), windows)
  # just copy dll
  internal-install-$(TARGET):$(DLL)
	$(INSTALL_DATA) $< $(DESTDIR)$(dlldir)
  # copy import library for developers
  internal-install-$(TARGET)-dev:$(LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
 else
  internal-install-$(TARGET) internal-install-$(TARGET)-dev:MINOR:=$(MINOR_VERSION)
  internal-install-$(TARGET) internal-install-$(TARGET)-dev:SONAME:=$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT).$(MAJOR_VERSION)
  # copy library with versioned name
  internal-install-$(TARGET):$(DLL)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
	ln -sf $(SONAME).$(MINOR) $(DESTDIR)$(libdir)/$(SONAME)
  # make dev symlink
  internal-install-$(TARGET)-dev:BASENAME:=$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT)
  internal-install-$(TARGET)-dev:
	ln -sf $(SONAME).$(MINOR) $(DESTDIR)$(libdir)/$(BASENAME)
 endif

 install-$(TARGET)-pkg:TGT:=$(TARGET)
 install-$(TARGET)-pkg:TGT_FLAGS:=-DPREFIX=$(prefix) -DVERSION=$(MAJOR_VERSION).$(MINOR_VERSION).0
 install-$(TARGET)-pkg:
	$(CPP) -P -o $(DESTDIR)$(libdir)/pkgconfig/$(TGT).pc -x c $(SRCDIR)/pkgconfig/$(TGT).pc.in $(TGT_FLAGS)

 TARGET:=
endif
# end
