# vim: set ft=make:

# Compile sources with decorated name
EM_NAME:=lib$(NAME)
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))/.pie
include $(MAKEDIR)/platform/compile.make

$(OBJS):WANT_PIE:=$(HAVE_PIE)
