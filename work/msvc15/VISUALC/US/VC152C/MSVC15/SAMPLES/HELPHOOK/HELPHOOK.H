// Function Prototypes...

int PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
BOOL InitApplication(HANDLE);
BOOL InitInstance(HANDLE, int);
long  __export CALLBACK MainWndProc(HWND, UINT, WPARAM, LPARAM);
BOOL  __export CALLBACK About(HWND, unsigned, WORD, LONG);
BOOL  __export CALLBACK SampleDialog(HWND, unsigned, WORD, LONG);
DWORD __export CALLBACK HelpMessageFilterHook(int, WORD, LPMSG);

#include "resource.h"
