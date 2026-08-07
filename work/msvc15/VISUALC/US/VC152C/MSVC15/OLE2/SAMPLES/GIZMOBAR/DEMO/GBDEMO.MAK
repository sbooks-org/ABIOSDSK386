# Microsoft Visual C++ generated build script - Do not modify

PROJ = GBDEMO
DEBUG = 1
PROGTYPE = 0
CALLER = 
ARGS = 
DLLS = 
D_RCDEFINES = -d_DEBUG
R_RCDEFINES = -dNDEBUG
ORIGIN = MSVC
ORIGIN_VER = 1.00
PROJPATH = UNKNOWN
USEMFC = 0
CC = cl
CPP = cl
CXX = cl
CCREATEPCHFLAG = 
CPPCREATEPCHFLAG = 
CUSEPCHFLAG = 
CPPUSEPCHFLAG = 
FIRSTC = GBDEMO.C    
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE = /nologo /G2 /Gy /W3 /Zi /YX"GBDEMO.H" /Od /D "_DEBUG" /FR /GA /GEf /Fd"GBDEMO.PDB"   /Fp"GBDEMO.PCH"
CFLAGS_R_WEXE = /nologo /G2 /Gy /W3 /YX"GBDEMO.H" /O1 /D "NDEBUG" /FR /GA /GEf /Fp"GBDEMO.PCH"
LFLAGS_D_WEXE = /NOLOGO /NOD /PACKC:61440 /STACK:10240 /ALIGN:16 /ONERROR:NOEXE /CO  
LFLAGS_R_WEXE = /NOLOGO /NOD /PACKC:61440 /STACK:10240 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw slibcew ..\gizmobar ..\..\lib\bttncur commdlg.lib 
LIBS_R_WEXE = oldnames libw slibcew ..\gizmobar ..\..\lib\bttncur commdlg.lib 
RCFLAGS = /nologo
RESFLAGS = /nologo
RUNFLAGS = 
DEFFILE = GBDEMO.DEF
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
SBRS = GBDEMO.SBR \
		INIT.SBR


all:	$(PROJ).EXE $(PROJ).BSC

GBDEMO.OBJ:	GBDEMO.C $(GBDEMO_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c GBDEMO.C

INIT.OBJ:	INIT.C $(INIT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c INIT.C

GBDEMO.RES:	GBDEMO.RC $(GBDEMO_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r GBDEMO.RC


$(PROJ).EXE::	GBDEMO.RES

$(PROJ).EXE::	GBDEMO.OBJ INIT.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
GBDEMO.OBJ +
INIT.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) GBDEMO.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	GBDEMO.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) GBDEMO.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
