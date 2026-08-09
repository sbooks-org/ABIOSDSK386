#define STRICT
#define WINVER 0x030A
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TIMER_ID 1
#ifndef BM_CLICK
#define BM_CLICK 0x00F5
#endif
#define TIMER_MS 25
#define INPUT_SIZE 512

static int comm_id = -1;
static char input[INPUT_SIZE];
static unsigned input_used;

static void send_text(const char *text)
{
    if (comm_id >= 0)
        WriteComm(comm_id, text, (int)strlen(text));
}

static void clean_text(char *text)
{
    char *p;
    for (p = text; *p; ++p)
        if (*p == '\r' || *p == '\n' || *p == '|') *p = ' ';
}

static void report_window(HWND window, HWND parent)
{
    char class_name[64];
    char title[128];
    char line[320];
    RECT rect;
    GetClassName(window, class_name, sizeof(class_name));
    GetWindowText(window, title, sizeof(title));
    clean_text(class_name);
    clean_text(title);
    GetWindowRect(window, &rect);
    sprintf(line, "W %04X %04X %d %d %d %d %u %u %s|%s\r\n",
            (unsigned)window, (unsigned)parent,
            rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top,
            IsWindowVisible(window) != 0, IsWindowEnabled(window) != 0,
            class_name, title);
    send_text(line);
}

static BOOL FAR PASCAL child_proc(HWND window, LPARAM data)
{
    report_window(window, GetParent(window));
    (void)data;
    return TRUE;
}

static BOOL FAR PASCAL window_proc(HWND window, LPARAM data)
{
    report_window(window, NULL);
    EnumChildWindows(window, child_proc, 0L);
    (void)data;
    return TRUE;
}

static HWND parse_window(const char *text)
{
    return (HWND)(unsigned)strtoul(text, NULL, 16);
}

static void dispatch(char *line)
{
    char *arg;
    HWND window, parent;
    unsigned key;
    int control_id;

    while (*line == ' ') ++line;
    arg = strchr(line, ' ');
    if (arg != NULL) {
        *arg++ = '\0';
        while (*arg == ' ') ++arg;
    }
    if (stricmp(line, "PING") == 0) {
        send_text("OK PONG\r\n");
    } else if (stricmp(line, "LIST") == 0) {
        EnumWindows(window_proc, 0L);
        send_text("END\r\n");
    } else if (arg != NULL && stricmp(line, "ACTIVATE") == 0) {
        window = parse_window(arg);
        if (IsWindow(window)) {
            ShowWindow(window, SW_RESTORE);
            SetActiveWindow(window);
            SetFocus(window);
            send_text("OK\r\n");
        } else send_text("ERR HWND\r\n");
    } else if (arg != NULL && stricmp(line, "CLICK") == 0) {
        window = parse_window(arg);
        if (IsWindow(window) && IsWindowEnabled(window)) {
            parent = GetParent(window);
            control_id = GetDlgCtrlID(window);
            if (parent != NULL && control_id >= 0) {
                SendMessage(parent, WM_COMMAND, control_id,
                            MAKELONG(window, BN_CLICKED));
            } else {
                SendMessage(window, WM_LBUTTONDOWN, MK_LBUTTON, 0L);
                SendMessage(window, WM_LBUTTONUP, 0, 0L);
            }
            send_text("OK\r\n");
        } else send_text("ERR HWND\r\n");
    } else if (arg != NULL && stricmp(line, "TEXT") == 0) {
        char *value = strchr(arg, ' ');
        if (value == NULL) { send_text("ERR ARGS\r\n"); return; }
        *value++ = '\0';
        window = parse_window(arg);
        if (IsWindow(window)) {
            SendMessage(window, WM_SETTEXT, 0, (LPARAM)(LPSTR)value);
            send_text("OK\r\n");
        } else send_text("ERR HWND\r\n");
    } else if (arg != NULL && stricmp(line, "KEY") == 0) {
        char *value = strchr(arg, ' ');
        if (value == NULL) { send_text("ERR ARGS\r\n"); return; }
        *value++ = '\0';
        window = parse_window(arg);
        key = (unsigned)strtoul(value, NULL, 0);
        if (IsWindow(window)) {
            SendMessage(window, WM_KEYDOWN, key, 1L);
            SendMessage(window, WM_KEYUP, key, 0xC0000001L);
            send_text("OK\r\n");
        } else send_text("ERR HWND\r\n");
    } else {
        send_text("ERR COMMAND\r\n");
    }
}

static void poll_comm(void)
{
    char chunk[64];
    int count, i;
    count = ReadComm(comm_id, chunk, sizeof(chunk));
    if (count < 0) count = -count;
    for (i = 0; i < count; ++i) {
        char ch = chunk[i];
        if (ch == '\r' || ch == '\n') {
            if (input_used) {
                input[input_used] = '\0';
                dispatch(input);
                input_used = 0;
            }
        } else if (input_used + 1 < INPUT_SIZE) {
            input[input_used++] = ch;
        } else {
            input_used = 0;
            send_text("ERR LONG\r\n");
        }
    }
}

static LRESULT FAR PASCAL agent_proc(HWND window, UINT message,
                                     WPARAM wparam, LPARAM lparam)
{
    switch (message) {
    case WM_TIMER:
        poll_comm();
        return 0;
    case WM_DESTROY:
        KillTimer(window, TIMER_ID);
        if (comm_id >= 0) CloseComm(comm_id);
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProc(window, message, wparam, lparam);
}

int PASCAL WinMain(HINSTANCE instance, HINSTANCE previous,
                   LPSTR command_line, int show)
{
    WNDCLASS wc;
    HWND window;
    MSG message;
    DCB dcb;
    COMSTAT status;

    (void)command_line;
    (void)show;
    if (!previous) {
        memset(&wc, 0, sizeof(wc));
        wc.lpfnWndProc = agent_proc;
        wc.hInstance = instance;
        wc.lpszClassName = "UIAgent";
        if (!RegisterClass(&wc)) return 1;
    }
    comm_id = OpenComm("COM1", 1024, 1024);
    if (comm_id < 0) return 2;
    if (BuildCommDCB("COM1:9600,n,8,1", &dcb) < 0 ||
        SetCommState(&dcb) < 0) {
        CloseComm(comm_id);
        return 3;
    }
    GetCommError(comm_id, &status);
    window = CreateWindow("UIAgent", "UIAGENT COM1", WS_OVERLAPPED,
                          0, 0, 0, 0, NULL, NULL, instance, NULL);
    if (!window) { CloseComm(comm_id); return 4; }
    SetTimer(window, TIMER_ID, TIMER_MS, NULL);
    send_text("READY UIAGENT 1\r\n");
    while (GetMessage(&message, NULL, 0, 0)) {
        TranslateMessage(&message);
        DispatchMessage(&message);
    }
    return message.wParam;
}
