PAGE 58,132
TITLE ABIOSDSK.ASM -- ABIOSDSK.386 Version 0.90 prerelease
; Copyright (C) 2026 Simplebooks Foundation
; Copyright (C) 2026 Josh Rodd

.386p

.XLIST
INCLUDE VMM.Inc
INCLUDE Debug.Inc
INCLUDE OptTest.Inc
INCLUDE BlockDev.Inc
INCLUDE Int13.Inc
INCLUDE VPICD.Inc
INCLUDE ABIOS.Inc
.LIST

ABIOSDSK_Major_Ver EQU 0
ABIOSDSK_Minor_Ver EQU 90
; ABIOSDSK_DEBUG enables protected-mode diagnostics. Define
; ABIOSDSK_RM_DEBUG separately when real-mode loader diagnostics are needed.
ABIOS_COM1_DIVISOR_57600 EQU 2


Declare_Virtual_Device ABIOSDSK, ABIOSDSK_Major_Ver, ABIOSDSK_Minor_Ver, ABIOSDSK_Control, Undefined_Device_ID, Undef_Touch_Mem_Init_Order

ABIOS_Private_BDD STRUC
                        db SIZE BlockDev_Device_Descriptor dup (?)
ABP_LID                 dw ?
ABP_Unit                dw ?
ABP_IRQ                 db ?
ABP_Retry_Count         db ?
ABP_Max_Transfer        dw ?
ABP_Request_Length      dw ?
ABP_LID_Flags           dw ?
ABP_Device_Flags        dw ?
ABIOS_Private_BDD ENDS

VxD_LOCKED_DATA_SEG

ABIOS_Drives             ABIOS_Private_BDD ABIOS_MAX_DRIVES dup (<>)
ABIOS_Drive_Names        db 'ABIOSD0',0,'ABIOSD1',0,'ABIOSD2',0,'ABIOSD3',0
ABIOS_Drive_Count        dd 0

ABIOS_Real_Base          dd 0
ABIOS_Real_Paragraphs    dd 0
ABIOS_Meta_Linear        dd 0
ABIOS_PM_CDA_Selector    dw 0
ABIOS_PM_FTT_Selector    dw 0
ABIOS_Real_Data_Selector dw 0
ABIOS_Request_Selector   dw 0
ABIOS_Bounce_Selector    dw 0
                        dw 0
ABIOS_PM_Common_Start    dd 0
ABIOS_PM_Common_Interrupt dd 0
ABIOS_PM_Common_Timeout  dd 0
ABIOS_Call_Entry         dd 0
ABIOS_PM_Thunk_Selector  dw 0
ABIOS_Thunk_Entry        dd 0
                         dw 0
; Executed through a dedicated USE16 code selector.  ABIOS records a
; 16-bit return IP into this thunk; the thunk then uses a patched m16:32
; far jump to resume the full 32-bit VxD continuation.
ABIOS_Thunk_Code         db 09Ah
ABIOS_Thunk_Target       dd 0
                         db 066h, 0EAh
ABIOS_Thunk_Return       dd 0
                         dw 0

ABIOS_Code_Segments      dw ABIOS_MAX_LIDS dup (0)
ABIOS_Code_Selectors     dw ABIOS_MAX_LIDS dup (0)
ABIOS_Code_Count         dd 0
ABIOS_Data_Selectors     dw ABIOS_MAX_LIDS dup (0)
ABIOS_Data_Count         dd 0
ABIOS_PM_FTT_Used        dd 0
ABIOS_PM_LID_Count       dd 0
ABIOS_PM_Real_Handle     dd 0
ABIOS_PM_Real_Linear     dd 0

ABIOS_Bounce_Handle      dd 0
ABIOS_Bounce_Linear      dd 0
ABIOS_Bounce_Physical    dd 0

ABIOS_Current_Command    dd 0
ABIOS_Current_BDD        dd 0
ABIOS_Current_Completed  dd 0
ABIOS_Current_Chunk      dd 0
ABIOS_Current_Retries    dd 0
ABIOS_Timeout_Handle     dd 0
ABIOS_Timeout_Kind       dd 0
ABIOS_Timeout_Generation dd 0
ABIOS_Pending_Commands   dd ABIOS_MAX_DRIVES dup (0)
ABIOS_Pending_BDDs       dd ABIOS_MAX_DRIVES dup (0)

ABIOS_Request            db ABIOS_MAX_REQUEST dup (?)

ALIGN 4
ABIOS_PM_Work_Handle      dd 0
ABIOS_PM_CDA_Linear       dd 0
ABIOS_PM_FTT_Linear       dd 0
ABIOS_PM_Stack_Linear     dd 0
ABIOS_PM_Stack_Selector   dw 0
ALIGN 4
ABIOS_Trace_Magic        dd 'RTBA', '!ECA', 13579BDFh, 2468ACE0h
ABIOS_Trace_Index        dd 0
ABIOS_Trace_Entries      dd 2048 dup (0)
IFDEF ABIOSDSK_DEBUG
ABIOS_Debug_VGA_Offset   dd 3360
ABIOS_Debug_PM_Start     db 'ABIOSDSK: protected-mode load starting.',13,10,0
ABIOS_Debug_PM_Metadata  db 'ABIOSDSK: real-mode metadata accepted.',13,10,0
ABIOS_Debug_PM_Workspace db 'ABIOSDSK: protected workspace allocated.',13,10,0
ABIOS_Debug_PM_Tables    db 'ABIOSDSK: protected ABIOS tables built.',13,10,0
ABIOS_Debug_PM_Bounce    db 'ABIOSDSK: bounce buffer allocated.',13,10,0
ABIOS_Debug_PM_Register  db 'ABIOSDSK: registering controlled disk with BlockDev.',13,10,0
ABIOS_Debug_PM_Real_Sel  db 'ABIOSDSK: real-data selector allocated.',13,10,0
ABIOS_Debug_PM_CDA_Sel   db 'ABIOSDSK: protected CDA selector allocated.',13,10,0
ABIOS_Debug_PM_FTT_Sel   db 'ABIOSDSK: protected FTT selector allocated.',13,10,0
ABIOS_Debug_PM_Req_Sel   db 'ABIOSDSK: request selector allocated.',13,10,0
ABIOS_Debug_PM_CDA_Copy  db 'ABIOSDSK: real CDA copied to protected memory.',13,10,0
ABIOS_Debug_PM_LIDs      db 'ABIOSDSK: converting LID function tables.',13,10,0
ABIOS_Debug_PM_Data      db 'ABIOSDSK: converting ABIOS data pointers.',13,10,0
ABIOS_Debug_PM_Common    db 'ABIOSDSK: converting common entry points.',13,10,0
ABIOS_Debug_PM_Data_Try  db 'ABIOSDSK: allocating ABIOS data selector.',13,10,0
ABIOS_Debug_PM_Data_OK   db 'ABIOSDSK: ABIOS data selector allocated.',13,10,0
ABIOS_Debug_PM_Data_Saved db 'ABIOSDSK: ABIOS data selector recorded.',13,10,0
ABIOS_Debug_PM_Data_Index db 'ABIOSDSK: data pointer index '
ABIOS_Debug_PM_Data_Index_Value db 8 dup ('0')
                            db ' of '
ABIOS_Debug_PM_Data_Total_Value db 8 dup ('0')
                            db '.',13,10,0
ABIOS_Debug_PM_No_Ref    db 'ABIOSDSK: no real-mode reference pointer.',13,10,0
ABIOS_Debug_PM_Bad_Magic db 'ABIOSDSK: real-mode metadata signature is invalid.',13,10,0
ABIOS_Debug_PM_Bad_Ver   db 'ABIOSDSK: real-mode metadata version is invalid.',13,10,0
ABIOS_Debug_PM_No_Drives db 'ABIOSDSK: real-mode metadata contains no disks.',13,10,0
ABIOS_Debug_PM_Drive     db 'ABIOSDSK: BlockDev accepted a controlled disk.',13,10,0
ABIOS_Debug_PM_Good      db 'ABIOSDSK: protected-mode load complete; everything is good.',13,10,0
ABIOS_Debug_PM_Fail      db 'ABIOSDSK: protected-mode load failed.',13,10,0
ABIOS_Debug_IO_Command    db 'ABIOSDSK: BlockDev command '
ABIOS_Debug_IO_Command_Value db 8 dup ('0')
                            db ', sector '
ABIOS_Debug_IO_Sector_Value db 8 dup ('0')
                            db ', count '
ABIOS_Debug_IO_Count_Value db 8 dup ('0')
                            db ', flags '
ABIOS_Debug_IO_Flags_Value db 8 dup ('0')
                            db '.',13,10,0
