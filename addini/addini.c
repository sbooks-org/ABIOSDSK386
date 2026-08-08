/* ABIOSDSK 0.90 prerelease INI helper.
 * Copyright (C) 2026 Simplebooks Foundation
 * Copyright (C) 2026 Josh Rodd
 *
 * Microsoft C 5.1, tiny model; PC-DOS/MS-DOS 3.10 or later.
 */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_FILE 32768U
static unsigned char file_data[MAX_FILE + 1U];

static int same_name(const unsigned char *p, const char *name, unsigned n)
{
    unsigned i;
    for (i = 0; i < n; ++i) {
        if (tolower(p[i]) != tolower((unsigned char)name[i]))
            return 0;
    }
    return name[n] == '\0';
}

static long insertion_point(const unsigned char *data, unsigned size,
                            const char *section)
{
    unsigned pos = 0;
    while (pos < size) {
        unsigned line = pos;
        unsigned end;
        while (line < size && (data[line] == ' ' || data[line] == '\t'))
            ++line;
        end = line;
        while (end < size && data[end] != '\r' && data[end] != '\n')
            ++end;
        if (line < end && data[line] == '[') {
            unsigned close = line + 1;
            while (close < end && data[close] != ']')
                ++close;
            if (close < end && same_name(data + line + 1, section,
                                         close - line - 1)) {
                pos = end;
                if (pos < size && data[pos] == '\r') ++pos;
                if (pos < size && data[pos] == '\n') ++pos;
                return (long)pos;
            }
        }
        pos = end;
        if (pos < size && data[pos] == '\r') ++pos;
        if (pos < size && data[pos] == '\n') ++pos;
    }
    return -1L;
}

int main(int argc, char **argv)
{
    FILE *f;
    unsigned char *data;
    unsigned size, got, i;
    long at;
    char line[128];

    if (argc < 4) {
        fputs("Usage: ADDINI file section line\r\n", stderr);
        return 2;
    }
    if (strlen(argv[1]) == 0 || strlen(argv[2]) > 31 ||
        argv[1][strlen(argv[1]) - 1] == '~')
        return 2;
    line[0] = '\0';
    for (i = 3; i < (unsigned)argc; ++i) {
        if (i != 3 && strlen(line) < sizeof(line) - 1) strcat(line, " ");
        if (strlen(line) + strlen(argv[i]) >= sizeof(line)) return 2;
        strcat(line, argv[i]);
    }
    if (line[0] == '\0') return 2;

    data = file_data;
    f = fopen(argv[1], "rb");
    if (f == NULL) return 3;
    got = (unsigned)fread(data, 1, MAX_FILE + 1U, f);
    if (ferror(f)) { fclose(f); return 4; }
    if (!feof(f) || got > MAX_FILE) { fclose(f); return 5; }
    size = got;
    fclose(f);

    at = insertion_point(data, size, argv[2]);
    if (at < 0) return 6;
    f = fopen(argv[1], "wb");
    if (f == NULL) return 7;
    if ((unsigned)at && fwrite(data, 1, (unsigned)at, f) != (unsigned)at)
        goto write_error;
    if ((unsigned)at == size && size && data[size - 1] != '\n')
        if (fwrite("\r\n", 1, 2, f) != 2) goto write_error;
    if (fwrite(line, 1, strlen(line), f) != strlen(line) ||
        fwrite("\r\n", 1, 2, f) != 2 ||
        fwrite(data + (unsigned)at, 1, size - (unsigned)at, f) !=
            size - (unsigned)at)
        goto write_error;
    if (fclose(f) != 0) return 7;
    return 0;

write_error:
    fclose(f);
    return 7;
}
