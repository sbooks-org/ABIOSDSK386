#!/bin/sh
# Entry present but not at the top: moved to the top of the section so it
# loads first.  Also exercises the bracketed section name [386Enh].
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[386Enh]\r\ndevice=X.386\r\ndevice=ABIOSDSK.386\r\n' > "$SB/system.ini"
run_addini system.ini '[386Enh]' device=ABIOSDSK.386
assert_rc 0
assert_out_clean
assert_file_eq system.ini \
    '[386Enh]\r\ndevice=ABIOSDSK.386\r\ndevice=X.386\r\n'
assert_no_temp system
finish
