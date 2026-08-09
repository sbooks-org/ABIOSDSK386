#!/bin/sh
# A stale SYSTEM.I~~ blocks the update: error, exit 1, file untouched.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[386Enh]\r\n' > "$SB/system.ini"
printf 'X' > "$SB/system.i~~"
cp "$SB/system.ini" "$SB/system.ini.before"
run_addini system.ini 386Enh device=ABIOSDSK.386
assert_rc 1
assert_out_contains 'temporary file'
if ! cmp -s "$SB/system.ini" "$SB/system.ini.before"; then
    echo "  FAIL: file was modified" >&2
    FAIL=1
fi
finish
