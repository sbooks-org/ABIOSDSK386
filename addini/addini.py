#!/usr/bin/env python3
"""ADDINI - ABIOSDSK INI helper (Python port of addini.c).

Duplicates the behaviour of the MS-C 5.1 build of addini.c:

  * /D /DELETE, /H /HELP /?, /V /VERSION options (also -h, -v,
    --help, --version), all case-insensitive
  * atomic replace: new content written to a temporary file
    (SYSTEM.INI -> SYSTEM.I~~), the original renamed aside
    (SYSTEM.INI -> SYSTEM.IN~), the temporary renamed into place
    (retried up to three times with a three-second delay), then the
    backup deleted
  * the entry is never duplicated: if it is already present in the
    section it is moved to the top of the section; if it is already at
    the top nothing is written at all
  * when adding a device= line to the [386Enh] section the driver file
    is checked (a bare or relative name resolves against
    <INI dir>\\SYSTEM\\); if it is missing it is copied from the ADDINI
    program directory, then from the current directory, before the
    update proceeds
  * a missing section is an error: the section is never created
  * \r\n line endings for added entries, unless the file only uses
    \n line endings, in which case \n is used

Exit status: 0 if the file was updated (or needed no update), 1 on
failure, 2 if the file was updated but a device= driver file could not
be found.
"""

import os
import sys
import time

OP_ADD = 1
OP_MOVE = 2
OP_DEL = 3

HELP_TEXT = (
    "ADDINI: add or delete an entry in an INI file.\r\n"
    "Usage: ADDINI [options] file section text\r\n"
    "  file     the .INI file to update, e.g. C:\\WINDOWS\\SYSTEM.INI\r\n"
    "  section  the section to update, e.g. 386Enh\r\n"
    "  text     the line to add or delete, e.g. device=ABIOSDSK.386\r\n"
    "Options:\r\n"
    "  /D /DELETE     delete the entry instead of adding it\r\n"
    "  /H /HELP /?    show this help\r\n"
    "  /V /VERSION    show version and copyright information\r\n"
    "The options -h, -v, --help and --version are also accepted.\r\n"
)

VERSION_TEXT = (
    "ADDINI - ABIOSDSK INI helper, version 0.90 prerelease\r\n"
    "Copyright (C) 2026 Simplebooks Foundation\r\n"
    "Copyright (C) 2026 Josh Rodd\r\n"
)

USAGE_TEXT = (
    "Usage: ADDINI [options] file section text\r\n"
    "Run ADDINI /? for help.\r\n"
)


def _last_sep_index(p):
    """Index of the last '\\' or '/' in p, or -1."""
    return max(p.rfind("\\"), p.rfind("/"))


def _base_name(p):
    i = _last_sep_index(p)
    return p[i + 1:] if i >= 0 else p


def _dir_part(p):
    """Directory portion of p including the trailing separator, or ''."""
    i = _last_sep_index(p)
    return p[:i + 1] if i >= 0 else ""


def make_temp_names(path):
    """Temporary names for the atomic replace.  For SYSTEM.INI this
    yields SYSTEM.I~~ (new content) and SYSTEM.IN~ (backup)."""
    base = _base_name(path)
    dirlen = len(path) - len(base)
    return (path[:dirlen] + base[:8] + "~~",
            path[:dirlen] + base[:9] + "~")


def find_section(data, section):
    """Offset just past the [section] header line, or None if the
    section does not exist."""
    n = len(data)
    pos = 0
    while pos < n:
        line = pos
        while line < n and data[line] in b" \t":
            line += 1
        end = line
        while end < n and data[end] not in b"\r\n":
            end += 1
        if line < end and data[line] == ord("["):
            close = line + 1
            while close < end and data[close] != ord("]"):
                close += 1
            if close < end and data[line + 1:close].lower() == section.lower():
                at = end
                if at < n and data[at] == ord("\r"):
                    at += 1
                if at < n and data[at] == ord("\n"):
                    at += 1
                return at
        pos = end
        if pos < n and data[pos] == ord("\r"):
            pos += 1
        if pos < n and data[pos] == ord("\n"):
            pos += 1
    return None


