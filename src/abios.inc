; ABIOS fixed-disk interface definitions used by ABIOSDSK.
; Layouts follow IBM Personal System/2 ABIOS, September 1991.
; Copyright (C) 2026 Simplebooks Foundation
; Copyright (C) 2026 Josh Rodd

ABIOS_EP_START                 EQU 0
ABIOS_EP_INTERRUPT             EQU 1
ABIOS_EP_TIMEOUT               EQU 2

ABFC_DEFAULT_INT_HANDLER       EQU 00h
ABFC_RET_LID_PARMS             EQU 01h
ABFC_READ_DEVICE_PARMS         EQU 03h
ABFC_RESET_DEVICE              EQU 05h
ABFC_DISK_READ                 EQU 08h
ABFC_DISK_WRITE                EQU 09h
ABFC_DISK_WRITE_VERIFY         EQU 0Ah
ABFC_DISK_VERIFY               EQU 0Bh
ABFC_DISK_INTERRUPT_STATUS     EQU 0Ch

ABRC_COMPLETE                  EQU 0000h
ABRC_STAGE_ON_INTERRUPT        EQU 0001h
ABRC_STAGE_ON_TIME             EQU 0002h
ABRC_NOT_MY_INTERRUPT          EQU 0005h
ABRC_SPURIOUS_INTERRUPT        EQU 0081h
ABRC_DEVICE_IN_USE             EQU 8000h
ABRC_INVALID                   EQU 0FFFFh
ABRC_UNSUCCESSFUL              EQU 8000h
ABRC_RETRYABLE                 EQU 0100h

ABIOS_DEVICE_INTERNAL          EQU 00h
ABIOS_DEVICE_DISK              EQU 02h

ABIOS_LF_16MB_SUPPORT          EQU 0020h
ABIOS_LF_CONCURRENT            EQU 0008h
ABIOS_LF_PHYSICAL_POINTER      EQU 0002h
ABIOS_LF_LOGICAL_POINTER       EQU 0001h

ABIOS_DP_SCB_TRANSFER          EQU 8000h
ABIOS_DP_SCSI_DEVICE           EQU 4000h
ABIOS_DP_ST506                 EQU 0400h
ABIOS_DP_CONCURRENT            EQU 0200h
ABIOS_DP_READABLE              EQU 0020h
ABIOS_DP_WRITE_MANY            EQU 0008h
ABIOS_DP_POWER_OFF             EQU 0002h
ABIOS_DP_PARAMETERS_INVALID    EQU 0001h

ABIOS_RB_LENGTH                EQU 00h
ABIOS_RB_LID                   EQU 02h
ABIOS_RB_UNIT                  EQU 04h
ABIOS_RB_FUNCTION              EQU 06h
ABIOS_RB_RESERVED0             EQU 08h
ABIOS_RB_RC                    EQU 0Ch
ABIOS_RB_TIMEOUT               EQU 0Eh

ABIOS_RLP_INTERRUPT_LEVEL      EQU 10h
ABIOS_RLP_ARBITRATION_LEVEL    EQU 11h
ABIOS_RLP_DEVICE_ID            EQU 12h
ABIOS_RLP_UNIT_COUNT           EQU 14h
ABIOS_RLP_FLAGS                EQU 16h
ABIOS_RLP_REQUEST_LENGTH       EQU 18h
ABIOS_RLP_SECONDARY_ID         EQU 1Ah
ABIOS_RLP_REVISION             EQU 1Bh
ABIOS_RLP_SIZE                 EQU 20h

ABIOS_RDP_SECTORS_PER_TRACK    EQU 10h
ABIOS_RDP_BLOCK_SIZE           EQU 12h
ABIOS_RDP_DEVICE_FLAGS         EQU 14h
ABIOS_RDP_CYLINDERS            EQU 18h
ABIOS_RDP_HEADS                EQU 1Ch
ABIOS_RDP_RETRY_COUNT          EQU 1Dh
ABIOS_RDP_RBA_COUNT            EQU 20h
ABIOS_RDP_MAX_TRANSFER         EQU 2Ch
ABIOS_RDP_SIZE                 EQU 30h

ABIOS_RW_LOGICAL_BUFFER        EQU 12h
ABIOS_RW_PHYSICAL_BUFFER       EQU 1Ah
ABIOS_RW_RBA                   EQU 20h
ABIOS_RW_WAIT_TIME             EQU 28h
ABIOS_RW_BLOCK_COUNT           EQU 2Ch
ABIOS_RW_FLAGS                 EQU 2Eh
ABIOS_RW_SOFT_ERROR            EQU 2Fh
ABIOS_BLOCK_SIZE_512           EQU 02h
ABIOS_RW_SIZE                  EQU 34h

