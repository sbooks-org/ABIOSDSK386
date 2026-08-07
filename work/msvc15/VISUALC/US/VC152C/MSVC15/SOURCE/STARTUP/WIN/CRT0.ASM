	page	,132
	title	crt0.asm - Windows C lib startup
;***
;crt0.asm - Windows C lib startup
;
;	Copyright (c) 1988-1992, Microsoft Corporation.  All rights reserved.
;
;Purpose:
;
;	Startup code for Windows C runtime libraries.
;
;*******************************************************************************

;*******************************;*
	DOSSEG			;* specifies DOS SEGment ordering *
;*******************************;*

;*******************************;*
IFDEF _SEARCH_RECORD
	INCLUDELIB LIBW 	;* Library Search Record for windows
ENDIF
;*******************************;*

?DF=	1			; this is special for c startup

_STARTUPBLD = 1 		; special flag for includes

.xlist
include version.inc
?PLM = 1
include cmacros.inc
include msdos.inc
include defsegs.inc
include rterr.inc
ifdef 	_BAT16
include	heap.inc
endif 	;_BAT16
include stdlib.inc
.list

;
; See what win target we're building for
;

ifdef _WINDLL
    ifdef   _NOCRT
	IF1
	%out ! Building DLL / NOCRT lib (?NOCRTDW.LIB)
	ENDIF
	;
	; In the DLL/NOCRT model, we don't need ANY startup code!
	; Define a new symbol to help us do this easily.
	;
	_WINDLL_NOCRT equ 1
    else
	IF1
	%out ! Building DLL window libs (?DLLCW.LIB)
	ENDIF
    endif
    ifdef _QWIN
	%err
	%out ! ERROR - _QWIN not valid for _WINDLL models!
    endif
else
    ifdef   _NOCRT
	IF1
	%out ! Building STATIC / NOCRT lib (?NOCRTW.LIB)
	ENDIF
    else
	IF1
	%out ! Building STATIC window libs (?LIBCW.LIB)
	ENDIF
    endif
endif

;
; See if we want the debug screen swapping symbols resolved
;
	_DEBUGSCREEN equ 1		; debug screen swapping

;
; Exit() redirection for fatal termination
; (Currently, this is called by FP but could be used by other
; components as well.)
;

ifdef _WINDLL
	; No exit() routine in DLLs so abort!
	alias	<__error_exit>	 = <_abort>
else
	alias	<__error_exit>	 = <_exit>
endif

;
; Define code segment
;

CrtDefSegs <code>

;
; Define data segment order for data.
;

CrtDefSegs <null,data,cdata,const,bss>


assumes DS,DATA

;
; NULL Segment definition
;

ifdef 	_BAT16
codeOFFSET equ	offset _TEXT:
dataOFFSET equ	offset DGROUP:
endif

sBegin      NULL
            DD  0
labelW      <PUBLIC,rsrvptrs>
maxRsrvPtrs = 5
	     DW  maxRsrvPtrs
	     DW  maxRsrvPtrs DUP (0)
sEnd        NULL

;
; Resolve definitions to pull in CRT
;

public	__acrtused		; trick to force in startup
	__acrtused = 9876h	; funny value not easily matched in SYMDEB


public	__fptaskdata		; stub out __fptaskdata so that
	__fptaskdata = 9876h	; non-Windows emulator is not brought in

ifdef _DEBUGSCREEN
public	__aDBused		; debug value used by QC
	__aDBused = 0d6d6h

public	__aDBdoswp
	__aDBdoswp = 0d6d6h
endif

ifndef _NOCRT
	extrn	__acrtmsg:abs	; trick to pull in startup messages (CRT0MSG.ASM)
endif

;
; Absolutes used at runtime to determine what model the program is
;

public	__sizec
	__sizec = sizeC

public	__sized
	__sized = sizeD


;
; Data declarations
;

sBegin      DATA

