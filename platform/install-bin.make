# vim: set ft=make:

em-$(NAME):$(BIN)

em-installdirs-$(NAME):    em-installdirs-bindir
em-installdirs-$(NAME)-dev:em-installdirs-$(NAME)

em-do-install-$(NAME):$(BIN)
	$(INSTALL_PROGRAM) $^ $(DESTDIR)$(bindir)
.PHONY:em-do-install-$(NAME)

em-install-$(NAME):    em-do-install-$(NAME)
em-install-$(NAME)-dev:em-install-$(NAME)

EM_NAME:=$(NAME)
include $(MAKEDIR)/platform/install.make

ifneq ($(WANT_TARGET),)
 $(NAME):em-$(NAME)
 .PHONY:$(NAME)

 installdirs-$(NAME):em-installdirs-$(NAME)
 .PHONY:installdirs-$(NAME)

 install-$(NAME):em-install-$(NAME)
 .PHONY:install-$(NAME)
endif
