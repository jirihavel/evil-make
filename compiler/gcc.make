# vim: set ft=make:
LIBEXT:=.a
OBJEXT:=.o
DEPEXT:=.d

LIBPREFIX:=lib

EM_COMPILER_C  :=$(if $(HOST),$(HOST)-)gcc
EM_COMPILER_CXX:=$(if $(HOST),$(HOST)-)g++

# Convert definitions to compiler options
em_compiler_defines=$(foreach d,$1,-D$d)

# Convert paths to compiler options
em_compiler_inc_dirs=$(foreach d,$1,-I$(subst \,/,$d))
em_compiler_lib_dirs=$(foreach d,$1,-L$(subst \,/,$d))
