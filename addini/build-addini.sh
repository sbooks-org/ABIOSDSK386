#!/bin/sh
# Build the DOS-compatible ADDINI.COM with Microsoft Visual C++ 1.52.
# Copyright (C) 2026 Simplebooks Foundation
# Copyright (C) 2026 Josh Rodd
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
WORK=$(CDPATH= cd -- "$ROOT/../work" && pwd)
TOOLCHAIN="$WORK/msvc15/VISUALC/US/VC152C/MSVC15"
BUILD="$ROOT/build"

if [ ! -f "$TOOLCHAIN/BIN/CL.EXE" ] || [ ! -f "$TOOLCHAIN/BIN/LINK.EXE" ]; then
    echo "Microsoft C toolchain not found under $TOOLCHAIN" >&2
    echo "Provision the shared toolchain in ../work/msvc15 first." >&2
    exit 1
fi
if ! command -v dosbox-x >/dev/null 2>&1; then
    echo "dosbox-x is required to build ADDINI.COM" >&2
    exit 1
fi

mkdir -p "$BUILD"
rm -f "$ROOT/ADDINI.OBJ" "$BUILD/ADDINI.COM" "$BUILD/ADDINI.LOG" \
    "$BUILD/ADDINI.OBJ" "$BUILD/ADDINI.OK"

cat >"$BUILD/dosbox.conf" <<'EOF'
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
mount e ../work/msvc15/VISUALC/US/VC152C/MSVC15
c:
set INCLUDE=e:\INCLUDE
set LIB=e:\LIB
e:\BIN\CL.EXE /nologo /AT /O1 /Gs /G3 /W3 /Febuild\ADDINI.COM addini.c /link /TINY /NOE /NOI /ONERROR:NOEXE >build\ADDINI.LOG
if errorlevel 1 exit
echo success>build\ADDINI.OK
exit
EOF

cd "$ROOT"
if [ "$(uname -s)" = Darwin ]; then
    SDL_MAC_BACKGROUND_APP=1 dosbox-x -fastlaunch -defaultconf \
        -conf "$BUILD/dosbox.conf"
else
    dosbox-x -fastlaunch -defaultconf -conf "$BUILD/dosbox.conf"
fi

if [ ! -f "$BUILD/ADDINI.OK" ] || [ ! -f "$BUILD/ADDINI.COM" ]; then
    echo "ADDINI.COM build failed; inspect $BUILD/ADDINI.LOG" >&2
    exit 1
fi
rm -f "$ROOT/ADDINI.OBJ" "$BUILD/ADDINI.OBJ" "$BUILD/ADDINI.OK"
printf '%s\n' "Built $BUILD/ADDINI.COM"
