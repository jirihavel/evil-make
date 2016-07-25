# vim: set ft=make:

ifeq ($(OS),Windows_NT)
 BUILD:=windows
 HAVE_UNAME:=$(shell where "/Q" uname && echo $(true))
else
 HAVE_UNAME:=$(true)
endif

ifneq ($(HAVE_UNAME),)
 OPERATING_SYSTEM_NAME:=$(shell uname -o)
 ifeq ($(OPERATING_SYSTEM_NAME),MinGW)
  BUILD:=mingw32
 endif
 ifeq ($(OPERATING_SYSTEM_NAME),Cygwin)
  BUILD:=cygwin
 endif
 ifeq ($(OPERATING_SYSTEM_NAME),GNU/Linux)
  BUILD:=linux
 endif
endif
include $(makedir)build/$(BUILD).make
