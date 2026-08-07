# Microsoft Visual C++ generated build script - Do not modify

PROJ = CLIDEMO
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
FIRSTC = CLIDEMO.C   
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /Od /G2 /Zp1 /W3 /AS /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /Ox /G2 /Zp1 /W3 /AS /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:32000 /ALIGN:16 /ONERROR:NOEXE /CO  
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:32000 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw commdlg.lib olecli.lib shell.lib 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw commdlg.lib olecli.lib shell.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = CLIDEMO.DEF
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
SBRS = CLIDEMO.SBR \
		DIALOG.SBR \
		OBJECT.SBR \
		REGISTER.SBR \
		STREAM.SBR \
		UTILITY.SBR


CLIDEMO_DEP = global.h \
	register.h \
	clidemo.h \
	stream.h \
	object.h \
	dialog.h \
	utility.h


DIALOG_DEP = global.h \
	register.h \
	utility.h \
	dialog.h \
	object.h


OBJECT_DEP = global.h \
	register.h \
	stream.h \
	object.h \
	clidemo.h \
	utility.h \
	dialog.h


REGISTER_DEP = global.h \
	register.h \
	clidemo.h


STREAM_DEP = global.h \
	utility.h \
	stream.h \
	object.h


UTILITY_DEP = global.h \
	utility.h \
	object.h \
	dialog.h


CLIDEMO_RCDEP = cliver.rcv \
	clidemo.ico


all:	$(PROJ).EXE $(PROJ).BSC

CLIDEMO.OBJ:	CLIDEMO.C $(CLIDEMO_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c CLIDEMO.C

DIALOG.OBJ:	DIALOG.C $(DIALOG_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DIALOG.C

OBJECT.OBJ:	OBJECT.C $(OBJECT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c OBJECT.C

REGISTER.OBJ:	REGISTER.C $(REGISTER_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c REGISTER.C

STREAM.OBJ:	STREAM.C $(STREAM_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c STREAM.C

UTILITY.OBJ:	UTILITY.C $(UTILITY_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c UTILITY.C

CLIDEMO.RES:	CLIDEMO.RC $(CLIDEMO_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r CLIDEMO.RC


$(PROJ).EXE::	CLIDEMO.RES

$(PROJ).EXE::	CLIDEMO.OBJ DIALOG.OBJ OBJECT.OBJ REGISTER.OBJ STREAM.OBJ UTILITY.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
CLIDEMO.OBJ +
DIALOG.OBJ +
OBJECT.OBJ +
REGISTER.OBJ +
STREAM.OBJ +
UTILITY.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) CLIDEMO.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	CLIDEMO.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) CLIDEMO.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
