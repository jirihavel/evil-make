# vim: set ft=make:
include $(MAKEDIR)/system/windows/system.make

SYSTEM_DEFAULT_INSTALL:=cp
SYSTEM_DEFAULT_INSTALL_DATA:=cp

# TODO : uses unixutils, find standard alternative
#MKDIR:=$(srcdir:/=\\)\make\system\windows\mkdir.bat
#RMDIR:=rmdir /s /q
#COPY:=$(srcdir:/=\\)\make\system\windows\copy.bat
#INSTALL:=$(srcdir)\make\system\windows\copy.bat
