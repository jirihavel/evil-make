include make/system/unix.make

DLLEXT:=.dylib

CompileFlags+=-I/opt/local/include
CompileFlags.cpp+=-stdlib=libc++

LinkFlags.dll+=-stdlib=libc++ -L/opt/local/lib
LinkFlags.bin+=-stdlib=libc++ -L/opt/local/lib
