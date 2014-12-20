# vim: set ft=make:
COMPILER_KIND:=gnu

DEPEXT:=.d
PCHEXT:=.gch
OBJEXT:=.o
LIBEXT:=.a
DBGEXT:=.dbg

# TODO : if HAVE_PIC && PIC -> -fpic
# else if HAVE_PIE && PIE -> -fpie
# else nothing

EM_CompileFlags=-o $@ -c -MMD -MP $(if $(PIE),-fpie) $(if $(PIC),-fpic) $(CompileFlags)

Compile.c=$(CC) $(EM_CompileFlags) $(CompileFlags.c) $(CPPFLAGS) $(CFLAGS)
Compile.cpp=$(CXX) $(EM_CompileFlags) $(CompileFlags.cpp) $(CPPFLAGS) $(CXXFLAGS)
Compile.cc=$(Compile.cpp)
Compile.C=$(Compile.cpp)

EM_GNU_MAP=-Wl,-Map=$(MAP)

EM_LinkFlags=-o $@ $(if $(MAP),$(EM_GNU_MAP) )$(LinkFlags)

EM_Linker=$(CXX)

EM_GNU_SONAME=-Wl,-soname=$(SONAME)
EM_GNU_IMPLIB=-Wl,--out-implib=$(IMPLIB)
EM_GNU_DEF=-Wl,--output-def=$(DEF)

Link.c.bin=$(CC) $(EM_LinkFlags) $(LinkFlags.bin) $(LDFLAGS) $(LDLIBS)
Link.cpp.bin=$(CXX) $(EM_LinkFlags) $(LinkFlags.bin) $(LDFLAGS) $(LDLIBS)

Link.lib=$(AR) -rcs $@
Link.dll=$(EM_Linker) -shared $(EM_LinkFlags) $(if $(SONAME),$(EM_GNU_SONAME) )$(if $(IMPLIB),$(EM_GNU_IMPLIB) )$(if $(DEF),$(EM_GNU_DEF) )$(LinkFlags.dll) $(LDFLAGS) $(LDLIBS)
Link.bin=$(EM_Linker) $(EM_LinkFlags) $(LinkFlags.bin) $(LDFLAGS) $(LDLIBS)

updateIfNotEqual=@echo '$1' | cmp -s - $@ || echo '$1' > $@

CompileFlags+=-I$(INCDIR)
LinkFlags+=-L$(LIBDIR)
