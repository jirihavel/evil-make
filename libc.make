# vim: set ft=make:
ifndef LIBC_MAKE_INCLUDED
LIBC_MAKE_INCLUDED:=1

include $(dir $(lastword $(MAKEFILE_LIST)))build.make

$(OBJDIR)make/libc.make:$(makedir)libc.make $(wildcard $(makedir)libc/*.c) | $$(@D)/.f
	@echo Checking libc :
	$(file >$@) $(file >$@.err)
	-@$(CC) -o $(OBJDIR)make/strlcpy$(BINEXT) $(makedir)libc/strlcpy.c 2>>$@.err && echo HAVE_STRLCPY:=$(true) >> $@
	-@$(CC) -o $(OBJDIR)make/strlcat$(BINEXT) $(makedir)libc/strlcat.c 2>>$@.err && echo HAVE_STRLCAT:=$(true) >> $@
	@cat $@

include $(OBJDIR)make/libc.make

HAVE_STRLCPY?=$(false)
HAVE_STRLCAT?=$(false)

LIBC_DEFINITIONS:=
LIBC_DEFINITIONS+=$(if $(HAVE_STRLCPY),HAVE_STRLCPY=1)
LIBC_DEFINITIONS+=$(if $(HAVE_STRLCAT),HAVE_STRLCAT=1)

endif # LIBC_MAKE_INCLUDED
