# Microsoft Visual C++ generated build script - Do not modify

PROJ = FILEOPEN
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
FIRSTC = FILEOPEN.C  
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /Zp1 /W3 /AM /Od /D "_DEBUG" /D "_WINDOWS" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /Zp1 /W3 /AM /Ox /D "NDEBUG" /D "_WINDOWS" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO  
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew libw commdlg.lib 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew libw commdlg.lib
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = FILEOPEN.DEF
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
SBRS = FILEOPEN.SBR


FILEOPEN_DEP = fileopen.h


all:	$(PROJ).EXE $(PROJ).BSC

FILEOPEN.OBJ:	FILEOPEN.C $(FILEOPEN_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c FILEOPEN.C

FILEOPEN.RES:	FILEOPEN.RC $(FILEOPEN_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r FILEOPEN.RC


$(PROJ).EXE::	FILEOPEN.RES

$(PROJ).EXE::	FILEOPEN.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
FILEOPEN.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) FILEOPEN.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	FILEOPEN.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) FILEOPEN.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
