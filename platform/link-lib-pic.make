# vim: set ft=make:

$(EM_LIB):OBJS:=$(OBJS)

# Check command line
$(EM_CMD):always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	@$(call UpdateIfNotEqual,$@,$(AR) -rcs $(OBJS))

# Link <libdir>/lib<name>[-<suffix>].a
# - ar updates the archive, so delete it before
$(EM_LIB):$(OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	@$(RM) $@
	$(if $(VERBOSE),,@)$(AR) -rcs $@ $(OBJS)

EM_CMD:=
EM_LIB:=
# end
