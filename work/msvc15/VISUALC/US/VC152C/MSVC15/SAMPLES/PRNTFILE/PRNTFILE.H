#include "resource.h"

#define MAXFILESIZE 1000000    /* maximum file size (in bytes) that can be loaded */
#define MAXFILENAME 256 	     /* maximum length of file pathname      */
#define MAXCUSTFILTER 40	     /* maximum size of custom filter buffer */


int PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
BOOL InitApplication(HANDLE);
BOOL InitInstance(HANDLE, int);
long FAR PASCAL _export MainWndProc(HWND, UINT, WPARAM, LPARAM);
BOOL FAR PASCAL _export About(HWND, unsigned, WORD, LONG);
BOOL SaveFile(HWND);
BOOL QuerySaveFile(HWND);
void SetNewBuffer(HWND, HANDLE, PSTR);
HANDLE GetPrinterDC();
int FAR PASCAL _export AbortProc(HDC, int);
int FAR PASCAL _export AbortDlg(HWND, unsigned, WORD, LONG);
