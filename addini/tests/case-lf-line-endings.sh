#!/bin/sh
# Line endings in an LF-only file: the Python port adds the entry with
# \n, the C build always adds \r\n.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

printf '[boot]\nfoo=1\n' > "$SB/system.ini"
run_addini system.ini boot bar=2
assert_rc 0
case "$ADDINI" in
    *.py) assert_file_eq system.ini '[boot]\nbar=2\nfoo=1\n' ;;
    *)    assert_file_eq system.ini '[boot]\nbar=2\r\nfoo=1\n' ;;
esac
finish
