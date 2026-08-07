PAGE 58,132
TITLE ABIOSRM.ASM -- Real-mode initialization and validation for ABIOSDSK

.386p

.XLIST
IFDEF ABIOS_DIAGNOSTIC
BeginProc MACRO Name
Name PROC NEAR
ENDM
EndProc MACRO Name
Name ENDP
ENDM
OPTION OLDSTRUCTS
ELSE
INCLUDE VMM.Inc
ENDIF
INCLUDE ABIOS.Inc
.LIST

IFDEF ABIOS_DIAGNOSTIC
RM_DIAGNOSTIC_SEG SEGMENT PARA PUBLIC USE16 'CODE'
ASSUME CS:RM_DIAGNOSTIC_SEG, DS:RM_DIAGNOSTIC_SEG, ES:NOTHING, SS:NOTHING
ORG 100h
        jmp     RM_Diagnostic_Entry
ELSE
VxD_REAL_INIT_SEG
ENDIF

RM_Service_Address       dd 0
RM_RAM_Extension         dw 0
RM_Allocation_Segment    dw 0
RM_Allocation_Paras      dw 0
RM_CDA_Size              dw 0
RM_Current_FTT           dw 0
RM_Total_LIDs            dw 0
RM_Next_Offset           dw 0
RM_Metadata_Offset       dw 0
RM_Request_Offset        dw 0
RM_Disk_Count            dw 0
RM_Next_Int13            db 80h
RM_IRQ_Seen              db 0
RM_Old_IRQ_Mask          db 0
RM_Old_IRQ_Vector        dd 0
RM_Current_LID_Flags     dw 0
RM_Current_RB_Length     dw 0
RM_Current_LID           dw 0
RM_Current_Unit          dw 0
RM_BIOS_SPT              dw 0
RM_BIOS_Heads            dw 0
RM_BIOS_Cylinders        dw 0
RM_Test_Count            db 0
                        db 0
RM_Test_LBA              dd 0
RM_Test_Limit            dd 0

RM_System_Parameters     db ABIOS_SYSTEM_SIZE dup (0)
RM_Initialization_Table db (ABIOS_MAX_INIT_ENTRIES*ABIOS_INIT_ENTRY_SIZE) dup (0)
RM_Int13_Buffer          db 512 dup (0)
RM_ABIOS_Buffer          db 512 dup (0)
RM_RDP_Save             db ABIOS_RDP_SIZE dup (0)

RM_Message_No_ABIOS      db 'ABIOSDSK: ABIOS is unavailable or could not be initialized.',13,10,'$'
RM_Message_No_Disk       db 'ABIOSDSK: no non-SCSI ABIOS fixed disk passed INT 13h validation.',13,10,'$'
RM_Message_Too_Large     db 'ABIOSDSK: ABIOS tables exceed the driver limits.',13,10,'$'
RM_Profile_Enable        db '32BITDISKACCESS',0
RM_Message_Passed        db 'ABIOSCHK: ABIOS fixed disk passed INT 13h comparison reads.',13,10,'$'

IFNDEF ABIOS_DIAGNOSTIC
RM_Build_Entry LABEL NEAR
BeginProc ABIOSDSK_Real_Mode_Init
        cmp     ax, 30Ah
        jb      RMRI_Abort_Silent
        mov     DWORD PTR cs:[RM_Service_Address], ecx

        mov     ax, 3
        xor     ecx, ecx
        xor     si, si
        mov     di, OFFSET RM_Profile_Enable
        call    DWORD PTR cs:[RM_Service_Address]
        or      cx, cx
        jz      RMRI_Abort_Silent

        call    RM_Build_BIOS_Tables
        jc      RMRI_No_ABIOS
        call    RM_Allocate_ABIOS_Data
        jc      RMRI_Too_Large
        call    RM_Initialize_ABIOS
        jc      RMRI_No_ABIOS_Free
        call    RM_Find_And_Validate_Disks
        jc      RMRI_No_Disk_Free

        mov     ax, cs:[RM_Allocation_Segment]
        movzx   edx, cs:[RM_Metadata_Offset]
        shl     eax, 16
        or      edx, eax
        xor     bx, bx
        xor     si, si
        mov     ax, Device_Load_Ok
        push    cs
        pop     ds
        ret

RMRI_No_ABIOS_Free:
        mov     dx, OFFSET RM_Message_No_ABIOS
        jmp     SHORT RMRI_Free_Print
RMRI_No_Disk_Free:
        mov     dx, OFFSET RM_Message_No_Disk
RMRI_Free_Print:
        push    dx
        mov     ax, cs:[RM_Allocation_Segment]
        mov     es, ax
        mov     ah, 49h
        int     21h
        pop     dx
        jmp     SHORT RMRI_Print_Abort
