#!/bin/sh
# Deleting an entry that is not there is an error: exit 1, file untouched.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[386Enh]\r\nfoo=1\r\n' > "$SB/system.ini"
cp "$SB/system.ini" "$SB/system.ini.before"
run_addini /D system.ini 386Enh device=NOPE.386
assert_rc 1
assert_out_contains 'not found'
if ! cmp -s "$SB/system.ini" "$SB/system.ini.before"; then
    echo "  FAIL: file was modified" >&2
    FAIL=1
fi
finish
