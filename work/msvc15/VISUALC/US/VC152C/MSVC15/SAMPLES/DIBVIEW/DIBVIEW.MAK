# Microsoft Visual C++ generated build script - Do not modify

PROJ = DIBVIEW
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
CFLAGS_D_WEXE =/nologo /YX /G2 /W3 /AM /Od /D "_DEBUG" /FR /GA /Zi
CFLAGS_R_WEXE =/nologo /YX /G2 /W3 /AM /Ox /D "NDEBUG" /FR /GA /Gs
LFLAGS_D_WEXE =/NOLOGO /NOD /STACK:15000 /ALIGN:16 /ONERROR:NOEXE /CO /MAP /LINE  
LFLAGS_R_WEXE =/NOLOGO /NOD /STACK:15000 /ALIGN:16 /ONERROR:NOEXE  
LIBS_D_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew LIBW MLIBCEW commdlg.lib 
LIBS_R_WEXE = oldnames libw commdlg shell olecli olesvr mlibcew LIBW MLIBCEW commdlg.lib 
RCFLAGS =/NOLOGO  
RESFLAGS =/NOLOGO  -t
RUNFLAGS = 
DEFFILE = DIBVIEW.DEF
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
SBRS = ABOUT.SBR \
		CAPTURE.SBR \
		CHILD.SBR \
		CLIPBRD.SBR \
		DIB.SBR \
		DIBVIEW.SBR \
		ERRORS.SBR \
		FILE.SBR \
		FRAME.SBR \
		INIT.SBR \
		OPTIONS.SBR \
		PAINT.SBR \
		PALETTE.SBR \
		PRINT.SBR


ABOUT_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


CAPTURE_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


CHILD_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


CLIPBRD_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


DIB_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


DIBVIEW_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


ERRORS_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


FILE_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


FRAME_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


INIT_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


OPTIONS_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


PAINT_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


PALETTE_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


PRINT_DEP = master.h \
	about.h \
	capture.h \
	child.h \
	options.h \
	clipbrd.h \
	dib.h \
	dibview.h \
	errors.h \
	file.h \
	frame.h \
	init.h \
	paint.h \
	palette.h


DIBVIEW_RCDEP = dibview.h \
	file.h \
	palette.h \
	options.h \
	dibview.ico \
	select.cur \
	dibdrag.cur


all:	$(PROJ).EXE $(PROJ).BSC

ABOUT.OBJ:	ABOUT.C $(ABOUT_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c ABOUT.C

CAPTURE.OBJ:	CAPTURE.C $(CAPTURE_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c CAPTURE.C

CHILD.OBJ:	CHILD.C $(CHILD_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c CHILD.C

CLIPBRD.OBJ:	CLIPBRD.C $(CLIPBRD_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c CLIPBRD.C

DIB.OBJ:	DIB.C $(DIB_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DIB.C

DIBVIEW.OBJ:	DIBVIEW.C $(DIBVIEW_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c DIBVIEW.C

ERRORS.OBJ:	ERRORS.C $(ERRORS_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c ERRORS.C

FILE.OBJ:	FILE.C $(FILE_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c FILE.C

FRAME.OBJ:	FRAME.C $(FRAME_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c FRAME.C

INIT.OBJ:	INIT.C $(INIT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c INIT.C

OPTIONS.OBJ:	OPTIONS.C $(OPTIONS_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c OPTIONS.C

PAINT.OBJ:	PAINT.C $(PAINT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c PAINT.C

PALETTE.OBJ:	PALETTE.C $(PALETTE_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c PALETTE.C

PRINT.OBJ:	PRINT.C $(PRINT_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c PRINT.C

DIBVIEW.RES:	DIBVIEW.RC $(DIBVIEW_RCDEP)
	$(RC) $(RCFLAGS) $(RCDEFINES) -r DIBVIEW.RC


$(PROJ).EXE::	DIBVIEW.RES

$(PROJ).EXE::	ABOUT.OBJ CAPTURE.OBJ CHILD.OBJ CLIPBRD.OBJ DIB.OBJ DIBVIEW.OBJ ERRORS.OBJ \
	FILE.OBJ FRAME.OBJ INIT.OBJ OPTIONS.OBJ PAINT.OBJ PALETTE.OBJ PRINT.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
ABOUT.OBJ +
CAPTURE.OBJ +
CHILD.OBJ +
CLIPBRD.OBJ +
DIB.OBJ +
DIBVIEW.OBJ +
ERRORS.OBJ +
FILE.OBJ +
FRAME.OBJ +
INIT.OBJ +
OPTIONS.OBJ +
PAINT.OBJ +
PALETTE.OBJ +
PRINT.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) DIBVIEW.RES $@
	@copy $(PROJ).CRF MSVC.BND

$(PROJ).EXE::	DIBVIEW.RES
	if not exist MSVC.BND 	$(RC) $(RESFLAGS) DIBVIEW.RES $@

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
