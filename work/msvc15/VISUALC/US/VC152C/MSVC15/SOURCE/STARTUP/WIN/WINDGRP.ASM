	page	,132
	title	windgrp.asm - Gets DGROUP of current .exe or .dll
;***
;windrp.asm - Stack checking for windows
;
;	Copyright (c) 1989-1992, Microsoft Corporation. All rights reserved.
;
;Purpose:
;	Defines _GetDGROUP() - gets DGROUP of current .exe or .dll
;
;*******************************************************************************

.xlist
	include version.inc
	include cmacros.inc
.list


sBegin	data
sEnd	data


sBegin	code
assumes cs,code

page
;***
;unsigned int _Far _Cdecl _GetDGROUP( void );
;
;Purpose:
;	Returns the current .exe or .dll DGROUP in ax.
;
;Entry:
;
;Exit:
;	ax = DGROUP
;Uses:
;
;Exceptions:
;
;*******************************************************************************

assumes ds,nothing

bMOV_AX_IMMED	equ	0b8h	    ; This is the op code for "mov ax, const".


externB  __ExportedStub


cProc  _GetDGROUP,<PUBLIC>,<>

cBegin	nogen

	cmp	[__ExportedStub], bMOV_AX_IMMED
	je	InDLL

	mov	ax, ss	    ; We are in an exe, so ss = DGROUP.
	ret

InDLL:
	mov	ax, word ptr [__ExportedStub+1]  ; get word operand of "mov ax, DGROUP"
	ret

cEnd  nogen

sEnd  code

end
