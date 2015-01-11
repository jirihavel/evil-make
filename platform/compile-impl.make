# vim: set ft=make:

# src/a.c -> obj/a.c.o
OBJS:=$(patsubst $(SRCDIR)/%,$(EM_OBJPATH)/%$(OBJEXT),$(SRCS))

# rule specific variable beause of late expansion in commands
# add pkg-config --cflags
$(OBJS):EM_FLAGS:=$(FLAGS) $(if $(PKGS),$(shell $(PKG_CONFIG) $(PKGS) --cflags))

# flags from previous compilations
# - file will change only when flags change
$(EM_OBJPATH)/$(EM_NAME).%.cmd:always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	@echo "$(Compile.$*) $(EM_FLAGS)" > $@.new
	$(call updateIfNotEqual,$(Compile.$*) $(EM_FLAGS))

# compile (+ generate *.d)
$(OBJS):$(EM_OBJPATH)/%$(OBJEXT):$(SRCDIR)/% $(EM_OBJPATH)/$(EM_NAME)$$(suffix $$*).cmd $$(@D)/.f
	@echo "Compiling $(if $(PIC),PIC )$<"
	$(if $(VERBOSE),,@)$(Compile$(suffix $*)) $(EM_FLAGS) $<

# include dependencies from previous compilations
# obj/a.c.o -> obj/a.c.d
-include $(patsubst %$(OBJEXT),%$(DEPEXT),$(OBJS))

# end
