@echo off
rem $Id: mklib.bat 1.2 93/01/25 17:41:47 rob Exp $
set M=%2
set PLLPTH=%3
if "%1" == "s" goto valid_model
if "%1" == "m" goto valid_model
if "%1" == "l" goto valid_model
if "%1" == "c" goto valid_model
goto usage
:valid_model
if "%2" == "e" goto valid_fp
if "%2" == "7" goto valid_fp
if "%2" == "a" goto valid_fp
goto usage
:valid_fp
if "%PLLPTH%" == "" goto no_path
goto path_supplied
:no_path
set PLLPTH=.
:path_supplied
set S=%PLLPTH%\%1libc%M%.lib
if exist %S% goto lib_exists
set S=%PLLPTH%\%1libc%M%r.lib
if exist %S% goto lib_exists
goto error1
:lib_exists
rem provide llibpe.lib for backward compat.
if not exist %1libp%M%.lib goto lib1_gone
del %1libp%M%.lib
:lib1_gone
lib /nologo /noe %1libp%M%;
if errorlevel 1 goto error4
if not exist %1libp%M%.lib goto error4
set T=%1libc%M%p
if not exist %T%.lib goto targ_no_exist
echo * Warning: File "%T%.lib" already exists and will be overwritten.
echo *          Press Ctrl-C to Abort ...
pause
:targ_no_exist
copy %S% %T%.lib
rem
rem Extract OBJs from PL libraries
rem
@echo on
lib msc8%1.lib @extmods.lbc;
@echo off
if errorlevel 1 goto error2
rem
rem Update new library
rem
@echo on
lib %T% @fp%2.lbc @insmods.lbc;
@echo off
if errorlevel 1 goto error3
rem
rem Delete intermediate object files
rem
call remobjs.bat
del %T%.bak
echo *
echo *	Library "%T%.lib" created successfully.
echo *
goto end
:usage
echo Usage: MKLIB [smlc] [7ea] [dir path]
echo The first two parameters are letters that determine which library
echo to extract files from:
echo	  s : Small Model 
echo	  m : Medium Model 
echo	  l : Large Model 
echo	  c : Compact Model 
echo	  e : Emulation Libraries
echo	  7 : 80x87 Libraries 
echo	  a : Alternate Math Libraries
echo The third parameter is the path to the DIRECTORY (e.g. c:\msvc\lib )
echo that contains the Microsoft Visual C++ library
echo files. The new library will be created in the current directory.
echo Sample Usage:
echo MKLIB s e c:\msvc\lib      (creates libraries sLIBPe.LIB, sLIBCeP.LIB)
goto end
:error1
echo *
echo *  ERROR: Library "%S%" Not Found.
echo *
goto end
:error2
echo *
echo *	ERROR: Could Not Extract Modules from library "msc8%1.lib".
echo *
goto end
:error3
echo *
echo *	ERROR: Could Not Create New Library "%T%.lib".
echo *
goto end
:error4
echo *
echo *	ERROR: Could Not Invoke Librarian "lib.exe"
echo *
goto end
:end
set PLLPTH=
set M=
set S=
set T=
rem Microsoft (R) is a registered trademark of Microsoft Corporation.
