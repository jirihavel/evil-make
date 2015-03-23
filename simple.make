# vim: set ft=make:

EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))

EM_SIMPLE_FLAGS:=$(FLAGS) $(if $(PKGS),$(shell pkg-config $(PKGS) --cflags))

EM_SIMPLE_LIBS:=$(LIBS) $(if $(PKGS),$(shell pkg-config $(PKGS) --libs))

# flags from previous compilations

$(EM_OBJPATH)/.em/simple.flags:always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@") 
	@$(call UpdateIfNotEqual,$@,$(EM_SIMPLE_FLAGS))

$(EM_OBJPATH)/.em/simple.libs:always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@") 
	@$(call UpdateIfNotEqual,$@,$(EM_SIMPLE_FLAGS))

.PRECIOUS:$(EM_OBJPATH)/%$(OBJEXT)

$(EM_OBJPATH)/%$(OBJEXT):$(SRCDIR)/% $(EM_OBJPATH)/.em/simple.flags $$(@D)/.f
	@echo "Compiling $<"
	@$(Compile$(suffix $*)) $(EM_SIMPLE_FLAGS) $<

$(BINDIR)/%$(SUFFIX)$(BINEXT):$(EM_OBJPATH)/%.c$(OBJEXT) $(EM_OBJPATH)/.em/simple.libs $$(@D)/.f
	@echo "Linking $@"
	@$(Link.c.bin) $< $(EM_SIMPLE_LIBS)

$(BINDIR)/%$(SUFFIX)$(BINEXT):$(EM_OBJPATH)/%.cpp$(OBJEXT) $(EM_OBJPATH)/.em/simple.libs $$(@D)/.f
	@echo "Linking $@"
	@$(Link.cpp.bin) $< $(EM_SIMPLE_LIBS)

EM_OBJPATH:=

# Include dependencies from previous compilations
include $(wildcard $(EM_OBJPATH)/*$(DEPEXT))
# end
