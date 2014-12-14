# vim: set ft=make:

ifeq ($(VERBOSE),)
 $(BIN):$(OBJS) $(EM_CMD) $$(@D)/.f
	@echo "Linking $@"
	@$(Link.bin) $(EM_LINK)
	@objcopy --only-keep-debug $@ $@.debug
	@strip -g $@
	@objcopy --add-gnu-debuglink=$@.debug $@
else
 $(BIN):$(OBJS) $(EM_CMD) $$(@D)/.f
	$(Link.bin) $(EM_LINK)
	objcopy --only-keep-debug $@ $@.debug
	strip -g $@
	objcopy --add-gnu-debuglink=$@.debug $@
endif
