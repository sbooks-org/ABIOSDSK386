# Microsoft Visual C++ generated build script - Do not modify

PROJ = SHOWGDI
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
FIRSTC = DC.C        
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /W3 /FR /Zp /G2 /D "_DEBUG" /Od /AM /GA /D "_WINDOWS" /Zi
CFLAGS_R_WEXE =/nologo /YX /W3 /FR /Zp /G2 /D "NDEBUG" /Ox /AM /GA /D "_WINDOWS" /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:5120 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew commdlg.lib  libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew commdlg.lib  libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = SHOWGDI.DEF
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
SBRS = DC.SBR \
		DIALOGS.SBR \
		DIB.SBR \
		DRAW.SBR \
		MAIN.SBR \
		UTIL.SBR \
		VIEW.SBR


DC_DEP = util.h \
	main.h \
	view.h \
	dib.h \
	dialogs.h \
	dc.h


DIALOGS_DEP = util.h \
	main.h \
	view.h \
	dc.h \
	draw.h \
	dib.h \
	dialogs.h


DIB_DEP = util.h \
	dib.h


DRAW_DEP = util.h \
	main.h \
	dc.h \
	view.h \
	dib.h \
	dialogs.h \
	draw.h


MAIN_DEP = util.h \
	dialogs.h \
	view.h \
	dc.h \
	draw.h \
	dib.h \
	main.h


UTIL_DEP = util.h


VIEW_DEP = util.h \
	main.h \
	dialogs.h \
	dc.h \
	view.h


SHOWGDI_RCDEP = showgdi.ico


all:	$(PROJ).EXE $(PROJ).BSC

DC.OBJ:	DC.C $(DC_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c DC.C

DIALOGS.OBJ:	DIALOGS.C $(DIALOGS_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DIALOGS.C

DIB.OBJ:	DIB.C $(DIB_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DIB.C

DRAW.OBJ:	DRAW.C $(DRAW_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DRAW.C

MAIN.OBJ:	MAIN.C $(MAIN_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c MAIN.C

UTIL.OBJ:	UTIL.C $(UTIL_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c UTIL.C

VIEW.OBJ:	VIEW.C $(VIEW_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c VIEW.C

SHOWGDI.RES:	SHOWGDI.RC $(SHOWGDI_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r SHOWGDI.RC


$(PROJ).EXE::	SHOWGDI.RES

$(PROJ).EXE::	DC.OBJ DIALOGS.OBJ DIB.OBJ DRAW.OBJ MAIN.OBJ UTIL.OBJ VIEW.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
DC.OBJ +
DIALOGS.OBJ +
DIB.OBJ +
DRAW.OBJ +
MAIN.OBJ +
UTIL.OBJ +
VIEW.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) SHOWGDI.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	SHOWGDI.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) SHOWGDI.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
