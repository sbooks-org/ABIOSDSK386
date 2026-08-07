# Microsoft Visual C++ generated build script - Do not modify

PROJ = MUSCROLL
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
FIRSTC = MUSCROLL.C  
FIRSTCPP =             
RC = rc
CFLAGS_D_WDLL =/nologo /YX /G2 /Zp1 /W3 /AM /Od /D "_DEBUG" /D "_WINDLL" /D "_WINDOWS" /FR /GA /Zi
CFLAGS_R_WDLL =/nologo /YX /G2 /Zp1 /W3 /AM /Ox /D "NDEBUG" /D "_WINDLL" /D "_WINDOWS" /FR /GA /Gs
LFLAGS_D_WDLL =/NOLOGO /NOD /NOE /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WDLL =/NOLOGO /NOD /NOE /ALIGN:16 /ONERROR:NOEXE
LIBS_D_WDLL = oldnames libw commdlg shell olecli olesvr mdllcew libw 
LIBS_R_WDLL = oldnames libw commdlg shell olecli olesvr mdllcew libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = MUSCROLL.DEF
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
SBRS = MUSCROLL.SBR \
		WEP.SBR \
		INIT.SBR \
		CTLDLG.SBR \
		PAINT.SBR \
		MSAPI.SBR


MUSCROLL_DEP = muscrdll.h \
	muscroll.h


WEP_DEP = 

INIT_DEP = muscrdll.h \
	muscroll.h


CTLDLG_DEP = muscrdll.h \
	muscroll.h


PAINT_DEP = muscrdll.h \
	muscroll.h


MSAPI_DEP = muscrdll.h \
	muscroll.h


all:	$(PROJ).DLL $(PROJ).BSC

MUSCROLL.OBJ:	MUSCROLL.C $(MUSCROLL_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c MUSCROLL.C

WEP.OBJ:	WEP.C $(WEP_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c WEP.C

INIT.OBJ:	INIT.C $(INIT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c INIT.C

CTLDLG.OBJ:	CTLDLG.C $(CTLDLG_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c CTLDLG.C

PAINT.OBJ:	PAINT.C $(PAINT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c PAINT.C

MSAPI.OBJ:	MSAPI.C $(MSAPI_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c MSAPI.C

MUSCROLL.RES:	MUSCROLL.RC $(MUSCROLL_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r MUSCROLL.RC


$(PROJ).DLL::	MUSCROLL.RES

$(PROJ).DLL::	MUSCROLL.OBJ WEP.OBJ INIT.OBJ CTLDLG.OBJ PAINT.OBJ MSAPI.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
MUSCROLL.OBJ +
WEP.OBJ +
INIT.OBJ +
CTLDLG.OBJ +
PAINT.OBJ +
MSAPI.OBJ +
$(OBJS_EXT)
$(PROJ).DLL
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) MUSCROLL.RES $@
	@copy $(PROJ).CRF MSVC.BND
	implib /nowep $(PROJ).LIB $(PROJ).DLL

$(PROJ).DLL::	MUSCROLL.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) MUSCROLL.RES $@

run: $(PROJ).DLL
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
