/*
 * MUSCROLL.H
 *
 * Public definitions for application that use the MicroScroll.
 *  - Messages
 *  - Prototypes for Message API Functions
 *  - Notification codes.
 *  - Control Styles.
 *
 * Version 1.1, October 1991, Kraig Brockschmidt
 *
 */



//Control-specific messages
#define MSM_HWNDASSOCIATESET  (WM_USER+1)
#define MSM_HWNDASSOCIATEGET  (WM_USER+2)
#define MSM_DWRANGESET        (WM_USER+3)
#define MSM_DWRANGEGET        (WM_USER+4)
#define MSM_WCURRENTPOSSET    (WM_USER+5)
#define MSM_WCURRENTPOSGET    (WM_USER+6)
#define MSM_FNOPEGSCROLLSET   (WM_USER+7)
#define MSM_FNOPEGSCROLLGET   (WM_USER+8)
#define MSM_FINVERTRANGESET   (WM_USER+9)
#define MSM_FINVERTRANGEGET   (WM_USER+10)
#define MSM_CRCOLORSET        (WM_USER+11)
#define MSM_CRCOLORGET        (WM_USER+12)


//Message API Functions
HWND     FAR PASCAL _export MSHAssociateSet(HWND hWnd, HWND hWndAssociate);
HWND     FAR PASCAL _export MSHAssociateGet(HWND hWnd);
DWORD    FAR PASCAL _export MSDwRangeSet(HWND hWnd, WORD iMin, WORD iMax);
DWORD    FAR PASCAL _export MSDwRangeGet(HWND hWnd);
WORD     FAR PASCAL _export MSWCurrentPosSet(HWND hWnd, WORD iPos);
WORD     FAR PASCAL _export MSWCurrentPosGet(HWND hWnd);
BOOL     FAR PASCAL _export MSFNoPegScrollSet(HWND hWnd, BOOL fNoPegScroll);
BOOL     FAR PASCAL _export MSFNoPegScrollGet(HWND hWnd);
BOOL     FAR PASCAL _export MSFInvertRangeSet(HWND hWnd, BOOL fInvertRange);
BOOL     FAR PASCAL _export MSFInvertRangeGet(HWND hWnd);
COLORREF FAR PASCAL _export MSCrColorSet(HWND hWnd, WORD iColor, COLORREF cr);
COLORREF FAR PASCAL _export MSCrColorGet(HWND hWnd, WORD iColor);



//Notification codes sent via WM_COMMAND from the control.
#define MSN_ASSOCIATEGAIN   1
#define MSN_ASSOCIATELOSS   2
#define MSN_RANGECHANGE     3


//Color indices for MSM_COLORSET/GET and MSCrColorSet/Get
#define MSCOLOR_FACE        0
#define MSCOLOR_ARROW       1
#define MSCOLOR_SHADOW      2
#define MSCOLOR_HIGHLIGHT   3
#define MSCOLOR_FRAME       4

#define CCOLORS             5

//Control specific styles.
#define MSS_VERTICAL        0x0001L
#define MSS_HORIZONTAL      0x0002L
#define MSS_NOPEGSCROLL     0x0004L
#define MSS_TEXTHASRANGE    0x0008L
#define MSS_INVERTRANGE     0x0010L
