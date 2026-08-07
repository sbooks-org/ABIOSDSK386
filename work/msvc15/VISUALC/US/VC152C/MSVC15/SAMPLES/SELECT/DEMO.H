#include "resource.h"

int PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
BOOL DemoInit(HANDLE);
long FAR PASCAL __export DemoWndProc(HWND, UINT, WPARAM, LPARAM);
BOOL FAR PASCAL __export About(HWND, unsigned, WORD, LONG);
