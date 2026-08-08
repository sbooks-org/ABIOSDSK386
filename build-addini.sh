#!/bin/sh
# ABIOSDSK Version 0.90 prerelease
# Copyright (C) 2026 Simplebooks Foundation
# Copyright (C) 2026 Josh Rodd
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
MODE=${MODE:-release}
case "$MODE" in
    debug)
        ASM_MODE_FLAG=-dABIOSDSK_DEBUG
        UASM_MODE_FLAG=-DABIOSDSK_DEBUG
        ;;
    release)
        ASM_MODE_FLAG=
        UASM_MODE_FLAG=
        ;;
    *)
        echo "MODE must be debug or release" >&2
        exit 2
        ;;
esac

TOOLCHAIN="$ROOT/work/msvc15/VISUALC/US/VC152C/MSVC15"
if [ ! -f "$TOOLCHAIN/BIN/LINK.EXE" ]; then
    mkdir -p "$ROOT/work/msvc15"
    7z x -y -o"$ROOT/work/msvc15" "$ROOT/archives/win16ddk.iso" \
        'VISUALC/US/VC152C/MSVC15/*'
fi

BUILD_DIR="$ROOT/build/$MODE"
mkdir -p "$BUILD_DIR"
rm -f "$ROOT/build/util.ok"
cat >"$BUILD_DIR/addinix.conf" <<EOF
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
mount e work/msvc15/VISUALC/US/VC152C/MSVC15
c:
d:\TOOLS\MASM5.EXE -p -w2 -Mx $ASM_MODE_FLAG addini\addini.asm,build\addini.obj,build\addini.lst; >build\addini.log
if errorlevel 1 exit
e:\BIN\LINK.EXE /TINY build\addini.obj,build\addini.com,build\addini.map; >>build\addini.log
if errorlevel 1 exit
echo success>build\util.ok
exit
EOF

cd "$ROOT"
dosbox-x -fastlaunch -defaultconf -conf "$BUILD_DIR/addinix.conf"
if [ ! -f "$ROOT/build/util.ok" ]; then
    echo "$MODE ADDINI build failed; inspect build/addini.log" >&2
    exit 1
fi
cp \
    "$ROOT/build/addini.obj" "$ROOT/build/addini.lst" \
    "$ROOT/build/addini.log" "$ROOT/build/addini.com" \
    "$ROOT/build/addini.map" "$BUILD_DIR/"
rm -f \
    "$ROOT/build/addini.obj" "$ROOT/build/addini.lst" \
    "$ROOT/build/addini.log" "$ROOT/build/addini.com" \
    "$ROOT/build/addini.map" "$ROOT/build/util.ok"
uasm -bin -DABIOS_DIAGNOSTIC -DABIOS_UASM $UASM_MODE_FLAG -Isrc \
    -Fo="$BUILD_DIR/abioschk.com" src/abiosrm.asm
