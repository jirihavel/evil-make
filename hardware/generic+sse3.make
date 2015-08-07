# vim: set ft=make:

include $(MAKEDIR)/hardware/generic.make

EmCompileFlags+=-msse3

HAVE_SSE :=1
HAVE_SSE2:=1
HAVE_SSE3:=1