ABIOS_Debug_IO_Call       db 'ABIOSDSK: entering ABIOS start routine.',13,10,0
ABIOS_Debug_IO_Start_RC   db 'ABIOSDSK: ABIOS start returned '
ABIOS_Debug_IO_Start_RC_Value db 8 dup ('0')
                            db '.',13,10,0
ABIOS_Debug_IO_Interrupt  db 'ABIOSDSK: hardware interrupt callback.',13,10,0
ABIOS_Debug_IO_Interrupt_RC db 'ABIOSDSK: ABIOS interrupt returned '
ABIOS_Debug_IO_Interrupt_RC_Value db 8 dup ('0')
                            db '.',13,10,0
ABIOS_Debug_IO_Timeout    db 'ABIOSDSK: ABIOS timeout callback.',13,10,0
ABIOS_Debug_IO_Complete   db 'ABIOSDSK: completing BlockDev command with status '
ABIOS_Debug_IO_Status_Value db 8 dup ('0')
                            db '.',13,10,0
ABIOS_Debug_Call_Frame    db 'ABIOSDSK: call frame selector '
ABIOS_Debug_Call_Selector_Value db 8 dup ('0')
                            db ', ESP '
ABIOS_Debug_Call_ESP_Value db 8 dup ('0')
                            db ', words '
ABIOS_Debug_Call_Word0_Value db 8 dup ('0')
                            db '/'
ABIOS_Debug_Call_Word1_Value db 8 dup ('0')
                            db '/'
ABIOS_Debug_Call_Word2_Value db 8 dup ('0')
                            db '.',13,10,0
ABIOS_Debug_Call_Target   db 'ABIOSDSK: call target '
ABIOS_Debug_Call_Target_Value db 8 dup ('0')
                            db '.',13,10,0
ABIOS_Debug_IO_Data       db 'ABIOSDSK: read RBA/data/destination '
ABIOS_Debug_IO_RBA_Value  db 8 dup ('0')
                            db '/'
ABIOS_Debug_IO_Data0_Value db 8 dup ('0')
                            db '/'
ABIOS_Debug_IO_Data1_Value db 8 dup ('0')
                            db '/'
ABIOS_Debug_IO_Data2_Value db 8 dup ('0')
                            db '/'
ABIOS_Debug_IO_Data3_Value db 8 dup ('0')
                            db '/'
ABIOS_Debug_IO_Dest_Value db 8 dup ('0')
                            db '.',13,10,0
ENDIF

VxD_LOCKED_DATA_ENDS

VxD_LOCKED_CODE_SEG
; EAX=event, EBX/ECX/EDX=event data. Each entry is four dwords.
BeginProc ABIOSDSK_Trace
        ret
EndProc ABIOSDSK_Trace
IFDEF ABIOSDSK_DEBUG
BeginProc ABIOSDSK_Debug_Init_COM1
        pushfd
        push    eax
        push    edx
        cli
        mov     dx, 3F9h
        xor     al, al
        out     dx, al
        mov     dx, 3FBh
        mov     al, 80h
        out     dx, al
        mov     dx, 3F8h
        mov     al, ABIOS_COM1_DIVISOR_57600
        out     dx, al
        inc     dx
        xor     al, al
        out     dx, al
        mov     dx, 3FBh
        mov     al, 3
        out     dx, al
        mov     dx, 3FAh
        mov     al, 7
        out     dx, al
        mov     dx, 3FCh
        mov     al, 3
        out     dx, al
        pop     edx
        pop     eax
        popfd
        ret
EndProc ABIOSDSK_Debug_Init_COM1

; ESI addresses a NUL-terminated line. Mirror it to COM1 and VGA text memory.
BeginProc ABIOSDSK_Debug_Line
        ret
        pushfd
        pushad
        mov     edi, [ABIOS_Debug_VGA_Offset]
        add     edi, 0B8000h
ABDL_Next:
        lodsb
        test    al, al
        jz      SHORT ABDL_Done
        mov     bl, al
        mov     dx, 3FDh
        mov     cx, 0FFFFh
ABDL_COM_Wait:
        in      al, dx
        test    al, 20h
        jnz     SHORT ABDL_COM_Send
        loop    ABDL_COM_Wait
        jmp     SHORT ABDL_VGA
ABDL_COM_Send:
        mov     dx, 3F8h
        mov     al, bl
        out     dx, al
ABDL_VGA:
        cmp     bl, 13
        je      SHORT ABDL_Next
        cmp     bl, 10
        je      SHORT ABDL_Done
        mov     ah, 07h
        mov     al, bl
        mov     WORD PTR [edi], ax
        add     edi, 2
        jmp     SHORT ABDL_Next
ABDL_Done:
        add     [ABIOS_Debug_VGA_Offset], 160
        cmp     [ABIOS_Debug_VGA_Offset], 4000
        jb      SHORT ABDL_Return
        mov     [ABIOS_Debug_VGA_Offset], 0
ABDL_Return:
        popad
        popfd
        ret
EndProc ABIOSDSK_Debug_Line

; EAX is formatted as eight hexadecimal digits at EDI.
BeginProc ABIOSDSK_Debug_Format_Dword
        pushad
        mov     ecx, 8
ABDFD_Next:
        rol     eax, 4
        mov     dl, al
        and     dl, 0Fh
        add     dl, '0'
        cmp     dl, '9'
        jbe     SHORT ABDFD_Store
        add     dl, 'A'-'9'-1
ABDFD_Store:
        mov     [edi], dl
        inc     edi
        loop    ABDFD_Next
        popad
        ret
EndProc ABIOSDSK_Debug_Format_Dword
BeginProc ABIOSDSK_Debug_Command
        pushad
        movzx   eax, WORD PTR [esi.BD_CB_Command]
        mov     edi, OFFSET32 ABIOS_Debug_IO_Command_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     eax, DWORD PTR [esi.BD_CB_Sector]
        mov     edi, OFFSET32 ABIOS_Debug_IO_Sector_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     eax, DWORD PTR [esi.BD_CB_Count]
        mov     edi, OFFSET32 ABIOS_Debug_IO_Count_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     eax, DWORD PTR [esi.BD_CB_Flags]
        mov     edi, OFFSET32 ABIOS_Debug_IO_Flags_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     esi, OFFSET32 ABIOS_Debug_IO_Command
        call    ABIOSDSK_Debug_Line
        popad
        ret
EndProc ABIOSDSK_Debug_Command

; ESI selects a line containing an eight-digit field at EDI.
; The current ABIOS return code is written to that field.
BeginProc ABIOSDSK_Debug_Return_Code
        pushad
        movzx   eax, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        call    ABIOSDSK_Debug_Format_Dword
        call    ABIOSDSK_Debug_Line
        popad
        ret
EndProc ABIOSDSK_Debug_Return_Code
BeginProc ABIOSDSK_Debug_Read_Data
        pushad
        mov     eax, [ABIOS_Request+ABIOS_RW_RBA]
        mov     edi, OFFSET32 ABIOS_Debug_IO_RBA_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     esi, [ABIOS_Bounce_Linear]
        mov     eax, [esi]
        mov     edi, OFFSET32 ABIOS_Debug_IO_Data0_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     eax, [esi+4]
        mov     edi, OFFSET32 ABIOS_Debug_IO_Data1_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     eax, [esi+8]
        mov     edi, OFFSET32 ABIOS_Debug_IO_Data2_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     eax, [esi+12]
        mov     edi, OFFSET32 ABIOS_Debug_IO_Data3_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     esi, [ABIOS_Current_Command]
        mov     esi, [esi.BD_CB_Buffer_Ptr]
        mov     eax, [esi]
        mov     edi, OFFSET32 ABIOS_Debug_IO_Dest_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     esi, OFFSET32 ABIOS_Debug_IO_Data
        call    ABIOSDSK_Debug_Line
        popad
        ret
EndProc ABIOSDSK_Debug_Read_Data

; EAX is the BlockDev completion status.
BeginProc ABIOSDSK_Debug_Status
        pushad
        mov     edi, OFFSET32 ABIOS_Debug_IO_Status_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     esi, OFFSET32 ABIOS_Debug_IO_Complete
        call    ABIOSDSK_Debug_Line
        popad
        ret
EndProc ABIOSDSK_Debug_Status

ENDIF


BeginProc ABIOSDSK_Control
        Control_Dispatch Sys_Critical_Init, ABIOSDSK_Sys_Critical_Init
        clc
        ret
EndProc ABIOSDSK_Control

; Allocate a ring-0, byte-granular writable selector.
; EAX=linear base, ECX=limit. Returns AX=selector, zero on failure.
BeginProc ABIOSDSK_Alloc_Data_Selector
        push    ebx
        push    edx
        push    esi
        push    edi
        VMMcall _BuildDescriptorDWORDs, <eax, ecx, RW_Data_Type, D_GRAN_BYTE, BDDExplicitDPL>
        VMMcall _Allocate_GDT_Selector, <edx, eax, 0>
        pop     edi
        pop     esi
        pop     edx
        pop     ebx
        ret
