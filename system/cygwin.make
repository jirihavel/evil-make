# vim: set ft=make:
include $(MAKEDIR)/system/windows.make

DLLPREFIX:=cyg

# We have unix tools
TOUCH:=touch
MKDIR:=mkdir -p
RMDIR:=rm -rf
COPY:=cp
MOVE:=mv
INSTALL:=install
