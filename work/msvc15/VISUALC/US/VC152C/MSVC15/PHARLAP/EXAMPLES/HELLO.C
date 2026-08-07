/* DOSX286 should be #defined on the CL command line. */

#ifdef	DOSX286
#define	MODE	"protected"
#else
#define	MODE	"real"
#endif

#include <stdio.h>

int
main(void)
{
	printf("Hello from " MODE " mode!\n");
	return 0;
}
