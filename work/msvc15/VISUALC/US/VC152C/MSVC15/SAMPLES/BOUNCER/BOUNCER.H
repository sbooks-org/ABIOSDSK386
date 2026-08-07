/* BOUNCER.H - Header file for BOUNCER sample screen saver application.
 */

#include <scrnsave.h>
#include "resource.h"

#define DEF_SOUND TRUE                  // Starting sound state
#define DEF_PAUSE TRUE                  // Starting bottom-pause state

/* Function prototypes
 */
void GetIniEntries(void);
void MoveImage(HWND hWnd);
void GetIniSettings(void);
void WriteProfileInt(LPSTR key, LPSTR tag, int i);
extern BOOL FAR PASCAL ScreenSaverConfigureDialog(HWND hDlg, UINT msg, WPARAM wParam, LPARAM lParam);
