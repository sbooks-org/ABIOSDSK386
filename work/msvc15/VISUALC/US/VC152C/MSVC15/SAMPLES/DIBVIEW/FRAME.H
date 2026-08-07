
#ifndef FRAME_INCLUDED
#define FRAME_INCLUDED

long FAR PASCAL __export FrameWndProc(HWND hWnd,
			     UINT message,
			     WPARAM wParam,
			     LPARAM lParam);


HWND OpenDIBWindow (HANDLE hDIB, LPSTR szTitle);

void EnableWindowAndOptionsMenus (BOOL bEnable);

#endif // FRAME_INCLUDED
