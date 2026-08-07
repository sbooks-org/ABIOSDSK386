/*  DOSMEM.C */

#include <stdlib.h>
#include <stdio.h>
#include <dos.h>

main()
{
    unsigned avail;
    char far *fp;
    _asm mov ah, 48h
    _asm mov bx, 0FFFFh
    _asm int 21h
    _asm jc error
    _asm mov word ptr fp+2, ax
    _asm mov word ptr fp, 0
    *fp = 'x';   /* make sure it's genuine */
    printf("Allocated 0FFFFh paragraphs: %Fp\n", fp);
    return 0;
error:
    _asm mov avail, bx
    printf("Only %04Xh paragraphs available\n", avail);
    return 1;
}

