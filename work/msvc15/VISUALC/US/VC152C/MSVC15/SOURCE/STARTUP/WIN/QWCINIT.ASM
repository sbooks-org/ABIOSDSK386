	page	,132
	title	qwcinit - QuickWin (QWIN) Init/Term
;***
;qwcinit.asm - QuickWin (QWIN) Init/Term
;
;	Copyright (c) 1990-1992, Microsoft Corporation.  All rights reserved.
;
;Purpose:
;	This source inits/terms the QWIN system.
;
;*******************************************************************************

?DF = 1 		; tell cmacros.inc we want to define our own segments

include version.inc
.xlist
include cmacros.inc
include cmsgs.inc
include defsegs.inc
include fcntl.inc
include rterr.inc
include stdlib.inc
.list

;
; Segments
;

CrtDefSegs  <code,data>
CrtDefSegs  <xcseg>

codeOFFSET equ	offset _TEXT:
dataOFFSET equ	offset DGROUP:

;
; Terminator
;

sBegin	xcseg

if	sizeC
	dd	_wcterm
else
	dw	_wcterm
endif

sEnd

;
; Externals
;

externFP	_QWINExit	; Exit QWIN system
externFP	_QWINInit	; Init QWIN system
externFP	_QWINOpen	; Open QWIN windows
externFP	_QWINSetExit	; Set QWIN exit behavior
externFP	_QWINTerm	; Term QWIN system

externP 	_splitpath	; _splitpath() function
externNP	_amsg_exit	; fatal termination

;
; Data
;

sBegin	data
assumes ds,data

externW 	_nfile		; number of OS files
externW 	_wfile		; number of QWIN files
externDP	__argv		; argument array

externW 	_hInstance	; instance handle
externW 	_cmdShow	; win display parameter

globalW 	_qwinused,1	; non-zero means QWIN layer in use

; default window title

stdname db	_WIN_CTITLE_TXT ; std file title

; open window structures

	_wopen	_wopeninfo	<_WINVER, stdname, _WINBUFDEF>

sEnd


sBegin	code
assumes cs,code

page
;***
; _wcinit - QWIN C Initialization
;
;Purpose:
;	Init the QWIN system.
;
;Entry: <void>
;
;Exit:	<void>
;
;Uses:
;
;Exceptions:
;
;*******************************************************************************

cProc	_wcinit,<PUBLIC,NEAR>,<>

cBegin <nolocals>

;
; Init the QWIN layer and child class
;

	; use the root name of the exe for the QWIN title

if sizeD
	push	ds
	lds	bx,dword ptr (__argv)	; ds:bx = __argv
	assumes  ds,nothing
	mov	ax,word ptr ds:[bx]
	mov	dx,word ptr ds:[bx+2]	; dx:ax = __argv[0]
	pop	ds
	assumes ds,data
else
	mov	bx,word ptr (__argv)	; bx = __argv
	mov	ax,word ptr [bx]
	mov	dx,ds			; dx:ax = __argv[0]
endif

	; _splitpath ( __argv[0], NULL, NULL, *filename, NULL)

	sub	sp,_MAX_FNAME		; space for filename on stack
	mov	bx,sp			; bx = pointer to filename space
	xor	cx,cx			; cx = 0
if sizeD
	push	cx
	push	cx			; extension = NULL
	push	ss
	push	bx			; * filename
	push	cx
	push	cx			; directory = NULL
	push	cx
	push	cx			; drive = NULL
	push	dx
	push	ax			; __argv[0]
	callcrt _splitpath
	add	sp,20			; clean stack
else
	push	cx			; extension = NULL
	push	bx			; * filename
	push	cx			; directory = NULL
	push	cx			; drive = NULL
	push	ax			; __argv[0]
	callcrt _splitpath
	add	sp,10			; clean stack
endif
	mov	ax,sp			; ss:bx = *filename

	; _QWINInit( (char far *) filename, _nfile, _wfile, hInstance, cmdShow )
	; [Note: _QWINInit makes its own copy of the filename string!]

	mov	bx,[_cmdShow]		; _cmdShow
	push	bx
	mov	bx,[_hInstance] 	; _hInstance
	push	bx
	mov	bx,[_wfile]		; # of windows file handles
	push	bx
	mov	bx,[_nfile]		; 1st windows file handle
	push	bx
	push	ss
	push	ax			; *filename
	call	_QWINInit
	add	sp,(12+_MAX_FNAME)	; clean off args and filename
	or	ax,ax			; ax = 0 = success
	jnz	fatal_err

;
; Open stdin/out/err windows
;
	; _QWINOpen ( (far *) _wopeninfo, (far *) _wsizeinfo )

	xor	ax,ax			; NULL = default size info
	push	ax
	push	ax
	mov	ax,dataOFFSET _wopen	; ds:bx = *_wopeninfo
	push	ds
	push	ax
	call	_QWINOpen
	add	sp,8
	cmp	ax,-1			; ax = file handle
	je	fatal_err

	; Make sure the std file handle is what we expect
	cmp	ax,[_nfile]
	jne	fatal_err


;
; Set the default EXIT behavior
;

;
; _QWINSetExit(_QWINEXITPERSIST)
;

	mov	ax,_WINEXITPERSIST
	push	ax
	call	_QWINSetExit
	add	sp,2
	or	ax,ax
	jnz	fatal_err


cEnd <nolocals>


;***
; _wcexit - QWIN C Exit
;
;Purpose:
;	Exit the QWIN system.
;
;	Exit the QWIN system.  We can't do this in the pre-terminators because
;	we want to make sure flushall() gets called before _QWINExit.
;
;Entry: <void>
;
;Exit:	<void>
;
;Uses:
;
;Exceptions:
;
;*******************************************************************************

cProc	_wcexit,<PUBLIC,NEAR>,<>

	parmW	status		; exit code

cBegin <nolocals>

	mov	ax,[status]	; exit code
	push	ax
	call	_QWINExit
	add	sp,2

cEnd <nolocals>


;***
; _wcterm - QWIN C Termination
;
;Purpose:
;	Terminate the QWIN system.
;
;	Note: This routine is placed in the terminator table so it
;	is executed by both exit() and _exit().
;
;Entry: <void>
;
;Exit:	<void>
;
;Uses:
;
;Exceptions:
;
;*******************************************************************************

cProc	_wcterm,<PUBLIC>,<>

cBegin <nolocals>

	call	_QWINTerm	 ; terminate windows package
	cmp	ax,-1		; error?
	je	fatal_err	; yup, die

cEnd <nolocals>


;
; --- Fatal Error ---
;

fatal_err:
	mov	ax,_RT_QWIN	; QuickWin error
	jmp	_amsg_exit	; die

sEnd
	End
