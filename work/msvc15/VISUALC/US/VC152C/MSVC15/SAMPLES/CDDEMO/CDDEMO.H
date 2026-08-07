#include "resource.h"

/****************************************************************************
*                                                                           *
*                             GLOBAL VARIABLES                              *
*                                                                           *
****************************************************************************/
typedef WORD (CALLBACK* FARHOOK)(HWND,UINT,WPARAM, LPARAM);

#ifdef ININIT

HANDLE             ghInst;
HWND               ghWnd;
HWND               ghFFRDlg=0;
HWND               ghPrintingDlg;
HBRUSH             ghBkgndBrush=0, ghDlgBrush=0;
HFONT              ghSelectedFont=0;
WORD               wFRMsg;
WORD               wHelpMsg;
BOOL               gbMonochrome;
BOOL               gbUserAbort;
FARHOOK 	   lpfnFileOpenHook, lpfnFindHook, lpfnFindReplaceHook;
char               gszAppName[]="Common Dialogs";
char               gszMenuName[]="CommonDlgMenu";
char               gszCommonWClass[]="CommonWClass";
char               gszAllocErrorMsg[]="Error Allocating Memory!";
char               gszLockErrorMsg[]="Error Locking Memory!";
char               gszFontMsg[]="Hello Windows World!";
char               gszPrintMsg[]="Common Dialog Print Sample";
char               gszTestDoc[]="Test-Doc";
char               gszWin31wh[]="win31wh.hlp";
char               gszLoadStrFail[]="LoadString failed!";
char               gszFOSuccess[]="File successfully opened and closed";
char               gszFOFailure[]="Failure finding specified file";
char               gszFilter[256];
char               gszBuffer[256];

#endif

#ifndef ININIT

extern HANDLE      ghInst;
extern HWND        ghWnd;
extern HWND        ghFFRDlg;
extern HWND        ghPrintingDlg;
extern HBRUSH      ghBkgndBrush, ghDlgBrush;
extern HFONT       ghSelectedFont;
extern WORD        wFRMsg;
extern WORD        wHelpMsg;
extern BOOL        gbMonochrome;
extern BOOL        gbUserAbort;
extern FARHOOK	   lpfnFileOpenHook, lpfnFindHook, lpfnFindReplaceHook;
extern char        gszAppName[];
extern char        gszMenuName[];
extern char        gszCommonWClass[];
extern char        gszAllocErrorMsg[];
extern char        gszLockErrorMsg[];
extern char        gszFontMsg[];
extern char        gszPrintMsg[];
extern char        gszTestDoc[];
extern char        gszWin31wh[];
extern char        gszLoadStrFail[];
extern char        gszFOSuccess[];
extern char        gszFOFailure[];
extern char        gszFilter[256];
extern char        gszBuffer[256];

#endif

/****************************************************************************
*                                                                           *
*                             FUNCTION PROTOTYPES                           *
*                                                                           *
****************************************************************************/

long FAR PASCAL __export MainWndProc(HWND, UINT, WPARAM,LPARAM);
int      PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
BOOL FAR        InitInstance(HANDLE, int);
void FAR        ProcessCDError(DWORD);
void FAR        ReportError(WORD);
BOOL FAR PASCAL __export About(HWND, UINT, WPARAM,LPARAM);
BOOL FAR PASCAL __export FileOpenHook(HWND, UINT, WPARAM, LPARAM);
BOOL FAR PASCAL __export FindHook(HWND, UINT, WPARAM, LPARAM);
BOOL FAR PASCAL __export FindReplaceHook(HWND, UINT, WPARAM, LPARAM);
BOOL FAR PASCAL __export PrintDlgProc(HWND, UINT, WPARAM, LPARAM);
BOOL FAR PASCAL __export AbortProc(HDC, int);

/****************************************************************************
*                                                                           *
*                          COMMOND DIALOG NOTIFICATION CODES                *
*                                                                           *
****************************************************************************/

#define CDN_FIND             1
#define CDN_FINDREPLACE      2


/****************************************************************************
*                                                                           *
*                          FILE OPEN STRUCTURE                              *
*                                                                           *
****************************************************************************/
typedef struct tagFOCHUNK
   {
      OPENFILENAME of;
      char szFile[MAXFILENAMELEN];
      char szFileTitle[MAXFILETITLELEN];
   }
FOCHUNK;

typedef FOCHUNK FAR *LPFOCHUNK;
typedef FOCHUNK FAR *LPFSCHUNK;


/****************************************************************************
*                                                                           *
*                          COLORS STRUCTURE                                 *
*                                                                           *
****************************************************************************/
typedef struct tagCOLORSCHUNK
   {
      CHOOSECOLOR chsclr;
      DWORD dwColor;
      DWORD dwCustClrs[16];
   }
COLORSCHUNK;

typedef COLORSCHUNK FAR *LPCOLORSCHUNK;


/****************************************************************************
*                                                                           *
*                          FIND STRUCTURE                                   *
*                                                                           *
****************************************************************************/

typedef struct tagFINDREPLACECHUNK
   {
      FINDREPLACE fr;
      char szFindWhat[MAXFINDWHATLEN];
      char szReplaceWith[MAXREPLACEWITHLEN];
   }
FINDREPLACECHUNK;

typedef FINDREPLACECHUNK FAR *LPFINDREPLACECHUNK;


