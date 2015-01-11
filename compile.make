# vim: set ft=make:
#config :
# VERBOSE
# SRCDIR, OBJDIR
# DEPEXT, OBJEXT
# CONFIG
#input :
# NAME
# SRCS
# TODO : DEPS
# PKGS
# FLAGS
#output:
# OBJS + PIC_OBJS

# internal enhanced name
EM_NAME:=$(NAME)

include $(MAKEDIR)/platform/compile.make

EM_NAME:=
# end
