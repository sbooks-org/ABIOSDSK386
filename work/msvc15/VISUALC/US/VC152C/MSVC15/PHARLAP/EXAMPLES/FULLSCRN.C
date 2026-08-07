/* 
FULLSCRN.C -- package of routines for direct screen writes
*/

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <dos.h>

#include <phapi.h>

#include "fullscrn.h"

typedef void far *FP;

#define VIDEO               0x10
#define SCROLL_UP           0x06
#define GET_VIDEO_MODE      0x0F

static BYTE far *vid_mem;

#define SCR(y,x)            (((y) * 160) + ((x) << 1))

int video_mode(void)
{
    int mode;
    _asm mov ah, GET_VIDEO_MODE
    _asm int 10h
    _asm xor ah, ah
    _asm mov mode,ax
    return mode;
}

unsigned get_vid_mem(void)
{
    int vmode = video_mode();
    unsigned short vid_seg;

    if (vmode == 7)
        vid_seg = 0xB000;
    else if ((vmode == 2) || (vmode == 3))
        vid_seg = 0xB800;
    else
        return 0;

#ifdef DOSX286
    {
        unsigned short sel;
        /*
            DosMapRealSeg() takes a real-mode paragraph address and
            a count of bytes, and gives back a selector that can be used
            to address the memory from protected mode. Like all PHAPI
            functions, DosMapRealSeg() returns 0 for success, or a
            non-zero error code. Any returned information (such as the
            selector we're interested in) is returned via parameters.
        */
        if (DosMapRealSeg(vid_seg, (long) 25*80*2, &sel) == 0)
            return sel;
        else
            return 0;
    }
#else
        return vid_seg;
#endif

}

int video_init(void)
{
    return !! (vid_mem = MAKEP(get_vid_mem(), 0));
}

#define MAKEWORD(l, h)  (((unsigned char) (l)) | ((unsigned short) (h)) << 8)

/* faster and safer version */
void wrt_str(int y, int x, ATTRIB attr, char *p)
{
    unsigned short far *v = (unsigned short far *)(vid_mem + SCR(y, x));
    int ok = 80 - x;
    while (ok && *p)
    {
        *v++ = (unsigned short) MAKEWORD(*p++, attr);
        ok--;
    }
}

static char buf[128] = {0};

void wrt_printf(int y, int x, ATTRIB attr, char *fmt, ...)
{
    va_list marker;
    va_start(marker, fmt);
    vsprintf(buf, fmt, marker); 
    va_end(marker);
    wrt_str(y, x, attr, buf);
}

void wrt_chr(int y, int x, ATTRIB attr, char c)
{
    BYTE far *v = vid_mem + SCR(y, x);
    *v++ = c;
    *v = (BYTE)attr;
}

void set_attr(int starty, int startx, int endy, int endx, ATTRIB attr)
{
    int x, y;
    for (y=starty; y<=endy; y++)
    {
        BYTE far *v = vid_mem + SCR(y, startx);
        for (x=startx; x<=endx; x++)
        {
            v++;
            *v++ = (BYTE)attr;
        }
    }
}

void fill(int starty, int startx, int endy, int endx, unsigned char c,
    ATTRIB attr)
{
    BYTE far *v = vid_mem;
    int x, y;
    for (y=starty; y<=endy; y++)
        for (x=startx, v=vid_mem+SCR(y, startx); x<=endx; x++)
        {
            *v++ = c;
            *v++ = (BYTE)attr;
        }
}

void clear(int starty, int startx, int endy, int endx, ATTRIB attr)
{
    _asm mov ax, 0600h
    _asm mov bh, byte ptr attr
    _asm mov ch, byte ptr starty
    _asm mov cl, byte ptr startx
    _asm mov dh, byte ptr endy
    _asm mov dl, byte ptr endx
    _asm int 10h
}

void cls(void)
{
    clear(0, 0, 24, 79, NORMAL);
}

static unsigned char brd[2][6] = {
    179, 196, 218, 191, 192, 217,       /* single box chars */
    186, 205, 201, 187, 200, 188        /* double box chars */
    } ;

void border(int starty, int startx, int endy, int endx, ATTRIB attr, int dbl)
{
    BYTE far *v;
    char *b;
    register int i;
    
    b = (char *)brd[(dbl-1) & 1];
    
    for (i=starty+1; i<endy; i++)
    {
        wrt_chr(i, startx, attr, *b);
        wrt_chr(i, endx, attr, *b);
    }
    b++;
    for (i=startx+1, v=vid_mem+SCR(starty, startx+1); i<endx; i++)
    {
        *v++ = *b;
        *v++ = (BYTE)attr;
        /* equivalent to wrt_chr(starty, i, attr, *b); */
    }
    for (i=startx+1, v=vid_mem+SCR(endy, startx+1); i<endx; i++)
    {
        *v++ = *b;
        *v++ = (BYTE)attr;
        /* equivalent to wrt_chr(endy, i, attr, *b); */
    }
    b++;
    wrt_chr(starty, startx, attr, *b++);
    wrt_chr(starty, endx, attr, *b++);
    wrt_chr(endy, startx, attr, *b++);
    wrt_chr(endy, endx, attr, *b);
}

void cursor(int on)
{
    static int old_curs = 0;
    if (on && old_curs)
    {
        _asm mov cx, old_curs
        _asm mov ah, 1
        _asm int 10h
    }
    else if (! (on || old_curs))
    {
        _asm mov ah, 3
        _asm mov bh, 0
        _asm int 10h
        _asm mov old_curs, cx
        _asm mov cx, 2000h
        _asm mov ah, 1
        _asm int 10h
    }
}

void center(int y, ATTRIB attr, char *s)
{
    wrt_str(y, 40 - (strlen(s) >> 1), attr, s);
}
