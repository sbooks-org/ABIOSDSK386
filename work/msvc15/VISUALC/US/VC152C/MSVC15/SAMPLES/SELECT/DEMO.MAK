# Microsoft Visual C++ generated build script - Do not modify

PROJ = DEMO
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
FIRSTC = DEMO.C      
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /Zp1 /Od /D "_DEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /Zp1 /Ox /D "NDEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO 
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew LIBW
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew LIBW
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = DEMO.DEF
OBJS_EXT = 
LIBS_EXT = SELECT.LIB 
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
SBRS = DEMO.SBR


SELECT_DEP = 

DEMO_DEP = demo.h \
	select.h


all:	$(PROJ).EXE $(PROJ).BSC

DEMO.OBJ:	DEMO.C $(DEMO_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c DEMO.C

DEMO.RES:	DEMO.RC $(DEMO_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r DEMO.RC


$(PROJ).EXE::	DEMO.RES

$(PROJ).EXE::	DEMO.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
DEMO.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
SELECT.LIB+
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) DEMO.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	DEMO.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) DEMO.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
