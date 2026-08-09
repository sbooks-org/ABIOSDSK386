; ABIOSCHK.COM standalone diagnostic wrapper.
; Copyright (C) 2026 Simplebooks Foundation
; Copyright (C) 2026 Josh Rodd
;
; The diagnostic and driver deliberately share the real-mode ABIOS engine.
ABIOS_DIAGNOSTIC EQU 1
ABIOS_UASM EQU 1
ABIOSDSK_RM_DEBUG EQU 1

INCLUDE ../src/abiosrm.asm
