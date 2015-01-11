# vim: set ft=make:
COMPILER_KIND:=gnu

DEPEXT:=.d
PCHEXT:=.gch
OBJEXT:=.o
LIBEXT:=.a
DBGEXT:=.dbg

updateIfNotEqual=@echo '$1' | cmp -s - $@ || echo '$1' > $@

EmCompileFlags+=-I$(INCDIR)
EmLinkFlags+=-L$(LIBDIR)

# TODO : if HAVE_PIC && PIC -> -fpic
# else if HAVE_PIE && PIE -> -fpie
# else nothing

EM_CPPFLAGS=
EM_CFLAGS=
EM_CXXFLAGS=

################################################################################
# Compilation
################################################################################

EmCompile=-o $@ -c -MMD -MP $(if $(PIE),-fpie) $(if $(PIC),-fpic) $(EmCompileFlags)

Compile.c=$(CC) $(EmCompile) $(EmCompileFlags.c) $(EM_CPPFLAGS) $(EM_CFLAGS) $(CPPFLAGS) $(CFLAGS)

Compile.cxx=$(CXX) $(EmCompile) $(EmCompileFlags.cxx) $(EM_CPPFLAGS) $(EM_CXXFLAGS) $(CPPFLAGS) $(CXXFLAGS)
Compile.cpp=$(Compile.cxx)
Compile.cc=$(Compile.cxx)
Compile.C=$(Compile.cxx)

################################################################################
# Archives - static libraries
################################################################################

Link.lib=$(AR) -rcs $@

################################################################################
# Linking
################################################################################

# these contain ',' so can't be directly in if
EM_GNU_MAP=-Wl,-Map=$(MAP)
EM_GNU_DEF=-Wl,--output-def=$(DEF)
EM_GNU_IMPLIB=-Wl,--out-implib=$(IMPLIB)
EM_GNU_SONAME=-Wl,-soname=$(SONAME)

EmLink=-o $@ $(if $(MAP),$(EM_GNU_MAP)) $(LinkFlags)

Link.c.bin=$(CC) $(EmLink) $(EmLinkFlags.bin) $(LDFLAGS) $(LDLIBS)
Link.cpp.bin=$(CXX) $(EmLink) $(EmLinkFlags.bin) $(LDFLAGS) $(LDLIBS)

Link.dll=$(CXX) -shared $(EmLink) $(if $(DEF),$(EM_GNU_DEF)) $(if $(IMPLIB),$(EM_GNU_IMPLIB)) $(if $(SONAME),$(EM_GNU_SONAME)) $(EmLinkFlags.dll) $(LDFLAGS) $(LDLIBS)
Link.bin=$(CXX) $(EmLink) $(EmLinkFlags.bin) $(LDFLAGS) $(LDLIBS)
# end
