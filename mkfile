</sys/src/ape/config

TARG=\
	git\

V=0
#CURLDIR=/sys/include/ape/curl ??
#CURL_CONFIG=curl-config
#GIT_HOST_CPU=i386|i686|x86_64

ROOT=`{pwd}

# remove -w flag because it is noisy
# remove -T flag because header files are not use extern
CFLAGS=-FVB+ -c\
	-I$ROOT\
	-I$ROOT/compat/plan9\
	-I$ROOT/compat/regex\
	-D__PLAN9__\
	-D_POSIX_SOURCE\
	-D_BSD_EXTENSION\
	-D_SUSV2_SOURCE\
	-D_RESEARCH_SOURCE\
	-D_REENTRANT_SOURCE\
	-DHAVE_SOCK_OPTS\
	-DNO_NSEC\
	-DNO_SYMLINK_HEAD\
	-DNO_GECOS_IN_PWENT\
	-DNO_GETTEXT\
	-DNO_STRCASESTR\
	-DNO_STRLCPY\
	-DNO_STRTOUMAX\
	-DNO_SETENV\
	-DNO_MBSUPPORT\
	-DNO_MKDTEMP\
	-DNO_UNSETENV\
	-DNEEDS_SYS_PARAM_H\
	-DNO_INITGROUPS\
	-DNO_MMAP\
	-DNO_ST_BLOCKS_IN_STRUCT_STAT\
	-DNO_STRUCT_ITIMERVAL\
	-DNO_SETITIMER\
	-Dsockaddr_storage=sockaddr_in6\
	-DNO_UNIX_SOCKETS\
	-DNO_ICONV\
	-DSHA1_OPENSSL\
	-DSHA256_OPENSSL\
	-DNO_MEMMEM\
	-DNO_PTHREADS\
	-DHAVE_STDBOOL_H\
	-DHAVE_STDINT_H\
	-DHAVE_LOCALE_H\
	-DHAVE_CLOCK_GETTIME\
	-DGIT_VERSION="2.9.5-dev"\
	-DGIT_BUILT_FROM_COMMIT="xxx"\
	-DGIT_USER_AGENT="git/2.9.5-dev"\
	-DETC_GITCONFIG="/sys/lib/git/config"\
	-DETC_GITATTRIBUTES="/sys/lib/git/attributes"\
	-DGIT_HOST_CPU="i386"\
	-DGIT_EXEC_PATH="/$objtype/bin/git-core"\
	-DGIT_MAN_PATH="/sys/man"\
	-DGIT_INFO_PATH=""\
	-DGIT_HTML_PATH=""\
	-DFALLBACK_RUNTIME_PREFIX=""\
	-DPAGER_ENV=""\

# TODO: refine

#NO_TCLTK=YesPlease
#NO_PERL=YesPlease
#NO_PYTHON=YesPlease

LIB_CFILES=`{sed -n '/^LIB_OBJS *\+= *(.*)\.o$/s//\1.c/p' Makefile}
LIB_OFILES=\
	${LIB_CFILES:%.c=%.$O}\
	compat/strcasestr.$O\
	compat/strlcpy.$O\
	compat/strtoumax.$O\
	compat/strtoimax.$O\
	compat/setenv.$O\
	compat/mkdtemp.$O\
	compat/unsetenv.$O\
	compat/mmap.$O\
	compat/memmem.$O\
	compat/regex/regex.$O\

XDIFF_CFILES=`{sed -n '/^XDIFF_OBJS *\+= *(.*)\.o$/s//\1.c/p' Makefile}
XDIFF_OFILES=${XDIFF_CFILES:%.c=%.$O}

CFILES=`{sed -n '/^BUILTIN_OBJS *\+= *(.*)\.o$/s//\1.c/p' Makefile}
OFILES=\
	${CFILES:%.c=%.$O}\

HFILES=\
	`{ls *.h}\
	`{ls */*.h}\
	`{ls */*/*.h}\
	`{ls */*/*/*.h}\
	command-list.h\

BIN=/$objtype/bin/git-core

LIB=\
	libgit.a$O\
	xdiff/lib.a$O\
	/$objtype/lib/ape/libcurl.a\
	/$objtype/lib/ape/libssl.a\
	/$objtype/lib/ape/libcrypto.a\
	/$objtype/lib/ape/libz.a\

CLEANFILES=command-list.h

</sys/src/cmd/mkmany

LIBGIT=libgit.a$O
LIBGITOBJ=${LIB_OFILES:%=$LIBGIT(%)}
LIBXDIFF=xdiff/lib.a$O
LIBXDIFFOBJ=${XDIFF_OFILES:%=$LIBXDIFF(%)}

command-list.h:D:	command-list.txt
	rc ./generate-cmdlist.rc $prereq >$target

$LIBGIT:	$LIBGITOBJ
	ar vu $target $newmember

$LIBXDIFF:	$LIBXDIFFOBJ
	ar vu $target $newmember

%.$O:	%.c
	$CC $CFLAGS -o $target $stem.c

$LIBGIT(%.$O):N:	%.$O

$LIBXDIFF(%.$O):N:	%.$O

clean:V:
	rm -f *.[$OS] [$OS].out y.tab.? lex.yy.c y.debug y.output $TARG $CLEANFILES
	rm -f */*.[$OS] */*/*.[$OS]
