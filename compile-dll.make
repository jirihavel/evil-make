# vim: set ft=make:

# Compile sources with decorated name
EM_NAME:=lib$(NAME)
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))
include $(MAKEDIR)/platform/compile.make
# end
