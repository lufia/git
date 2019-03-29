</sys/src/ape/config

V=0
#CURLDIR=/sys/include/ape/curl ??
#CURL_CONFIG=curl-config
#GIT_HOST_CPU=i386|i686|x86_64

ROOT=`{pwd}

CFLAGS=$CFLAGS -B -c\
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
	-DUSE_ST_TIMESPEC\
	-DNO_SYMLINK_HEAD\
	-DNO_GETTEXT\
	-DNO_STRCASESTR\
	-DNO_STRLCPY\
	-DNO_STRTOUMAX\
	-DNO_SETENV\
	-DNO_MKDTEMP\
	-DNO_UNSETENV\
	-DNEEDS_SYS_PARAM_H\
	-DNO_INITGROUPS\
	-DNO_MMAP\
	-DNO_STRUCT_ITIMERVAL\
	-DNO_SETITIMER\
	-Dsockaddr_storage=sockaddr_in6\
	-DNO_UNIX_SOCKETS\
	-DNO_ICONV\
	-DSHA1_OPENSSL\
	-DSHA256_OPENSSL\
	-DNO_MEMMEM\
	-DNO_PTHREADS\
	-DHAVE_CLOCK_GETTIME\
	-DETC_GITCONFIG="/sys/lib/git/config"\
	-DETC_GITATTRIBUTES="/sys/lib/git/attributes"\
	-DGIT_EXEC_PATH="/bin"\
	-DFALLBACK_RUNTIME_PREFIX=""\

NO_TCLTK=YesPlease
NO_PERL=YesPlease
NO_PYTHON=YesPlease
PAGER_ENV=

CFILES=`{sed -n '/^LIB_OBJS *\+= *(.*)\.o$/s//\1.c/p' Makefile}
OFILES=\
	${CFILES:%.c=%.$O}\
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

HFILES=`{ls *.h */*.h */*/*.h */*/*/*.h}

LIB=/$objtype/lib/ape/libgit.a

</sys/src/cmd/mklib

%.$O: %.c
	$CC $CFLAGS -o $target $stem.c


#LIB=\
#    libgit.a\
#    /$objtype/lib/ape/libcurl.a\
#    /$objtype/lib/ape/libssl.a\
#    /$objtype/lib/ape/libcrypto.a\
#    /$objtype/lib/ape/libz.a\
