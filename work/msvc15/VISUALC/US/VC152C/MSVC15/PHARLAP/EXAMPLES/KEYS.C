/* 
KEYS.C -- demonstrate use of BIOS data area in 286|DOS-Extender
*/

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>

#ifdef DOSX286
#include <phapi.h>
#else
typedef unsigned char UCHAR;
typedef unsigned USHORT;
typedef unsigned long ULONG;
#endif

/*
    Microsoft Visual C++ - 
    We use based variables, which are perfect for mapped selectors
    in 286|DOS-Extender, and much nicer to work with than either
    the MAKEP() or MK_FP() macros.
*/
_segment bios;
#define TICKS()             (*((ULONG _based(bios) *) 0x6C))
#define KB_STAT             (*((UCHAR _based(bios) *) 0x17))
#define KB_HEAD             (*((USHORT _based(bios) *) 0x1A))
#define KB_TAIL             (*((USHORT _based(bios) *) 0x1C))

#define KB_HIT()            (KB_HEAD != KB_TAIL)
#define CTRL()              (KB_STAT & 4)
#define ALT()               (KB_STAT & 8)

#define ESC                 0x1B

void fail(char *s, unsigned ret)
{
    printf("%s ret=%04X (%u)\n", s, ret, ret);
    exit(ret);
}

main()
{
    USHORT ret;
    int done = 0;
    int c;
    
#ifdef DOSX286
    /*
        Notice that DosGetBIOSSeg() is called only once, at the 
        beginning of the program. We can then freely use the 
        selector for as long as we want.
    */
    if ((ret = DosGetBIOSSeg((PSEL) &bios)) != 0)
        fail("DosGetBIOSSeg - failure", ret);
#else
    bios = 0x40;
#endif

    /* Note: Ctrl-Esc probably not a good choice: used by Windows too! */
    puts("Press keys; Ctrl-Esc to quit");
    while (! done)
        if (KB_HIT())
        {
            c = getch();
            printf("TIME=%-8lX ST=%02X CHAR=%02X ", TICKS(), KB_STAT, c);
            if (c == 0)
                printf("%02X", getch());  /* extended character */
            printf("\n");
            if ((c == ESC) && CTRL()) /* Ctrl-ESC */ 
                break;
    }
    
#ifdef DOSX286
    /* Do _NOT_ DosFreeSeg(bios) ! */
#endif

    puts("bye");
    return 0;
}
