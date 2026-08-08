/*
 * ABIOSDSK Version 0.90 prerelease Windows stressor
 * Copyright (C) 2026 Simplebooks Foundation
 * Copyright (C) 2026 Josh Rodd
 */

#define STRICT
#define WINVER 0x030A
#include <windows.h>
#include <malloc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BLOCK_BYTES 133120L
#define BLOCK_COUNT 4
#define TIMER_ID 1
#define TIMER_MILLISECONDS 250

static HWND main_window;
static unsigned char huge *buffer;
static unsigned long generations[BLOCK_COUNT];
static unsigned long seed = 0x31574E31UL;
static unsigned long random_state;
static unsigned long operations;
static unsigned long reads;
static unsigned long writes;
static HFILE file_handle = HFILE_ERROR;
static char file_name[128] = "WSTRS.DAT";
static char status_text[160] = "Starting";
static int failed;
static int auto_dos;

static unsigned long pattern_base(unsigned block, unsigned long generation)
{
    return seed + generation * 29UL + ((unsigned long)block + 1UL) * 71UL;
}

static unsigned char pattern_byte(unsigned long base, unsigned long position)
{
    unsigned long value = base + position + (position >> 8) + (position >> 16);
    return (unsigned char)(value ^ (value >> 8));
}

static void fill_pattern(unsigned block, unsigned long generation)
{
    unsigned long i;
    unsigned long base = pattern_base(block, generation);

    for (i = 0; i < BLOCK_BYTES; ++i)
        buffer[i] = pattern_byte(base, i);
}

static int check_pattern(unsigned block, unsigned long generation,
                         unsigned long *bad_position,
                         unsigned char *expected, unsigned char *actual)
{
    unsigned long i;
    unsigned long base = pattern_base(block, generation);
    unsigned char wanted;

    for (i = 0; i < BLOCK_BYTES; ++i) {
        wanted = pattern_byte(base, i);
        if (buffer[i] != wanted) {
            *bad_position = i;
            *expected = wanted;
            *actual = buffer[i];
            return 0;
        }
    }
    return 1;
}

static int position_file(unsigned block)
{
    long offset = (long)block * BLOCK_BYTES;
    return _llseek(file_handle, offset, 0) == offset;
}

static int read_block(unsigned block)
{
    return position_file(block) &&
           _hread(file_handle, (void huge *)buffer, BLOCK_BYTES) == BLOCK_BYTES;
}

static int write_block(unsigned block)
{
    return position_file(block) &&
           _hwrite(file_handle, (const void huge *)buffer, BLOCK_BYTES) == BLOCK_BYTES;
}

static int reopen_file(void)
{
    if (file_handle != HFILE_ERROR)
        _lclose(file_handle);
    file_handle = _lopen(file_name, OF_READWRITE | OF_SHARE_EXCLUSIVE);
    return file_handle != HFILE_ERROR;
}

static int initialize_file(void)
{
    unsigned block;

    file_handle = _lcreat(file_name, 0);
    if (file_handle == HFILE_ERROR)
        return 0;
    for (block = 0; block < BLOCK_COUNT; ++block) {
        generations[block] = 0;
        fill_pattern(block, generations[block]);
        if (!write_block(block))
            return 0;
    }
    return reopen_file();
}

static unsigned next_random(void)
{
    random_state = random_state * 1664525UL + 1013904223UL;
    return (unsigned)(random_state >> 16);
}

static void stop_with_error(const char *message)
{
    failed = 1;
    KillTimer(main_window, TIMER_ID);
    lstrcpyn(status_text, message, sizeof(status_text));
    InvalidateRect(main_window, NULL, TRUE);
    MessageBox(main_window, status_text, "WSTRS disk stress failure",
               MB_OK | MB_ICONHAND | MB_TASKMODAL);
}

static void perform_operation(void)
{
    unsigned block;
    int writing;
    unsigned long bad_position;
    unsigned char expected;
    unsigned char actual;
    char message[160];

    ++operations;
    block = next_random() % BLOCK_COUNT;
    writing = (next_random() & 1) != 0;

    if (writing) {
        ++generations[block];
        fill_pattern(block, generations[block]);
        if (!write_block(block)) {
            sprintf(message, "WRITE FAILED: operation %lu block %u", operations,
                    block);
            stop_with_error(message);
            return;
        }
        ++writes;
        if (!reopen_file()) {
            sprintf(message, "REOPEN FAILED: operation %lu", operations);
            stop_with_error(message);
            return;
        }
    } else {
        ++reads;
    }

    if (!read_block(block)) {
        sprintf(message, "READ FAILED: operation %lu block %u", operations,
                block);
        stop_with_error(message);
        return;
    }
    if (!check_pattern(block, generations[block], &bad_position,
                       &expected, &actual)) {
        sprintf(message,
                "CORRUPTION: op=%lu block=%u offset=%lu expected=%02X actual=%02X",
                operations, block,
                (unsigned long)block * BLOCK_BYTES + bad_position,
                expected, actual);
        stop_with_error(message);
        return;
    }

    sprintf(status_text,
            "RUNNING: %lu operations, %lu reads, %lu writes; last=%s block %u",
            operations, reads, writes, writing ? "write/read" : "read", block);
    InvalidateRect(main_window, NULL, FALSE);
}

