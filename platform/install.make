# vim: set ft=make:
#in:
# EM_NAME = [lib]name

.PHONY:em-$(EM_NAME)

em-installdirs-$(EM_NAME):    $(foreach d,$(DEPS),em-installdirs-$(basename $d))
.PHONY:em-installdirs-$(EM_NAME)

em-installdirs-$(EM_NAME)-dev:$(foreach d,$(DEPS),em-installdirs-$(basename $d)-dev)
.PHONY:em-installdirs-$(EM_NAME)-dev

em-install-$(EM_NAME):        $(foreach d,$(DEPS),em-install-$(basename $d))
.PHONY:em-install-$(EM_NAME)

em-install-$(EM_NAME)-dev:    $(foreach d,$(DEPS),em-install-$(basename $d)-dev)
.PHONY:em-install-$(EM_NAME)-dev

EM_NAME:=
# end
