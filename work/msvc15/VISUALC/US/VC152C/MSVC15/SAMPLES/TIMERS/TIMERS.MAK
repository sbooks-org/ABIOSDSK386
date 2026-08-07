# Microsoft Visual C++ generated build script - Do not modify

PROJ = TIMERS
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
FIRSTC = TIMERS.C    
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /W3 /AS /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /W3 /AS /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:4096 /ALIGN:16 /ONERROR:NOEXE /CO  
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:4096 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw toolhelp.lib 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw toolhelp.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  /t 
RUNFLAGS = 
DEFFILE = TIMERS.DEF
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
SBRS = TIMERS.SBR


all:	$(PROJ).EXE $(PROJ).BSC

TIMERS.OBJ:	TIMERS.C $(TIMERS_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c TIMERS.C

TIMERS.RES:	TIMERS.RC $(TIMERS_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r TIMERS.RC


$(PROJ).EXE::	TIMERS.RES

$(PROJ).EXE::	TIMERS.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
TIMERS.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) TIMERS.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	TIMERS.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) TIMERS.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
