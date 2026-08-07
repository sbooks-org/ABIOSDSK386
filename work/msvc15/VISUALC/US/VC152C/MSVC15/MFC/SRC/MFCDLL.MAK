# This is a part of the Microsoft Foundation Classes C++ library.
# Copyright (C) 1992-1993 Microsoft Corporation
# All rights reserved.
#
# This source code is only intended as a supplement to the
# Microsoft Foundation Classes Reference and Microsoft
# QuickHelp documentation provided with the library.
# See these sources for detailed information regarding the
# Microsoft Foundation Classes product.
#

# MFC250[D].DLL is a large model DLL built with MFC large model [debug] DLL
#  which exports all the MFC classes
# If you need a private build of the MFC DLL, be sure to rename
#  "MFC250.DLL" to something more appropriate for your application.
# Please do not re-distribute a privately built version with the
#  name "MFC250.DLL".


MODEL=l
TARGET=w
DLL=2
TARG=mfc250
MASMOPT=
LFLAGS=/NOD /NOE /ONERROR:NOEXE /PACKDATA /NOPACKCODE /BATCH
# /NOPACKCODE => keep MFC library segmentation

!if "$(DEBUG)"!="0"
# Debug DLL build
TARG=$(TARG)d
AFXDLL_OBJ=afxdlld.obj
RCDEFINES=/D_DEBUG
LFLAGS=$(LFLAGS)

!ELSE
# Release DLL build
AFXDLL_OBJ=afxdll.obj
RCDEFINES=
LFLAGS=$(LFLAGS) /AL:16
!ENDIF

!ifdef RELEASE # Release VERSION info
RCDEFINES=$(RCDEFINES) /DRELEASE
!endif

dll_goal: create2.dir $(TARG).dll ..\lib\$(TARG).lib

#############################################################################
# import most rules and library files from normal makefile

!include makefile

OBJ_LIB=$D.lib

!if "$(CODEVIEW)"=="1"
TARGOPTS_LIB=/Z7
LFLAGS=$(LFLAGS) /CODEVIEW
!endif

create2.dir:
	@-if not exist $D\*.* mkdir $D
	@-if not exist $(OBJ_LIB)\*.* mkdir $(OBJ_LIB)

#############################################################################
# Debug target

$D\$(TARG).res: mfcdll.rc
	rc /r $(RCDEFINES) /fo $D\$(TARG).res mfcdll.rc

DLLOBJS=$(OBJECT) $(INLINES) $(FILES) $(COLLECTIONS1) $(COLLECTIONS2) \
	$(MISC) $(WINDOWS) $(DIALOG) $(WINMISC) $(DOCVIEW) $(APPLICATION) \
	$(VBX_OBJ) $(OLEREQ)

$(TARG).dll: $(DLLOBJS) $D\dllinit.obj $(TARG).def $D\$(TARG).res
	@echo Creating DLL: $(TARG).DLL
	link $(LFLAGS) @<<mfcdll.rsp
$D\dllinit.obj+
$(DLLOBJS: =+
),
$(TARG).dll,
$D\$(TARG).map /MAP:ADDRESS,
ldllcew libw commdlg shell,
$(TARG).def;
<<KEEP
	rc /31 /t $D\$(TARG).res $(TARG).dll

#############################################################################
# Special rules for building static linked library part

# NonShared diagnostics and other hooks (see OBJDIAG in MAKEFILE)
SLIB_OBJ= $(OBJ_LIB)\dumpinit.obj $(OBJ_LIB)\dumpout.obj \
	$(OBJ_LIB)\afxasert.obj $(OBJ_LIB)\afxmem.obj $(OBJ_LIB)\afxabort.obj

# _AFXDLL defined (but not _WINDLL)
TARGOPTS_LIB=$(TARGOPTS_LIB) /GA /GEf /GEs /G2
CPPFLAGS_LIB=$(CL_MODEL) /W3 /WX /Zp $(TARGOPTS_LIB) $(DEFS) $(OPT)
PCH_LIB=$(OBJ_LIB)\stdafx.pch

$(OBJ_LIB)\dumpinit.obj $(OBJ_LIB)\stdafx.pch: dumpinit.cpp $(HDRS)
	@$(CPP) @<<
/c /Ycstdafx.h /Fp$(PCH_LIB) $(CPPFLAGS_LIB) /c /Fo$(OBJ_LIB)\ dumpinit.cpp
<<

.cpp{$(OBJ_LIB)}.obj:
	$(CPP) @<<
$(CPPFLAGS_LIB) /Yustdafx.h /Fp$(PCH_LIB) /c /Fo$(OBJ_LIB)\ $<
<<

# AFXDLL.OBJ and AFXDLLD.OBJ are pre-built using the following MASM rules
afxdll.obj: afxdll.asm
	masm /Mx $(MASM_OPT) afxdll.asm,afxdll.obj;
afxdlld.obj: afxdll.asm
	masm /Mx $(MASM_OPT) /D_DEBUG afxdll.asm,afxdlld.obj;

# import library
..\lib\$(TARG).lib: $(TARG).def $(AFXDLL_OBJ) $(SLIB_OBJ)
	if exist $@ del $@
	implib /NOWEP $@ $(TARG).def
	lib /NOEXT /PAGESIZE:16 @<<
$@
$(AFXDLL_OBJ)&
$(SLIB_OBJ)
;
<<
	if exist ..\lib\$(TARG).bak del ..\lib\$(TARG).bak

#############################################################################
