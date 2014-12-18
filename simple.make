# vim: set ft=make:

EM_OBJPATH:=$(OBJDIR)$(if $(CONFIG),/$(CONFIG))

EM_FLAGS:=$(FLAGS) $(if $(PKGS),$(shell pkg-config $(PKGS) --cflags))
EM_LINK:=$(LIBS) $(EM_DEPS) $(if $(PKGS),$(shell pkg-config $(PKGS) --libs)) 

# flags from previous compilations
# file will change only when flags change
#$(EM_OBJPATH)/$(NAME).%.cmd:always $$(@D)/.f
#	$(call updateIfNotEqual,$(Compile.$*) $(EM_FLAGS))

$(EM_OBJPATH)/%$(OBJEXT):$(SRCDIR)/% $$(@D)/.f
	@echo "Compiling $<"
	@$(Compile$(suffix $*)) $(EM_FLAGS) $<

$(BINDIR)/%$(SUFFIX)$(BINEXT):$(EM_OBJPATH)/%.c$(OBJEXT) $$(@D)/.f
	@echo "Linking $<"
	@$(Link.bin) $< $(EM_LINK)

$(BINDIR)/%$(SUFFIX)$(BINEXT):$(EM_OBJPATH)/%.cpp$(OBJEXT) $$(@D)/.f
	@echo "Linking $<"
	@$(Link.bin) $< $(EM_LINK)

# include dependencies from previous compilations
# obj/a.c.o -> obj/a.c.d
#-include $(patsubst %$(OBJEXT),%$(DEPEXT),$(OBJS))
# end #end