ABIOS_CDA_DATA0_OFFSET         EQU 00h
ABIOS_CDA_LID_COUNT            EQU 02h
ABIOS_CDA_FIRST_LID            EQU 08h
ABIOS_CDA_LID_ENTRY_SIZE       EQU 08h
ABIOS_CDA_DEVICE_BLOCK         EQU 00h
ABIOS_CDA_FUNCTION_TABLE       EQU 04h

ABIOS_FTT_START                EQU 00h
ABIOS_FTT_INTERRUPT            EQU 04h
ABIOS_FTT_TIMEOUT              EQU 08h
ABIOS_FTT_FUNCTION_COUNT       EQU 0Ch
ABIOS_FTT_FIRST_FUNCTION       EQU 10h

ABIOS_DB_LOGICAL_ID            EQU 04h
ABIOS_DB_DEVICE_ID             EQU 06h

ABIOS_INIT_ENTRY_SIZE          EQU 18h
ABIOS_INIT_DEVICE_ID           EQU 00h
ABIOS_INIT_LID_COUNT           EQU 02h
ABIOS_INIT_DEVICE_BLOCK_LENGTH EQU 04h
ABIOS_INIT_ROUTINE             EQU 06h
ABIOS_INIT_REQUEST_LENGTH      EQU 0Ah
ABIOS_INIT_FTT_LENGTH          EQU 0Ch
ABIOS_INIT_DATA_LENGTH         EQU 0Eh
ABIOS_INIT_SECONDARY_ID        EQU 10h
ABIOS_INIT_REVISION            EQU 11h

ABIOS_SYSTEM_START             EQU 00h
ABIOS_SYSTEM_INTERRUPT         EQU 04h
ABIOS_SYSTEM_TIMEOUT           EQU 08h
ABIOS_SYSTEM_STACK             EQU 0Ch
ABIOS_SYSTEM_ENTRY_COUNT       EQU 1Eh
ABIOS_SYSTEM_SIZE              EQU 20h

ABIOS_MAX_INIT_ENTRIES         EQU 64
ABIOS_MAX_LIDS                 EQU 64
ABIOS_MAX_DRIVES               EQU 4
ABIOS_MAX_REQUEST              EQU 80h
ABIOS_MAX_CDA                  EQU 4096
ABIOS_MAX_PM_FTT               EQU 16384
ABIOS_PM_STACK_SLICE           EQU 4096
ABIOS_PM_STACK_START_TOP       EQU ABIOS_PM_STACK_SLICE
ABIOS_PM_STACK_INTERRUPT_TOP   EQU (ABIOS_PM_STACK_SLICE * 2)
ABIOS_PM_STACK_TIMEOUT_TOP     EQU (ABIOS_PM_STACK_SLICE * 3)
ABIOS_PM_STACK_BYTES           EQU ABIOS_PM_STACK_TIMEOUT_TOP
ABIOS_PM_WORK_PAGES            EQU ((ABIOS_MAX_CDA + ABIOS_MAX_PM_FTT + ABIOS_PM_STACK_BYTES + 4095) / 4096)
ABIOS_BOUNCE_PAGES             EQU 16
ABIOS_BOUNCE_BYTES             EQU (ABIOS_BOUNCE_PAGES * 4096)
ABIOS_BOUNCE_SECTORS           EQU (ABIOS_BOUNCE_BYTES / 512)

ABIOS_META_MAGIC               EQU 534F4942h ; "BIOS", paired with version below
ABIOS_META_VERSION             EQU 0002h

ABIOS_META STRUC
AM_Magic                       dd ?
AM_Version                     dw ?
AM_Allocation_Paragraphs       dw ?
AM_CDA_Size                    dw ?
AM_LID_Count                   dw ?
AM_Drive_Count                 dw ?
AM_Reserved                    dw ?
AM_Common_Start                dd ?
AM_Common_Interrupt            dd ?
AM_Common_Timeout              dd ?
AM_Drives                      db 1 dup (?)
ABIOS_META ENDS

ABIOS_DRIVE_META STRUC
ADM_LID                        dw ?
ADM_Unit                       dw ?
ADM_Int13_Drive                db ?
ADM_IRQ                        db ?
ADM_LID_Flags                  dw ?
ADM_Device_Flags               dw ?
ADM_Sectors_Per_Track          dw ?
ADM_Block_Size                 dw ?
ADM_Heads                      dd ?
ADM_Cylinders                  dd ?
ADM_RBA_Count                  dd ?
ADM_Max_Transfer               dw ?
ADM_Request_Length             dw ?
ADM_Retry_Count                db ?
ADM_Validation_Reads           db ?
ABIOS_DRIVE_META ENDS

ABIOS_META_HEADER_SIZE         EQU ABIOS_META.AM_Drives
ABIOS_META_SIZE                EQU (ABIOS_META_HEADER_SIZE + ABIOS_MAX_DRIVES * SIZE ABIOS_DRIVE_META)
