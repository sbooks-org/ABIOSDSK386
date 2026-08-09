/* ABIOSDSK 0.90 prerelease INI helper.
 * Copyright (C) 2026 Simplebooks Foundation
 * Copyright (C) 2026 Josh Rodd
 *
 * Microsoft C 5.1, tiny model; PC-DOS/MS-DOS 3.10 or later.
 *
 * Usage: ADDINI [options] file section text
 *   /D /DELETE   delete the entry instead of adding it
 *   /H /HELP /?  show help (also -h, --help)
 *   /V /VERSION  show version and copyright (also -v, --version)
 * All options are case-insensitive.  No file name ever starts with
 * '/' or '-', so every such argument is treated as an option.
 *
 * The INI file is updated atomically: the new content is written to a
 * temporary file (SYSTEM.INI -> SYSTEM.I~~), the original is renamed
 * aside (SYSTEM.INI -> SYSTEM.IN~), the temporary is renamed into
 * place, and the backup is deleted.  If the rename into place fails it
 * is retried up to three times with a three-second delay between
 * attempts; if it still fails the user is told to finish the rename by
 * hand.
 *
 * The entry is never duplicated: if it is already present in the
 * section it is moved to the very top of the section so it is loaded
 * first; if it is already at the top nothing is written at all.
 *
 * When adding a device= line to the [386Enh] section the driver file is
 * checked (a bare or relative name resolves against <INI dir>\SYSTEM\).
 * If it is missing it is copied from the ADDINI program directory and
 * then from the current directory; if it is still missing a warning is
 * printed but the update still goes ahead.
 *
 * A missing section is an error: the section is never created.
 *
 * Exit status: 0 if the file was updated (or needed no update), 1 on
 * failure, 2 if the file was updated but a device= driver file could
 * not be found.
 */
#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_FILE 32768U
static unsigned char file_data[MAX_FILE + 1U];

#define OP_ADD  1
#define OP_MOVE 2
#define OP_DEL  3

/* Case-insensitive string compare. */
static int strieq(const char *a, const char *b)
{
    for (;;) {
        int ca = tolower((unsigned char)*a);
        int cb = tolower((unsigned char)*b);
        if (ca != cb) return 0;
        if (ca == '\0') return 1;
        ++a;
        ++b;
    }
}

/* Case-insensitive prefix test: does s start with pre? */
static int starts_ci(const char *s, const char *pre)
{
    while (*pre != '\0') {
        if (tolower((unsigned char)*s) != tolower((unsigned char)*pre))
            return 0;
        ++s;
        ++pre;
    }
    return 1;
}

/* Case-insensitive compare of p[0..n) against the NUL-terminated name. */
static int same_name(const unsigned char *p, const char *name, unsigned n)
{
    unsigned i;
    for (i = 0; i < n; ++i) {
        if (name[i] == '\0') return 0;
        if (tolower(p[i]) != tolower((unsigned char)name[i]))
            return 0;
    }
    return name[n] == '\0';
}

/* Index of the last '\' or '/' in p, or NULL. */
static const char *last_sep(const char *p)
{
    const char *bs = strrchr(p, '\\');
    const char *fs = strrchr(p, '/');
    if (fs == NULL) return bs;
    if (bs == NULL) return fs;
    return (fs > bs) ? fs : bs;
}

/* File name portion of a path. */
static const char *base_name(const char *p)
{
    const char *sep = last_sep(p);
    return (sep != NULL) ? sep + 1 : p;
}

/* Locate the section header "[section]".  Returns the offset of the
 * header line, or -1 if the section does not exist.  *after is set to
 * the offset just past the header line (including its terminator),
 * i.e. the top of the section body. */
static long find_section(const unsigned char *data, unsigned size,
                         const char *section, unsigned *after)
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
                unsigned at = end;
                if (at < size && data[at] == '\r') ++at;
                if (at < size && data[at] == '\n') ++at;
                *after = at;
                return (long)line;
            }
        }
        pos = end;
        if (pos < size && data[pos] == '\r') ++pos;
        if (pos < size && data[pos] == '\n') ++pos;
    }
    return -1L;
}