RMRI_No_ABIOS:
        mov     dx, OFFSET RM_Message_No_ABIOS
        jmp     SHORT RMRI_Print_Abort
RMRI_Too_Large:
        mov     dx, OFFSET RM_Message_Too_Large
RMRI_Print_Abort:
        push    cs
        pop     ds
        mov     ah, 9
        int     21h
RMRI_Abort_Silent:
        xor     bx, bx
        xor     si, si
        mov     ax, Abort_Device_Load + No_Fail_Message
        ret
EndProc ABIOSDSK_Real_Mode_Init
ENDIF

; Build the BIOS system-parameters and initialization tables. A one-paragraph
; zero-length RAM-extension record is supplied because INT 15h requires DS:0.
BeginProc RM_Build_BIOS_Tables
        pushad
        push    ds
        push    es
        mov     bx, 1
        mov     ah, 48h
        int     21h
        jc      SHORT RBBT_Fail
        mov     cs:[RM_RAM_Extension], ax
        mov     ds, ax
        mov     WORD PTR ds:[0], 0
        push    cs
        pop     es
        mov     di, OFFSET RM_System_Parameters
        mov     ax, 0400h
        int     15h
        jc      SHORT RBBT_Free_Fail
        or      ah, ah
        jnz     SHORT RBBT_Free_Fail
        mov     ax, WORD PTR es:[RM_System_Parameters+ABIOS_SYSTEM_ENTRY_COUNT]
        test    ax, ax
        jz      SHORT RBBT_Free_Fail
        cmp     ax, ABIOS_MAX_INIT_ENTRIES
        ja      SHORT RBBT_Free_Fail
        mov     di, OFFSET RM_Initialization_Table
        mov     ax, 0500h
        int     15h
        jc      SHORT RBBT_Free_Fail
        or      ah, ah
        jnz     SHORT RBBT_Free_Fail
        clc
        jmp     SHORT RBBT_Free
RBBT_Free_Fail:
        stc
RBBT_Free:
        pushf
        mov     ax, cs:[RM_RAM_Extension]
        mov     es, ax
        mov     ah, 49h
        int     21h
        popf
        jmp     SHORT RBBT_Exit
RBBT_Fail:
        stc
RBBT_Exit:
        pop     es
        pop     ds
        popad
        ret
EndProc RM_Build_BIOS_Tables

; Compute a compact CDA/DB/FTT layout and allocate it below 1MB with DOS.
BeginProc RM_Allocate_ABIOS_Data
        pushad
        mov     cx, WORD PTR cs:[RM_System_Parameters+ABIOS_SYSTEM_ENTRY_COUNT]
        mov     si, OFFSET RM_Initialization_Table
        mov     ebx, 1                  ; logical ID 1 remains null
        xor     edx, edx                ; total data-pointer bytes
RAAD_Count:
        movzx   eax, WORD PTR cs:[si+ABIOS_INIT_LID_COUNT]
        add     ebx, eax
        movzx   eax, WORD PTR cs:[si+ABIOS_INIT_DATA_LENGTH]
        add     edx, eax
        add     si, ABIOS_INIT_ENTRY_SIZE
        loop    RAAD_Count
        cmp     ebx, ABIOS_MAX_LIDS
        ja      RAAD_Fail
        mov     cs:[RM_Total_LIDs], bx
        mov     eax, ebx
        shl     eax, 3
        add     eax, 10                 ; header plus data-pointer count
        add     eax, edx
        cmp     eax, ABIOS_MAX_CDA
        ja      RAAD_Fail
        mov     cs:[RM_CDA_Size], ax
        add     eax, 3
        and     eax, NOT 3
        mov     edi, eax

        mov     cx, WORD PTR cs:[RM_System_Parameters+ABIOS_SYSTEM_ENTRY_COUNT]
        mov     si, OFFSET RM_Initialization_Table
RAAD_Sizes:
        movzx   eax, WORD PTR cs:[si+ABIOS_INIT_FTT_LENGTH]
        add     eax, 3
        and     eax, NOT 3
        add     edi, eax
        movzx   eax, WORD PTR cs:[si+ABIOS_INIT_DEVICE_BLOCK_LENGTH]
        movzx   ebx, WORD PTR cs:[si+ABIOS_INIT_LID_COUNT]
        imul    eax, ebx
        add     eax, 3
        and     eax, NOT 3
        add     edi, eax
        add     si, ABIOS_INIT_ENTRY_SIZE
        loop    RAAD_Sizes
        mov     eax, edi
        add     eax, 3
        and     eax, NOT 3
        mov     cs:[RM_Metadata_Offset], ax
        add     eax, ABIOS_META_SIZE
        add     eax, 3
        and     eax, NOT 3
        mov     cs:[RM_Request_Offset], ax
        add     eax, ABIOS_MAX_REQUEST
        cmp     eax, 0FFF0h
        ja      RAAD_Fail
        add     eax, 15
        shr     eax, 4
        mov     cs:[RM_Allocation_Paras], ax
        mov     bx, ax
        mov     ah, 48h
        int     21h
        jc      RAAD_Fail
        mov     cs:[RM_Allocation_Segment], ax
        mov     es, ax
        xor     di, di
        xor     eax, eax
        movzx   ecx, cs:[RM_Allocation_Paras]
        shl     ecx, 2
        cld
        rep stosd
        popad
        clc
        ret
