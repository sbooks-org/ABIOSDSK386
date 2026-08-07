# Microsoft Visual C++ generated build script - Do not modify

PROJ = CURSOR
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
FIRSTC = CURSOR.C    
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /AS /Od /D "_DEBUG" /D "_WINDOWS" /G2 /Zp1 /W3 /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /AS /Ox /D "NDEBUG" /D "_WINDOWS" /G2 /Zp1 /W3 /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOI /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO 
LFLAGS_R_WEXE =/NOLOGO /NOI /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  /t 
RUNFLAGS = 
DEFFILE = CURSOR.DEF
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
SBRS = CURSOR.SBR


CURSOR_DEP = cursor.h


CURSOR_RCDEP = bullseye.cur


all:	$(PROJ).EXE $(PROJ).BSC

CURSOR.OBJ:	CURSOR.C $(CURSOR_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c CURSOR.C

CURSOR.RES:	CURSOR.RC $(CURSOR_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r CURSOR.RC


$(PROJ).EXE::	CURSOR.RES

$(PROJ).EXE::	CURSOR.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
CURSOR.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) CURSOR.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	CURSOR.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) CURSOR.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
