# vim: set ft=make:

ifneq ($(HAVE_PIC),)
 PIC:=$(LIBDIR)/lib$(NAME)$(SUFFIX).pic$(LIBEXT)
 EM_CMD:=$(OBJDIR)/lib$(NAME)$(SUFFIX).pic.cmd
 EM_LIB:=$(PIC)
 include $(MAKEDIR)/platform/link-archive.make
else
 PIC:=$(LIB)
 EmLibraryDeps.lib$(NAME).pic:=$(EmLibraryDeps.lib$(NAME).lib)
 EmLibraryPkgs.lib$(NAME).pic:=$(EmLibraryPkgs.lib$(NAME).lib)
 EmLibraryPkgDeps.lib$(NAME).pic:=$(EmLibraryPkgDeps.lib$(NAME).lib)
endif
# end