RAAD_Fail:
        popad
        stc
        ret
EndProc RM_Allocate_ABIOS_Data

; Populate CDA pointers and invoke every initialization-table entry in order.
BeginProc RM_Initialize_ABIOS
        pushad
        push    ds
        push    es
        mov     ax, cs:[RM_Allocation_Segment]
        mov     es, ax
        mov     ax, cs:[RM_CDA_Size]
        sub     ax, 8
        mov     es:[ABIOS_CDA_DATA0_OFFSET], ax
        mov     ax, cs:[RM_Total_LIDs]
        mov     es:[ABIOS_CDA_LID_COUNT], ax
        mov     bx, cs:[RM_CDA_Size]
        add     bx, 3
        and     bx, NOT 3
        mov     cs:[RM_Next_Offset], bx
        mov     dx, 2
        mov     bp, WORD PTR cs:[RM_System_Parameters+ABIOS_SYSTEM_ENTRY_COUNT]
        mov     si, OFFSET RM_Initialization_Table
RIA_Entry:
        test    bp, bp
        jz      RIA_Translate_Data
        mov     cx, cs:[si+ABIOS_INIT_LID_COUNT]
        mov     di, cs:[RM_Next_Offset]
        mov     cs:[RM_Current_FTT], di
        mov     ax, cs:[si+ABIOS_INIT_FTT_LENGTH]
        test    ax, ax
        jz      SHORT RIA_No_FTT_Advance
        add     ax, 3
        and     ax, NOT 3
        add     cs:[RM_Next_Offset], ax
RIA_No_FTT_Advance:
        xor     ebx, ebx
        mov     bx, dx
RIA_LID_Pointers:
        cmp     bx, dx
        jb      SHORT RIA_Call_Initializer
        mov     ax, bx
        sub     ax, dx
        cmp     ax, cx
        jae     SHORT RIA_Call_Initializer
        push    bx
        shl     bx, 3
        mov     eax, 0
        cmp     WORD PTR cs:[si+ABIOS_INIT_DEVICE_BLOCK_LENGTH], 0
        je      SHORT RIA_DB_Null
        mov     ax, cs:[RM_Next_Offset]
        movzx   edi, cs:[RM_Allocation_Segment]
        shl     edi, 16
        or      eax, edi
RIA_DB_Null:
        mov     es:[bx+ABIOS_CDA_DEVICE_BLOCK], eax
        mov     eax, 0
        cmp     WORD PTR cs:[si+ABIOS_INIT_FTT_LENGTH], 0
        je      SHORT RIA_FTT_Null
        mov     ax, cs:[RM_Current_FTT]
        movzx   edi, cs:[RM_Allocation_Segment]
        shl     edi, 16
        or      eax, edi
RIA_FTT_Null:
        mov     es:[bx+ABIOS_CDA_FUNCTION_TABLE], eax
        movzx   eax, WORD PTR cs:[si+ABIOS_INIT_DEVICE_BLOCK_LENGTH]
        add     eax, 3
        and     eax, NOT 3
        add     cs:[RM_Next_Offset], ax
        pop     bx
        inc     bx
        jmp     SHORT RIA_LID_Pointers
RIA_Call_Initializer:
        mov     ax, cs:[RM_Allocation_Segment]
        mov     ds, ax
        call    DWORD PTR cs:[si+ABIOS_INIT_ROUTINE]
        push    cs
        pop     ds
        or      al, al
        jz      SHORT RIA_Initialized
        mov     bx, dx
        mov     ax, cx
RIA_Null_Failed:
        test    ax, ax
        jz      SHORT RIA_Initialized
        push    bx
        shl     bx, 3
        mov     DWORD PTR es:[bx+ABIOS_CDA_DEVICE_BLOCK], 0
        mov     DWORD PTR es:[bx+ABIOS_CDA_FUNCTION_TABLE], 0
        pop     bx
        inc     bx
        dec     ax
        jmp     SHORT RIA_Null_Failed
RIA_Initialized:
        add     dx, cx
        add     si, ABIOS_INIT_ENTRY_SIZE
        dec     bp
        jmp     RIA_Entry

