# This is a part of the Microsoft Foundation Classes C++ library.
# Copyright (C) 1993 Microsoft Corporation
# All rights reserved.
#
# This source code is only intended as a supplement to the
# Microsoft Foundation Classes Reference and Microsoft
# QuickHelp documentation provided with the library.
# See these sources for detailed information regarding the
# Microsoft Foundation Classes product.
#

# MFCN250[D].DLL is a large model DLL built with MFC large model [debug] DLL
#  which exports all the MFC NET classes
# If you need a private build of the MFC DLL, be sure to rename
#  "MFCN250.DLL" to something more appropriate for your application.
# Please do not re-distribute a privately built version with the
#  name "MFCN250.DLL".


MODEL=l
TARGET=w
DLL=2
TARG=MFCN250
TARGDEFS=/D_AFXDLLEX

LFLAGS=/NOD /NOE /ONERROR:NOEXE /PACKDATA /NOPACKCODE /BATCH
# /NOPACKCODE => keep MFC library segmentation

!if "$(DEBUG)"!="0"
# Debug DLL build
TARG=$(TARG)D
OBJ_LIB=$D
RCDEFINES=/D_DEBUG
LFLAGS=$(LFLAGS)
MFCDLL=..\lib\mfc250d.lib
PCH_FILE=$$DLLD\stdafxn.pch
PCH_CPP=dllnet

!ELSE
# Release DLL build
OBJ_LIB=$D
RCDEFINES=
LFLAGS=$(LFLAGS) /AL:16
MFCDLL=..\lib\mfc250.lib
PCH_FILE=$$DLL\stdafxn.pch
PCH_CPP=dllnet

!ENDIF

!ifdef RELEASE # Release VERSION info
RCDEFINES=$(RCDEFINES) /DRELEASE
!endif

dll_goal: create2.dir $(TARG).dll ..\lib\$(TARG).lib

#############################################################################
# import most rules and library files from normal makefile

!include makefile

!if "$(CODEVIEW)"=="1"
TARGOPTS_LIB=/Z7
LFLAGS=$(LFLAGS) /CODEVIEW
!endif

create2.dir:
	@-if not exist $D\*.* mkdir $D
	@-if not exist $(OBJ_LIB)\*.* mkdir $(OBJ_LIB)

#############################################################################
# Debug target

$D\$(TARG).res: mfcnet.rc
	rc /r $(RCDEFINES) /fo $D\$(TARG).res mfcnet.rc

DLLOBJS=$(SOCKETS)

$(TARG).dll: $D\dllnet.obj $(DLLOBJS) $(TARG).def $D\$(TARG).res
	@echo Creating DLL: $(TARG).DLL
	link $(LFLAGS) @<<
$D\dllnet.obj+
$(DLLOBJS: =+
),
$(TARG).dll,
$D\$(TARG).map /MAP:ADDRESS,
$(MFCDLL) winsock ldllcew libw commdlg shell,
$(TARG).def;
<<
	rc /31 /t $D\$(TARG).res $(TARG).dll

# import library
..\lib\$(TARG).lib: $(TARG).def $(AFXDLL_OBJ) $(SLIB_OBJ)
	if exist $@ del $@
	implib /NOWEP $@ $(TARG).def

#############################################################################
