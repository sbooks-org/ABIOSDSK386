# Microsoft Visual C++ generated build script - Do not modify

PROJ = ROTARY
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
FIRSTC = ROTARY.C    
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /Zp1 /Od /D "_DEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /Zp1 /Ox /D "NDEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:5000 /CO
LFLAGS_R_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:5000
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = ROTARY.DEF
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
SBRS = ROTARY.SBR


ROTARY_DEP = rotary.h


all:	$(PROJ).EXE $(PROJ).BSC

ROTARY.OBJ:	ROTARY.C $(ROTARY_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c ROTARY.C

ROTARY.RES:	ROTARY.RC $(ROTARY_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r ROTARY.RC


$(PROJ).EXE::	ROTARY.RES

$(PROJ).EXE::	ROTARY.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
ROTARY.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) ROTARY.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	ROTARY.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) ROTARY.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
