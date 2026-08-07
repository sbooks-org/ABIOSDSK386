@echo off

REM This is a part of the Microsoft Foundation Classes C++ library.
REM Copyright (C) 1992-1993 Microsoft Corporation
REM All rights reserved.
REM
REM This source code is only intended as a supplement to the
REM Microsoft Foundation Classes Reference and Microsoft
REM QuickHelp documentation provided with the library.
REM See these sources for detailed information regarding the
REM

echo.
echo Microsoft Foundation Classes -- Sample Applications (batch build)
echo.
echo This MS-DOS Batch file will build most of the Windows/MFC sample
echo applications.  Use of the batch file will save time and
echo disk space if you are interested in seeing all of the
echo working samples as you learn the Microsoft Foundation Classes.
echo If you are modifying a sample or using it as a basis for
echo your own application, then the use of the Visual Workbench
echo is recommended.
echo.
echo.

set __DEBUG=1
if "%1"=="DEBUG" goto doit
if "%1"=="debug" goto doit

set __DEBUG=0

if "%1"=="RETAIL" goto doit
if "%1"=="retail" goto doit

if "%1"=="CLEAN" goto doit_clean
if "%1"=="clean" goto doit_clean

echo Please specify DEBUG or RETAIL or CLEAN on the command line.
echo.
echo     DEBUG will build executables with symbolic information,
echo         diagnostics, and no optimizations (large and slow).
echo     RETAIL will build ship quality executables that
echo         are fully optimized (small and fast).
echo     CLEAN will remove all compiler generated files (object
echo         files, executables, etc.)  Use this to switch between
echo         DEBUG and RETAIL.
echo.

goto end

:doit
shift

echo.
echo NOTE: Since this builds all the sample programs it could
echo take a little while.  Type Ctrl-C now if you wish
echo to build them later.  You can stop the build at
echo any time by typing Ctrl-C (several times) and
echo answer 'Y' to terminate.
echo.
pause

:doit_clean

if "%1"=="CLEAN" erase STDAFX??.PCH
if "%1"=="CLEAN" erase STDAFX??.OBJ

@echo on

cd CALCDRIV
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\CATALOG
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\DYNABIND
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\CHKBOOK
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\CTRLBARS
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\CTRLTEST
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\DIBLOOK
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\DLLHUSK
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\DRAWCLI
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\HELLO
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\HELLOAPP
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\HIERSVR
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\MDI
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\MULTIPAD
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\OCLIENT
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\PROPDLG
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\SPEAKN
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\SUPERPAD
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\TRACER
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\TRACKER
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\VBCHART
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\VBCIRCLE
nmake /nologo "DEBUG=%__DEBUG%" %1
cd ..\VIEWEX
nmake /nologo "DEBUG=%__DEBUG%" %1

@echo off
echo Note: You must manually build the DLLTRACE sample
echo Note: You must manually build the MAKEHM tool
echo Note: You must manually build the TEMPLDEF tool

cd ..

:end
set __DEBUG=
@echo on