/* Within the section body starting at 'after', find a line that matches
 * 'line' (leading blanks ignored, case-insensitive).  Returns 1 with
 * the raw line bounds [*lstart, *lend) (including the terminator) and
 * *at_top set if the match is the first non-blank line of the section
 * body.  Returns 0 if not found; the scan stops at the next section
 * header or at end of file. */
static int find_line(const unsigned char *data, unsigned size,
                     unsigned after, const char *line,
                     unsigned *lstart, unsigned *lend, int *at_top)
{
    unsigned pos = after;
    int seen = 0;
    while (pos < size) {
        unsigned start = pos;
        unsigned end = pos;
        unsigned t;
        unsigned le;
        while (end < size && data[end] != '\r' && data[end] != '\n')
            ++end;
        le = end;
        if (le < size && data[le] == '\r') ++le;
        if (le < size && data[le] == '\n') ++le;
        t = start;
        while (t < end && (data[t] == ' ' || data[t] == '\t'))
            ++t;
        if (t == end) {                 /* blank line */
            pos = le;
            continue;
        }
        if (data[t] == '[')             /* next section header */
            return 0;
        if (same_name(data + t, line, end - t)) {
            *lstart = start;
            *lend = le;
            *at_top = !seen;
            return 1;
        }
        seen = 1;
        pos = le;
    }
    return 0;
}

/* Value after a leading "device=", with leading blanks skipped. */
static const char *value_after(const char *s)
{
    s += 7;
    while (*s == ' ' || *s == '\t')
        ++s;
    return s;
}

/* Build the temporary names used for the atomic replace.  For
 * SYSTEM.INI this yields SYSTEM.I~~ (new content) and SYSTEM.IN~
 * (backup of the original): the base name truncated to 8 characters
 * with "~~" appended, and to 9 characters with "~" appended. */
static void make_temp_names(const char *file, char *tmp_new, char *tmp_old)
{
    const char *base = base_name(file);
    unsigned dirlen = (unsigned)(base - file);
    unsigned n = (unsigned)strlen(base);
    unsigned k;
    char trunc_new[9];
    char trunc_old[10];
    for (k = 0; k < n && k < 8; ++k)
        trunc_new[k] = base[k];
    trunc_new[k] = '\0';
    for (k = 0; k < n && k < 9; ++k)
        trunc_old[k] = base[k];
    trunc_old[k] = '\0';
    strcpy(tmp_new, file);
    tmp_new[dirlen] = '\0';
    strcat(tmp_new, trunc_new);
    strcat(tmp_new, "~~");
    strcpy(tmp_old, file);
    tmp_old[dirlen] = '\0';
    strcat(tmp_old, trunc_old);
    strcat(tmp_old, "~");
}

/* Resolve a device= value.  A bare or relative name resolves against
 * <INI dir>\SYSTEM\; an absolute name (drive or root-relative) is used
 * as given. */
static void make_system_path(const char *file, const char *dev, char *out)
{
    const char *sep = last_sep(file);
    unsigned dirlen = (sep != NULL) ? (unsigned)(sep - file + 1) : 0;
    strcpy(out, file);
    out[dirlen] = '\0';
    if (sep != NULL && *sep == '/')
        strcat(out, "SYSTEM/");
    else
        strcat(out, "SYSTEM\\");
    strcat(out, dev);
}

/* Copy the directory portion of p (including the trailing separator)
 * to out; returns its length (0 if p has no directory). */
static unsigned dir_part(const char *p, char *out)
{
    const char *sep = last_sep(p);
    unsigned len = (sep != NULL) ? (unsigned)(sep - p + 1) : 0;
    unsigned i;
    for (i = 0; i < len; ++i)
        out[i] = p[i];
    out[len] = '\0';
    return len;
}

static int file_exists(const char *name)
{
    FILE *f = fopen(name, "rb");
    if (f == NULL) return 0;
    fclose(f);
    return 1;
}

