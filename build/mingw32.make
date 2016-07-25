# vim: set ft=make:
HAVE_OS_WINDOWS:=$(true)

EM_DEV_NULL:=nul

em_conv_path=$(subst /,\,$1)

em_mkdir_impl=if not exist $1 md $1 2>$(EM_DEV_NULL)
em_mkdir=$(call em_mkdir_impl,$(call em_conv_path,$1))
