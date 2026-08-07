# Microsoft Visual C++ generated build script - Do not modify

PROJ = VERSTAMP
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
FIRSTC = VERSTAMP.C  
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /W3 /AS /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /W3 /AS /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:6044 /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:6044 /ALIGN:16 /ONERROR:NOEXE
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw commdlg.lib lzexpand.lib ver.lib 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw commdlg.lib lzexpand.lib ver.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  
RUNFLAGS = 
DEFFILE = VERSTAMP.DEF
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
SBRS = VERSTAMP.SBR


VERSTAMP_DEP = verstamp.h


VERSTAMP_RCDEP = verstamp.h \
	verstamp.ico


all:	$(PROJ).EXE $(PROJ).BSC

VERSTAMP.OBJ:	VERSTAMP.C $(VERSTAMP_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c VERSTAMP.C

VERSTAMP.RES:	VERSTAMP.RC $(VERSTAMP_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r VERSTAMP.RC


$(PROJ).EXE::	VERSTAMP.RES

$(PROJ).EXE::	VERSTAMP.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
VERSTAMP.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) VERSTAMP.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	VERSTAMP.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) VERSTAMP.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
