#include "resource.h"

//********************** Function prototypes

int PASCAL WinMain (HANDLE hInstance, HANDLE hPrevInstance,
                    LPSTR lpCmdLine,  int nCmdShow);

long FAR PASCAL __export MainWndProc (HWND hWnd,   UINT message,
                 WPARAM wParam, LPARAM lParam);

BOOL FAR PASCAL __export About (HWND hDlg,   unsigned message,
                       WORD wParam, LONG lParam);

BOOL FAR PASCAL __export Info (HWND hDlg,   unsigned message,
                      WORD wParam, LONG lParam);
