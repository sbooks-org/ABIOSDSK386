#!/bin/sh
# Usage errors: no arguments and unknown options — exit 1.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

run_addini
assert_rc 1
assert_out_contains 'Usage:'

run_addini /X a b c
assert_rc 1
assert_out_contains 'unknown option'
finish
