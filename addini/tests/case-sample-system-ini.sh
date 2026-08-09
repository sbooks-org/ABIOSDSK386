#!/bin/sh
# Real-world sample (tests/SYSTEM.INI, fetched from C: by mcopy):
#   1. device=ABIOSDSK.386 is already the first line of [386Enh]:
#      no-op, exit 0, file untouched
#   2. add foo=bar under [drivers]: it becomes the first line of that
#      section
#   3. delete it again: file restored byte-for-byte
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

SAMPLE="$(dirname "$0")/SYSTEM.INI"
if [ ! -f "$SAMPLE" ]; then
    echo "  FAIL: $SAMPLE missing — run 'make system-ini' first" >&2
    FAIL=1
    finish
fi
cp "$SAMPLE" "$SB/system.ini"

run_addini system.ini 386Enh device=ABIOSDSK.386
assert_rc 0
assert_out_clean
if ! cmp -s "$SB/system.ini" "$SAMPLE"; then
    echo "  FAIL: no-op run modified the sample" >&2
    FAIL=1
fi

run_addini system.ini drivers foo=bar
assert_rc 0
assert_out_clean
if ! sed -n '/^\[drivers\]/,/^\[/p' "$SB/system.ini" \
    | tr -d '\r' | sed -n '2p' | grep -qx 'foo=bar'; then
    echo "  FAIL: foo=bar is not the first line of [drivers]" >&2
    FAIL=1
fi

run_addini /D system.ini drivers foo=bar
assert_rc 0
if ! cmp -s "$SB/system.ini" "$SAMPLE"; then
    echo "  FAIL: file not restored after delete" >&2
    FAIL=1
fi
finish
