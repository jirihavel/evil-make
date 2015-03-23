# vim: set ft=make:

# Compile sources with undecorated name
# - create <name>.{c,cpp,...}.cmd files
EM_NAME:=lib$(NAME)
EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))
include $(MAKEDIR)/platform/compile.make
# end
