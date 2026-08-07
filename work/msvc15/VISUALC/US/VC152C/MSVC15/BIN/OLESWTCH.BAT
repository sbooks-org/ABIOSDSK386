@echo off
echo WARNING: If you have installed another application that uses
echo          a later version than OLE 2.01, then this OLESWTCH.BAT
echo          command may overwrite the new version of OLE with the
echo          older OLE 2.01 version installed by Visual C++ in your
echo          Windows System directory.  If so, cancel OLESWTCH.BAT
echo          now with CNTL-C.
pause

set WinPath=
set DbgPath=
set NoDPath=

if (%NoDPath%)==() goto OutOfEnvSpace

    if (%1)==(N) goto OleNoDebug
    if (%1)==(n) goto OleNoDebug
    if (%1)==(D) goto OleDebug
    if (%1)==(d) goto OleDebug
    goto Usage

:OutOfEnvSpace
    rem -----------------------------------
    rem  Display Out of Env. Space Message 
    rem -----------------------------------

    echo:
    echo: Error: Out of Environment Space !!
    echo:
    echo:        Increase the size of your environment using the 
    echo:        '/e' switch on COMMAND.COM.
    echo:        
    echo:        Example CONFIG.SYS:
    echo:
    echo:           SHELL=C:\COMMAND.COM /e:512
    echo:
    goto Done

:NoWinPath
    rem -----------------------------
    rem  Display Set WinPath Message
    rem -----------------------------

    echo:
    echo: Error: Windows System Path not set !!
    echo:
    echo:       Set the 'WinPath' environment variable in
    echo:       %0.BAT to your Windows System Directory.
    echo:
    goto Done

:Usage
    rem ---------------------------
    rem  Display OLESWTCH.BAT Usage
    rem ---------------------------

    echo:
    echo: Usage:
    echo:        %0 {N or D}
    echo:
    echo: where  N = switch to nodebug version of OLE DLLs
    echo:        D = switch to debug version of OLE DLLs
    echo:
    echo: NOTE: %0 is normally called by OLEN2D.BAT and OLED2N.BAT
    echo:
    goto Done

:OleNoDebug
    rem ---------------------------
    rem  Copy NODEBUG files
    rem ---------------------------
copy %NoDPath%\COMPOBJ.DLL  %WinPath%
copy %NoDPath%\COMPOBJ.SYM  %WinPath%
copy %NoDPath%\OLE2.DLL     %WinPath%
copy %NoDPath%\OLE2.SYM     %WinPath%
copy %NoDPath%\OLE2CONV.DLL %WinPath%
copy %NoDPath%\OLE2CONV.SYM %WinPath%
copy %NoDPath%\OLE2DISP.DLL %WinPath%
copy %NoDPath%\OLE2DISP.SYM %WinPath%
copy %NoDPath%\OLE2NLS.DLL  %WinPath%
copy %NoDPath%\OLE2NLS.SYM  %WinPath%
copy %NoDPath%\OLE2PROX.DLL %WinPath%
copy %NoDPath%\OLE2PROX.SYM %WinPath%
copy %NoDPath%\STORAGE.DLL  %WinPath%
copy %NoDPath%\TYPELIB.DLL  %WinPath%
copy %NoDPath%\TYPELIB.SYM  %WinPath%
goto Done
	 
:OleDebug
    rem ---------------------------
    rem  Copy DEBUG files
    rem ---------------------------
copy %DbgPath%\COMPOBJ.DLL  %WinPath%
copy %DbgPath%\COMPOBJ.SYM  %WinPath%
copy %DbgPath%\OLE2.DLL     %WinPath%
copy %DbgPath%\OLE2.SYM     %WinPath%
copy %DbgPath%\OLE2CONV.DLL %WinPath%
copy %DbgPath%\OLE2CONV.SYM %WinPath%
copy %DbgPath%\OLE2DISP.DLL %WinPath%
copy %DbgPath%\OLE2DISP.SYM %WinPath%
copy %DbgPath%\OLE2NLS.DLL  %WinPath%
copy %DbgPath%\OLE2NLS.SYM  %WinPath%
copy %DbgPath%\OLE2PROX.DLL %WinPath%
copy %DbgPath%\OLE2PROX.SYM %WinPath%
copy %DbgPath%\STORAGE.DLL  %WinPath%
copy %DbgPath%\TYPELIB.DLL  %WinPath%
copy %DbgPath%\TYPELIB.SYM  %WinPath%
goto Done

:Done

set WinPath=
set DbgPath=
set NoDPath=
