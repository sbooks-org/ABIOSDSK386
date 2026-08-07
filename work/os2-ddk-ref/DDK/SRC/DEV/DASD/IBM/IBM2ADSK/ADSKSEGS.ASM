;       SCCSID = @(#)adsksegs.asm       6.3 92/05/05

        page    ,132

;**************************************************************************
;*
;* SOURCE FILE NAME = ADSKSEGS.ASM
;*
;* DESCRIPTIVE NAME = IBM2ADSK.ADD - Adapter Driver for ABIOS DASD Devices
;*
;*
;* 
;* 
;* COPYRIGHT    Copyright (C) 1992 IBM Corporation
;*              Copyright (C) 1989 Microsoft Corporation
;* 
;* The following IBM OS/2 2.1 source code is provided to you solely for
;* the purpose of assisting you in your development of OS/2 2.x device
;* drivers. You may use this code in accordance with the IBM License
;* Agreement provided in the IBM Device Driver Source Kit for OS/2. This
;* Copyright statement may not be removed.
;* 
;* 
;*
;* VERSION = V2.0
;*
;* DATE
;*
;* DESCRIPTION : CODE/DATA segment declarations.
;*
;*
;***************************************************************************/



        include devhdr.inc

;/*-------------------------------------*/
;/* Assembler Helper to order segments  */
;/*-------------------------------------*/

DDHeader        segment dword public 'DATA'

DiskDDHeader   dd      -1
               dw      DEVLEV_3 + DEV_CHAR_DEV
               dw      _ADSKStr1
               dw      0
               db      "IBMADSK$"
               dw      0
               dw      0
               dw      0
               dw      0
               dd      DEV_ADAPTER_DD
               dw      0

DDHeader        ends

LIBDATA         segment dword public 'DATA'
LIBDATA         ends

_DATA           segment dword public 'DATA'
_DATA           ends

CONST           segment dword public 'CONST'
CONST           ends

_BSS            segment dword public 'BSS'
_BSS            ends

_TEXT           segment dword public 'CODE'

                extrn  _ADSKStr1:near

_TEXT           ends

Code            segment dword public 'CODE'
Code            ends

LIBCODE         segment dword public 'CODE'
LIBCODE         ends

SwapCode        segment dword public 'CODE'
SwapCode        ends

DGROUP          group   CONST, _BSS, DDHeader, LIBDATA, _DATA
StaticGroup     group   Code, LIBCODE, _TEXT
SwapGroup       group   SwapCode

        end