RIA_Translate_Data:
        mov     bx, es:[ABIOS_CDA_DATA0_OFFSET]
        mov     cx, es:[bx+6]
RIA_Data_Loop:
        jcxz    SHORT RIA_Metadata
        mov     eax, es:[bx+2]
        cmp     eax, 0FFFFFh
        ja      SHORT RIA_Data_Above_1M
        mov     edx, eax
        and     dx, 0Fh
        shr     eax, 4
        mov     es:[bx+2], dx
        mov     es:[bx+4], ax
        jmp     SHORT RIA_Data_Next
RIA_Data_Above_1M:
        mov     DWORD PTR es:[bx+2], 0
RIA_Data_Next:
        sub     bx, 6
        loop    RIA_Data_Loop

RIA_Metadata:
        mov     di, cs:[RM_Metadata_Offset]
        mov     DWORD PTR es:[di.AM_Magic], ABIOS_META_MAGIC
        mov     WORD PTR es:[di.AM_Version], ABIOS_META_VERSION
        mov     ax, cs:[RM_Allocation_Paras]
        mov     es:[di.AM_Allocation_Paragraphs], ax
        mov     ax, cs:[RM_CDA_Size]
        mov     es:[di.AM_CDA_Size], ax
        mov     ax, cs:[RM_Total_LIDs]
        mov     es:[di.AM_LID_Count], ax
        mov     eax, DWORD PTR cs:[RM_System_Parameters+ABIOS_SYSTEM_START]
        mov     DWORD PTR es:[di.AM_Common_Start], eax
        mov     eax, DWORD PTR cs:[RM_System_Parameters+ABIOS_SYSTEM_INTERRUPT]
        mov     DWORD PTR es:[di.AM_Common_Interrupt], eax
        mov     eax, DWORD PTR cs:[RM_System_Parameters+ABIOS_SYSTEM_TIMEOUT]
        mov     DWORD PTR es:[di.AM_Common_Timeout], eax
        pop     es
        pop     ds
        popad
        clc
        ret
EndProc RM_Initialize_ABIOS

BeginProc RM_Clear_Request
        pushad
        push    es
        mov     ax, cs:[RM_Allocation_Segment]
        mov     es, ax
        mov     di, cs:[RM_Request_Offset]
        xor     eax, eax
        mov     cx, ABIOS_MAX_REQUEST/4
        cld
        rep stosd
        pop     es
        popad
        ret
EndProc RM_Clear_Request

; Call one of the common routines. AL=0 start, 1 interrupt, 2 timeout.
BeginProc RM_ABIOS_Call
        push    bx
        mov     bx, cs:[RM_Request_Offset]
        push    ds
        push    ds
        push    bx
        sub     sp, 8
        cmp     al, 1
        je      SHORT RAC_Interrupt
        cmp     al, 2
        je      SHORT RAC_Timeout
        call    DWORD PTR cs:[RM_System_Parameters+ABIOS_SYSTEM_START]
        jmp     SHORT RAC_Done
RAC_Interrupt:
        call    DWORD PTR cs:[RM_System_Parameters+ABIOS_SYSTEM_INTERRUPT]
        jmp     SHORT RAC_Done
RAC_Timeout:
        call    DWORD PTR cs:[RM_System_Parameters+ABIOS_SYSTEM_TIMEOUT]
RAC_Done:
        add     sp, 14
        pop     bx
        ret
EndProc RM_ABIOS_Call

BeginProc RM_Install_IRQ14
        pushad
        push    ds
        push    es
        mov     ax, 3576h
        int     21h
        mov     WORD PTR cs:[RM_Old_IRQ_Vector], bx
        mov     WORD PTR cs:[RM_Old_IRQ_Vector+2], es
        in      al, 0A1h
        mov     cs:[RM_Old_IRQ_Mask], al
        and     al, NOT 40h
        out     0A1h, al
        push    cs
        pop     ds
        mov     dx, OFFSET RM_IRQ14_Handler
        mov     ax, 2576h
        int     21h
        pop     es
        pop     ds
        popad
        ret
EndProc RM_Install_IRQ14

BeginProc RM_Remove_IRQ14
        pushad
        push    ds
        mov     al, cs:[RM_Old_IRQ_Mask]
        out     0A1h, al
        lds     dx, cs:[RM_Old_IRQ_Vector]
        mov     ax, 2576h
        int     21h
        pop     ds
        popad
        ret
EndProc RM_Remove_IRQ14

BeginProc RM_IRQ14_Handler
        push    ax
        mov     cs:[RM_IRQ_Seen], 1
        mov     al, 20h
        out     0A0h, al
        out     20h, al
        pop     ax
        iret
