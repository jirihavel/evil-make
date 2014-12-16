# vim: set ft=make:

# copy dll
em-install-$(NAME):$(DLL)
	$(INSTALL_DATA) $< $(DESTDIR)$(dlldir)

# copy import library for developers
em-install-$(NAME)-dev:$(LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
#end
