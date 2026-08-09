#!/bin/sh
# Shared helpers for addini test cases.
# Source this file, then call set_addini, then use: SB, run_addini,
# assert_rc, assert_file_eq, assert_out_contains, assert_out_clean,
# assert_no_temp, finish.

SB=$(mktemp -d "${TMPDIR:-/tmp}/addini-case.XXXXXX")
trap 'rm -rf "$SB"' EXIT INT TERM
FAIL=0
RC=0
OUT=

# set_addini path — resolve the tool under test to an absolute path
set_addini() {
    ADDINI=$(CDPATH= cd -- "$(dirname "$1")" && pwd)/$(basename "$1")
}

# run_addini [args...] — run $ADDINI inside the sandbox; sets RC and OUT
run_addini() {
    OUT=$(cd "$SB" && "$ADDINI" "$@" 2>&1)
    RC=$?
}

# assert_rc expected
assert_rc() {
    if [ "$RC" -ne "$1" ]; then
        echo "  FAIL: exit $RC, expected $1" >&2
        echo "  output was: $OUT" >&2
        FAIL=1
    fi
}

# assert_file_eq file expected-bytes (with printf %b escapes)
assert_file_eq() {
    printf '%b' "$2" > "$SB/.expected"
    if ! cmp -s "$SB/$1" "$SB/.expected"; then
        echo "  FAIL: $1 content mismatch" >&2
        (cd "$SB" && od -c "$1" && echo '  expected:' && od -c .expected) >&2
        FAIL=1
    fi
}

# assert_out_contains text
assert_out_contains() {
    if ! printf '%s' "$OUT" | grep -q "$1"; then
        echo "  FAIL: output does not contain: $1" >&2
        echo "  output was: $OUT" >&2
        FAIL=1
    fi
}

# assert_out_clean — no Warning: or Error: lines in the output
assert_out_clean() {
    if printf '%s' "$OUT" | grep -Eq 'Warning:|Error:'; then
        echo "  FAIL: unexpected warning/error in output: $OUT" >&2
        FAIL=1
    fi
}

# assert_no_temp base — no base.i~~ or base.in~ left in the sandbox
assert_no_temp() {
    if [ -e "$SB/$1.i~~" ] || [ -e "$SB/$1.in~" ]; then
        echo "  FAIL: temporary files left behind for $1" >&2
        FAIL=1
    fi
}

# finish — clean up and exit with the pass/fail status
finish() {
    rm -rf "$SB"
    [ "$FAIL" -eq 0 ]
}