def find_line(data, after, line):
    """Find 'line' in the section body starting at 'after' (leading
    blanks ignored, case-insensitive).  Returns (start, end, at_top) of
    the raw matching line including its terminator; at_top is True when
    the match is the first non-blank line of the body.  Returns None if
    not found; the scan stops at the next section header or EOF."""
    n = len(data)
    pos = after
    seen = False
    while pos < n:
        start = pos
        end = pos
        while end < n and data[end] not in b"\r\n":
            end += 1
        le = end
        if le < n and data[le] == ord("\r"):
            le += 1
        if le < n and data[le] == ord("\n"):
            le += 1
        t = start
        while t < end and data[t] in b" \t":
            t += 1
        if t == end:
            pos = le
            continue
        if data[t] == ord("["):
            return None
        if data[t:end].lower() == line.lower():
            return (start, le, not seen)
        seen = True
        pos = le
    return None


def detect_newline(data):
    """\n only when the file contains \n but no \r\n; else \r\n."""
    if b"\r\n" not in data and b"\n" in data:
        return b"\n"
    return b"\r\n"


def build_new_content(data, newline, op, htop, lstart, lend, entry):
    """Updated file content for the given operation.  op is OP_ADD
    (insert 'entry' right after 'htop'), OP_MOVE (remove the raw line
    [lstart, lend) and insert 'entry' right after 'htop'), or OP_DEL
    (remove the raw line [lstart, lend))."""
    if op == OP_DEL:
        return data[:lstart] + data[lend:]
    out = bytearray()
    out += data[:htop]
    # Appending at end of a file that lacks a final newline: put the
    # line break before the new entry so it starts on its own line.
    if htop == len(data) and data and not data.endswith(b"\n"):
        out += newline
    out += entry
    out += newline
    if op == OP_MOVE:
        out += data[htop:lstart]
        out += data[lend:]
    else:
        out += data[htop:]
    return bytes(out)


def atomic_update(path, tmp_new, tmp_old, content):
    """Steps 1-5 of the replace dance.  Returns True on success."""
    if os.path.exists(tmp_new) or os.path.exists(tmp_old):
        print(f"Error: temporary file {tmp_new} or {tmp_old} already "
              "exists; remove it and try again")
        return False
    try:
        with open(tmp_new, "wb") as f:
            f.write(content)
    except OSError as e:
        print(f"Error: cannot create {tmp_new}: {e}")
        return False
    try:
        os.rename(path, tmp_old)
    except OSError as e:
        print(f"Error: cannot rename {path} to {tmp_old}: {e}")
        try:
            os.remove(tmp_new)
        except OSError:
            pass
        return False
    for attempt in range(4):
        try:
            os.rename(tmp_new, path)
            break
        except OSError as e:
            if attempt < 3:
                print(f"Error: cannot rename {tmp_new} to {path}: {e} "
                      "- retrying")
                time.sleep(3)
    else:
        print(f"Error: cannot rename {tmp_new} to {path} after 3 retries")
        print(f"Please manually rename {tmp_new} to {path}.")
        print(f"The original file is saved as {tmp_old}.")
        return False
    try:
        os.remove(tmp_old)
    except OSError as e:
        print(f"Warning: cannot delete {tmp_old}: {e}")
    return True


def make_system_path(ini_path, dev):
    """Resolve a device= value: a bare or relative name resolves against
    <INI dir>\\SYSTEM\\, an absolute name (drive or root-relative) is
    used as given.  The separator follows the INI path."""
    if dev.startswith(("\\", "/")) or (len(dev) >= 2 and dev[0].isalpha()
                                       and dev[1] == ":"):
        return dev
    sep = "\\"
    i = _last_sep_index(ini_path)
    if i >= 0:
        sep = ini_path[i]
    return _dir_part(ini_path) + "SYSTEM" + sep + dev


