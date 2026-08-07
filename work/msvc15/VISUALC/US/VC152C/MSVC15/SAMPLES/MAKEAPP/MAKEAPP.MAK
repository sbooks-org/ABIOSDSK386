# Microsoft Visual C++ generated build script - Do not modify

PROJ = MAKEAPP
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
FIRSTC = APP.C       
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /G2 /Zp1 /W3 /AS /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /Zp1 /W3 /AS /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO  
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw commdlg.lib 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew libw commdlg.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  /t 
RUNFLAGS = 
DEFFILE = MAKEAPP.DEF
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
SBRS = APP.SBR \
		CLIENT.SBR \
		DLG.SBR \
		FRAME.SBR


APP_DEP = makeapp.h \
	app.h \
	frame.h \
	client.h \
	dlg.h


CLIENT_DEP = makeapp.h \
	app.h \
	frame.h \
	client.h \
	dlg.h


DLG_DEP = makeapp.h \
	app.h \
	frame.h \
	client.h \
	dlg.h


FRAME_DEP = makeapp.h \
	app.h \
	frame.h \
	client.h \
	dlg.h


MAKEAPP_RCDEP = makeapp.ico \
	makeapp.ver


all:	$(PROJ).EXE $(PROJ).BSC

APP.OBJ:	APP.C $(APP_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c APP.C

CLIENT.OBJ:	CLIENT.C $(CLIENT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c CLIENT.C

DLG.OBJ:	DLG.C $(DLG_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DLG.C

FRAME.OBJ:	FRAME.C $(FRAME_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c FRAME.C

MAKEAPP.RES:	MAKEAPP.RC $(MAKEAPP_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r MAKEAPP.RC


$(PROJ).EXE::	MAKEAPP.RES

$(PROJ).EXE::	APP.OBJ CLIENT.OBJ DLG.OBJ FRAME.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
APP.OBJ +
CLIENT.OBJ +
DLG.OBJ +
FRAME.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) MAKEAPP.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	MAKEAPP.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) MAKEAPP.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
