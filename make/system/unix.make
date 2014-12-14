# vim: set ft=make: 
SYSTEM_KIND:=unix

# lib/lib*.{so,dylib,?}
DLLPREFIX:=lib
ifndef dlldir
 dlldir:=$(libdir)
endif
ifndef DLLDIR
 DLLDIR:=$(LIBDIR)
endif 

MKDIR:=mkdir -p

COPY:=cp

INSTALL:=install
INSTALL_PROGRAM:=$(INSTALL)
INSTALL_DATA:=$(INSTALL) -m 644

#directory construction
%/.f :
	$(MKDIR) $(dir $@)
	touch $@


BINEXT:=

HAVE_PIC:=1
