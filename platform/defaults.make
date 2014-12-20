# vim: set ft=make:

# Default installation directories
defaults.prefix        =/usr/local
defaults.exec_prefix   =$(prefix)
defaults.bindir        =$(exec_prefix)/bin
defaults.libexecdir    =$(exec_prefix)/libexec
defaults.datarootdir   =$(prefix)/share
defaults.datadir       =$(datarootdir)
defaults.sysconfdir    =$(prefix)/etc
defaults.sharedstatedir=$(prefix)/com
defaults.localstatedir =$(prefix)/var
defaults.runstatedir   =$(prefix)/run
defaults.includedir    =$(prefix)/include
defaults.libdir        =$(exec_prefix)/lib
