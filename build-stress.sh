#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TOOLCHAIN="$ROOT/work/msvc15/VISUALC/US/VC152C/MSVC15"

if [ ! -f "$TOOLCHAIN/BIN/CL.EXE" ]; then
    mkdir -p "$ROOT/work/msvc15"
    7z x -y -o"$ROOT/work/msvc15" "$ROOT/archives/win16ddk.iso" \
        'VISUALC/US/VC152C/MSVC15/*'
fi

mkdir -p "$ROOT/build"
python3 "$ROOT/stress/mkpif.py" "$ROOT/build"
cat >"$ROOT/build/stressbox.conf" <<'EOF'
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
cl /nologo /AH /G2 /W3 /O /Fobuild\dstrs.obj /Febuild\dstrs.exe stress\dstrs.c >build\dstrs.log
if errorlevel 1 exit
copy /Y build\dstrs.exe build\dstrs1.exe >NUL
if errorlevel 1 exit
copy /Y build\dstrs.exe build\dstrs2.exe >NUL
if errorlevel 1 exit
cl /nologo /AL /G2 /GA /W3 /O /c /Fobuild\wstrs.obj stress\wstrs.c >build\wstrs.log
if errorlevel 1 exit
link /NOLOGO build\wstrs.obj,build\wstrs.exe,build\wstrs.map,llibcew.lib libw.lib,stress\wstrs.def; >build\wlink.log
if errorlevel 1 exit
exit
EOF

cd "$ROOT"
exec dosbox-x -fastlaunch -defaultconf -conf build/stressbox.conf
