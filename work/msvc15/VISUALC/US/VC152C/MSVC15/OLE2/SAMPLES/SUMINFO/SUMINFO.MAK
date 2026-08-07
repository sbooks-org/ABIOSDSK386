# Microsoft Visual C++ generated build script - Do not modify

PROJ = SUMINFO
DEBUG = 1
PROGTYPE = 3
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
FIRSTC =             
FIRSTCPP = TESTSUMI.CPP
RC = rc
CFLAGS_D_WTTY = /nologo /G2 /Gy /Mq /W3 /Zi /AM /Od /D "_DEBUG" /FR /Fd"SUMINFO.PDB"
CFLAGS_R_WTTY = /nologo /Gs /G2 /Gy /Mq /W3 /AM /Ox /D "NDEBUG" /FR 
LFLAGS_D_WTTY = /NOLOGO /NOD /PACKC:57344 /STACK:10240 /ALIGN:16 /ONERROR:NOEXE /CO 
LFLAGS_R_WTTY = /NOLOGO /NOD /PACKC:57344 /STACK:10240 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WTTY = ..\lib\moleuicd oldnames libw mlibcewq ole2 compobj storage 
LIBS_R_WTTY = ..\lib\moleuic oldnames libw mlibcewq ole2 compobj storage 
RCFLAGS = /nologo
RESFLAGS = /nologo
RUNFLAGS = 
DEFFILE = SUMINFO.DEF
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_WTTY)
LFLAGS = $(LFLAGS_D_WTTY)
LIBS = $(LIBS_D_WTTY)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
DEFFILE=SUMINFO.DEF
!else
CFLAGS = $(CFLAGS_R_WTTY)
LFLAGS = $(LFLAGS_R_WTTY)
LIBS = $(LIBS_R_WTTY)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
DEFFILE=SUMINFO.DEF
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = TESTSUMI.SBR


all:	$(PROJ).EXE $(PROJ).BSC

TESTSUMI.OBJ:	TESTSUMI.CPP $(TESTSUMI_DEP)
	$(CPP) $(CFLAGS) $(CPPCREATEPCHFLAG) /c TESTSUMI.CPP


$(PROJ).EXE::	TESTSUMI.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
TESTSUMI.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) $@


run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
