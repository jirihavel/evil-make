# vim: set ft=make:
COMPILER_KIND:=gnu

DEPEXT:=.d
PCHEXT:=.gch
OBJEXT:=.o
LIBEXT:=.a
DBGEXT:=.dbg

EM_CompileFlags=-o $@ -c -MMD -MP $(if $(PIE),-fpie) $(if $(PIC),-fpic) $(CompileFlags)

Compile.c=$(CC) $(EM_CompileFlags) $(CompileFlags.c) $(CPPFLAGS) $(CFLAGS)
Compile.cpp=$(CXX) $(EM_CompileFlags) $(CompileFlags.cpp) $(CPPFLAGS) $(CXXFLAGS)
Compile.cc=$(Compile.cpp)
Compile.C=$(Compile.cpp)

EM_LinkFlags=-o $@ -Wl,-Map=$@.map $(LinkFlags)

Link.lib=$(AR) -rcs $@
Link.dll=$(CXX) -shared $(EM_LinkFlags) $(LinkFlags.dll) $(LDFLAGS) $(LDLIBS)
Link.bin=$(CXX) $(EM_LinkFlags) $(LinkFlags.bin) $(LDFLAGS) $(LDLIBS)

updateIfNotEqual=@echo '$1' | cmp -s - $@ || echo '$1' > $@

$(OBJDIR)/compile%.cmd: always $$(@D)/.f
	$(call updateIfNotEqual,$(Compile$*))

$(OBJDIR)/link%.cmd: always $$(@D)/.f
	$(call updateIfNotEqual,$(Link$*))

CompileFlags+=-I$(INCDIR)
LinkFlags+=-L$(LIBDIR)
