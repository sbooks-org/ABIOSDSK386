PAGE 58,132
TITLE ADDINI.ASM -- ABIOSDSK 0.90 prerelease INI helper
; Copyright (C) 2026 Simplebooks Foundation
; Copyright (C) 2026 Josh Rodd

; ---------------------------------------------------------------------------
; ADDINI <file> <section> <line>
;
; Finds the first line in <file> that is a section header for <section>
; and inserts <line> on its own line immediately below that header.
; Section names match case-insensitively ("386Enh" finds "[386enh]").
; Leading whitespace on the header line is ignored, and anything after
; the ']' on that line is left alone.  The first matching header wins.
;
; Exit status:  0  success (nothing is printed)
;               2  missing or unusable arguments
;               3  cannot open <file>
;               4  read error
;               5  file too large (more than 32 KB)
;               6  section not found (file left untouched)
;               7  write error
;
; Runs one-shot from the command line; it does not stay resident.
;
; Target: PC-DOS / MS-DOS 3.10 or later, any 8086-class CPU.  Uses only
; INT 21h functions 09h, 3Dh, 3Eh, 3Fh, 40h and 4Ch, all available in
; DOS 2.0 and later.
;
; Build:  MASM 5.x, then LINK /TINY  (see build-addini.sh)
; ---------------------------------------------------------------------------

_TEXT   SEGMENT PARA PUBLIC 'CODE'
        ASSUME  CS:_TEXT, DS:_TEXT, ES:_TEXT, SS:_TEXT
        ORG     100h

; ---------------------------------------------------------------------------
; JIF cond,label -- branch to a possibly-distant label.  8086 conditional
; jumps are always short, so invert the condition and skip over a near
; jump: JIF NC,UsageError jumps to UsageError when the carry flag is set.
; ---------------------------------------------------------------------------
JIF     MACRO   cond, lab
        j&cond  $+5
        jmp     lab
        ENDM

; JIFZ lab -- branch to a possibly-distant label when CX is zero.  There is
; no conditional jump for "CX not zero", so test ZF with OR (CX unchanged)
; and skip the near jump when CX is nonzero.
JIFZ    MACRO   lab
        or      cx, cx
        jnz     $+5
        jmp     lab
        ENDM

Start:
        jmp     Main

; ---------------------------------------------------------------------------
; ParseArgs: split the PSP command tail into FileName, SectionName, Line.
; Exits with a usage message if any argument is missing or too long.
; ---------------------------------------------------------------------------
ParseArgs PROC NEAR
        mov     si, 81h                 ; first byte after the length
        mov     cl, BYTE PTR ds:[80h]   ; tail length
        xor     ch, ch

        mov     di, OFFSET FileName
        mov     dl, 63
        call    GetToken
        JIF NC, UsageError

        mov     di, OFFSET SectionName
        mov     dl, 31
        call    GetToken
        JIF NC, UsageError

        mov     di, OFFSET LineBuf
        mov     dl, 127
        call    GetLine
        JIF NC, UsageError

        ; remember how long the line is
        mov     si, OFFSET LineBuf
        xor     cx, cx
PL_Count:
        mov     al, BYTE PTR [si]
        test    al, al
        jz      PL_Done
        inc     si
        inc     cx
        jmp PL_Count
PL_Done:
        mov     [LineLen], cx
        ret
ParseArgs ENDP

; ---------------------------------------------------------------------------
; GetToken: copy one blank-delimited word from the tail.
;   In:  SI = cursor, CX = bytes remaining, DI = destination, DL = max chars
;   Out: CF=0, word copied and NUL-terminated, SI/CX past the word
;        CF=1, missing (or too long)
; ---------------------------------------------------------------------------
GetToken PROC NEAR
GT_Skip:
        test    cx, cx
        jz      GT_Missing
        mov     al, BYTE PTR [si]
        cmp     al, ' '
        je      GT_Advance
        cmp     al, 9
        je      GT_Advance
        jmp GT_Copy
GT_Advance:
        inc     si
        dec     cx
        jmp GT_Skip
GT_Copy:
        xor     bl, bl                  ; character count
