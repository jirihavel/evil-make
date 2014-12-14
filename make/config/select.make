# common stuff
# also disables recursive expansion with +=
CONFIG_FLAGS:=-Wall
CONFIG_LIBS :=

# default config is optimized debug
ifdef CFG
 CONFIG:=$(CFG)
else
 CONFIG:=release
endif

# include proper settings
include make/config/$(CONFIG).make

SUFFIX:=$(CONFIG_SUFFIX)
