	page	,132
	title	stubmain - Default main() procedure for windows
;***
;stubmain.asm - Default main() procedure for windows
;
;	Copyright (c) 1990-1992, Microsoft Corporation.  All rights reserved.
;
;Purpose:
;	(see routine description below)
;
;*******************************************************************************

.xlist
include version.inc
?WIN = 1
include cmacros.inc
.list

;
; External code
;

ifdef _WINDLL

extrn	   pascal __nomain:far		; Alternate main
extrn	   pascal LIBMAIN(__nomain):far ; User's main code

else ;!_WINDLL

if	sizeC
extrn	   pascal __nomain:far		; Alternate main
extrn	   pascal WINMAIN(__nomain):far ; User's main code
else
extrn	   pascal __nomain:near 	; Alternate main
extrn	   pascal WINMAIN(__nomain):near; User's main code
endif

endif ;_WINDLL

;
; External data
;

sBegin	data
assumes ds,data

ifdef _WINDLL
externW _hModule		; parameters for LIBMAIN
externW _wDataSeg
externW _wHeapSize
externD _lpszCmdLine
else
externW _hPrevInstance		; parameters for WINMAIN
externW _hInstance
externD _lpszCmdLine
externW _cmdShow
endif

sEnd	data


sBegin	code
assumes cs,code
assumes ds,data

page
;***
; stubmain - Call the user's procedure
;
;Purpose:
;
;	Windows programs may have either a main() or a WinMain()/LibMain()
;	procedure entry point:
;
;	(1) main() - If a program has main(), then that routine will be
;	call.  If not, this routine will be called via a weak extern.
;
ifdef _WINDLL
;	(2) LibMain() - If the user's program has LibMain() instead of
;	main(), then this routine is called which, in turn, calls LibMain().
else
;	(2) WinMain() - If the user's program has WinMain() instead of
;	main(), then this routine is called which, in turn, calls WinMain().
endif
;
;Entry:
;	(same as main)
;Exit:
;	(returns value passed back from WinMain/LibMain routine).
;Uses:
;
;Exceptions:
;	If the user has neither a main() or WinMain()/LibMain() procedure,
;	the app will fail with a runtime error.
;
;*******************************************************************************

cProc	_stubmain,<PUBLIC>,<>

	parmW	argc
	parmDP	argv
	parmDP	envp

cBegin	<nolocals>

ifdef _WINDLL

	push	(_hModule)
	push	(_wDataSeg)
	push	(_wHeapSize)
	push	word ptr (_lpszCmdLine+2)
	push	word ptr (_lpszCmdLine)
	call	LIBMAIN

else	;!_WINDLL

	push	(_hInstance)
	push	(_hPrevInstance)
	push	word ptr (_lpszCmdLine+2)
	push	word ptr (_lpszCmdLine)
	push	(_cmdShow)
	call	WINMAIN

endif	;_WINDLL

cEnd	<nolocals>

sEnd	code

	end