/* Copy src to dst; returns 1 on success. */
static int copy_file(const char *src, const char *dst)
{
    FILE *in;
    FILE *out;
    unsigned char buf[512];
    size_t n;
    in = fopen(src, "rb");
    if (in == NULL) return 0;
    out = fopen(dst, "wb");
    if (out == NULL) {
        fclose(in);
        return 0;
    }
    while ((n = fread(buf, 1, sizeof buf, in)) != 0) {
        if (fwrite(buf, 1, n, out) != n) {
            fclose(in);
            fclose(out);
            return 0;
        }
    }
    if (ferror(in)) {
        fclose(in);
        fclose(out);
        return 0;
    }
    if (fclose(in) != 0 || fclose(out) != 0) return 0;
    return 1;
}

static void delay_seconds(int seconds)
{
    time_t t0 = time(NULL);
    while (time(NULL) - t0 < (time_t)seconds)
        ;
}

/* Check that the file named by the device= value exists, resolving
 * relative names against <INI dir>\SYSTEM\.  If it is missing, warn
 * and try to copy it from the ADDINI program directory, then from the
 * current directory.  Returns 1 if the file is present (or was
 * copied), 0 if it is still missing (a warning has been printed). */
static int ensure_device(const char *file, const char *dev, const char *argv0)
{
    char resolved[160];
    char src[160];
    char where[160];
    const char *base;
    unsigned len;
    FILE *f;

    if (dev[0] == '\\' || dev[0] == '/'
        || (isalpha((unsigned char)dev[0]) && dev[1] == ':')) {
        strcpy(resolved, dev);
    } else {
        make_system_path(file, dev, resolved);
    }

    f = fopen(resolved, "rb");
    if (f != NULL) {
        fclose(f);
        return 1;
    }
    printf("Warning: %s not found\r\n", resolved);

    base = base_name(dev);
    if (base[0] == '\0') {
        printf("Warning: no file name given after device=\r\n");
        return 0;
    }

    len = dir_part(argv0, where);
    if (len > 0) {
        strcpy(src, where);
        strcat(src, base);
        if (file_exists(src)) {
            if (copy_file(src, resolved)) {
                printf("Copied %s to %s\r\n", src, resolved);
                return 1;
            }
            fprintf(stderr, "Error: cannot copy %s to %s\r\n", src, resolved);
        }
    }

    if (file_exists(base)) {
        if (copy_file(base, resolved)) {
            printf("Copied %s to %s\r\n", base, resolved);
            return 1;
        }
        fprintf(stderr, "Error: cannot copy %s to %s\r\n", base, resolved);
    }

    printf("Warning: %s could not be found in the ADDINI directory or the "
           "current directory; updating %s anyway\r\n", base, file);
    return 0;
}

/* Write the updated file content to 'name'.  op selects the operation:
 * OP_ADD inserts 'entry' right after 'htop'; OP_MOVE removes the raw
 * line [lstart, lend) and inserts 'entry' right after 'htop'; OP_DEL
 * removes the raw line [lstart, lend).  Returns 1 on success. */
