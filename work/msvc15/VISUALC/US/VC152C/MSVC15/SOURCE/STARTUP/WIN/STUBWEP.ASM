	page	,132
	title	stubwep - Default _WEP() Procedure for Windows DLL
;***
;stubwep.asm - Default _WEP() Procedure for Windows DLL
;
;	Copyright (c) 1990-1992, Microsoft Corporation.  All rights reserved.
;
;Purpose:
;	WEP() get's control in the C runtime and dispatches to
;	an optional _WEP() routine provided by the user.  If that
;	routine does not exist, then this one is called.
;
;*******************************************************************************

?DF=	1			; this is special for c startup

.xlist
include version.inc
?PLM = 1
?WIN = 1
include cmacros.inc
include defsegs.inc
.list

;
; Define segment
;

CrtDefSegs <wepcode>
CODE_SEG  equ	<wepcode>
CS_ASSUME equ	<WEP_TEXT>	; assumes macro won't handle wepcode


%sBegin  CODE_SEG
%assumes cs,CS_ASSUME
assumes ds,nothing

page
;***
; stubwep - Default _WEP() Procedure for Windows DLL
;
;Purpose:
;	(see above)
;
;Entry:
;	int fSystemExit = WEP_SYSTEM_EXIT = System Shutdown
;			= WEP_FREE_DLL = DLL Termination
;
;Exit:
;	return value = 1
;Uses:
;
;Exceptions:
;
;*******************************************************************************

;int _far pascal _STUBWEP (int bSystemExit)

cProc	__STUBWEP,<PUBLIC,PASCAL,FAR>,<>

	parmW	exitflags

cBegin	<nolocals>

	mov	ax,1		; 1 = success

cEnd	<nolocals>

sEnd	code

	end
