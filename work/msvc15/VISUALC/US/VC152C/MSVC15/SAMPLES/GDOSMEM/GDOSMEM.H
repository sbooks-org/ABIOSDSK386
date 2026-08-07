#include "resource.h"

int PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
BOOL InitApplication(HANDLE);
BOOL InitInstance(HANDLE, int);
long CALLBACK __export MainWndProc(HWND, UINT, WPARAM,LPARAM);
BOOL __export CALLBACK About(HWND, unsigned, WORD, LONG);

DWORD FAR PASCAL GlobalDosAlloc (DWORD);
UINT FAR PASCAL GlobalDosFree (UINT);

void SizeWindow (short *, short *);
void TSR_Check (void);
void TSR_Request (void);