EndProc RM_IRQ14_Handler

; Execute a request synchronously during loader initialization.
; DS must be the CDA segment. Carry denotes any nonzero final return code.
BeginProc RM_Run_Request
        pushad
        push    es
        mov     cs:[RM_IRQ_Seen], 0
        call    RM_Install_IRQ14
        xor     al, al
        call    RM_ABIOS_Call
        mov     ax, 40h
        mov     es, ax
        mov     ebp, es:[6Ch]
RRR_Wait:
        mov     bx, cs:[RM_Request_Offset]
        mov     ax, ds:[bx+ABIOS_RB_RC]
        test    ax, ax
        jz      SHORT RRR_Success
        cmp     ax, ABRC_STAGE_ON_TIME
        je      SHORT RRR_Resume
        test    ax, 1
        jz      SHORT RRR_Fail
        sti
        hlt
        cli
        cmp     cs:[RM_IRQ_Seen], 0
        jne     SHORT RRR_Resume
        mov     eax, es:[6Ch]
        sub     eax, ebp
        cmp     eax, 18*10
        jb      SHORT RRR_Wait
        mov     al, 2
        call    RM_ABIOS_Call
        jmp     SHORT RRR_Final
RRR_Resume:
        mov     cs:[RM_IRQ_Seen], 0
        mov     al, 1
        call    RM_ABIOS_Call
        jmp     SHORT RRR_Wait
RRR_Success:
        clc
        jmp     SHORT RRR_Remove
RRR_Fail:
        stc
RRR_Final:
        mov     bx, cs:[RM_Request_Offset]
        cmp     WORD PTR ds:[bx+ABIOS_RB_RC], 0
        jne     SHORT RRR_Remove
        clc
RRR_Remove:
        pushf
        call    RM_Remove_IRQ14
        sti
        popf
        pop     es
        popad
        ret
EndProc RM_Run_Request

BeginProc RM_Prepare_Header
        call    RM_Clear_Request
        mov     ax, cs:[RM_Allocation_Segment]
        mov     ds, ax
        mov     bx, cs:[RM_Request_Offset]
        mov     ds:[bx+ABIOS_RB_LENGTH], cx
        mov     ax, cs:[RM_Current_LID]
        mov     ds:[bx+ABIOS_RB_LID], ax
        mov     ax, cs:[RM_Current_Unit]
        mov     ds:[bx+ABIOS_RB_UNIT], ax
        mov     ds:[bx+ABIOS_RB_FUNCTION], dx
        mov     WORD PTR ds:[bx+ABIOS_RB_RC], ABRC_INVALID
        ret
EndProc RM_Prepare_Header

BeginProc RM_Read_ABIOS_Sector
        pushad
        mov     cx, cs:[RM_Current_RB_Length]
        mov     dx, ABFC_DISK_READ
        call    RM_Prepare_Header
        mov     eax, cs:[RM_Test_LBA]
        mov     ds:[bx+ABIOS_RW_RBA], eax
        mov     WORD PTR ds:[bx+ABIOS_RW_BLOCK_COUNT], 1
        test    cs:[RM_Current_LID_Flags], ABIOS_LF_LOGICAL_POINTER
        jz      SHORT RRAS_No_Logical
        mov     WORD PTR ds:[bx+ABIOS_RW_LOGICAL_BUFFER], OFFSET RM_ABIOS_Buffer
        mov     WORD PTR ds:[bx+ABIOS_RW_LOGICAL_BUFFER+2], cs
RRAS_No_Logical:
        test    cs:[RM_Current_LID_Flags], ABIOS_LF_PHYSICAL_POINTER
        jz      SHORT RRAS_No_Physical
        xor     eax, eax
        mov     ax, cs
        shl     eax, 4
        add     eax, OFFSET RM_ABIOS_Buffer
        mov     ds:[bx+ABIOS_RW_PHYSICAL_BUFFER], eax
RRAS_No_Physical:
        call    RM_Run_Request
        pushf
        push    cs
        pop     ds
        popf
        popad
        ret
EndProc RM_Read_ABIOS_Sector

; Read RM_Test_LBA through INT 13h using the CBIOS-reported translation.
BeginProc RM_Read_INT13_Sector
        pushad
        push    es
        mov     eax, cs:[RM_Test_LBA]
        xor     edx, edx
        movzx   ecx, cs:[RM_BIOS_SPT]
        div     ecx
        inc     dl
        mov     cl, dl
        xor     edx, edx
        movzx   ebx, cs:[RM_BIOS_Heads]
        div     ebx
        cmp     eax, 1023
        ja      SHORT RRIS_Fail
        mov     dh, dl
        mov     ch, al
        mov     al, ah
        and     al, 3
        shl     al, 6
        or      cl, al
        mov     dl, cs:[RM_Next_Int13]
        push    cs
        pop     es
        mov     bx, OFFSET RM_Int13_Buffer
        mov     ax, 0201h
        int     13h
        jnc     SHORT RRIS_OK
        push    bx
        push    cx
        push    dx
        xor     ax, ax
        int     13h
        pop     dx
        pop     cx
        pop     bx
        mov     ax, 0201h
        int     13h
        jc      SHORT RRIS_Fail
