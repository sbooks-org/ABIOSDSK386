/* PHAPI.H - 286|DOS-Extender Phar Lap API definition file */

/************************************************************************/
/*	Copyright (C) 1986-1990 Phar Lap Software, Inc.			*/
/*	Unpublished - rights reserved under the Copyright Laws of the	*/
/*	United States.  Use, duplication, or disclosure by the 		*/
/*	Government is subject to restrictions as set forth in 		*/
/*	subparagraph (c)(1)(ii) of the Rights in Technical Data and 	*/
/*	Computer Software clause at 252.227-7013.			*/
/*	Phar Lap Software, Inc., 60 Aberdeen Ave., Cambridge, MA 02138	*/
/************************************************************************/

/* $Id: phapi.h 1.6 91/10/08 15:32:05 rob Exp $ */


/*

This file provides C data structure declarations and function
prototypes that define the Phar Lap Application Program Interface
(PHAPI) for use in 286|DOS-Extender programs. The functions declared
in this file provide the following services:

	o  manipulating protected mode selectors
	o  manipulating pages on the 80386
	o  allocated conventional (DOS) memory
	o  interrupt and exception handling
	o  communicating with real mode code
	o  dynamic linking
	o  miscellaneous services
	 
The code for PHAPI is located in PHAPI.DLL, a dynamic link
library that is part of 286|DOS-Extender. In addition to #including
PHAPI.H, programs that use the PHAPI should also link in the import
library, PHAPI.LIB. 

All PHAPI functions must be invoked with a FAR call. With the
exception of three functions that allow a variable number of
arguments, all PHAPI routines use the Pascal calling convention. In
the following function prototypes, APIENTRY designates a FAR PASCAL
function. 

286|DOS-Extender provides character-mode OS/2 API calls for
use by protected mode MS-DOS programs. The OS/2 API data structures
and function prototypes are declared in the file OS2.H, provided with
Microsoft C and compatible compilers (you DO NOT need the OS/2 SDK!).

The functions declared in this file, PHAPI.H, are those PHAPI
functions which are not already declared in OS2.H or in its helper
include files such as OS2DEF.H, BSEDOS.H, or BSESUB.H. This file,
PHAPI.H, automatically includes (and requires) the Microsoft C
OS2DEF.H include file. Most programs that #include <PHAPI.H> will
probably also need to #include <OS2.H>.

*/
#ifndef PHAPI_H_INCLUDED
#define PHAPI_H_INCLUDED


/*

If the OS/2 .H files haven't been included, then define the
following base types.

*/

#ifndef OS2DEF_INCLUDED
#define OS2DEF_INCLUDED

