#!/bin/sh
# ABIOSDSK.386 Version 0.90 prerelease
# Copyright (C) 2026 Simplebooks Foundation
# Copyright (C) 2026 Josh Rodd
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
MODE=${MODE:-release}
case "$MODE" in
    debug)
        ASM_MODE_FLAG=-dABIOSDSK_DEBUG
        ;;
    release)
        ASM_MODE_FLAG=
        ;;
    *)
        echo "MODE must be debug or release" >&2
        exit 2
        ;;
esac

BUILD_DIR="$ROOT/build/$MODE"
mkdir -p "$BUILD_DIR"
rm -f "$ROOT/build/driver.ok"
cat >"$BUILD_DIR/dosbox.conf" <<EOF
[sdl]
fullscreen=false
[dosbox]
memsize=32
[cpu]
core=normal
cputype=pentium
cycles=max
[autoexec]
mount c .
mount d work/ddk-ref/WIN31/DDK/386
c:
d:\TOOLS\MASM5.EXE -p -w2 -Mx $ASM_MODE_FLAG -Isrc -Id:\INCLUDE src\abiosdsk.asm,build\abiosdsk.obj,build\abiosdsk.lst; >build\abiosdsk.log
if errorlevel 1 exit
d:\TOOLS\MASM5.EXE -p -w2 -Mx $ASM_MODE_FLAG -Isrc -Id:\INCLUDE src\abiosrm.asm,build\abiosrm.obj,build\abiosrm.lst; >build\abiosrm.log
if errorlevel 1 exit
d:\TOOLS\LINK386.EXE build\abiosdsk.obj+build\abiosrm.obj,build\abiosdsk.386 /BATCH /NOLOGO /NOI /NOD /NOP,build\abiosdsk.map,,src\abiosdsk.def; >build\link.log
if errorlevel 1 exit
d:\TOOLS\ADDHDR.EXE build\abiosdsk.386
if errorlevel 1 exit
echo success>build\driver.ok
exit
EOF

cd "$ROOT"
dosbox-x -fastlaunch -defaultconf -conf "$BUILD_DIR/dosbox.conf"
if [ ! -f "$ROOT/build/driver.ok" ]; then
    echo "$MODE driver build failed; inspect build/*.log" >&2
    exit 1
fi
cp \
    "$ROOT/build/abiosdsk.obj" "$ROOT/build/abiosdsk.lst" \
    "$ROOT/build/abiosdsk.log" "$ROOT/build/abiosrm.obj" \
    "$ROOT/build/abiosrm.lst" "$ROOT/build/abiosrm.log" \
    "$ROOT/build/abiosdsk.386" "$ROOT/build/abiosdsk.map" \
    "$ROOT/build/link.log" "$BUILD_DIR/"
rm -f \
    "$ROOT/build/abiosdsk.obj" "$ROOT/build/abiosdsk.lst" \
    "$ROOT/build/abiosdsk.log" "$ROOT/build/abiosrm.obj" \
    "$ROOT/build/abiosrm.lst" "$ROOT/build/abiosrm.log" \
    "$ROOT/build/abiosdsk.386" "$ROOT/build/abiosdsk.map" \
    "$ROOT/build/link.log" "$ROOT/build/driver.ok"
