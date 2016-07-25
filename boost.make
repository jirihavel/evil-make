# vim: set ft=make:
#
# Defines :
# - BOOST_CPPFLAGS
# - BOOST_LIBS
# - boost_libs
#   $(call boost_libs,atomic ...) creates correct linker commands
#
# Config :
# - WANT_BOOST forces an error if boost is not detected
# - WANT_THREADS selects multithreaded libraries
#   - can be rule specific
# - BOOST_DYN_LINK switches to dynamic libraries
#   - static libraries are default
# - BOOST_INC_DIRS set additional include directories
#   - affect BOOST_CPPFLAGS
#   - can change boost version
# - BOOST_LIB_DIRS set additional library directories
ifndef BOOST_MAKE_INCLUDED
BOOST_MAKE_INCLUDED:=1

srcdir?=
include $(srcdir)make/build.make

BOOST_INCLUDE_DIRS?=
BOOST_LIBRARY_DIRS?=
BOOST_ALL_DYN_LINK?=$(true)
CONFIG_VARS+=BOOST_INCLUDE_DIRS BOOST_LIBRARY_DIRS BOOST_ALL_DYN_LINK

BOOST_LIB_RUNTIME_STATIC?=$(false)
BOOST_LIB_RUNTIME_DEBUG?=$(false)
BOOST_LIB_PYTHON_DEBUG?=$(false)
BOOST_LIB_DEBUG?=$(false)
CONFIG_VARS+=BOOST_LIB_RUNTIME_STATIC BOOST_LIB_RUNTIME_DEBUG BOOST_LIB_PYTHON_DEBUG BOOST_LIB_DEBUG

BOOST_CONFIG_BINARY:=obj/make/boost$(BINEXT)
BOOST_CONFIG_FLAGS:=$(call em_compiler_inc_dirs,$(BOOST_INC_DIRS)) $(if $(BOOST_ALL_DYN_LINK),-DBOOST_ALL_DYN_LINK)

obj/make/boost.make:$(srcdir)make/boost.make $(srcdir)make/boost/version.cpp | $$(@D)/.f
	@echo Checking boost :
	$(file >$@)
	-@$(CXX) -o $(BOOST_CONFIG_BINARY) $(srcdir)make/boost/version.cpp $(BOOST_CONFIG_FLAGS) 2>$@.err \
		&& $(call em_conv_path,$(BOOST_CONFIG_BINARY)) >> $@
	@cat $@

include obj/make/boost.make

BOOST_FOUND?=$(false)
BOOST_DEFINITIONS:=$(if $(BOOST_FOUND),HAVE_BOOST=1) $(if $(BOOST_ALL_DYN_LINK),BOOST_ALL_DYN_LINK)

#BOOST_SYSTEM_CODE_HEADER_ONLY?=$(false)
#BOOST_SYSTEM_DEPRECATED?=$(false)
#CONFIG_VARS+=BOOST_SYSTEM_CODE_HEADER_ONLY BOOST_SYSTEM_DEPRECATED

#BOOST_FILESYSTEM_DEPRECATED?=$(false)
#CONFIG_VARS+=BOOST_FILESYSTEM_DEPRECATED

#BOOST_THREAD_VERSION?=4
#CONFIG_VARS+=BOOST_THREAD_VERSION

#BOOST_CPPFLAGS:=$(call em_compiler_inc_dirs,$(BOOST_INC_DIRS)) $(if $(BOOST_ALL_DYN_LINK),-DBOOST_ALL_DYN_LINK)
#BOOST_LDLIBS:=$(call em_compiler_lib_dirs,$(BOOST_LIB_DIRS))

BOOST_LIB_ABI_TAG=$(if $(BOOST_LIB_RUNTIME_STATIC),s)$(if $(BOOST_LIB_RUNTIME_DEBUG),g)$(if $(BOOST_LIB_PYTHON_DEBUG),y)$(if $(BOOST_LIB_DEBUG),d)
BOOST_LIB_TOOLSET:=mgw49
BOOST_LIB_SUFFIX:=$(if $(BOOST_ALL_DYN_LINK),.dll)

boost_libs=$(foreach l,$1,-lboost_$l-$(BOOST_LIB_TOOLSET)$(if $(WANT_THREADS),-mt)$(if $(BOOST_LIB_ABI_TAG),-$(BOOST_LIB_ABI_TAG))-$(BOOST_LIB_VERSION)$(BOOST_LIB_SUFFIX))

endif # BOOST_MAKE_INCLUDED
