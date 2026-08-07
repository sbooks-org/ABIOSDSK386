/*
 * mcitest.h
 */
#include "resource.h"

/* Function prototypes.
 */
int PASCAL WinMain(HINSTANCE, HINSTANCE, LPSTR, int);
BOOL FAR PASCAL __export AboutDlgProc(HWND, unsigned, WORD, LONG);
PSTR PASCAL NEAR FileName(PSTR);
void PASCAL NEAR OpenMciFile(HWND, LPSTR);
int PASCAL NEAR get_number_of_devices(void);
void PASCAL NEAR update_device_list(void);
DWORD PASCAL NEAR sendstring(HWND, PSTR);
int PASCAL NEAR NDialog(int, HWND, FARPROC);
BOOL FAR PASCAL __export ErrDlgFunc(HWND, WORD, WORD, LONG);
void PASCAL NEAR execute(HWND, BOOL);
BOOL FAR PASCAL __export devices(HWND, WORD, WORD, LONG);
void PASCAL NEAR create_device_list(void);
BOOL FAR PASCAL __export mcitester(HWND, WORD, WORD, LONG);
BOOL PASCAL NEAR AppInit(HANDLE, HANDLE, LPSTR, WORD);