ifndef _NOCRT

	externB __cpumode		; real/protected flag
	externW __osversion		; byte-swapped DOS version
	externW __osver			; DOS version (usable byte order)
	externW __winver		; WIN version (usable byte order)
	externW  ___argc		; arg count
	externDP ___argv		; arg array
	externDP __environ		; environment array

    ifndef  _WINDLL
	externW  __psp			; psp:0 (paragraph #)
    endif

    ifdef _QWIN
       externW	 __qwinused		; QWIN in-use flag
    endif

endif ;!_NOCRT

ifdef _BAT16
globalD ___cmdLine,0
globalW	__atopsp, 0
globalW	__asizds, 0


labelW	<PUBLIC,__nheap_desc>	; near heap descriptor
_nheap_desc _heap_seg_desc <0,_HEAP_NEAR OR _HEAP_MODIFY, 0,0,0,0,0,0>
.ERRE	flags	eq	2	; flags better be second word

.ERRE	offset __asizds+2 EQ offset _nheap_desc	; make sure!

endif	;_BAT16

ifdef	_WINDLL

	globalW  _STKHQQ,STACKSLOP	; Set DLL stack to max size

	globalW  __hModule,0		; parameters for LIBMAIN
	globalW  __wDataSeg,0
	globalW  __wHeapSize,0
	globalD  __lpszCmdLine,0

ifndef _NOCRT
	globalB __dllinit,0		; 0 = DLL not initialized
endif

else	;!_WINDLL

	globalW _STKHQQ,0		; stack limit

	globalW __hPrevInstance,0	; parameters for WINMAIN
	globalW __hInstance,0
	globalD __lpszCmdLine,0
	globalW __cmdShow,0

endif	;_WINDLL

; Heap segment limits for compiler range checking

	globalW _aseglo,1		; lowest segment
	globalW _aseghi,0FFFFh		; highest segment

ifdef _DEBUGSCREEN
	globalW ___aDBswpflg,0		; debugger screen swap
	globalW ___aDBrterr,0
endif

sEnd        DATA

;
; Externs
;

	extrn	   __WINFLAGS:abs	; Windows status flags
ifdef   _BAT16
	externFP   <LOCALINIT>          ;Window heap init routine
endif

ifdef	_WINDLL

    ifndef  _NOCRT
	externFP   <LOCALINIT>		; Windows heap init routine
	externFP   <LOCKSEGMENT>	; Lock down a segment
	externFP   <WEP>		; DLL termination routine
    endif

else	;!_WINDLL

if sizeD
	externFP   <LOCKSEGMENT>	; Lock down a segment
endif
	externFP   <INITTASK>		; Init new task


    ifdef   _NOCRT
	externP    <WINMAIN>		; User's main code
    else
	externNP   <__amsg_exit>	; Fatal error
	ifdef _QWIN
	    externNP   <__wcinit>	; Init the QWIN layer
	endif
    endif

	externFP   <WAITEVENT>
	externFP   <INITAPP>

endif	;_WINDDLL

ifndef	_NOCRT

	externFP   <GETVERSION> 	; Get windows version

if sizeC
	extern	   __stubmain:far	; Alternate main()
	extern	   _main(__stubmain):far; Weak extern to main()
else
	extern	   __stubmain:near	; Alternate main()
	extern	   _main(__stubmain):near;Weak extern to main()
endif

	externP    <__cinit>		; C lib initialization
	externP    <__setenvp>		; set up envp[] array

    ifndef  _WINDLL
	externP    <__setargv>		; set up argv[] array
	externP    <__exit>		; Quick exit
	externP    <_exit>		; Normal exit
    endif   ;!_WINDLL

endif	;_NOCRT


sBegin  CODE
assumes CS,CODE

;
; Save __WINFLAGS in code segment so we don't need DS to access it.
;
	globalW   __wflags,__WINFLAGS


ifndef	_WINDLL
ifdef  _NOCRT

page
;***
; _exit, __exit - Resolve these in the _NOCRT object
;
;Purpose:
;
;Entry:
;
;Exit:
;
;Uses:
;
;Exceptions:
;
;*******************************************************************************

cProc	__exit,<PUBLIC,C>
cBegin	<nogen>
	;fall through
cEnd	<nogen>

cProc	_exit, <PUBLIC,C>
cBegin	<nogen>
	pop	ax		; eat the return offset
if sizeC
	pop	ax		; if large code, eat the segment too
endif
	pop	ax		; grab the status code
	callos	terminate	; OS exit
	;*** NEVER RETURNS ***
cEnd	<nogen>

endif	;_NOCRT
endif	;!_WINDLL

ifndef	_WINDLL_NOCRT		; No startup code in WINDLL/NOCRT libs!

page
;***
; _astart - C library startup code
;
;Purpose:
;
;  WIN STATIC Application startup code:
;
;       1. call INITTASK to process task parameters
;	2. init _cpumode, etc.
;	3. call WAITEVENT(NULL) and INITAPP(hInstance);
;	4. Perform C lib initialization
;	5. Init argv and envp
;	6. call main() / WINMAIN()
;	7. call exit with parameter returned from main/WINMAIN
;
;  WIN DLL startup code:
;
;	1. Init the local heap if one exists and then calls
;	2. Init the C startup code
;	3. Set DLL init complete flag
;	4. Call the user's main()/Libmain() routine
;
;
;Entry:
;	WIN DLL entry:
;
;	di = handle of the module instance
;	ds = library data segment
;	cx = heap size
;	es:si = command line segment:offset
;
;	[NOTE: The command line seg:off (es:si) is always NULL (!),
;	but we need to pass this through to LibMain for upward
;	compatibility with previous versions.]
;
;Exit:
;
;Uses:
;
;Exceptions:
;
;*******************************************************************************

ifndef _WINDLL

;
; --- Error exit ---
;

error_exit:
        mov     al,0FFh
	cCall	__exit,<ax>		; quick exit with error code
	;*** NEVER RETURNS ***

endif	;!_WINDLL

;
; --- Entry ---
;
ifdef _BAT16
ifndef _NOCRT
	extrn LibvapExit:NEAR
labelNP <PUBLIC,__astart>	; start address of all "C" programs
;cProc	__astart,<PUBLIC,C,FAR>
;cBegin	<nolocals>

;	mov	cs:[_dataseg],di ;* Save DGROUP
	assumes ss,data
	mov	ss:[__psp],es	;* Save PSP for the program
        mov     ax, cx          ; cx = size of dgroup (bytes)
	dec	ax		; ax = size DGROUP - 1
	mov	ss:[__asizds],ax	; Size of Global Data Segment

   	mov     WORD PTR ss:[___cmdLine+2],dx ;* seg of cmdline
        mov     WORD PTR ss:[___cmdLine],bx ;*   offset of cmdline

	mov	bx,dataoffset _nheap_desc ; ss:bx = near heap descriptor
	mov	ss:[bx].checksum,ss ; save dgroup in near heap desc

	and	sp,not 1	    ; make even (if not)
	mov	ss:[bx].segsize,sp  ; save as segment size

	mov	ss:[__atopsp],sp	; Top of Stack Region
	push	ss		; set up initial DS=ES=SS, CLD
	pop	ds
	; LocalInit((LPSTR)start, WORD wHeapSize);
	push    ds		; Heap segment
	mov     ax, sp          ; get start of heap
        add     ax, 2           ;   above stack
	push    ax              ; Heap start offset in segment
        dec     cx		;   get end of heap
        push    cx              ; Heap end offset in segment
	call    LocalInit       ; try to initialise it
        or      ax, ax		; did it do it ok?
        jz      done		; quit if it failed
;@@:
;	mov	cx,__qczrinit		;* Get initializer addr
;	jcxz	@F			;* Is it zero?
;	call	cx			;* No -- call indirect through
;@@:

;	process command line and environment

	call	__setenvp	; crack environment
	call	__setargv	; crack command line

;
; Zero bp for debugging backtrace support (i.e., mark top-of-stack).
;

	xor	bp,bp		; mark top stack frame for SYMDEB

;	do necessary initialization

	call	__cinit		; shared by DOS and Windows
	push	ss
	pop	ds		; ds = DGROUP
	assumes ds,data

;	call main and exit

if	sizeD
	push	word ptr [__environ+2] ; the environment is not always in DS
endif
	push	word ptr [__environ]

if	sizeD
	push	word ptr [___argv+2] ; the arguments are not always in DS
endif
	push	word ptr [___argv]

	push	[___argc]	; argument count

	call	_main		; main ( argc , argv , envp )

done:
	jmp LibvapExit
;cEnd	<nolocals>			; return to lib loader


; use whatever is in ax after returning here from the main program
;	push	ax
;	callcrt _exit		; exit (AX)
				;   _exit will call terminators
endif	;!_NOCRT
else		;_BAT16

ifdef _WINDLL
cProc	__astart,<PUBLIC,C,FAR>


cBegin	<nolocals>
	push	di			; save si/di
	push	si
else
labelNP <PUBLIC,__astart>
endif

ifdef _WINDLL

;
; Save our input values for later reference
;
	mov	__hModule,di		; handle of the module instance
	mov	__wDataSeg,ds		; library data segment
	mov	__wHeapSize,cx		; heap size
	mov	word ptr __lpszCmdline,bx ; Save command line
	mov	word ptr __lpszCmdline+2,si

;
; Init the local heap
; cx = local heap size (0 = no heap)

	jcxz	@F		 ; jump if no heap specified

	; LocalInit((LPSTR)start, WORD wHeapSize);
	push	ds		 ; Heap segment
        xor     ax,ax
	push	ax		 ; Heap start offset in segment
	push	cx		 ; Heap end offset in segment
	call	LocalInit	 ; try to initialise it
	or	ax,ax		 ; did it do it ok ?
	jz	done		 ; quit if it failed
@@:

else	;!_WINDLL

;
; Set up a dummy stack frame (as an "anchor")
;

	xor	bp,bp			; zero bp and tos
	push	bp

;
; Perform windows initialization
;

        cCall   INITTASK
	or	ax,ax			; init work ok ?
	jz	error_exit		; if not, error

;   Success:
;	AX = 1
;	CX = stack limit
;	DX = cmdShow parameter to CreateWindow
;	ES:BX = -> DOS format command line (ES = PSP address)
;	SI = hPrevInstance
;	DI = hInstance


;
; Save our input values for later reference
;

ifndef _NOCRT
        mov     __psp,es                ; Remember PSP for runtimes
endif

	add	cx,STACKSLOP		; add in stack slop space
	jc	error_exit		; if overflow, return error
	mov	_STKHQQ,cx		; Setup for _stackavail

	mov	__hPrevInstance,si
	mov	__hInstance,di

	mov	word ptr __lpszCmdline,bx ; Save command line
	mov	word ptr __lpszCmdline+2,es

	mov	__cmdShow,dx

endif	;!_WINDLL

if sizeD
;
; Make sure DGROUP can't move in large data models
;
	mov	ax,0ffffh
	cCall	LOCKSEGMENT, <ax>
endif

ifndef _NOCRT
;
; Init _cpumode, _osversion, etc.
; [Note that _osmode is already set to _WIN_MODE.]
;
	call	GETVERSION		; get version of WIN
	xchg	al,ah			; put bytes in right order
	mov	[__winver],ax

	callos	version 		; get version of DOS
	mov	[__osversion],ax	; save it in byte-swapped order
	xchg	al,ah			; put bytes in right order
	mov	[__osver],ax		; save it in correct byte order

	; Set real/protected mode (set to protected mode by default)
	test	__wflags,WF_PMODE	; Are we in protected mode ??
	jnz	@F			; yes, already set up
	mov	al,_REAL_MODE		; no, real mode
	mov	[__cpumode],al
@@:

endif	; _NOCRT

ifndef _WINDLL
;
; Init this windows task
;
        xor     ax,ax
        cCall   WAITEVENT,<ax>          ; Clear initial PostEvent that got this task started.
	cCall	INITAPP,<__hInstance>	; do windows task initialization
	or	ax,ax			; init work ok ??
	jz	error_exit		; if not, error return

endif	;!_WINDLL

ifndef _NOCRT

;
; Init C Runtime
;

	call	__cinit 		; initialize runtime

;
; Init args and environment
;

ifndef _WINDLL
        call    __setargv               ; initialize ___argc and ___argv
endif
        call    __setenvp               ; initialize __environ


ifndef _WINDLL
ifdef _QWIN
;
; Init the QWIN layer.
; We must do this after WAITEVENT and INITAPP.	We must also do this
; after argv[0] is initialized.
;
	call	__wcinit	; init the QWIN system
endif	;_QWIN
endif	;!_WINDLL

endif	; _NOCRT

ifdef _WINDLL
;
; Indicate that DLL is initialize (for WEP's benefit)
;

	inc	[__dllinit]	; !0 = DLL initialized
endif

;
; Call the user's code
;

ifdef	_NOCRT

ifdef	_WINDLL
	cCall	LIBMAIN,<__hModule,__wDataSeg,__wHeapSize,__lpszCmdLine>
else	;!_WINDLL
	cCall	WINMAIN,<__hInstance,__hPrevInstance,__lpszCmdline,__cmdShow>
endif	;_WINDLL

else	;!_NOCRT

if	sizeD
	push	word ptr [__environ+2] ; the environment is not always in DS
endif
	push	word ptr [__environ]

if	sizeD
	push	word ptr [___argv+2] ; the arguments are not always in DS
endif
	push	word ptr [___argv]

	push	[___argc]	; argument count

	call	_main		; main ( argc , argv , envp )

if	sizeD
	add	sp,10
else
	add	sp,6
endif

endif	;_NOCRT

;
; --- Exit ---
; ax = return code
;

ifdef	_WINDLL
	pop	si			; restore si, di
	pop	di
done:
cEnd	<nolocals>			; return to lib loader
else
	cCall	_exit,<ax>		; exit with okay parameter
	;*** NEVER RETURNS ***
endif	;_WINDLL

endif	;_BAT16
page
;***
; _nomain - No main procedure
;
;Purpose:
;	We get here if there is no main() or WinMain()/LibMain()
;	procedure.
;
;	EXE - Must have a main/Winmain so if we get here we
;	terminate with a fatal error.
;
;	DLL - The main/LibMain is optional so just return.
;
;Entry: <void>
;
;Exit:
;	EXE: Fatal runtime error
;	DLL: AX=1 (success)
;
;Uses:
;
;Exceptions:	<see above>
;
;*******************************************************************************

ifdef _WINDLL

;int _far pascal Libmain( hModule, wDataSeg, wHeapSize, lpszCmdLine)

cProc	__nomain,<PUBLIC,PASCAL,FAR>,<>

	parmW hModule
	parmW wDataSeg
	parmW wHeapSize
	parmD lpszCmdLine

cBegin	<nolocals>

	mov	ax,1		; return success

cEnd	<nolocals>

else	;!_WINDLL

ifndef	_NOCRT

labelP	<PUBLIC,__nomain>
	mov	ax,_RT_NOMAIN	; No main error
	jmp	__amsg_exit	; die

endif	;!_NOCRT

endif	;_WINDLL

endif	;!_WINDLL_NOCRT

ifdef _BAT16
globalW	__dataseg,0
endif	;_BAT16


sEnd	 CODE


;
; EXE/DLL starting address
;

ifdef _BAT16

xend	macro
	end 
	endm

else	;_BAT16

ifdef _WINDLL_NOCRT

; DLL/NOCRT = No starting address
xend	macro
	END
	endm

else

;STATIC and DLL/CRT = Begin at __astart
xend	macro
	end __astart
	endm

endif	;_WINDLL_NOCRT

endif	;_BAT16

	xend
