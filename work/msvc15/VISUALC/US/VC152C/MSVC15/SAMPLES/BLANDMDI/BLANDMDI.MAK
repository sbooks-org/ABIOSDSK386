# Microsoft Visual C++ generated build script - Do not modify

PROJ = BLANDMDI
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
FIRSTC = BLANDINI.C  
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /W3 /AS /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /W3 /AS /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:8192 /ALIGN:16 /ONERROR:NOEXE /CO 
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:8192 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw commdlg.lib olecli.lib olesvr.lib shell.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  
RUNFLAGS = 
DEFFILE = BLANDMDI.DEF
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
SBRS = BLANDINI.SBR \
		BLANDMDI.SBR


BLANDINI_DEP = blandmdi.h


BLANDMDI_DEP = blandmdi.h


BLANDMDI_RCDEP = blandmdi.h \
	mdiframe.ico \
	mdichild.ico


all:    $(PROJ).EXE $(PROJ).BSC

BLANDINI.OBJ:   BLANDINI.C $(BLANDINI_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c BLANDINI.C

BLANDMDI.OBJ:   BLANDMDI.C $(BLANDMDI_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c BLANDMDI.C

BLANDMDI.RES:   BLANDMDI.RC $(BLANDMDI_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r BLANDMDI.RC


$(PROJ).EXE::   BLANDMDI.RES

$(PROJ).EXE::   BLANDINI.OBJ BLANDMDI.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
BLANDINI.OBJ +
BLANDMDI.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) BLANDMDI.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::   BLANDMDI.RES
	if not exist MSVC.BND   $(RC) $(RESFLAGS) BLANDMDI.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
