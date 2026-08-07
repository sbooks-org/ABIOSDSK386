# Microsoft Visual C++ generated build script - Do not modify

PROJ = MYPAL
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
FIRSTC = MYPAL.C     
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /Zp1 /W3 /AS /Od /D "_DEBUG" /D "_WINDOWS" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /Zp1 /W3 /AS /Ox /D "NDEBUG" /D "_WINDOWS" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:8192 /CO
LFLAGS_R_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:8192
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = MYPAL.DEF
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
SBRS = MYPAL.SBR


MYPAL_DEP = mypal.h


MYPAL_RCDEP = mypal.h \
	mypal.ico


all:	$(PROJ).EXE $(PROJ).BSC

MYPAL.OBJ:	MYPAL.C $(MYPAL_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c MYPAL.C

MYPAL.RES:	MYPAL.RC $(MYPAL_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r MYPAL.RC


$(PROJ).EXE::	MYPAL.RES

$(PROJ).EXE::	MYPAL.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
MYPAL.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) MYPAL.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	MYPAL.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) MYPAL.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
