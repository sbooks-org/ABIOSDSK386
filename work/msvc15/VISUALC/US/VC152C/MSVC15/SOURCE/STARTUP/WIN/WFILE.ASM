	page	,132
	title	 wfile - windows stream i/o tables
;***
;wfile.asm - windows stream i/o tables
;
;	Copyright (c) 1990-1992, Microsoft Corporation.  All rights reserved.
;
;Purpose:
;	Windows stream I/O data tables.
;
;	The _iob[] and _iob2[] tables are each in their own segments
;	so that additions can appended on easily and predictably (e.g.,
;	windows).  Also, note that _lastiob is also defined in its own
;	segment so it always points to the last _iob[] entry regardless
;	of what is added to the table.
;
;	The data defined in this file is inserted in the _iob/_iob2 tables
;	and, thus, those tables MUST be in the EXE.
;
;*******************************************************************************

?DF	=	1		; define segments

include version.inc
.xlist
include cmacros.inc
include defsegs.inc
include stdio.inc
.list

;
; Segment declarations

CrtDefSegs  <code,data>
CrtDefSegs  <iobsegs>

dataOFFSET equ	offset DGROUP:

;
; This file is for QWIN only!
;

ifndef _WINDOWS
     .err
     %out *** ERROR: For use with _WINDOWS only!
endif

ifndef _QWIN
     .err
     %out *** ERROR: For use with _QWIN only!
endif

;
; Number of files
;

	_WFILE_  equ 20

;
; Make sure _iob[]/_iob2[] tables are pulled into the EXE.
;

public	__wiobused
	__wiobused = 1

;
; _iob[] table additions for Windows
;

sBegin	iobxseg

	;	ptr,	cnt,	base,	flag,	file

	_iobuf	_WFILE_ dup (<?>)

sEnd


;
; _iob2[] table additions for Windows
;

sBegin	iob2xseg

	;	flag2, charbuf, bufsiz, tmpnum, padding

	_iobuf2 _WFILE_ dup (<?>)

sEnd


	end