static void parse_command_line(LPSTR command_line)
{
    char *end;
    int length = 0;

    while (*command_line == ' ' || *command_line == '\t')
        ++command_line;
    if (*command_line == '"') {
        ++command_line;
        while (*command_line && *command_line != '"' &&
               length < sizeof(file_name) - 1)
            file_name[length++] = *command_line++;
        if (*command_line == '"')
            ++command_line;
    } else if (*command_line) {
        while (*command_line && *command_line != ' ' && *command_line != '\t' &&
               length < sizeof(file_name) - 1)
            file_name[length++] = *command_line++;
    }
    if (length != 0)
        file_name[length] = '\0';

    while (*command_line == ' ' || *command_line == '\t')
        ++command_line;
    if (*command_line) {
        seed = strtoul(command_line, &end, 0);
        command_line = end;
        while (*command_line == ' ' || *command_line == '\t')
            ++command_line;
        if ((*command_line == 'A' || *command_line == 'a') &&
            (command_line[1] == 'U' || command_line[1] == 'u') &&
            (command_line[2] == 'T' || command_line[2] == 't') &&
            (command_line[3] == 'O' || command_line[3] == 'o'))
            auto_dos = 1;
    }
}

static void yield_for_dos_startup(void)
{
    DWORD started = GetTickCount();

    do {
        Yield();
    } while (GetTickCount() - started < 3000UL);
}


static int launch_dos_stressors(void)
{
    UINT result;

    result = WinExec("C:\\STRSSTST\\DSTRS1.PIF", SW_SHOWNOACTIVATE);
    if (result < 32)
        return 0;
    yield_for_dos_startup();
    result = WinExec("C:\\STRSSTST\\DSTRS2.PIF", SW_SHOWNOACTIVATE);
    return result >= 32;
}

static void paint_window(HWND window)
{
    PAINTSTRUCT paint;
    HDC dc;
    char line[160];

    dc = BeginPaint(window, &paint);
    TextOut(dc, 8, 8, "ABIOSDSK 130K protected-mode stress", 38);
    sprintf(line, "File: %s", file_name);
    TextOut(dc, 8, 28, line, strlen(line));
    sprintf(line, "Seed: %08lX; request size: %lu bytes; file size: %lu bytes",
            seed, BLOCK_BYTES, BLOCK_BYTES * BLOCK_COUNT);
    TextOut(dc, 8, 48, line, strlen(line));
    TextOut(dc, 8, 68, status_text, strlen(status_text));
    TextOut(dc, 8, 96,
            "Each write is closed/reopened, read back, and byte-verified.", 60);
    EndPaint(window, &paint);
}

static LRESULT CALLBACK window_proc(HWND window, UINT message,
                                    WPARAM w_param, LPARAM l_param)
{
    switch (message) {
    case WM_TIMER:
        if (!failed)
            perform_operation();
        return 0;
    case WM_PAINT:
        paint_window(window);
        return 0;
    case WM_DESTROY:
        KillTimer(window, TIMER_ID);
        if (file_handle != HFILE_ERROR)
            _lclose(file_handle);
        if (buffer != NULL)
            _hfree(buffer);
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProc(window, message, w_param, l_param);
}

int PASCAL WinMain(HINSTANCE instance, HINSTANCE previous_instance,
                   LPSTR command_line, int show_command)
{
    WNDCLASS window_class;
    MSG message;

    parse_command_line(command_line);
    random_state = seed ^ 0xA5A55A5AUL;
    buffer = (unsigned char huge *)_halloc(BLOCK_BYTES, 1);
    if (buffer == NULL) {
        MessageBox(NULL, "Cannot allocate 130K huge buffer", "WSTRS",
                   MB_OK | MB_ICONHAND);
        return 2;
    }

    if (!previous_instance) {
        memset(&window_class, 0, sizeof(window_class));
        window_class.style = CS_HREDRAW | CS_VREDRAW;
        window_class.lpfnWndProc = window_proc;
        window_class.hInstance = instance;
        window_class.hIcon = LoadIcon(NULL, IDI_APPLICATION);
        window_class.hCursor = LoadCursor(NULL, IDC_ARROW);
        window_class.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
        window_class.lpszClassName = "ABIOSDSK_WSTRS";
        if (!RegisterClass(&window_class)) {
            MessageBox(NULL, "Cannot register window class", "WSTRS",
                       MB_OK | MB_ICONHAND);
            _hfree(buffer);
            return 2;
        }
    }

    main_window = CreateWindow("ABIOSDSK_WSTRS", "ABIOSDSK WSTRS",
                               WS_OVERLAPPEDWINDOW,
                               20, 270, 580, 150,
                               NULL, NULL, instance, NULL);
    if (main_window == NULL) {
        MessageBox(NULL, "Cannot create window", "WSTRS", MB_OK | MB_ICONHAND);
        _hfree(buffer);
        return 2;
    }

    ShowWindow(main_window, show_command);
    UpdateWindow(main_window);
    lstrcpy(status_text, "INITIALIZING: writing four 130K pattern blocks");
    InvalidateRect(main_window, NULL, TRUE);
    UpdateWindow(main_window);

    if (!initialize_file()) {
        stop_with_error("INITIALIZATION FAILED: cannot create/write stress file");
    } else if (auto_dos && !launch_dos_stressors()) {
        stop_with_error("AUTO FAILED: cannot launch DOS stress windows");
    } else {
        if (auto_dos)
            lstrcpy(status_text, "RUNNING: two DOS stress windows launched");
        else
            lstrcpy(status_text, "RUNNING: initialized; no corruption detected");
        SetTimer(main_window, TIMER_ID, TIMER_MILLISECONDS, NULL);
    }

    while (GetMessage(&message, NULL, 0, 0)) {
        TranslateMessage(&message);
        DispatchMessage(&message);
    }
    return failed ? 1 : 0;
}
