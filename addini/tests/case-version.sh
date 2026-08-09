#!/bin/sh
# Version: /V, /VERSION (any case), -v, --version — exit 0, version and
# copyright notice shown.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

for opt in /V /VERSION /version -v --version; do
    run_addini "$opt"
    assert_rc 0
    assert_out_contains 'version 0.90'
    assert_out_contains 'Copyright'
done
finish
