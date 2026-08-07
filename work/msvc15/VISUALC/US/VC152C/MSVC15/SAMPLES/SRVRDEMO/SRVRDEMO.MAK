# Microsoft Visual C++ generated build script - Do not modify

PROJ = SRVRDEMO
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
FIRSTC = DOC.C       
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /Zp1 /W3 /AS /Od /D "_DEBUG" /FR /GA /Zid
CFLAGS_R_WEXE =/nologo /YX /G2 /Zp1 /W3 /AS /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:16000 /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:16000 /ALIGN:16 /ONERROR:NOEXE
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw slibcew commdlg.lib olesvr.lib 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw slibcew commdlg.lib olesvr.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  
RUNFLAGS = 
DEFFILE = SRVRDEMO.DEF
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
SBRS = DOC.SBR \
		FILE.SBR \
		OBJ.SBR \
		SERVER.SBR \
		SRVRDEMO.SBR


DOC_DEP = srvrdemo.h


FILE_DEP = srvrdemo.h


OBJ_DEP = srvrdemo.h


SERVER_DEP = srvrdemo.h


SRVRDEMO_DEP = srvrdemo.h


SRVRDEMO_RCDEP = srvrdemo.ico


all:	$(PROJ).EXE $(PROJ).BSC

DOC.OBJ:	DOC.C $(DOC_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c DOC.C

FILE.OBJ:	FILE.C $(FILE_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c FILE.C

OBJ.OBJ:	OBJ.C $(OBJ_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c OBJ.C

SERVER.OBJ:	SERVER.C $(SERVER_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c SERVER.C

SRVRDEMO.OBJ:	SRVRDEMO.C $(SRVRDEMO_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c SRVRDEMO.C

SRVRDEMO.RES:	SRVRDEMO.RC $(SRVRDEMO_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r SRVRDEMO.RC


$(PROJ).EXE::	SRVRDEMO.RES

$(PROJ).EXE::	DOC.OBJ FILE.OBJ OBJ.OBJ SERVER.OBJ SRVRDEMO.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
DOC.OBJ +
FILE.OBJ +
OBJ.OBJ +
SERVER.OBJ +
SRVRDEMO.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) SRVRDEMO.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	SRVRDEMO.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) SRVRDEMO.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
