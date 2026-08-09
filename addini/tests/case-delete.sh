#!/bin/sh
# /D deletes the entry instead of adding it.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[386Enh]\r\ndevice=ABIOSDSK.386\r\nfoo=1\r\n' > "$SB/system.ini"
run_addini /D system.ini 386Enh device=ABIOSDSK.386
assert_rc 0
assert_file_eq system.ini '[386Enh]\r\nfoo=1\r\n'
assert_no_temp system
finish
