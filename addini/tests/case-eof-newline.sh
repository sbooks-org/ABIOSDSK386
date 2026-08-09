#!/bin/sh
# The section header is the last line and has no trailing newline: the
# entry still starts on its own line.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[boot]' > "$SB/system.ini"
run_addini system.ini boot foo=bar
assert_rc 0
assert_file_eq system.ini '[boot]\r\nfoo=bar\r\n'
assert_no_temp system
finish