GT_Loop:
        test    cx, cx
        jz      GT_Done
        mov     al, BYTE PTR [si]
        cmp     al, ' '
        je      GT_Done
        cmp     al, 9
        je      GT_Done
        cmp     al, 0Dh
        je      GT_Done
        cmp     al, 0Ah
        je      GT_Done
        cmp     bl, dl
        jae     GT_Missing              ; too long
        mov     BYTE PTR [di], al
        inc     di
        inc     bl
        inc     si
        dec     cx
        jmp GT_Loop
GT_Done:
        mov     BYTE PTR [di], 0
        clc
        ret
GT_Missing:
        stc
        ret
GetToken ENDP

; ---------------------------------------------------------------------------
; GetLine: copy the rest of the tail, trimmed of leading and trailing
;   blanks, into the destination.  Trailing CR/LF is not copied.
;   In:  SI = cursor, CX = bytes remaining, DI = destination, DL = max chars
;   Out: CF=0, line copied and NUL-terminated, CF=1 if empty or too long
; ---------------------------------------------------------------------------
GetLine PROC NEAR
GL_Skip:
        test    cx, cx
        jz      GL_Empty
        mov     al, BYTE PTR [si]
        cmp     al, ' '
        je      GL_Advance
        cmp     al, 9
        je      GL_Advance
        jmp GL_Copy
GL_Advance:
        inc     si
        dec     cx
        jmp GL_Skip
GL_Copy:
        xor     bl, bl
        mov     bp, di                  ; first character position
GL_Loop:
        test    cx, cx
        jz      GL_Trim
        mov     al, BYTE PTR [si]
        cmp     al, 0Dh
        je      GL_Trim
        cmp     al, 0Ah
        je      GL_Trim
        cmp     bl, dl
        jae     GL_Empty                ; too long
        mov     BYTE PTR [di], al
        inc     di
        inc     bl
        inc     si
        dec     cx
        jmp GL_Loop
GL_Trim:
        cmp     di, bp
        jbe     GL_Empty                ; nothing but blanks
        mov     al, BYTE PTR [di-1]
        cmp     al, ' '
        je      GL_TrimStep
        cmp     al, 9
        je      GL_TrimStep
        jmp GL_Terminate
GL_TrimStep:
        dec     di
        jmp GL_Trim
GL_Terminate:
        mov     BYTE PTR [di], 0
        clc
        ret
GL_Empty:
        stc
        ret
GetLine ENDP

; ---------------------------------------------------------------------------
; Main: open, read, locate, patch, close.
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; RejectTildeName: bail if FileName ends with '~' (temp copies of
; backed-up files are not safe to modify in place).
; ---------------------------------------------------------------------------
RejectTildeName PROC NEAR
        mov     si, OFFSET FileName
        xor     cx, cx
RTN_Scan:
        cmp     BYTE PTR [si], 0
        je      RTN_Done
        inc     si
        inc     cx
        jmp     RTN_Scan
RTN_Done:
        jcxz    RTN_OK                  ; empty (should not happen)
        cmp     BYTE PTR [si-1], '~'
        jne     RTN_OK
        mov     dx, OFFSET Msg_TempRefused
        call    Print
        mov     ax, 4C08h
        int     21h
RTN_OK:
        ret
RejectTildeName ENDP

Main PROC NEAR
        call    ParseArgs

        ; Refuse filenames ending with '~' — those are temp copies.
        ; Do this before opening the file so we touch nothing.
        call    RejectTildeName

        mov     ax, 3D02h               ; open existing file, read/write
        mov     dx, OFFSET FileName
        int     21h
        JIF NC, OpenError
        mov     [Handle], ax

        mov     bx, ax
        xor     di, di                  ; total bytes read
ReadLoop:
        mov     ah, 3Fh
        mov     cx, BufSize
        mov     dx, OFFSET FileBuf
        int     21h
        JIF NC, ReadError
        test    ax, ax
        jz      ReadDone
        add     di, ax
        cmp     di, BufSize
        jb      ReadLoop
        ; buffer exactly full: one more byte tells us the file is bigger
        mov     ah, 3Fh
        mov     cx, 1
        mov     dx, OFFSET ProbeByte
        int     21h
        JIF NC, ReadError
        test    ax, ax
        JIF Z, TooLargeError
