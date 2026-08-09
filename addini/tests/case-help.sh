#!/bin/sh
# Help: /?, /H, /HELP (any case), -h, --help — exit 0, usage shown.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

for opt in /? /H /HELP /help -h --help; do
    run_addini "$opt"
    assert_rc 0
    assert_out_contains 'Usage: ADDINI'
    assert_out_contains '/V /VERSION'
done
finish
