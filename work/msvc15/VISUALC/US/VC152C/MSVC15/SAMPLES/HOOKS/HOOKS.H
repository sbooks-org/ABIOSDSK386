#include "resource.h"

#define CALLWNDPROCINDEX     0
#define CBTINDEX	     	 (IDM_CBT		 	  - IDM_CALLWNDPROC)
#define GETMESSAGEINDEX      (IDM_GETMESSAGE	  - IDM_CALLWNDPROC)
#define JOURNALPLAYBACKINDEX (IDM_JOURNALPLAYBACK - IDM_CALLWNDPROC)
#define JOURNALRECORDINDEX   (IDM_JOURNALRECORD   - IDM_CALLWNDPROC)
#define KEYBOARDINDEX	     (IDM_KEYBOARD	 	  - IDM_CALLWNDPROC)
#define MOUSEINDEX	    	 (IDM_MOUSE 	 	  - IDM_CALLWNDPROC)
#define MSGFILTERINDEX	     (IDM_MSGFILTER	 	  - IDM_CALLWNDPROC)
#define SYSMSGFILTERINDEX    (IDM_SYSMSGFILTER	  - IDM_CALLWNDPROC)

#define NUMOFHOOKS 9


//
// Entry functions for the DLL
//
int __export CALLBACK InitHooksDll(HWND hwndMainWindow, int nWinLineHeight);
int __export CALLBACK PaintHooksDll(HDC hDC );
int __export CALLBACK InstallFilter (int nHookIndex, int nCode );
