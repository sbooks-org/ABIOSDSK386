#!/bin/sh
# Entry already at the top of its section: no-op, file untouched, exit 0.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[386Enh]\r\ndevice=ABIOSDSK.386\r\ndevice=X.386\r\n' > "$SB/system.ini"
cp "$SB/system.ini" "$SB/system.ini.before"
run_addini system.ini 386Enh device=ABIOSDSK.386
assert_rc 0
assert_out_clean
if ! cmp -s "$SB/system.ini" "$SB/system.ini.before"; then
    echo "  FAIL: file was modified by the no-op run" >&2
    FAIL=1
fi
finish
