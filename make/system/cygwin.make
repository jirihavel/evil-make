# vim: set ft=make:
SYSTEM_KIND:=windows

BINEXT:=.exe
DLLEXT:=.dll

# bin/*.dll 
DLLPREFIX:=cyg
ifndef dlldir
 dlldir:=$(bindir)
endif
ifndef DLLDIR
 DLLDIR:=$(BINDIR)
endif

TOUCH:=touch
MKDIR:=mkdir -p
COPY:=cp
INSTALL:=install
INSTALL_PROGRAM:=$(INSTALL)
INSTALL_DATA:=$(INSTALL)

# hack, TODO : correct dll.make, so it creates both directories
$(DLLDIR)/.f : | $(LIBDIR)/.f

# PIC is not used on windows
HAVE_PIC:=
