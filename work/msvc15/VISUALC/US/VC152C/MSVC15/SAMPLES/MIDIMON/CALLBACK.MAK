# Microsoft Visual C++ generated build script - Do not modify

PROJ = CALLBACK
DEBUG = 1
PROGTYPE = 1
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
FIRSTC = CALLBACK.C  
FIRSTCPP =             
RC = rc
CFLAGS_D_WDLL =/nologo /YX /Zp1 /Od /D "_DEBUG" /D "_WINDOWS" /D "_WINDLL" /G2 /W3 /ASw /FR /GD /Zi
CFLAGS_R_WDLL =/nologo /YX /Zp1 /Ox /D "NDEBUG" /D "_WINDOWS" /D "_WINDLL" /G2 /W3 /ASw /FR /GD /Gs
LFLAGS_D_WDLL =/NOLOGO /NOD /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WDLL =/NOLOGO /NOD /ALIGN:16 /ONERROR:NOEXE
LIBS_D_WDLL = oldnames libw commdlg shell olecli olesvr sdllcew mmsystem.lib  libw
LIBS_R_WDLL = oldnames libw commdlg shell olecli olesvr sdllcew mmsystem.lib  libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = CALLBACK.DEF
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_WDLL)
LFLAGS = $(LFLAGS_D_WDLL)
LIBS = $(LIBS_D_WDLL)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
!else
CFLAGS = $(CFLAGS_R_WDLL)
LFLAGS = $(LFLAGS_R_WDLL)
LIBS = $(LIBS_R_WDLL)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = CALLBACK.SBR


CALLBACK_DEP = midimon.h \
	circbuf.h \
	instdata.h \
	callback.h


all:	$(PROJ).DLL $(PROJ).BSC

CALLBACK.OBJ:	CALLBACK.C $(CALLBACK_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c CALLBACK.C


$(PROJ).DLL::	CALLBACK.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
CALLBACK.OBJ +
$(OBJS_EXT)
$(PROJ).DLL
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) $@
	implib /nowep $(PROJ).LIB $(PROJ).DLL


run: $(PROJ).DLL
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
