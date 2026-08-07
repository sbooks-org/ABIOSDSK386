	page	,132
	title	 fatal - Fatal error handler (Windows)
;***
;fatal.asm - Fatal error handler (Windows)
;
;	Copyright (c) 1989-1992, Microsoft Corporation.  All rights reserved.
;
;Purpose:
;	This source contains code that handles fatal C runtime errors
;	in the Windows models.
;
;	NOTE: In the non-windows libs, this code appears in startup.  It
;	is moved out of win crt0.asm for granularity purposes (Win DLL
;	users are particularly sensitive to this).
;
;*******************************************************************************

?DF=	1			; this is special for c startup
.xlist
include version.inc
?PLM = 1
include cmacros.inc
include defsegs.inc
include rterr.inc
.list

CrtDefSegs <code, data>
CrtDefSegs <nmsg>


externFP    <FATALAPPEXIT>	; Fatal windows exit (term app)
externFP    <FATALEXIT> 	; Fatal windows exit (term all of windows)

externP    <__FF_MSGBANNER>	; Write out standard error header
externP    <__NMSG_WRITE>	; Write out an error message
externP    <__NMSG_TEXT>	; Get error text

ifdef	SS_NEQ_DGROUP
externP    <__GetDGROUP>	; Function to recover DGROUP
endif	;_WINDLL


sBegin	code
assumes cs,code
assumes ds,data

page
;***
; _amsg_exit - Fatal error handler
;
;Purpose:
;
;	_amsg_exit = general runtime error handler
;	_cintDIV   = integer divide by 0 trap
;
;	NOTE:  In windows, this code is tightly tied to how nmsghdr.asm
;	works.	If you change one, you should look at the other, too.
;
;Entry:
;	_amsg_exit = ax = fatal error number
;
;Exit:
;	Fatal error -- never returns to caller
;
;Uses:
;
;Exceptions:
;
;*******************************************************************************

labelNP <PUBLIC,__cintDIV>

ifndef	SS_NEQ_DGROUP
	push	ss
	pop	ds			;set DS = DGROUP
else	;SS_NEQ_DGROUP
	call	__GetDGROUP
	mov	ds,ax			;set DS = DGROUP
endif	;SS_NEQ_DGROUP

	; *** should we flush stream buffers, etc. here?

	mov	ax,_RT_INTDIV
	;jmp	 short __amsg_exit	; <fall thru>


labelNP <PUBLIC,__amsg_exit>

;
; write error message to debug screen and get pointer
; to text for FATALAPPEXIT
;
	; <pascal calling convention>
	push	ax			; for __NMSG_TEXT
	push	ax			; for __NMST_WRITE
	callcrt __FF_MSGBANNER		; run-time error message banner
	callcrt __NMSG_WRITE		; write out error message
	callcrt __NMSG_TEXT		; ax = * msg or NULL

	; make sure all fatal msgs are short enough for FATALAPPEXIT
	.ERRE	(_RT_MAXTXTLEN LE 35)

 ;
 ; Set up the message for FATALAPPEXIT
 ;

	xor	bx,bx			; bx = 0
	or	ax,ax			; is ptr 0?
	jz	killapp 		; jump, if so

	mov	di,ax			; di = ptr to start of string
	mov	ax,_RT_STANDARD_STRING	; assume "R6???" message
	cmp	byte ptr [di],_RT_MATH_STARTCHAR ; message start with "M" ??
	jne	@F			; jump, if not
	mov	ax,_RT_MATH_STRING	; "M6???" message
@@:
	add	di,ax			; step over "?6???" portion of msg
	push	di			; save ptr to start of string

	push	ds
	pop	es			; es:di = *message
	mov	al,_RT_STANDARD_ENDCHAR ; al = char after string
	mov	cx,_RT_MAXTXTLEN	; max length of a fatal string
	repne	scasb			; find end of string
	; don't worry about cx=0 case
	mov	[di-1],bl		; store a final null
	pop	ax			; ax = ptr to string

;
; kill the app
; ax = ptr to string (or 0)
; bx = 0
;

killapp:
	push	bx			; action code = 0
	push	ds
	push	ax			; ds:ax = * fatal message
	call	FATALAPPEXIT		; term app
	;*** NORMALLY DOESN'T RETURN ***

	mov	ax,255
	push	ax			; error code
	call	FATALEXIT		; term windows
	;*** NEVER RETURNS ***


sEnd	code

	end
