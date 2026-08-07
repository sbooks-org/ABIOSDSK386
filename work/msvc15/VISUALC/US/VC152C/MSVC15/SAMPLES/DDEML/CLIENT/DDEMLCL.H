#include <windows.h>
#include <ddeml.h>
#include "resource.h"

#define WINDOWMENU  3	/* position of window menu		 */

// predefined format list item

typedef struct {
    ATOM atom;
    PSTR sz;
} FORMATINFO;
#define CFORMATS 3

// conversation (MDI child) window information
typedef struct {
    HWND hwndXaction;       // last xaction window with focus, 0 if none.
    BOOL fList;
    HCONV hConv;
    HSZ hszTopic;
    HSZ hszApp;
    int x;          // next child coord.
    int y;
    CONVINFO ci; // most recent status info.
} MYCONVINFO;       // parameters to AddConv() in reverse order.
#define CHILDCBWNDEXTRA	    2
#define UM_GETNEXTCHILDX    (WM_USER + 200)
#define UM_GETNEXTCHILDY    (WM_USER + 201)
#define UM_DISCONNECTED     (WM_USER + 202)

// transaction processing structure - this structure is associated with
// infoctrl control windows.  A handle to this structure is placed into
// the first window word of the control.
typedef struct {    // used to passinfo to/from TransactionDlgProc and
    DWORD ret;      // TextEntryDlgProc.
    DWORD Result;
    DWORD ulTimeout;
    WORD wType;
    HCONV hConv;
    HDDEDATA hDdeData;
    WORD wFmt;
    HSZ hszItem;
    WORD fsOptions;
} XACT;

typedef struct {
    HDDEDATA hData;
    HSZ hszItem;
    WORD wFmt;
} OWNED;

// transaction option flags - for fsOptions field and DefOptions global.

#define XOPT_NODATA             0x0001
#define XOPT_ACKREQ             0x0002
#define XOPT_DISABLEFIRST       0x0004
#define XOPT_ABANDONAFTERSTART  0x0008
#define XOPT_BLOCKRESULT        0x0010
#define XOPT_ASYNC              0x0020
#define XOPT_COMPLETED          0x8000      // used internally only.

/* attribute flags for DlgDirList */
#define ATTR_DIRS	0xC010		/* find drives and directories */
#define ATTR_FILES	0x0000		/* find ordinary files	       */
#define PROP_FILENAME	szPropertyName	/* name of property for dialog */
#define MAX_OWNED   20

/*
 *  GLOBALS
 */
extern CONVCONTEXT CCFilter;
extern DWORD idInst;
extern HANDLE hInst;		/* application instance handle		  */
extern HANDLE hAccel;		/* resource handle of accelerators	  */
extern HWND hwndFrame;		/* main window handle			  */
extern HWND hwndMDIClient;	/* handle of MDI Client window		  */
extern HWND hwndActive; 	/* handle of current active MDI child	  */
extern HWND hwndActiveEdit;	/* handle of edit control in active child */
extern LONG styleDefault;	/* default child creation state 	  */
extern WORD SyncTimeout;
extern LONG DefTimeout;
extern WORD wDelay;
extern BOOL fEnableCBs;
extern BOOL fEnableOneCB;
extern BOOL fBlockNextCB;
extern BOOL fTermNextCB;
extern BOOL fAutoReconnect;
extern HDDEDATA hDataOwned;
extern WORD fmtLink;        // registered LINK clipboard fmt
extern WORD DefOptions;
extern char szChild[];		/* class of child			  */
extern char szList[];		/* class of child			  */
extern char szSearch[]; 	/* search string			  */
extern char *szDriver;		/* name of printer driver		  */
extern char szPropertyName[];	/* filename property for dialog box	  */
extern int iPrinter;		/* level of printing capability 	  */
extern BOOL fCase;		/* searches case sensitive		  */
extern WORD cFonts;		/* number of fonts enumerated		  */
extern FORMATINFO aFormats[];
extern OWNED aOwned[MAX_OWNED];
extern WORD cOwned;


// MACROS

#ifdef NODEBUG
#define MyAlloc(cb)     (PSTR)LocalAlloc(LPTR, (cb))
#define MyFree(p)       (LocalUnlock((HANDLE)(p)), LocalFree((HANDLE)(p)))
#else   // DEBUG

#define MyAlloc(cb)     DbgAlloc((WORD)cb)
#define MyFree(p)       DbgFree((PSTR)p)
#endif //NODEBUG


/*  externally declared functions
 */

