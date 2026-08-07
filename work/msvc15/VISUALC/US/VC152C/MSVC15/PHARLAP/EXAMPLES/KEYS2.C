/* 
KEYS.C -- demonstrate use of BIOS data area in 286|DOS-Extender
*/

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>

/*
    Microsoft Visual C++ - 
    We use based variables, which are perfect for mapped selectors
    in 286|DOS-Extender, and much nicer to work with than either
    the MAKEP() or MK_FP() macros.  Notice that 0x40 is a _very_
    special case.  All DPMI servers arrange that selector 0x40
    maps the memory at 0040:000.  In other words, for this selector
    only, protected-mode addresses are the same as real-mode addresses.
*/
_segment bios = 0x40;
#define TICKS()             (*((unsigned long _based(bios) *) 0x6C))
#define KB_STAT             (*((unsigned char _based(bios) *) 0x17))
#define KB_HEAD             (*((unsigned short _based(bios) *) 0x1A))
#define KB_TAIL             (*((unsigned short _based(bios) *) 0x1C))

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
    int done = 0;
    int c;
    

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
    
    puts("bye");
    return 0;
}
