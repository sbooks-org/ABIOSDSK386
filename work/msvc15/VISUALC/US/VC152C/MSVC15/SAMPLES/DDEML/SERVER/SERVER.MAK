# Microsoft Visual C++ generated build script - Do not modify

PROJ = SERVER
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
FIRSTC = DDE.C       
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /W3 /AS /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /W3 /AS /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /NOE /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO  
LFLAGS_R_WEXE =/NOLOGO /NOD /NOE /STACK:5120 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw slibcew libw.lib ddeml.lib 
LIBS_R_WEXE = oldnames libw slibcew libw.lib ddeml.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  /t 
RUNFLAGS = 
DEFFILE = DDEMLSV.DEF
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
SBRS = DDE.SBR \
		DDEMLSV.SBR \
		DIALOG.SBR \
		HUGE.SBR


DDE_DEP = ddemlsv.h \
	huge.h


DDEMLSV_DEP = ddemlsv.h \
	huge.h


DDEMLSV_RCDEP = ddemlsv.ico


DIALOG_DEP = ddemlsv.h \
	huge.h


HUGE_DEP = ddemlsv.h \
	huge.h


all:	$(PROJ).EXE $(PROJ).BSC

DDE.OBJ:	DDE.C $(DDE_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c DDE.C

DDEMLSV.OBJ:	DDEMLSV.C $(DDEMLSV_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DDEMLSV.C

DDEMLSV.RES:	DDEMLSV.RC $(DDEMLSV_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r DDEMLSV.RC

DIALOG.OBJ:	DIALOG.C $(DIALOG_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DIALOG.C

HUGE.OBJ:	HUGE.C $(HUGE_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c HUGE.C


$(PROJ).EXE::	DDEMLSV.RES

$(PROJ).EXE::	DDE.OBJ DDEMLSV.OBJ DIALOG.OBJ HUGE.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
DDE.OBJ +
DDEMLSV.OBJ +
DIALOG.OBJ +
HUGE.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) DDEMLSV.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	DDEMLSV.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) DDEMLSV.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
