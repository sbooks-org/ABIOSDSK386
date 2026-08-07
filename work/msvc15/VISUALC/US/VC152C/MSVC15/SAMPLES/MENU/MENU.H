/****************************************************************************
 *									    *
 *  FILE	: Menu.h						    *
 *									    *
 *  DESCRIPTION : Header file for the Menu Example application. 	    *
 *									    *
 ****************************************************************************/

#include "resource.h"

/* BitBlt Raster operation */
#define ROP_PSDPxax	0x00B8074AL

int PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
BOOL NEAR PASCAL MenuInit(HANDLE);
long FAR PASCAL __export MenuWndProc(HWND, UINT, WPARAM, LPARAM);
BOOL FAR PASCAL __export About(HWND, unsigned, WORD, LONG);