EndProc ABIOSDSK_Alloc_Data_Selector

; Convert a real-mode code pointer in EAX to selector:offset in EAX.
BeginProc ABIOSDSK_Convert_Code_Pointer
        test    eax, eax
        jz      ACDP_Exit
        push    ebx
        push    ecx
        push    edx
        push    esi
        push    edi
        movzx   edi, ax
        shr     eax, 16
        mov     ebx, eax
        mov     ecx, [ABIOS_Code_Count]
        xor     esi, esi
ACDP_Find:
        jecxz   SHORT ACDP_Allocate
        cmp     bx, [ABIOS_Code_Segments+esi*2]
        je      SHORT ACDP_Found
        inc     esi
        dec     ecx
        jmp     SHORT ACDP_Find
ACDP_Allocate:
        cmp     esi, ABIOS_MAX_LIDS
        jae     SHORT ACDP_Fail
        movzx   eax, bx
        shl     eax, 4
        mov     ecx, 0FFFFh
        VMMcall _BuildDescriptorDWORDs, <eax, ecx, Code_Type, D_DEF16, BDDExplicitDPL>
        VMMcall _Allocate_GDT_Selector, <edx, eax, 0>
        test    eax, eax
        jz      SHORT ACDP_Fail
        mov     [ABIOS_Code_Segments+esi*2], bx
        mov     [ABIOS_Code_Selectors+esi*2], ax
        inc     [ABIOS_Code_Count]
ACDP_Found:
        movzx   eax, [ABIOS_Code_Selectors+esi*2]
        shl     eax, 16
        mov     ax, di
        jmp     SHORT ACDP_Done
ACDP_Fail:
        xor     eax, eax
ACDP_Done:
        pop     edi
        pop     esi
        pop     edx
        pop     ecx
        pop     ebx
ACDP_Exit:
        ret
EndProc ABIOSDSK_Convert_Code_Pointer

; Convert real segment:offset in EAX to a flat physical/linear address.
BeginProc ABIOSDSK_Real_Pointer_To_Linear
        movzx   edx, ax
        shr     eax, 16
        shl     eax, 4
        add     eax, edx
        ret
EndProc ABIOSDSK_Real_Pointer_To_Linear

; Build protected-mode CDA, function tables, and all selectors.
; EBX points at the real-mode metadata record.
BeginProc ABIOSDSK_Build_PM_Tables
        pushad
        mov     [ABIOS_Meta_Linear], ebx
        movzx   ecx, [ebx.AM_Allocation_Paragraphs]
        mov     [ABIOS_Real_Paragraphs], ecx
        shl     ecx, 4
        mov     edx, ecx
        add     edx, 4095
        shr     edx, 12
        VMMcall _PageAllocate, <edx, PG_SYS, 0, 0, 0, 0, 0, <PageLocked+PageZeroInit>>
        test    eax, eax
        jz      ABPM_Fail
        mov     [ABIOS_PM_Real_Handle], eax
        mov     [ABIOS_PM_Real_Linear], edx
        mov     edi, edx
        mov     esi, [ABIOS_Real_Base]
        mov     ecx, [ABIOS_Real_Paragraphs]
        shl     ecx, 4
        cld
        rep movsb
        mov     eax, [ABIOS_PM_Real_Linear]
        mov     ecx, [ABIOS_Real_Paragraphs]
        shl     ecx, 4
        dec     ecx
        call    ABIOSDSK_Alloc_Data_Selector
        test    eax, eax
        jz      ABPM_Fail
        mov     [ABIOS_Real_Data_Selector], ax
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Real_Sel
        call    ABIOSDSK_Debug_Line
ENDIF

        mov     eax, [ABIOS_PM_CDA_Linear]
        mov     ecx, ABIOS_MAX_CDA-1
        call    ABIOSDSK_Alloc_Data_Selector
        test    eax, eax
        jz      ABPM_Fail
        mov     [ABIOS_PM_CDA_Selector], ax
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_CDA_Sel
        call    ABIOSDSK_Debug_Line
ENDIF

        mov     eax, [ABIOS_PM_FTT_Linear]
        mov     ecx, ABIOS_MAX_PM_FTT-1
        call    ABIOSDSK_Alloc_Data_Selector
        test    eax, eax
        jz      ABPM_Fail
        mov     [ABIOS_PM_FTT_Selector], ax
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_FTT_Sel
        call    ABIOSDSK_Debug_Line
ENDIF

        mov     eax, OFFSET32 ABIOS_Request
        mov     ecx, ABIOS_MAX_REQUEST-1
        call    ABIOSDSK_Alloc_Data_Selector
        test    eax, eax
        jz      ABPM_Fail
        mov     [ABIOS_Request_Selector], ax
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Req_Sel
        call    ABIOSDSK_Debug_Line
ENDIF

        movzx   ecx, [ebx.AM_CDA_Size]
        cmp     ecx, ABIOS_MAX_CDA
        ja      ABPM_Fail
        mov     esi, [ABIOS_Real_Base]
        mov     edi, [ABIOS_PM_CDA_Linear]
        cld
        rep movsb
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_CDA_Copy
        call    ABIOSDSK_Debug_Line
ENDIF

        mov     [ABIOS_PM_FTT_Used], 0
        movzx   eax, [ebx.AM_LID_Count]
        cmp     eax, ABIOS_MAX_LIDS
        ja      ABPM_Fail
        mov     [ABIOS_PM_LID_Count], eax
        mov     ebp, 1
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_LIDs
        call    ABIOSDSK_Debug_Line
ENDIF
ABPM_LID_Loop:
        cmp     ebp, [ABIOS_PM_LID_Count]
        ja      ABPM_Data_Pointers
        mov     esi, [ABIOS_Real_Base]
        lea     esi, [esi+ebp*8]
        mov     eax, [esi.ABIOS_CDA_DEVICE_BLOCK]
        mov     edx, [esi.ABIOS_CDA_FUNCTION_TABLE]
        mov     edi, [ABIOS_PM_CDA_Linear]
        lea     edi, [edi+ebp*8]
        test    eax, eax
        jz      ABPM_Null_LID
        test    edx, edx
        jz      ABPM_Null_LID

        push    edx
        call    ABIOSDSK_Real_Pointer_To_Linear
        sub     eax, [ABIOS_Real_Base]
        jc      ABPM_Pop_Fail
        movzx   edx, [ABIOS_Real_Data_Selector]
        shl     edx, 16
        and     eax, 0FFFFh
        or      eax, edx
        mov     [edi.ABIOS_CDA_DEVICE_BLOCK], eax
        pop     eax

        call    ABIOSDSK_Real_Pointer_To_Linear
        mov     esi, eax
        movzx   eax, WORD PTR [esi.ABIOS_FTT_FUNCTION_COUNT]
        lea     eax, [eax*4+ABIOS_FTT_FIRST_FUNCTION]
        mov     edx, [ABIOS_PM_FTT_Used]
        add     edx, 3
        and     edx, NOT 3
        mov     [ABIOS_PM_FTT_Used], edx
        add     eax, edx
        cmp     eax, ABIOS_MAX_PM_FTT
        ja      ABPM_Fail
        sub     eax, edx
        mov     ecx, eax
        mov     edi, [ABIOS_PM_FTT_Linear]
        add     edi, edx
        push    edi
        cld
        rep movsb
        pop     edi

        mov     eax, [edi.ABIOS_FTT_START]
        call    ABIOSDSK_Convert_Code_Pointer
        test    eax, eax
        jz      ABPM_Fail
        mov     [edi.ABIOS_FTT_START], eax
        mov     eax, [edi.ABIOS_FTT_INTERRUPT]
        call    ABIOSDSK_Convert_Code_Pointer
        mov     [edi.ABIOS_FTT_INTERRUPT], eax
        mov     eax, [edi.ABIOS_FTT_TIMEOUT]
        call    ABIOSDSK_Convert_Code_Pointer
        mov     [edi.ABIOS_FTT_TIMEOUT], eax

        movzx   ecx, WORD PTR [edi.ABIOS_FTT_FUNCTION_COUNT]
        add     edi, ABIOS_FTT_FIRST_FUNCTION
ABPM_Function_Loop:
        jecxz   SHORT ABPM_Functions_Done
        mov     eax, [edi]
        call    ABIOSDSK_Convert_Code_Pointer
        mov     [edi], eax
        add     edi, 4
        dec     ecx
        jmp     SHORT ABPM_Function_Loop
