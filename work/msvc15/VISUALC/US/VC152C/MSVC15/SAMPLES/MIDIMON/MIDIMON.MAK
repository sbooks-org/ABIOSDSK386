# Microsoft Visual C++ generated build script - Do not modify

PROJ = MIDIMON
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
FIRSTC = ABOUT.C     
FIRSTCPP =             
RC = rc
CFLAGS_D_WEXE =/nologo /YX /Zp1 /Od /D "_DEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /Zp1 /Ox /D "NDEBUG" /D "_WINDOWS" /G2 /W3 /AS /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:5000 /ALIGN:16 /ONERROR:NOEXE /CO
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:5000 /ALIGN:16 /ONERROR:NOEXE 
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib  libw
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr slibcew mmsystem.lib  libw
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = MIDIMON.DEF
OBJS_EXT = 
LIBS_EXT = CALLBACK.LIB 
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
SBRS = ABOUT.SBR \
		CIRCBUF.SBR \
		DISPLAY.SBR \
		FILTER.SBR \
		INSTDATA.SBR \
		MIDIMON.SBR \
		PREFER.SBR


CALLBACK_DEP = 

ABOUT_DEP = about.h


CIRCBUF_DEP = midimon.h \
	circbuf.h


DISPLAY_DEP = midimon.h \
	circbuf.h \
	display.h


FILTER_DEP = midimon.h \
	display.h \
	filter.h


INSTDATA_DEP = midimon.h \
	circbuf.h \
	instdata.h


MIDIMON_DEP = midimon.h \
	about.h \
	circbuf.h \
	display.h \
	prefer.h \
	instdata.h \
	callback.h \
	filter.h


PREFER_DEP = midimon.h \
	prefer.h


all:	$(PROJ).EXE $(PROJ).BSC

ABOUT.OBJ:	ABOUT.C $(ABOUT_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c ABOUT.C

CIRCBUF.OBJ:	CIRCBUF.C $(CIRCBUF_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c CIRCBUF.C

DISPLAY.OBJ:	DISPLAY.C $(DISPLAY_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DISPLAY.C

FILTER.OBJ:	FILTER.C $(FILTER_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c FILTER.C

INSTDATA.OBJ:	INSTDATA.C $(INSTDATA_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c INSTDATA.C

MIDIMON.OBJ:	MIDIMON.C $(MIDIMON_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c MIDIMON.C

PREFER.OBJ:	PREFER.C $(PREFER_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c PREFER.C

MIDIMON.RES:	MIDIMON.RC $(MIDIMON_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r MIDIMON.RC


$(PROJ).EXE::	MIDIMON.RES

$(PROJ).EXE::	ABOUT.OBJ CIRCBUF.OBJ DISPLAY.OBJ FILTER.OBJ INSTDATA.OBJ MIDIMON.OBJ \
	PREFER.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
ABOUT.OBJ +
CIRCBUF.OBJ +
DISPLAY.OBJ +
FILTER.OBJ +
INSTDATA.OBJ +
MIDIMON.OBJ +
PREFER.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
CALLBACK.LIB+
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) MIDIMON.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	MIDIMON.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) MIDIMON.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
