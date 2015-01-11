# vim: set ft=make:
all:$(foreach d,$(DEPS),em-$(basename $d))
installdirs:$(foreach d,$(DEPS),em-installdirs-$(basename $d))
installdirs-dev:$(foreach d,$(DEPS),em-installdirs-$(basename $d)-dev)
install:$(foreach d,$(DEPS),em-install-$(basename $d))
install-dev:$(foreach d,$(DEPS),em-install-$(basename $d)-dev)
# end
