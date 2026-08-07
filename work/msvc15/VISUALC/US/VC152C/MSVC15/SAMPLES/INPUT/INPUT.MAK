# Microsoft Visual C++ generated build script - Do not modify

PROJ = INPUT
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
FIRSTC = INPUT.C     
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /Zp1 /Od /D "_DEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /Zp1 /Ox /D "NDEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:8192 /CO
LFLAGS_R_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:8192
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew LIBW
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew LIBW
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = INPUT.DEF
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
SBRS = INPUT.SBR


INPUT_DEP = input.h


all:	$(PROJ).EXE $(PROJ).BSC

INPUT.OBJ:	INPUT.C $(INPUT_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c INPUT.C

INPUT.RES:	INPUT.RC $(INPUT_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r INPUT.RC


$(PROJ).EXE::	INPUT.RES

$(PROJ).EXE::	INPUT.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
INPUT.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) INPUT.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	INPUT.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) INPUT.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