ABPM_Functions_Done:
        mov     eax, [ABIOS_PM_FTT_Used]
        mov     edi, [ABIOS_PM_FTT_Linear]
        add     edi, eax
        movzx   edx, WORD PTR [edi.ABIOS_FTT_FUNCTION_COUNT]
        lea     edx, [edx*4+ABIOS_FTT_FIRST_FUNCTION]
        add     [ABIOS_PM_FTT_Used], edx
        movzx   edx, [ABIOS_PM_FTT_Selector]
        shl     edx, 16
        or      eax, edx
        mov     edi, [ABIOS_PM_CDA_Linear]
        mov     [edi+ebp*8+ABIOS_CDA_FUNCTION_TABLE], eax
        inc     ebp
        jmp     ABPM_LID_Loop

ABPM_Pop_Fail:
        pop     eax
        jmp     ABPM_Fail
ABPM_Null_LID:
        mov     DWORD PTR [edi.ABIOS_CDA_DEVICE_BLOCK], 0
        mov     DWORD PTR [edi.ABIOS_CDA_FUNCTION_TABLE], 0
        inc     ebp
        jmp     ABPM_LID_Loop

ABPM_Data_Pointers:
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Data
        call    ABIOSDSK_Debug_Line
ENDIF
        mov     esi, [ABIOS_PM_CDA_Linear]
        movzx   edx, WORD PTR [esi.ABIOS_CDA_DATA0_OFFSET]
        movzx   ecx, WORD PTR [esi+edx+6]
        cmp     ecx, ABIOS_MAX_LIDS
        ja      ABPM_Fail
        xor     ebp, ebp
ABPM_Data_Loop:
IFDEF ABIOSDSK_DEBUG
        mov     eax, ebp
        mov     edi, OFFSET32 ABIOS_Debug_PM_Data_Index_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     eax, ecx
        mov     edi, OFFSET32 ABIOS_Debug_PM_Data_Total_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     esi, OFFSET32 ABIOS_Debug_PM_Data_Index
        call    ABIOSDSK_Debug_Line
ENDIF
        cmp     ebp, ecx
        jae     SHORT ABPM_Common_Pointers
        mov     edi, edx
        mov     eax, ebp
        imul    eax, 6
        sub     edi, eax
        add     edi, [ABIOS_PM_CDA_Linear]
        movzx   eax, WORD PTR [edi+2]
        movzx   ebx, WORD PTR [edi+4]
        shl     ebx, 4
        add     eax, ebx
        sub     eax, [ABIOS_Real_Base]
        jc      ABPM_Fail
        add     eax, [ABIOS_PM_Real_Linear]
        movzx   ebx, WORD PTR [edi]
        mov     esi, ecx
        mov     ecx, ebx
IFDEF ABIOSDSK_DEBUG
        push    esi
        mov     esi, OFFSET32 ABIOS_Debug_PM_Data_Try
        call    ABIOSDSK_Debug_Line
        pop     esi
ENDIF
        call    ABIOSDSK_Alloc_Data_Selector
        mov     ecx, esi
        test    eax, eax
        jz      ABPM_Fail
        mov     WORD PTR [edi+2], 0
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Data_OK
        call    ABIOSDSK_Debug_Line
ENDIF
        mov     WORD PTR [edi+4], ax
        mov     ebx, [ABIOS_Data_Count]
        mov     [ABIOS_Data_Selectors+ebx*2], ax
        inc     [ABIOS_Data_Count]
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Data_Saved
        call    ABIOSDSK_Debug_Line
ENDIF
        inc     ebp
        jmp     ABPM_Data_Loop

ABPM_Common_Pointers:
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Common
        call    ABIOSDSK_Debug_Line
ENDIF
        mov     ebx, [ABIOS_Meta_Linear]
        mov     eax, [ebx.AM_Common_Start]
        call    ABIOSDSK_Convert_Code_Pointer
        test    eax, eax
        jz      ABPM_Fail
        mov     [ABIOS_PM_Common_Start], eax
        mov     eax, [ebx.AM_Common_Interrupt]
        call    ABIOSDSK_Convert_Code_Pointer
        test    eax, eax
        jz      ABPM_Fail
        mov     [ABIOS_PM_Common_Interrupt], eax
        mov     eax, [ebx.AM_Common_Timeout]
        call    ABIOSDSK_Convert_Code_Pointer
        mov     [ABIOS_PM_Common_Timeout], eax
        popad
        clc
        ret
ABPM_Fail:
        popad
        stc
        ret
EndProc ABIOSDSK_Build_PM_Tables

BeginProc ABIOSDSK_Allocate_PM_Workspace
        mov     edx, ABIOS_PM_WORK_PAGES
        VMMcall _PageAllocate, <edx, PG_SYS, 0, 0, 0, 0, 0, <PageLocked+PageZeroInit>>
        test    eax, eax
        jz      AAPW_Fail
        mov     [ABIOS_PM_Work_Handle], eax
        mov     [ABIOS_PM_CDA_Linear], edx
        add     edx, ABIOS_MAX_CDA
        mov     [ABIOS_PM_FTT_Linear], edx
        add     edx, ABIOS_MAX_PM_FTT
        mov     [ABIOS_PM_Stack_Linear], edx
        mov     eax, edx
        mov     ecx, ABIOS_PM_STACK_BYTES-1
        VMMcall _BuildDescriptorDWORDs, <eax, ecx, RW_Data_Type, D_GRAN_BYTE, BDDExplicitDPL>
        VMMcall _Allocate_GDT_Selector, <edx, eax, 0>
        test    eax, eax
        jz      SHORT AAPW_Fail
        mov     [ABIOS_PM_Stack_Selector], ax
        mov     eax, OFFSET32 ABIOS_Thunk_Code
        mov     ecx, 12
        VMMcall _BuildDescriptorDWORDs, <eax, ecx, Code_Type, D_DEF16, BDDExplicitDPL>
        VMMcall _Allocate_GDT_Selector, <edx, eax, 0>
        test    eax, eax
        jz      SHORT AAPW_Fail
        mov     [ABIOS_PM_Thunk_Selector], ax
        mov     WORD PTR [ABIOS_Thunk_Entry+4], ax
        clc
        ret
AAPW_Fail:
        stc
        ret
EndProc ABIOSDSK_Allocate_PM_Workspace

BeginProc ABIOSDSK_Allocate_Bounce
        mov     edx, ABIOS_BOUNCE_PAGES
        mov     eax, ABIOS_BOUNCE_PAGES-1
        mov     edi, OFFSET32 ABIOS_Bounce_Physical
        VMMcall _PageAllocate, <edx, PG_SYS, 0, eax, 0, 0FFFh, edi, PageUseAlign+PageContig+PageFixed+PageZeroInit>
        test    eax, eax
        jz      SHORT AAB_Fail
        mov     [ABIOS_Bounce_Handle], eax
        mov     [ABIOS_Bounce_Linear], edx
        mov     ecx, ABIOS_BOUNCE_BYTES-1
        call    ABIOSDSK_Alloc_Data_Selector
        test    eax, eax
        jz      SHORT AAB_Fail
        mov     [ABIOS_Bounce_Selector], ax
        mov     edi, [ABIOS_Bounce_Linear]
        add     edi, 2000h
        mov     DWORD PTR [edi], 'RTBA'
        mov     DWORD PTR [edi+4], '!ECA'
        mov     DWORD PTR [edi+8], 13579BDFh
        mov     DWORD PTR [edi+12], 2468ACE0h
        mov     DWORD PTR [edi+16], 0
        clc
        ret
AAB_Fail:
        stc
        ret
EndProc ABIOSDSK_Allocate_Bounce

BeginProc ABIOSDSK_Sys_Critical_Init
IFDEF ABIOSDSK_DEBUG
        call    ABIOSDSK_Debug_Init_COM1
        mov     esi, OFFSET32 ABIOS_Debug_PM_Start
        call    ABIOSDSK_Debug_Line
ENDIF
        mov     eax, edx
        shr     eax, 16
        test    eax, eax
        jz      ABSCI_Fail_No_Ref
        shl     eax, 4
        mov     [ABIOS_Real_Base], eax
        movzx   ebx, dx
        add     ebx, eax
        cmp     [ebx.AM_Magic], ABIOS_META_MAGIC
        jne     ABSCI_Fail_Bad_Magic
        cmp     [ebx.AM_Version], ABIOS_META_VERSION
        jne     ABSCI_Fail_Bad_Ver
        cmp     [ebx.AM_Drive_Count], 0
        je      ABSCI_Fail_No_Drives
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Metadata
        call    ABIOSDSK_Debug_Line
ENDIF
        call    ABIOSDSK_Allocate_PM_Workspace
        jc      ABSCI_Fail
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Workspace
        call    ABIOSDSK_Debug_Line
ENDIF
        call    ABIOSDSK_Build_PM_Tables
        jc      ABSCI_Fail
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Tables
        call    ABIOSDSK_Debug_Line
