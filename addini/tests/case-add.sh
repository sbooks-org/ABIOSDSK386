#!/bin/sh
# Add a new entry: inserted as the first line of the section body.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[386Enh]\r\ndevice=OTHER.386\r\n\r\n[drivers]\r\nfoo=1\r\n' \
    > "$SB/system.ini"
run_addini system.ini drivers bar=2
assert_rc 0
assert_out_clean
assert_file_eq system.ini \
    '[386Enh]\r\ndevice=OTHER.386\r\n\r\n[drivers]\r\nbar=2\r\nfoo=1\r\n'
assert_no_temp system
finish
