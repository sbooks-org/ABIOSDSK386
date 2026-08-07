/****************************************************************************
 *									    *
 *  FILE	: OwnCombo.h						    *
 *									    *
 *  DESCRIPTION : Header file for OwnCombo example.			    *
 *									    *
 ****************************************************************************/

#include "resource.h"

int PASCAL WinMain(HANDLE, HANDLE, LPSTR, int);
long FAR  PASCAL __export OwnComboWndProc(HWND, UINT, WPARAM, LPARAM);
BOOL NEAR PASCAL OwnComboInit(HANDLE);
BOOL FAR  PASCAL __export About(HWND, unsigned, WORD, LONG);
BOOL FAR  PASCAL __export ListBoxExample(HWND, unsigned, WORD, LONG);
BOOL FAR  PASCAL __export ComboBoxExample(HWND, unsigned, WORD, LONG);
BOOL FAR  PASCAL __export OwnerComboBoxExample(HWND, unsigned, WORD, LONG);