ENDIF
        call    ABIOSDSK_Allocate_Bounce
        jc      ABSCI_Fail
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Bounce
        call    ABIOSDSK_Debug_Line
ENDIF

        mov     ebx, [ABIOS_Meta_Linear]
        movzx   ecx, [ebx.AM_Drive_Count]
        cmp     ecx, ABIOS_MAX_DRIVES
        jbe     SHORT ABSCI_Count_OK
        mov     ecx, ABIOS_MAX_DRIVES
ABSCI_Count_OK:
        xor     ebp, ebp
        add     ebx, ABIOS_META_HEADER_SIZE
ABSCI_Drive_Loop:
        test    ecx, ecx
        jz      ABSCI_Done
        cmp     [ebx.ADM_IRQ], 14
        jne     ABSCI_Next_Drive
        cmp     [ebx.ADM_Block_Size], 512
        jne     ABSCI_Next_Drive
        cmp     [ebx.ADM_RBA_Count], 0
        je      ABSCI_Next_Drive

        mov     eax, ebp
        imul    eax, SIZE ABIOS_Private_BDD
        mov     edi, OFFSET32 ABIOS_Drives
        add     edi, eax
        mov     [edi.BDD_BD_Major_Ver], BD_Major_Version
        mov     [edi.BDD_BD_Minor_Ver], BD_Minor_Version
        mov     [edi.BDD_Device_Type], BDT_Fixed_Disk
        mov     al, [ebx.ADM_Int13_Drive]
        mov     [edi.BDD_Int_13h_Number], al
        mov     [edi.BDD_Flags], BDF_Int13_Drive OR BDF_Writeable OR BDF_Serial_Cmd
        mov     eax, ebp
        shl     eax, 3
        add     eax, OFFSET32 ABIOS_Drive_Names
        mov     [edi.BDD_Name_Ptr], eax
        mov     eax, [ebx.ADM_RBA_Count]
        dec     eax
        mov     DWORD PTR [edi.BDD_Max_Sector], eax
        mov     DWORD PTR [edi.BDD_Max_Sector+4], 0
        mov     DWORD PTR [edi.BDD_Sector_Size], 512
        mov     eax, [ebx.ADM_Heads]
        mov     [edi.BDD_Num_Heads], eax
        mov     eax, [ebx.ADM_Cylinders]
        mov     [edi.BDD_Num_Cylinders], eax
        movzx   eax, [ebx.ADM_Sectors_Per_Track]
        mov     [edi.BDD_Num_Sec_Per_Track], eax
        mov     [edi.BDD_Sync_Cmd_Proc], OFFSET32 ABIOSDSK_Sync_Command
        mov     [edi.BDD_Command_Proc], OFFSET32 ABIOSDSK_Command
        mov     [edi.BDD_Hw_Int_Proc], OFFSET32 ABIOSDSK_Hw_Int
        mov     ax, [ebx.ADM_LID]
        mov     [edi.ABP_LID], ax
        mov     ax, [ebx.ADM_Unit]
        mov     [edi.ABP_Unit], ax
        mov     al, [ebx.ADM_IRQ]
        mov     [edi.ABP_IRQ], al
        mov     al, [ebx.ADM_Retry_Count]
        cmp     al, 8
        jbe     SHORT ABSCI_Retry_OK
        mov     al, 8
ABSCI_Retry_OK:
        mov     [edi.ABP_Retry_Count], al
        mov     ax, [ebx.ADM_Max_Transfer]
        test    ax, ax
        jnz     SHORT ABSCI_Xfer_Nonzero
        mov     ax, 1
ABSCI_Xfer_Nonzero:
        cmp     ax, ABIOS_BOUNCE_SECTORS
        jbe     SHORT ABSCI_Xfer_OK
        mov     ax, ABIOS_BOUNCE_SECTORS
ABSCI_Xfer_OK:
        mov     [edi.ABP_Max_Transfer], ax
        mov     ax, [ebx.ADM_Request_Length]
        cmp     ax, ABIOS_RW_SIZE
        jb      ABSCI_Fail
        cmp     ax, ABIOS_MAX_REQUEST
        ja      ABSCI_Fail
        mov     [edi.ABP_Request_Length], ax
        mov     ax, [ebx.ADM_LID_Flags]
        mov     [edi.ABP_LID_Flags], ax
        mov     ax, [ebx.ADM_Device_Flags]
        mov     [edi.ABP_Device_Flags], ax
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Register
        call    ABIOSDSK_Debug_Line
ENDIF
        push    ebx
        push    ecx
        push    ebp
        VxDcall BlockDev_Register_Device
        pop     ebp
        pop     ecx
        pop     ebx
        jc      ABSCI_Fail
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Drive
        call    ABIOSDSK_Debug_Line
ENDIF
        inc     ebp
ABSCI_Next_Drive:
        add     ebx, SIZE ABIOS_DRIVE_META
        dec     ecx
        jmp     ABSCI_Drive_Loop
ABSCI_Done:
        mov     [ABIOS_Drive_Count], ebp
        test    ebp, ebp
        jz      SHORT ABSCI_Fail
        ; The real-mode initializer temporarily marks its DOS block as system
        ; owned so WIN.COM cannot reclaim it before this protected copy exists.
        ; All ABIOS pointers now reference locked pages; return that conventional
        ; memory to the DOS arena before Windows sizes its remaining memory.
        mov     eax, [ABIOS_Real_Base]
        sub     eax, 10h
        cmp     BYTE PTR [eax], 'M'
        je      SHORT ABSCI_Free_Real
        cmp     BYTE PTR [eax], 'Z'
        jne     SHORT ABSCI_Real_Freed
ABSCI_Free_Real:
        cmp     WORD PTR [eax+1], 0008h
        jne     SHORT ABSCI_Real_Freed
        mov     WORD PTR [eax+1], 0000h
ABSCI_Real_Freed:
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Good
        call    ABIOSDSK_Debug_Line
ENDIF
        clc
        ret
ABSCI_Fail_No_Ref:
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_No_Ref
        call    ABIOSDSK_Debug_Line
ENDIF
        jmp     SHORT ABSCI_Fail
ABSCI_Fail_Bad_Magic:
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Bad_Magic
        call    ABIOSDSK_Debug_Line
ENDIF
        jmp     SHORT ABSCI_Fail
ABSCI_Fail_Bad_Ver:
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Bad_Ver
        call    ABIOSDSK_Debug_Line
ENDIF
        jmp     SHORT ABSCI_Fail
ABSCI_Fail_No_Drives:
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_No_Drives
        call    ABIOSDSK_Debug_Line
ENDIF
        jmp     SHORT ABSCI_Fail
ABSCI_Fail:
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_PM_Fail
        call    ABIOSDSK_Debug_Line
ENDIF
        stc
        ret
EndProc ABIOSDSK_Sys_Critical_Init

BeginProc ABIOSDSK_Sync_Command
        or      ax, ax
        jnz     SHORT ABSC_Invalid
        mov     ax, (BD_Major_Version SHL 8) OR BD_Minor_Version
        clc
        ret
ABSC_Invalid:
        mov     ax, BD_SC_Err_Invalid_Cmd
        stc
        ret
EndProc ABIOSDSK_Sync_Command

; EAX selects the common ABIOS entry point and EDX selects one of the
; non-overlapping 16-bit stack slices before entering this helper.
BeginProc ABIOSDSK_Call_Common
        mov     [ABIOS_Call_Entry], eax
        mov     [ABIOS_Thunk_Target], eax
        mov     eax, OFFSET32 ABIOSDSK_Call_Return
        mov     [ABIOS_Thunk_Return], eax
        mov     ax, cs
        mov     WORD PTR [ABIOS_Thunk_Return+4], ax
        pushfd
        pushad
        push    ds
        push    es
        push    fs
        push    gs
        cld
        mov     ebx, esp
        mov     cx, ss
        mov     edi, edx
IFDEF ABIOSDSK_DEBUG
        pushad
        mov     eax, [ABIOS_Call_Entry]
        mov     edi, OFFSET32 ABIOS_Debug_Call_Target_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     esi, OFFSET32 ABIOS_Debug_Call_Target
        call    ABIOSDSK_Debug_Line
        popad
ENDIF
        mov     ax, [ABIOS_PM_Stack_Selector]
        mov     ss, ax
        mov     esp, edi
        push    ebx
        push    ecx
        sub     esp, 14
        mov     WORD PTR [esp+8], 0
        mov     ax, [ABIOS_Request_Selector]
        mov     WORD PTR [esp+10], ax
        mov     ax, [ABIOS_PM_CDA_Selector]
        mov     WORD PTR [esp+12], ax