#ifdef __cplusplus
extern "C" {
#endif	

#ifndef CHAR
typedef char CHAR;
#endif
#ifndef INT
typedef int INT;
#endif
typedef short SHORT;
typedef long LONG;
typedef int BOOL;
typedef unsigned char BYTE;

typedef unsigned char UCHAR;
typedef unsigned int UINT;
typedef unsigned short USHORT;
typedef unsigned long ULONG;

typedef char _far *PCHAR;
typedef int _far *PINT;
typedef short _far *PSHORT;
typedef long _far *PLONG;

typedef unsigned char _far *PUCHAR;
typedef unsigned int _far *PUINT;
typedef unsigned short _far *PUSHORT;
typedef unsigned long _far *PULONG;

typedef unsigned short SEL;
typedef unsigned short _far *PSEL;
typedef unsigned short HMODULE;
typedef unsigned short _far *PHMODULE;
typedef void _far *PVOID;
typedef unsigned char _far *PSZ;
typedef void (pascal _far *PFN)();
typedef PFN _far *PPFN;

#define VOID void
#define APIENTRY pascal _far


/* 

Utility macros

*/

#define MAKEP(sel, off) ((PVOID)((((ULONG)(sel)) << 16) + (off)))

#define SELECTOROF(fp) ((SEL)(((ULONG)(fp)) >> 16))

#define OFFSETOF(fp) ((UINT)(ULONG)(fp))	       
	
#define MAKETYPE(var, type) (*((type _far *)&var))

#define FIELDOFFSET(type, field) ((UINT)&(((type *)0)->field))

#define MAKELONG(lo, hi) ((((LONG)(hi)) << 16) + (USHORT)(lo))

#define MAKEULONG(lo, hi) ((((ULONG)(hi)) << 16) + (USHORT)(lo))

#define MAKESHORT(lo, hi) ((((USHORT)(hi)) << 8) + (UCHAR)(lo))

#define MAKEUSHORT(lo, hi) ((((USHORT)(hi)) << 8) + (UCHAR)(lo)) 

#define LOBYTE(val) ((UCHAR)(val))  

#define HIBYTE(val) ((UCHAR)(((USHORT)(val)) >> 8))

#define LOUCHAR(val) ((UCHAR)(val))  

#define HIUCHAR(val) ((UCHAR)(((USHORT)(val)) >> 8))

#define LOWORD(val) ((USHORT)(val))

#define HIWORD(val) ((USHORT)(((ULONG)(val)) >> 16))

#define LOUSHORT(val) ((USHORT)(val))

#define HIUSHORT(val) ((USHORT)(((ULONG)(val)) >> 16))

#endif


/*

Force PHAPI.LIB to be linked into the resulting .EXE

*/

#pragma comment(lib, "PHAPI")


/*

Types 

*/

typedef unsigned long REALPTR;


/*

Idealized segment descriptor

*/

typedef struct
{
	ULONG base;		/* Segment linear base address */
	ULONG size;		/* Size in bytes of segment */
	USHORT attrib;		/* Attribute byte */
} DESC;

typedef DESC _far *PDESC;


/*

Segment types

*/

#define CODE16		1		/* Code segment */
#define DATA16		2		/* Data segment */
#define CODE16_NOREAD	3		/* Execute only code segment */
#define DATA16_NOWRITE	4		/* Read only data segment */


/*

Mask values returned by "DosVerifyAccess"

*/

#define IS_SEL		0x0001		/* Is a valid selector */	
#define IS_READABLE	0x0002	    	/* Is readable */
#define IS_WRITEABLE	0x0004	       	/* Is writeable */
#define IS_CODE		0x0008		/* Is executable */


/*

Function prototypes

*/

USHORT APIENTRY DosCreateDSAlias(SEL sel, PSEL aselp);

USHORT APIENTRY DosMapLinSeg(ULONG lin_addr, ULONG size, PSEL selp);

USHORT APIENTRY DosMapRealSeg(USHORT rm_para, ULONG size, PSEL selp);

USHORT APIENTRY DosMapPhysSeg(ULONG phys_addr, ULONG size, PSEL selp);

USHORT APIENTRY DosGetBIOSSeg(PSEL selp);

USHORT APIENTRY DosGetSegDesc(SEL sel, PDESC descp);

USHORT APIENTRY DosSetSegAttrib(SEL sel, USHORT attrib);

USHORT APIENTRY DosVerifyAccess(SEL sel, PUSHORT flagp);

USHORT APIENTRY DosLockSegPages(SEL sel);

USHORT APIENTRY DosUnlockSegPages(SEL sel);

USHORT APIENTRY DosGetPhysAddr(PVOID addr, PULONG phys_addrp, PULONG countp);

USHORT APIENTRY DosEnumMod(PSZ name_buff, USHORT name_len, PHMODULE handp);

USHORT APIENTRY DosEnumProc(USHORT mod_handle, PSZ name_buff,
			    PUSHORT ordinalp);

USHORT APIENTRY DosIsPharLap(void);

REALPTR APIENTRY DosProtToReal(PVOID ptr);

PVOID APIENTRY DosRealToProt(REALPTR ptr);

USHORT APIENTRY DosSetProcAddr(HMODULE mhand, PSZ pnamep,
			       PFN paddr);


/*

Low level memory management functions

*/

USHORT APIENTRY DosRemapLinSeg(ULONG lin_addr, ULONG size, SEL sel);

USHORT APIENTRY DosRemapRealSeg(USHORT rm_para, ULONG size, SEL sel);

USHORT APIENTRY DosRemapPhysSeg(ULONG phys_addr, ULONG size, SEL sel);

USHORT APIENTRY DosAllocLinMem(ULONG size, PULONG lin_addp);

USHORT APIENTRY DosFreeLinMem(ULONG lin_add);

USHORT APIENTRY DosReallocLinMem(ULONG old_lin_add, ULONG new_size, 
	                         PULONG new_lin_addp);

USHORT APIENTRY DosMapLinMemToSelector(USHORT sel, ULONG lin_addr, 
				       ULONG size);

USHORT APIENTRY DosAllocSpecificSelectors(SEL sel, USHORT count);

USHORT APIENTRY DosFreeSelectors(SEL sel, USHORT count);


/*

OS/2 compatible API's

*/

#ifndef INCL_DOSPROCESS_INCLUDED
#define INCL_DOSPROCESS_INCLUDED

typedef struct _RESULTCODES
{ 
	USHORT codeTerminate;
	USHORT codeResult;
} RESULTCODES;

typedef RESULTCODES _far *PRESULTCODES;

typedef void (pascal _far *PFNEXITLIST)(USHORT);

#define EXLST_ADD    1
#define EXLST_REMOVE 2
#define EXLST_EXIT   3

#define MODE_REAL      0
#define MODE_PROTECTED 1

#define TC_EXIT        0
#define TC_HARDERROR   1
#define TC_TRAP        2
#define TC_KILLPROCESS 3

#define EXEC_SYNC        0
#define EXEC_ASYNC       1
#define EXEC_ASYNCRESULT 2
#define EXEC_TRACE       3
#define EXEC_BACKGROUND  4

USHORT APIENTRY DosExecPgm(PCHAR failp, SHORT failc,
			   USHORT flags, PSZ argsp, PSZ envp,
			   PRESULTCODES resultp, PSZ namep);

VOID APIENTRY DosExit(USHORT flag, USHORT rc);

USHORT APIENTRY DosExitList(USHORT code, PFNEXITLIST funcp);

USHORT APIENTRY DosGetMachineMode(PUCHAR modep);

#endif

#ifndef INCL_DOSMEMMGR_INCLUDED
#define INCL_DOSMEMMGR_INCLUDED

USHORT APIENTRY DosAllocHuge(USHORT nseg, USHORT lcount, PSEL selp,
			     USHORT maxsel, USHORT flags);

USHORT APIENTRY DosAllocSeg(USHORT size, PSEL selp, USHORT flags);

USHORT APIENTRY DosCreateCSAlias(SEL dsel, PSEL cselp);

USHORT APIENTRY DosGetHugeShift(PUSHORT countp);

USHORT APIENTRY DosFreeSeg(SEL sel);

USHORT APIENTRY DosMemAvail(PULONG availp);

USHORT APIENTRY DosReallocHuge(USHORT nseg, USHORT lcount, SEL sel);

USHORT APIENTRY DosReallocSeg(USHORT nsize, SEL sel);

#endif

#ifndef INCL_DOSMODULEMGR_INCLUDED
#define INCL_DOSMODULEMGR_INCLUDED

USHORT APIENTRY DosFreeModule(HMODULE mhand);

USHORT APIENTRY DosGetModHandle(PSZ namep, PHMODULE mhandp);

USHORT APIENTRY DosGetModName(HMODULE mhand, USHORT buffc, PCHAR buffp);

USHORT APIENTRY DosGetProcAddr(HMODULE mhand, PSZ pnamep,
			       PPFN paddrp);

USHORT APIENTRY DosLoadModule(PSZ failp, USHORT failc,
                              PSZ modnamep, PHMODULE mhandp);

#ifdef __cplusplus
}
#endif	

#endif
#endif
