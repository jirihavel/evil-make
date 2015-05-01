# vim: set ft=make:

# Compile sources with decorated name
EM_NAME:=lib$(NAME)
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))/.pic
include $(MAKEDIR)/platform/compile.make

# Force PIC if necessary
$(OBJS):WANT_PIC:=$(HAVE_PIC)
