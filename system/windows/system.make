# vim: set ft=make:

SYSTEM_KIND:=windows

BINEXT:=.exe
DLLEXT:=.dll
DEFEXT:=.def

# bin/*.dll 
DLLPREFIX:=

SYSTEM_DEFAULT_DLLDIR:=$(BINDIR)
system_default_dlldir:=$(bindir)

# PIC is not used on windows
HAVE_PIC:=