ReadDone:
        mov     [FileLen], di

        call    FindSection
        JIF C, NotFoundError
        mov     [InsOffset], di
        mov     [NeedPrefix], dx

        call    WriteChanges
        JIF NC, WriteError

        mov     ah, 3Eh                 ; close
        mov     bx, [Handle]
        int     21h

        mov     ax, 4C00h
        int     21h
Main ENDP

; ---------------------------------------------------------------------------
; FindSection: scan FileBuf[0..FileLen) for the section header.
;   Out: CF=1 found, DI = insertion offset, DX = need-prefix flag
;        (1 if the header line has no terminator, so a CRLF must be
;        written before the new line)
;        CF=0 not found
; ---------------------------------------------------------------------------
FindSection PROC NEAR
        mov     dx, OFFSET FileBuf      ; DX = current line start
FS_Line:
        call    TestHeader
        jc      FS_Found

        ; advance to the start of the next line
        mov     si, dx
        mov     ax, dx
        sub     ax, OFFSET FileBuf
        mov     cx, [FileLen]
        sub     cx, ax                  ; CX = bytes remaining
FS_Scan:
        jcxz    FS_NotFound
        mov     al, BYTE PTR [si]
        cmp     al, 0Dh
        je      FS_CR
        cmp     al, 0Ah
        je      FS_LF
        inc     si
        dec     cx
        jmp FS_Scan
FS_CR:
        inc     si
        dec     cx
        jcxz    FS_Next
        cmp     BYTE PTR [si], 0Ah
        jne     FS_Next
        inc     si
        dec     cx
FS_Next:
        mov     dx, si
        jmp FS_Line
FS_LF:
        inc     si
        dec     cx
        mov     dx, si
        jmp FS_Line
FS_NotFound:
        clc
        ret
FS_Found:
        stc
        ret
FindSection ENDP

; ---------------------------------------------------------------------------
; TestHeader: is the line at DX a [section] header for SectionName?
;   Out: CF=1 yes, DI = insertion offset (just past the line terminator,
;        or EOF if there is none), DX = need-prefix flag
;        CF=0 no (DX preserved)
; ---------------------------------------------------------------------------
TestHeader PROC NEAR
        mov     si, dx                  ; SI scans the line
        mov     ax, si
        sub     ax, OFFSET FileBuf
        mov     cx, [FileLen]
        sub     cx, ax                  ; CX = bytes remaining

        ; skip leading blanks
TH_Skip:
        JIFZ    TH_No
        mov     al, BYTE PTR [si]
        cmp     al, ' '
        je      TH_Step
        cmp     al, 9
        je      TH_Step
        jmp TH_Bracket
TH_Step:
        inc     si
        dec     cx
        jmp TH_Skip

TH_Bracket:
        cmp     al, '['
        JIF E, TH_No

        inc     si
        dec     cx

        ; compare against the section name, case-insensitively
        mov     bx, OFFSET SectionName
TH_Name:
        mov     al, BYTE PTR [bx]
        test    al, al
        jz      TH_NameDone
        JIFZ    TH_No
        mov     ah, BYTE PTR [si]
        cmp     al, 'a'
        jb      TH_AL_Upper
        cmp     al, 'z'
        ja      TH_AL_Upper
        sub     al, 20h
TH_AL_Upper:
        cmp     ah, 'a'
        jb      TH_AH_Upper
        cmp     ah, 'z'
        ja      TH_AH_Upper
        sub     ah, 20h
TH_AH_Upper:
        cmp     al, ah
        JIF E, TH_No
        inc     si
        dec     cx
        inc     bx
        jmp TH_Name

TH_NameDone:
        ; skip blanks, then expect ']'
TH_Skip2:
        JIFZ    TH_No
        mov     al, BYTE PTR [si]
        cmp     al, ' '
        je      TH_Step2
        cmp     al, 9
        je      TH_Step2
        jmp TH_Close
TH_Step2:
        inc     si
        dec     cx
        jmp TH_Skip2

