# vim: set ft=make:

ifneq ($(HAVE_PIC),)
 include $(MAKEDIR)/compile-pic.make
 include $(MAKEDIR)/link-pic.make
else
 PIC:=$(LIB)
endif
# end
