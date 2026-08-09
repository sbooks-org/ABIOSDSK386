@echo off
rem  ABIOSDSK Version 0.90 prerelease
rem  Copyright (C) 2026 Simplebooks Foundation
rem  Copyright (C) 2026 Josh Rodd
rem ------------------------------------------------------------------
rem  INSTALL.BAT -- install ABIOSDSK.386 (Windows 3.1 ABIOS BlockDev VxD)
rem
rem  Usage:  INSTALL [windows-directory]
rem
rem  The Windows directory defaults to C:\WINDOWS.  INSTALL.BAT copies
rem  ABIOSDSK.386 and ABIOSCHK.COM into the Windows SYSTEM directory,
rem  then runs ADDINI.COM to add the device= line to SYSTEM.INI.
rem  See HELP.TXT.
rem ------------------------------------------------------------------
echo ABIOSDSK Version 0.90 prerelease installer
echo Copyright (C) 2026 Simplebooks Foundation
echo Copyright (C) 2026 Josh Rodd
echo.
echo WARNING: This prerelease needs further testing.
echo Tested only with DOS 3.30 on partitions smaller than 32 MB.
echo Supports only system-supported MFM and ESDI fixed disks.
echo.
set WIN=%1
if "%WIN%"="" set WIN=C:\WINDOWS
rem The \NUL test is the classic portable way to check a directory exists.
if exist %WIN%\SYSTEM\nul goto found
echo.
echo Cannot find the SYSTEM directory under %WIN%.
echo Re-run with:  INSTALL [windows-directory]
echo For example:  INSTALL C:\WINDOWS
goto end
:found
copy ABIOSDSK.386 %WIN%\SYSTEM\ABIOSDSK.386 >nul
if errorlevel 1 goto copyerr
copy ABIOSCHK.COM %WIN%\ABIOSCHK.COM >nul
if errorlevel 1 goto copyerr
echo.
echo ABIOSDSK.386 copied to %WIN%\SYSTEM
echo and ABIOSCHK.COM copied to %WIN%
echo.
addini %WIN%\SYSTEM.INI 386Enh device=ABIOSDSK.386
if errorlevel 1 goto adderr
addini %WIN%\SYSTEM.INI 386Enh 32BITDISKACCESS=ON
if errorlevel 1 goto adderr
echo.
echo ABIOSDSK.386 and 32BITDISKACCESS=ON added to SYSTEM.INI
echo.
echo Restart Windows to use the new driver. Details are in
echo HELP.TXT; error messages are explained in README.TXT.
echo.
goto end
:copyerr
echo.
echo Could not copy ABIOSDSK.386 to %WIN%\SYSTEM
echo or ABIOSCHK.COM to %WIN%
echo.
echo Check the path and that the diskette is not write-protected.
echo.
:adderr
echo.
echo Could not add the ABIOSDSK settings to SYSTEM.INI.
echo Check that %WIN%\SYSTEM.INI exists and has a [386Enh]
echo section.  You can add these lines by hand with SYSEDIT:
echo    32BITDISKACCESS=ON
echo    device=ABIOSDSK.386
echo.
:end
