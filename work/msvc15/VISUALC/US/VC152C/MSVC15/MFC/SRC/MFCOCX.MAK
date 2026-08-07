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
# The OLE Controls runtime contains a version of MFC built
# specifically to support OLE Custom Controls.  This MAKEFILE
# compiles MFC to a library to be included in the OLE Controls
# runtime DLL.

MODEL=l
TARGET=w
DLL=2
MASMOPT=
LFLAGS=/NOD /NOE /ONERROR:NOEXE /PACKDATA /NOPACKCODE /BATCH
# /NOPACKCODE => keep MFC library segmentation

AFXCTL=1
TARG_DEPEND=time.txt
TARGDEFS=/D_AFXCTL

AFXDLL_OBJ=

dll_goal: create2.dir create.obj

#############################################################################
# import most rules and library files from normal makefile

!include makefile

!if "$(OBJ)" == ""
D=$$CTL$(DEBUGSUF)
!endif

!if "$(CODEVIEW)"=="1"
TARGOPTS_LIB=/Z7
!endif

create2.dir:
	@-if not exist $D\*.* mkdir $D

#############################################################################
# Special rules for building static linked library part

!if 0
# NonShared diagnostics and other hooks (see OBJDIAG in MAKEFILE)
SLIB_OBJ=$(OBJ_LIB)\dumpinit.obj $(OBJ_LIB)\afxasert.obj \
	$(OBJ_LIB)\dumpout.obj $(OBJ_LIB)\oledll.obj \
	$(OBJ_LIB)\afxabort.obj

# _AFXDLL defined (but not _WINDLL)
# TARGOPTS_LIB=$(TARGOPTS_LIB) /GA /GEf /GEs /G2
TARGOPTS_LIB=$(TARGOPTS_LIB) /G2
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
!endif

##############################################################################
# Build object modules for OLE controls runtime DLL
# These files are not put in a library, since this
# would cause the linker to discard object modules
# that are not explicitly referenced by the runtime.
#
# Some OBJs are lib'ed into a static LIB for use in
# the actual control.  This LIB is made dependant on
# all OBJs just to have a time reference.

!include mfcocx1.mak

create.obj: $D\$(TARG_DEPEND)

$D\$(TARG_DEPEND): $(AFXCONTROL_OBJ)
	@echo Built all AFX control object modules. >$@

#############################################################################
