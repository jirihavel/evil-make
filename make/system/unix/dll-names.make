# vim: set ft=make:
LIBNAME:=$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT)
SONAME:=$(LIBNAME).$(MAJOR_VERSION)
DLLNAME:=$(SONAME).$(MINOR_VERSION)

LIB:=$(LIBDIR)/$(LIBNAME)
DLL:=$(DLLDIR)/$(DLLNAME)

# something for linker
$(DLL):SONAME:=$(SONAME)

$(LIB):$(DLLNAME):=$(DLLNAME)

# lib/libfoo.so.1 -> libfoo.so.1.2
$(LIB).$(MAJOR_VERSION):$(DLL)
	ln -sf $(DLLNAME) $@

# lib/libfoo.so -> libfoo.so.1.2
$(LIB):$(LIB).$(MAJOR_VERSION)
	ln -sf $(DLLNAME) $@
#end
