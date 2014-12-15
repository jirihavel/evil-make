# vim: set ft=make: 
SYSTEM_KIND:=unix

BINEXT:=

# lib/lib*.{so,dylib,?}
DLLPREFIX:=lib
ifndef dlldir
 dlldir:=$(libdir)
endif
ifndef DLLDIR
 DLLDIR:=$(LIBDIR)
endif 

TOUCH:=touch
MKDIR:=mkdir -p
COPY:=cp
INSTALL:=install
INSTALL_PROGRAM:=$(INSTALL)
INSTALL_DATA:=$(INSTALL) -m 644

HAVE_PIC:=1
