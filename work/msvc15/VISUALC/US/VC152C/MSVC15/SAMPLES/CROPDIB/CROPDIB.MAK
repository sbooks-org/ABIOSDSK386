# Microsoft Visual C++ generated build script - Do not modify

PROJ = CROPDIB
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
FIRSTC = CROPDIB.C   
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /Zp1 /Od /D "_DEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /Zp1 /Ox /D "NDEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:4096 /CO
LFLAGS_R_WEXE =/NOLOGO /ONERROR:NOEXE /ALIGN:16 /NOD /STACK:4096
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = CROPDIB.DEF
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
SBRS = CROPDIB.SBR \
		DIB.SBR


CROPDIB_DEP = cropdib.h \
	dib.h


DIB_DEP = dib.h


CROPDIB_RCDEP = cropdib.ico


all:	$(PROJ).EXE $(PROJ).BSC

CROPDIB.OBJ:	CROPDIB.C $(CROPDIB_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c CROPDIB.C

DIB.OBJ:	DIB.C $(DIB_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DIB.C

CROPDIB.RES:	CROPDIB.RC $(CROPDIB_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r CROPDIB.RC


$(PROJ).EXE::	CROPDIB.RES

$(PROJ).EXE::	CROPDIB.OBJ DIB.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
CROPDIB.OBJ +
DIB.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) CROPDIB.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	CROPDIB.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) CROPDIB.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
