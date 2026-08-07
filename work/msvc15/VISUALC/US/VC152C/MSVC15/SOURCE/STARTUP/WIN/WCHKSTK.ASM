	page	,132
	title	wchkstk.asm - Stack checking for windows
;***
;wchkstk.asm - Stack checking for windows
;
;	Copyright (c) 1988-1992, Microsoft Corporation. All rights reserved.
;
;Purpose:
;	Windows versions of the C lib stack checking routines.
;
;*******************************************************************************

.xlist
include version.inc
?PLM = 1
include cmacros.inc
include rterr.inc
.list

	externW pStackTop	; Windows stack values
	externW pStackMin
	externW pStackBot

	externNP __amsg_exit	; fatal error handler

ifdef	SS_NEQ_DGROUP
externP    <__GetDGROUP>	; Function to recover DGROUP
endif

sBegin	data
	assumes ds,data

globalCP    __aaltstkovr,-1	; Holds alternate overflow handler

sEnd	data


sBegin	code
	assumes cs,code

page
;***
; _aNchkstk - Near check stack routine (windows version)
;
;Purpose:
;
;Entry:
;	AX = size of local frame
;
;Exit:
;	SP = new stackframe if successful
;
;Uses:
;
;Exceptions:
;	Gives out of stack overflow error and aborts if there is not enough
;	stack space for the routine.
;
;*******************************************************************************

ife sizeC
labelP	<PUBLIC,__chkstk>
endif

labelP	<PUBLIC, __aNchkstk>
	pop	bx			; get return address
	inc	ax
	and	al,0FEh 		; round up to nearest even
	sub	ax,sp
	jae	astkovr
	neg	ax
	cmp	ss:[pStackTop],ax
	ja	astkovr
	cmp	ss:[pStackMin],ax
	jbe	nchkstk1
	mov	ss:[pStackMin],ax
nchkstk1:
	mov	sp,ax
	jmp	bx			; jump to return address


page
;***
; _aFchkstk - Far check stack routine (windows version)
;
;Purpose:
;
;Entry:
;	AX = size of local frame
;
;Exit:
;	SP = new stackframe if successful
;
;Uses:
;
;Exceptions:
;	Gives out of stack overflow error and aborts if there is not enough
;	stack space for the routine.
;
;*******************************************************************************


if  sizeC
labelP	<PUBLIC,__chkstk>
endif

labelP	<PUBLIC, __aFchkstk>
        pop     bx
	pop	dx			; get far return address
	inc	ax
	and	al,0FEh 		; round up to nearest even
        sub     ax,sp
        jae     stkerr
        neg     ax
        cmp     ss:[pStackTop],ax
        ja      stkerr
        cmp     ss:[pStackMin],ax
	jbe	fchkstk1
        mov     ss:[pStackMin],ax
fchkstk1:
        mov     sp,ax
        push    dx
        push    bx
ccc     proc    far
        ret
ccc     endp

;
; Stack fault has occurred
; (common to both near and far check stack routines)
;

stkerr:

ifdef SS_NEQ_DGROUP
	call	__GetDGROUP
	mov	ds,ax			;set DS = DGROUP
endif
	mov	dx,word ptr [__aaltstkovr]
	inc	dx
	jz	astkovr
	jmp	[__aaltstkovr]	; alternate stack handler

astkovr:
	mov	ax,_RT_STACK	; stack overflow error
	jmp	__amsg_exit	; fatal error handler


sEnd	code

	end
