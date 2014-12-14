# vim: set ft=make:

# just copy dll
em-install-$(TARGET):$(DLL)
	$(INSTALL_DATA) $< $(DESTDIR)$(dlldir)

# copy import library for developers
em-install-$(TARGET)-dev:$(LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
#end
