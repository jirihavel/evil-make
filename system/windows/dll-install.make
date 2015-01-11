# vim: set ft=make:

# copy dll
em-install-dll$(NAME):$(DLL)
	$(INSTALL_DATA) $< $(DESTDIR)$(dlldir)

# copy import library for developers
em-install-dll$(NAME)-dev:$(LIB)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
#end
