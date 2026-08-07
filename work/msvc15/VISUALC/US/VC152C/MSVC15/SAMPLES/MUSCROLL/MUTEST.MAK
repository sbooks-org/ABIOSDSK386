# Microsoft Visual C++ generated build script - Do not modify

PROJ = MUTEST
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
FIRSTC = MUSTEST.C   
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /Zp1 /W3 /AM /Od /D "_DEBUG" /D "_WINDOWS" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /Zp1 /W3 /AM /Ox /D "NDEBUG" /D "_WINDOWS" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO  /NOD /STACK:4096 /ALIGN:16 /ONERROR:NOEXE /CO 
LFLAGS_R_WEXE =/NOLOGO  /NOD /STACK:4096 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew libw 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = MUSTEST.DEF
OBJS_EXT = 
LIBS_EXT = MUSCROLL.LIB 
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
SBRS = MUSTEST.SBR


MUSCROLL_DEP = 

MUSTEST_DEP = muscroll.h \
	mustest.h


MUSTEST_RCDEP = mustest.ico


all:	$(PROJ).EXE $(PROJ).BSC

MUSTEST.OBJ:	MUSTEST.C $(MUSTEST_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c MUSTEST.C

MUSTEST.RES:	MUSTEST.RC $(MUSTEST_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r MUSTEST.RC


$(PROJ).EXE::	MUSTEST.RES

$(PROJ).EXE::	MUSTEST.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
MUSTEST.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
MUSCROLL.LIB+
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) MUSTEST.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	MUSTEST.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) MUSTEST.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
