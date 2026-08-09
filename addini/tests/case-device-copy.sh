#!/bin/sh
# device= driver missing from SYSTEM\: copied from the ADDINI program
# directory (argv[0]), then the update proceeds with exit 0.  The tool
# under test is copied into the sandbox so its directory differs from
# the current directory.
. "$(dirname "$0")/lib.sh"
set_addini "${1:?missing tool argument}"

cp "$ADDINI" "$SB/tool"
case "$ADDINI" in
    *.py) TOOL="python3 $SB/tool" ;;
    *)    TOOL="$SB/tool" ;;
esac
mkdir -p "$SB/win/SYSTEM"
printf 'DRIVER' > "$SB/ABIOSDSK.386"
printf '[386Enh]\r\n' > "$SB/win/system.ini"
(cd "$SB" && $TOOL win/system.ini 386Enh device=ABIOSDSK.386) > "$SB/out" 2>&1
RC=$?
assert_rc 0
assert_file_eq win/SYSTEM/ABIOSDSK.386 'DRIVER'
assert_file_eq win/system.ini '[386Enh]\r\ndevice=ABIOSDSK.386\r\n'
finish
