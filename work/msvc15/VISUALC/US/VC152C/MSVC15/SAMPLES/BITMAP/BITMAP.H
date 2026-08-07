#include "resource.h"

#define PATORDEST             0x00FA0089L

int PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
BOOL InitApplication(HANDLE);
BOOL InitInstance(HANDLE, int);
long FAR PASCAL __export MainWndProc(HWND, UINT, WPARAM, LPARAM);
BOOL FAR PASCAL __export About(HWND, unsigned, WORD, LONG);
HBITMAP MakeColorBitmap(HWND);
