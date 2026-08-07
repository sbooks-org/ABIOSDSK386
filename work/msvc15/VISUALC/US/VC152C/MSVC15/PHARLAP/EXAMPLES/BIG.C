/* BIG.C */

#include <stdlib.h>
#include <stdio.h>
#include <malloc.h>

#define NROWS    512
#define NCOLS    512
#define	ARSIZE	((long)NROWS * sizeof(long [NCOLS]))

main()
{
    int i, j;

    long (huge * array)[NCOLS];
    array = (long (huge *)[NCOLS]) _halloc ( NROWS, sizeof(long [NCOLS]) );
    if( ! array )
    {
	printf("Can't allocate %lu-byte array, giving up!\n", ARSIZE);
	return 1;
    }

    printf("Using %lu-byte array\n", ARSIZE);

    for (i=0; i<NROWS; i++)
    {
        for (j=0; j<NCOLS; j++)
            array[i][j] = (long) i * j; /* touch every element */
        printf("%d\r", i);              /* display odometer */
    }

    printf("done\n");
    return 0;
}
