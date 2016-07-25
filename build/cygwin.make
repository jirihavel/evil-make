# vim: set ft=make:
HAVE_OS_WINDOWS:=$(true)

EM_DEV_NULL:=/dev/null

em_conv_path=$1
em_mkdir=[ -d $1 ] || mkdir -p $1

em_install_program=install -t $2 $1
