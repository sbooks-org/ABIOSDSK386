#define APSTUDIO_HIDDEN_SYMBOLS
#include "windows.h"
#undef APSTUDIO_HIDDEN_SYMBOLS
#include "drivinit.h"
#include "resource.h"

#ifndef CDECL
#define CDECL cdecl
#endif

#define WINDOWMENU  3	/* position of window menu		 */
#define SHORTMENU   2	/* position of short version window menu */

#define DEFFILESEARCH	(LPSTR) "*.TXT"

#ifdef RC_INVOKED
#define ID(id) id
#else
#define ID(id) MAKEINTRESOURCE(id)
#endif

/* edit control identifier */
#define ID_EDIT 0xCAC

/* resource ID's */
#define IDMULTIPAD  ID(1)
#define IDMULTIPAD2 ID(3)
#define IDNOTE	    ID(2)

/* Window word values for child windows */
#define GWW_HWNDEDIT	0
#define GWW_CHANGED	2
#define GWW_WORDWRAP	4
#define GWW_UNTITLED	6
#define CBWNDEXTRA	8

/* menu ID's */
#define IDM_EDITFIRST	IDM_EDITUNDO
#define IDM_EDITLAST	IDM_EDITFONT
#define IDM_SEARCHFIRST IDM_SEARCHFIND
#define IDM_SEARCHLAST	IDM_SEARCHPREV

/* dialog ids */
#define IDD_FILEOPEN	ID(200)
#define IDD_ABOUT	ID(300)
#define IDD_FIND	ID(400)
#define IDD_SAVEAS	ID(500)
#define IDD_PRINT	ID(600)
#define IDD_FONT	ID(700)
#define IDD_NEXT	IDOK

/* attribute flags for DlgDirList */
#define ATTR_DIRS	0xC010		/* find drives and directories */
#define ATTR_FILES	0x0000		/* find ordinary files	       */
#define PROP_FILENAME	szPropertyName	/* name of property for dialog */

/*
 *  External variable declarations
 */
extern HANDLE hInst;		/* application instance handle		  */
extern HANDLE hAccel;		/* resource handle of accelerators	  */
extern HWND hwndFrame;		/* main window handle			  */
extern HWND hwndMDIClient;	/* handle of MDI Client window		  */
extern HWND hwndActive; 	/* handle of current active MDI child	  */
extern HWND hwndActiveEdit;	/* handle of edit control in active child */
extern LONG styleDefault;	/* default child creation state 	  */
extern char szChild[];		/* class of child			  */
extern char szSearch[]; 	/* search string			  */
extern char *szDriver;		/* name of printer driver		  */
extern char szPropertyName[];	/* filename property for dialog box	  */
extern int iPrinter;		/* level of printing capability 	  */
extern BOOL fCase;		/* searches case sensitive		  */
extern WORD cFonts;		/* number of fonts enumerated		  */

/*  externally declared functions
 */
extern BOOL FAR PASCAL InitializeApplication(VOID);
extern BOOL FAR PASCAL InitializeInstance(LPSTR,WORD);
extern BOOL FAR PASCAL __export AboutDlgProc(HWND,WORD,WORD,LONG);
extern HWND FAR PASCAL AddFile(char *);
extern VOID FAR PASCAL ReadFile(HWND);
extern VOID FAR PASCAL SaveFile(HWND);
extern BOOL FAR PASCAL ChangeFile(HWND);
extern int FAR PASCAL LoadFile(HWND, char *);
extern VOID FAR PASCAL PrintFile(HWND);
extern BOOL FAR PASCAL GetInitializationData(HWND);
extern short FAR CDECL MPError(HWND,WORD,WORD,...);
extern VOID FAR PASCAL Find(void);
extern VOID FAR PASCAL FindNext(void);
extern VOID FAR PASCAL FindPrev(void);
extern VOID FAR PASCAL MPSpotHelp(HWND,POINT);
extern LONG FAR PASCAL __export MPFrameWndProc(HWND,UINT,WPARAM,LPARAM);
extern LONG FAR PASCAL __export MPMDIChildWndProc(HWND,UINT,WPARAM,LPARAM);
extern HDC FAR PASCAL GetPrinterDC(void);
extern VOID NEAR PASCAL SetSaveFrom (HWND, PSTR);
extern BOOL NEAR PASCAL RealSlowCompare (PSTR, PSTR);
extern VOID FAR PASCAL FindPrev (void);
extern VOID FAR PASCAL FindNext (void);
extern BOOL NEAR PASCAL IsWild (PSTR);
extern VOID NEAR PASCAL SelectFile (HWND);
extern VOID NEAR PASCAL MyFindText ( int );