IFDEF ABIOSDSK_DEBUG
        pushad
        movzx   eax, [ABIOS_Request_Selector]
        mov     edi, OFFSET32 ABIOS_Debug_Call_Selector_Value
        call    ABIOSDSK_Debug_Format_Dword
        lea     eax, [esp+32]
        mov     edi, OFFSET32 ABIOS_Debug_Call_ESP_Value
        call    ABIOSDSK_Debug_Format_Dword
        movzx   eax, WORD PTR [esp+32+8]
        mov     edi, OFFSET32 ABIOS_Debug_Call_Word0_Value
        call    ABIOSDSK_Debug_Format_Dword
        movzx   eax, WORD PTR [esp+32+10]
        mov     edi, OFFSET32 ABIOS_Debug_Call_Word1_Value
        call    ABIOSDSK_Debug_Format_Dword
        movzx   eax, WORD PTR [esp+32+12]
        mov     edi, OFFSET32 ABIOS_Debug_Call_Word2_Value
        call    ABIOSDSK_Debug_Format_Dword
        mov     esi, OFFSET32 ABIOS_Debug_Call_Frame
        call    ABIOSDSK_Debug_Line
        popad
ENDIF
        db      0FFh, 02Dh              ; JMP FAR m16:32 to the USE16 thunk
        dd      OFFSET32 ABIOS_Thunk_Entry
ABIOSDSK_Call_Return:
        add     esp, 14
        pop     ecx
        pop     ebx
        mov     ss, cx
        mov     esp, ebx
        pop     gs
        pop     fs
        pop     es
        pop     ds
        popad
        popfd
        ret
EndProc ABIOSDSK_Call_Common

BeginProc ABIOSDSK_Call_Start
        mov     edx, ABIOS_PM_STACK_START_TOP
        mov     eax, [ABIOS_PM_Common_Start]
        jmp     ABIOSDSK_Call_Common
EndProc ABIOSDSK_Call_Start

BeginProc ABIOSDSK_Call_Interrupt
        mov     edx, ABIOS_PM_STACK_INTERRUPT_TOP
        mov     eax, [ABIOS_PM_Common_Interrupt]
        jmp     ABIOSDSK_Call_Common
EndProc ABIOSDSK_Call_Interrupt
; A stage-on-time resume invokes the interrupt entry point from timeout
; context. Use the timeout stack slice so a real IRQ can safely preempt it.
BeginProc ABIOSDSK_Call_Delay
        mov     edx, ABIOS_PM_STACK_TIMEOUT_TOP
        mov     eax, [ABIOS_PM_Common_Interrupt]
        jmp     ABIOSDSK_Call_Common
EndProc ABIOSDSK_Call_Delay


BeginProc ABIOSDSK_Call_Timeout
        mov     eax, [ABIOS_PM_Common_Timeout]
        test    eax, eax
        jz      SHORT ACTO_Unsupported
        mov     edx, ABIOS_PM_STACK_TIMEOUT_TOP
        jmp     ABIOSDSK_Call_Common
ACTO_Unsupported:
        mov     WORD PTR [ABIOS_Request+ABIOS_RB_RC], 0C020h
        ret
EndProc ABIOSDSK_Call_Timeout

BeginProc ABIOSDSK_Cancel_Timeout
        pushfd
        push    esi
        cli
        inc     [ABIOS_Timeout_Generation]
        xor     esi, esi
        xchg    esi, [ABIOS_Timeout_Handle]
        test    esi, esi
        jz      SHORT ACT_None
        VMMcall Cancel_Time_Out
ACT_None:
        pop     esi
        popfd
        ret
EndProc ABIOSDSK_Cancel_Timeout

; EAX=milliseconds, EDX=kind (1 interrupt timeout, 2 delay).
BeginProc ABIOSDSK_Arm_Timeout
        push    esi
        push    edx
        call    ABIOSDSK_Cancel_Timeout
        pop     edx
        test    eax, eax
        jnz     SHORT AAT_Nonzero
        mov     eax, 1
AAT_Nonzero:
        mov     [ABIOS_Timeout_Kind], edx
        inc     [ABIOS_Timeout_Generation]
        mov     edx, [ABIOS_Timeout_Generation]
        mov     esi, OFFSET32 ABIOSDSK_Timeout_Callback
        VMMcall Set_Global_Time_Out
        mov     [ABIOS_Timeout_Handle], esi
        pop     esi
        ret
EndProc ABIOSDSK_Arm_Timeout

BeginProc ABIOSDSK_Arm_For_Return_Code
        movzx   eax, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        test    eax, ABRC_STAGE_ON_INTERRUPT
        jz      SHORT AFRC_Time
        movzx   eax, WORD PTR [ABIOS_Request+ABIOS_RB_TIMEOUT]
        shr     eax, 3
        imul    eax, 1000
        test    eax, eax
        jnz     SHORT AFRC_Int_Have_Time
        mov     eax, 10000
AFRC_Int_Have_Time:
        mov     edx, 1
        call    ABIOSDSK_Arm_Timeout
        ret
AFRC_Time:
        cmp     eax, ABRC_STAGE_ON_TIME
        jne     SHORT AFRC_Exit
        mov     eax, DWORD PTR [ABIOS_Request+ABIOS_RW_WAIT_TIME]
        ; ABIOS reports this field in milliseconds, matching the VMM timer.
        mov     edx, 2
        call    ABIOSDSK_Arm_Timeout
AFRC_Exit:
        ret
EndProc ABIOSDSK_Arm_For_Return_Code

; Copy ECX sectors beginning EDX sectors into the command to the bounce buffer.
BeginProc ABIOSDSK_Copy_To_Bounce
        pushad
        mov     ebp, ecx
        mov     esi, [ABIOS_Current_Command]
        TestMem [esi.BD_CB_Flags], BDCF_Scatter_Gather
        jnz     SHORT ACTB_Scatter
        shl     edx, 9
        mov     esi, [esi.BD_CB_Buffer_Ptr]
        add     esi, edx
        mov     edi, [ABIOS_Bounce_Linear]
        mov     ecx, ebp
        shl     ecx, 7
        cld
        rep movsd
        popad
        clc
        ret
ACTB_Scatter:
        mov     esi, [esi.BD_CB_Buffer_Ptr]
        mov     edi, [ABIOS_Bounce_Linear]
ACTB_Find_Region:
        mov     eax, [esi]
        test    eax, eax
        jz      SHORT ACTB_Fail
        cmp     edx, eax
        jb      SHORT ACTB_Copy_Region
        sub     edx, eax
        add     esi, 8
        jmp     SHORT ACTB_Find_Region
ACTB_Copy_Region:
        sub     eax, edx
        cmp     eax, ebp
        jbe     SHORT ACTB_Count_OK
        mov     eax, ebp
ACTB_Count_OK:
        mov     ebx, [esi+4]
        mov     ecx, edx
        shl     ecx, 9
        add     ebx, ecx
        mov     ecx, eax
        shl     ecx, 7
        xchg    esi, ebx
        cld
        rep movsd
        xchg    esi, ebx
        sub     ebp, eax
        jz      SHORT ACTB_Done
        xor     edx, edx
        add     esi, 8
        jmp     SHORT ACTB_Find_Region
ACTB_Done:
        popad
        clc
        ret
ACTB_Fail:
        popad
        stc
        ret
EndProc ABIOSDSK_Copy_To_Bounce

; Copy ECX sectors from the bounce buffer to the command at EDX sectors.
BeginProc ABIOSDSK_Copy_From_Bounce
        pushad
        mov     ebp, ecx
        mov     edi, [ABIOS_Current_Command]
        TestMem [edi.BD_CB_Flags], BDCF_Scatter_Gather
        jnz     SHORT ACFB_Scatter
        shl     edx, 9
        mov     edi, [edi.BD_CB_Buffer_Ptr]
        add     edi, edx
        mov     esi, [ABIOS_Bounce_Linear]
        mov     ecx, ebp
        shl     ecx, 7
        cld
        rep movsd
        popad
        clc
        ret
ACFB_Scatter:
        mov     edi, [edi.BD_CB_Buffer_Ptr]
        mov     esi, [ABIOS_Bounce_Linear]
ACFB_Find_Region:
        mov     eax, [edi]
        test    eax, eax
        jz      SHORT ACFB_Fail
        cmp     edx, eax
        jb      SHORT ACFB_Copy_Region
        sub     edx, eax
        add     edi, 8
        jmp     SHORT ACFB_Find_Region
ACFB_Copy_Region:
        sub     eax, edx
        cmp     eax, ebp
        jbe     SHORT ACFB_Count_OK
        mov     eax, ebp
ACFB_Count_OK:
        mov     ebx, [edi+4]
        mov     ecx, edx
        shl     ecx, 9
        add     ebx, ecx
        xchg    edi, ebx
        mov     ecx, eax
        shl     ecx, 7
        cld
        rep movsd
        xchg    edi, ebx
        sub     ebp, eax
        jz      SHORT ACFB_Done
        xor     edx, edx
        add     edi, 8
        jmp     SHORT ACFB_Find_Region
