# Microsoft Visual C++ generated build script - Do not modify

PROJ = DBWIN
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
FIRSTC = DBWIN.C     
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /Zp1 /W3 /AS /Od /D "_DEBUG" /D "_WINDOWS" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /Zp1 /W3 /AS /Ox /D "NDEBUG" /D "_WINDOWS" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew commdlg.lib  libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew commdlg.lib  libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = DBWIN.DEF
OBJS_EXT = 
LIBS_EXT = DBWINDLL.LIB 
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
SBRS = DBWIN.SBR \
		SETDB.SBR \
		ALLOCBRK.SBR


DBWINDLL_DEP = 

DBWIN_DEP = dbwin.h \
	dbwindll.h


SETDB_DEP = dbwin.h \
	dbwindll.h


ALLOCBRK_DEP = dbwin.h \
	dbwindll.h


DBWIN_RCDEP = dbwin.ico \
	dbwin.ver


all:	$(PROJ).EXE $(PROJ).BSC

DBWIN.OBJ:	DBWIN.C $(DBWIN_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c DBWIN.C

SETDB.OBJ:	SETDB.C $(SETDB_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c SETDB.C

ALLOCBRK.OBJ:	ALLOCBRK.C $(ALLOCBRK_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c ALLOCBRK.C

DBWIN.RES:	DBWIN.RC $(DBWIN_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r DBWIN.RC


$(PROJ).EXE::	DBWIN.RES

$(PROJ).EXE::	DBWIN.OBJ SETDB.OBJ ALLOCBRK.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
DBWIN.OBJ +
SETDB.OBJ +
ALLOCBRK.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
DBWINDLL.LIB+
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) DBWIN.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	DBWIN.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) DBWIN.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
