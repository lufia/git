#include <stdio.h>
#include <errno.h>
#include <string.h>
#define _POSIX_SOURCE
#include <unistd.h>

int
main(int argc, char *argv[])
{
	USED(argc);
	if(execv("/bin/git", argv) < 0){
		fprintf(stderr, "%s: %s\n", argv[0], strerror(errno));
		return 1;
	}
	return 0; /* can't happen */
}