static int write_new_file(const char *name, const unsigned char *data,
                          unsigned size, int op, unsigned htop,
                          unsigned lstart, unsigned lend, const char *entry)
{
    FILE *f;
    unsigned n;
    f = fopen(name, "wb");
    if (f == NULL) {
        fprintf(stderr, "Error: cannot create %s: %s\r\n", name,
                strerror(errno));
        return 0;
    }
    if (op == OP_DEL) {
        if (lstart && fwrite(data, 1, lstart, f) != lstart) goto werr;
        if (size - lend && fwrite(data + lend, 1, size - lend, f) !=
                           size - lend)
            goto werr;
    } else {
        if (htop && fwrite(data, 1, htop, f) != htop) goto werr;
        /* Appending at end of a file that lacks a final newline: put the
         * line break before the new entry so it starts on its own line. */
        if (op != OP_DEL && htop == size && size && data[size - 1] != '\n') {
            if (fwrite("\r\n", 1, 2, f) != 2) goto werr;
        }
        n = (unsigned)strlen(entry);
        if (fwrite(entry, 1, n, f) != n) goto werr;
        if (fwrite("\r\n", 1, 2, f) != 2) goto werr;
        if (op == OP_MOVE) {
            if (lstart - htop &&
                fwrite(data + htop, 1, lstart - htop, f) != lstart - htop)
                goto werr;
            if (size - lend &&
                fwrite(data + lend, 1, size - lend, f) != size - lend)
                goto werr;
        } else {
            if (size - htop &&
                fwrite(data + htop, 1, size - htop, f) != size - htop)
                goto werr;
        }
    }
    if (fclose(f) != 0) {
        fprintf(stderr, "Error: cannot finish %s: %s\r\n", name,
                strerror(errno));
        return 0;
    }
    return 1;
werr:
    fclose(f);
    fprintf(stderr, "Error: write failed on %s\r\n", name);
    return 0;
}

/* Perform the atomic replace: rename the original aside, move the new
 * file into place (retrying up to three times with a three-second
 * delay), then delete the backup.  Returns 1 on success. */
static int commit(const char *file, const char *tmp_new, const char *tmp_old)
{
    int attempt;
    if (rename(file, tmp_old) != 0) {
        fprintf(stderr, "Error: cannot rename %s to %s: %s\r\n",
                file, tmp_old, strerror(errno));
        remove(tmp_new);
        return 0;
    }
    for (attempt = 0; attempt < 4; ++attempt) {
        if (rename(tmp_new, file) == 0)
            break;
        if (attempt < 3) {
            fprintf(stderr, "Error: cannot rename %s to %s: %s - retrying\r\n",
                    tmp_new, file, strerror(errno));
            delay_seconds(3);
        }
    }
    if (attempt == 4) {
        fprintf(stderr,
                "Error: cannot rename %s to %s after 3 retries: %s\r\n"
                "Please manually rename %s to %s.\r\n"
                "The original file is saved as %s.\r\n",
                tmp_new, file, strerror(errno), tmp_new, file, tmp_old);
        return 0;
    }
    if (remove(tmp_old) != 0) {
        fprintf(stderr, "Warning: cannot delete %s: %s\r\n",
                tmp_old, strerror(errno));
    }
    return 1;
}

static void help_screen(FILE *out)
{
    fputs("ADDINI: add or delete an entry in an INI file.\r\n"
          "Usage: ADDINI [options] file section text\r\n"
          "  file     the .INI file to update, e.g. C:\\WINDOWS\\SYSTEM.INI\r\n"
          "  section  the section to update, e.g. 386Enh\r\n"
          "  text     the line to add or delete, e.g. device=ABIOSDSK.386\r\n"
          "Options:\r\n"
          "  /D /DELETE     delete the entry instead of adding it\r\n"
          "  /H /HELP /?    show this help\r\n"
          "  /V /VERSION    show version and copyright information\r\n"
          "The options -h, -v, --help and --version are also accepted.\r\n",
          out);
}

static void version_screen(FILE *out)
{
    fputs("ADDINI - ABIOSDSK INI helper, version 0.90 prerelease\r\n"
          "Copyright (C) 2026 Simplebooks Foundation\r\n"
          "Copyright (C) 2026 Josh Rodd\r\n", out);
}

static void usage(FILE *out)
{
    fputs("Usage: ADDINI [options] file section text\r\n"
          "Run ADDINI /? for help.\r\n", out);
}

