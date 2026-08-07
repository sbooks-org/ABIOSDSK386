#include "resource.h"

//*********************** Misc. defines

#define STATUS_WIDTH            400
#define STATUS_HEIGHT           100
#define INFO_LINE_WIDTH         300
#define INFO_LINE_HEIGHT        18
#define INFO_LINE_X             10
#define INFO_LINE_Y             20
#define ID_STATUSTIMER          99
#define INFO_STR_LEN            50
#define TIMER_DURATION          1500        // 1.5 seconds
#define PATH_NAME_LEN           260
#define VOLUME_NAME_LEN         14
#define SHARE_NAME_LEN          128
#define SMALL_STR_LEN           12
#define LONG_STR_LEN            60



//*********************** Function prototypes

HMENU FAR PASCAL __export FMExtensionProc (HWND hwndXtension, WORD wMesssage,
                                  LONG lParam);

long FAR PASCAL __export StatusWndProc (HWND hWnd,   UINT uMessage,
                   WPARAM wParam, LPARAM lParam);

BOOL FAR PASCAL __export AboutDlgProc (HWND hDlg,   unsigned uMessage,
                              WORD wParam, LONG lParam);


BOOL FAR PASCAL __export DriveInfoDlgProc (HWND hDlg,   unsigned uMessage,
                                  WORD wParam, LONG lParam);

BOOL FAR PASCAL __export SelFileInfoDlgProc (HWND hDlg,   unsigned uMessage,
                                    WORD wParam, LONG lParam);

BOOL CreateStatusWindow (HWND hwndExtension);

void DisplayStatus (HWND hwndExtension, WORD wEvent);
