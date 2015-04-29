# vim: set ft=make:
SYSTEM_KIND:=windows

BINEXT:=.exe
DLLEXT:=.dll
DEFEXT:=.def

# bin/*.dll 
DLLPREFIX:=
ifndef dlldir
 dlldir:=$(bindir)
 em-installdirs-dlldir:em-installdirs-bindir
endif
ifndef DLLDIR
 DLLDIR:=$(BINDIR)
endif

# PIC is not used on windows
HAVE_PIC:=

# TODO : use different stuff than unixutils
TOUCH:=touch
MKDIR:=mkdir -p
RMDIR:=rm -rf
COPY:=cp
MOVE:=mv
INSTALL:=cp
INSTALL_DATA:=$(INSTALL)

# TODO : uses unixutils, find standard alternative
#MKDIR:=$(srcdir:/=\\)\make\system\windows\mkdir.bat
#RMDIR:=rmdir /s /q
#COPY:=$(srcdir:/=\\)\make\system\windows\copy.bat
#INSTALL:=$(srcdir)\make\system\windows\copy.bat

PKG_CONFIG:=PKG_CONFIG_PATH=$(LIBDIR)/pkgconfig pkg-config
