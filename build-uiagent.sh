#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TOOLCHAIN="$ROOT/work/msvc15/VISUALC/US/VC152C/MSVC15"
if [ ! -f "$TOOLCHAIN/BIN/CL.EXE" ]; then
    echo "Microsoft C 5.1 toolchain is missing; run a normal build first" >&2
    exit 1
fi
mkdir -p "$ROOT/build"
cat >"$ROOT/build/uiagent.conf" <<'EOF'
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
mount e work/msvc15/VISUALC/US/VC152C/MSVC15
set PATH=E:\BIN
set INCLUDE=E:\INCLUDE
set LIB=E:\LIB
c:
cl /nologo /AL /G2 /GA /W3 /O /c /Fobuild\uiagent.obj uiagent\uiagent.c >build\uiagent.log
if errorlevel 1 exit
link /NOLOGO build\uiagent.obj,build\uiagent.exe,build\uiagent.map,llibcew.lib libw.lib,uiagent\uiagent.def; >build\uiagent-link.log
if errorlevel 1 exit
echo success>build\uiagent.ok
exit
EOF
rm -f "$ROOT/build/uiagent.ok"
cd "$ROOT"
if [ "$(uname -s)" = Darwin ]; then
    SDL_MAC_BACKGROUND_APP=1 dosbox-x -fastlaunch -defaultconf -conf build/uiagent.conf
else
    dosbox-x -fastlaunch -defaultconf -conf build/uiagent.conf
fi
if [ ! -f "$ROOT/build/uiagent.ok" ]; then
    echo "UIAGENT build failed; inspect build/uiagent*.log" >&2
    exit 1
fi
