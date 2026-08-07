;       SCCSID = src/dev/dasd/ibm/ibm2adsk/adskasub.asm, adsk, ddk_subset, ddk2_r206.044 93/03/20

        page    ,132

;**************************************************************************
;*
;* SOURCE FILE NAME = ADSKASUB.ASM
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
;* DESCRIPTION : Miscellaneous assembler helper routines
;*
;*
;***************************************************************************/



        .386p
Code    segment dword public USE16 'CODE'
        assume  CS:Code

STK     equ     [bp]

;-------------------------------------------------------------------------;
;                                                                         ;
;                                                                         ;
;       VOID  NEAR memcpy( PBYTE Dst, PBYTE Src, USHORT cb   );           ;
;                                                                         ;
;                                                                         ;
;-------------------------------------------------------------------------;

Dst     =       4
Src     =       8
cb      =       12

                public  _memcpy
_memcpy         label   near

                push    bp
                mov     bp, sp

                push    dx
                push    ecx
                push    esi
                push    edi
                push    es
                push    ds
;
                xor     esi, esi
                xor     edi, edi
;
                lds     si,  STK.Src
                les     di,  STK.Dst
                movzx   ecx, word ptr STK.cb
                mov     dx,  cx
                cld
;
                shr     cx, 2
                jz      memc0010
                rep     movsd
;
memc0010:
                mov     cx, dx
                and     cx, 3
                jz      memc0020
;
                rep     movsb
memc0020:
                pop     ds
                pop     es
                pop     edi
                pop     esi
                pop     ecx
                pop     dx

                pop     bp

                ret


;-------------------------------------------------------------------------;
;                                                                         ;
;                                                                         ;
; ULONG NEAR ULONGdivUSHORT( ULONG Dividend, USHORT Divisor, NPUSHORT Rem);      ;
;                                                                         ;
;                                                                         ;
;-------------------------------------------------------------------------;

Dividend    =       4
Divisor     =       8
Rem         =       10

                public  _ULONGdivUSHORT
_ULONGdivUSHORT label   near

                push    bp
                mov     bp, sp

                push    ecx

                xor     edx, edx
                mov     eax, STK.Dividend
                movzx   ecx, word ptr STK.Divisor

                div     ecx

                movzx   ecx, word ptr STK.Rem
                or      cx, cx
                jz      ULUS0010

                mov     [ecx], dx
ULUS0010:
                mov     edx, eax
                and     eax, 0ffffh
                shr     edx, 16

                pop     ecx

                pop     bp
                ret

;-------------------------------------------------------------------------;
;                                                                         ;
;                                                                         ;
; ULONG NEAR ULONGmulULONG( ULONG Multiplier, ULONG Multiplicand);        ;
;                                                                         ;
;                                                                         ;
;-------------------------------------------------------------------------;

Multiplier      =       4
Multiplicand    =       8

                public  _ULONGmulULONG
_ULONGmulULONG  label   near

                push    bp
                mov     bp, sp

                push    ecx

                xor     edx, edx
                mov     eax, STK.Multiplier
                mov     ecx, STK.Multiplicand

                mul     ecx
                jno     UMUL0010

                mov     eax, -1
UMUL0010:
                mov     edx, eax
                and     eax, 0ffffh
                shr     edx, 16

                pop     ecx

                pop     bp
                ret

Code            ends
                end
