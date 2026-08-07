// Copyright 1991 Microsoft Corporation. All rights reserved.

#include "windows.h"
#include "resource.h"

#define WINDOWMENU  1  /* position of window menu     */
#define CBWNDEXTRA  0

#ifdef RC_INVOKED
#define ID(id) id
#else
#define ID(id) MAKEINTRESOURCE(id)
#endif

/* resource ID's */
#define IDBLANDFRAME  ID(1)
#define IDBLANDCHILD  ID(2)
#define IDBLANDMENU   ID(3)

/* External variable declarations */
extern HANDLE hInst;       /* application instance handle  */
extern HWND hwndFrame;     /* main window handle           */
extern HWND hwndMDIClient; /* handle of MDI Client window  */
extern LONG styleDefault;  /* default child creation state */
extern char szChild[];     /* class of child               */

/* External functions */
extern BOOL FAR PASCAL InitializeApplication(VOID);
extern BOOL FAR PASCAL InitializeInstance   (LPSTR,WORD);
extern HWND FAR PASCAL MakeNewChild         (char *);
extern LONG FAR PASCAL __export BlandFrameWndProc    (HWND,UINT,WPARAM,LPARAM);
extern LONG FAR PASCAL __export BlandMDIChildWndProc (HWND,UINT,WPARAM,LPARAM);
