/****************************************************************************
 Main.h

 The Main module handles the main program instance and window.

****************************************************************************/
#include "resource.h"

/* Menu IDs are of the form MII in hex where M is the menu group number
   and II is a unique item number for that menu group. */

#define MenuGroupFromID( id )    ((id) & 0xFF00)


/****************************************************************************
   Globals
****************************************************************************/

extern HANDLE  hInst;			   /* current instance */
extern HWND    hwndMain;         /* main program window */
extern HWND    hwndView;         /* drawing view window */
extern HDC     drawDC;           /* the off-screen drawing DC */


/****************************************************************************
   Functions
****************************************************************************/

int PASCAL WinMain( HANDLE hInstance, HANDLE hPrevInstance, LPSTR lpCmdLine, 
                    int nCmdShow );
BOOL InitApplication( HANDLE hInstance );
BOOL InitInstance( HANDLE hInstance, int nCmdShow );
void Fini( void );
long FAR PASCAL MainWndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam );
void HelpCmd( int item );
