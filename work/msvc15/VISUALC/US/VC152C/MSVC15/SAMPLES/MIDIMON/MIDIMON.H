/*
 *    midimon.h
 */

#include "resource.h"

/* Compile-time application metrics
 */
#define MAX_NUM_DEVICES         8       // max # of MIDI input devices
#define INPUT_BUFFER_SIZE       200     // size of input buffer in events
#define DISPLAY_BUFFER_SIZE     1000    // size of display buffer in events



/* Custom messages sent by low-level callback to application
 */
#define MM_MIDIINPUT    WM_USER + 0


/* The label for the display window.
 */
#define LABEL " TIMESTAMP STATUS DATA1 DATA2 CHAN EVENT                 "

/* Structure for translating virtual key messages to scroll messages.
 */
typedef struct keyToScroll_tag
{
     WORD wVirtKey;
     int  iMessage;
     WORD wRequest;
} KEYTOSCROLL;

/* Structure to represent a single MIDI event.
 */
typedef struct event_tag
{
    DWORD dwDevice;
    DWORD timestamp;
    DWORD data;
} EVENT;
typedef EVENT FAR *LPEVENT;


/* Function prototypes
 */
long FAR PASCAL __export WndProc(HWND, UINT, WPARAM ,LPARAM );
void CommandMsg(HWND hWnd, WORD wParam, LONG lParam);
void DoMenuItemCheck(HWND hWnd, WORD menuItem, BOOL newState);
void SetupCustomChecks(HANDLE hInstance, HWND hWnd);
BOOL InitFirstInstance(HANDLE);
int Error(LPSTR msg);
