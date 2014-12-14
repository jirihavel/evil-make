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

# compile (sets OBJS)
include make/compile.make

OBJS+=$(ADD_OBJS)

BIN:=$(BINDIR)/$(NAME)$(SUFFIX)$(BINEXT)

# rule specific variable beause of late expansion in commands
# append pkg-config --libs
$(BIN):EM_LINK:=$(OBJS) $(LIBS) $(if $(PKGS),$(shell pkg-config $(PKGS) --libs))

EM_CMD:=$(EM_OBJPATH)/$(NAME)$(SUFFIX).bin.cmd 

# objects + libs from previous linking
# *.link will change only when different from before
$(EM_CMD):always $$(@D)/.f
	$(call updateIfNotEqual,$(Link.bin) $(EM_LINK))

include make/compiler/$(COMPILER_KIND)/bin.make 

ifneq ($(TARGET),)
 .PHONY:$(TARGET) install-$(TARGET) internal-install-$(TARGET)

 $(TARGET):$(BIN)

 internal-install-$(TARGET):$(BIN)
	$(INSTALL_PROGRAM) $< $(DESTDIR)$(bindir)

 install-$(TARGET):internal-install-$(TARGET)

 TARGET:=
endif
# end
