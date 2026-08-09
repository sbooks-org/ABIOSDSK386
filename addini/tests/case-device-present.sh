#!/bin/sh
# device= under [386Enh] with the driver present in <ini dir>\SYSTEM\:
# exit 0, no warnings, no copy.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

mkdir -p "$SB/win/SYSTEM"
printf 'DRIVER' > "$SB/win/SYSTEM/ABIOSDSK.386"
printf '[386Enh]\r\n' > "$SB/win/system.ini"
run_addini win/system.ini 386Enh device=ABIOSDSK.386
assert_rc 0
assert_out_clean
assert_file_eq win/system.ini '[386Enh]\r\ndevice=ABIOSDSK.386\r\n'
assert_no_temp win/system
finish
