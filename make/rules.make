# vim: set ft=make:
all:$(foreach d,$(DEPS),$(Dependencies.$d))
installdirs:$(foreach d,$(DEPS),$(Dependencies.installdirs.$d))
install:$(foreach d,$(DEPS),$(Dependencies.install.$d))
#end
