# Microsoft Visual C++ generated build script - Do not modify

PROJ = SNOOP
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
FIRSTC = SNOOP.C     
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /W3 /FR /Zp /G2 /D "_DEBUG" /Od /AM /GA /D "_WINDOWS" /Zi
CFLAGS_R_WEXE =/nologo /YX /W3 /FR /Zp /G2 /D "NDEBUG" /Ox /AM /GA /D "_WINDOWS" /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:4096 /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:4096 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew penwin.lib  libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew penwin.lib  libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = SNOOP.DEF
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
SBRS = SNOOP.SBR


SNOOP_DEP = snoop.h


SNOOP_RCDEP = snoop.h \
	snoop.ico


all:	$(PROJ).EXE $(PROJ).BSC

SNOOP.OBJ:	SNOOP.C $(SNOOP_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c SNOOP.C

SNOOP.RES:	SNOOP.RC $(SNOOP_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r SNOOP.RC


$(PROJ).EXE::	SNOOP.RES

$(PROJ).EXE::	SNOOP.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
SNOOP.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) SNOOP.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	SNOOP.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) SNOOP.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
