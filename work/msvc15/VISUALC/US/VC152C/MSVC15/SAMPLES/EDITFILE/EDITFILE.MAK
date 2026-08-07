# Microsoft Visual C++ generated build script - Do not modify

PROJ = EDITFILE
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
FIRSTC = EDITFILE.C  
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /W3 /AS /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /W3 /AS /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO  
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw commdlg.lib 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw commdlg.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = EDITFILE.DEF
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
SBRS = EDITFILE.SBR


EDITFILE_DEP = editfile.h


all:	$(PROJ).EXE $(PROJ).BSC

EDITFILE.OBJ:	EDITFILE.C $(EDITFILE_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c EDITFILE.C

EDITFILE.RES:	EDITFILE.RC $(EDITFILE_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r EDITFILE.RC


$(PROJ).EXE::	EDITFILE.RES

$(PROJ).EXE::	EDITFILE.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
EDITFILE.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) EDITFILE.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	EDITFILE.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) EDITFILE.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