RRIS_OK:
        pop     es
        popad
        clc
        ret
RRIS_Fail:
        pop     es
        popad
        stc
        ret
EndProc RM_Read_INT13_Sector

BeginProc RM_Compare_Sectors
        push    ds
        push    es
        push    si
        push    di
        push    cx
        push    cs
        pop     ds
        push    cs
        pop     es
        mov     si, OFFSET RM_Int13_Buffer
        mov     di, OFFSET RM_ABIOS_Buffer
        mov     cx, 512/2
        cld
        repe cmpsw
        pop     cx
        pop     di
        pop     si
        pop     es
        pop     ds
        ret
EndProc RM_Compare_Sectors

BeginProc RM_Get_BIOS_Geometry
        pushad
        push    es
        mov     dl, cs:[RM_Next_Int13]
        mov     ah, 08h
        int     13h
        jc      SHORT RGBG_Fail
        mov     al, cl
        and     ax, 003Fh
        test    ax, ax
        jz      SHORT RGBG_Fail
        mov     cs:[RM_BIOS_SPT], ax
        movzx   eax, dh
        inc     eax
        mov     cs:[RM_BIOS_Heads], ax
        movzx   eax, ch
        movzx   ebx, cl
        and     ebx, 0C0h
        shl     ebx, 2
        or      eax, ebx
        inc     eax
        mov     cs:[RM_BIOS_Cylinders], ax
        movzx   eax, cs:[RM_BIOS_SPT]
        movzx   ebx, cs:[RM_BIOS_Heads]
        imul    eax, ebx
        movzx   ebx, cs:[RM_BIOS_Cylinders]
        imul    eax, ebx
        mov     cs:[RM_Test_Limit], eax
        pop     es
        popad
        clc
        ret
RGBG_Fail:
        pop     es
        popad
        stc
        ret
EndProc RM_Get_BIOS_Geometry

; Compare LBA 0, a midpoint, and the last CBIOS-addressable sector.
BeginProc RM_Validate_Current_Unit
        pushad
        call    RM_Get_BIOS_Geometry
        jc      RVCU_Fail
        mov     eax, DWORD PTR cs:[RM_RDP_Save+ABIOS_RDP_RBA_COUNT]
        cmp     eax, cs:[RM_Test_Limit]
        jae     SHORT RVCU_Limit_OK
        mov     cs:[RM_Test_Limit], eax
RVCU_Limit_OK:
        cmp     cs:[RM_Test_Limit], 1
        jbe     SHORT RVCU_Fail_DS
        mov     cs:[RM_Test_Count], 0
        xor     eax, eax
        call    RM_Validate_One_LBA
        jc      SHORT RVCU_Fail_DS
        inc     cs:[RM_Test_Count]
        mov     eax, cs:[RM_Test_Limit]
        shr     eax, 1
        test    eax, eax
        jz      SHORT RVCU_Last
        call    RM_Validate_One_LBA
        jc      SHORT RVCU_Fail_DS
        inc     cs:[RM_Test_Count]
RVCU_Last:
        mov     eax, cs:[RM_Test_Limit]
        dec     eax
        call    RM_Validate_One_LBA
        jc      SHORT RVCU_Fail_DS
        inc     cs:[RM_Test_Count]
        push    cs
        pop     ds
        popad
        clc
        ret
RVCU_Fail_DS:
        push    cs
        pop     ds
RVCU_Fail:
        popad
        stc
        ret
EndProc RM_Validate_Current_Unit

BeginProc RM_Validate_One_LBA
        mov     cs:[RM_Test_LBA], eax
        push    ds
        push    cs
        pop     ds
        call    RM_Read_INT13_Sector
        pop     ds
        jc      SHORT RVOL_Fail
        call    RM_Read_ABIOS_Sector
        jc      SHORT RVOL_Fail
        call    RM_Compare_Sectors
        jne     SHORT RVOL_Fail
        clc
        ret
RVOL_Fail:
        stc
        ret
EndProc RM_Validate_One_LBA

; Enumerate all LIDs, exclude SCSI, validate each fixed-disk unit, and export
; only units whose ABIOS and INT 13h sector contents agree.
BeginProc RM_Find_And_Validate_Disks
        pushad
        push    ds
        push    es
        mov     cs:[RM_Disk_Count], 0
        mov     cs:[RM_Next_Int13], 80h
        mov     cs:[RM_Current_LID], 2
