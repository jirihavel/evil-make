# vim: set ft=make:

# -- Link library --

ifneq ($(HAVE_PIC),)
 PIC:=$(LIBDIR)/lib$(NAME)$(SUFFIX).pic$(LIBEXT)
 EM_CMD:=$(OBJDIR)/lib$(NAME)$(SUFFIX).pic.cmd
 EM_LIB:=$(PIC)
 include $(MAKEDIR)/platform/link-lib-pic.make
else
 PIC:=$(LIB)
endif

# -- Register library --

EmLibraryPieces.lib$(NAME).pic:=$(PIC)

# end
