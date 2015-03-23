# vim: set ft=make:

ifneq ($(WANT_DEF),)
 DEF:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(DEFEXT)
 $(DLL):DEF:=$(DEF)
endif

# -- Import library --

IMP:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(LIBEXT)

# Pass to linker
$(DLL):IMP:=$(IMP)

# New import lib is created with the dll
$(IMP):$(DLL)

# Create also directory for the import lib
$(DLL):$(LIBDIR)/.f

# -- Install --

# Copy dll
em-install-dll$(NAME):$(DLL)
	$(INSTALL_DATA) $< $(DESTDIR)$(dlldir)

# Copy import library
em-install-dll$(NAME)-dev:$(IMP)
	$(INSTALL_DATA) $< $(DESTDIR)$(libdir)
#end