TH_Close:
        cmp     al, ']'
        JIF E, TH_No

        ; header found.  Walk to the end of the line to find its
        ; terminator (CR, LF, or CRLF); insertion goes right after it.
        inc     si
        dec     cx
        mov     di, si
TH_Term:
        jcxz    TH_Unterminated
        mov     al, BYTE PTR [di]
        cmp     al, 0Dh
        je      TH_CR
        cmp     al, 0Ah
        je      TH_LF
        inc     di
        dec     cx
        jmp TH_Term

TH_CR:
        inc     di
        dec     cx
        jcxz    TH_CRDone
        cmp     BYTE PTR [di], 0Ah
        jne     TH_CRDone
        inc     di
        dec     cx
TH_CRDone:
        mov     ax, di
        sub     ax, OFFSET FileBuf
        xor     dx, dx                  ; no CRLF prefix needed
        jmp TH_Hit

TH_LF:
        inc     di
        dec     cx
        mov     ax, di
        sub     ax, OFFSET FileBuf
        xor     dx, dx
        jmp TH_Hit

TH_Unterminated:
        mov     ax, [FileLen]           ; insert at EOF
        mov     dx, 1                   ; CRLF prefix needed
TH_Hit:
        mov     di, ax

        stc
        ret
TH_No:

        clc
        ret
TestHeader ENDP

; ---------------------------------------------------------------------------
; WriteChanges: write the file back as head + new line + tail.
; ---------------------------------------------------------------------------
WriteChanges PROC NEAR
        ; Write the output to a temporary file (last char → '~'),
        ; then atomically replace the original.  This is as close to
        ; atomic as DOS 3.10 can manage: on failure the temp file is
        ; deleted and the original is untouched.  Any stale temp file
        ; from a previous crashed run is removed before the new one is
        ; created.

        ; construct TempName = FileName with trailing char → '~'
        mov     si, OFFSET FileName
        xor     cx, cx
W_StrLen:
        cmp     BYTE PTR [si], 0
        je      W_HaveLen
        inc     si
        inc     cx
        jmp     W_StrLen
W_HaveLen:
        push    cx                      ; save length
        mov     si, OFFSET FileName
        mov     di, OFFSET TempName
        rep movsb                       ; copy including the NUL
        mov     BYTE PTR [di-2], '~'    ; replace last char before NUL

        ; delete any stale temp file (best effort)
        mov     ah, 41h
        mov     dx, OFFSET TempName
        int     21h

        ; create temp file
        mov     ah, 3Ch
        xor     cx, cx
        mov     dx, OFFSET TempName
        int     21h
        JIF NC, W_TempFail
        mov     [TempHandle], ax

        ; ---- write head, [prefix CRLF,] line, CRLF, tail ----
        mov     bx, ax                  ; BX = temp handle

        ; head: bytes before the insertion point
        mov     ah, 40h
        mov     cx, [InsOffset]
        mov     dx, OFFSET FileBuf
        int     21h
        JIF NC, W_WriteFail
        cmp     ax, cx
        JIF Z, W_WriteFail

        ; leading CRLF when the header was unterminated
        cmp     [NeedPrefix], 0
        JIF NZ, W_Line
        mov     ah, 40h
        mov     cx, 2
        mov     dx, OFFSET CRLF
        int     21h
        JIF NC, W_WriteFail
        cmp     ax, 2
        JIF Z, W_WriteFail

W_Line:
        ; the new line + trailing CRLF
        mov     ah, 40h
        mov     cx, [LineLen]
        mov     dx, OFFSET LineBuf
        int     21h
        JIF NC, W_WriteFail
        cmp     ax, cx
        JIF Z, W_WriteFail

        mov     ah, 40h
        mov     cx, 2
        mov     dx, OFFSET CRLF
        int     21h
        JIF NC, W_WriteFail
        cmp     ax, 2
        JIF Z, W_WriteFail
        ; tail: everything after the insertion point.
        ; Copy it to the beginning of FileBuf (the head region was
        ; already written) and write from there, because some DOS
        ; implementations mis-handle writes whose source is above
        ; offset ~0x4000 in a large buffer.
        mov     cx, [FileLen]
        sub     cx, [InsOffset]
        jz      W_NoTail
        mov     [TailCount], cx         ; save count for the write
        mov     si, OFFSET FileBuf
        add     si, [InsOffset]          ; SI = tail source
        mov     di, OFFSET FileBuf       ; DI = low-address destination
        rep movsb                       ; copy tail to [0..count)
        mov     ah, 40h
        mov     cx, [TailCount]
        mov     dx, OFFSET FileBuf
        int     21h
        jc      W_WriteFail
        cmp     ax, cx
        JIF Z, W_WriteFail
