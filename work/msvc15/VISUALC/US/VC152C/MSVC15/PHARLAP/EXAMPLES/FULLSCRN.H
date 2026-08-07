/* 
FULLSCRN.H -- package of routines for direct screen writes
*/

typedef enum { 
    BLUEFORE=1, GREENFORE=2, REDFORE=4, 
    LOW=8, 
    BLUEBACK=16, GREENBACK=32, REDBACK=64,
    _BLINK=128 } ATTRIB;

#define NORMAL  (BLUEFORE | GREENFORE | REDFORE)
#define REVERSE (BLUEBACK | GREENBACK | REDBACK)

#define ATTR(fore, back)    (((unsigned) (fore)) | (((unsigned) (back)) << 4))

#define TOP             0
#define BOTTOM          24
#define LEFT            0
#define RIGHT           79

/* for border */
#define NOBORD          0
#define SINGLE          1
#define DOUBLE          2

#define HATCH1      176
#define HATCH2      177
#define HATCH3      178
#define BOX         219

#define F1          0x3B
#define UP_KB       0x48
#define LEFT_KB     0x4b
#define RIGHT_KB    0x4d
#define DOWN_KB     0x50
#define ENTER       0x0d

int video_mode(void);
unsigned get_vid_mem(void);
int video_init(void);
void wrt_str(int y, int x, ATTRIB attr, char *p);
void wrt_chr(int y, int x, ATTRIB attr, char c);
void wrt_printf(int y, int x, ATTRIB attr, char *fmt, ...);
void cls(void);
void border(int starty, int startx, int endy, int endx, ATTRIB attr, int dbl);
void clear(int starty, int startx, int endy, int endx, ATTRIB attr);
void fill(int starty, int startx, int endy, int endx, unsigned char c,
    ATTRIB attr);
void set_attr(int starty, int startx, int endy, int endx, ATTRIB attr);
void cursor(int on);
void center(int y, ATTRIB attr, char *s);

/* values of _osmode in STDLIB.H */
#define REAL_MODE           0
#define PROTECTED_MODE      1
