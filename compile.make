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

include $(MAKEDIR)/common/compile.make

EM_NAME:=
# end
