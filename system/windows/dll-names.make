# vim: set ft=make:
LIB:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(LIBEXT)
DEF:=$(LIBDIR)/lib$(NAME)$(SUFFIX).def
DLL:=$(DLLDIR)/$(DLLPREFIX)$(NAME)$(SUFFIX)$(DLLEXT)

# something for linker
$(DLL):IMPLIB:=$(LIB)
$(DLL):DEF:=$(DEF)

# import lib is created with dll
$(LIB):$(DLL)
#	@$(TOUCH) $(LIB)

# create also directory for import lib
$(DLL):$(LIBDIR)/.f
#end
