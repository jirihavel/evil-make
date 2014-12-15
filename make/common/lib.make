LIB:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(EM_SUFFIX)$(LIBEXT)

$(LIB):EM_OBJS:=$(EM_OBJS)

# *.cmd will change only when different from before
EM_CMD:=$(EM_OBJPATH)/lib$(NAME)$(SUFFIX).lib.cmd
$(EM_CMD):always $$(@D)/.f
	$(call updateIfNotEqual,$(Link.lib) $(EM_OBJS))

# link
ifeq ($(VERBOSE),)
 $(LIB):$(EM_OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	@$(Link.lib) $(EM_OBJS)
else
 $(LIB):$(EM_OBJS) $(EM_CMD) $$(@D)/.f
	$(Link.lib) $(EM_OBJS)
endif
# end
