# Microsoft Visual C++ generated build script - Do not modify

PROJ = DBWINDLL
DEBUG = 1
PROGTYPE = 1
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
FIRSTC = DBWINDLL.C  
FIRSTCPP =             
RC = rc
CFLAGS_D_WDLL =/nologo /YX /G2 /Zp1 /W3 /AM /Od /D "_DEBUG" /D "_WINDOWS" /D "_WINDLL" /FR /GD /Zi
CFLAGS_R_WDLL =/nologo /YX /G2 /Zp1 /W3 /AM /Ox /D "NDEBUG" /D "_WINDOWS" /D "_WINDLL" /FR /GD /Gs
LFLAGS_D_WDLL =/NOLOGO /NOD /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WDLL =/NOLOGO /NOD /ALIGN:16 /ONERROR:NOEXE
LIBS_D_WDLL = oldnames libw commdlg shell olecli olesvr mdllcew libw toolhelp.lib
LIBS_R_WDLL = oldnames libw commdlg shell olecli olesvr mdllcew libw toolhelp.lib
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = DBWINDLL.DEF
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_WDLL)
LFLAGS = $(LFLAGS_D_WDLL)
LIBS = $(LIBS_D_WDLL)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
!else
CFLAGS = $(CFLAGS_R_WDLL)
LFLAGS = $(LFLAGS_R_WDLL)
LIBS = $(LIBS_R_WDLL)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = DBWINDLL.SBR \
		MONOOUT.SBR \
		COMOUT.SBR \
		NFYFMT.SBR


DBWINDLL_DEP = dbwindlp.h \
	dbwindll.h


MONOOUT_DEP = dbwindlp.h \
	dbwindll.h


COMOUT_DEP = dbwindlp.h \
	dbwindll.h


NFYFMT_DEP = dbwindlp.h \
	dbwindll.h


DBWINDLL_RCDEP = dbwindll.h \
	dbwindll.ver


all:	$(PROJ).DLL $(PROJ).BSC

DBWINDLL.OBJ:	DBWINDLL.C $(DBWINDLL_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c DBWINDLL.C

MONOOUT.OBJ:	MONOOUT.C $(MONOOUT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c MONOOUT.C

COMOUT.OBJ:	COMOUT.C $(COMOUT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c COMOUT.C

NFYFMT.OBJ:	NFYFMT.C $(NFYFMT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c NFYFMT.C

DBWINDLL.RES:	DBWINDLL.RC $(DBWINDLL_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r DBWINDLL.RC


$(PROJ).DLL::	DBWINDLL.RES

$(PROJ).DLL::	DBWINDLL.OBJ MONOOUT.OBJ COMOUT.OBJ NFYFMT.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
DBWINDLL.OBJ +
MONOOUT.OBJ +
COMOUT.OBJ +
NFYFMT.OBJ +
$(OBJS_EXT)
$(PROJ).DLL
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) DBWINDLL.RES $@
	@copy $(PROJ).CRF MSVC.BND
	implib /nowep $(PROJ).LIB $(PROJ).DLL

$(PROJ).DLL::	DBWINDLL.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) DBWINDLL.RES $@

run: $(PROJ).DLL
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
