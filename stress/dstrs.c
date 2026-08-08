/*
 * ABIOSDSK Version 0.90 prerelease DOS stressor
 * Copyright (C) 2026 Simplebooks Foundation
 * Copyright (C) 2026 Josh Rodd
 */

#include <dos.h>
#include <fcntl.h>
#include <conio.h>
#include <io.h>
#include <malloc.h>
#include <share.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define BLOCK_BYTES 133120L
#define BLOCK_COUNT 4
#define IO_CHUNK 0xF000U

static unsigned char huge *buffer;
static unsigned long generations[BLOCK_COUNT];
static unsigned long seed;
static unsigned long random_state;
static const char *file_name;
static unsigned long keyboard_count;
static unsigned last_key;


static void service_keyboard(void)
{
    int key;
    int scan;

    while (kbhit()) {
        key = getch();
        ++keyboard_count;
        fputs("\r\nDSTRS: keyboard echo: ", stdout);
        if (key == 0 || key == 0xE0) {
            scan = getch();
            last_key = 0x100U | (unsigned char)scan;
            printf("<EXT-%02X>", (unsigned char)scan);
        } else {
            last_key = (unsigned char)key;
            if (key >= 0x20 && key <= 0x7E)
                putchar(key);
            else if (key == '\r')
                fputs("<ENTER>", stdout);
            else if (key == '\t')
                fputs("<TAB>", stdout);
            else if (key == '\b')
                fputs("<BACKSPACE>", stdout);
            else
                printf("<%02X>", (unsigned char)key);
        }
        printf(" (key %lu)\n", keyboard_count);
        fflush(stdout);
    }
}



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

    for (i = 0; i < BLOCK_BYTES; ++i) {
        buffer[i] = pattern_byte(base, i);
        if ((i & 0x0FFFUL) == 0)
            service_keyboard();
    }
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
        if ((i & 0x0FFFUL) == 0)
            service_keyboard();
        if (buffer[i] != wanted) {
            *bad_position = i;
            *expected = wanted;
            *actual = buffer[i];
            return 0;
        }
    }
    return 1;
}

static int transfer(int handle, int writing)
{
    unsigned char huge *position = buffer;
    unsigned long remaining = BLOCK_BYTES;
    unsigned chunk;
    int result;

    while (remaining != 0) {
        chunk = remaining > IO_CHUNK ? IO_CHUNK : (unsigned)remaining;
        if (writing)
            result = write(handle, (const void far *)position, chunk);
        else
            result = read(handle, (void far *)position, chunk);
        if (result != (int)chunk)
            return 0;
        position += chunk;
        remaining -= chunk;
        service_keyboard();
    }
    return 1;
}

static int open_file(int truncate)
{
    int flags = O_RDWR | O_BINARY | O_CREAT;

    if (truncate)
        flags |= O_TRUNC;
    return sopen(file_name, flags, SH_DENYRW, S_IREAD | S_IWRITE);
}

static int position_file(int handle, unsigned block)
{
    long offset = (long)block * BLOCK_BYTES;
    return lseek(handle, offset, SEEK_SET) == offset;
}

static int read_block(int handle, unsigned block)
{
    return position_file(handle, block) && transfer(handle, 0);
}

static int write_block(int handle, unsigned block)
{
    return position_file(handle, block) && transfer(handle, 1);
}

static int initialize_file(void)
{
    int handle;
    unsigned block;

    handle = open_file(1);
    if (handle < 0)
        return 0;
    for (block = 0; block < BLOCK_COUNT; ++block) {
        generations[block] = 0;
        fill_pattern(block, generations[block]);
        if (!write_block(handle, block)) {
            close(handle);
            return 0;
        }
    }
    return close(handle) == 0;
}

static unsigned next_random(void)
{
    random_state = random_state * 1664525UL + 1013904223UL;
    return (unsigned)(random_state >> 16);
}

