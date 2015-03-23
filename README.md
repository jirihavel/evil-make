Evil make
=========

Collection of Makefile tools for C and C++ projects. Look to examples/

* Intended to be included in other repositories as a submodule.

* Directories for output files are automatically constructed.

* Dependencies on included headers are processed automatically, so files are always rebuilt correctly.

* Any change of compilation parameters is detected and affected files are correctly rebuilt.

* Switching between debug/release/whatever configuration doen not require complete rebuild.

* In source and out of source builds are possible.

* Allows for parallel builds. `make -j` without a reasonable number is not a good idea.

* No tools except GNU make and common unix stuff are necessary.

* Works on Linux and Windows (mingw or cygwin).

Platform configuration
----------------------

The build platform is initialized by including *platform.make* as used in examples. *platform.make* uses its path as a prefix (variable **MAKEDIR**) for including further make files. Directory names do not include trailing slash. All variables are set only when not initialized. Otherwise *platform.make* does not modify them. Also, all variables are initialized as *simple* unless it is mentioned explicitly.

Basic configuration is done by

* **VERBOSE** forces the make to print lots of information. Otherwise the output is very brief, such as "Compiling x", "Linking y", ...

* **SYSTEM** {*detect*,windows,cygwin,linux,osx} On windows, makefile needs basic unix utilities such as UnixUtils. On default, makefile tries to detect the system using environment variables and the `uname` command.

* **COMPILER** {gcc,clang} Initialized to **SYSTEM_DEFAULT_COMPILER** which is *gcc* on default.

* **ENVIRONMENT**

* **HARDWARE** {*generic*,native}

The platform uses basic configuration to set various other variables :

* **BINEXT**, **DLLEXT**, **LIBEXT**, **OBJEXT**, **DEPEXT**, **MAPEXT** are extensions of compiler and linker products. DLL will mean all kinds of dynamic libraries (dll, so, dylib) and LIB static ones. All nonempty extensions include the dot.

* TODO **PICEXT** and **PIEEXT*

* **BINDIR**, **DLLDIR**, **LIBDIR**, **OBJDIR** are *build* directories to put those files. **DLLDIR** is usually **BINDIR** or **LIBDIR**, depending on **SYSTEM**.

