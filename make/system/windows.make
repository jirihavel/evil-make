# vim: set ft=make:
SYSTEM_KIND:=windows

# bin/*.dll 
ifndef dlldir
 dlldir:=$(bindir)
endif
ifndef DLLDIR
 DLLDIR:=$(BINDIR)
endif

MKDIR:=make\system\windows\mkdir.bat
#RMDIR:=rmdir /s /q

COPY:=make\system\windows\copy.bat
INSTALL:=make\system\windows\copy.bat
INSTALL_PROGRAM:=$(INSTALL)
INSTALL_DATA:=$(INSTALL)

# TODO : uses touch from unixutils, find standard alternative
%/.f :
	$(MKDIR) $(dir $@)
	touch $@
	attrib +H $@

# hack, TODO : correct dll.make, so it creates both directories
$(DLLDIR)/.f : | $(LIBDIR)/.f

DLLPREFIX:=

BINEXT:=.exe
DLLEXT:=.dll

# PIC is not used on windows
HAVE_PIC:=
