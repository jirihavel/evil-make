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
#
# Input :
# - file extension (implies general language)
# - LANG variable (language + version)
# 
# extension(c,cpp,h,...) -> language (c,c++) + LANG[.c,c++] -> language version
################################################################################

# -- language by file extension --
# headers have unknown type, LANG must be set
EmSourceType.h  :=
EmSourceType.c  :=c
EmSourceType.C  :=cxx
EmSourceType.cc :=cxx
EmSourceType.cpp:=cxx
EmSourceType.cxx:=cxx

# function that gets language version from file extension and LANG
# - $1 file extension (e.g. ".c" ".cpp")
# - output "c", "c99", "cxx", "cxx11", ...
# - e.g. .cpp -> C++ => $(LANG.cxx) / $(LANG) / c++ (first nonempty)
em_lang=$(if $(EmSourceType$1),$(if $(LANG.$(EmSourceType$1)),$(LANG.$(EmSourceType$1)),$(if $(LANG),$(LANG),$(EmSourceType$1))),$(LANG))

EmCompiler.:=echo "Unknown extension, LANG must be set"
EmCompileFlags.:=

# -- C compiler --

$(foreach i,c c99 c11,$(eval EmCompiler.$i=$(CC)))

EmCompileFlags.c  :=
EmCompileFlags.c99:=-std=c99
EmCompileFlags.c11:=-std=c11

# -- C++ compiler --

$(foreach i,cxx cxx11 cxx14,$(eval EmCompiler.$i=$(CXX)))

EmCompileFlags.cxx  :=
EmCompileFlags.cxx11:=-std=c++11
EmCompileFlags.cxx14:=-std=c++14

# function that creates compilation command
# - $@ output file
# - $1 source file
em_compile=$(EmCompiler.$(call em_lang,$1)) -o $@ -c -MMD -MP $(EmCompileFlags.$(call em_lang,$1)) -I$(INCDIR) $(if $(WANT_PIE),-fpie) $(if $(WANT_PIC),-fpic) $(CPPFLAGS)

################################################################################
# Linking
################################################################################

em_linker.c  :=$(CC)
em_linker.c++:=$(CXX)

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
