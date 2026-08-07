	page	,132
	title	noqwin - QuickWin (QWIN) Stub Module
;***
;noqwin.asm - QuickWin (QWIN) Stub Module
;
;	Copyright (c) 1990-1992, Microsoft Corporation.  All rights reserved.
;
;Purpose:
;	This source is used by programs that want to use the Win/C
;	libraries but do NOT want the QWIN functionality.
;
;	Note: Currently, this module is model independent so a single
;	object can be used to stub out the QWIN system regardless of model.
;
;*******************************************************************************

include version.inc
.xlist
include cmacros.inc
include rterr.inc
.list

;
; Externals
;

externNP	_amsg_exit	; fatal termination

;
; Data
;

sBegin	data
assumes ds,data

globalW 	_qwinused,0	; 0 means QWIN layer NOT used

sEnd


sBegin	code
assumes cs,code


page
;***
; QWIN Public Stubs - Public Stubs for QWIN Routines
;
;Purpose:
;	This entry stubs out QWIN externs to publics.
;
;Entry: <not applicable>
;
;Exit:	<not applicable>
;
;Exceptions:
;
;*******************************************************************************

public	__wiobused
	__wiobused = 0


page
;***
; QWIN Return Stubs - Return Stubs for QWIN Routines
;
;Purpose:
;	This entry stubs out QWIN routines that may be called if
;	_qwinused is 0 but which don't do anything in that model.
;
;	*** Note:  This routine is NEAR regardless of model.
;
;Entry: <void>
;
;Exit:	<void>
;
;Exceptions:
;
;*******************************************************************************

labelNP <PUBLIC, _wcinit>

cProc	_wcexit,<PUBLIC,NEAR>,<>
cBegin <nolocals>
cEnd <nolocals>


page
;***
; QWIN Fatal Stubs - Fatally Stubs out QWIN routines
;
;Purpose:
;	This entry stubs out all the QWIN references.  They should
;	never be called if _qwinused is 0.  If for some reason one
;	IS called, the program terminates with an appropriate error.
;
;Entry: <void>
;
;Exit:
;	<NEVER RETURNS>
;
;Exceptions:
;
;*******************************************************************************

;
; C runtime entries
;

labelNP <PUBLIC, _wabout>

labelNP <PUBLIC, _wclose>

labelNP <PUBLIC, _wgetfocus>

labelNP <PUBLIC, _wgetscreenbuf>

labelNP <PUBLIC, _wgetsize>

labelNP <PUBLIC, _wmenuclick>

labelNP <PUBLIC, _wopen>

labelNP <PUBLIC, _wread>

labelNP <PUBLIC, _wsetfocus>

labelNP <PUBLIC, _wsetscreenbuf>

labelNP <PUBLIC, _wsetsize>

labelNP <PUBLIC, _wwrite>

labelNP <PUBLIC, _wterm>


;
; QWIN API entries
;

labelNP <PUBLIC, _QWINClose>

labelNP <PUBLIC, _QWINGetBuffSize>

labelNP <PUBLIC, _QWINGetFocus>

labelNP <PUBLIC, _QWINGetSize>

labelNP <PUBLIC, _QWINExit>

labelNP <PUBLIC, _QWINInit>

labelNP <PUBLIC, _QWINIsQWINin>

labelNP <PUBLIC, _QWINMenuClick>

labelNP <PUBLIC, _QWINOpen>

labelNP <PUBLIC, _QWINRead>

labelNP <PUBLIC, _QWINSetAboutString>

labelNP <PUBLIC, _QWINSetBuffSize>

labelNP <PUBLIC, _QWINSetFocus>

labelNP <PUBLIC, _QWINSetSize>

labelNP <PUBLIC, _QWINTerm>

labelNP <PUBLIC, _QWINYield>

labelNP <PUBLIC, _QWINWrite>

;
; Die with a fatal error message
;

	mov	ax,_RT_QWIN	; QuickWin error
	jmp	_amsg_exit	; die

sEnd
	End