static int verify_block(int handle, unsigned block, unsigned long operation)
{
    unsigned long bad_position;
    unsigned char expected;
    unsigned char actual;

    if (!read_block(handle, block)) {
        fprintf(stderr, "DSTRS: read failed at operation %lu block %u\n",
                operation, block);
        return 0;
    }
    if (!check_pattern(block, generations[block], &bad_position,
                       &expected, &actual)) {
        fprintf(stderr,
                "DSTRS: CORRUPTION op=%lu block=%u file-offset=%lu "
                "expected=%02X actual=%02X\n",
                operation, block, (unsigned long)block * BLOCK_BYTES + bad_position,
                expected, actual);
        return 0;
    }
    return 1;
}

int main(int argc, char **argv)
{
    unsigned long operation = 0;
    unsigned long limit = 0;
    unsigned block;
    int writing;
    int handle;
    const char *result_name;
    FILE *result;

    file_name = argc > 1 ? argv[1] : "DSTRS.DAT";
    seed = argc > 2 ? strtoul(argv[2], NULL, 0) : 0xD05D1234UL;
    if (argc > 3)
        limit = strtoul(argv[3], NULL, 0);
    result_name = argc > 4 ? argv[4] : NULL;
    if (result_name != NULL)
        unlink(result_name);
    random_state = seed ^ 0xA5A55A5AUL;

    buffer = (unsigned char huge *)_halloc(BLOCK_BYTES, 1);
    if (buffer == NULL) {
        fputs("DSTRS: cannot allocate 130K buffer\n", stderr);
        return 2;
    }

    printf("DSTRS: file=%s seed=%08lX request=%lu bytes blocks=%u\n",
           file_name, seed, BLOCK_BYTES, BLOCK_COUNT);
    puts("DSTRS: initializing and verifying file; Ctrl-C stops an unlimited run.");

    if (!initialize_file()) {
        fprintf(stderr, "DSTRS: cannot initialize %s\n", file_name);
        _hfree(buffer);
        return 2;
    }

    handle = open_file(0);
    if (handle < 0) {
        fprintf(stderr, "DSTRS: cannot reopen %s\n", file_name);
        _hfree(buffer);
        return 2;
    }

    while (limit == 0 || operation < limit) {
        service_keyboard();
        ++operation;
        block = next_random() % BLOCK_COUNT;
        writing = (next_random() & 1) != 0;

        if (writing) {
            ++generations[block];
            fill_pattern(block, generations[block]);
            if (!write_block(handle, block)) {
                fprintf(stderr, "DSTRS: write failed at operation %lu block %u\n",
                        operation, block);
                close(handle);
                _hfree(buffer);
                return 1;
            }
            if (close(handle) != 0) {
                fprintf(stderr, "DSTRS: close failed at operation %lu\n", operation);
                _hfree(buffer);
                return 1;
            }
            handle = open_file(0);
            if (handle < 0) {
                fprintf(stderr, "DSTRS: reopen failed at operation %lu\n", operation);
                _hfree(buffer);
                return 1;
            }
        }

        if (!verify_block(handle, block, operation)) {
            close(handle);
            _hfree(buffer);
            return 1;
        }
        service_keyboard();

        printf("\rDSTRS: op=%lu %s b=%u gen=%lu keys=%lu last=%03X   ",
               operation, writing ? "write/read" : "read", block,
               generations[block], keyboard_count, last_key);
        fflush(stdout);
    }

    printf("\nDSTRS: PASS - %lu operations, no corruption\n", operation);
    if (result_name != NULL) {
        result = fopen(result_name, "wt");
        if (result == NULL ||
            fprintf(result, "PASS %lu operations file=%s seed=%08lX\n",
                    operation, file_name, seed) < 0 ||
            fclose(result) != 0) {
            fputs("DSTRS: cannot write completion marker\n", stderr);
            close(handle);
            _hfree(buffer);
            return 1;
        }
    }
    close(handle);
    _hfree(buffer);
    return 0;
}
