#include <windows.h>
#include <windowsx.h>
#include <commdlg.h>
#include <toolhelp.h>
#include "dbwindll.h"
#include "resource.h"

//----- Standard command ID aliases

#define CTL_OK                  IDOK
#define CTL_CANCEL              IDCANCEL

// Message sent when second instance of app is run,
// in order to activate first instance.
//
#define WM_ACTIVATEFIRST        WM_USER

//----- Function declarations

BOOL DBWinInit(HINSTANCE hinst, HINSTANCE hinstPrev, int sw, LPSTR szCmdLine);
void DBWinTerminate(BOOL fEndSession);
LRESULT CALLBACK _export DBWinWndProc(HWND hwnd, UINT uiMessage, WPARAM wParam, LPARAM lParam);

void DoCommand(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);

BOOL CALLBACK _export NotifyCallback(UINT id, DWORD dwData);
BOOL SaveBuffer(HWND hwnd);

void OnBufferNotEmpty(void);

UINT CmdFromMode(UINT mode);
UINT ModeFromCmd(UINT cmd);

void DoInitMenu(HWND hwnd);
void SetTopmost(HWND hwnd, BOOL fTopmost);
void WriteDBWinState(HWND hwndMain);
void ReadDBWinState(HWND hwndMain);

void DoDebugOptions(HWND hwnd);
void DoSaveOptions(HWND hwnd);
void DoAllocBrk(HWND hwnd);
BOOL IsDebugSystem(HWND hwnd);

void DoAbout(HWND hwnd);
BOOL CALLBACK _export AboutDlgProc(HWND hwndDlg, UINT msg, WPARAM wParam, LPARAM lParam);
