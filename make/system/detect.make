ifeq ($(OS),Windows_NT)
 SYSTEM:=windows
else
 SYSTEM:=wrong
 UNAME_S:=$(shell uname -s)
 ifeq ($(UNAME_S),Linux)
  SYSTEM:=linux
 endif
 ifeq ($(UNAME_S),Darwin)
  SYSTEM:=osx
 endif
endif
include make/system/$(SYSTEM).make
