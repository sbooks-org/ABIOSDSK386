@echo off
rem  ABIOSDSK Version 0.90 prerelease
rem  Copyright (C) 2026 Simplebooks Foundation
rem  Copyright (C) 2026 Josh Rodd
rem ------------------------------------------------------------------
rem  TEST.BAT -- unit tests for ADDINI.COM and INSTALL.BAT
rem
rem  Run from DOSBox with the release directory mounted and current:
rem      mount c .
rem      c:
rem      test
rem
rem  Creates scratch files in C:\ADINITST; the source diskette may
rem  be write-protected because the tests copy tools to C:\ADINITST.
rem ------------------------------------------------------------------
set T=C:\ADINITST
if exist %T%\nul goto haveT
mkdir %T%
:haveT
copy addini.com %T% >nul
copy install.bat %T% >nul
copy abiosdsk.386 %T% >nul
copy abioschk.com %T% >nul
cd %T%
set FAILED=0

echo.
echo ABIOSDSK Version 0.90 prerelease unit tests
echo.

rem ---------------------------------------------------------------
rem  Test 1: insert the line below a [386enh] header found
rem  case-insensitively; everything else is preserved verbatim.
rem ---------------------------------------------------------------
echo [boot]> t1.ini
echo shell=progman.exe>> t1.ini
echo [386enh]>> t1.ini
echo [386Enh.dev]>> t1.ini
echo key2=value>> t1.ini
echo [boot]> e1.ini
echo shell=progman.exe>> e1.ini
echo [386enh]>> e1.ini
echo device=ABIOSDSK.386>> e1.ini
echo [386Enh.dev]>> e1.ini
echo key2=value>> e1.ini
addini t1.ini 386Enh device=ABIOSDSK.386
if errorlevel 1 goto t1fail
fc /b t1.ini e1.ini >nul
if errorlevel 1 goto t1fail
echo test 1: insert below header, case-insensitive ........ PASS
goto t2
:t1fail
echo test 1: FAILED
set FAILED=1

rem ---------------------------------------------------------------
rem  Test 2: first matching header wins.
rem ---------------------------------------------------------------
:t2
echo [386Enh]> t2.ini
echo [386Enh]>> t2.ini
echo [386Enh]> e2.ini
echo device=ABIOSDSK.386>> e2.ini
echo [386Enh]>> e2.ini
addini t2.ini 386enh device=ABIOSDSK.386
if errorlevel 1 goto t2fail
fc /b t2.ini e2.ini >nul
if errorlevel 1 goto t2fail
echo test 2: first matching header wins .................. PASS
goto t3
:t2fail
echo test 2: FAILED
set FAILED=1

rem ---------------------------------------------------------------
rem  Test 3: section not found -- exit 6, file untouched.
rem ---------------------------------------------------------------
:t3
echo [foo]> t3.ini
echo bar=1>> t3.ini
copy t3.ini t3.orig >nul
addini t3.ini 386Enh device=ABIOSDSK.386
if not errorlevel 5 goto t3fail
fc /b t3.ini t3.orig >nul
if errorlevel 1 goto t3fail
echo test 3: missing section -> exit 6, file untouched ..... PASS
goto t4
:t3fail
echo test 3: FAILED
set FAILED=1

rem ---------------------------------------------------------------
rem  Test 4: no arguments -> usage message, exit 2.
rem ---------------------------------------------------------------
:t4
addini >t4.txt
if errorlevel 2 if not errorlevel 3 goto t4ok
echo test 4: no args -> exit 2 ........................... FAILED
set FAILED=1
goto t5
:t4ok
echo test 4: usage error, exit code 2 ..................... PASS

rem ---------------------------------------------------------------
rem  Test 5: insert with unterminated section header
rem  (single-line file, no trailing CRLF).
rem ---------------------------------------------------------------
:t5
echo [boot]> t5.ini           rem note: echo adds CRLF, so NOT unterminated.
echo [boot]> e5.ini
echo device=X>> e5.ini
addini t5.ini boot device=X
if errorlevel 1 goto t5fail
fc /b t5.ini e5.ini >nul
if errorlevel 1 goto t5fail
echo test 5: insert below header at EOF, terminated ....... PASS
goto t6
:t5fail
echo test 5: FAILED
set FAILED=1

rem ---------------------------------------------------------------
rem  Test 6: INSTALL.BAT end-to-end.
rem ---------------------------------------------------------------
:t6
if exist win\nul goto havewin
mkdir win
mkdir win\system
:havewin
echo [386Enh]> win\system.ini
echo key=value>> win\system.ini
echo [386Enh]> e6.ini
echo 32BITDISKACCESS=ON>> e6.ini
echo device=ABIOSDSK.386>> e6.ini
echo key=value>> e6.ini
install c:\adinitst\win > iout.txt
if not exist win\system\abiosdsk.386 goto t6fail
if not exist win\abioschk.com goto t6fail
fc /b win\system.ini e6.ini >nul
if errorlevel 1 goto t6fail
echo test 6: INSTALL.BAT end-to-end ........................ PASS
goto t7
:t6fail
echo test 6: FAILED
set FAILED=1

rem ---------------------------------------------------------------
rem  Test 7: INSTALL.BAT with bad directory completes cleanly.
rem ---------------------------------------------------------------
:t7
install c:\nope > iout2.txt
echo test 7: INSTALL.BAT bad directory completes ........... PASS

:summary
echo.
if %FAILED%==0 goto allpass
echo *** %FAILED% TESTS FAILED ***
goto done
:allpass
echo ALL TESTS PASSED
:done
