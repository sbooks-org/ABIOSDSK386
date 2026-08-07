
# This is a part of the Microsoft Foundation Classes C++ library.
# Copyright (C) 1992 Microsoft Corporation
# All rights reserved.
#
# This source code is only intended as a supplement to the
# Microsoft Foundation Classes Reference and Microsoft
# QuickHelp and/or WinHelp documentation provided with the library.
# See these sources for detailed information regarding the
# Microsoft Foundation Classes product.

# Common include for building MFC Sample programs
#
#  typical usage
#       PROJ = foo
#       OBJS = foo.obj bar.obj ...
#       !INCLUDE ..\SAMPLE_.MAK
#
# NOTE: do not include 'stdafx.obj' in the OBJS list - the correctly
#    built version will be included for you
#
# Options to NMAKE:
#     "AFXDLL=1" => build a DLL client app (default static MFC library)
#     "DEBUG=0" => use retail (default debug)
#     "OPT" => use to set custom compile options
#     "BROWSE=1" => build Visual C++ compatible browse file (.BSC file)

!ifndef PROJ
	!ERROR You forgot to define 'PROJ' !!
!endif
!ifndef OBJS
	!ERROR You forgot to define 'OBJS' !!
!endif

!if "$(DEBUG)"!="0"
DEBUGSUF=D
!endif

!if "$(AFXDLL)"!="1"
# static link library variant [medium model] - the default
STDAFX=stdafx
CPPMAIN_FLAGS=/AM /Zp /GA /G2 /Gyf
LIBS=mlibcew
AFXLIB=mafxcw$(DEBUGSUF)
!else
# dynamic link library variant [large model]
STDAFX=stdafxe
CPPMAIN_FLAGS=/AL /Zp /GA /GEf /GEs /Gs /G2 /Gyf /D_AFXDLL
RCFLAGS=$(RCFLAGS) /D_AFXDLL
LIBS=llibcew
AFXLIB=mfc250$(DEBUGSUF)
!ifdef USES_OLE
AFXLIB=$(AFXLIB) mfco250$(DEBUGSUF)
!endif
!ifdef USES_DB
AFXLIB=$(AFXLIB) mfcd250$(DEBUGSUF)
!endif
!endif #//AFXDLL

!ifdef USES_VBX
# special settings for VBX enabled apps
STACK=/STACK:20480
!else
STACK=/STACK:10240
!endif

!ifdef USES_OLE
# special settings for OLE enabled apps
WIN31ONLY=1
STACK=/STACK:12288
LIBS=$(LIBS) mfcoleui compobj storage ole2 ole2disp
!endif

!ifdef USES_DB
LIBS=$(LIBS) odbc
!endif

!if "$(DEBUG)"!="0"
# debug variant - the default
CPPMAIN_FLAGS=/D_DEBUG $(CPPMAIN_FLAGS) /Od /Z7
LINKFLAGS=/NOD /ONERR:NOEXE $(STACK) /CODEVIEW
STDAFX=$(STDAFX)d
!else
# retail variant
CPPMAIN_FLAGS=$(CPPMAIN_FLAGS) /O1
LINKFLAGS=/AL:16 /NOD /ONERR:NOEXE $(STACK)
!endif #//DEBUG

!if "$(OPT)"!=""
CPPMAIN_FLAGS=$(CPPMAIN_FLAGS) $(OPT)
!endif

LIBS=$(AFXLIB) $(LIBS) libw commdlg shell $(EXTRA_LIBS)
CPPFLAGS=$(CPPMAIN_FLAGS) /W3 /Yustdafx.h /Fp..\$(STDAFX).pch $(EXTRA_FLAGS)

!if "$(BROWSE)"=="1"
CPPFLAGS=$(CPPFLAGS) /FR
SBRS=$(OBJS:.obj=.sbr)
all: $(PROJ).exe $(PROJ).bsc
!endif

#############################################################################

$(PROJ).exe: ..\$(STDAFX).obj $(PROJ).res $(PROJ).def $(OBJS)
	link $(LINKFLAGS) @<<
$(OBJS) ..\$(STDAFX).obj,
$(PROJ),NUL,$(LIBS),$(PROJ).def;
<<
	rc /31 /k /t $(PROJ).res

$(OBJS): ..\$(STDAFX).pch

$(PROJ).res:  resource.h
	rc /r /z $(RCFLAGS) $(PROJ).rc

$(PROJ).bsc: $(SBRS) ..\$(STDAFX).sbr
	bscmake @<<
/o$@ $(SBRS) ..\$(STDAFX).sbr
<<

clean::
	-erase $(PROJ).exe
	-erase $(PROJ).res
	-erase $(PROJ).bsc
	-erase *.aps
	-erase *.pdb
	-erase *.pch
	-erase *.map
	-erase *.obj
	-erase *.sbr

#############################################################################
# Shared PCH and PCT files (shared by all samples)

..\$(STDAFX).obj ..\$(STDAFX).pch ..\$(STDAFX).sbr:: ..\stdafx.h ..\stdafx.cpp
	@echo.
	@echo Building shared Pre-Compiled Header/Type files.
	@echo.
!if "$(BROWSE)"=="1"
	$(CPP) @<<
$(CPPMAIN_FLAGS) /W4 /Ycstdafx.h /FR..\$(STDAFX).sbr /Fp..\$(STDAFX).pch /Fo..\$(STDAFX).obj /c ..\stdafx.cpp
<<
!else
	$(CPP) @<<
$(CPPMAIN_FLAGS) /W4 /Ycstdafx.h /Fp..\$(STDAFX).pch /Fo..\$(STDAFX).obj /c ..\stdafx.cpp
<<
!endif

cleanall: clean
	-erase ..\$(STDAFX).pch
	-erase ..\$(STDAFX).obj
	-erase ..\$(STDAFX).sbr

#############################################################################