RFVD_LID_Loop:
        mov     ax, cs:[RM_Current_LID]
        cmp     ax, cs:[RM_Total_LIDs]
        ja      RFVD_Done
        mov     ax, cs:[RM_Allocation_Segment]
        mov     es, ax
        mov     bx, cs:[RM_Current_LID]
        shl     bx, 3
        cmp     WORD PTR es:[bx+ABIOS_CDA_DEVICE_BLOCK+2], ax
        jne     RFVD_Next_LID
        mov     di, WORD PTR es:[bx+ABIOS_CDA_DEVICE_BLOCK]
        test    di, di
        jz      RFVD_Next_LID
        cmp     WORD PTR es:[di+ABIOS_DB_DEVICE_ID], ABIOS_DEVICE_DISK
        jne     RFVD_Next_LID
        mov     cs:[RM_Current_Unit], 0
        mov     cx, ABIOS_RLP_SIZE
        mov     dx, ABFC_RET_LID_PARMS
        call    RM_Prepare_Header
        call    RM_Run_Request
        push    cs
        pop     ds
        jc      RFVD_Next_LID
        mov     ax, cs:[RM_Allocation_Segment]
        mov     es, ax
        mov     bx, cs:[RM_Request_Offset]
        cmp     WORD PTR es:[bx+ABIOS_RLP_DEVICE_ID], ABIOS_DEVICE_DISK
        jne     RFVD_Next_LID
        cmp     BYTE PTR es:[bx+ABIOS_RLP_INTERRUPT_LEVEL], 14
        jne     RFVD_Next_LID
        mov     ax, es:[bx+ABIOS_RLP_REQUEST_LENGTH]
        cmp     ax, ABIOS_RW_SIZE
        jb      RFVD_Next_LID
        cmp     ax, ABIOS_MAX_REQUEST
        ja      RFVD_Next_LID
        mov     cs:[RM_Current_RB_Length], ax
        mov     ax, es:[bx+ABIOS_RLP_FLAGS]
        mov     cs:[RM_Current_LID_Flags], ax
        mov     bp, es:[bx+ABIOS_RLP_UNIT_COUNT]
        mov     cs:[RM_Current_Unit], 0
RFVD_Unit_Loop:
        test    bp, bp
        jz      RFVD_Next_LID
        cmp     cs:[RM_Disk_Count], ABIOS_MAX_DRIVES
        jae     RFVD_Done
        mov     cx, cs:[RM_Current_RB_Length]
        mov     dx, ABFC_READ_DEVICE_PARMS
        call    RM_Prepare_Header
        call    RM_Run_Request
        push    cs
        pop     ds
        jc      RFVD_Unit_Next
        mov     ax, cs:[RM_Allocation_Segment]
        mov     es, ax
        mov     bx, cs:[RM_Request_Offset]
        mov     ax, es:[bx+ABIOS_RDP_DEVICE_FLAGS]
        test    ax, ABIOS_DP_SCSI_DEVICE
        jnz     RFVD_Unit_Next
        test    ax, ABIOS_DP_READABLE
        jz      RFVD_Unit_Next
        test    ax, ABIOS_DP_POWER_OFF
        jnz     RFVD_Unit_Next
        cmp     WORD PTR es:[bx+ABIOS_RDP_BLOCK_SIZE], ABIOS_BLOCK_SIZE_512
        jne     RFVD_Unit_Next
        cmp     DWORD PTR es:[bx+ABIOS_RDP_RBA_COUNT], 1
        jbe     RFVD_Unit_Next
        push    ds
        push    es
        pop     ds
        push    cs
        pop     es
        mov     si, bx
        mov     di, OFFSET RM_RDP_Save
        mov     cx, ABIOS_RDP_SIZE/4
        cld
        rep movsd
        pop     ds
        call    RM_Validate_Current_Unit
        push    cs
        pop     ds
        jc      RFVD_Unit_Rejected

        mov     ax, cs:[RM_Allocation_Segment]
        mov     es, ax
        mov     di, cs:[RM_Metadata_Offset]
        add     di, ABIOS_META_HEADER_SIZE
        movzx   eax, cs:[RM_Disk_Count]
        imul    ax, SIZE ABIOS_DRIVE_META
        add     di, ax
        mov     ax, cs:[RM_Current_LID]
        mov     es:[di.ADM_LID], ax
        mov     ax, cs:[RM_Current_Unit]
        mov     es:[di.ADM_Unit], ax
        mov     al, cs:[RM_Next_Int13]
        mov     es:[di.ADM_Int13_Drive], al
        mov     BYTE PTR es:[di.ADM_IRQ], 14
        mov     ax, cs:[RM_Current_LID_Flags]
        mov     es:[di.ADM_LID_Flags], ax
        mov     ax, WORD PTR cs:[RM_RDP_Save+ABIOS_RDP_DEVICE_FLAGS]
        mov     es:[di.ADM_Device_Flags], ax
        mov     ax, WORD PTR cs:[RM_RDP_Save+ABIOS_RDP_SECTORS_PER_TRACK]
        mov     es:[di.ADM_Sectors_Per_Track], ax
        mov     WORD PTR es:[di.ADM_Block_Size], 512
        movzx   eax, BYTE PTR cs:[RM_RDP_Save+ABIOS_RDP_HEADS]
        mov     es:[di.ADM_Heads], eax
        mov     eax, DWORD PTR cs:[RM_RDP_Save+ABIOS_RDP_CYLINDERS]
        mov     es:[di.ADM_Cylinders], eax
        mov     eax, DWORD PTR cs:[RM_RDP_Save+ABIOS_RDP_RBA_COUNT]
        mov     es:[di.ADM_RBA_Count], eax
        mov     ax, WORD PTR cs:[RM_RDP_Save+ABIOS_RDP_MAX_TRANSFER]
        mov     es:[di.ADM_Max_Transfer], ax
        mov     ax, cs:[RM_Current_RB_Length]
        mov     es:[di.ADM_Request_Length], ax
        mov     al, BYTE PTR cs:[RM_RDP_Save+ABIOS_RDP_RETRY_COUNT]
        mov     es:[di.ADM_Retry_Count], al
        mov     al, cs:[RM_Test_Count]
        mov     es:[di.ADM_Validation_Reads], al
        inc     cs:[RM_Disk_Count]
