/* lowpass.h - Header file for LOWPASS sample application.
 */
#include "resource.h"

/* Function Prototypes
 */
void DoLowPass(HWND hwnd);
int PASCAL WinMain(HINSTANCE hInst, HINSTANCE hPrev, LPSTR lpszCmdLine,
    int iCmdShow);
BOOL FAR PASCAL __export AboutDlgProc(HWND hwnd, unsigned wMsg,
    WORD wParam, LONG lParam);
BOOL FAR PASCAL __export LowPassDlgProc(HWND hwnd, unsigned wMsg,
    WORD wParam, LONG lParam);