def ensure_device(ini_path, dev, argv0):
    """Check the device= file exists, resolving relative names against
    <INI dir>\\SYSTEM\\; if missing, warn and try to copy it from the
    ADDINI program directory, then from the current directory.  Returns
    True when present (or copied), False when still missing (a warning
    has been printed)."""
    resolved = make_system_path(ini_path, dev)
    if os.path.isfile(resolved):
        return True
    print(f"Warning: {resolved} not found")
    base = _base_name(dev)
    if not base:
        print("Warning: no file name given after device=")
        return False
    where = _dir_part(argv0)
    candidates = ([where + base] if where else []) + [base]
    for src in candidates:
        if os.path.isfile(src):
            try:
                with open(src, "rb") as fin, open(resolved, "wb") as fout:
                    fout.write(fin.read())
                print(f"Copied {src} to {resolved}")
                return True
            except OSError as e:
                print(f"Error: cannot copy {src} to {resolved}: {e}")
    print(f"Warning: {base} could not be found in the ADDINI directory or "
          f"the current directory; updating {ini_path} anyway")
    return False


def main(argv):
    delete_mode = False
    positional = []
    line_parts = []
    i = 1
    while i < len(argv):
        a = argv[i]
        if a.startswith(("/", "-")):
            o = a.lstrip("/-").lower()
            if o in ("?", "h", "help"):
                sys.stdout.write(HELP_TEXT)
                return 0
            if o in ("v", "version"):
                sys.stdout.write(VERSION_TEXT)
                return 0
            if o in ("d", "delete"):
                delete_mode = True
                i += 1
                continue
            sys.stderr.write(f"ADDINI: unknown option: {a}\r\n")
            sys.stderr.write(USAGE_TEXT)
            return 1
        if len(positional) < 2:
            positional.append(a)
        else:
            line_parts.append(a)
        i += 1

    if len(positional) < 2 or not line_parts:
        sys.stderr.write(USAGE_TEXT)
        return 1
    file, section = positional
    line = " ".join(line_parts)
    if not file or file[-1] == "~":
        return 1

    # Section name, with optional surrounding brackets stripped.
    sec = section
    if len(sec) >= 2 and sec[0] == "[" and sec[-1] == "]":
        sec = sec[1:-1]
    if not sec or len(sec) > 31:
        sys.stderr.write(USAGE_TEXT)
        return 1

    try:
        with open(file, "rb") as f:
            data = f.read()
    except OSError as e:
        print(f"Error: cannot open {file}: {e}")
        return 1

    newline = detect_newline(data)
    secb = sec.encode("latin-1")
    lineb = line.encode("latin-1")

    htop = find_section(data, secb)
    if htop is None:
        print(f"Error: section [{sec}] not found in {file}; it will not "
              "be created")
        return 1

    missing = False
    lstart = lend = at_top = 0
    found = find_line(data, htop, lineb)
    if delete_mode:
        if found is None:
            print(f"Error: entry \"{line}\" not found in section [{sec}]")
            return 1
        lstart, lend, at_top = found
        op = OP_DEL
    elif found is not None:
        lstart, lend, at_top = found
        if at_top:
            # already at the top of the section: nothing to do
            return 0
        op = OP_MOVE
    else:
        op = OP_ADD
        if sec.lower() == "386enh" and lineb[:7].lower() == b"device=":
            missing = not ensure_device(file, line[7:].lstrip(" \t"), argv[0])

    tmp_new, tmp_old = make_temp_names(file)
    content = build_new_content(data, newline, op, htop, lstart, lend, lineb)
    if not atomic_update(file, tmp_new, tmp_old, content):
        return 1
    return 2 if missing else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
