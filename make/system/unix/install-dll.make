# vim: set ft=make:

em-install-$(TARGET) em-install-$(TARGET)-dev:MINOR:=$(MINOR_VERSION)
em-install-$(TARGET) em-install-$(TARGET)-dev:SONAME:=$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT).$(MAJOR_VERSION)

# copy library with versioned name + create soname symlink
em-install-$(TARGET):$(DLL)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
	ln -sf $(SONAME).$(MINOR) $(DESTDIR)$(libdir)/$(SONAME)

# make dev symlink
em-install-$(TARGET)-dev:BASENAME:=$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT)
em-install-$(TARGET)-dev:
	ln -sf $(SONAME).$(MINOR) $(DESTDIR)$(libdir)/$(BASENAME)
#end
