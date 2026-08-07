# Microsoft Visual C++ generated build script - Do not modify

PROJ = MCITEST
DEBUG = 1
PROGTYPE = 0
CALLER = 
ARGS = 
DLLS = 
D_RCDEFINES = 
R_RCDEFINES = 
ORIGIN = MSVC
ORIGIN_VER =1.00
PROJPATH =UNKNOWN
USEMFC = 0
CC = cl
CPP = cl
CXX = cl
CCREATEPCHFLAG = 
CPPCREATEPCHFLAG = 
CUSEPCHFLAG = 
CPPUSEPCHFLAG = 
FIRSTC = DLGOPEN.C   
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /Zp1 /Od /D "_DEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /Zp1 /Ox /D "NDEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:8000 /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:8000 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib  libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib  libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = MCITEST.DEF
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_WEXE)
LFLAGS = $(LFLAGS_D_WEXE)
LIBS = $(LIBS_D_WEXE)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
!else
CFLAGS = $(CFLAGS_R_WEXE)
LFLAGS = $(LFLAGS_R_WEXE)
LIBS = $(LIBS_R_WEXE)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = DLGOPEN.SBR \
		EDIT.SBR \
		MCITEST.SBR


DLGOPEN_DEP = dlgopen.h


EDIT_DEP = gmem.h \
	edit.h


MCITEST_DEP = mcitest.h \
	edit.h \
	dlgopen.h


MCITEST_RCDEP = mcitest.ico


all:	$(PROJ).EXE $(PROJ).BSC

DLGOPEN.OBJ:	DLGOPEN.C $(DLGOPEN_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c DLGOPEN.C

EDIT.OBJ:	EDIT.C $(EDIT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c EDIT.C

MCITEST.OBJ:	MCITEST.C $(MCITEST_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c MCITEST.C

MCITEST.RES:	MCITEST.RC $(MCITEST_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r MCITEST.RC


$(PROJ).EXE::	MCITEST.RES

$(PROJ).EXE::	DLGOPEN.OBJ EDIT.OBJ MCITEST.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
DLGOPEN.OBJ +
EDIT.OBJ +
MCITEST.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) MCITEST.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	MCITEST.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) MCITEST.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
