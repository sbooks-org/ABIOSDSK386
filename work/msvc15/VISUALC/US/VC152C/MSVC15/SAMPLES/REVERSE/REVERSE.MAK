# Microsoft Visual C++ generated build script - Do not modify

PROJ = REVERSE
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
FIRSTC = REVERSE.C   
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /Zp1 /Od /D "_DEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /Zp1 /Ox /D "NDEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:8192 /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:8192 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib  libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib  libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = REVERSE.DEF
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
SBRS = REVERSE.SBR


REVERSE_RCDEP = reverse.ico


REVERSE_DEP = reverse.h


all:	$(PROJ).EXE $(PROJ).BSC

REVERSE.RES:	REVERSE.RC $(REVERSE_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r REVERSE.RC

REVERSE.OBJ:	REVERSE.C $(REVERSE_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c REVERSE.C


$(PROJ).EXE::	REVERSE.RES

$(PROJ).EXE::	REVERSE.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
REVERSE.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) REVERSE.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	REVERSE.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) REVERSE.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
