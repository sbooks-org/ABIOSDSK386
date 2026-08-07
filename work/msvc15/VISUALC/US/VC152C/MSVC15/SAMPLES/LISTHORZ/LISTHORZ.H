/*
 * Control Identifiers.
 */
#include "resource.h"

long __export CALLBACK ListHScrollWndProc(HWND, UINT, WPARAM, LPARAM);

/*
 * Protoypes of the 'API' defined in listhelp.c
 */
BOOL FAR PASCAL FInitListboxExtents(HWND);
WORD FAR PASCAL WAddExtentEntry(HWND, LPSTR);
WORD FAR PASCAL WRemoveExtentEntry(HWND, WORD);
BOOL FAR PASCAL FFreeListboxExtents(HWND);
void FAR PASCAL ResetListboxExtents(HWND);
