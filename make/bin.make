# vim: set ft=make:
#input :
# SRCDIR, OBJDIR, BINDIR
# DEPEXT, OBJEXT, BINEXT
# NAME
# ?TARGET
# SRCS
# PKGS
# FLAGS
# ADD_OBJS
# LIBS
#output :
# OBJS
# BIN

# compile (sets OBJS and EM_OBJPATH)
include $(MAKEDIR)/compile.make

OBJS+=$(ADD_OBJS)

BIN:=$(BINDIR)/$(NAME)$(SUFFIX)$(BINEXT)

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(BIN):EM_LINK:=$(OBJS) $(LIBS) $(if $(PKGS),$(shell pkg-config $(PKGS) --libs))

# objects + libs from previous linking
# *.link will change only when different from before
EM_CMD:=$(EM_OBJPATH)/$(NAME)$(SUFFIX).bin.cmd 
$(EM_CMD):always $$(@D)/.f
	$(call updateIfNotEqual,$(Link.bin) $(EM_LINK))

include $(MAKEDIR)/compiler/$(COMPILER_KIND)/bin.make 

ifneq ($(TARGET),)
 .PHONY:$(TARGET) em-install-$(TARGET) install-$(TARGET)
 $(TARGET):$(BIN)
 em-install-$(TARGET):$(BIN)
	$(INSTALL_PROGRAM) $< $(DESTDIR)$(bindir)
 install-$(TARGET):em-install-$(TARGET)
 TARGET:=
endif
# end
