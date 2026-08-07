/* MEMTEST.C */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

main()
{
    char *p;
    unsigned long allocs;

    for (allocs = 0; ; allocs++)
       if ((p = malloc(1024)) != 0)    /* in 1k blocks */
       {
           memset(p, 0, 1024); /* touch every byte */
           *p = 'x';           /* do something, anything with */
           p[1023] = 'y';      /* the allocated memory      */
           
           if (allocs && (allocs % 1024) == 0)   /* odometer */
               printf("Allocated %u megabytes\r", allocs >> 10);
       }
       else
           break;

       printf("Allocated %lu bytes\n", allocs << 10);
       return 0;
}
