#!/bin/sh
# device= driver missing everywhere: warn, still update, exit 2.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[386Enh]\r\ndevice=OTHER.386\r\n' > "$SB/system.ini"
run_addini system.ini 386Enh device=ABIOSDSK.386
assert_rc 2
assert_out_contains 'Warning'
assert_file_eq system.ini \
    '[386Enh]\r\ndevice=ABIOSDSK.386\r\ndevice=OTHER.386\r\n'
assert_no_temp system
finish