int main(int argc, char **argv)
{
    FILE *f;
    unsigned char *data;
    unsigned size, got, i, n;
    long at;
    unsigned htop = 0, lstart = 0, lend = 0;
    int at_top = 0, op = 0, delete_mode = 0, missing = 0;
    char line[128];
    char sec[40];
    char tmp_new[160];
    char tmp_old[160];
    const char *file = NULL;
    const char *section = NULL;
    const char *a;
    const char *o;

    line[0] = '\0';
    for (i = 1; i < (unsigned)argc; ++i) {
        a = argv[i];
        o = a;
        if (a[0] == '/' || a[0] == '-') {
            while (*o == '/' || *o == '-')
                ++o;
            if (strieq(o, "?") || strieq(o, "H") || strieq(o, "HELP")) {
                help_screen(stdout);
                return 0;
            }
            if (strieq(o, "V") || strieq(o, "VERSION")) {
                version_screen(stdout);
                return 0;
            }
            if (strieq(o, "D") || strieq(o, "DELETE")) {
                delete_mode = 1;
                continue;
            }
            fprintf(stderr, "ADDINI: unknown option: %s\r\n", a);
            usage(stderr);
            return 1;
        }
        if (file == NULL) file = a;
        else if (section == NULL) section = a;
        else {
            if (line[0] != '\0') {
                if (strlen(line) >= sizeof(line) - 2) {
                    usage(stderr);
                    return 1;
                }
                strcat(line, " ");
            }
            if (strlen(line) + strlen(a) >= sizeof(line)) {
                usage(stderr);
                return 1;
            }
            strcat(line, a);
        }
    }
    if (file == NULL || section == NULL || line[0] == '\0') {
        usage(stderr);
        return 1;
    }
    if (strlen(file) == 0 || file[strlen(file) - 1] == '~')
        return 1;

    /* Section name, with optional surrounding brackets stripped. */
    if (strlen(section) >= sizeof(sec)) {
        usage(stderr);
        return 1;
    }
    strcpy(sec, section);
    n = (unsigned)strlen(sec);
    if (n >= 2 && sec[0] == '[' && sec[n - 1] == ']') {
        sec[n - 1] = '\0';
        memmove(sec, sec + 1, n - 1);
        n -= 2;
    }
    if (n == 0 || n > 31) {
        usage(stderr);
        return 1;
    }

    data = file_data;
    f = fopen(file, "rb");
    if (f == NULL) {
        fprintf(stderr, "Error: cannot open %s: %s\r\n", file,
                strerror(errno));
        return 1;
    }
    got = (unsigned)fread(data, 1, MAX_FILE + 1U, f);
    if (ferror(f)) {
        fclose(f);
        fprintf(stderr, "Error: read failed on %s\r\n", file);
        return 1;
    }
    if (!feof(f) || got > MAX_FILE) {
        fclose(f);
        fprintf(stderr, "Error: %s is too large\r\n", file);
        return 1;
    }
    size = got;
    fclose(f);

    at = find_section(data, size, sec, &htop);
    if (at < 0) {
        fprintf(stderr,
                "Error: section [%s] not found in %s; it will not be created\r\n",
                sec, file);
        return 1;
    }

    if (delete_mode) {
        if (!find_line(data, size, htop, line, &lstart, &lend, &at_top)) {
            fprintf(stderr, "Error: entry \"%s\" not found in section [%s]\r\n",
                    line, sec);
            return 1;
        }
        op = OP_DEL;
    } else if (find_line(data, size, htop, line, &lstart, &lend, &at_top)) {
        if (at_top) {
            /* already at the top of the section: nothing to do */
            return 0;
        }
        op = OP_MOVE;
    } else {
        op = OP_ADD;
        if (strieq(sec, "386ENH") && starts_ci(line, "DEVICE=")) {
            missing = !ensure_device(file, value_after(line), argv[0]);
        }
    }

    make_temp_names(file, tmp_new, tmp_old);
    if (file_exists(tmp_new) || file_exists(tmp_old)) {
        fprintf(stderr,
                "Error: temporary file %s or %s already exists; remove it "
                "and try again\r\n", tmp_new, tmp_old);
        return 1;
    }
    if (!write_new_file(tmp_new, data, size, op, htop, lstart, lend, line))
        return 1;
    if (!commit(file, tmp_new, tmp_old))
        return 1;
    return missing ? 2 : 0;
}
