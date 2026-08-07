# Microsoft Visual C++ generated build script - Do not modify

PROJ = GWAPI
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
FIRSTC = GWAPI.C     
FIRSTCPP =             
RC = rc
CFLAGS_D_WDLL =/nologo /YX /G2 /Zp1 /W3 /AM /Od /D "_DEBUG" /FR /GD /Zi
CFLAGS_R_WDLL =/nologo /YX /G2 /Zp1 /W3 /AM /Ox /D "NDEBUG" /FR /GD /Gs
LFLAGS_D_WDLL =/NOLOGO /NOD /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WDLL =/NOLOGO /NOD /ALIGN:16 /ONERROR:NOEXE
LIBS_D_WDLL = oldnames libw commdlg shell olecli olesvr mdllcew libw.lib penwin.lib 
LIBS_R_WDLL = oldnames libw commdlg shell olecli olesvr mdllcew libw.lib penwin.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  /t 
RUNFLAGS = 
DEFFILE = GWAPI.DEF
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
SBRS = GWAPI.SBR


GWAPI_DEP = 

all:	$(PROJ).DLL $(PROJ).BSC

GWAPI.OBJ:	GWAPI.C $(GWAPI_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c GWAPI.C


$(PROJ).DLL::	GWAPI.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
GWAPI.OBJ +
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
