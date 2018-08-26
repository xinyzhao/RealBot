CPP = g++

ARCHFLAG = -m32

METAMOD_SRCDIR = ./dependencies/metamod-1.19/metamod
HLSDK_BASEDIR = ./dependencies/hlsdk

BASEFLAGS = -Dstricmp=strcasecmp -Dstrcmpi=strcasecmp -Dlinux=1
CPPFLAGS = ${BASEFLAGS} ${ARCHFLAG} -O2 -w -I"${METAMOD_SRCDIR}" -I"${HLSDK_BASEDIR}/multiplayer/common" -I"${HLSDK_BASEDIR}/multiplayer/dlls" -I"${HLSDK_BASEDIR}/multiplayer/engine" -I"${HLSDK_BASEDIR}/multiplayer/pm_shared"

OBJ = NodeMachine.o \
	bot.o \
	bot_buycode.o \
	bot_client.o \
	bot_func.o \
	bot_navigate.o \
	build.o \
	dll.o \
	engine.o \
	game.o \
	util.o \
	ChatEngine.o \
	IniParser.o

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
SO_SUFFIX = so
endif
ifeq ($(UNAME_S),Darwin)
SO_SUFFIX = dylib
endif

realbot_mm_i386.${SO_SUFFIX}: ${OBJ}
	${CPP} ${ARCHFLAG} -fPIC -shared -o $@ ${OBJ} -ldl
	mkdir -p Release
	mv $@ ${OBJ} Release

clean:
	rm -f *.o
	rm -f *.map
	rm -f *.${SO_SUFFIX}
	mv Release/*.${SO_SUFFIX} .
	rm -f Release/*
	mv *.${SO_SUFFIX} Release

distclean:
	rm -rf Release
	mkdir -p Release

%.o:	%.cpp
	${CPP} ${CPPFLAGS} -c $< -o $@

%.o:	%.c
	${CPP} ${CPPFLAGS} -c $< -o $@
