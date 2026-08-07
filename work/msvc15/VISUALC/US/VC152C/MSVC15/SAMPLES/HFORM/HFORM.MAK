# Microsoft Visual C++ generated build script - Do not modify

PROJ = HFORM
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
FIRSTC =             
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /W3 /FR /Zp /G2 /D "_DEBUG" /Od /AM /GA /D "_WINDOWS" /Zi
CFLAGS_R_WEXE =/nologo /YX /W3 /FR /Zp /G2 /D "NDEBUG" /Ox /AM /GA /D "_WINDOWS" /Gs
LFLAGS_D_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:4096 /CO
LFLAGS_R_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:4096
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew LIBW
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew LIBW
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = HFORM.DEF
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
SBRS = HFORM.SBR


HFORM_DEP = hfres.h \
	hform.h


HFORM_RCDEP = hfres.h \
	hform.ico


all:	$(PROJ).EXE $(PROJ).BSC

HFORM.OBJ:	HFORM.C $(HFORM_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c HFORM.C

HFORM.RES:	HFORM.RC $(HFORM_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r HFORM.RC


$(PROJ).EXE::	HFORM.RES

$(PROJ).EXE::	HFORM.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
HFORM.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) HFORM.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	HFORM.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) HFORM.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
