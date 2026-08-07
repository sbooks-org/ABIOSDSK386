# Microsoft Visual C++ generated build script - Do not modify

PROJ = CDDEMO
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
FIRSTC = CDDEMO.C    
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /W3 /AM /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /W3 /AM /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:8192 /ALIGN:16 /ONERROR:NOEXE /CO  
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:8192 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew libw commdlg.lib 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew libw commdlg.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = CDDEMO.DEF
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
SBRS = CDDEMO.SBR \
		ERROR.SBR \
		INIT.SBR


CDDEMO_DEP = cddemo.h


ERROR_DEP = cddemo.h


INIT_DEP = cddemo.h


all:	$(PROJ).EXE $(PROJ).BSC

CDDEMO.OBJ:	CDDEMO.C $(CDDEMO_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c CDDEMO.C

CDDEMO.RES:	CDDEMO.RC $(CDDEMO_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r CDDEMO.RC

ERROR.OBJ:	ERROR.C $(ERROR_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c ERROR.C

INIT.OBJ:	INIT.C $(INIT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c INIT.C


$(PROJ).EXE::	CDDEMO.RES

$(PROJ).EXE::	CDDEMO.OBJ ERROR.OBJ INIT.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
CDDEMO.OBJ +
ERROR.OBJ +
INIT.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) CDDEMO.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	CDDEMO.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) CDDEMO.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
