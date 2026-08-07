	page	,132
	title	wep - Windows DLL Exit Processing
;***
;wep.asm - Windows DLL Exit Processing
;
;	Copyright (c) 1990-1992, Microsoft Corporation.  All rights reserved.
;
;Purpose:
;	This is the WEP() procedure that gets control when a Windows DLL
;	terminates.
;
;	NOTE:  There are a whole PILE of restrictions and problems with
;	WIN DLLs (especially under Win 3.0).  Here's a short list.
;
;	(1) WEP code should be RESIDENT and FIXED.
;
;	(2) WEP can possibly be called with DS!=DGROUP.
;
;	(3) WEP can possibly be called before the DLL init code is done.
;
;	(4) We might be on a small kernel stack (4k, I think) so avoid
;	going too deep (and minimize OS requests).
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

.286

;
; Define segments
;

CrtDefSegs <wepcode,code>

WEPCODE_SEG  equ   <wepcode>
CS_ASSUMEWEP equ   <WEP_TEXT>	   ; assumes macro won't handle wepcode

CrtDefSegs <null,data,cdata,const,bss>

;
; WEP fSystemExit flag values
;
	WEP_SYSTEM_EXIT equ 1		; System shutdown
	WEP_FREE_DLL	equ 0		; DLL termination

;
; Segment present access bit
;

	_SEG_PRESENT	equ 8000H	; hi bit, hi byte

;
; External routines
;
	extern	pascal __STUBWEP:far	; Alternate _WEP() routine
	extern	pascal _WEP(__STUBWEP):far ; User's DLL Term Routine

	externP <__cexit>		; callable C termination code
;
; External data
;

sBegin data

	externB <__dllinit>		; Win DLL init flag

sEnd


%sBegin  WEPCODE_SEG
%assumes cs,CS_ASSUMEWEP

page
;***
;WEP - Windows DLL Exit Processing
;
;Purpose:
;
;	This is the WEP() procedure that gets control when a Windows DLL
;	terminates.  Perform the following actions:
;
;	(1) Call the a user's termination routine (via weak extern)
;
;	(2) Call _cexit()
;
;	(3) Return to OS
;
;Entry:
;	int fSystemExit = WEP_SYSTEM_EXIT = System Shutdown
;			= WEP_FREE_DLL = DLL Termination
;
;Exit:
;	ax = 1 = successful WEP processing
;
;Uses:
;
;Exceptions:
;
;*******************************************************************************

;int _far pascal WEP (int bSystemExit)

cProc	WEP,<PUBLIC,PASCAL,FAR>,<>

	parmW	exitflags

cBegin	<nolocals>

;
; See if the DLL init code had a chance to run
;

	assumes ds,nothing
	mov	cx,ds
	lar	ax,cx		; get ds access rights
	jnz	return1 	; oops, ds not ours

	and	ax,_SEG_PRESENT ; is segment present?
	jz	return1 	; nope, get out

	assumes ds,data 	; DS=DGROUP
	mov	al,[__dllinit]	; get dll initialization flag
	or	al,al		; is it 0 ??
	jz	return1 	; yup, initialization not completed

;
; Call user's DLL term routine
;

	cCall _WEP <exitflags>

;
; Perform C exit processing
; ax = return code from _WEP (1 = success)
;

	push	ax		; save return code around _cexit()
if sizeC
	call	__cexit 	; C termination processing
else
	call	__fcexit	; C termination processing (far version)
endif
	pop	ax		; ax = exit code
	jmp	short done	; use ax for return code

;
; Return
; ax = exit code (1 = success)
;

return1:
	mov	ax,1
done:

cEnd	<nolocals>

% sEnd	WEPCODE_SEG


ife sizeC

sBegin	code
assumes cs,code

page
;***
; _fcexit - Shell that calls _cexit (always FAR)
;
;Purpose:
;	This routine is simply a shell that allows WEP to call
;	_fcexit.  Since WEP is always in it's own segment, we
;	need a wrapper that is always called far in the _TEXT
;	segment.
;
;	This stub in only needed in small code model; large
;	code model can call directly to __cexit.
;
;Entry:
;	void
;
;Exit:
;	void
;
;Uses:
;
;Exceptions:
;
;*******************************************************************************

; void __fcexit (void)

cProc	__fcexit,<LOCAL,FAR>,<>

cBegin	<nolocals>

	call	__cexit

cEnd	<nolocals>

sEnd  code

endif ;!sizeC

	end
