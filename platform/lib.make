# vim: set ft=make:

# EM_OBJS will be overwritten, store copy for $(LIB)
$(LIB):EM_OBJS:=$(EM_OBJS)

# *.cmd will change only when different from before
EM_CMD:=$(EM_OBJPATH)/lib$(NAME)$(SUFFIX).lib.cmd
$(EM_CMD):always $$(@D)/.f
	@$(if $(VERBOSE),echo "Checking $@")
	$(call updateIfNotEqual,$(Link.lib) $(EM_OBJS))

# link
$(LIB):$(EM_OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	$(if $(VERBOSE),,@)$(Link.lib) $(EM_OBJS)
# end
