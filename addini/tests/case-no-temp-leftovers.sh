#!/bin/sh
# A successful update leaves no SYSTEM.I~~ / SYSTEM.IN~ behind.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[boot]\r\nfoo=1\r\n' > "$SB/system.ini"
run_addini system.ini boot bar=2
assert_rc 0
assert_no_temp system
finish
