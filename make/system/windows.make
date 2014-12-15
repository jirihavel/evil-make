# vim: set ft=make:
SYSTEM_KIND:=windows

BINEXT:=.exe
DLLEXT:=.dll

# bin/*.dll 
DLLPREFIX:=
ifndef dlldir
 dlldir:=$(bindir)
endif
ifndef DLLDIR
 DLLDIR:=$(BINDIR)
endif

# TODO : use different stuff than unixutils
TOUCH:=touch
MKDIR:=mkdir -p
COPY:=cp
INSTALL:=install

#MKDIR:=$(srcdir:/=\\)\make\system\windows\mkdir.bat
#RMDIR:=rmdir /s /q
#COPY:=$(srcdir:/=\\)\make\system\windows\copy.bat
#INSTALL:=$(srcdir)\make\system\windows\copy.bat
INSTALL_PROGRAM:=$(INSTALL)
INSTALL_DATA:=$(INSTALL)

# TODO : uses touch from unixutils, find standard alternative
#%/.f :
#	$(MKDIR) $(dir $@)
#	touch $@
#	attrib +H $@

# hack, TODO : correct dll.make, so it creates both directories
$(DLLDIR)/.f : | $(LIBDIR)/.f

# PIC is not used on windows
HAVE_PIC:=