// ddemlcl.c

BOOL FAR PASCAL InitializeApplication(VOID);
BOOL FAR PASCAL InitializeInstance(WORD);
HWND FAR PASCAL AddFile(char *);
VOID FAR PASCAL ReadFile(HWND);
VOID FAR PASCAL SaveFile(HWND);
BOOL FAR PASCAL ChangeFile(HWND);
int FAR PASCAL LoadFile(HWND, char *);
VOID FAR PASCAL PrintFile(HWND);
BOOL FAR PASCAL GetInitializationData(HWND);
short FAR CDECL MPError(HWND,WORD,WORD,...);
VOID FAR PASCAL Find(void);
VOID FAR PASCAL FindNext(void);
VOID FAR PASCAL FindPrev(void);
VOID FAR PASCAL MPSpotHelp(HWND,POINT);
LONG FAR PASCAL __export FrameWndProc(HWND,UINT,WPARAM,LPARAM);
LONG FAR PASCAL __export MDIChildWndProc(HWND,UINT,WPARAM,LPARAM);
HDC FAR PASCAL GetPrinterDC(void);
VOID NEAR PASCAL SetSaveFrom (HWND, PSTR);
BOOL NEAR PASCAL RealSlowCompare (PSTR, PSTR);
VOID FAR PASCAL FindPrev (void);
VOID FAR PASCAL FindNext (void);
BOOL NEAR PASCAL IsWild (PSTR);
VOID NEAR PASCAL SelectFile (HWND);
VOID NEAR PASCAL FindText ( int );
HCONV CreateConv(HSZ hszApp, HSZ hszTopic, BOOL fList, WORD *pError);
HWND FAR PASCAL AddConv(HSZ hszApp, HSZ hszTopic, HCONV hConv, BOOL fList);
PSTR GetConvListText(HCONVLIST hConvList);
PSTR GetConvInfoText(HCONV hConv, CONVINFO *pci);
PSTR GetConvTitleText(HCONV hConv, HSZ hszApp, HSZ hszTopic, BOOL fList);
PSTR Status2String(WORD status);
PSTR State2String(WORD state);
PSTR Error2String(WORD error);
PSTR Type2String(WORD wType, WORD fsOptions);
PSTR GetHSZName(HSZ hsz);
DWORD FAR PASCAL __export MyMsgFilterProc(int nCode, WORD wParam, DWORD lParam);
typedef DWORD FAR PASCAL FILTERPROC(int nCode, WORD wParam, DWORD lParam);
extern FILTERPROC  *lpMsgFilterProc;

// dialog.c


int FAR DoDialog(LPCSTR lpTemplateName, FARPROC lpDlgProc, DWORD param,
        BOOL fRememberFocus);
BOOL FAR PASCAL __export AboutDlgProc(HWND,WORD,WORD,LONG);
BOOL FAR PASCAL __export ConnectDlgProc(HWND,WORD,WORD,LONG);
BOOL FAR PASCAL __export TransactDlgProc(HWND,WORD,WORD,LONG);
BOOL FAR PASCAL __export AdvOptsDlgProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL __export TextEntryDlgProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL __export ViewHandleDlgProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL __export TimeoutDlgProc(HWND,WORD,WORD,LONG);
BOOL FAR PASCAL __export DelayDlgProc(HWND,WORD,WORD,LONG);
BOOL FAR PASCAL __export ContextDlgProc(HWND,WORD,WORD,LONG);
VOID Delay(DWORD delay);

// dde.c


BOOL ProcessTransaction(XACT *pxact);
VOID CompleteTransaction(HWND hwndInfoCtr, XACT *pxact);
HDDEDATA EXPENTRY __export DdeCallback(WORD wType, WORD wFmt, HCONV hConv, HSZ hsz1,
        HSZ hsz2, HDDEDATA hData, DWORD lData1, DWORD lData2);
HWND MDIChildFromhConv(HCONV hConv);
HWND FindAdviseChild(HWND hwndMDI, HSZ hszItem, WORD wFmt);
HWND FindListWindow(HCONVLIST hConvList);
PSTR GetTextData(HDDEDATA hData);
PSTR GetFormatData(HDDEDATA hData);
int MyGetClipboardFormatName(WORD fmt, LPSTR lpstr, int cbMax);
PSTR GetFormatName(WORD wFmt);
BOOL MyDisconnect(HCONV hConv);

// mem.c


PSTR DbgAlloc(WORD cb);
PSTR DbgFree(PSTR p);

