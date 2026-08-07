#include "resource.h"

#define MAXFILESIZE 0x7fff           /* maximum file size that can be loaded */
#define MAXFILENAME 256 	     /* maximum length of file pathname      */
#define MAXCUSTFILTER 40	     /* maximum size of custom filter buffer */

int PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
BOOL InitApplication(HANDLE);
BOOL InitInstance(HANDLE, int);
long FAR PASCAL __export MainWndProc(HWND, UINT, WPARAM, LPARAM);
BOOL FAR PASCAL __export About(HWND, unsigned, WORD, LONG);
BOOL SaveFile(HWND);
BOOL QuerySaveFile(HWND);
void SetNewBuffer(HWND, HANDLE, PSTR);