ACFB_Done:
        popad
        clc
        ret
ACFB_Fail:
        popad
        stc
        ret
EndProc ABIOSDSK_Copy_From_Bounce

BeginProc ABIOSDSK_Prepare_Request
        pushad
        mov     edi, OFFSET32 ABIOS_Request
        xor     eax, eax
        mov     ecx, ABIOS_MAX_REQUEST/4
        cld
        rep stosd
        mov     edi, OFFSET32 ABIOS_Request
        mov     esi, [ABIOS_Current_BDD]
        mov     ax, [esi.ABP_Request_Length]
        mov     WORD PTR [edi+ABIOS_RB_LENGTH], ax
        mov     ax, [esi.ABP_LID]
        mov     [edi+ABIOS_RB_LID], ax
        mov     ax, [esi.ABP_Unit]
        mov     [edi+ABIOS_RB_UNIT], ax
        mov     ebx, [ABIOS_Current_Command]
        mov     ax, ABFC_DISK_READ
        cmp     WORD PTR [ebx.BD_CB_Command], BDC_Read
        je      SHORT APR_Function_Ready
        mov     ax, ABFC_DISK_WRITE
        cmp     WORD PTR [ebx.BD_CB_Command], BDC_Write
        je      SHORT APR_Function_Ready
        mov     ax, ABFC_DISK_VERIFY
APR_Function_Ready:
        mov     [edi+ABIOS_RB_FUNCTION], ax
        mov     WORD PTR [edi+ABIOS_RB_RC], ABRC_INVALID
        mov     eax, DWORD PTR [ebx.BD_CB_Sector]
        add     eax, [ABIOS_Current_Completed]
        mov     [edi+ABIOS_RW_RBA], eax
        mov     eax, [ABIOS_Current_Chunk]
        mov     [edi+ABIOS_RW_BLOCK_COUNT], ax
        TestMem [ebx.BD_CB_Flags], BDCF_Dont_Cache
        jz      SHORT APR_Cache_OK
        mov     BYTE PTR [edi+ABIOS_RW_FLAGS], 1
APR_Cache_OK:
        TestMem [esi.ABP_LID_Flags], ABIOS_LF_LOGICAL_POINTER
        jz      SHORT APR_No_Logical
        movzx   eax, [ABIOS_Bounce_Selector]
        shl     eax, 16
        mov     [edi+ABIOS_RW_LOGICAL_BUFFER], eax
APR_No_Logical:
        TestMem [esi.ABP_LID_Flags], ABIOS_LF_PHYSICAL_POINTER
        jz      SHORT APR_No_Physical
        mov     eax, [ABIOS_Bounce_Physical]
        mov     [edi+ABIOS_RW_PHYSICAL_BUFFER], eax
APR_No_Physical:
        popad
        ret
EndProc ABIOSDSK_Prepare_Request

BeginProc ABIOSDSK_Start_Chunk
ASC_Next_Chunk:
        mov     esi, [ABIOS_Current_Command]
        mov     edi, [ABIOS_Current_BDD]
        mov     eax, [esi.BD_CB_Count]
        sub     eax, [ABIOS_Current_Completed]
        jz      ASC_All_Done
        movzx   ecx, [edi.ABP_Max_Transfer]
        cmp     eax, ecx
        jbe     SHORT ASC_Size_OK
        mov     eax, ecx
ASC_Size_OK:
        cmp     eax, ABIOS_BOUNCE_SECTORS
        jbe     SHORT ASC_Bounce_OK
        mov     eax, ABIOS_BOUNCE_SECTORS
ASC_Bounce_OK:
        mov     [ABIOS_Current_Chunk], eax
        cmp     [esi.BD_CB_Command], BDC_Write
        jne     SHORT ASC_Prepare
        mov     ecx, eax
        mov     edx, [ABIOS_Current_Completed]
        call    ABIOSDSK_Copy_To_Bounce
        jc      ASC_Buffer_Error
ASC_Prepare:
        call    ABIOSDSK_Prepare_Request
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_IO_Call
        call    ABIOSDSK_Debug_Line
ENDIF
        call    ABIOSDSK_Call_Start
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_IO_Start_RC
        mov     edi, OFFSET32 ABIOS_Debug_IO_Start_RC_Value
        call    ABIOSDSK_Debug_Return_Code
ENDIF
        pushad
        mov     eax, 2
        movzx   ebx, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        mov     ecx, [ABIOS_Request+ABIOS_RW_WAIT_TIME]
        movzx   edx, WORD PTR [ABIOS_Request+ABIOS_RB_TIMEOUT]
        call    ABIOSDSK_Trace
        popad
        movzx   eax, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        cmp     eax, ABRC_COMPLETE
        je      SHORT ASC_Stage_Complete
        cmp     eax, ABRC_STAGE_ON_INTERRUPT
        je      SHORT ASC_Staged
        cmp     eax, ABRC_STAGE_ON_TIME
        je      SHORT ASC_Staged
        jmp     ABIOSDSK_Request_Error
ASC_Staged:
        call    ABIOSDSK_Arm_For_Return_Code
        ret
ASC_Stage_Complete:
        cmp     [esi.BD_CB_Command], BDC_Read
        jne     SHORT ASC_Advance
        mov     ecx, [ABIOS_Current_Chunk]
        mov     edx, [ABIOS_Current_Completed]
        call    ABIOSDSK_Copy_From_Bounce
        jc      SHORT ASC_Buffer_Error
ASC_Advance:
        mov     eax, [ABIOS_Current_Chunk]
        add     [ABIOS_Current_Completed], eax
        jmp     ASC_Next_Chunk
ASC_All_Done:
        mov     eax, BDS_Success
        cmp     [ABIOS_Current_Retries], 0
        je      SHORT ASC_Check_Soft
        mov     eax, BDS_Success_With_Retries
ASC_Check_Soft:
        cmp     WORD PTR [ABIOS_Request+ABIOS_RW_SOFT_ERROR], 0
        je      SHORT ASC_Finish
        mov     eax, BDS_Success_With_ECC
ASC_Finish:
        call    ABIOSDSK_Finish_Current
        ret
ASC_Buffer_Error:
        mov     eax, BDS_Device_Error
        call    ABIOSDSK_Finish_Current
        ret
EndProc ABIOSDSK_Start_Chunk

BeginProc ABIOSDSK_Request_Error
        movzx   eax, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        test    eax, ABRC_RETRYABLE
        jz      SHORT ARE_Fail
        mov     ecx, [ABIOS_Current_Retries]
        mov     edi, [ABIOS_Current_BDD]
        movzx   edx, [edi.ABP_Retry_Count]
        cmp     ecx, edx
        jae     SHORT ARE_Fail
        inc     [ABIOS_Current_Retries]
        call    ABIOSDSK_Prepare_Request
        call    ABIOSDSK_Call_Start
        call    ABIOSDSK_Handle_Resumed
        ret
ARE_Fail:
        mov     eax, BDS_Media_Error
        call    ABIOSDSK_Finish_Current
        ret
EndProc ABIOSDSK_Request_Error

BeginProc ABIOSDSK_Queue_Command
        xor     ecx, ecx
AQC_Find:
        cmp     ecx, ABIOS_MAX_DRIVES
        jae     SHORT AQC_Fail
        cmp     [ABIOS_Pending_Commands+ecx*4], 0
        je      SHORT AQC_Store
        inc     ecx
        jmp     SHORT AQC_Find
AQC_Store:
        mov     [ABIOS_Pending_Commands+ecx*4], esi
        mov     [ABIOS_Pending_BDDs+ecx*4], edi
        ret
AQC_Fail:
        mov     [esi.BD_CB_Cmd_Status], BDS_Device_Error
        VxDcall BlockDev_Command_Complete
        ret
EndProc ABIOSDSK_Queue_Command

BeginProc ABIOSDSK_Start_Command
        mov     [ABIOS_Current_Command], esi
        mov     [ABIOS_Current_BDD], edi
        mov     [ABIOS_Current_Completed], 0
        mov     [ABIOS_Current_Retries], 0
        call    ABIOSDSK_Start_Chunk
        ret
EndProc ABIOSDSK_Start_Command

BeginProc ABIOSDSK_Start_Next
        xor     ecx, ecx
ASN_Find:
        cmp     ecx, ABIOS_MAX_DRIVES
        jae     SHORT ASN_None
        mov     esi, [ABIOS_Pending_Commands+ecx*4]
        test    esi, esi
        jnz     SHORT ASN_Found
        inc     ecx
        jmp     SHORT ASN_Find
ASN_Found:
        mov     edi, [ABIOS_Pending_BDDs+ecx*4]
        mov     [ABIOS_Pending_Commands+ecx*4], 0
        mov     [ABIOS_Pending_BDDs+ecx*4], 0
        call    ABIOSDSK_Start_Command
