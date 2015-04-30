# vim: set ft=make:
COMPILER_KIND:=gnu

DEPEXT:=.d
PCHEXT:=.gch
OBJEXT:=.o
LIBEXT:=.a
DBGEXT:=.dbg
MAPEXT:=.map

EmCompileFlags+=-I$(INCDIR)

# TODO : if HAVE_PIC && PIC -> -fpic
# else if HAVE_PIE && PIE -> -fpie
# else nothing

EM_CPPFLAGS=
EM_CFLAGS=
EM_CXXFLAGS=

################################################################################
# Compilation
################################################################################

EmCompileLine=-o $@ -c -MMD -MP $(if $(WANT_PIE),-fpie) $(if $(WANT_PIC),-fpic) $(EmCompileFlags) $(EM_CPPFLAGS) $(CPPFLAGS)

# C sources
EmCompile.c=$(CC) $(EmCompileLine) $(EmCompileFlags.c) $(EM_CFLAGS) $(CFLAGS)

# C++ sources
EmCompile.cxx=$(CXX) $(EmCompileLine) $(EmCompileFlags.cxx) $(EM_CXXFLAGS) $(CXXFLAGS)
EmCompile.cpp=$(EmCompile.cxx)
EmCompile.cc=$(EmCompile.cxx)
EmCompile.C=$(EmCompile.cxx)

################################################################################
# Linking
################################################################################

# these contain ',' so can't be directly in if
EM_GNU_MAP=-Wl,-Map=$(MAP)
EM_GNU_DEF=-Wl,--output-def=$(DEF)
EM_GNU_IMPLIB=-Wl,--out-implib=$(IMP)
EM_GNU_SONAME=-Wl,-soname=$(SONAME)

EmLinkLine=-o $@ $(if $(MAP),$(EM_GNU_MAP)) $(EmLinkFlags)

Link.c.bin=$(CC) $(EmLinkLine) $(EmLinkFlags.bin) $(LDFLAGS) $(LDLIBS)
Link.cxx.bin=$(CXX) $(EmLinkLine) $(EmLinkFlags.bin) $(LDFLAGS) $(LDLIBS)

Link.dll=$(CXX) $(EmLinkLine) -shared $(if $(DEF),$(EM_GNU_DEF)) $(if $(IMP),$(EM_GNU_IMPLIB)) $(if $(SONAME),$(EM_GNU_SONAME)) $(EmLinkFlags.dll) $(LDFLAGS) $(LDLIBS)
Link.bin=$(CXX) $(EmLinkLine) $(EmLinkFlags.bin) $(LDFLAGS) $(LDLIBS)
# end
