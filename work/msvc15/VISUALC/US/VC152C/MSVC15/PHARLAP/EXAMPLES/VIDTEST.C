/* 
VIDTEST.C 

Compaq 386/20e: 3 seconds
In Windows 3.0 enhanced mode, running in sizeable window: 19 seconds
*/

#include <stdlib.h>
#include <conio.h>
#include <time.h>
#include <string.h>
#include "fullscrn.h"

main()
{
    char msg[30];
    int i;
    time_t t1, t2;
    time(&t1);
    video_init();
    for (i=30000; i--; )
        wrt_str(rand() % 25, rand() % 80, rand() % 0xFF, "hello world!");
    clear(9, 8, 19, 28, REVERSE);
    time(&t2);
    strcat(ultoa(t2 - t1, msg, 10), " seconds");
    wrt_str(11, 10, REVERSE, msg);
    wrt_str(13, 10, REVERSE, "Press any key...");
    getch();
    cls();
    return 0;
}

