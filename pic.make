# vim: set ft=make:

ifneq ($(HAVE_PIC),)
 include $(MAKEDIR)/compile-pic.make
endif
include $(MAKEDIR)/link-pic.make

# end
