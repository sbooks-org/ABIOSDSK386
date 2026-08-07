# Microsoft Visual C++ generated build script - Do not modify

PROJ = LOWPASS
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
FIRSTC = LOWPASS.C   
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /Zp1 /Od /D "_DEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /Zp1 /Ox /D "NDEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:4096 /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:4096 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib  libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib  libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = LOWPASS.DEF
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
SBRS = LOWPASS.SBR


LOWPASS_DEP = lowpass.h


LOWPASS_RCDEP = lowpass.h \
	lowpass.ico


all:	$(PROJ).EXE $(PROJ).BSC

LOWPASS.OBJ:	LOWPASS.C $(LOWPASS_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c LOWPASS.C

LOWPASS.RES:	LOWPASS.RC $(LOWPASS_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r LOWPASS.RC


$(PROJ).EXE::	LOWPASS.RES

$(PROJ).EXE::	LOWPASS.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
LOWPASS.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) LOWPASS.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	LOWPASS.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) LOWPASS.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
