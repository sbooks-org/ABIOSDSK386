	page	,132
	title	wnull - Windows NULL segment
;***
;wnull.asm - Windows NULL segment
;
;	Copyright (c) 1987-1992, Microsoft Corporation.  All rights reserved.
;
;Purpose:
;
;*******************************************************************************

.xlist
?DF = 1 		; Dont generate default segment definitions
include version.inc
?PLM = 1		; Pascal naming
include cmacros.inc
.list

;
;  Windows NULL segment (1st paragrpah of automatic data segment)
;

rsrvPtrOff = 6

DefRsrvPtr  MACRO   name
public name
name = rsrvPtrOff
rsrvPtrOff = rsrvPtrOff + 2
ENDM

DefRsrvPtr  pLocalHeap		; Local heap pointer
DefRsrvPtr  pAtomTable		; Atom table pointer
DefRsrvPtr  pStackTop		; top of stack
DefRsrvPtr  pStackMin		; minimum value of SP
DefRsrvPtr  pStackBot		; bottom of stack

end
