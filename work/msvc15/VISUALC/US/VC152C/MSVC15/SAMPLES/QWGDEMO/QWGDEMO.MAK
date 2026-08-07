# Microsoft Visual C++ generated build script - Do not modify

PROJ = QWGDEMO
DEBUG = 1
PROGTYPE = 3
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
FIRSTCPP = QWGDEMO.CPP 
RC = rc
CFLAGS_D_WTTY =/nologo /YX /G2 /Mq /W3 /AM /Od /D "_DEBUG" /FR /Fd"QWGDEMO.PDB" /Zi
CFLAGS_R_WTTY =/nologo /YX /G2 /Mq /W3 /AM /Ox /D "NDEBUG" /FR /Fd"QWGDEMO.PDB" /Gs
LFLAGS_D_WTTY =/NOLOGO /NOD /PACKC:61440 /ALIGN:16 /ONERROR:NOEXE /PACKC:57344 /CO
LFLAGS_R_WTTY =/NOLOGO /NOD /PACKC:61440 /ALIGN:16 /ONERROR:NOEXE /PACKC:57344 
LIBS_D_WTTY = oldnames libw mlibcewq commdlg.lib olecli.lib olesvr.lib shell.lib 
LIBS_R_WTTY = oldnames libw mlibcewq commdlg.lib olecli.lib olesvr.lib shell.lib 
RCFLAGS =/NOLOGO
RESFLAGS =/NOLOGO
RUNFLAGS = 
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_WTTY)
LFLAGS = $(LFLAGS_D_WTTY)
LIBS = $(LIBS_D_WTTY)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
DEFFILE=C:\MSVC\BIN\CL.DEF
!else
CFLAGS = $(CFLAGS_R_WTTY)
LFLAGS = $(LFLAGS_R_WTTY)
LIBS = $(LIBS_R_WTTY)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
DEFFILE=C:\MSVC\BIN\CL.DEF
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = QWGDEMO.SBR


QWGDEMO_DEP = 

all:    $(PROJ).EXE $(PROJ).BSC

QWGDEMO.OBJ:    QWGDEMO.CPP $(QWGDEMO_DEP)
    $(CPP) $(CFLAGS) $(CPPCREATEPCHFLAG) /c QWGDEMO.CPP


$(PROJ).EXE::   QWGDEMO.OBJ $(OBJS_EXT) $(DEFFILE)
    echo >NUL @<<$(PROJ).CRF
QWGDEMO.OBJ +
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
