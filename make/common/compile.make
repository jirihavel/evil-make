# vim: set ft=make:

# src/a.c -> obj/a.c.o
OBJS:=$(patsubst $(SRCDIR)/%,$(EM_OBJPATH)/%$(OBJEXT),$(SRCS))
# obj/a.c.o -> obj/a.c.d
DEPS:=$(patsubst %$(OBJEXT),%$(DEPEXT),$(OBJS))

# rule specific variable beause of late expansion in commands
# add pkg-config --cflags
$(OBJS):EM_FLAGS:=$(FLAGS) $(if $(PKGS),$(shell pkg-config $(PKGS) --cflags))

# flags from previous compilations
# file will change only when flags change
$(EM_OBJPATH)/$(NAME).%.cmd:always $$(@D)/.f
	$(call updateIfNotEqual,$(Compile.$*) $(EM_FLAGS))

# compile (+ generate *.d)
ifeq ($(VERBOSE),)
 $(OBJS):$(EM_OBJPATH)/%$(OBJEXT):$(SRCDIR)/% $(EM_OBJPATH)/$(NAME)$$(suffix $$*).cmd $$(@D)/.f
	@echo "Compiling $(if $(PIC),PIC )$<"
	@$(Compile$(suffix $*)) $(EM_FLAGS) $<
else
 $(OBJS):$(EM_OBJPATH)/%$(OBJEXT):$(SRCDIR)/% $(EM_OBJPATH)/$(NAME)$$(suffix $$*).cmd $$(@D)/.f
	$(Compile$(suffix $*)) $(EM_FLAGS) $<
endif

# include dependencies from previous compilations
-include $(DEPS)
# end
