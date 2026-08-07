# Microsoft Visual C++ generated build script - Do not modify

PROJ = BOUNCER
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
FIRSTC = BOUNCER.C   
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /Zp1 /W3 /Od /D "_DEBUG" /D "_WINDOWS" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /Zp1 /W3 /Ox /D "NDEBUG" /D "_WINDOWS" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOI /NOD /STACK:5000 /ALIGN:16 /ONERROR:NOEXE /CO 
LFLAGS_R_WEXE =/NOLOGO /NOI /NOD /STACK:5000 /ALIGN:16 /ONERROR:NOEXE
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib scrnsave.lib  libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib scrnsave.lib  libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = BOUNCER.DEF
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
SBRS = BOUNCER.SBR


BOUNCER_DEP = bouncer.h


BOUNCER_RCDEP = bouncer.h \
	bouncer.ico


all:	$(PROJ).EXE $(PROJ).BSC

BOUNCER.OBJ:	BOUNCER.C $(BOUNCER_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c BOUNCER.C

BOUNCER.RES:	BOUNCER.RC $(BOUNCER_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r BOUNCER.RC


$(PROJ).EXE::	BOUNCER.RES

$(PROJ).EXE::	BOUNCER.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
BOUNCER.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) BOUNCER.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	BOUNCER.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) BOUNCER.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