ASN_None:
        ret
EndProc ABIOSDSK_Start_Next

; EAX is the BlockDev completion status.
BeginProc ABIOSDSK_Finish_Current
        pushad
        mov     ebx, eax
        mov     eax, 4
        mov     ecx, [ABIOS_Current_Completed]
        mov     edx, [ABIOS_Current_Chunk]
        call    ABIOSDSK_Trace
        popad
IFDEF ABIOSDSK_DEBUG
        call    ABIOSDSK_Debug_Status
ENDIF
        push    eax
        call    ABIOSDSK_Cancel_Timeout
        pop     eax
        mov     esi, [ABIOS_Current_Command]
        test    esi, esi
        jz      SHORT AFC_Exit
        cmp     esi, -1
        je      SHORT AFC_Exit
        pushfd
        cli
        mov     [esi.BD_CB_Cmd_Status], ax
        mov     [ABIOS_Current_Command], -1
        VxDcall BlockDev_Command_Complete
        cli
        mov     [ABIOS_Current_Command], 0
        mov     [ABIOS_Current_BDD], 0
        call    ABIOSDSK_Start_Next
        popfd
AFC_Exit:
        ret
EndProc ABIOSDSK_Finish_Current

BeginProc ABIOSDSK_Command
        pushfd
        cld
        pushad
IFDEF ABIOSDSK_DEBUG
        call    ABIOSDSK_Debug_Command
ENDIF
        pushad
        mov     ebx, DWORD PTR [esi.BD_CB_Sector]
        mov     ecx, DWORD PTR [esi.BD_CB_Count]
        movzx   edx, WORD PTR [esi.BD_CB_Flags]
        movzx   eax, WORD PTR [esi.BD_CB_Command]
        shl     eax, 16
        or      edx, eax
        mov     eax, 1
        call    ABIOSDSK_Trace
        popad
        cmp     [esi.BD_CB_Command], BDC_Write
        ja      SHORT ACMD_Invalid
        cmp     [ABIOS_Current_Command], 0
        jne     SHORT ACMD_Queue
        call    ABIOSDSK_Start_Command
        jmp     SHORT ACMD_Exit
ACMD_Queue:
        call    ABIOSDSK_Queue_Command
        jmp     SHORT ACMD_Exit
ACMD_Invalid:
        mov     [esi.BD_CB_Cmd_Status], BDS_Invalid_Command
        VxDcall BlockDev_Command_Complete
ACMD_Exit:
        popad
        popfd
        sti
        ret
EndProc ABIOSDSK_Command

BeginProc ABIOSDSK_Handle_Resumed
        movzx   eax, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        pushad
        mov     eax, 3
        movzx   ebx, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        mov     ecx, [ABIOS_Current_Completed]
        mov     edx, [ABIOS_Request+ABIOS_RW_RBA]
        call    ABIOSDSK_Trace
        popad
        cmp     eax, ABRC_COMPLETE
        je      SHORT AHR_Complete
        cmp     eax, ABRC_STAGE_ON_INTERRUPT
        je      SHORT AHR_Staged
        cmp     eax, ABRC_STAGE_ON_TIME
        je      SHORT AHR_Staged
        jmp     ABIOSDSK_Request_Error
AHR_Staged:
        call    ABIOSDSK_Arm_For_Return_Code
        ret
AHR_Complete:
        mov     esi, [ABIOS_Current_Command]
        cmp     [esi.BD_CB_Command], BDC_Read
        jne     SHORT AHR_Advance
        pushad
        mov     esi, [ABIOS_Bounce_Linear]
        mov     ecx, [ABIOS_Current_Chunk]
        shl     ecx, 7
        xor     ebp, ebp
AHR_Trace_Checksum:
        xor     ebp, [esi]
        add     esi, 4
        loop    AHR_Trace_Checksum
        mov     eax, 9
        mov     ebx, [ABIOS_Request+ABIOS_RW_RBA]
        mov     ecx, ebp
        mov     edi, [ABIOS_Current_BDD]
        movzx   edx, [edi.ABP_Unit]
        call    ABIOSDSK_Trace
        popad
        mov     ecx, [ABIOS_Current_Chunk]
        mov     edx, [ABIOS_Current_Completed]
        call    ABIOSDSK_Copy_From_Bounce
        jc      SHORT AHR_Copy_Fail
IFDEF ABIOSDSK_DEBUG
        call    ABIOSDSK_Debug_Read_Data
ENDIF
AHR_Advance:
        mov     eax, [ABIOS_Current_Chunk]
        add     [ABIOS_Current_Completed], eax
        call    ABIOSDSK_Start_Chunk
        ret
AHR_Copy_Fail:
        mov     eax, BDS_Device_Error
        call    ABIOSDSK_Finish_Current
        ret
EndProc ABIOSDSK_Handle_Resumed

BeginProc ABIOSDSK_Hw_Int
        cmp     [ABIOS_Current_Command], 0
        je      AHI_Not_Mine
        cmp     [ABIOS_Current_Command], -1
        je      AHI_Not_Mine
        cmp     edi, [ABIOS_Current_BDD]
        jne     AHI_Not_Mine
        test    WORD PTR [ABIOS_Request+ABIOS_RB_RC], ABRC_STAGE_ON_INTERRUPT
        jz      AHI_Not_Mine
        pushfd
        cld
        pushad
        pushad
        mov     eax, 5
        movzx   ebx, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        mov     ecx, [ABIOS_Current_Completed]
        mov     edx, [ABIOS_Request+ABIOS_RW_RBA]
        call    ABIOSDSK_Trace
        popad
        mov     ebp, eax
        call    ABIOSDSK_Cancel_Timeout
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_IO_Interrupt
        call    ABIOSDSK_Debug_Line
ENDIF
        call    ABIOSDSK_Call_Interrupt
        pushad
        mov     eax, 6
        movzx   ebx, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        mov     ecx, [ABIOS_Request+ABIOS_RW_WAIT_TIME]
        movzx   edx, WORD PTR [ABIOS_Request+ABIOS_RB_TIMEOUT]
        call    ABIOSDSK_Trace
        popad
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_IO_Interrupt_RC
        mov     edi, OFFSET32 ABIOS_Debug_IO_Interrupt_RC_Value
        call    ABIOSDSK_Debug_Return_Code
ENDIF
        movzx   eax, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        cmp     eax, ABRC_NOT_MY_INTERRUPT
        je      SHORT AHI_Pop_Not_Mine
        cmp     eax, ABRC_SPURIOUS_INTERRUPT
        je      SHORT AHI_Pop_Not_Mine
        mov     eax, ebp
        VxDcall VPICD_Phys_EOI
        call    ABIOSDSK_Handle_Resumed
        popad
        popfd
        clc
        ret
AHI_Pop_Not_Mine:
        call    ABIOSDSK_Arm_For_Return_Code
        popad
        popfd
        stc
        ret
AHI_Not_Mine:
        stc
        ret
EndProc ABIOSDSK_Hw_Int

BeginProc ABIOSDSK_Timeout_Callback
        pushfd
        cli
        cld
        cmp     edx, [ABIOS_Timeout_Generation]
        jne     SHORT ATC_Exit
        mov     [ABIOS_Timeout_Handle], 0
        cmp     [ABIOS_Current_Command], 0
        je      SHORT ATC_Exit
        cmp     [ABIOS_Current_Command], -1
        je      SHORT ATC_Exit
        pushad
        pushad
        mov     eax, 7
        mov     ebx, [ABIOS_Timeout_Kind]
        movzx   ecx, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        mov     edx, [ABIOS_Timeout_Generation]
        call    ABIOSDSK_Trace
        popad
IFDEF ABIOSDSK_DEBUG
        mov     esi, OFFSET32 ABIOS_Debug_IO_Timeout
        call    ABIOSDSK_Debug_Line
ENDIF
        cmp     [ABIOS_Timeout_Kind], 2
        je      SHORT ATC_Delay
        call    ABIOSDSK_Call_Timeout
        jmp     SHORT ATC_Resume
ATC_Delay:
        call    ABIOSDSK_Call_Delay
        pushad
        mov     eax, 8
        movzx   ebx, WORD PTR [ABIOS_Request+ABIOS_RB_RC]
        mov     ecx, [ABIOS_Request+ABIOS_RW_WAIT_TIME]
        movzx   edx, WORD PTR [ABIOS_Request+ABIOS_RB_TIMEOUT]
        call    ABIOSDSK_Trace
        popad
ATC_Resume:
        call    ABIOSDSK_Handle_Resumed
        popad
ATC_Exit:
        popfd
        ret
EndProc ABIOSDSK_Timeout_Callback

VxD_LOCKED_CODE_ENDS

END