RFVD_Unit_Rejected:
        inc     cs:[RM_Next_Int13]
RFVD_Unit_Next:
        inc     cs:[RM_Current_Unit]
        dec     bp
        jmp     RFVD_Unit_Loop
RFVD_Next_LID:
        inc     cs:[RM_Current_LID]
        jmp     RFVD_LID_Loop
RFVD_Done:
        mov     ax, cs:[RM_Allocation_Segment]
        mov     es, ax
        mov     di, cs:[RM_Metadata_Offset]
        mov     ax, cs:[RM_Disk_Count]
        mov     es:[di.AM_Drive_Count], ax
        test    ax, ax
        jz      SHORT RFVD_Fail
        pop     es
        pop     ds
        popad
        clc
        ret
RFVD_Fail:
        pop     es
        pop     ds
        popad
        stc
        ret
EndProc RM_Find_And_Validate_Disks

IFDEF ABIOS_DIAGNOSTIC
RM_Build_Entry LABEL NEAR
BeginProc RM_Diagnostic_Entry
        mov     ax, cs
        cli
        mov     ss, ax
        mov     sp, 2FF0h
        sti
        mov     es, ax
        mov     bx, 300h
        mov     ah, 4Ah
        int     21h
        jc      RMD_Too_Large
        push    cs
        pop     ds
        call    RM_Build_BIOS_Tables
        jc      RMD_No_ABIOS
        call    RM_Allocate_ABIOS_Data
        jc      RMD_Too_Large
        call    RM_Initialize_ABIOS
        jc      SHORT RMD_No_ABIOS_Free
        call    RM_Find_And_Validate_Disks
        jc      SHORT RMD_No_Disk_Free
        mov     dx, OFFSET RM_Message_Passed
        xor     bl, bl
        jmp     SHORT RMD_Free_Print
RMD_No_ABIOS_Free:
        mov     dx, OFFSET RM_Message_No_ABIOS
        jmp     SHORT RMD_Free_Error
RMD_No_Disk_Free:
        mov     dx, OFFSET RM_Message_No_Disk
RMD_Free_Error:
        mov     bl, 1
RMD_Free_Print:
        push    bx
        push    dx
        mov     ax, cs:[RM_Allocation_Segment]
        mov     es, ax
        mov     ah, 49h
        int     21h
        pop     dx
        pop     bx
        jmp     SHORT RMD_Print
RMD_No_ABIOS:
        mov     dx, OFFSET RM_Message_No_ABIOS
        mov     bl, 1
        jmp     SHORT RMD_Print
RMD_Too_Large:
        mov     dx, OFFSET RM_Message_Too_Large
        mov     bl, 1
RMD_Print:
        push    cs
        pop     ds
        mov     ah, 9
        int     21h
        mov     al, bl
        mov     ah, 4Ch
        int     21h
EndProc RM_Diagnostic_Entry

RM_DIAGNOSTIC_SEG ENDS
ELSE
VxD_REAL_INIT_ENDS
ENDIF

END RM_Build_Entry