* **SRCDIR**, **INCDIR**, **ETCDIR** are the source directories. These are initialized as subdirectories of **srcdir** (yes it is lowercase, see [Makefile Conventions](http://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html#Makefile-Conventions)) /src, /include and /etc

* Variables **DESTDIR**, **prefix** and other *installation* directories are also initialized to usual values. The variable **dlldir** is added for consistency on windows.

Aside from these variables, some **EM_***SOMETHING* and **Em***Something* variables are defined. These are semi-internal. The same goes for rules **em-***something*.

### Directory construction

The makefile uses */.f* marker files for automatic construction of *build* directories. To construct output directory, simply add `$$(@D)/.f` as prerequisities. Since second order expansion is enabled, this expands correctly to file path and an implicit rule does the rest.

*Installation* directories are constructed by usual installdirs rules. There are helper **em-installdirs-***variable-name* rules but no marker files and automatic checking. The makefile creates a lot of junk but only in build directories.

Compilation
-----------

Including *compile.make* creates compilation rules for sources in **SRCS**. It expects **SRCS** to be simple and copies it inside, so *compile.make* can be used multiple times. The corresponding object files are returned in **OBJS**. The rule is based on file extension. .c files are compiled as C and .C, .cc, .cpp and .cxx as C++.

The actual transformation is from $(SRCDIR)/*something* to $(OBJDIR)/$(CONFIG)/*something*$(OBJEXT). This way, the source extension is preserved and no conflict occurs between similarly named files. The variable **CONFIG** can have values such as *debug* or *release* and can separate object files from multiple configurations. **CONFIG** can be also decorated by the makefile to distinguish further variations.

Gcc preprocessor can produce *something*.d along *something*.o files. These files contain lists of included files as dependencies. If these files exist, *compile.make* includes them automatically. When the object file is built for the first time, .d file is created. For next builds, .d file is included and make can detect changes in included files and rebuild everything correctly. When .o files are removed together with .d files, everything works as expected. Yes, make includes lots of files, but after first build, everything is cached.

Compilation flags are taken from multiple sources :

* Internal compilation flags **EM_CPPFLAGS**, **EM_CFLAGS**, **EM_CXXFLAGS**, ...

* **CPPFLAGS**, **CFLAGS**, **CXXFLAGS** are directly used in commands, so they can be set globally or overridden [per target](https://www.gnu.org/software/make/manual/html_node/Target_002dspecific.html).

* **FLAGS** is expected to be a simple variable, so *compile.make* copies the contents. Then it can be safely overwritten for next compilation.

* **PKGS** are package names for *pkg-config*. The path *$(LIBDIR)/pkgconfig* is added to **PKG_CONFIG_PATH** so `*something*-uninstalled` can be put there and used immediately.

The order is same as in this list, so **CPPFLAGS** override internal flags and so on till **PKGS** that override everything. That is, if the compiler resolves conflicting flags similarly as gcc.

### Flag checking

Compilation flags are stored as an auxiliary file in $(OBJDIR)/$(CONFIG). Every time a file is compiled, the file is checked against wanted flags and if it doesn't match it is rewritten. This changes its timestamp, so when it is added as dependency, it forces rebuild of the affected object file.

Executables
-----------

Including *link-bin.make* creates link rule for object files in **OBJS** (from *compile.make*). It returns **BIN**:=$(BINDIR)/$(NAME)$(SUFFIX)$(BINEXT). Currently, everything is linked as C++ (TODO).

Similarly to compilation, linker flags come from multiple sources (in following order) :

* Internal linker flags **EM_LDFLAGS**, **EM_LDLIBS**, ...

* Usual **LDFLAGS** and **LDLIBS**

* Simple variable **LIBS** (see FLAGS above)

* `pkg-config --libs $(PKGS)`

Debug symbols for linked binary are put separately into $(BIN)$(DBGEXT). These files are produced even in release version without debug symbols. (TODO)

If **WANT_MAP** is set, rule for linker map file is created and returned as **MAP**:=$(BIN)$(MAPEXT).

If **WANT_TARGET** is set, default phony targets *$(NAME)*, *installdirs-$(NAME)* and *install-$(NAME)* are created. These build and install the binary into $(DESTDIR)$(bindir) as usual. These rules do not have any commands specified directly, so anything can be added to them safely.

Compilation and linking can be done together by *bin.make*. *link-bin.make* is probably usefull only when **OBJS** are created by multiple compilations.

Libraries
---------

### Static libraries

are linked by *link-lib.make* and *lib.make*. It returns **LIB**:=$(LIBDIR)/lib$(NAME)$(SUFFIX)$(LIBEXT), linked by `$(AR) $(ARFLAGS) $@ $(OBJS)`. **WANT_TARGET** creates *lib$(NAME)*, *installdirs-lib$(NAME)-dev* and *install-lib$(NAME)-dev* to install into $(DESTDIR)$(libdir). Because of the *lib* prefix, similarly named bin and lib ruled do not conflict. For *install-lib$(NAME)-dev*, adding more commands makes sense, since some headers are usually installed with a library (to $(DESTDIR)$(includedir)).

Libraries are automatically registered to a global registry by their identifier *lib$(NAME)*. This way, any executables can simply link them by using variable **DEPS**, that specifies its library dependencies. The libraries are added as link rule dependencies, so the build chains properly.



TODO and also to linker command right after object files (so the libraries are correctly linked with everything else). However nothing except 

### Dynamic libraries

are linked by *link-dll.make* and *dll.make*. TODO PIC