W_NoTail:
        ; close both files
        mov     ah, 3Eh
        mov     bx, [Handle]
        int     21h
        mov     ah, 3Eh
        mov     bx, [TempHandle]
        int     21h

        ; delete the original
        mov     ah, 41h
        mov     dx, OFFSET FileName
        int     21h
        jc      W_UnlinkFail

        ; rename temp → original
        mov     ah, 56h
        mov     dx, OFFSET TempName
        mov     di, OFFSET FileName
        int     21h
        jc      W_UnlinkFail

        clc
        ret

W_WriteFail:
        ; close temp, delete it, close original
        push    ax
        mov     ah, 3Eh
        mov     bx, [TempHandle]
        int     21h
        mov     ah, 41h
        mov     dx, OFFSET TempName
        int     21h
W_CloseOrig:
        mov     ah, 3Eh
        mov     bx, [Handle]
        int     21h
        pop     ax
        stc
        ret

W_UnlinkFail:
        ; delete temp (best effort) and signal failure
        mov     ah, 41h
        mov     dx, OFFSET TempName
        int     21h
        stc
        ret

W_TempFail:
        ; could not create temp — close original and fail
        mov     ah, 3Eh
        mov     bx, [Handle]
        int     21h
        stc
        ret
WriteChanges ENDP

; ---------------------------------------------------------------------------
; Error exits
; ---------------------------------------------------------------------------
UsageError:
        mov     dx, OFFSET Msg_Usage
        call    Print
        mov     ax, 4C02h
        int     21h
OpenError:
        mov     dx, OFFSET Msg_Open
        call    Print
        mov     ax, 4C03h
        int     21h
ReadError:
        mov     dx, OFFSET Msg_Read
        call    Print
        mov     ax, 4C04h
        int     21h
TempName        db 64 dup (0)
TempHandle      dw 0
TailCount       dw 0

TooLargeError:
        mov     dx, OFFSET Msg_TooLarge
        call    Print
        mov     ax, 4C05h
        int     21h
NotFoundError:
        mov     dx, OFFSET Msg_NotFound
        call    Print
        mov     ax, 4C06h
        int     21h
WriteError:
        mov     dx, OFFSET Msg_Write
        call    Print
        mov     ax, 4C07h
        int     21h

Print PROC NEAR
        mov     ah, 9
        int     21h
        ret
Print ENDP

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
CRLF            db 0Dh, 0Ah
Msg_Usage       db 0Dh, 0Ah, 'ADDINI: usage: ADDINI <file> <section> <line>', 0Dh, 0Ah, '$'
Msg_Open        db 0Dh, 0Ah, 'ADDINI: cannot open file', 0Dh, 0Ah, '$'
Msg_Read        db 0Dh, 0Ah, 'ADDINI: read error', 0Dh, 0Ah, '$'
Msg_TooLarge    db 0Dh, 0Ah, 'ADDINI: file too large', 0Dh, 0Ah, '$'
Msg_NotFound    db 0Dh, 0Ah, 'ADDINI: section not found', 0Dh, 0Ah, '$'
Msg_Write       db 0Dh, 0Ah, 'ADDINI: write error', 0Dh, 0Ah, '$'
Msg_TempRefused db 0Dh, 0Ah, 'ADDINI: refusing to touch backup file', 0Dh, 0Ah, '$'

Handle          dw 0
FileLen         dw 0
InsOffset       dw 0
NeedPrefix      dw 0
LineLen         dw 0

FileName        db 64 dup (0)
SectionName     db 32 dup (0)
LineBuf         db 128 dup (0)
ProbeByte       db 0

BufSize         EQU 8000h
FileBuf         db BufSize dup (0)

_TEXT   ENDS
        END     Start
